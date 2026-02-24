#!/bin/bash
# =============================================================================
# Poodle Docs - Caddy Import 설정 스크립트
# =============================================================================
# Caddyfile에 poodle-docs import 추가

set -e

CADDYFILE="/etc/caddy/Caddyfile"
IMPORT_LINE="import /etc/caddy/poodle-docs.caddy"
PR_IMPORT_LINE="import /etc/caddy/pr-previews/*.caddy"

echo "🐩 Setting up Caddy imports..."

# 백업 생성
if [ -f "$CADDYFILE" ]; then
    cp "$CADDYFILE" "${CADDYFILE}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backup created"
fi

# import가 이미 있는지 확인
if grep -q "$IMPORT_LINE" "$CADDYFILE"; then
    echo "ℹ️  poodle-docs.caddy import already exists"
else
    echo "" >> "$CADDYFILE"
    echo "# Poodle Docs" >> "$CADDYFILE"
    echo "$IMPORT_LINE" >> "$CADDYFILE"
    echo "✅ Added poodle-docs.caddy import"
fi

if grep -q "$PR_IMPORT_LINE" "$CADDYFILE"; then
    echo "ℹ️  PR previews import already exists"
else
    echo "$PR_IMPORT_LINE" >> "$CADDYFILE"
    echo "✅ Added PR previews import"
fi

# Caddy 설정 검증
echo ""
echo "Validating Caddy configuration..."
if docker exec soso-proxy caddy validate --config /etc/caddy/Caddyfile 2>&1; then
    echo "✅ Caddy configuration is valid"
else
    echo "❌ Caddy configuration is invalid"
    exit 1
fi

# Caddy 리로드
echo ""
echo "Reloading Caddy..."
if docker exec soso-proxy caddy reload --config /etc/caddy/Caddyfile 2>&1; then
    echo "✅ Caddy reloaded successfully"
    echo ""
    echo "🎉 Caddy import setup complete!"
else
    echo "❌ Failed to reload Caddy"
    exit 1
fi
