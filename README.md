# sb-flow

**SpecKit + bkit 통합 개발 워크플로우**

AI 코딩 에이전트(Claude Code)와 함께 **Spec-Driven Development(SDD)** 방식으로 소프트웨어를 개발하기 위한 워크플로우 도구입니다.

---

## 이게 뭔가요?

sb-flow는 두 가지 프레임워크를 하나의 워크플로우로 연결합니다:

| 단계 | 도구 | 역할 |
|------|------|------|
| **설계** (1~7단계) | [SpecKit](https://github.com/github/spec-kit) | "무엇을, 왜 만드는가?" — 헌법, 명세, 기술 설계, 태스크 분해 |
| **브릿지** (7.5단계) | SPEC_CONTEXT.md | 설계 산출물을 구현 도구에 전달하는 다리 |
| **구현/검증** (8~17단계) | [bkit](https://github.com/popup-studio-ai/bkit-claude-code) PDCA | "어떻게 만들고 제대로 됐는가?" — 개발, 갭 분석, 개선, 보고 |

**명세를 먼저 쓰고, AI가 명세에 따라 코드를 생성하는 방식**입니다.

---

## 사전 준비

- [Node.js](https://nodejs.org) v18 이상
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 설치 (`npm install -g @anthropic-ai/claude-code`)

---

## 설치 및 사용

> **모든 설치 과정은 Claude Code 안에서 실행합니다.**
> PowerShell 환경 차이로 인한 오류를 방지하기 위해, Claude Code 대화창에서 명령어를 입력하는 방식으로 통일합니다.

### 1. sb-flow 클론

터미널(PowerShell, Terminal 등)에서:

```powershell
git clone https://github.com/Andy-yeongjin/sb-flow.git C:\sb-flow
```

```bash
git clone https://github.com/Andy-yeongjin/sb-flow.git ~/sb-flow
```

### 2. 새 프로젝트 폴더 만들기

```
mkdir my-app
cd my-app
```

### 3. Claude Code 실행

프로젝트 폴더에서 Claude Code를 실행합니다:

```
claude --dangerously-skip-permissions
```

### 4. Claude Code 안에서 설치 스크립트 실행

Claude Code 대화창에 아래를 입력합니다:

**Windows**
```
C:\sb-flow\install.ps1 확인하고 수동으로 직접 실행해줘
```

**macOS / Linux**
```
~/sb-flow/install.sh 확인하고 수동으로 직접 실행해줘
```

> Claude Code가 스크립트를 실행하며, uv 설치 · spec-kit 초기화 · 헌법/명령어/템플릿 복사를 순서대로 진행합니다.
> 중간에 직접 실행해야 하는 단계가 있으며, 안내에 따라 진행하면 됩니다.

### 5. Vercel React Best Practices 스킬 설치

Claude Code 대화창에서:

```
npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -y
```

### 6. bkit 플러그인 설치

Claude Code 대화창에서:

```
/plugin marketplace add popup-studio-ai/bkit-claude-code
/plugin install bkit
```

### 7. 개발 시작

```
/sb-oneshot 사용자가 이메일과 비밀번호로 가입하고 로그인할 수 있는 인증 기능
```

이 명령어 하나로 설계 → 브릿지 문서 → 구현까지 자동으로 진행됩니다.

---

## 명령어

| 명령어 | 설명 |
|--------|------|
| `/sb-oneshot [기능 설명]` | 설계부터 구현까지 한방에 진행 |
| `/sb-guide` | 현재 단계 파악 + 다음 단계 안내 |
| `/sb-setup` | 기존 프로젝트 세션 재개 |
| `/sb-bridge [spec-dir]` | SPEC_CONTEXT.md 브릿지 문서 생성 |

---

## 워크플로우 개요

```
[설계 — SpecKit]              [브릿지]         [구현/검증 — bkit PDCA]

/speckit.constitution          SPEC_           /pdca plan
/speckit.specify        →→→   CONTEXT   →→→  /pdca design
/speckit.clarify (선택)        .md             /pdca do
/speckit.plan                  (7.5단계)       /pdca analyze
/speckit.tasks                                 /pdca iterate
                                               /pdca report
```

---

## 프로젝트에 설치되는 파일

| 파일 | 용도 |
|------|------|
| `CLAUDE.md` | Claude Code 세션 시작 시 자동으로 읽히는 컨텍스트 |
| `design.md` | 디자인 시스템 명세 (불변) |
| `design-tokens.css` | CSS 디자인 토큰 변수 (불변) |
| `sdd_guide.md` | AI 에이전트가 SDD 방법론을 학습하는 문서 |
| `SPEC_CONTEXT.md` | SpecKit → bkit 브릿지 문서 템플릿 |
| `.specify/memory/constitution.md` | 프로젝트 개발 헌법 (18개 조항) |
| `.claude/commands/sb-*.md` | 커스텀 명령어 4종 |

---

## 개발 헌법 핵심

sb-flow는 18개 조항의 개발 헌법을 기반으로 합니다:

| 조항 | 원칙 |
|------|------|
| 제0조 | 모든 표준 문서는 한글로 작성 |
| 제1조 | 명세 우선 (SDD) — spec.md가 Single Source of Truth |
| 제2조 | 보편 언어 (DDD) — 기획/명세/코드/DB에 동일 용어 |
| 제3조 | 도메인 무결성 — 비즈니스 로직을 프레임워크와 격리 |
| 제5조 | 프론트엔드 품질 — Vercel React Best Practices 준수 |
| 제8조 | 검증 의무 — 테스트 미통과 코드는 미완성 |
| 제10조 | 최종 빌드 검증 — 프로덕션 빌드 성공 = 완료 |
| 제15조 | 메인 화면 우선 개발 — 비인증 탐색 보장 |
| 제16조 | 통합 디자인 시스템 — design.md + design-tokens.css 필수 |
| 제17조 | Pencil.dev 디자인 원본 준수 — .pen 파일 우선 |

전체 원문: [`constitution.md`](constitution.md)

---

## 기술 스택 (기본)

| 영역 | 기술 |
|------|------|
| Framework | Next.js (App Router) |
| Language | TypeScript (Strict Mode) |
| Database | PostgreSQL (Neon, Supabase 등) |
| ORM | Prisma 또는 Drizzle |
| Styling | CSS Modules (Vanilla CSS) + design-tokens.css |
| Design | sb-flow Design System (Tailwind 스케일 기반) |
| UI Design | Pencil.dev (선택) |
| Auth | Auth.js (NextAuth) |

---

## 자주 묻는 질문

**Q. Claude Code가 없어도 사용할 수 있나요?**
아니요. sb-flow는 Claude Code 환경에서 동작하도록 설계되었습니다.

**Q. bkit 플러그인이 설치가 안 돼요**
Claude Code 대화창(터미널이 아닌)에서 `/plugin install bkit`을 실행해야 합니다.

**Q. PowerShell에서 스크립트 실행이 안 돼요**
Claude Code를 먼저 실행한 뒤, 대화창에서 `C:\sb-flow\install.ps1 확인하고 수동으로 직접 실행해줘`를 입력하세요. PowerShell 환경 차이 문제를 우회할 수 있습니다.

**Q. 헌법을 커스터마이징하고 싶어요**
프로젝트의 `.specify/memory/constitution.md`를 직접 수정하면 됩니다.

---

## 참고 자료

- [SDD (Spec-Driven Development) 가이드](sdd_guide.md)
- [통합 워크플로우 상세 문서](SPECKIT_BKIT_WORKFLOW.md)
- [GitHub spec-kit](https://github.com/github/spec-kit)
- [bkit Claude Code Plugin](https://github.com/popup-studio-ai/bkit-claude-code)

---

## License

MIT
