# sb-bridge — SPEC_CONTEXT.md 자동 생성 (7.5단계)

**사용법**: `/sb-bridge [spec-directory]`

**예시**:
```
/sb-bridge specs/001-meal-planner
```

SpecKit 설계 산출물 전체를 읽어 `SPEC_CONTEXT.md`를 자동으로 채웁니다.
이 파일이 생성되어야 bkit(`/pdca`) 명령어를 사용할 수 있습니다.

---

## 왜 이 단계가 필요한가?

bkit의 `/pdca` 명령어는 SpecKit 파일을 **자동으로 읽지 않습니다**.
특히 `gap-detector`, `pdca-iterator` 같은 내부 서브에이전트는 완전히 독립된 컨텍스트로 실행되기 때문에,
모든 SpecKit 산출물을 하나의 파일로 요약해두고 bkit에 전달해야 합니다.

---

## 실행 지시사항

### Step 1: 입력 검증

`$ARGUMENTS`가 비어있으면:
```
⚠️  spec 디렉토리를 지정해주세요.
사용법: /sb-bridge specs/NNN-기능명
예시: /sb-bridge specs/001-meal-planner
```

`$ARGUMENTS` 디렉토리가 존재하지 않으면:
```
⚠️  디렉토리를 찾을 수 없습니다: $ARGUMENTS
specs/ 폴더에서 정확한 경로를 확인해주세요.
```

### Step 2: 소스 파일 읽기

아래 순서로 파일을 읽습니다. 파일이 없으면 해당 섹션은 "해당 없음"으로 표시합니다:

1. `.specify/memory/constitution.md` — 헌법 (필수)
2. `$ARGUMENTS/spec.md` — 기능 명세서 (필수)
3. `$ARGUMENTS/plan.md` — 기술 설계 (필수)
4. `$ARGUMENTS/data-model.md` — 데이터 모델 (있으면)
5. `$ARGUMENTS/contracts/api.md` — API 계약 (있으면)
6. `$ARGUMENTS/tasks.md` — 태스크 목록 (필수)
7. `$ARGUMENTS/research.md` — 기술 결정 기록 (있으면)

### Step 3: SPEC_CONTEXT.md 섹션 채우기

읽은 내용을 바탕으로 `SPEC_CONTEXT.md`의 각 섹션을 채웁니다.

**작성 원칙**:
- 전체 내용 복사 ❌ → 핵심 요약만 ✅ (토큰 효율)
- HTML 주석(`<!-- 예시 -->`) 블록은 작성 후 삭제
- 각 섹션별 "예시" 행은 실제 내용으로 교체

**섹션별 작성 기준**:

| 섹션 | 출처 파일 | 작성 방법 |
|------|----------|----------|
| 1. 기본 정보 | spec.md 헤더 | 기능명, 브랜치명, 날짜, 경로 |
| 2. 헌법 (개발 원칙) | constitution.md | 조항별 한 줄 요약 테이블 + 기술 스택 |
| 3. 기능 명세 요약 | spec.md | 유저 스토리 목록 + 핵심 Clarifications |
| 4. 기술 설계 요약 | plan.md, research.md | 아키텍처 3~5줄 + 프로젝트 구조 + 성능 목표 |
| 5. 데이터 모델 | data-model.md | 엔티티 관계도 (텍스트) + 핵심 엔티티 표 |
| 6. API 계약 | contracts/api.md | 엔드포인트 목록 + 공통 에러 코드 |
| 7. 도메인 규칙 | plan.md, spec.md | 계산식, 임계값, 날짜 처리 규칙 |
| 8. 태스크 현황 | tasks.md | Phase별 상태 + 미완료 태스크 목록 |

### Step 4: 저장

채워진 내용을 `SPEC_CONTEXT.md`에 저장합니다.

### Step 5: CLAUDE.md 업데이트

`CLAUDE.md`의 `## Spec References` 섹션에 경로를 추가합니다:
```
- $ARGUMENTS/
```

---

## 완료 보고

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ SPEC_CONTEXT.md 생성 완료 (7.5단계)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 읽은 파일:
  ✅ .specify/memory/constitution.md
  ✅ $ARGUMENTS/spec.md
  ✅ $ARGUMENTS/plan.md
  [나머지 파일 목록]

📝 채워진 섹션:
  ✅ 1. 기본 정보
  ✅ 2. 헌법 (개발 원칙)
  ✅ 3. 기능 명세 요약
  ✅ 4. 기술 설계 요약
  ✅ 5. 데이터 모델
  ✅ 6. API 계약
  ✅ 7. 도메인 규칙
  ✅ 8. 태스크 현황

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
⏭️  이제 bkit 구현을 시작할 수 있습니다.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/pdca plan · design · do 명령어에 아래 문구를 반드시 추가하세요:
  "SPEC_CONTEXT.md 파일을 참조해서 작업해줘."
  (/pdca analyze · iterate는 불필요 — 8~10단계 산출물 기반으로 자동 비교)

1️⃣  개발 계획 (8단계):
┌──────────────────────────────────────
│ /pdca plan 기능명
│ SPEC_CONTEXT.md 파일을 참조해서 개발 계획을 세워줘.
│ @vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
│ 다음 세 가지 기준을 반드시 지켜야 해:
│ 1. 헌법(constitution)의 모든 원칙을 준수할 것
│ 2. spec.md의 모든 기능 요구사항을 빠짐없이 구현할 것
│ 3. tasks.md의 모든 태스크를 완료 기준으로 삼을 것
└──────────────────────────────────────
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 재실행 (기능 변경 시)

기능 명세가 변경된 경우 이 명령어를 다시 실행하여 SPEC_CONTEXT.md를 갱신합니다:

```
/sb-bridge specs/NNN-기능명
```

갱신 후에는 bkit 명령어도 재실행이 필요할 수 있습니다.
