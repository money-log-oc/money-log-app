# MONEYLOG TASK.md

기준: 2026-03-04
목표: 실서비스 가능한 v1 완성 (서버/앱/인증/배포)

---

## A. AGENT TASK (내가 할 일)

### A1) Backend Architecture (Hexagonal)
- [x] `service` 잔여 비즈니스 로직을 `application usecase`로 이관
- [x] `adapter-in(web)` / `application` / `port` / `adapter-out` 경계 완성
- [x] 레거시 `/api/v1/*` 의존 제거 준비(호환 레이어 최소화)

### A2) Backend API (DoD: 구현+Swagger+테스트)
- [x] Budget API 최종화 + Swagger + 테스트
- [x] Home Summary API 최종화 + Swagger + 테스트
- [x] Transaction API(조회/태그/제외) 최종화 + Swagger + 테스트
- [x] Report API(월별 태그/일별 지출) 최종화 + Swagger + 테스트
- [x] 공통 에러 응답/코드 표준화

### A3) Security/Auth
- [x] Spring Security JWT 실검증 로직 연결
- [x] Auth 엔드포인트에서 카카오 토큰 검증 연동
- [x] Access/Refresh 발급/재발급 정책 구현
- [x] 보호 API 인증 필수 적용 + 인가 기본 정책(USER)

### A4) Data/Infra
- [x] Flyway 도입 및 마이그레이션 스크립트 작성
- [x] local/dev/prod profile 동작 검증
- [x] 로컬 docker postgres + 서버 실행 가이드 검증
- [x] Railway 스모크테스트 자동화

### A5) Flutter App
- [x] 로그인(카카오) -> 서버 auth 연동
- [x] 토큰 저장(secure storage) + 자동 로그인
- [x] 홈 실데이터 바인딩 안정화
- [x] 내역(필터/태그/제외) UX 완성 및 API 반영
- [x] 리포트 실데이터/빈상태/에러상태 완성
- [x] 설정(월급일/예산 수정) API 연동

### A6) Docs/Ops
- [x] Swagger 최종 노출 확인 (`/swagger-ui.html`)
- [x] `API_STATUS.md`, `HEXAGONAL_PLAN.md` 지속 갱신
- [x] 릴리즈 체크리스트 문서화

---

## B. USER TASK (규혁이 해줘야 하는 것)

### B1) Kakao Developer (필수)
- [ ] Kakao Developers 앱 준비
- [ ] iOS 플랫폼/번들ID 등록
- [ ] Redirect URI 확정
- [ ] 동의항목(이메일/프로필) 확정
- [ ] `KAKAO_REST_API_KEY`, `KAKAO_REDIRECT_URI` 제공

### B2) 보안/정책 값 제공
- [ ] `JWT_SECRET` 운영용 강한 키 제공
- [ ] 토큰 만료 정책 결정 (예: access 30m / refresh 14d)

### B3) 배포/스토어
- [ ] Apple Developer/App Store Connect 준비
- [ ] TestFlight 배포 정책 확정

### B4) 운영 승인
- [ ] Railway 환경변수 반영 승인
- [ ] 운영 도메인/노출 정책 승인

---

## C. 진행 규칙
- API 단위 완료 기준(DoD): **구현 + Swagger + 테스트**
- 보고 형식:
  - `[완료] 작업명`
  - `commit: <hash>`
  - `검증: <내용>`
  - `[시작] 다음작업`
- 하드 규칙:
  - 커밋 해시 없는 완료 보고 금지
  - 20분 이상 커밋 없으면 `[막힘]/[필요]/[재개]` 보고 먼저

---

## D. Feature-sharp backlog (AGENT)
- [ ] Weekly Pace Engine: 월급일 사이클 + 주간 한도 계산식(롤오버 포함) 고정
- [ ] Recovery Coach: 초과 감지 + 남은 기간 복구 플랜 제시
- [ ] Fast Classification UX: 미분류 우선 정렬 + 1탭 태그/제외 + 최근 태그 추천
- [ ] Real Report Utility: 월 태그 TOP3 + 전월 대비 + 새는 소비 인사이트 카드
- [ ] MVP Polish: v11 기준 간격/타이포 + 로딩/빈상태/에러 UX 통일

## E. Next 3 (즉시 실행 순서)
1. [ ] (USER) Kakao 키/리다이렉트 값 전달 (`KAKAO_REST_API_KEY`, `KAKAO_REDIRECT_URI`, `KAKAO_NATIVE_APP_KEY`)
2. [ ] (USER) 운영 `JWT_SECRET` 및 토큰 만료 정책(access/refresh) 확정
3. [ ] (AGENT) 사용자 값 반영 후 Railway 운영 환경변수 적용 + prod 스모크 재검증
