# sb-flow

**헌법 기반 bkit 개발 워크플로우**

AI 코딩 에이전트(Claude Code / Antigravity)와 함께 **헌법(constitution.md)과 디자인 헌법(design-constitution.md)을 모든 구현의 기준**으로 삼아 소프트웨어를 개발하기 위한 워크플로우 도구입니다.

---

## 이게 뭔가요?

sb-flow는 두 가지 핵심 자산을 기반으로 bkit PDCA 사이클을 돌립니다:

| 자산 | 파일 | 역할 |
|------|------|------|
| **개발 헌법** | `constitution.md` | 개발 원칙 19개 조항 — TypeScript Strict, 보안, 반응형, 로깅 등 |
| **디자인 헌법** | `designs/design-constitution.md` | 정부 UIUX 가이드라인 — 색상 대비 4.5:1, 터치 타깃 44px, 키보드 접근성 |
| **디자인 시스템** | `designs/design.md` + `designs/design-tokens.css` | 프로젝트 고유 색상·폰트·간격 토큰 |

bkit의 모든 `/pdca` 명령어 실행 시 위 파일들이 **자동으로 참조**됩니다.

---

## 사전 준비

사용할 AI 에이전트에 맞게 준비하세요:

| AI 에이전트 | 준비 사항 |
|------------|----------|
| **Claude Code** | [Claude 데스크톱 앱](https://claude.ai/download) 설치 및 로그인 |
| **Antigravity (Gemini)** | ① [Gemini CLI](https://github.com/google-gemini/gemini-cli) 설치 및 로그인 → ② [Antigravity](https://antigravity.google/download) 설치 |

---

## 설치 및 사용

### 1. sb-flow 다운로드

[GitHub 페이지](https://github.com/Andy-yeongjin/sb-flow)에서 **Code → Download ZIP**으로 받아서 압축을 풀어두세요.

### 2. setup 실행

사용하는 AI 에이전트에 맞는 setup 파일을 **더블클릭**합니다. 폴더 선택 창이 뜨면 프로젝트를 만들 빈 폴더를 선택하면 필요한 파일이 자동으로 복사됩니다.

| AI 에이전트 | 실행 파일 |
|------------|----------|
| Claude Code | `setup.bat` |
| Antigravity (Gemini) | `setup_gemini.bat` |

### 3. 에이전트에서 프로젝트 열기

**Claude Code:**
1. 상단 **"코드"** 탭 클릭
2. 하단 **"지점 선택"** → setup으로 설정한 폴더 선택
3. 입력창 권한 버튼 → **"권한 건너뛰기"** 선택

**Antigravity (Gemini):**
1. **Ctrl+E** → **Agent Manager View** 열기
2. **Open Local 폴더** 버튼 클릭 → 프로젝트 폴더 선택
3. **Trust Folder & Continue** 클릭

### 4. /sb-setup 실행

대화창에 입력하면 bkit 등 필요한 도구가 자동으로 설치됩니다:

```
/sb-setup
```

### 5. 개발 시작

#### (선택) .pen 디자인 파일이 있다면 먼저 실행

Pencil.dev에서 만든 `.pen` 파일을 `designs/` 폴더에 넣은 경우, `/sb-oneshot` 전에 아래를 먼저 실행하세요:

```
/sb-design
```

`.pen` 파일을 분석해서 색상·폰트·간격 등 디자인 토큰을 자동 추출하고 `designs/design.md`와 `designs/design-tokens.css`를 생성합니다.

#### 기능 개발

```
/sb-oneshot 사용자가 이메일과 비밀번호로 가입하고 로그인할 수 있는 인증 기능
```

이 명령어 하나로 개발 계획 → 구현 → 갭 분석 → 자동 개선 → 브라우저 검증까지 **6단계가 자동으로 완주**됩니다.

> **PRD 파일 자동 감지**: `prd/` 폴더에 `.md` 파일이 있으면 자동으로 감지하여 구현에 반영합니다.

> **서버 실행**: 개발 완료 후 `start.bat`을 실행해서 브라우저에서 결과를 확인하세요.

---

## 명령어

| 명령어 | 설명 |
|--------|------|
| `/sb-oneshot [기능 설명]` | 개발 계획부터 브라우저 검증까지 6단계 자동 완주 |
| `/sb-guide` | 현재 단계 파악 + 다음 단계 안내 |
| `/sb-setup` | 기존 프로젝트 세션 재개 |
| `/sb-design` | .pen 분석 → designs/design.md + design-tokens.css 생성 |

---

## 워크플로우 개요

```
[1단계] /pdca plan    ← constitution.md + design.md + design-tokens.css 참조
[2단계] /pdca design  ← constitution.md + design.md + design-tokens.css 참조
[3단계] /pdca do      ← constitution.md + design.md + design-tokens.css 참조
[4단계] /pdca analyze (갭 분석)
[5단계] /pdca iterate (Match Rate < 90% 시 자동 개선)
[6단계] Playwright 브라우저 검증
```

**`/sb-oneshot`** — 위 6단계를 명령어 하나로 자동 완주합니다.

---

## 프로젝트에 설치되는 파일

| 파일/폴더 | 용도 |
|----------|------|
| `CLAUDE.md` / `GEMINI.md` | AI 에이전트 세션 시작 시 자동으로 읽히는 컨텍스트 + 헌법 강제 참조 규칙 |
| `constitution.md` | 프로젝트 개발 헌법 (19개 조항) — 모든 /pdca 명령의 최우선 기준 |
| `designs/design-constitution.md` | 정부 UI/UX 가이드라인 — 모든 UI 구현의 불변 최저 기준 |
| `designs/design.md` | 프로젝트 디자인 시스템 명세 (.pen에서 생성) |
| `designs/design-tokens.css` | CSS 디자인 토큰 변수 (design.md와 세트) |
| `prd/` | PRD 파일 보관 폴더 (sb-oneshot이 자동 감지) |
| `.claude/commands/sb-*.md` | Claude Code 커스텀 명령어 4종 |
| `.gemini/commands/sb-*.toml` | Antigravity (Gemini) 커스텀 명령어 4종 |

---

## 개발 헌법 핵심

sb-flow는 19개 조항의 개발 헌법을 기반으로 합니다:

| 조항 | 원칙 |
|------|------|
| 제0조 | 모든 표준 문서는 한글로 작성 |
| 제0조의2 | 날짜는 Asia/Seoul(UTC+9) 기준, YYYY-MM-DD 형식 |
| 제1조 | 명세 우선 (SDD) — 계획 문서가 Single Source of Truth |
| 제2조 | 보편 언어 (DDD) — 기획/설계/코드/DB에 동일 용어 |
| 제3조 | 도메인 무결성 — 비즈니스 로직을 프레임워크와 격리 |
| 제5조 | 프론트엔드 품질 — Vercel React Best Practices 준수 |
| 제8조 | 검증 의무 — 테스트 미통과 코드는 미완성 |
| 제10조 | 최종 빌드 검증 — 프로덕션 빌드 성공 = 완료 |
| 제15조 | 메인 화면 우선 개발 — 비인증 탐색 보장 |
| 제16조 | 통합 디자인 시스템 — designs/design.md + design-tokens.css 필수 |
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

**Q. Claude와 Gemini 중 어떤 걸 써야 하나요?**
둘 다 동일한 6단계 파이프라인을 지원합니다. Claude는 `setup.bat`, Antigravity는 `setup_gemini.bat`으로 각각 설치하세요.

**Q. bkit 플러그인이 설치가 안 돼요**
`/sb-setup`을 실행하면 자동으로 설치됩니다. 수동으로 하려면 Claude 대화창에서 `/plugin install bkit`을 실행하세요.

**Q. 헌법을 커스터마이징하고 싶어요**
프로젝트의 `constitution.md`를 직접 수정하면 됩니다.

**Q. 디자인 시스템을 커스터마이징하고 싶어요**
`/sb-design` 명령어로 .pen 파일에서 디자인 토큰을 추출하거나, `designs/design.md`와 `designs/design-tokens.css`를 직접 편집하세요.

---

## License

MIT
