# sb-flow 워크플로우 가이드

> **헌법 기반 bkit PDCA 개발 워크플로우 — 새 프로젝트/기능 개발 시 참조 가이드**

## 개요

sb-flow는 **헌법(constitution.md)과 디자인 시스템(design.md + design-tokens.css)을 모든 구현의 기준**으로 삼아 bkit PDCA 사이클로 기능을 개발하는 워크플로우입니다.

| 구성 요소 | 파일 | 역할 |
|----------|------|------|
| **개발 헌법** | `constitution.md` | 개발 원칙 19개 조항 — 모든 구현의 최우선 기준. 세션 시작 시 AI가 즉시 읽음 |
| **디자인 시스템** | `designs/design.md` + `designs/design-tokens.css` | 프로젝트 고유 색상·폰트·간격 토큰 — 모든 UI 구현의 시각적 기준 |
| **디자인 헌법** | `designs/design-constitution.md` | 정부 UIUX 가이드라인 — `/sb-design` 실행 시 토큰 검증에만 사용 |
| **PRD** | `prd/*.md` | 기능 요구사항 원본 (선택) — `/sb-oneshot`이 자동 감지 |
| **디자인 화면** | `designs/*.pen` 또는 `designs/stitch/` | Pencil.dev 또는 Stitch UI 화면 (선택) — `/sb-oneshot`이 자동 감지 |

> **`/sb-oneshot [기능 설명]`** — 아래 6단계 전체를 명령어 하나로 자동 완주합니다.

---

## 헌법 강제 참조 방식

### 세션 시작 시 (자동)

`CLAUDE.md`에 아래 지시가 있어 Claude가 세션 시작 시 즉시 읽습니다:

```
constitution.md — 개발 헌법 전문. 모든 조항을 숙지하고 이 프로젝트의 모든 작업에 적용한다.
```

### /pdca 명령 실행 시 (명시적 포함)

`/pdca plan`, `/pdca design`, `/pdca do` 실행 시 반드시 아래를 함께 입력합니다:

```
constitution.md 파일을 읽고 모든 원칙을 반드시 준수해서 작업해줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 UI 수치를 var(--토큰명) 형태로 참조해줘. 하드코딩 금지.
```

> `/sb-oneshot` 사용 시 위 지시가 자동으로 포함됩니다. 수동으로 `/pdca`를 칠 때만 직접 입력이 필요합니다.

---

## 사전 설치

> **새 프로젝트 시작 전 1회만 실행.**

```
/sb-setup
```

자동으로 실행되는 항목:
1. Node.js 설치 확인
2. bkit 플러그인 설치
3. Vercel React Best Practices 스킬 설치
4. constitution.md 파일 존재 확인

---

## 6단계 워크플로우

```
[0] 입력 자산 감지
    constitution.md ✅ 필수
    designs/design.md + design-tokens.css ✅ 필수
    prd/*.md (선택)
    designs/*.pen (선택)

[1] /pdca plan    ← constitution.md + design.md/tokens 참조
[2] /pdca design  ← constitution.md + design.md/tokens 참조
[3] /pdca do      ← constitution.md + design.md/tokens 참조
[4] /pdca analyze ← 갭 분석 + design.md/tokens 토큰 적용 검증
[5] /pdca iterate ← Match Rate < 90% 시 자동 개선
[6] Playwright    ← 브라우저 기능·디자인 검증 + 자체 수정
```

---

### [0] 입력 자산 감지

파이프라인 시작 전 자동으로 수행됩니다.

| 자산 | 경로 | 필수 여부 |
|------|------|---------|
| 개발 헌법 | `constitution.md` | 필수 — 없으면 즉시 중단 |
| 디자인 시스템 | `designs/design.md` + `designs/design-tokens.css` | 필수 — 없으면 즉시 중단 |
| PRD | `prd/*.md` | 선택 — 있으면 기능 요구사항에 반영 |
| 디자인 화면 | `designs/*.pen` | 선택 — 있으면 UI 구조·배치에 반영 |

> **`.pen` 파일은 반드시 `designs/` 폴더에 넣어야 합니다.**

---

### [1] 개발 계획 — `/pdca plan`

bkit이 기능의 개발 계획을 수립합니다.

