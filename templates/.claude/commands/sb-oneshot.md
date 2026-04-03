# sb-oneshot — 명세 입력 → 구현 완료 전 자동 파이프라인 (한방 기능)

**사용법**: `/sb-oneshot [기능 설명]`

**예시**:
```
/sb-oneshot 사용자가 음식을 검색해서 끼니별로 기록하고 하루 칼로리를 확인하는 식단 기록 기능
```

기능 설명 하나만 입력하면 SpecKit 설계 → SPEC_CONTEXT.md 브릿지 → bkit 구현(`/pdca do`) → 갭 분석 → 브라우저 검증 → 문서 동기화까지
**14단계를 자동으로 완주**합니다. 완료 후에는 사용자가 대화로 수정·개선합니다.

---

## 실행 전 체크 (자동)

파이프라인 시작 전 아래를 확인합니다:

1. **헌법 확인**: `.specify/memory/constitution.md` 존재 여부
   - 없으면 → **즉시 중단** 후 안내:
     ```
     ⚠️  헌법 파일이 없습니다.

     방법 A (권장): constitution.md를 복사합니다.
       mkdir -p .specify/memory
       cp [sb-flow 경로]/constitution.md .specify/memory/constitution.md

     방법 B: speckit으로 새로 작성합니다.
       /speckit.constitution

     헌법 설정 후 다시 /sb-oneshot 을 실행해주세요.
     ```

2. **기능 설명 확인**: `$ARGUMENTS`가 비어있으면 → 안내:
   ```
   기능 설명을 입력해주세요.
   사용법: /sb-oneshot [만들고 싶은 기능 설명]
   예시: /sb-oneshot 사용자 로그인 및 회원가입 기능
   ```

3. **입력 자산 감지**: 먼저 아래를 출력합니다: `⏳ [0/14] 입력 자산 감지 중...`
   그 후 아래 경로에서 파일을 탐색하여 기록합니다:

   | 자산 | 탐색 경로 | 필수 | 용도 |
   |------|----------|------|------|
   | **디자인 헌법** | `designs/design-constitution.md` | **필수** | 정부 UIUX 가이드라인 — WCAG 2.1 AA, 터치 타깃 44px, 색상 대비 4.5:1 등 UI 품질의 불변 기준 (헌법 제16·17조) |
   | **디자인 시스템** | `designs/design.md` + `designs/design-tokens.css` | **필수** | 시각적 값의 절대 기준 — 모든 UI 수치(높이·색상·폰트·간격)는 이 토큰으로 구현 (헌법 제16조) |
   | **PRD** | `prd/` 폴더 안의 모든 `.md` 파일 | 선택 | 기능 요구사항 원본 — spec.md 작성 시 모든 요구사항을 빠짐없이 반영 |
   | **디자인 화면** | `designs/` 폴더 안의 모든 `.pen` 파일 | 선택 | UI 구조·배치 원본 — 화면 구성과 컴포넌트 배치를 반영 (헌법 제17조). **시각적 수치는 design.md 토큰으로 교정하여 구현** |

   - **디자인 헌법 검증** (필수):
     - `designs/design-constitution.md`가 **존재**해야 진행 가능
     - 없으면 → **즉시 중단** 후 안내:
       ```
       ⚠️  designs/design-constitution.md 파일이 없습니다.

       design-constitution.md는 정부 UIUX 가이드라인(WCAG 2.1 AA, 터치 타깃, 색상 대비 등)의 불변 기준입니다.
       sb-flow setup을 다시 실행하거나 파일을 designs/ 폴더에 복사해주세요.
       ```

   - **디자인 시스템 검증** (필수):
     - `designs/design.md`와 `designs/design-tokens.css`가 **모두 존재**해야 진행 가능
     - 하나라도 없으면 → **즉시 중단** 후 안내:
       ```
       ⚠️  디자인 시스템 파일이 없습니다.

       designs/design.md와 designs/design-tokens.css는 UI 일관성의 필수 기준입니다.
       sb-flow setup을 다시 실행하거나 파일을 designs/ 폴더에 복사해주세요.
       ```

   - 감지 결과 보고:
     ```
     [0/14] 입력 자산 감지 완료
       디자인 헌법: design-constitution.md ✅
       디자인 시스템: design.md ✅ + design-tokens.css ✅
       PRD: prd/요구사항.md ✅  (또는 prd/ 폴더 내 감지된 파일명)
       디자인 화면(.pen): designs/화면.pen ✅  (또는 designs/ 폴더 내 감지된 파일명)
     ```
   - `prd/` 폴더가 비어있거나 없으면 PRD → `—` 표시 후 계속
   - `designs/` 폴더가 비어있거나 없으면 디자인 화면 → `—` 표시 후 계속
   - **파일이 여러 개인 경우** → **멈추고 사용자에게 선택 요청**:
     ```
     ⚠️  [PRD / 디자인 화면] 파일이 여러 개 감지되었습니다.

     사용할 파일을 선택해주세요:
       1. {파일명1}
       2. {파일명2}
       ...

     번호 또는 파일명을 입력해주세요. (전체 사용: "모두")
     ```
     선택 완료 후 파이프라인을 계속 진행합니다.

