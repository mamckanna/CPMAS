# PowerShell Debug Checklist

1. Are all parameters validated defensively?
2. Are all file paths checked with `Test-Path` before use?
3. Are all errors captured with `-ErrorVariable` and validated with `Should -Throw -ErrorId`?
4. Are test files created in `TESTDRIVE:` and cleaned up?
5. Is output validated for both success and failure cases?
6. Are verbose/debug messages used for traceability?
7. Are all test cases parameterized and grouped logically?

Use this checklist for every PowerShell script, hook, and test to ensure robust, expert-level quality and easier debugging.

---

**See also:**
- [PowerShell Best Practices](./PowerShell-best-practices.md)
- [PowerShell expert repos](./PowerShell.md)
- [awesome-copilot](./awesome-copilot.md)
- [MAS core validation patterns](../core/validation-and-recovery.md)
