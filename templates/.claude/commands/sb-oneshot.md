# sb-oneshot — 명세 입력 → 구현 완료 전 자동 파이프라인 (한방 기능)

**사용법**: `/sb-oneshot [기능 설명]`

**예시**:
```
/sb-oneshot 사용자가 음식을 검색해서 끼니별로 기록하고 하루 칼로리를 확인하는 식단 기록 기능
```

기능 설명 하나만 입력하면 SpecKit 설계 → SPEC_CONTEXT.md 브릿지 → bkit 구현(`/pdca do`) → 갭 분석까지
**12단계를 자동으로 완주**합니다. 완료 후에는 사용자가 대화로 수정·개선합니다.

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

3. **입력 자산 감지**: 프로젝트 루트에서 아래 파일을 탐색하여 기록합니다:

   | 자산 | 탐색 패턴 | 필수 | 용도 |
   |------|----------|------|------|
   | **디자인 시스템** | `design.md` + `design-tokens.css` | **필수** | 시각적 값의 절대 기준 — 모든 UI 수치(높이·색상·폰트·간격)는 이 토큰으로 구현 (헌법 제16조) |
   | **PRD** | `*prd*.md`, `*PRD*.md` (대소문자 무관, 파일명에 "prd" 포함) | 선택 | 기능 요구사항 원본 — spec.md 작성 시 모든 요구사항을 빠짐없이 반영 |
   | **디자인 화면** | `*.pen` | 선택 | UI 구조·배치 원본 — 화면 구성과 컴포넌트 배치를 반영 (헌법 제17조). **시각적 수치는 design.md 토큰으로 교정하여 구현** |

   - **디자인 시스템 검증** (필수):
     - `design.md`와 `design-tokens.css`가 **모두 존재**해야 진행 가능
     - 하나라도 없으면 → **즉시 중단** 후 안내:
       ```
       ⚠️  디자인 시스템 파일이 없습니다.

       design.md와 design-tokens.css는 UI 일관성의 필수 기준입니다.
       sb-flow setup을 다시 실행하거나 파일을 수동 복사해주세요.
       ```

   - 감지 결과 보고:
     ```
     [0/12] 입력 자산 감지 완료
       디자인 시스템: design.md ✅ + design-tokens.css ✅
       PRD: prd.md ✅
       디자인 화면(.pen): design.pen ✅
     ```
   - PRD·.pen이 없는 경우 → 해당 항목만 `—` 표시 후 계속 (디자인 시스템은 항상 필수)

---

## 파이프라인 실행 순서 (12단계 자동 실행)

각 단계마다 `[N/12] 단계명 실행 중...` 형식으로 진행 상황을 보고합니다.
**멈추는 경우는 아래 두 가지뿐입니다:**
- spec.md에 `[NEEDS CLARIFICATION]` 마커가 발견된 경우
- `/speckit.analyze`에서 CRITICAL 이슈가 발견된 경우

> **명령어 실행 규칙 (필수)**: 각 단계의 코드 블록에 적힌 명령어를 **{기능명}만 실제 이름으로 바꿔서 전체를 그대로 실행**합니다.
> 명령어 첫 줄만 실행하거나 내용을 임의로 수정·생략하는 것은 금지입니다.

---

### [1/12] 명세서 작성 — `/speckit.specify`

**PRD가 감지된 경우:**

```
/speckit.specify
$ARGUMENTS

아래 PRD 문서를 기능 요구사항의 원본으로 참조하여 spec.md를 작성합니다.
PRD의 모든 요구사항, 유저 스토리, 수락 기준을 빠짐없이 spec.md에 반영해야 합니다.
PRD에 정의되지 않은 내용만 [NEEDS CLARIFICATION]으로 표기합니다.

@{감지된 PRD 파일 경로}
```

**디자인(.pen)이 감지된 경우**, 위 명령어에 아래를 추가:

```
디자인 파일(.pen)이 제공되었습니다.
Pencil MCP 도구(batch_get)로 .pen 파일의 화면 구성과 컴포넌트를 읽고,
UI 흐름과 화면 목록을 spec.md의 유저 시나리오 및 화면 구성 섹션에 반영합니다.

⚠️ 역할 분리 원칙 (헌법 제16조 + 제17조):
- .pen 파일 → 레이아웃·구조·컴포넌트 배치의 원본 (무엇이 어디에 있는가)
- design.md → 시각적 수치의 원본 (높이·색상·폰트·간격이 얼마인가)
- .pen에 표기된 수치가 design.md 토큰과 다른 경우, spec.md에 design.md 토큰 기준값을 명시합니다.
  (예: .pen에서 navbar 72px → spec.md에는 "--navbar-height(64px) 적용"으로 기재)

@{감지된 .pen 파일 경로}
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

### [2/12] 모호성 확인 (자동 판단)

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

### [3/12] 기술 설계 — `/speckit.plan`

```
/speckit.plan
```

완료 후 생성 파일 확인:
- `specs/NNN-기능명/plan.md`
- `specs/NNN-기능명/data-model.md`
- `specs/NNN-기능명/contracts/api.md`
- `specs/NNN-기능명/research.md`

---

### [4/12] 태스크 분해 — `/speckit.tasks`

```
/speckit.tasks
```

완료 후 `specs/NNN-기능명/tasks.md` 생성 확인

---

### [5/12] 설계 일관성 검증 — `/speckit.analyze`

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

### [6/12] SPEC_CONTEXT.md 생성 (7.5단계)

`specs/NNN-기능명/` 디렉토리의 아래 파일을 모두 읽습니다:
- `.specify/memory/constitution.md`
- `*prd*.md` (프로젝트 루트, 대소문자 무관, 파일명에 "prd" 포함, 있으면) — PRD 핵심 요구사항을 섹션 3에 반영
- `specs/NNN-기능명/spec.md`
- `specs/NNN-기능명/plan.md`
- `specs/NNN-기능명/research.md` (있으면)
- `specs/NNN-기능명/data-model.md`
- `specs/NNN-기능명/contracts/api.md`
- `specs/NNN-기능명/tasks.md`

읽은 내용을 바탕으로 `SPEC_CONTEXT.md` 템플릿의 각 섹션을 채웁니다.
**핵심 요약만** 작성합니다 (전체 내용 복사 ❌, 토큰 효율 ✅).

---

### [7/12] CLAUDE.md Spec References 업데이트

`CLAUDE.md`의 `## Spec References` 섹션에 새 spec 경로를 추가합니다.