---

## 파이프라인 실행 순서 (14단계 자동 실행)

> **진행 상황 출력 규칙 (필수)**: 각 단계를 시작하기 전 반드시 아래 형식을 텍스트로 출력합니다.
> 출력 없이 바로 실행하는 것은 금지입니다.
> ```
> ⏳ [N/14] 단계명 시작...
> ```
> 단계 완료 후에는:
> ```
> ✅ [N/14] 단계명 완료
> ```

**멈추는 경우는 아래 두 가지뿐입니다:**
- spec.md에 `[NEEDS CLARIFICATION]` 마커가 발견된 경우
- `/speckit.analyze`에서 CRITICAL 이슈가 발견된 경우

> **명령어 실행 규칙 (필수)**: 각 단계의 코드 블록에 적힌 명령어를 **{기능명}만 실제 이름으로 바꿔서 전체를 그대로 실행**합니다.
> 명령어 첫 줄만 실행하거나 내용을 임의로 수정·생략하는 것은 금지입니다.

---

### [1/14] 명세서 작성 — `/speckit.specify`

> 🔔 **출력**: `⏳ [1/14] 명세서 작성 시작...`

**PRD가 감지된 경우:**

```
/speckit.specify
$ARGUMENTS

아래 PRD 문서를 기능 요구사항의 원본으로 참조하여 spec.md를 작성합니다.
PRD의 모든 요구사항, 유저 스토리, 수락 기준을 빠짐없이 spec.md에 반영해야 합니다.
PRD에 정의되지 않은 내용만 [NEEDS CLARIFICATION]으로 표기합니다.

@{prd/ 폴더 내 감지된 PRD 파일 경로 (1개면 바로 사용, 여러 개면 아래 절차대로 선택)}
```

**`designs/` 폴더에 .pen 파일이 감지된 경우**, 위 명령어에 아래를 추가:

```
디자인 파일(.pen)이 제공되었습니다.
Pencil MCP 도구(batch_get)로 .pen 파일의 화면 구성과 컴포넌트를 읽고,
UI 흐름과 화면 목록을 spec.md의 유저 시나리오 및 화면 구성 섹션에 반영합니다.

⚠️ 역할 분리 원칙 (헌법 제16조 + 제17조):
- .pen 파일 → 레이아웃·구조·컴포넌트 배치의 원본 (무엇이 어디에 있는가)
- design.md → 시각적 수치의 원본 (높이·색상·폰트·간격이 얼마인가)
- .pen에 표기된 수치가 design.md 토큰과 다른 경우, spec.md에 design.md 토큰 기준값을 명시합니다.
  (예: .pen에서 navbar 72px → spec.md에는 "--navbar-height(64px) 적용"으로 기재)

@{designs/ 폴더 내 감지된 .pen 파일 경로 (여러 개면 모두 나열)}
```

**PRD·디자인 모두 없는 경우** (기존과 동일):

```
/speckit.specify
$ARGUMENTS
```

완료 후:
- 생성된 `specs/NNN-기능명/` 경로를 기록합니다
- spec.md에서 `[NEEDS CLARIFICATION]` 마커를 확인합니다
- **PRD가 있었다면**: spec.md가 PRD의 모든 요구사항을 누락 없이 반영했는지 대조 확인합니다. 누락된 항목이 있으면 spec.md에 추가합니다.

---

### [2/14] 모호성 확인 (자동 판단)

> 🔔 **출력**: `⏳ [2/14] 모호성 확인 시작...`

spec.md에 `[NEEDS CLARIFICATION]` 마커가 있는지 확인합니다:

**마커 없음** → `✅ 명세 완료` 메시지 후 자동 계속

**마커 있음** → **멈추고 안내**:
```
⚠️  명세서에 [NEEDS CLARIFICATION] 항목이 있습니다.

설계 단계에서 오류가 발생하거나 엉뚱한 방향으로 구현될 수 있습니다.
아래 중 하나를 선택해주세요:

선택 A (권장): 모호성 해소 후 계속
  /speckit.clarify
  → 완료 후 다시 /sb-oneshot 을 처음부터 실행하거나
    /sb-guide 로 3단계부터 안내받으세요.

선택 B: 모호성 무시하고 계속 (구현 결과가 달라질 수 있음)
  /sb-guide 로 다음 단계를 안내받으세요.
```

