# 프로젝트 개발 환경 (sb-flow Powered)

> **sb-flow** 워크플로우 기반 SDD(Spec-Driven Development) 프로젝트
> SpecKit으로 설계 → SPEC_CONTEXT.md로 브릿지 → bkit PDCA로 구현
>
> 설치: `.\setup.ps1 [프로젝트경로] [sb-flow경로]` (PowerShell)

---

## ⚡ 세션 시작 체크리스트

새 세션을 시작할 때 아래를 순서대로 실행합니다:

1. **SDD 학습**: `sdd_guide.md` 파일을 읽고 SDD 방법론과 spec-kit 사용법을 숙지합니다
2. **기존 프로젝트 재개 시**: `/sb-setup` 실행
3. **새 프로젝트 / 단계 파악 필요 시**: `/sb-guide` 실행
4. **새 기능 바로 시작하고 싶을 때**: `/sb-oneshot [기능 설명]` 실행

---

## 🗺️ 개발 워크플로우 개요

```
[설계 — SpecKit]              [브릿지]         [구현·검증 — bkit PDCA]

/speckit.constitution          SPEC_           /pdca plan      ← @vercel-react-best-practices
/speckit.specify        →→→   CONTEXT   →→→  /pdca design    ← @vercel-react-best-practices
/speckit.clarify (선택)        .md             /pdca do        ← @vercel-react-best-practices
/speckit.plan                  (7.5단계)       /pdca analyze
/speckit.tasks                                 /pdca iterate
/speckit.analyze                               /pdca report
                                               /pdca archive
```

**역할 분리 원칙**:
- SpecKit: "무엇을, 왜 만드는가?" (설계 전담)
- bkit: "어떻게 만들고 제대로 됐는가?" (구현·검증 전담)
- `/speckit.implement` 사용 금지 — 구현은 반드시 `/pdca do`

---

## 📋 핵심 원칙 (반드시 지킬 것)

1. **설계 먼저**: `/pdca do` 전 반드시 SpecKit 설계 완료 (최소 spec.md + tasks.md)
2. **브릿지 필수**: 모든 `/pdca` 명령에 반드시 추가:
   ```
   SPEC_CONTEXT.md 파일을 참조해서 작업해줘.
   ```
3. **서브에이전트 주의**: `/pdca analyze`, `/pdca iterate`는 내부 서브에이전트 실행
   → 8~10단계에서 이미 SPEC_CONTEXT.md 기반으로 bkit plan/design 문서가 생성되므로 별도 참조 불필요:
   ```
   /pdca analyze 기능명
   ```
4. **Vercel React Best Practices 필수**: 8~10단계(`/pdca plan` · `/pdca design` · `/pdca do`) 실행 시 `@vercel-react-best-practices` 가이드라인을 먼저 읽고 기준에 맞춰 계획·설계·구현:
   ```
   @vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 작업해줘.
   ```
5. **bkit → SpecKit 흐름 금지**: `/pdca` 실행 후 다시 SpecKit 명령어 사용하지 않음

---

## 🛠️ sb-flow 커스텀 명령어

| 명령어 | 설명 | 언제 사용? |
|--------|------|-----------|
| `/sb-setup` | 세션 재개 + 현재 상태 복원 | 기존 프로젝트로 돌아올 때 |
| `/sb-guide` | 현재 단계 파악 + 다음 단계 안내 | 어디서부터 해야 할지 모를 때 |
| `/sb-oneshot [기능설명]` | 설계→브릿지→구현 자동 파이프라인 (PRD·.pen 자동 감지) | 새 기능을 한방에 설계하고 싶을 때 |
| `/sb-bridge [spec-dir]` | SPEC_CONTEXT.md 자동 생성 | 7.5단계 (설계 완료 후) |
| `/sb-design` | .pen 분석 → design.md + design-tokens.css 생성 | 디자인 시스템 확정할 때 |

---

## 🏛️ 개발 헌법 핵심 요약

> 전체 원문: `.specify/memory/constitution.md`

| 조항 | 원칙 | 핵심 |
|------|------|------|
| 제0조 | 한글 작성 | 모든 표준 문서는 반드시 한글로 |
| 제1조 | 명세 우선 (SDD) | spec.md가 Single Source of Truth |
| 제2조 | 보편 언어 (DDD) | 기획·명세·코드·DB에 동일한 용어 |
| 제3조 | 도메인 무결성 | 비즈니스 로직은 프레임워크와 격리 |
| 제5조 | 프론트엔드 품질 | Vercel React Best Practices 필수 |
| 제8조 | 검증 의무 | 테스트 미통과 코드는 미완성 |
| 제9조 | 명세-코드 동기화 | 코드 수정 시 spec.md 먼저 최신화 |
| 제10조 | 최종 빌드 검증 | 프로덕션 빌드 성공 = 완료 |
| 제15조 | 메인 화면 우선 | 메인 화면 먼저 개발, 비인증 탐색 보장 |
| 제16조 | 디자인 시스템 | design.md + design-tokens.css 필수, 하드코딩 금지 |
| 제17조 | 디자인 원본 | .pen은 구조/배치 원본, 시각적 수치는 design.md 토큰으로 교정 |
| 제19조 | 정부 디자인 헌법 | design-constitution.md가 불변 최저 기준 — 색상 대비 4.5:1, 터치 타깃 44px, 키보드 접근성 필수 |

---

## 📁 Spec References

> `/speckit.specify` 실행 후 생성된 spec 경로를 여기에 추가합니다.
> Claude는 이 파일을 항상 읽으므로 여기 경로를 추가하면 자동 인식됩니다.

<!-- 예시:
- specs/001-meal-planner/
- specs/002-auth/
-->

---

## 📊 현재 개발 상태

> 세션 재개 시 `/sb-setup` 또는 `/pdca status`로 확인

| 항목 | 내용 |
|------|------|
| 현재 기능 | — |
| 현재 단계 | — |
| 마지막 작업 | — |
