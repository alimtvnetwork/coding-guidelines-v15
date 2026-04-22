# 28 — Distribution and Runner

> **Version:** 1.0.0
> **Updated:** 2026-04-22
> **Type:** Consolidated Guideline — Phase 6B
> **Source folder:** [`spec/15-distribution-and-runner/`](../15-distribution-and-runner/)
> **Status:** Standalone — promoted from inline mention in `17-self-update-app-update.md` once the source folder grew to 6 files.

This file is the **standalone consolidated reference** for the
end-user-facing distribution surface of `coding-guidelines-v15`. An AI
reading only this file must be able to:

- Implement `install.sh` / `install.ps1` from scratch.
- Implement the repo-root `run.sh` / `run.ps1` sub-command dispatcher.
- Build the GitHub Release pipeline producing every required artifact.
- Author and validate `install-config.json`.

Companion file: `17-self-update-app-update.md` covers the **runtime
self-update mechanism** (latest.json, rename-first deployment). This
file covers the **first-install + release packaging** surface.

---

## §1 — Scope & Audience

| Surface | Owner | Lives in |
|---|---|---|
| `install.sh`, `install.ps1` | This file (§3) | repo root |
| `install-config.json` | This file (§6) | repo root |
| `run.sh`, `run.ps1` (root dispatcher) | This file (§4) | repo root |
| `linter-scripts/run.sh`, `run.ps1` | `02-coding-guidelines.md §35` | `linter-scripts/` |
| GitHub Release artifacts | This file (§5) | `.github/workflows/release.yml` |
| Self-update at runtime (latest.json) | `17-self-update-app-update.md` | per-app |

If a non-developer cannot follow the README and have a working install
in **60 seconds**, this spec has failed.

---

## §2 — Canonical Distributable Artifacts

Every GitHub Release MUST publish all of the following. Missing any one
is a **release blocker**.

| # | Artifact | Source | Filename pattern | Purpose |
|---|---|---|---|---|
| 1 | Spec + linters tree (download-on-demand) | `spec/`, `linters/`, `linter-scripts/`, `linters-cicd/` on main | sourced via `codeload.github.com` archive — **not** a release asset | Powers `install.sh` / `install.ps1` |
| 2 | Linters CI/CD pack | `linters-cicd/` (excludes `__pycache__`, `*.pyc`) | `coding-guidelines-linters-vX.Y.Z.zip` | Drop-in CI artifact; consumed by `linters-install.sh` |
| 3 | Slides deck | `slides-app/dist/` | `coding-guidelines-slides-vX.Y.Z.zip` | Offline trainer deck (double-click `index.html`) |
| 4 | Bash installer | `install.sh` | `install.sh` | Linux/macOS one-liner |
| 5 | PowerShell installer | `install.ps1` | `install.ps1` | Windows one-liner |
| 6 | Linters quick-installer | `linters-cicd/install.sh` (renamed) | `linters-install.sh` | CI one-liner that installs only `linters-cicd/` |
| 7 | Default install config | `install-config.json` | `install-config.json` | Authoritative folder list shipped with installers |
| 8 | Checksums | computed in CI | `checksums.txt` | SHA-256 of every zip |
| 9 | Other release outputs | `release.sh` | `release-artifacts/*.zip`, `*.tar.gz` | Per-app generic-release bundles |

This list is the **contract**. Any addition or removal requires
updating §3.2 (install layout), §6.3 (default folders), and the
`folders` array in `install-config.json` in the **same commit**.

---

## §3 — Install Contract (`install.sh` / `install.ps1`)

### §3.1 One-liner invocations

These MUST work without prior setup beyond `curl`/`wget` + `bash` (or
PowerShell 7+):

```bash
curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh | bash
```

```powershell
irm https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.ps1 | iex
```

### §3.2 Default install layout

After running with no flags, the user's CWD MUST contain exactly:

```
<dest>/
├── spec/                  ← full coding-guidelines spec tree
├── linters/               ← per-language lint plugins, ESLint configs
├── linter-scripts/        ← orchestrator scripts (legacy validator)
└── linters-cicd/          ← Python check suite, run-all.sh, registry, baseline
```

| Folder | Mandatory | Purpose |
|---|---|---|
| `spec/` | ✅ | Full coding-guidelines spec tree (606+ files) |
| `linters/` | ✅ | Language-specific lint plugins, ESLint configs, tree-sitter queries |
| `linter-scripts/` | ✅ | Legacy orchestrator (validator wrappers, helper scripts) |
| `linters-cicd/` | ✅ | Python check suite, registry, `run-all.sh`, baseline |

This list is loaded from `install-config.json`. The four entries above
MUST equal the `folders` array in that file.

> **Why all four?** The user wants every distributable component
> installed by default. To install a subset, override with
> `--folders` (Bash) or `-Folders` (PowerShell).

