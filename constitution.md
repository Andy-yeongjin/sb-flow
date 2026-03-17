<!--
Sync Impact Report
- Version change: 1.9.1 → 1.10.0
- List of modified principles:
  - [ADDED/REORDERED] 제5조: 프론트엔드 아키텍처 및 품질 (Vercel React Best Practices 준수 의무화)
  - [RENUMBERED] 제6조 ~ 제14조 (기존 제5조 ~ 제13조가 한 단계씩 뒤로 이동)
- Added sections: None
- Removed sections: None
- Templates requiring updates (✅ updated):
  - .specify/memory/constitution.md (✅)
  - .specify/templates/plan-template.md (✅)
  - .specify/templates/spec-template.md (✅)
  - .specify/templates/tasks-template.md (✅)
  - .specify/templates/checklist-template.md (✅)
  - .specify/templates/agent-file-template.md (✅)
- Follow-up TODOs: None
-->

**제0조 (표준 문서의 한글 작성 원칙): 본 프로젝트의 모든 명세서, 계획서, 작업 리스트 및 표준 문서는 반드시 한글로 작성합니다. 이는 AI와 개발자 간의 보편 언어(DDD) 준수 및 정확한 의사소통을 위한 절대 원칙입니다. 모든 템플릿 파일은 반드시 상단에 `지침: 모든 계획서 내용은 반드시 한글로 작성합니다.`를 포함해야 합니다.**

# 프로젝트 개발 헌법 (Project Development Constitution)

## 핵심 원칙 (Core Principles)

### 제1조: 명세 우선 원칙 (SDD - Specification Driven Development)
코드보다 명세가 우선합니다. 모든 기능 개발과 수정은 코드를 작성하기 전, `SPEC.md` 또는 OpenAPI 문서의 업데이트로부터 시작합니다. 명세는 '진실의 원천(Single Source of Truth)'이며, AI와 개발자는 구현된 코드보다 명세서의 텍스트를 우선적인 지표로 삼아 판단합니다.

### 제2조: 보편 언어 준수 (DDD - Domain Driven Design)
기획, 명세, 코드, 데이터베이스 필드명은 동일한 단어를 사용합니다(용어의 단일화). 변수명과 함수명은 기술적 구현(예: `getDataFromDB`)이 아닌 비즈니스 의도(예: `calculateTotalAmount`)를 나타내야 하는 '도메인 중심 명명'을 엄격히 준수합니다.

### 제3조: 도메인 무결성 (Business Logic Isolation)
핵심 비즈니스 규칙은 프레임워크나 외부 라이브러리에 의존하지 않는 순수 로직 영역에 격리합니다. 데이터만 있는 객체가 아닌, 자신의 데이터가 유효한지 스스로 검증하고 로직을 수행하는 '똑똑한 도메인 모델'을 지향합니다.

### 제4조: 결합도와 응집도 (Architecture & Context)
각 도메인 영역(Bounded Context)은 서로의 내부 구현을 몰라야 하며, 명확하게 정의된 인터페이스를 통해서만 통신합니다. 인프라스트럭처(DB, 외부 API 등)는 언제든 교체 가능하도록 플러그인 구조로 설계하여 핵심 로직이 이에 영향을 받지 않도록 합니다.

### 제5조: 프론트엔드 아키텍처 및 품질 (Frontend Architecture & Quality)
모든 프론트엔드 아키텍처 설계와 구현은 `Vercel React Best Practices`를 최우선으로 준수해야 합니다. 이는 성능, 가독성, 유지보수성을 극대화하기 위한 프로젝트의 절대 규칙이며, 모든 UI 컴포넌트와 상태 관리 로직은 이 가이드라인에 따라 검증됩니다.

### 제6조: 기술적 무결성 및 보안 (Technical Integrity & Security)
모든 데이터 구조는 TypeScript로 엄격히 정의하며, 데이터의 ACID 특성을 보장합니다. 모든 접근은 세션 검증을 필수로 하며, 핵심 로직에 대한 단위 테스트와 구조화된 로깅을 통해 관측 가능성(Observability)을 확보합니다.

### 제7조: 반응형 디자인 및 사용자 경험 (Responsive UX)
다양한 기기(데스크탑, 태블릿, 모바일)에서 최적화된 경험을 제공하는 반응형 디자인을 원칙으로 합니다. 화면 크기에 상관없이 데이터의 가독성과 인터랙션의 일관성을 유지하며, 웹 접근성(a11y) 표준을 준수하여 모든 사용자가 차별 없이 정보를 파악할 수 있도록 합니다.

