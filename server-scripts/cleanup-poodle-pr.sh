#!/bin/bash
# =============================================================================
# Poodle Docs - PR Preview 정리 스크립트
# =============================================================================
# 사용법: cleanup-poodle-pr.sh <PR_NUMBER>
# 예시: cleanup-poodle-pr.sh 42

set -e

PR_NUMBER=$1

if [ -z "$PR_NUMBER" ]; then
    echo "Usage: $0 <PR_NUMBER>"
    echo "Example: $0 42"
    exit 1
fi

CADDY_FILE="/etc/caddy/pr-previews/pr-${PR_NUMBER}.caddy"
LOG_FILE="/var/log/caddy/poodle-pr-${PR_NUMBER}.log"

echo "🧹 Cleaning up PR #${PR_NUMBER} preview..."

# Caddy 설정 파일 삭제
if [ -f "$CADDY_FILE" ]; then
    rm "$CADDY_FILE"
    echo "✅ Removed Caddy config: $CADDY_FILE"
else
    echo "ℹ️  Caddy config not found: $CADDY_FILE"
fi

# 로그 파일 삭제 (선택사항)
if [ -f "$LOG_FILE" ]; then
    rm "$LOG_FILE"
    echo "✅ Removed log file: $LOG_FILE"
fi

# Caddy 리로드
if docker exec soso-proxy caddy reload --config /etc/caddy/Caddyfile 2>&1; then
    echo "✅ Caddy reloaded successfully"
    echo ""
    echo "🎉 PR Preview cleaned up!"
else
    echo "❌ Failed to reload Caddy"
    exit 1
fi
