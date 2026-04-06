# sb-setup — 초기 설치 & 세션 재개

처음 실행 시 필요한 도구를 자동으로 설치하고, 기존 프로젝트라면 이전 작업 상태를 복원합니다.

---

## 실행 지시사항

### Step 0: 초기 설치 여부 판단 — 반드시 먼저 실행

`.specify` 폴더 존재 여부를 Bash 도구로 직접 확인한다:

```bash
ls .specify
```

**결과에 따라 분기:**

---

#### 🔴 `.specify` 폴더가 없는 경우 — 초기 설치 모드

아래 단계를 Bash 도구로 순서대로 직접 실행한다. 설명만 하지 말고 반드시 실행할 것.

**1단계 — Node.js 설치 확인 및 설치:**
```bash
node --version
```
명령어가 없으면 winget으로 자동 설치:
```bash
winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
```
설치 후 터미널을 재시작하거나 PATH를 새로 불러와야 할 수 있다. 설치 완료 후 `node --version`으로 확인.

**2단계 — uv 설치 확인 및 설치:**
```bash
uvx --version
```
명령어가 없으면 아래를 실행:
```powershell
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

**3단계 — spec-kit 초기화 (직접 실행):**
```bash
uvx --from "git+https://github.com/github/spec-kit.git" specify init . --ai claude --script ps --force
```

**4단계 — constitution.md 이동 (직접 실행):**
루트에 `constitution.md`가 있으면:
```bash
mv constitution.md .specify/memory/constitution.md
```

**5단계 — bkit 플러그인 설치 (직접 실행):**
```
/plugin marketplace add popup-studio-ai/bkit-claude-code
/plugin install bkit
```

**6단계 — Vercel 스킬 설치 (직접 실행):**
```bash
npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -y
```

모든 단계 완료 후 아래 메시지를 출력하고 **Step 1~3은 건너뛴다**:
```
✅ 초기 설치 완료!
→ /sb-oneshot [만들고 싶은 기능 설명] 으로 개발을 시작하세요.
```

---

#### 🟢 `.specify` 폴더가 있는 경우 — 세션 복원 모드

Step 1로 이동한다.

---

### Step 1: SPEC_CONTEXT.md 읽기

`SPEC_CONTEXT.md` 파일을 읽고 현재 프로젝트 상태를 파악합니다:

읽어야 할 정보:
- **기능명** 및 Feature Branch
- **Status** (Draft / In Progress / Completed)
- **태스크 현황**: Phase별 완료/전체 수, 미완료 태스크 목록

SPEC_CONTEXT.md가 없거나 비어있으면:
```
⚠️  SPEC_CONTEXT.md가 없거나 비어있습니다.
새 프로젝트이거나 설계가 아직 완료되지 않은 상태입니다.
→ /sb-guide 를 실행하여 현재 단계를 파악해주세요.
```

### Step 2: bkit 상태 확인

```
/pdca status
```

### Step 3: 상황 판단 및 안내

아래 표를 기준으로 현재 상황을 판단하고 다음 단계를 안내합니다:

| 상황 | 판단 | 안내할 명령어 |
|------|------|--------------|
| 미완료 태스크 있음 (tasks.md에 `[ ]`) | 10단계 계속 | 아래 10단계 명령어 |
| 구현 완료, 코드 리뷰 없음 | 11단계 필요 | `/code-review` (선택) |
| 코드 리뷰 완료, gap 분석 없음 | 12단계 필요 | 아래 12단계 명령어 |
| gap 분석: Match Rate < 90% | 13단계 필요 | 아래 13단계 명령어 |
| gap 분석: Match Rate ≥ 90%, 보고서 없음 | 15~16단계 | 아래 15단계 명령어 |
| 보고서 있음 | 완료 | — |
| 버그 수정 / 소규모 수정 | 직접 수정 | 자연어로 요청 |
| 새 기능 (대규모) | 8단계부터 | 아래 8단계 명령어 |
| 새 기능 (초대규모) | 처음부터 | `/sb-oneshot [기능설명]` |

**단계별 실행 명령어 (복사해서 사용)**

8단계 — 개발 계획:
```
/pdca plan {기능명}
SPEC_CONTEXT.md 파일을 참조해서 개발 계획을 세워줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
다음 세 가지 기준을 반드시 지켜야 해:
1. 헌법(constitution)의 모든 원칙을 준수할 것
2. spec.md의 모든 기능 요구사항(FR)을 빠짐없이 구현할 것
3. tasks.md의 모든 태스크를 완료 기준으로 삼을 것
```

10단계 — 코드 구현 계속:
```
/pdca do {기능명}
SPEC_CONTEXT.md 파일을 참조해서 작업해줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 구현해줘.
```

12단계 — Gap 분석:
```
/pdca analyze {기능명}
```

13단계 — 자동 개선:
```
/pdca iterate {기능명}
```

15단계 — 코드 정리:
```
/simplify
```

16단계 — 완료 보고서:
```
/pdca report {기능명}
```

---

## 출력 형식 (세션 복원 시)

현황과 다음 할 일을 간단히 출력한다:

```
현재 단계: [N단계]
미완료 태스크: [개수]개

다음:
[다음 실행할 명령어 한 줄]
```

진행 중인 기능이 없으면:
```
새 기능을 시작하려면: /sb-oneshot [기능 설명]
```
