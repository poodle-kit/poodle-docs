#!/usr/bin/env node
import express from 'express';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);
const app = express();
const PORT = process.env.PORT || 9000;
const WEBHOOK_SECRET = process.env.WEBHOOK_SECRET || 'poodle-docs-secret-2026';

app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'poodle-docs-webhook' });
});

// PR Preview 배포 webhook
app.post('/webhook/pr-preview', async (req, res) => {
  try {
    const { secret, action, pr_number, image_tag } = req.body;

    // 시크릿 검증
    if (secret !== WEBHOOK_SECRET) {
      return res.status(401).json({ error: 'Invalid secret' });
    }

    console.log(`[${new Date().toISOString()}] Received webhook:`, { action, pr_number });

    if (action === 'deploy') {
      await deployPRPreview(pr_number, image_tag);
      res.json({
        success: true,
        message: `PR #${pr_number} deployed successfully`,
        url: `https://pr-${pr_number}.poodle-kit.my`
      });
    } else if (action === 'cleanup') {
      await cleanupPRPreview(pr_number);
      res.json({
        success: true,
        message: `PR #${pr_number} cleaned up successfully`
      });
    } else {
      res.status(400).json({ error: 'Invalid action' });
    }
  } catch (error) {
    console.error('Webhook error:', error);
    res.status(500).json({
      error: 'Deployment failed',
      message: error.message
    });
  }
});

async function deployPRPreview(prNumber, imageTag) {
  const containerName = `poodle-docs-pr-${prNumber}`;
  const port = 3000 + parseInt(prNumber);
  const image = `ghcr.io/poodle-kit/poodle-docs:${imageTag}`;

  console.log(`Deploying PR #${prNumber}...`);
  console.log(`  Container: ${containerName}`);
  console.log(`  Port: ${port}`);
  console.log(`  Image: ${image}`);

  // 기존 컨테이너 중지 및 제거
  try {
    await execAsync(`docker stop ${containerName}`);
    await execAsync(`docker rm ${containerName}`);
  } catch (e) {
    // 컨테이너가 없으면 무시
  }

  // 이미지 pull
  await execAsync(`docker pull ${image}`);

  // 새 컨테이너 실행
  const runCmd = `docker run -d \
    --name ${containerName} \
    --restart unless-stopped \
    --label com.centurylinklabs.watchtower.enable=false \
    -p ${port}:3000 \
    -e NODE_ENV=production \
    -e PR_NUMBER=${prNumber} \
    ${image}`;

  await execAsync(runCmd);

  // Caddy 설정 업데이트
  await execAsync(`/usr/local/bin/deploy-poodle-pr.sh ${prNumber} ${port}`);

  console.log(`✅ PR #${prNumber} deployed successfully`);
}

async function cleanupPRPreview(prNumber) {
  const containerName = `poodle-docs-pr-${prNumber}`;

  console.log(`Cleaning up PR #${prNumber}...`);

  // 컨테이너 중지 및 제거
  try {
    await execAsync(`docker stop ${containerName}`);
    await execAsync(`docker rm ${containerName}`);
  } catch (e) {
    console.log(`Container ${containerName} not found, skipping...`);
  }

  // Caddy 설정 제거
  await execAsync(`/usr/local/bin/cleanup-poodle-pr.sh ${prNumber}`);

  // 이미지 정리 (선택사항)
  try {
    await execAsync(`docker rmi ghcr.io/poodle-kit/poodle-docs:pr-${prNumber}`);
  } catch (e) {
    // 이미지가 없으면 무시
  }

  console.log(`✅ PR #${prNumber} cleaned up successfully`);
}

app.listen(PORT, () => {
  console.log(`🐩 Poodle Docs Webhook Service running on port ${PORT}`);
  console.log(`📡 Webhook endpoint: http://localhost:${PORT}/webhook/pr-preview`);
  console.log(`🔐 Secret: ${WEBHOOK_SECRET.substring(0, 10)}...`);
});
