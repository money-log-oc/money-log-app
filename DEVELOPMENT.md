# Moneylog App – Dev Notes

## Current status
- v11-aligned UI skeleton implemented
- API bound screens:
  - Home: `/api/v1/home/summary`
  - Transactions: `/api/v1/transactions`
  - Report: `/api/v1/reports/monthly-tags`
- Transaction classify flow:
  - tag update / exclude update via PATCH APIs
- Kakao login skeleton wired to `/api/v1/auth/kakao`

## Run target
- Flutter iOS-first
- `API_BASE_URL` via `--dart-define=API_BASE_URL=...`

## Next action checklist
1. Real Kakao SDK integration (replace dev token)
2. Persist auth session (secure storage)
3. UX polish for transaction bottom-sheet v11 fidelity
4. Add widget tests for Home/Transactions loading+error state
