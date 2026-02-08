# Poodle Docs Webhook Service

PR Preview 배포를 위한 간단한 webhook 서비스입니다.

## 설치

### 서버에 직접 설치 (Node.js 방식)

```bash
# 서버에 파일 복사
scp -r webhook-service hwigeon@dreampaste.com:/opt/poodle-docs/

# 서버 접속
ssh dreampaste

# 디렉토리 이동
cd /opt/poodle-docs/webhook-service

# 의존성 설치
npm install

# PM2로 서비스 실행
npm install -g pm2
pm2 start server.js --name poodle-webhook
pm2 save
pm2 startup
```

### Docker 방식 (권장)

```bash
# 이미지 빌드
docker build -t poodle-webhook .

# 컨테이너 실행
docker run -d \
  --name poodle-webhook \
  --restart unless-stopped \
  -p 9000:9000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e WEBHOOK_SECRET=poodle-docs-secret-2026 \
  poodle-webhook
```

## API

### Health Check

```bash
GET /health
```

### PR Preview 배포

```bash
POST /webhook/pr-preview
Content-Type: application/json

{
  "secret": "poodle-docs-secret-2026",
  "action": "deploy",
  "pr_number": "7",
  "image_tag": "pr-7"
}
```

### PR Preview 정리

```bash
POST /webhook/pr-preview
Content-Type: application/json

{
  "secret": "poodle-docs-secret-2026",
  "action": "cleanup",
  "pr_number": "7"
}
```

## GitHub Actions에서 사용

```yaml
- name: Call webhook
  run: |
    curl -X POST https://dreampaste.com:9000/webhook/pr-preview \
      -H "Content-Type: application/json" \
      -d '{
        "secret": "${{ secrets.WEBHOOK_SECRET }}",
        "action": "deploy",
        "pr_number": "${{ github.event.pull_request.number }}",
        "image_tag": "pr-${{ github.event.pull_request.number }}"
      }'
```

## 환경 변수

- `PORT`: 서비스 포트 (기본: 9000)
- `WEBHOOK_SECRET`: Webhook 인증 시크릿

## 보안

- Webhook secret으로 인증
- 내부 네트워크에서만 접근 가능하도록 방화벽 설정 권장
- 또는 Caddy reverse proxy를 통해 HTTPS로 노출
