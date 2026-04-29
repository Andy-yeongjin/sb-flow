# NeonDB 연결 가이드

> **사람이 가입·설정하는 단계 + Claude에게 시킬 프롬프트가 섞인 하이브리드 가이드**
> 회원가입과 콘솔 작업은 사람이 직접 하고, 코드 연결은 프롬프트를 복사해서 Claude에게 맡깁니다.

---

## 이 가이드를 쓰는 시점

`/sb-oneshot`으로 기능 개발이 끝났고, 이제 **로컬 메모리/파일 저장 대신 진짜 PostgreSQL 데이터베이스**에 데이터를 저장해야 할 때 사용하세요.

기본 스택 가정: **Next.js (App Router) + Prisma**

---

## 1단계 — NeonDB 가입 (사람)

1. [https://neon.tech](https://neon.tech) 접속
2. 우측 상단 **Sign Up** → **Continue with GitHub** (또는 Google)
3. 약관 동의 후 가입 완료

> 무료 플랜으로 충분합니다. 신용카드 등록 불필요.

---

## 2단계 — 프로젝트 생성 (사람)

1. 가입 후 자동으로 **New Project** 화면이 뜹니다 (안 뜨면 좌측 상단 프로젝트 드롭다운 → **New Project**)
2. 입력 항목:
   - **Project name**: 프로젝트 이름 (예: `my-app`)
   - **Postgres version**: 기본값(최신) 그대로
   - **Region**: `AWS Asia Pacific 1 (Singapore) — ap-southeast-1` 선택 (한국 사용자 기준 가장 가까운 무료 리전)
3. **Create Project** 클릭

---

## 3단계 — Connection String 복사 (사람)

1. 프로젝트 생성 직후 화면에서 **Connection String** 클릭
2. **Connection pooling** 토글 **켜짐** 상태 확인 (Vercel 서버리스 환경 필수)
3. 하단 **Copy snippet** 클릭해 connection string 복사

복사한 문자열은 아래 형태입니다 (예시):

```
postgresql://username:password@ep-xxxxx-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require
```

> ⚠️ 이 문자열은 **비밀번호가 포함된 자격증명**입니다. Slack/Discord/GitHub에 붙여넣지 마세요.

### 직접 연결 string도 추가로 복사 (마이그레이션용)

같은 화면에서 **Connection pooling** 토글을 **끄고** 하단 **Copy snippet**을 다시 클릭해 복사하세요. 이건 별도로 보관해 둡니다.

```
postgresql://username:password@ep-xxxxx.ap-southeast-1.aws.neon.tech/neondb?sslmode=require
```

> Prisma는 마이그레이션 시 **풀링 안 된 직접 연결**을 별도로 요구합니다.

---

## 4단계 — Claude에게 연결 시키기 (프롬프트 복사)

Claude Code 대화창에 아래 프롬프트를 그대로 붙여넣고, **`<여기에_POOLED_URL_붙여넣기>`** 와 **`<여기에_DIRECT_URL_붙여넣기>`** 두 군데만 3단계에서 복사한 값으로 교체하세요.

````
constitution.md를 읽고 모든 원칙을 준수해줘. 특히 보안(API 키/DB 자격증명을 코드에 하드코딩 금지, .env로만 관리, .gitignore에 .env 포함 확인).

NeonDB(PostgreSQL)를 이 프로젝트에 Prisma ORM으로 연결해줘. 현재 이 프로젝트는 sqlite로 개발 중일 가능성이 높으니, **기존 sqlite 스키마와 모델 정의를 반드시 먼저 확인하고 그대로 이관**해야 한다. 아래 절차를 순서대로 수행해:

0. 현재 상태 점검 (가장 먼저)
   - prisma/schema.prisma 가 있는지 확인하고 있으면 datasource provider, model 정의를 모두 읽어줘
   - 코드 내에서 prisma.* 호출이 어떤 모델·필드를 사용하는지 grep으로 파악
   - 위 두 가지를 본 뒤에 이관 계획을 한 줄로 요약해서 알려줘 (어떤 모델 N개를 어떻게 옮길지)

1. 의존성 확인
   - prisma (devDependency), @prisma/client 가 설치되어 있는지 확인 (없으면 설치)
   - prisma/schema.prisma 가 이미 있으면 그걸 기준으로 작업, 없으면 npx prisma init

2. .env 파일에 아래 두 환경변수 작성 (이미 있으면 갱신):
   DATABASE_URL="<여기에_POOLED_URL_붙여넣기>"
   DIRECT_URL="<여기에_DIRECT_URL_붙여넣기>"
   기존에 sqlite용 DATABASE_URL="file:./dev.db" 가 있었다면 위 값으로 교체.

3. prisma/schema.prisma 수정:
   - datasource db 블록의 provider를 "postgresql"로 (현재 "sqlite"였다면 교체)
   - url을 env("DATABASE_URL")로
   - 같은 블록에 directUrl = env("DIRECT_URL") 추가
   - **기존 model 정의는 가능한 그대로 유지**. sqlite ↔ postgresql 간 타입 차이가 있는 부분만 PostgreSQL에 맞게 미세 조정 (예: Int autoincrement 동작, Bytes, DateTime 정밀도, @default(now()) 등)
   - 정의된 model이 하나도 없을 때만, 현재 코드베이스에서 사용 중인 데이터 모델(메모리/파일/JSON)을 분석해서 새로 정의

4. 기존 sqlite 마이그레이션 정리:
   - prisma/migrations/ 폴더가 sqlite 기준으로 만들어져 있다면 PostgreSQL과 호환되지 않으므로 폴더 통째로 삭제
   - 로컬 dev.db, *.db, *.db-journal, prisma/dev.db 가 .gitignore에 포함되어 있는지 확인 (없으면 추가)

5. 마이그레이션 실행:
   - npx prisma migrate dev --name init
   - npx prisma generate

6. lib/prisma.ts(또는 lib/db.ts) 싱글톤 클라이언트 생성 — Next.js 개발 모드 hot reload 시 연결 풀 누수 방지 패턴 적용 (globalThis에 캐싱). 이미 있으면 건너뛰어.

7. 기존에 메모리/파일/sqlite로 데이터를 읽고 쓰던 부분을 모두 Prisma 클라이언트 호출로 교체해줘. Server Actions / Route Handlers 안에서만 사용하고, 클라이언트 컴포넌트에는 절대 import하지 말 것.

8. .gitignore에 .env, .env*.local이 포함되어 있는지 확인하고 없으면 추가해줘.

9. 마지막에 npm run build로 프로덕션 빌드 검증해줘 (constitution 제10조).

작업 후 어떤 파일이 추가/변경됐고, sqlite에서 가져온 모델이 무엇인지, 새로 추가한 모델이 무엇인지 요약해줘.
````

---

## 5단계 — 연결 확인 (프롬프트 복사)

Claude Code 대화창에 아래 프롬프트를 붙여넣으면 Claude가 자동으로 검증 스크립트를 작성·실행하고 결과를 표로 보고합니다.

````
방금 연결한 NeonDB가 정상 동작하는지 다음 절차로 검증하고 결과를 표로 보고해줘:

1. 연결 ping
   - lib/prisma.ts (또는 동일한 싱글톤)을 import한 임시 스크립트 scripts/check-db.ts 를 만들어서
     await prisma.$queryRaw`SELECT 1 as ok` 실행 → 결과 출력
   - tsx 또는 ts-node로 실행: npx tsx scripts/check-db.ts

2. 마이그레이션 상태 점검
   - npx prisma migrate status 실행해서 "Database schema is up to date" 가 나오는지 확인

3. 모델별 row count
   - schema.prisma 안의 모든 model에 대해 prisma.<model>.count() 를 호출해서
     | 모델명 | row count | 비고 | 형식의 표로 정리

4. 임시 INSERT/SELECT/DELETE 라운드트립
   - 가장 단순한 모델 하나(예: User 같은 단일 PK 모델)를 골라
     테스트용 row 1개 insert → 같은 조건으로 select 해서 일치 확인 → delete
   - 모델이 없으면 _HealthCheck 라는 임시 모델을 만들지는 말고 그냥 3번까지만 하고 4번은 "스킵: 적절한 모델 없음"으로 보고

5. 종료 정리
   - scripts/check-db.ts 는 작업이 끝나면 삭제 (또는 원하면 유지하고 .gitignore에 추가 여부 물어봐줘)
   - 어떤 단계에서 어떤 출력이 나왔는지 그대로 보고
   - 실패가 있다면 에러 코드(P1001/P1003/P2021 등)와 가장 가능성 높은 원인 한 줄

마지막에 "✅ 연결 정상 / ⚠️ 부분 정상 / ❌ 실패" 중 하나로 한 줄 결론을 내려줘.
````

> **UI로 직접 보고 싶다면 (선택)**: NeonDB 대시보드 → 좌측 **Tables** 탭에서 동일한 테이블이 생성됐는지 확인 가능합니다. 또는 `npx prisma studio`로 로컬 GUI(localhost:5555)에서 데이터를 직접 조작할 수 있어요.

검증이 ✅로 끝났다면 NeonDB 연결 완료. 다음은 [Vercel 배포 가이드](./vercel-guide.md).

---

## 자주 묻는 질문

**Q. Pooled / Direct 두 개를 왜 다 받나요?**
- **Pooled (DATABASE_URL)**: 앱 런타임이 사용. Vercel 서버리스 함수가 매번 새 연결을 만들어 NeonDB를 터뜨리지 않도록 풀링.
- **Direct (DIRECT_URL)**: `prisma migrate`가 사용. 마이그레이션은 풀링된 커넥션 위에서 실행할 수 없음.

**Q. 무료 플랜 한계는?**
- 0.5 GB 스토리지, 1개 프로젝트, 자동 스케일 다운(미사용 시 슬립). 초기 개발/소규모 프로덕션에 충분합니다.

**Q. 프로덕션 배포 시 환경변수는?**
[Vercel 배포 가이드](./vercel-guide.md) 4단계에서 동일한 `DATABASE_URL` / `DIRECT_URL`을 Vercel 환경변수에 등록합니다.

**Q. Drizzle을 쓰고 싶어요**
3단계에서 받는 connection string은 ORM과 무관한 표준 PostgreSQL URL이라 그대로 사용 가능합니다. 4단계 프롬프트에서 "Prisma ORM" → "Drizzle ORM" 으로 바꾼 뒤 Drizzle 절차(drizzle-kit, drizzle.config.ts)로 시켜주세요.

**Q. 자격증명을 실수로 GitHub에 푸시했어요**
즉시 NeonDB 대시보드 → **Settings** → **Reset password**로 비밀번호 재발급 후 새 connection string으로 `.env` 갱신하세요. GitHub에서 파일을 지우는 것만으로는 git history에 남아 누출된 상태입니다.