### §3.3 Versioning flags

| Mode | Flag (Bash) | Flag (PS) | Behavior |
|---|---|---|---|
| Latest tag | (none) | (none) | Probes for newer `coding-guidelines-vN` repos (middle-out, parallel, 2 s timeout). Hands off to newer installer if found. |
| Pinned version | `--version vX.Y.Z` | `-Version vX.Y.Z` | Downloads tagged tarball/zipball, extracts the four folders. |
| Pinned branch | `--branch <name>` | `-Branch <name>` | Downloads from branch head. |
| Skip probe | `-n` / `--no-probe` / `--no-latest` | `-NoProbe` | Use the running installer as-is, no version detection. |

### §3.4 File-merge semantics

| Mode | Flag (Bash) | Flag (PS) | Behavior |
|---|---|---|---|
| Default | (none) | (none) | Overwrite existing files silently (legacy behavior) |
| Interactive | `--prompt` | `-Prompt` | Ask `[y]es / [n]o / [a]ll / [s]kip-all` per existing file |
| Force | `--force` | `-Force` | Overwrite every existing file. **Mutually exclusive with `--prompt`** |
| Dry run | `--dry-run` | `-DryRun` | Print would-create/would-overwrite, write nothing |

### §3.5 Listings (no install)

| Mode | Flag (Bash) | Flag (PS) | Output |
|---|---|---|---|
| List release tags | `--list-versions` | `-ListVersions` | Up to 50 tags from `api.github.com/repos/<repo>/releases` |
| List top-level folders | `--list-folders` | `-ListFolders` | Top-level dirs in chosen ref (via `api.github.com/repos/<repo>/contents`) |

### §3.6 Cleanup contract

Both installers MUST:

1. Create a unique temp dir under the OS temp root.
2. Download the archive and extract into the temp dir.
3. Copy/merge files into the destination.
4. **Always** clean up the temp dir on exit (success or failure) via
   `trap` (Bash) or `try/finally` (PowerShell).
5. Verify cleanup happened; emit a warning if it didn't.

### §3.7 Exit codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | Generic failure (network, parse error, missing tools) |
| `2` | Bad CLI flag combination (e.g. `--prompt` with `--force`) |

(Aligned with `27-linter-authoring-guide.md §3` — the universal
0/1/2 contract.)

### §3.8 Error message contract

Every error MUST include:

- The remote URL that failed (so the user can `curl` it manually).
- The local path being written (so the user can check permissions).
- One actionable next step (`retry with --no-probe`, `delete X and re-run`, …).

No silent failures. No bare stack traces.

### §3.9 Anti-requirements

- MUST NOT require Node.js, Python, or Go on the host. Bash installer
  uses only `curl`/`wget`/`tar`/`unzip`. PS installer uses only
  built-in cmdlets.
- MUST NOT require GitHub authentication for public repos.
- MUST NOT install or modify anything outside
  `<dest>/{spec,linters,linter-scripts,linters-cicd}/`.

---

## §4 — Runner Contract (root `run.sh` / `run.ps1`)

The repo-root runner is the user's **single entry point** for the most
common operations. It is **distinct** from `linter-scripts/run.sh`,
which is the linter orchestrator.

### §4.1 Sub-command surface

| Invocation | Effect | Inner script |
|---|---|---|
| `./run.ps1` (no positional args) | `git pull` → run the Go validator on `src/` (legacy default) | `linter-scripts/run.ps1` |
| `./run.ps1 lint [-Path …] [-MaxLines …] [-Json] [-d]` | Explicit lint form. Same as no-args. | `linter-scripts/run.ps1` |
| `./run.ps1 slides` | `git pull` → build & preview deck → open browser | inline (see §4.3) |
| `./run.ps1 help` | Print sub-command table, exit `0` | inline |

`run.sh` MUST implement the same surface in Bash with the same
positional convention.

### §4.2 Default-behaviour preservation (HARD RULE)

When invoked with **no positional arguments**, the runner MUST behave
exactly as before this spec was introduced — forwarding `-Path`,
`-MaxLines`, `-Json`, `-d` to `linter-scripts/run.ps1` /
`linter-scripts/run.sh`.

> **Why:** Existing CI jobs and local muscle memory rely on
> `./run.ps1` triggering the Go validator. Adding a sub-command MUST
> NOT break them.

### §4.3 Slides sub-command

`./run.ps1 slides` and `./run.sh slides` MUST:

1. Print banner: `▸ slides — building offline deck and opening in browser`.
2. `git pull` (best-effort; warn but continue on failure).
3. Verify `slides-app/` exists; otherwise abort with pointer to slides spec.
4. Verify `bun --version`. If absent, fall back to `pnpm`. If neither,
   abort with installation instructions.
