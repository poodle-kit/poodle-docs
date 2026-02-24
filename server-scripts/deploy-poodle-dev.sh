#!/bin/bash
# =============================================================================
# Poodle Docs - Dev 환경 Caddy 설정 스크립트
# =============================================================================
# 사용법: deploy-poodle-dev.sh <PORT>
# 예시: deploy-poodle-dev.sh 3099

set -e

PORT=$1

if [ -z "$PORT" ]; then
    echo "Usage: $0 <PORT>"
    echo "Example: $0 3099"
    exit 1
fi

echo "🐩 Configuring dev environment..."
echo "   Port: ${PORT}"
echo "   Domain: dev.poodle-kit.my"

# dev 환경은 이미 poodle-docs.caddy에 포함되어 있으므로
# 포트만 확인하고 Caddy 리로드
if docker exec soso-proxy caddy reload --config /etc/caddy/Caddyfile 2>&1; then
    echo "✅ Caddy reloaded successfully"
    echo ""
    echo "🎉 Dev environment ready!"
    echo "   URL: https://dev.poodle-kit.my"
else
    echo "❌ Failed to reload Caddy"
    exit 1
fi
