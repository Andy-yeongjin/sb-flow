# sb-flow 시작 가이드

sb-flow를 처음 사용하는 분을 위한 단계별 설명입니다.

---

## 0단계. 사전 준비 — Claude Code 설치

> 이미 Claude Code가 설치되어 있다면 [1단계](#1단계-새-프로젝트-폴더-만들기)로 건너뛰세요.

### 0-1. Node.js 설치 (v18 이상)

Claude Code는 Node.js 위에서 실행됩니다. 먼저 Node.js를 설치합니다.

1. [https://nodejs.org](https://nodejs.org) 접속 → **LTS 버전** 다운로드 후 설치
2. 설치 완료 후 PowerShell을 열고 확인:

```powershell
node -v   # v18.x.x 이상이면 정상
npm -v    # 같이 출력되면 정상
```

### 0-2. Claude Code 설치

```powershell
npm install -g @anthropic-ai/claude-code
```

설치 확인:

```powershell
claude --version
```

> ⚠️ `'claude'은(는) 인식되지 않는 명령어입니다` 오류가 나면 PowerShell을 완전히 닫고 다시 열어서 재시도하세요.

### 0-3. Claude Code 로그인

```powershell
claude
```

첫 실행 시 브라우저가 열리며 **Claude.ai 계정 연결** 화면이 나타납니다.

| 방법 | 대상 | 비고 |
|------|------|------|
| Claude.ai 계정 연결 | Pro / Max 구독자 | 추천 — 별도 API 키 불필요 |
| API 키 입력 | API 이용자 | `ANTHROPIC_API_KEY` 환경변수 또는 직접 입력 |

로그인 후 `>` 프롬프트가 뜨면 성공입니다. `exit`로 나옵니다.

> 💡 Claude Code 사용법이 더 궁금하다면 Claude Code 대화창에서 `/claude-code-learning`을 실행하세요.

---

## 새 프로젝트 시작하기

> **모든 설치 과정은 Claude Code 안에서 실행합니다.**
> PowerShell 환경 차이로 인한 오류를 방지하기 위해, Claude Code 대화창에서 명령어를 입력하는 방식으로 통일합니다.

### 1단계. 새 프로젝트 폴더 만들기

파일 탐색기에서 빈 폴더를 만듭니다.

```
예: C:\projects\my-app
```

### 2단계. 만든 폴더에서 Claude Code 실행

터미널(PowerShell, Terminal 등)에서 프로젝트 폴더로 이동 후 Claude Code를 실행합니다:

```powershell
cd C:\projects\my-app
claude --dangerously-skip-permissions
```

### 3단계. Claude Code 안에서 설치 스크립트 실행

Claude Code 대화창에 아래를 입력합니다:

**Windows**
```
C:\sb-flow\install.ps1 확인하고 수동으로 직접 실행해줘
```

**macOS / Linux**
```
~/sb-flow/install.sh 확인하고 수동으로 직접 실행해줘
```

> `C:\sb-flow`는 실제 sb-flow 클론 경로로 바꿔주세요.

스크립트가 아래 순서로 진행됩니다:

| 단계 | 작업 | 방식 |
|------|------|------|
| [1/8] | uv 설치 확인 (없으면 자동 설치) | 자동 |
| [2/8] | spec-kit 초기화 (`specify init`) | **안내에 따라 진행** |
| [3/8] | Vercel React Best Practices 스킬 설치 | 자동 |
| [4/8] | CLAUDE.md + 커스텀 명령어 복사 | 자동 |
| [5/8] | 개발 헌법 복사 (sb-flow 헌법으로 교체) | 자동 |
| [6/8] | SDD 학습 문서 복사 | 자동 |
| [7/8] | SPEC_CONTEXT.md 템플릿 복사 | 자동 |
| [8/8] | 디자인 시스템 복사 (design.md + design-tokens.css) | 자동 |

### 4단계. bkit 플러그인 설치

Claude Code 대화창에서:

```
/plugin marketplace add popup-studio-ai/bkit-claude-code
/plugin install bkit
```

### 5단계. Claude Code 재시작

`Ctrl+C`로 Claude Code를 종료한 뒤 다시 실행합니다:

```
claude --dangerously-skip-permissions
```

> 재시작하지 않으면 새로 설치한 명령어(`/sb-oneshot` 등)가 표시되지 않습니다.

### 6단계. 개발 시작

```
/sb-oneshot 만들고 싶은 기능 설명
```

**예시**:
```
/sb-oneshot 사용자가 이메일과 비밀번호로 가입하고 로그인할 수 있는 인증 기능
```

이 명령어 하나로 설계(SpecKit) → 브릿지 문서 → 구현(`/pdca do`)까지 자동으로 완주합니다.

> **참고**: `/sb-oneshot`은 내부적으로 `@vercel-react-best-practices` 가이드라인을 적용합니다.

---

## 기존 프로젝트로 돌아올 때

프로젝트 폴더에서 Claude Code를 열고 입력:

```
/sb-setup
```

현재 진행 상태를 복원하고 오늘 할 작업을 안내해줍니다.

---

## 명령어 요약

| 상황 | 명령어 |
|------|--------|
| 새 기능을 한방에 설계+구현하고 싶을 때 | `/sb-oneshot [기능 설명]` |
| 어디서부터 해야 할지 모를 때 | `/sb-guide` |
| 어제 하던 작업 재개할 때 | `/sb-setup` |
| 설계 완료 후 브릿지 문서만 만들 때 | `/sb-bridge specs/001-기능명` |

---

## 자주 묻는 질문

**Q. Node.js를 설치했는데 `node` 명령어를 찾을 수 없다고 나와요**
설치 후 PowerShell을 완전히 닫고 새로 열어야 PATH가 적용됩니다.
그래도 안 되면 Node.js를 다시 설치하면서 "Add to PATH" 옵션이 체크되어 있는지 확인하세요.

**Q. `npm install -g @anthropic-ai/claude-code` 설치가 너무 오래 걸려요**
네트워크 환경에 따라 1~3분 걸릴 수 있습니다. 그대로 기다려주세요.

**Q. Claude Code 로그인 시 브라우저가 안 열려요**
터미널에 출력된 URL을 복사해 브라우저에 직접 붙여넣기 하세요.

**Q. "UnicodeEncodeError" 오류가 나요**
Claude Code 안에서 설치 스크립트를 실행하면 이 문제가 발생하지 않습니다.
만약 터미널에서 직접 실행 중이라면 Claude Code 대화창에서 다시 시도해주세요.

**Q. uv 설치 후 "uvx를 찾을 수 없다"는 오류가 나요**
Claude Code를 완전히 종료(`exit`) 후 다시 실행하면 PATH가 적용됩니다.

**Q. specify init 단계에서 "Directory already exists" 오류가 나요**
`--here --force` 옵션이 이를 해결합니다. 스크립트가 안내하는 명령어를 그대로 사용하세요.

**Q. 설치 후 `/sb-oneshot`이 목록에 안 보여요**
Claude Code를 재시작하면 새 명령어가 인식됩니다.

**Q. bkit 명령어(`/pdca`)가 없다고 나와요**
5단계 bkit 플러그인 설치를 완료했는지 확인해주세요.
`/plugin install bkit` 을 Claude Code 대화창에서 다시 실행해보세요.

**Q. `@vercel-react-best-practices`가 인식이 안 돼요**
4단계에서 아래 명령어를 Claude Code 대화창에서 실행했는지 확인해주세요:
`npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -y`
설치 후 Claude Code를 재시작하면 인식됩니다.