5. Run, with `slides-app/` as CWD:
   - `bun install --frozen-lockfile || bun install`
   - `bun run build`
   - `bun run preview &` (background)
6. Wait up to **10 seconds** for `http://localhost:4173` to be reachable.
7. Open browser:
   - PowerShell: `Start-Process "http://localhost:4173/"`
   - Bash: `xdg-open` (Linux) · `open` (macOS) · `start` (Git-Bash on Windows)
8. Print: `▸ slides — preview running. Press Ctrl-C to stop.`
9. `wait` on the preview process so Ctrl-C reaches it.

### §4.4 Argument-parsing rule

The first positional argument is the sub-command. If it starts with
`-` (e.g. `-Path src/`), treat the whole invocation as legacy lint
form and forward all arguments unchanged.

```
./run.ps1                       → lint (default)
./run.ps1 -Path cmd             → lint -Path cmd
./run.ps1 lint -Path cmd        → lint -Path cmd
./run.ps1 slides                → slides sub-command
./run.ps1 help                  → print help
./run.ps1 unknown-subcommand    → error: unknown sub-command, exit 2
```

### §4.5 Help aliases

`./run.ps1 -h`, `./run.ps1 --help`, `./run.ps1 -?` are all aliases for
`./run.ps1 help`.

### §4.6 Exit codes

| Code | Meaning |
|---|---|
| `0` | Success |
| `1` | Lint validator reported violations OR slides build failed |
| `2` | Unknown sub-command or bad CLI flags |
| `130` | User pressed Ctrl-C |

### §4.7 Anti-requirements

- MUST NOT silently swap the default lint behaviour.
- MUST NOT require pre-installed `bun` for the lint sub-command (only
  `slides` needs it).
- MUST NOT auto-update or mutate `slides-app/package.json`.
- MUST NOT leave a background `bun preview` process running after the
  user exits.

---

## §5 — Release Pipeline (`.github/workflows/release.yml`)

### §5.1 Trigger

```yaml
on:
  push:
    tags:
      - "v*"

concurrency:
  group: release-${{ github.ref }}
  cancel-in-progress: false
```

> **Releases MUST NEVER be cancelled.** Every release tag must produce
> a GitHub Release regardless of subsequent commits.

### §5.2 Required artifacts

(See §2 for the canonical list.) CI MUST `test -f` (or equivalent)
**before** the publish step and fail the build if any artifact is
missing.

### §5.3 Job order

```
checkout
  → resolve version (from GITHUB_REF_NAME)
    → bash release.sh                                  (builds release-artifacts/)
      → verify release-artifacts/ + checksums.txt
        → setup bun
          → cd slides-app && bun install + bun run build + bun run package
            → verify slides-app/dist.zip
              → rename slides-app zip with version
                → zip linters-cicd/ → coding-guidelines-linters-vX.Y.Z.zip
                  → sha256sum >> checksums.txt
                    → cp install.sh as linters-install.sh
                      → softprops/action-gh-release@v2 publishes everything
```

### §5.4 Release notes

The release body MUST include, at minimum:

1. Install one-liners for Bash and PowerShell.
2. Slide-deck download instructions (filename + double-click `index.html`).
3. CI/CD linter-pack quick-start (composite action one-liner + curl one-liner).
4. Pointer to `checksums.txt` for SHA-256 verification.

The wording in `.github/workflows/release.yml` `body:` is the
canonical source.

### §5.5 Build-once rule

Each artifact is compiled **exactly once** per release. Compression,
checksums, and publishing operate on already-built artifacts and MUST
NOT trigger a rebuild.

### §5.6 Pre-release detection

Tags containing a `-` (e.g. `v3.5.0-beta.1`) MUST be marked
`prerelease: true` and MUST NOT be marked `make_latest`:

```yaml
prerelease:  ${{ contains(steps.version.outputs.version, '-') }}
make_latest: ${{ !contains(steps.version.outputs.version, '-') }}
```

### §5.7 Failure modes

| Symptom | Cause | Fix |
|---|---|---|
| `release-artifacts/ missing` | `release.sh` failed silently | Read `release.sh` logs; fix and retag |
| `slides-app/dist.zip missing` | Vite build failed | Check `bun run build` output |
| `linters-cicd zip missing` | Wrong working directory or `__pycache__` exclude pattern | Verify exclude globs |
| Checksum mismatch downstream | `checksums.txt` not regenerated after re-zip | Always append to `checksums.txt` after zipping |

### §5.8 Anti-requirements

- MUST NOT publish a release missing any artifact in §2.
- MUST NOT cancel an in-progress release for a newer tag
  (`cancel-in-progress: false`).
- MUST NOT publish source maps inside `coding-guidelines-slides-*.zip`
  — `slides-app/scripts/package-zip.mjs` strips them.
- MUST NOT include `node_modules/`, `.git/`, or `__pycache__/` in any
  release zip.