---

### [3/14] 기술 설계 — `/speckit.plan`

> 🔔 **출력**: `⏳ [3/14] 기술 설계 시작...`

```
/speckit.plan
```

완료 후 생성 파일 확인:
- `specs/NNN-기능명/plan.md`
- `specs/NNN-기능명/data-model.md`
- `specs/NNN-기능명/contracts/api.md`
- `specs/NNN-기능명/research.md`

---

### [4/14] 태스크 분해 — `/speckit.tasks`

> 🔔 **출력**: `⏳ [4/14] 태스크 분해 시작...`

```
/speckit.tasks
```

완료 후 `specs/NNN-기능명/tasks.md` 생성 확인

---

### [5/14] 설계 일관성 검증 — `/speckit.analyze`

> 🔔 **출력**: `⏳ [5/14] 설계 일관성 검증 시작...`

```
/speckit.analyze
```

분석 결과 확인:
- **CRITICAL 없음** → `✅ 설계 검증 통과` 후 자동 계속
- **CRITICAL 있음** → **멈추고 안내**:
  ```
  ⚠️  설계에 CRITICAL 이슈가 발견되었습니다.

  [분석 결과 요약]

  이슈 해결 후 /sb-guide 로 계속 진행해주세요.
  ```

---

### [6/14] SPEC_CONTEXT.md 생성 (7.5단계)

> 🔔 **출력**: `⏳ [6/14] SPEC_CONTEXT.md 생성 시작...`

`specs/NNN-기능명/` 디렉토리의 아래 파일을 모두 읽습니다:
- `.specify/memory/constitution.md`
- `prd/` 폴더 안의 모든 `.md` 파일 (있으면) — PRD 핵심 요구사항을 섹션 3에 반영
- `specs/NNN-기능명/spec.md`
- `specs/NNN-기능명/plan.md`
- `specs/NNN-기능명/research.md` (있으면)
- `specs/NNN-기능명/data-model.md`
- `specs/NNN-기능명/contracts/api.md`
- `specs/NNN-기능명/tasks.md`

읽은 내용을 바탕으로 `SPEC_CONTEXT.md` 템플릿의 각 섹션을 채웁니다.
**핵심 요약만** 작성합니다 (전체 내용 복사 ❌, 토큰 효율 ✅).

---

### [7/14] CLAUDE.md Spec References 업데이트

> 🔔 **출력**: `⏳ [7/14] CLAUDE.md Spec References 업데이트 시작...`

`CLAUDE.md`의 `## Spec References` 섹션에 새 spec 경로를 추가합니다.

---

### [8/14] 개발 계획 — `/pdca plan`

> 🔔 **출력**: `⏳ [8/14] 개발 계획 시작...`

**아래 명령어를 기능명만 바꿔서 그대로 실행합니다** (추가·변경·생략 금지):

```
/pdca plan {기능명}
SPEC_CONTEXT.md 파일을 참조해서 개발 계획을 세워줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
다음 네 가지 기준을 반드시 지켜야 해:
1. 헌법(constitution)의 모든 원칙을 준수할 것
2. spec.md의 모든 기능 요구사항(FR)을 빠짐없이 구현할 것
3. tasks.md의 모든 태스크를 완료 기준으로 삼을 것
4. designs/design.md의 디자인 토큰을 UI 구현의 시각적 기준으로 삼을 것 — 모든 색상·크기·간격·그림자·둥글기는 designs/design-tokens.css 변수를 사용하고, .pen 파일의 수치와 다를 경우 design.md 토큰이 우선
```

> ⚠️ `/pdca plan {기능명}` 한 줄만 실행하지 말 것. 반드시 위 전체를 사용합니다.

완료 후 `docs/01-plan/features/기능명.plan.md` 생성 확인

---

### [9/14] 상세 설계 — `/pdca design`

> 🔔 **출력**: `⏳ [9/14] 상세 설계 시작...`

**아래 명령어를 기능명만 바꿔서 그대로 실행합니다** (추가·변경·생략 금지):

```
/pdca design {기능명}
SPEC_CONTEXT.md 파일을 참조해서 작업해줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 상세 설계를 작성해줘.
designs/design.md의 디자인 토큰을 읽고, 모든 UI 컴포넌트의 시각적 수치(높이·색상·폰트·간격·그림자·둥글기)를 design.md 토큰으로 명시해줘. 하드코딩된 값(예: color: #abc123, padding: 13px)은 사용하지 말고 반드시 토큰 변수를 지정해줘.
```

