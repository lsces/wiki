# Wiki Package — Developer Notes

Dated history: decisions, bugs found, why things are the way they are. For the current
architecture/reference — the transaction-safety mechanism itself and the stuck-transaction
diagnostic — see `MANUAL.md` instead.

## 2026-06-18 — found: `BitPage::store()` had no `RollbackTrans()` fallback

`BitPage::store()` wrapped the entire save in `StartTrans()`/`CompleteTrans()` with no
`RollbackTrans()` fallback. If an exception escaped (e.g. from the nested `LibertyMime::store()`
call), `CompleteTrans()` never ran and Firebird was left with an open transaction holding locks
on `wiki_pages`/`liberty_content` rows — symptom: wiki pages return "page not found" with no
visible error until Firebird is restarted. Documented here first, not yet fixed — flagged not to
patch speculatively, confirm via `MON$TRANSACTIONS` first (see `MANUAL.md`'s diagnostic).

## 2026-07-31 — fixed, two ways the same day

**Direct fix** (`wiki` commit `28a337b`): `store()`'s body split into a private
`storeInTrans()`, called from inside a real `try`/`catch` with `RollbackTrans()` on the
`catch` — matches the fix this file originally sketched as a plan. See `MANUAL.md` for the
current shape.

**Same day, independently**: the kernel-level transaction shutdown safety net
(`bit_shutdown_handler()`) was built the same day, originating from this exact bug — see
`kernel/CLAUDE.md`'s 2026-07-31 entry. Belt-and-suspenders: the direct fix here handles the
catchable-exception case with a real error message, the kernel net covers anything that reaches
a fatal error instead (which skips try/catch entirely). This file previously described the bug
as still open/unconfirmed for over a month after the actual fix landed — caught and corrected
2026-08-22 during a documentation sweep, not from any fresh investigation.
