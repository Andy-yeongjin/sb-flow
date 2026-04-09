# 프로젝트 개발 환경 (sb-flow Powered)

> **sb-flow** 워크플로우 기반 SDD(Spec-Driven Development) 프로젝트
> bkit PDCA로 개발하며, 헌법과 디자인 시스템을 모든 작업의 최우선 기준으로 삼습니다.

---

## ⚡ 세션 시작 — 반드시 먼저 실행

**세션이 시작되면 아래 파일을 즉시 읽어라. 어떤 작업을 하기 전에 먼저 읽어야 한다.**

1. `constitution.md` — 개발 헌법 전문. 모든 조항을 숙지하고 이 프로젝트의 모든 작업에 적용한다.

## 🗺️ 개발 워크플로우

```
[1단계] /pdca plan    ← constitution.md + design.md + design-tokens.css 참조 필수
[2단계] /pdca design  ← constitution.md + design.md + design-tokens.css 참조 필수
[3단계] /pdca do      ← constitution.md + design.md + design-tokens.css 참조 필수
[4단계] /pdca analyze
[5단계] /pdca iterate (Match Rate < 90% 시)
[6단계] 브라우저 검증 (browser_subagent)
```

**`/sb-oneshot [기능 설명]`** — 위 6단계를 한 번에 자동 완주합니다.

---

## ⛔ 절대 규칙 — 모든 결과물은 헌법 준수 재검증 필수

> **이 규칙은 예외 없이 적용된다. 어떤 작업이든 완료 전 반드시 이행해야 한다.**

**코드 수정 요청이 오면 응답하기 전에 반드시 `constitution.md`, `designs/design.md`, `designs/design-tokens.css`를 직접 열어서 확인한 후 작업하라.** UI 수정이라면 해당하는 토큰(`var(--토큰명)`)을 사용하고, 토큰에 없는 값이라면 토큰을 추가한 후 사용한다. 위반이 하나라도 있으면 즉시 수정한다. 검증 없이 "완료"라고 말하는 것은 허용되지 않는다.

---

## 🚨 핵심 규칙 (반드시 지킬 것)

### 1. 헌법 + 디자인 시스템 강제 참조

`/pdca plan`, `/pdca design`, `/pdca do` 실행 시 반드시 아래를 함께 입력합니다:

```
constitution.md 파일을 읽고 모든 원칙을 반드시 준수해서 작업해줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 UI 수치를 var(--토큰명) 형태로 참조해줘. 하드코딩 금지.
```

> **절대 `/pdca do {기능명}` 한 줄만 실행하지 말 것.** 위 지시를 항상 포함해야 합니다.

### 2. 디자인 토큰 하드코딩 금지

모든 CSS 스타일링에서 `design-tokens.css`의 CSS 변수만 사용합니다:
- `color: #2563EB` ❌ → `color: var(--color-primary-600)` ✅
- `height: 64px` ❌ → `height: var(--navbar-height)` ✅

### 3. Vercel React Best Practices 필수

`/pdca plan`, `/pdca design`, `/pdca do` 실행 시 `.claude/` 폴더를 참조해서 `@vercel-react-best-practices`를 함께 사용합니다.

### 4. 커스텀 명령어 준수

모든 슬래시 명령어(`/sb-`, `/pdca`) 실행 시 반드시 `.gemini/commands/` 폴더의 해당 `.toml` 파일을 읽고 그 지침에 따라 작업을 수행합니다.

---

## 🛠️ sb-flow 커스텀 명령어

| 명령어 | 설명 | 언제 사용? |
|--------|------|-----------|
| `/sb-setup` | 세션 재개 + 현재 상태 복원 | 기존 프로젝트로 돌아올 때 |
| `/sb-guide` | 현재 단계 파악 + 다음 단계 안내 | 어디서부터 해야 할지 모를 때 |
| `/sb-oneshot [기능설명]` | 6단계 자동 파이프라인 (PRD·.pen 자동 감지) | 새 기능을 한방에 개발하고 싶을 때 |
| `/sb-design` | .pen 분석 → design.md + design-tokens.css 생성 | 디자인 시스템 확정할 때 |

> **`.pen` 파일 위치**: Pencil.dev 디자인 파일은 반드시 `designs/` 폴더에 넣어야 합니다. `/sb-design`과 `/sb-oneshot`은 `designs/*.pen`을 자동 탐색합니다.

---

## 🏛️ 개발 헌법 핵심 요약

> 전체 원문: `constitution.md`

| 조항 | 원칙 | 핵심 |
|------|------|------|
| 제0조 | 한글 작성 | 모든 표준 문서는 반드시 한글로 |
| 제0조의2 | 표준 시간대·날짜 형식 | Asia/Seoul(UTC+9) 기준, YYYY-MM-DD 형식 일관 적용 |
| 제1조 | 명세 우선 (SDD) | 계획 문서가 Single Source of Truth |
| 제2조 | 보편 언어 (DDD) | 기획·설계·코드·DB에 동일한 용어 |
| 제3조 | 도메인 무결성 | 비즈니스 로직은 프레임워크와 격리 |
| 제4조 | 결합도·응집도 | 도메인 간 명확한 인터페이스, 인프라는 교체 가능 플러그인 구조 |
| 제5조 | 프론트엔드 품질 | Vercel React Best Practices 필수 |
| 제6조 | 기술적 무결성·보안 | TypeScript Strict Mode, ACID 보장, 세션 검증 필수 |
| 제7조 | 반응형 디자인·UX | 다기기 최적화, 웹 접근성(a11y) 표준 준수 |
| 제8조 | 검증 의무 | 테스트 미통과 코드는 미완성 |
| 제9조 | 명세-코드 동기화 | 코드 수정 시 계획 문서 먼저 최신화 |
| 제10조 | 최종 빌드 검증 | 프로덕션 빌드 성공 = 완료 |
| 제11조 | 보안·기밀 유지 | API 키·토큰 하드코딩 금지, .env 격리 필수 |
| 제12조 | 결정의 기록 (ADR) | 중요한 아키텍처 결정 이유를 문서화 |
| 제13조 | 예외 처리·사용자 피드백 | 개발자용 로그와 사용자 안내 메시지 명확히 분리 |
| 제14조 | 구조화된 로깅 | JSON 구조 로그, Request ID 포함, 민감정보 제외 |
| 제15조 | 메인 화면 우선 | 메인 화면 먼저 개발, 비인증 탐색 보장 |
| 제16조 | 디자인 시스템 | designs/design.md + design-tokens.css 필수, 하드코딩 금지 |
| 제17조 | 디자인 원본 | .pen은 구조/배치 원본, 시각적 수치는 design.md 토큰으로 교정 |
| 제18조 | 로컬 개발 DB | 로컬은 SQLite, 배포 전 NeonDB·Supabase 중 결정 후 ADR 문서화 |
| 제19조 | 정부 디자인 헌법 | design-constitution.md가 불변 최저 기준 — 색상 대비 4.5:1, 터치 타깃 44px, 키보드 접근성 필수 |

---

## ⚙️ 환경 설정 및 스킬 (Skills)

1. **Vercel React Best Practices 스킬**:
   - `npx skills add` 명령어 실행 시 기본적으로 `.claude/` 폴더가 생성됩니다.
   - Gemini CLI는 이 폴더 내의 스킬을 참조하여 동작하므로, 폴더 이름을 변경하지 마세요.

---
