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

- [Claude 데스크톱 앱](https://claude.ai/download) 설치 및 로그인

---

## 설치 및 사용

### 1. sb-flow 다운로드

[GitHub 페이지](https://github.com/Andy-yeongjin/sb-flow)에서 **Code → Download ZIP**으로 받아서 압축을 풀어두세요.

### 2. setup.bat 실행

sb-flow 폴더 안의 `setup.bat`을 **더블클릭**합니다. 폴더 선택 창이 뜨면 내 프로젝트를 만들 빈 폴더를 선택하면 필요한 파일이 자동으로 복사됩니다.

### 3. Claude 데스크톱 앱에서 프로젝트 열기

1. 상단 **"코드"** 탭 클릭
2. 하단 **"지점 선택"** → setup.bat으로 설정한 폴더 선택
3. 입력창 권한 버튼 → **"권한 건너뛰기"** 선택

### 4. /sb-setup 실행

Claude 대화창에 입력하면 SpecKit, bkit 등 필요한 도구가 자동으로 설치됩니다:

```
/sb-setup
```

### 5. 개발 시작

```
/sb-oneshot 사용자가 이메일과 비밀번호로 가입하고 로그인할 수 있는 인증 기능
```

이 명령어 하나로 설계 → 브릿지 문서 → 구현 → 갭 분석까지 자동으로 진행됩니다.

> **PRD·디자인 파일 자동 감지**: 프로젝트 루트에 PRD 파일(`*prd*.md`)이나 Pencil 디자인 파일(`.pen`)이 있으면 자동으로 감지하여 명세서 작성에 반영합니다.

> **서버 실행**: 개발 완료 후 `start.bat`을 실행해서 브라우저에서 결과를 확인하세요.

---

## 명령어

| 명령어 | 설명 |
|--------|------|
| `/sb-oneshot [기능 설명]` | 설계부터 구현·갭 분석까지 한방에 진행 (PRD·.pen 자동 감지) |
| `/sb-sync` | 구현 완료 후 모든 문서 자동 동기화 |
| `/sb-guide` | 현재 단계 파악 + 다음 단계 안내 |
| `/sb-setup` | 기존 프로젝트 세션 재개 |
| `/sb-bridge [spec-dir]` | SPEC_CONTEXT.md 브릿지 문서 생성 |
| `/sb-design` | .pen 분석 → design-constitution.md 검증 → design.md + design-tokens.css 생성 |

---

## 워크플로우 개요

```
[설계 — SpecKit]              [브릿지]         [구현/검증 — bkit PDCA]

/speckit.constitution          SPEC_           /pdca plan
/speckit.specify        →→→   CONTEXT   →→→  /pdca design
/speckit.clarify (선택)        .md             /pdca do
/speckit.plan                  (7.5단계)       /pdca analyze  ← /sb-oneshot 자동 실행
/speckit.tasks                                 /pdca iterate
                                               /pdca report
                                               /sb-sync       ← 문서 자동 동기화
```

---

## 프로젝트에 설치되는 파일

| 파일 | 용도 |
|------|------|
| `CLAUDE.md` | Claude Code 세션 시작 시 자동으로 읽히는 컨텍스트 |
| `design-constitution.md` | 정부 UI/UX 가이드라인 — 모든 UI 구현의 불변 최저 기준 |
| `design.md` | 프로젝트 디자인 시스템 명세 (헌법 준수 필수, .pen에서 생성) |
| `design-tokens.css` | CSS 디자인 토큰 변수 (design.md와 세트) |
| `sdd_guide.md` | AI 에이전트가 SDD 방법론을 학습하는 문서 |
| `SPEC_CONTEXT.md` | SpecKit → bkit 브릿지 문서 템플릿 |
| `constitution.md` | 프로젝트 개발 헌법 (19개 조항) |
| `.claude/commands/sb-*.md` | 커스텀 명령어 6종 |

---

## 개발 헌법 핵심

sb-flow는 19개 조항의 개발 헌법을 기반으로 합니다:

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
| 제17조 | Pencil.dev 디자인 원본 준수 — .pen은 구조/배치 원본, 시각적 수치는 design.md 토큰으로 교정 |
| 제19조 | 정부 디자인 헌법 — design-constitution.md가 불변 최저 기준 (색상 대비 4.5:1, 터치 타깃 44px, 키보드 접근성) |

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
| Design Standard | design-constitution.md (정부 KRDS 가이드라인) |
| UI Design | Pencil.dev (선택) |
| Auth | Auth.js (NextAuth) |

---

## 자주 묻는 질문

**Q. Claude 데스크톱 앱이 없어도 사용할 수 있나요?**
아니요. sb-flow는 Claude 데스크톱 앱의 Claude Code 환경에서 동작하도록 설계되었습니다.

**Q. bkit 플러그인이 설치가 안 돼요**
`/sb-setup`을 실행하면 자동으로 설치됩니다. 수동으로 하려면 Claude 대화창에서 `/plugin install bkit`을 실행하세요.

**Q. /sb-setup이 작동하지 않아요**
Claude 데스크톱 앱에서 프로젝트 폴더가 올바르게 열려 있는지 확인하세요. 하단에 폴더 이름이 표시되어야 합니다.

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