> ⚠️ `/pdca design {기능명}` 한 줄만 실행하지 말 것. 반드시 위 4줄 전체를 사용합니다.

> **스킬 미로드 시**: `@vercel-react-best-practices`가 없으면 아래 안내 후 대기합니다:
> ```
> ℹ️  Vercel React Best Practices 스킬이 필요합니다.
> 터미널에서 아래 명령어를 실행 후 이 대화를 계속해주세요:
>
> npx skills add https://github.com/vercel-labs/agent-skills --skill vercel-react-best-practices -y
> ```
> 사용자가 "계속"/"설치했어" → 바로 진행. "그냥 진행해줘" → 스킬 없이 진행.

완료 후 `docs/02-design/features/기능명.design.md` 생성 확인

---

### [10/14] 코드 구현 — `/pdca do`

> 🔔 **출력**: `⏳ [10/14] 코드 구현 시작...`

**아래 명령어를 기능명만 바꿔서 그대로 실행합니다** (추가·변경·생략 금지):

```
/pdca do {기능명}
SPEC_CONTEXT.md 파일을 참조해서 작업해줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 구현해줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 CSS 스타일링에서 design-tokens.css의 CSS 변수를 사용해줘. 색상·크기·간격·그림자·둥글기 등 시각적 값을 절대 하드코딩하지 말고, 반드시 var(--토큰명) 형태로 참조해야 해. .pen 파일의 레이아웃/배치는 따르되, 수치 값은 design.md 토큰 기준으로 교정해서 구현해줘.
designs/design-constitution.md를 참조해서 정부 UIUX 가이드라인을 준수해줘: 색상 대비 4.5:1 이상(WCAG 2.1 AA), 터치 타깃 최소 44px, 시맨틱 HTML 마크업, 키보드 접근성(aria 속성, focus 관리), 한국어 UI 문구 표준 적용.
```

> ⚠️ `/pdca do {기능명}` 한 줄만 실행하지 말 것. 반드시 위 4줄 전체를 사용합니다.

---

### [11/14] 갭 분석 + 디자인 헌법 검증 — `/pdca analyze`

> 🔔 **출력**: `⏳ [11/14] 갭 분석 + 디자인 헌법 검증 시작...`

```
/pdca analyze {기능명}
```

갭 분석 완료 후, **디자인 헌법 준수 검증**을 추가로 수행합니다:

`designs/design-constitution.md`를 참조해서 구현된 UI 컴포넌트를 아래 기준으로 검증합니다:

| 검증 항목 | 기준 | 판정 |
|----------|------|------|
| 색상 대비 | 텍스트 4.5:1 이상 (WCAG 2.1 AA) | ✅ / ⚠️ |
| 터치 타깃 | 최소 44×44px | ✅ / ⚠️ |
| 키보드 접근성 | aria 속성, focus 표시, tab 순서 | ✅ / ⚠️ |
| 시맨틱 마크업 | heading 계층, landmark, alt 텍스트 | ✅ / ⚠️ |
| 반응형 레이아웃 | 모바일 375px 이상 정상 표시 | ✅ / ⚠️ |

위반 항목 발견 시:
```
⚠️  디자인 헌법 위반 항목이 있습니다.

[위반 내역 목록]

선택 A (권장): 즉시 수정 후 재검증
선택 B: 이 상태로 계속 진행 (13단계 Playwright 검증에서 재확인)
```

갭 분석 Match Rate 결과를 기록합니다. 자동 개선이 필요하면 다음 단계([12/14])에서 처리합니다.

---

### [12/14] 자동 개선 — `/pdca iterate`

> 🔔 **출력**: `⏳ [12/14] 자동 개선 시작...`

11단계 갭 분석 결과에 따라 자동 판단합니다:

**Match Rate ≥ 90%** → `✅ [12/14] 자동 개선 패스 (Match Rate 충족)` 후 바로 13단계로 진행

**Match Rate < 90%** → 아래를 실행합니다:

```
/pdca iterate {기능명}
```

iterate 완료 후:
- 개선된 Match Rate를 확인합니다
- Match Rate ≥ 90% → 13단계로 진행
- Match Rate < 90% (2회 이상 반복 후에도) → **멈추고 안내**:
  ```
  ⚠️  자동 개선 후에도 Match Rate가 [N]%입니다.

  선택 A (권장): 사용자가 직접 확인 후 /sb-guide 로 계속
  선택 B: 이 상태로 13단계(Playwright 검증)로 진행
  ```

---

