#!/bin/bash
# =============================================================================
# Poodle Docs - PR Preview 배포 스크립트
# =============================================================================
# 사용법: deploy-poodle-pr.sh <PR_NUMBER> <PORT>
# 예시: deploy-poodle-pr.sh 42 3042

set -e

PR_NUMBER=$1
PORT=$2

if [ -z "$PR_NUMBER" ] || [ -z "$PORT" ]; then
    echo "Usage: $0 <PR_NUMBER> <PORT>"
    echo "Example: $0 42 3042"
    exit 1
fi

CADDY_FILE="/etc/caddy/pr-previews/pr-${PR_NUMBER}.caddy"

echo "🐩 Deploying PR #${PR_NUMBER} preview..."
echo "   Port: ${PORT}"
echo "   Domain: pr-${PR_NUMBER}.poodle-kit.my"

# PR preview Caddy 설정 생성
cat > "$CADDY_FILE" << EOF
pr-${PR_NUMBER}.poodle-kit.my {
    reverse_proxy localhost:${PORT}
    encode gzip

    header {
        X-Frame-Options "SAMEORIGIN"
        X-Content-Type-Options "nosniff"
    }

    log {
        output file /var/log/caddy/poodle-pr-${PR_NUMBER}.log
    }
}
EOF

echo "✅ Created Caddy config: $CADDY_FILE"

# Caddy 리로드
if docker exec soso-proxy caddy reload --config /etc/caddy/Caddyfile 2>&1; then
    echo "✅ Caddy reloaded successfully"
    echo ""
    echo "🎉 PR Preview deployed!"
    echo "   URL: https://pr-${PR_NUMBER}.poodle-kit.my"
else
    echo "❌ Failed to reload Caddy"
    exit 1
fi
