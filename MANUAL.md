# Wiki Package — Reference Manual

How the package actually works today. For the history of *why* — decisions, bugs found, wrong
turns — see `CLAUDE.md`'s dated session log instead; this file only tracks current behaviour.

## `BitPage::store()` — transaction safety

`BitPage::store()` wraps its body (`storeInTrans()`, split out specifically so this works) in a
`StartTrans()`/`try`/`CompleteTrans()`/`catch`/`RollbackTrans()` block — any exception escaping
the save (e.g. from a nested `LibertyMime::store()`) rolls the transaction back explicitly
rather than leaving it open. This is additionally backstopped by the kernel-level transaction
shutdown safety net (see `kernel/MANUAL.md`/`CLAUDE.md`) for anything that reaches a fatal
error rather than a catchable exception — the two are complementary, not redundant: the
try/catch handles the common case cleanly with a real error message in `mErrors`, the kernel net
catches whatever a request-ending fatal skips past.

**Diagnostic** — if a page ever returns "page not found" and a stuck Firebird transaction is
suspected, check directly rather than guessing:
```sql
SELECT t.MON$TRANSACTION_ID, t.MON$TIMESTAMP,
       s.MON$SQL_TEXT, s.MON$STATE
FROM MON$TRANSACTIONS t
LEFT JOIN MON$STATEMENTS s ON s.MON$TRANSACTION_ID = t.MON$TRANSACTION_ID
WHERE t.MON$STATE = 1;
```
