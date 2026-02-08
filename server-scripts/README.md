# Poodle Docs 서버 스크립트

이 디렉토리에는 poodle-docs 배포를 위한 서버 측 스크립트들이 포함되어 있습니다.

## 📋 파일 목록

| 파일 | 설명 |
|------|------|
| `setup-caddy-import.sh` | Caddyfile에 poodle-docs import 추가 (최초 1회 실행) |
| `deploy-poodle-pr.sh` | PR Preview 배포 스크립트 (GitHub Actions에서 사용) |
| `deploy-poodle-dev.sh` | Dev 환경 Caddy 리로드 (GitHub Actions에서 사용) |
| `cleanup-poodle-pr.sh` | PR Preview 정리 스크립트 (GitHub Actions에서 사용) |

## 🚀 서버 설치 방법

### 1. 스크립트 파일들을 서버로 복사

```bash
# 로컬에서 실행
scp server-scripts/*.sh hwigeon@dreampaste.com:/tmp/
```

### 2. 서버에 스크립트 설치

```bash
# 서버에 SSH 접속
ssh dreampaste

# 스크립트를 /usr/local/bin으로 이동
sudo mv /tmp/deploy-poodle-pr.sh /usr/local/bin/
sudo mv /tmp/cleanup-poodle-pr.sh /usr/local/bin/
sudo mv /tmp/deploy-poodle-dev.sh /usr/local/bin/
sudo mv /tmp/setup-caddy-import.sh /usr/local/bin/

# 실행 권한 부여
sudo chmod +x /usr/local/bin/deploy-poodle-pr.sh
sudo chmod +x /usr/local/bin/cleanup-poodle-pr.sh
sudo chmod +x /usr/local/bin/deploy-poodle-dev.sh
sudo chmod +x /usr/local/bin/setup-caddy-import.sh
```

### 3. Caddy import 설정 (최초 1회만)

```bash
# poodle-docs.caddy가 이미 /etc/caddy/에 있는지 확인
ls -la /etc/caddy/poodle-docs.caddy

# Caddyfile에 import 추가
sudo /usr/local/bin/setup-caddy-import.sh
```

### 4. sudo 권한 설정

GitHub Actions에서 스크립트를 실행할 수 있도록 sudo 권한을 부여합니다:

```bash
# sudoers 파일 생성
sudo tee /etc/sudoers.d/github-deploy > /dev/null << 'EOF'
# GitHub Actions deployment permissions
hwigeon ALL=(ALL) NOPASSWD: /usr/local/bin/deploy-poodle-pr.sh
hwigeon ALL=(ALL) NOPASSWD: /usr/local/bin/cleanup-poodle-pr.sh
hwigeon ALL=(ALL) NOPASSWD: /usr/local/bin/deploy-poodle-dev.sh
EOF

# 권한 설정
sudo chmod 0440 /etc/sudoers.d/github-deploy

# 검증
sudo visudo -c
```

## 🧪 테스트

### PR Preview 배포 테스트

```bash
# 컨테이너가 3042 포트에서 실행 중이라고 가정
sudo /usr/local/bin/deploy-poodle-pr.sh 42 3042

# 브라우저에서 확인
# https://pr-42.poodle-kit.my
```

### PR Preview 정리 테스트

```bash
sudo /usr/local/bin/cleanup-poodle-pr.sh 42
```

### Dev 환경 테스트

```bash
# dev 컨테이너가 3099 포트에서 실행 중이라고 가정
sudo /usr/local/bin/deploy-poodle-dev.sh 3099

# 브라우저에서 확인
# https://dev.poodle-kit.my
```

## 📝 참고사항

- 모든 스크립트는 `soso-proxy` Caddy 컨테이너를 사용합니다
- Caddy 설정 파일은 `/etc/caddy/` 디렉토리에 저장됩니다
- PR Preview 설정은 `/etc/caddy/pr-previews/` 디렉토리에 저장됩니다
- 로그는 `/var/log/caddy/` 디렉토리에 저장됩니다

## 🔧 문제 해결

### Caddy 리로드 실패

```bash
# Caddy 설정 검증
docker exec soso-proxy caddy validate --config /etc/caddy/Caddyfile

# Caddy 로그 확인
docker logs soso-proxy --tail 50

# Caddy 재시작 (최후의 수단)
docker restart soso-proxy
```

### 설정 파일 확인

```bash
# 메인 설정
cat /etc/caddy/poodle-docs.caddy

# PR Preview 설정들
ls -la /etc/caddy/pr-previews/

# Caddyfile import 확인
grep -A 2 "Poodle Docs" /etc/caddy/Caddyfile
```
