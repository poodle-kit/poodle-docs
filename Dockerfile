# =============================================================================
# Poodle Docs - Dockerfile
# =============================================================================
# Next.js 16 + Nextra 4 기반 문서 사이트를 위한 멀티스테이지 Docker 빌드
# 최적화된 프로덕션 이미지 생성 (~150MB)

# -----------------------------------------------------------------------------
# Stage 1: Dependencies
# -----------------------------------------------------------------------------
FROM node:20-alpine AS deps

# 기본 라이브러리 설치 (일부 npm 패키지가 필요로 함)
RUN apk add --no-cache libc6-compat

# pnpm 활성화 (Node.js 20에 내장)
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# 종속성 파일만 먼저 복사 (Docker 레이어 캐싱 최적화)
COPY package.json pnpm-lock.yaml ./

# 종속성 설치 (프로덕션 + 개발 종속성 모두 - 빌드에 필요)
RUN pnpm install --frozen-lockfile --production=false

# -----------------------------------------------------------------------------
# Stage 2: Builder
# -----------------------------------------------------------------------------
FROM node:20-alpine AS builder

# pnpm 활성화
RUN corepack enable && corepack prepare pnpm@latest --activate

WORKDIR /app

# deps 스테이지에서 node_modules 복사
COPY --from=deps /app/node_modules ./node_modules

# 소스 코드 복사
COPY . .

# Next.js 텔레메트리 비활성화
ENV NEXT_TELEMETRY_DISABLED=1

# Next.js 빌드 실행 (Standalone 모드)
RUN pnpm build

# -----------------------------------------------------------------------------
# Stage 3: Runner (프로덕션)
# -----------------------------------------------------------------------------
FROM node:20-alpine AS runner

WORKDIR /app

ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1

# 보안을 위한 non-root 사용자 생성
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs

# 필요한 파일만 선택적으로 복사
COPY --from=builder /app/public ./public

# Standalone 출력 복사 (Next.js가 자동으로 필요한 파일만 번들링)
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

# nextjs 사용자로 전환
USER nextjs

# 포트 노출
EXPOSE 3000

# 환경 변수 설정
ENV PORT=3000
ENV HOSTNAME="0.0.0.0"

# 서버 시작
CMD ["node", "server.js"]