**PRD + .pen 모두 있는 경우 (최적):**
```
/pdca plan {기능명}
constitution.md 파일을 읽고 모든 원칙(제0조~마지막 조항)을 반드시 준수해서 개발 계획을 세워줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 색상·크기·간격·그림자·둥글기는 design-tokens.css의 CSS 변수를 사용해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
아래 PRD 문서를 기능 요구사항의 원본으로 참조해서 모든 요구사항을 빠짐없이 반영해줘:
@prd/요구사항.md
Pencil MCP 도구(batch_get)로 아래 .pen 파일의 화면 구성을 읽고 UI 흐름을 반영해줘.
⚠️ .pen의 레이아웃·배치는 따르되, 시각적 수치는 반드시 design.md 토큰 기준으로 교정해줘.
@designs/화면.pen
```

**아무것도 없는 경우 (기본):**
```
/pdca plan {기능명}
constitution.md 파일을 읽고 모든 원칙(제0조~마지막 조항)을 반드시 준수해서 개발 계획을 세워줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 색상·크기·간격·그림자·둥글기는 design-tokens.css의 CSS 변수를 사용해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
기능 설명: {기능 설명}
```

**산출물**: `docs/01-plan/features/{기능명}.plan.md`

---

### [2] 상세 설계 — `/pdca design`

UI 컴포넌트와 데이터 구조를 상세 설계합니다.

```
/pdca design {기능명}
constitution.md 파일을 읽고 모든 원칙을 준수해서 상세 설계를 작성해줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 UI 컴포넌트의 시각적 수치(높이·색상·폰트·간격·그림자·둥글기)를 design-tokens.css 변수로 명시해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 상세 설계를 작성해줘.
```

**산출물**: `docs/02-design/features/{기능명}.design.md`

---

### [3] 코드 구현 — `/pdca do`

실제 코드를 작성합니다.

```
/pdca do {기능명}
constitution.md 파일을 읽고 모든 원칙을 반드시 준수해서 구현해줘. 특히 TypeScript Strict Mode, 보안(API 키 하드코딩 금지), 빌드 검증.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 CSS 스타일링에서 var(--토큰명) 형태로 참조해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 구현해줘.
```

---

### [4] 갭 분석 + 토큰 검증 — `/pdca analyze`

설계 대비 구현 일치율(Match Rate)을 측정하고, 디자인 토큰 적용 여부를 검증합니다.

```
/pdca analyze {기능명}
```

갭 분석 후 추가 검증:

| 검증 항목 | 기준 | 판정 |
|----------|------|------|
| 색상 하드코딩 | `color: #hex` 없음 → 모두 `var(--color-*)` | ✅ / ⚠️ |
| 크기 하드코딩 | px 고정값 없음 → 모두 `var(--space-*)`, `var(--text-*)` 등 | ✅ / ⚠️ |
| 레이아웃 토큰 | navbar·sidebar 등 `var(--navbar-height)` 등 사용 | ✅ / ⚠️ |
| 반응형 | 모바일 375px 이상 정상 표시 | ✅ / ⚠️ |

---

### [5] 자동 개선 — `/pdca iterate`

Match Rate < 90% 시 자동 실행됩니다.

```
/pdca iterate {기능명}
```

- Match Rate ≥ 90% → 패스, 6단계로 진행
- Match Rate < 90% → iterate 실행
- 2회 이상 반복 후에도 < 90% → 사용자에게 확인 요청

---

### [6] Playwright 브라우저 검증

실제 브라우저에서 기능과 디자인을 검증하고 즉시 수정합니다.

1. `http://localhost:3000` 접속 확인 (서버 미실행 시 중단 후 안내)
2. 모든 주요 화면 탐색 + 스크린샷 수집
3. 핵심 기능 직접 테스트 (버튼 클릭, 폼 입력, 페이지 이동)
4. `designs/design.md` 기준으로 토큰 미적용·레이아웃 깨짐 확인
5. 발견된 문제 즉시 코드 수정 후 재검증

---

## 디자인 시스템 생성 — `/sb-design`

디자인 소스(`.pen` 또는 Stitch)를 분석해 `design.md` + `design-tokens.css`를 생성합니다.
`designs/stitch/` 폴더가 있으면 Stitch 모드, `designs/*.pen`이 있으면 Pencil 모드로 자동 분기합니다.

```
/sb-design
```

### 디자인 소스 준비

**Pencil.dev 사용 시:**
- `designs/` 폴더에 `.pen` 파일을 넣어주세요.

