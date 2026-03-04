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
1. 홈 실데이터 바인딩 안정화
2. UX polish for transaction bottom-sheet v11 fidelity
3. Add widget tests for Home/Transactions loading+error state
4. 로그인 실패 유형별 메시지 정교화 (취소/네트워크/권한)
