# sb-guide — 현재 단계 파악 & 다음 단계 안내

현재 프로젝트의 개발 단계를 자동으로 감지하고, 다음 실행할 명령어를 안내합니다.
처음 사용자도 이 명령어 하나로 어디서부터 시작해야 할지 알 수 있습니다.

---

## 실행 지시사항

### Step 1: 파일 존재 여부 확인

아래 파일/디렉토리를 순서대로 확인합니다:

```
[ ] constitution.md                    — 개발 헌법
[ ] designs/design-constitution.md    — 디자인 헌법
[ ] designs/design.md                 — 디자인 시스템
[ ] prd/ (내용 있음)                   — PRD 파일
[ ] docs/01-plan/                     — bkit 개발 계획 (1단계)
[ ] docs/02-design/                   — bkit 상세 설계 (2단계)
[ ] src/ 또는 app/ (소스코드 존재)     — 구현 시작 (3단계)
[ ] docs/archive/                     — 세션 아카이브
```

### Step 2: 현재 단계 판단 로직

아래 순서대로 판단하여 **가장 최근 완료된 단계**를 식별합니다:

| 조건 | 현재 상태 | 다음 실행 |
|------|----------|----------|
| constitution.md 없음 | 🆕 새 프로젝트 시작 전 | sb-flow setup 재실행 안내 |
| constitution.md 있음, docs/ 없음 | ✅ 준비 완료 | `/sb-oneshot [기능설명]` |
| docs/01-plan 없음 | 1단계 필요 | 아래 1단계 명령어 |
| docs/01-plan 있음, docs/02-design 없음 | ✅ 1단계 완료 | 아래 2단계 명령어 |
| docs/02-design 있음, 소스코드 미완 | ✅ 2단계 완료 | 아래 3단계 명령어 |
| 소스코드 있음, gap 분석 없음 | ✅ 3단계 완료 | 아래 4단계 명령어 |
| gap 분석 있음 (Match Rate < 90%) | ⚠️ 4단계 완료, 개선 필요 | 아래 5단계 명령어 |
| gap 분석 완료 (Match Rate ≥ 90%) | ✅ 4단계 완료 | 아래 정리 명령어 |
| simplify 완료 | ✅ 정리 완료 | 아래 보고서 명령어 |
| 완료 보고서 생성됨 | ✅ 완료 | 🎉 전체 사이클 완료! |

**단계별 실행 명령어 (복사해서 사용)**

1단계 — 개발 계획:
```
/pdca plan {기능명}
constitution.md 파일을 읽고 모든 원칙을 반드시 준수해서 개발 계획을 세워줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 색상·크기·간격·그림자·둥글기는 design-tokens.css의 CSS 변수를 사용해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 개발 계획을 세워줘.
```

2단계 — 상세 설계:
```
/pdca design {기능명}
constitution.md 파일을 읽고 모든 원칙을 준수해서 상세 설계를 작성해줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 UI 수치를 var(--토큰명) 형태로 명시해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 상세 설계를 작성해줘.
```

3단계 — 코드 구현:
```
/pdca do {기능명}
constitution.md 파일을 읽고 모든 원칙을 반드시 준수해서 구현해줘.
designs/design.md와 designs/design-tokens.css를 읽고, 모든 CSS 스타일링에서 var(--토큰명) 형태로 참조해줘. 하드코딩 금지.
@vercel-react-best-practices 가이드라인을 읽고 이 기준에 맞춰 구현해줘.
```

4단계 — Gap 분석:
```
/pdca analyze {기능명}
```

5단계 — 자동 개선 (Match Rate < 90%):
```
/pdca iterate {기능명}
```

정리 — 코드 정리 (Match Rate ≥ 90%):
```
/simplify
```

보고서:
```
/pdca report {기능명}
```

### Step 3: 단계별 세부 안내

감지된 단계에 따라 아래 내용을 포함하여 안내합니다:

1. **현재 위치**: 몇 단계인지
2. **완료된 산출물**: 이미 생성된 파일 목록
3. **다음 단계 설명**: 왜 이 단계인지, 무엇이 생성되는지
4. **실행 명령어**: 복사해서 바로 쓸 수 있는 완성된 명령어 (헌법·디자인 헌법 참조 포함)
5. **주의사항**: 해당 단계에서 특히 주의할 점

---

## 출력 형식

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📍 현재 단계: [N단계. 단계명]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁 완료된 산출물:
  ✅ [파일/단계명]

⏭️  다음 단계: [N+1단계. 다음 단계명]
   [다음 단계가 무엇을 하는지 1~2줄 설명]

🔧 실행 명령어:
┌─────────────────────────────────────
│ [복사 가능한 완성된 명령어]
└─────────────────────────────────────

💡 참고사항:
  • [주의사항 또는 선택적 단계 안내]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 특수 상황 처리

**constitution.md가 없는 경우**:
"constitution.md가 없습니다. sb-flow setup을 다시 실행하거나 constitution.md를 프로젝트 루트에 복사해주세요." 라고 안내합니다.

**designs/ 파일이 없는 경우**:
"designs/design.md 또는 designs/design-constitution.md가 없습니다. `/sb-design` 명령어로 .pen 파일에서 디자인 시스템을 추출하거나, sb-flow setup을 다시 실행해주세요." 라고 안내합니다.
