# sb-setup — 초기 설치

처음 실행 시 필요한 도구를 자동으로 설치합니다.

---

## 실행 지시사항

#### 초기 설치 모드

아래 단계를 순서대로 직접 실행한다. 설명만 하지 말고 반드시 실행할 것.

**1단계 — Node.js 설치 확인 및 설치:**
```bash
node --version
```
명령어가 없으면 winget으로 자동 설치:
```bash
winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
```
설치 완료 후 `node --version`으로 확인.

**2단계 — bkit 플러그인 설치:**
```
/plugin marketplace add popup-studio-ai/bkit-claude-code
/plugin install bkit
```

**3단계 — Vercel 스킬 설치:**
```bash
npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -y
```

**4단계 — 헌법 파일 확인:**
```bash
ls constitution.md
```
`constitution.md`가 있으면 정상입니다.
없으면 → sb-flow setup을 다시 실행하거나 sb-flow의 `constitution.md`를 프로젝트 루트에 복사해주세요.

모든 단계 완료 후 아래 메시지를 출력하고 **Step 1~3은 건너뛴다**:
```
✅ 초기 설치 완료!
→ /sb-oneshot [만들고 싶은 기능 설명] 으로 개발을 시작하세요.
```

---