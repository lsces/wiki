# Wiki Package — Developer Notes

## BitPage::store() — missing RollbackTrans
`BitPage::store()` (line 220) wraps the entire save in `StartTrans()` / `CompleteTrans()`
but has no `RollbackTrans()` fallback. If an exception escapes — e.g. from the nested
`LibertyMime::store()` call at line 222, which has its own `StartTrans()` — `CompleteTrans()`
never runs and Firebird is left with an open transaction holding locks on `wiki_pages`
and/or `liberty_content` rows.

Symptom: wiki pages return "page not found" until Firebird is restarted. The failed save
appears to cause no visible error, but the stuck transaction blocks subsequent access to
the affected rows.

**Diagnostic** — run in isql when stuck:
```sql
SELECT t.MON$TRANSACTION_ID, t.MON$TIMESTAMP,
       s.MON$SQL_TEXT, s.MON$STATE
FROM MON$TRANSACTIONS t
LEFT JOIN MON$STATEMENTS s ON s.MON$TRANSACTION_ID = t.MON$TRANSACTION_ID
WHERE t.MON$STATE = 1;
```

**Fix** — wrap the body of `store()` in a try/catch with `RollbackTrans()`:
```php
$this->StartTrans();
try {
    // ... existing body ...
    $this->CompleteTrans();
} catch( \Exception $e ) {
    $this->mDb->RollbackTrans();
    $this->mErrors['store'] = $e->getMessage();
}
```

Do not action until confirmed via `MON$TRANSACTIONS` — use xdebug or the monitoring
query above to verify this is the actual call stack before patching.
