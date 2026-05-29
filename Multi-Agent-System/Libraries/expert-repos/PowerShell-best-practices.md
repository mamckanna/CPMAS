# PowerShell Best Practices (Expert Reference)

## Error Handling
- Use `-ErrorAction` and `-ErrorVariable` for robust error capture and control.
- Validate errors with `Should -Throw -ErrorId` in Pester tests, not just error messages.
- Use `try/catch` for terminating errors and check `$?` for non-terminating errors.
- Prefer `SilentlyContinue` for negative test cases to avoid test interruption.

## File IO
- Always check file existence with `Test-Path` before reading/writing.
- Use `TESTDRIVE:` for all test file operations to ensure isolation and cleanup.
- Clean up files in `AfterAll` or `finally` blocks.

## Test Patterns
- Use `BeforeAll`/`AfterAll` for setup/teardown.
- Use `-TestCases` for parameterized tests.
- Avoid free code in `Describe` blocks—use setup blocks.
- Validate both expected output and error state.

## Debugging
- Output `$Error`, `$LASTEXITCODE`, and relevant file contents on failure.
- Use `Write-Verbose` and `Write-Debug` for traceability.
- Add a debug checklist to step through: param validation → file existence → error handling → output validation.

## Canonical Patterns
- Use `Should -BeOfType` to validate error types.
- Always check both `$?` and `$Error` after script invocation.
- Use `Mock` for external dependencies in tests.
- Use `Context` blocks to group related test cases.

---

**See also:**
- [PowerShell Debug Checklist](./debug-checklist.md)
- [PowerShell expert repos](./PowerShell.md)
- [awesome-copilot](./awesome-copilot.md)
- [MAS core validation patterns](../core/validation-and-recovery.md)