### [13/14] Playwright 브라우저 기능·디자인 검증 + 자체 수정

> 🔔 **출력**: `⏳ [13/14] Playwright 브라우저 검증 시작...`

Playwright MCP 도구를 사용하여 실제 브라우저에서 구현된 화면을 직접 확인하고 문제를 즉시 수정합니다.

**검증 절차:**

1. **개발 서버 확인**: `http://localhost:3000` 접속 가능 여부 확인
   - 서버가 실행 중이 아니면 → **멈추고 안내**:
     ```
     ℹ️  개발 서버가 필요합니다.
     터미널에서 npm run dev 를 실행한 후 "계속"을 입력해주세요.
     ```

2. **화면 탐색 및 스크린샷 수집**: `mcp__playwright__browser_navigate` → `mcp__playwright__browser_take_screenshot`
   - 구현된 모든 주요 화면을 순서대로 방문합니다
   - 각 화면의 스크린샷을 캡처합니다

3. **기능 검증**: spec.md의 유저 시나리오를 실제로 실행합니다
   - 버튼 클릭, 폼 입력, 페이지 이동 등 핵심 기능을 직접 테스트합니다
   - `mcp__playwright__browser_click`, `mcp__playwright__browser_fill_form` 등 활용

4. **디자인 검증**: 스크린샷을 `design-constitution.md` 기준으로 분석합니다
   - 색상 대비, 터치 타깃 크기, 레이아웃 깨짐 여부
   - design-tokens.css 토큰이 의도대로 적용됐는지 확인

5. **자체 수정**: 발견된 문제를 **즉시 코드 수정** 후 재검증합니다
   - 수정 후 스크린샷을 다시 캡처하여 개선 확인
   - 사용자가 요청하기 전에 선제적으로 수정합니다

6. **검증 결과 출력**:
   ```
   [13/14] Playwright 검증 결과
     화면 수: [N]개
     기능 검증: ✅ [N]개 통과 / ⚠️ [N]개 수정됨
     디자인 검증: ✅ [N]개 통과 / ⚠️ [N]개 수정됨
     수정된 파일: [수정 파일 목록]
   ```

---

### [14/14] 문서 동기화 — `/sb-sync`

> 🔔 **출력**: `⏳ [14/14] 문서 동기화 시작...`

```
/sb-sync
```

구현 완료 후 실제 구현 내용을 모든 설계 문서에 반영합니다:
- bkit plan/design 문서 업데이트
- SpecKit spec.md + tasks.md 동기화 (완료 태스크 체크, 변경 FR 반영)
- SPEC_CONTEXT.md 갱신 (`In Progress` → `Completed`)
- SpecKit 문서 최종 일관성 검증

---

## 파이프라인 완료 보고

14단계 완료 후 아래 형식으로 최종 보고합니다:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ sb-oneshot 완료! (설계 → 구현 → 검증 → 동기화 14단계)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 입력 자산:
  디자인 헌법: design-constitution.md [감지됨/없음]
  PRD: [감지됨/없음]
  디자인(.pen): [감지됨/없음]

📁 생성된 산출물:
  [SpecKit 설계]
  ✅ specs/NNN-기능명/spec.md
  ✅ specs/NNN-기능명/plan.md
  ✅ specs/NNN-기능명/data-model.md
  ✅ specs/NNN-기능명/contracts/api.md
  ✅ specs/NNN-기능명/tasks.md

  [브릿지]
  ✅ SPEC_CONTEXT.md

  [bkit 구현]
  ✅ docs/01-plan/features/기능명.plan.md
  ✅ docs/02-design/features/기능명.design.md
  ✅ [구현된 소스 파일 목록]

  [갭 분석 + 자동 개선]
  ✅ Match Rate: [N]%
  ✅ 디자인 헌법 준수: [통과/위반 N건]

  [Playwright 검증]
  ✅ 기능 검증: [N]개 통과
  ✅ 디자인 검증: [N]개 통과
  ✅ 자체 수정: [N]개 파일

  [문서 동기화]
  ✅ 동기화 완료

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 이제 대화로 수정·개선하세요
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

구현 결과를 확인하고 아래 방법으로 피드백을 주세요:

  • 버그·오류 발견: "로그인 버튼 클릭 시 에러가 나"
  • 화면 수정 요청: "회원가입 폼에 이메일 중복 확인 버튼 추가해줘"
  • 로직 변경: "칼로리 계산식을 Mifflin-St Jeor 공식으로 바꿔줘"
  • 수정 후 문서 재동기화:
    → /sb-sync
  • 다음 공식 단계로 진행:
    → 보고서: /pdca report {기능명}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
