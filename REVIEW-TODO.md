# PS.Log Review — Working Checklist

Temporary tracker for the cleanup work on branch
`feature/standards-and-correctness-cleanup` (issue #18, PR #19).

Delete this file before merging.

Legend: `[ ]` open · `[x]` done · `[~]` in progress · `[-]` won't do (with note)

---

## PR 1 — Correctness & security

- [x] **Path validator is a no-op.** Replaced with `(Test-Path -Path $_ -PathType 'Leaf') -and $_ -like '*.log'`
      across all five files.
- [x] **`-Id` `ValidateRange` mismatch.** Normalized to `0..999999` across all four writers.
- [x] **`Build/build.ps1` invalid parameter.** Dropped the `-ForegroundColor 'Yellow'`.
- [x] **`throw` -> `Write-Error`** in `Start-Log` (now includes the conflicting file path).
- [x] **Log injection.** All four writers strip `[\r\n]+` -> literal `\n` before `Add-Content`.
- [x] **Path traversal in `Start-Log`.** `-Name` now uses `[ValidatePattern('^[\w.\-]+$')]`.
- [x] **`Start-Log` parent-only validator.** Dropped; `-Directory` now uses `[ValidateNotNullOrEmpty()]`
      (the `Begin` block already creates the directory if missing).
- [x] **Copy-paste SYNOPSIS/DESCRIPTION** fixed in `Write-LogError` / `Write-LogWarn` / `Write-LogDebug`.
      (Remaining `.PARAMETER` / `.EXAMPLE` copy-paste is help text only — covered under PR 2.)

## PR 2 — Standards alignment

- [ ] **`PowerShellVersion = '4.0'`** -> `'5.1'` in `PS.Log.psd1`.
- [ ] **Add `CompatiblePSEditions = @('Core','Desktop')`** to `PS.Log.psd1`.
- [ ] **Add `[OutputType()]`** to every function:
  - `Start-Log` -> `[OutputType([System.String])]`
  - `Stop-Log`, `Write-LogInfo`, `Write-LogError`, `Write-LogWarn`, `Write-LogDebug`
    -> `[OutputType([System.Void])]`
- [ ] **`.NOTES Status:` line** on every function (e.g., `Status: Stable`). Drop "General notes".
- [ ] **Rewrite `.psm1` dot-source loop** per `module-structure.md`:
      `$dirs = @("$PSScriptRoot\Public", "$PSScriptRoot\Private")` -> use the canonical
      `Get-ChildItem -Path $dirs -Filter '*.ps1'` pattern with `-f` / `Join-Path` if any
      interpolation remains.
- [ ] **Replace `New-Item -ItemType "Directory"`** with single-quoted `'Directory'` in `Start-Log`.
- [ ] **Add `-Path` to `Test-Path $Directory`** in `Start-Log` (explicit parameter names).
- [ ] **Typo:** "Paraent" -> "Parent" in `Start-Log` `.PARAMETER Directory` help.
- [ ] **`PS.Log.psd1` header comment** says `module 'PSLog'`; correct to `PS.Log`.
- [ ] **Recommended:** add `Tags` and `LicenseUri` to `PSData` in `PS.Log.psd1`.

## PR 3 (follow-up, separate branch/issue) — Tests & CI

- [ ] **Per-function Pester tests** under `Tests/Unit/` for each of the six exported
      functions, following the skeleton in `pester-testing.md`.
- [ ] **Audit `Tests/Common/MetaFixers.psm1`** — appears to be dead template code; remove
      if unreferenced.
- [ ] **PlatyPS monkey-patch** in `Build/build.psake.ps1` (rewrites installed
      `platyPS.psm1` by hard-coded line number) — pin/upgrade PlatyPS to a version that
      natively supports `ProgressAction`, then delete the patch block.
- [ ] **Pin third-party GitHub Actions by commit SHA** in `.github/workflows/*.yml` per
      `module-structure.md`.

---

## Cross-cutting validation

- [ ] `./Build/build.ps1 -ResolveDependency -TaskList Analyze` exits 0
- [ ] `./Build/build.ps1 -TaskList Test` exits 0
- [ ] Manual smoke test of the public API after each PR
- [ ] **Delete this file** as the final commit on PR 2
