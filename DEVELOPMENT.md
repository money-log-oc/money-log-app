# Moneylog App – Dev Notes

## Current status
- v11-aligned UI skeleton implemented
- API bound screens:
  - Home: `/api/v1/home/summary`
  - Transactions: `/api/v1/transactions`
  - Report: `/api/v1/reports/monthly-tags`
- Transaction classify flow:
  - tag update / exclude update via PATCH APIs
- Kakao SDK login wired to `/api/auth/kakao`
- Auth session persisted with `flutter_secure_storage`
- Auto-login enabled via app startup session restore (`AuthSession.initialize`)
- `MoneylogApi` now sends Bearer access token and retries once after refresh-token reissue on 401/403
- Home UI binds cycle range(`cycle.endAt`) to remaining-days indicator

## Run target
- Flutter iOS-first
- `API_BASE_URL` via `--dart-define=API_BASE_URL=...`
- `KAKAO_NATIVE_APP_KEY` via `--dart-define=KAKAO_NATIVE_APP_KEY=...`

## Next action checklist
1. Add widget tests for Home/Transactions/Report loading+error state
2. 로그인 실패 유형별 메시지 정교화 (취소/네트워크/권한)
3. v1 라우트 제거 전 앱 라우트 최종 점검(`/api/*` only)
4. 설정 스크린 입력 UX 개선(숫자 포맷/유효성 메시지)