---

### [8/12] 개발 계획 — `/pdca plan`

**아래 명령어를 기능명만 바꿔서 그대로 실행합니다** (추가·변경·생략 금지):

```
/pdca plan {기능명}
SPEC_CONTEXT.md 파일을 참조해서 개발 계획을 세워줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
다음 네 가지 기준을 반드시 지켜야 해:
1. 헌법(constitution)의 모든 원칙을 준수할 것
2. spec.md의 모든 기능 요구사항(FR)을 빠짐없이 구현할 것
3. tasks.md의 모든 태스크를 완료 기준으로 삼을 것
4. design.md의 디자인 토큰을 UI 구현의 시각적 기준으로 삼을 것 — 모든 색상·크기·간격·그림자·둥글기는 design-tokens.css 변수를 사용하고, .pen 파일의 수치와 다를 경우 design.md 토큰이 우선
```

> ⚠️ `/pdca plan {기능명}` 한 줄만 실행하지 말 것. 반드시 위 전체를 사용합니다.

완료 후 `docs/01-plan/features/기능명.plan.md` 생성 확인

---

### [9/12] 상세 설계 — `/pdca design`

**아래 명령어를 기능명만 바꿔서 그대로 실행합니다** (추가·변경·생략 금지):

```
/pdca design {기능명}
SPEC_CONTEXT.md 파일을 참조해서 작업해줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 상세 설계를 작성해줘.
design.md의 디자인 토큰을 읽고, 모든 UI 컴포넌트의 시각적 수치(높이·색상·폰트·간격·그림자·둥글기)를 design.md 토큰으로 명시해줘. 하드코딩된 값(예: color: #abc123, padding: 13px)은 사용하지 말고 반드시 토큰 변수를 지정해줘.
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

### [10/12] 코드 구현 — `/pdca do`

**아래 명령어를 기능명만 바꿔서 그대로 실행합니다** (추가·변경·생략 금지):

```
/pdca do {기능명}
SPEC_CONTEXT.md 파일을 참조해서 작업해줘.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 구현해줘.
design.md와 design-tokens.css를 읽고, 모든 CSS 스타일링에서 design-tokens.css의 CSS 변수를 사용해줘. 색상·크기·간격·그림자·둥글기 등 시각적 값을 절대 하드코딩하지 말고, 반드시 var(--토큰명) 형태로 참조해야 해. .pen 파일의 레이아웃/배치는 따르되, 수치 값은 design.md 토큰 기준으로 교정해서 구현해줘.
```

> ⚠️ `/pdca do {기능명}` 한 줄만 실행하지 말 것. 반드시 위 4줄 전체를 사용합니다.

---

### [11/12] 갭 분석 — `/pdca analyze`

```
/pdca analyze {기능명}
```

분석 결과에 따라:
- **Match Rate ≥ 90%** → `✅ 갭 분석 통과` 후 완료 보고로 진행
- **Match Rate < 90%** → **멈추고 안내**:
  ```
  ⚠️  Match Rate가 [N]%입니다.

  선택 A (권장): /pdca iterate {기능명}  → 자동 개선 후 재검증
  선택 B: 이 상태로 완료하고 나중에 수정
  ```

---

## 파이프라인 완료 보고

12단계 완료 후 아래 형식으로 최종 보고합니다:

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ sb-oneshot 완료! (설계 → 구현 → 검증 12단계)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 입력 자산:
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

  [갭 분석]
  ✅ Match Rate: [N]%

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💬 이제 대화로 수정·개선하세요
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

구현 결과를 확인하고 아래 방법으로 피드백을 주세요:

  • 버그·오류 발견: "로그인 버튼 클릭 시 에러가 나"
  • 화면 수정 요청: "회원가입 폼에 이메일 중복 확인 버튼 추가해줘"
  • 로직 변경: "칼로리 계산식을 Mifflin-St Jeor 공식으로 바꿔줘"
  • 수정이 끝났으면:
    → 문서 동기화: /sb-sync
  • 다음 공식 단계로 진행:
    → 갭 분석:     /pdca analyze {기능명}
    → 보고서:      /pdca report {기능명}
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```