### 제8조: 검증의 의무 (Verification & Testing)
모든 기능 구현은 반드시 그 정당성을 증명하는 테스트 코드를 동반해야 합니다. 특히 API나 복잡한 비즈니스 로직은 메인 코드베이스에 반영하기 전, 독립적인 테스트 스크립트(예: 단위 테스트, API 호출 테스트)를 작성하여 선검증하는 과정을 거칩니다. 테스트를 통과하지 못한 코드는 '미완성'으로 간주하며 반영하지 않습니다.

### 제9조: 명세-코드 동기화 (Specification-Code Sync)
AI와 개발자는 코드 수정 시 반드시 관련된 명세서(`SPEC.md`)와 작업 리스트(`TASKS.md`)를 먼저 최신화합니다. 코드와 명세 사이에 불일치가 발생할 경우, 명세서를 '진실의 원천'으로 삼아 코드를 수정하며, 이를 통해 프로젝트의 지속 가능한 유지보수성을 확보합니다.

### 제10조: 최종 빌드 검증 (Final Build Validation)
모든 개발 작업의 최종 단계는 프로덕션 환경과 동일한 조건에서의 '성공적인 빌드'입니다. 단순한 기능 구현을 넘어 전체 프로젝트가 오류 없이 빌드되는지 확인하고, 최종 결과물의 무결성을 검증한 후에만 해당 작업을 '완료'로 정의합니다.

### 제11조: 보안 및 기밀 유지 (Security & Confidentiality)
모든 소스 코드와 설정 파일에서 API 키, 개인 토큰, 비밀번호 등 민감한 정보의 노출을 엄격히 금지합니다. GitHub에 코드를 푸시하거나 서비스를 배포하기 전, 반드시 `.env` 파일의 격리 상태와 코드 내 하드코딩된 비밀 정보가 없는지 전수 검사합니다. 환경 변수는 반드시 안전한 관리 도구(Secret Manager 등)를 통해 관리하며, 실수로 노출된 경우 즉시 토큰을 무효화하고 재발급합니다.

### 제12조: 결정의 기록 (Decision Documentation - ADR)
중요한 아키텍처 결정이나 특정 기술 도입, 혹은 비즈니스 정책의 변화에 대해서는 '왜(Why)' 그렇게 결정했는지에 대한 근거를 간략히 기록(ADR - Architecture Decision Record)합니다. 이는 미래의 개발자가 과거의 맥락을 오해하지 않고 유지보수할 수 있도록 돕는 필수적인 자산입니다.

### 제13조: 예외 처리 및 사용자 피드백 (Error Handling & Feedback)
모든 예외 상황은 개발자용 상세 로그(Log)와 사용자용 안내 메시지를 명확히 분리하여 처리합니다. 시스템 오류 발생 시에도 사용자는 현재 상황을 이해하고 다음 행동을 취할 수 있는 구체적인 가이드를 받아야 하며, 서비스는 예외 상황에서 비정상 종료 없이 안전하게 복구(Resilience)되어야 합니다.

### 제14조: 구조화된 로깅 및 관측 가능성 (Structured Logging & Observability)
시스템의 모든 주요 상태 변화와 비즈니스 흐름, 그리고 예외 상황은 반드시 구조화된 형태(Structured Logging)로 기록합니다. 로그는 단순한 텍스트가 아닌 분석 가능한 데이터(JSON 등)로 구성하며, 서비스 장애 추적을 위해 요청 식별자(Request ID)와 맥락(Context)을 포함해야 합니다. 기록된 로그는 시스템의 건강 상태를 모니터링하고 신속한 장애 조치를 위한 핵심 지표로 활용하며, 제10조(보안)에 따라 민감한 개인 정보는 로그 기록에서 엄격히 제외합니다.

## 기술 스택 (Technology Stack)

- **Framework**: Next.js (App Router)
- **Language**: TypeScript (Strict Mode)
- **Database**: PostgreSQL (Neon, Supabase 등)
- **ORM**: Prisma 또는 Drizzle
- **Styling**: Vanilla CSS (CSS Modules)
- **Security**: Auth.js (NextAuth) 또는 유사 세션 관리

## 거버넌스 (Governance)

- **헌법 우선순위**: 이 헌법은 프로젝트의 모든 개발 관행에 우선하며, 모든 산출물은 헌법의 원칙을 반영해야 합니다.
- **변경 절차**: 원칙의 변경은 버전 번호를 갱신하며, 변경 이력(Sync Impact Report)을 문서 상단에 기록합니다.
- **버전 정책**: MAJOR(원칙 재정의), MINOR(원칙 추가/확장), PATCH(문구 수정).
- **템플릿 준수**: 모든 명세서, 계획서, 작업 리스트 템플릿은 반드시 상단에 `지침: 모든 계획서 내용은 반드시 한글로 작성합니다.`를 포함해야 하며, 이를 통해 제0조를 산출물 수준에서 강제합니다.

**Version**: 1.10.0 | **Ratified**: 2026-02-26 | **Last Amended**: 2026-03-10