---

## §6 — `install-config.json` Contract

### §6.1 Schema

```json
{
  "repo":    "<owner>/<repo>",
  "branch":  "<default branch>",
  "folders": ["<folder1>", "<folder2>", "..."]
}
```

| Field | Type | Required | Default | Notes |
|---|---|---|---|---|
| `repo` | string | ✅ | `"alimtvnetwork/coding-guidelines-v15"` | GitHub `owner/repo` |
| `branch` | string | ✅ | `"main"` | Branch to install from when no `--version` is given |
| `folders` | string[] | ✅ | `["spec","linters","linter-scripts","linters-cicd"]` | Top-level folders to fetch |

Subpaths (e.g. `"spec/14-update"`) are allowed in `folders` for partial
installs.

### §6.2 Authoritative default

The committed `install-config.json` at the repo root MUST equal
exactly:

```json
{
  "repo": "alimtvnetwork/coding-guidelines-v15",
  "branch": "main",
  "folders": [
    "spec",
    "linters",
    "linter-scripts",
    "linters-cicd"
  ]
}
```

This list MUST stay in sync with §3.2 (install layout) and §2 (canonical
artifacts).

### §6.3 Override precedence

Both installers MUST resolve `repo`, `branch`, `folders` in this order
(highest wins):

1. CLI flag (`--repo`, `--branch`, `--folders`, `--version`)
2. Custom config file specified via `--config <path>`
3. The repo-root `install-config.json`
4. Hard-coded fallback in the installer source

### §6.4 Custom config example

```json
{
  "repo": "acme-corp/coding-guidelines-v15-fork",
  "branch": "internal",
  "folders": ["spec", "linters-cicd"]
}
```

```bash
./install.sh --config team-config.json
```

### §6.5 Anti-requirements

- MUST NOT include any secret, token, or auth field. Installers operate
  on **public repos only**.
- MUST NOT include feature flags or runtime behaviour — config is for
  **source coordinates**, period.
- MUST NOT add a fifth folder without updating §3.2 and §6.2 in the
  **same commit**.

---

## §7 — Verification Recipe

A blind AI implementing or modifying this surface MUST verify with:

```bash
# 1. Install contract: idempotent, cleanup, exit 0
mkdir /tmp/cg-install && cd /tmp/cg-install
bash <(curl -fsSL https://raw.githubusercontent.com/alimtvnetwork/coding-guidelines-v15/main/install.sh) --no-probe
ls -la spec linters linter-scripts linters-cicd        # all four present
ls /tmp | grep cg-install-tmp                          # NO leftover temp dir

# 2. Runner contract: default behaviour preserved
./run.sh                                               # → Go validator on src/
./run.sh help                                          # → sub-command table, exit 0
./run.sh unknown-subcommand                            # → exit 2

# 3. Release pipeline: dry-run on a tag
gh workflow run release.yml -r v3.51.0-dryrun
gh run list --workflow=release.yml --limit 1           # status: success
gh release view v3.51.0-dryrun --json assets           # 8 artifacts present

# 4. Cross-link integrity
python3 linter-scripts/check-spec-cross-links.py --root spec --repo-root .
```

---

## §8 — Cross-References

- Source folder: [`spec/15-distribution-and-runner/`](../15-distribution-and-runner/)
- [`17-self-update-app-update.md`](./17-self-update-app-update.md) — Runtime self-update mechanism (latest.json, rename-first deployment)
- [`15-cicd-pipeline-workflows.md`](./15-cicd-pipeline-workflows.md) — Broader CI/CD conventions
- [`23-generic-cli.md`](./23-generic-cli.md) — Generic CLI conventions consumed by installers
- [`27-linter-authoring-guide.md`](./27-linter-authoring-guide.md) — Exit-code contract reused by installers (§3.7)
- [`spec-slides/`](../../spec-slides/) — Slides app spec (consumed by `run.sh slides`)
- [`spec/16-generic-release/`](../16-generic-release/) — Generic release standard

---

## Verification

_Auto-generated section — see `spec/17-consolidated-guidelines/97-acceptance-criteria.md` for the full criteria index._

### AC-CON-028: Distribution & runner conformance

**Given** A clean machine with only `curl`/`wget` + Bash (or PowerShell 7+) installed.
**When** The user runs the one-liner from §3.1 with no flags.
**Then** All four folders (§3.2) appear in CWD, no temp dir is left behind
(§3.6), the install completes with exit code `0` (§3.7), and a subsequent
`./run.sh` (§4.2) launches the Go validator without modification.

**Verification command:**

```bash
bash linter-scripts/run.sh && \
python3 linter-scripts/check-spec-cross-links.py --root spec --repo-root .
```

**Expected:** exit `0`. Any non-zero exit is a hard fail and blocks merge.

_Verification section last updated: 2026-04-22_