**Stitch 사용 시:**
1. Stitch에서 디자인 완성 후 **내보내기 → ZIP** 클릭
2. 다운로드된 ZIP 파일 압축 해제
3. 압축 해제된 파일들을 `designs/stitch/` 폴더에 넣기
   ```
   designs/
   └── stitch/
       ├── code.html    ← Tailwind 색상·폰트·둥글기 토큰 포함
       ├── DESIGN.md    ← 디자인 원칙·타이포그래피·컴포넌트 규칙
       └── screen.png   ← 스크린샷 (선택)
   ```
4. `/sb-design` 실행

### 실행 순서

1. `designs/stitch/` 또는 `designs/*.pen` 자동 감지 (Stitch 우선)
2. 소스 파싱 — 색상·폰트·간격·둥글기 추출
3. `designs/design-constitution.md` 기준 검증·교정 (색상 대비, 터치 타깃 등)
4. `designs/design.md` 생성
5. `designs/design-tokens.css` 생성
6. `guides/design-preview.html` 생성 (브라우저 시각 확인용)

> `design-constitution.md`는 이 단계에서만 사용됩니다. 이후 구현 단계에서는 검증된 결과물인 `design.md` + `design-tokens.css`만 참조합니다.

---

## 명령어 레퍼런스

| 명령어 | 설명 | 언제 사용? |
|--------|------|-----------|
| `/sb-setup` | 초기 설치 + 세션 재개 | 처음 시작 또는 기존 프로젝트로 돌아올 때 |
| `/sb-oneshot [기능설명]` | 6단계 자동 완주 | 새 기능을 한 번에 개발하고 싶을 때 |
| `/sb-guide` | 현재 단계 파악 + 다음 단계 안내 | 어디서부터 해야 할지 모를 때 |
| `/sb-design` | .pen 또는 Stitch → design.md + design-tokens.css 생성 | 디자인 시스템 확정할 때 |
| `/pdca plan {기능명}` | 개발 계획 수립 | 1단계 |
| `/pdca design {기능명}` | 상세 설계 | 2단계 |
| `/pdca do {기능명}` | 코드 구현 | 3단계 |
| `/pdca analyze {기능명}` | 갭 분석 | 4단계 |
| `/pdca iterate {기능명}` | 자동 개선 | 5단계 (Match Rate < 90%) |
| `/pdca report {기능명}` | 완료 보고서 생성 | 최종 단계 |

---

## 프로젝트 파일 구조

```
프로젝트 루트/
├── constitution.md              # 개발 헌법 (AI가 세션 시작 시 읽음)
├── CLAUDE.md                    # AI 에이전트 컨텍스트
├── designs/
│   ├── design.md                # 디자인 시스템 명세 (본체)
│   ├── design-tokens.css        # CSS 변수 (본체)
│   ├── design-constitution.md   # 정부 가이드라인 (sb-design 전용)
│   ├── 화면.pen                 # Pencil.dev 디자인 파일 (선택)
│   └── stitch/                  # Stitch ZIP 압축 해제 폴더 (선택)
│       ├── code.html            #   Tailwind 토큰 포함 HTML
│       ├── DESIGN.md            #   디자인 원칙 문서
│       └── screen.png           #   스크린샷
├── prd/
│   └── 요구사항.md              # PRD 파일 (선택)
├── docs/
│   ├── 01-plan/                 # bkit 개발 계획 문서
│   └── 02-design/               # bkit 상세 설계 문서
├── guides/
│   └── design-preview.html     # 디자인 시스템 시각 확인 (sb-design 생성)
├── start.bat                    # 개발 서버 실행
└── end.bat                      # 개발 서버 종료
```

---

## 자주 묻는 질문

**Q. `.pen` 파일이 없으면 어떻게 하나요?**
`setup.bat` 실행 시 기본 `design.md` + `design-tokens.css`가 복사됩니다. 이 파일을 직접 편집하거나 그대로 사용하면 됩니다.

**Q. `/pdca` 명령어에 매번 헌법 참조를 입력해야 하나요?**
`/sb-oneshot`을 사용하면 자동으로 포함됩니다. 수동으로 `/pdca`를 실행할 때만 직접 입력이 필요합니다.

**Q. `design-constitution.md`는 언제 사용하나요?**
`/sb-design` 실행 시 토큰을 정부 가이드라인 기준으로 검증·교정하는 데만 사용합니다. 이미 검증된 `design.md` + `design-tokens.css`를 쓰는 이후 단계에서는 참조하지 않습니다.

**Q. Match Rate가 90% 미만이면?**
`/pdca iterate`가 자동으로 실행되어 갭을 메웁니다. 2회 반복 후에도 미달이면 사용자에게 확인을 요청합니다.
