# Plan: implement `skills/r-arf` from scratch

Implementation plan for the arf agent skill. Do not treat this file as skill
text. When the skill lands, archive or delete this note along with
[`r-execution-routing.md`](r-execution-routing.md).

**Status:** ready to implement. Decisions below are locked from the
[2026-09-24 session](cf72cdee-810b-4fe3-9ae6-4b8ab570eeee) plus the later
routing scratch, checked against the personal `arf-ipc` skill as updated
2026-09-28 for arf 0.5.2 silent-eval policy.

---

## 1. Outcome

`skills/r-arf` is the canonical arf skill: a short router the agent always
reads, plus curated references it opens only for the intent at hand, plus a
vendor mirror it opens only when a curated page is not enough.

It replaces the idea that `~/.cursor/skills/arf-ipc` is the arf skill. That
personal skill stays the source for the IPC golden path until this skill
absorbs it. After this skill is in place, the personal skill becomes a stub
that points here (follow-up, outside this repo).

The skill teaches three jobs:

1. Run agent-owned R in one reusable process.
2. Answer human questions about the arf console, config, and which R arf will
   start.
3. Refuse the confusions that the 2026-09-24 session actually hit.

---

## 2. What the prior session established

The experiment in that chat is the design constraint. Stock Cursor Agent Shell
runs a command and reads its output. It can keep a background terminal alive.
It cannot type the next line into a program that already owns that terminal
(`arf`, `python`, `node`, an interactive `ssh`).

A live `arf` prompt was started. The agent could not send `x <- 10` into it.
Win32 console injection is out of scope. The workable drive cable that arf
ships is IPC: many short `arf ipc` client calls against one long-lived server.

Visibility is a separate requirement. Silent `arf ipc eval` returns JSON to the
agent and does not show the source in the server terminal. The user wants to
see what ran. Headless `--visible` shows output and still fills `value` /
`error`, and it does not reliably echo assignment source. So the skill's
contract is both:

- one watchable headless terminal, with `--visible` on evals the user should
  see
- the R source pasted in chat on every execution, including assignments

Persistence, drivability, and visibility are three different properties. The
skill must not collapse them.

---

## 3. Locked decisions

| Decision | Choice |
|---|---|
| Folder and skill `name` | `skills/r-arf` / `r-arf` |
| `skills/r-cli` | Leave it. It is the R `{cli}` package, not a CLI umbrella |
| Default agent R | One headless server the agent starts, reuses, and shuts down |
| Startup flags | `arf headless --json --vanilla --ipc-eval-unrestricted` |
| How the agent sends R | `arf ipc eval --pid <PID>`, prefer `--visible` for work the user should watch |
| Chat | Paste every R expression in chat before or as it runs |
| Allowlist | Do not edit the user's `[ipc.eval] allowed_functions`. Unrestricted is startup-only on the agent server |
| R selection | `arf r resolve`. Never hardcode an R install path. Inherited `R_HOME` is not the selector |
| Profiles | `--vanilla` unless the user asks for their profile |
| Shutdown | `arf ipc shutdown --pid` for headless servers this task started. Closing the terminal is not shutdown |
| Process hygiene | Never `Stop-Process` every `arf`. The editor REPL (`arf --no-save --no-restore`) and any interactive session are not the agent's |
| RStudio / btw | Different host and cable. This skill names the boundary and stops. It does not document btw |
| Batch | `arf -e` / `arf -f` when nothing must persist |
| Vendor docs | Mirror under `references/vendor/`. Curated files stay beside it so sync cannot overwrite them |
| Personal `arf-ipc` | Content source for IPC, Windows, and patterns. Not copied as the `SKILL.md` |

---

## 4. What "from scratch" means

The current `skills/r-arf` tree is a stub plus an upstream doc dump:

| Path | What it is today | What happens |
|---|---|---|
| `SKILL.md` | 16-line stub, IPC-only description, `arf_version: ">= 0.5.0"` | Rewrite |
| `references/ipc.md` | Full upstream IPC doc (~767 lines), includes 0.5.x policy | Move to `references/vendor/ipc.md` |
| `references/configuration.md` | Full upstream config doc | Move to `references/vendor/` |
| `references/editors.md` | Full upstream editors doc (small) | Move to `references/vendor/` |
| `references/r-resolve.md` | Full upstream resolve doc (small) | Move to `references/vendor/`; write a thin curated sibling if the vendor page is the wrong default read |
| `scripts/sync-docs.ps1` | Writes to `scripts/references` (`Join-Path $PSScriptRoot "references"`) | Point at `references/vendor/` and add a manifest |

Do not edit the vendor pages into agent instructions. Do not paste
`~/.cursor/skills/arf-ipc/SKILL.md` in as `skills/r-arf/SKILL.md`. That file is
an IPC-only golden path. This skill is a router that keeps that golden path
one click away.

The 2026-09-28 `arf-ipc` update is the IPC content to absorb: silent eval
allowlist, `R_EVAL_NOT_ALLOWED` vs `R_BUSY`, `--ipc-eval-unrestricted`,
readiness `ipc_policy.silent.mode`, and the Windows WinGet lock. The older
transcript copy of that skill (no unrestricted flag, `library()` / `|>`
examples against a default-restricted server) is stale. Use the files on disk
under `~/.cursor/skills/arf-ipc/`.

---

## 5. Target tree

```text
skills/r-arf/
  SKILL.md
  references/
    sessions.md              # ownership x cable; when to open which file
    ipc.md                   # curated agent IPC (lifecycle, policy, errors)
    windows.md               # WinGet lock, pipes, PowerShell quoting
    patterns.md              # readiness, long jobs, graphics, temp scripts
    console.md               # meta commands, -e/-f, human REPL
    resolve.md               # which R arf will start; pointer to vendor
    configuration-index.md   # which keys matter; pointer to vendor
    vendor/
      configuration.md
      ipc.md
      editors.md
      r-resolve.md
      MANIFEST.json
  scripts/
    sync-docs.ps1
```

`SKILL.md` links one level deep. Reference files may link to `vendor/` and to
each other. They do not link onward into a third tier the agent must discover.

Line budget: `SKILL.md` about 180-250 lines (hard cap 400). Curated refs stay
short enough to read whole. Vendor files can stay long because they are
opt-in.

---

## 6. `SKILL.md` outline

Frontmatter:

```yaml
---
name: r-arf
description: >-
  Drive the arf R console for agent work and for human arf questions.
  Use when executing R that must keep state across steps, when choosing
  between arf IPC, a one-shot arf -e, and leaving RStudio or btw alone,
  or when configuring arf, resolving which R arf will start, or using
  arf meta commands. Covers headless IPC lifecycle, the 0.5.x silent-eval
  allowlist, Windows shutdown hygiene, and when to read vendor docs.
metadata:
  author: jimmy.briggs@jimbrig.com
  r_version: ">= 4.3"
  arf_version: ">= 0.5.2"
---
```

Description is third person and includes the trigger terms: execute R, IPC,
headless, allowlist, config, resolve, meta commands, RStudio/btw boundary.

Body sections, in this order:

1. **Mental model** (short). One long-lived R process. Agent Shell cannot type
   into its prompt. IPC is the drive cable. Chat holds the source. The
   background terminal holds output when evals are `--visible`.
2. **Router.** The table in section 7. This is the first thing the agent acts
   on.
3. **Agent-owned session** (the golden path, commands included). Discover,
   start once, confirm `ipc_policy.silent.mode` is `unrestricted`, many evals,
   shutdown. Paste R in chat. Prefer `--visible`. Rules that are wrong if
   omitted: `--vanilla`, `--ipc-eval-unrestricted`, `--pid`, no hardcoded R
   path, shutdown before the final reply, do not orphan `arf.exe`.
4. **Hard boundaries.** Extension REPL is not an IPC server. btw
   `list_r_sessions` is not `arf ipc list`. Do not `shutdown` interactive or
   unknown sessions. Do not edit `arf.toml` to unblock an agent. Do not retry
   `R_EVAL_NOT_ALLOWED`. Do not use `--visible` or `send` to dodge a restricted
   session the agent does not own.
5. **Where to read next.** One table of reference files and when.

Keep JSON field tables, exit codes, quoting, and long-job patterns out of
`SKILL.md`. Those live in the curated refs. `SKILL.md` states the rule and
links the file.

---

## 7. Router (encode this table in `SKILL.md`)

| Intent | Do this | Then read |
|---|---|---|
| Multi-step R the agent owns | Start or reuse one headless IPC server | `references/ipc.md`, then `windows.md` on Windows, `patterns.md` if the job is long or writes files |
| User wants to watch the R | Same server; `arf ipc eval --visible`; paste source in chat | `references/sessions.md` |
| One expression, no state to keep | `arf -e` or `arf -f` | `references/console.md` |
| Inspect or mutate the user's RStudio | Stop. Use btw MCP. Do not start arf | `references/sessions.md` (boundary only) |
| User's interactive arf already has IPC | Attach read-only with `--pid`. No `shutdown`. Silent eval there is restricted | `references/ipc.md` |
| Docs, help, "is this package installed?" | btw MCP when it is available. Do not start R to print `?foo` | none in this skill |
| Configure `arf.toml` | `references/configuration-index.md` | `references/vendor/configuration.md` |
| Which R will start | `arf r resolve` | `references/resolve.md`, then vendor if the JSON is ambiguous |
| Meta commands, reprex, shell mode, editor setup | `references/console.md` | `references/vendor/editors.md` for vscode-R / Zed |
| Protocol, JSON-RPC, security model | curated `ipc.md` first | `references/vendor/ipc.md` |

---

## 8. Reference contracts

### `references/sessions.md`

The decision tree from the routing scratch, in plain language:

- Agent-owned persistent R: headless IPC.
- Human RStudio: btw, never "arf IPC against RStudio".
- Editor `arf --no-save --no-restore`: human/editor owned; `arf ipc list` is
  empty for it unless IPC was turned on; btw may still list it as `(arf)`.
- Batch: `arf -e` / `arf -f`.
- Three words that must stay distinct: persistence, drivability, visibility.

Include the method cheat-sheet from the scratch (section 5) in compressed
form. State that a generic "type into any REPL" skill is out of scope; IPC is
the cable this skill uses.

### `references/ipc.md`

Curated from the 2026-09-28 `arf-ipc` skill and `references/cli.md`, not from
vendor `ipc.md`. Must include:

- Server vs client diagram.
- Discover (`arf ipc list`), start, reuse, shutdown.
- Readiness JSON and `ipc_policy.silent.mode` (`restricted` vs `unrestricted`).
- What restricted silent eval allows (literals, bare names, exact allowlisted
  calls) and what it always rejects (`<-`, `=`, `|>`, control flow, `:::`,
  computed callees). `$`, `[`, `[[` are allowlist-gated.
- `R_EVAL_NOT_ALLOWED` is exit 4 before R runs. It is not `R_BUSY`.
- Eval JSON: `value`, `stdout`, `stderr`, `error`. R errors are exit 0.
- `--visible` and `send`: skip the allowlist; headless runs immediately and
  still fills `value` / `error`; interactive waits for a human `y` and leaves
  those fields null.
- Error-code table (busy, not allowed, typing, ambiguous, not found,
  incomplete, pending, transport).
- `list` / `session` / `history` work while R is busy.
- `--timeout` bounds the client wait. R keeps running.

Point at `vendor/ipc.md` for JSON-RPC method names and security detail.

### `references/windows.md`

Port `~/.cursor/skills/arf-ipc/references/windows.md` with light edits:

- `where.exe arf`, then the WinGet package path if the shim is gone.
- Orphan `arf.exe` locks the portable binary; `winget upgrade` deletes the
  PATH shim first.
- Pipe `\\.\pipe\arf-ipc-<PID>`. Clients use session files, not hand-typed
  pipes.
- PowerShell: outer single quotes, R double quotes inside. Temp `.R` file plus
  `source()` for multiline. `source()` is invisible, so the eval expression
  must also return `result`.
- Do not wrap the server in `Start-Process`.
- rig short paths are harmless. `--vanilla` still sees `.libPaths()`.

### `references/patterns.md`

Port the personal `patterns.md`, adjusted to this skill's visibility rule:

- Readiness: background terminal, wait for `"pid"`, confirm unrestricted,
  retry `R_BUSY` only.
- Incremental context in one session.
- Verify files the R job wrote, in that same session.
- Long jobs: background the client with a long `--timeout`, or write a file
  and poll it. `session` / `history` / `list` still respond. Do not spam eval
  retries.
- Graphics: file devices (`png` / `ggsave`), then show the file.
- One session per task. `--pid` whenever more than one exists.
- Package load once with `library()` on the unrestricted server.

### `references/console.md`

Thin, from `arf --help` and the README meta table. Not a second IPC guide.

- Interactive `arf` is for a human at the keyboard.
- One-shots: `arf -e`, `arf -f`, `--reprex`.
- Meta commands worth naming: `:help`, `:cd`, `:history`, `:shell`, `:reprex`,
  `:switch`, `:restart`, `:ipc start|stop|status`.
- `:ipc start` is how a human enables the cable on a session they already
  have. The agent does not assume it is on.

### `references/resolve.md`

Thin. Precedence:

1. `arf headless --r-home` / `--with-r-version` (flags belong on the
   subcommand)
2. `ARF_R_HOME` / `ARF_R_VERSION`
3. `r_source_overrides` / project `.r-version` / `rproject.toml`
4. `startup.r_source` in `arf.toml`
5. rig, then PATH

`arf r resolve` prints the choice without starting R. Machine `R_HOME` is not
in this chain. Link `vendor/r-resolve.md` for the JSON schema.

### `references/configuration-index.md`

An index, not a rewrite of the 700-line config doc. Cover only keys an agent
hits:

- where the file lives (`%APPDATA%\arf\arf.toml` on Windows)
- `arf config init` / `arf config check`
- `startup.r_source`
- `[ipc.eval] allowed_functions` and why the agent does not edit it
- prompt / completion / experimental keys as "human console only"

Everything else: open `vendor/configuration.md`.

---

## 9. Golden path to encode verbatim in `SKILL.md`

```text
arf ipc list
arf headless --json --vanilla --ipc-eval-unrestricted
# wait until stdout JSON has "pid" and ipc_policy.silent.mode == "unrestricted"

arf ipc eval --visible --pid <PID> '<R>'
# paste <R> in chat as well

arf ipc shutdown --pid <PID>
```

Silent eval (no `--visible`) is allowed on that unrestricted server for noisy
intermediates. It is not the default when the user is watching.

If `arf` is missing from PATH, resolve the WinGet package exe and use that
full path for both `headless` and `ipc`. Do not treat a missing shim as
"arf is uninstalled" while a server may still be locking the binary.

---

## 10. `scripts/sync-docs.ps1`

Fix and narrow it. It maintains the vendor mirror only.

- Output directory: `Join-Path $PSScriptRoot "..\references\vendor"`.
- Create the directory if missing.
- Sync upstream `docs/*.md` from `eitsupi/arf` (current set: `configuration.md`,
  `ipc.md`, `editors.md`, `r-resolve.md`).
- Write `references/vendor/MANIFEST.json` with `synced_at`, repo, ref or tag,
  and the list of files.
- Print installed `arf --version` next to the synced ref so drift is visible.
  Do not fail the sync on mismatch; the mirror can be ahead of or behind the
  binary, and the skill already says to trust `arf --help` when they disagree.
- Do not copy README, changelog, or `arf.schema.json` until a task needs them.
  The config index points at the vendor markdown, which is enough.

After the move, delete the vendor files from `references/` root so the curated
names (`ipc.md`, and a new `resolve.md`) are not the upstream dumps.

---

## 11. Implementation order

1. Create `references/vendor/` and move the four current reference files into
   it. Do not rewrite them.
2. Fix `sync-docs.ps1` and run it once so `MANIFEST.json` exists and the move
   matches what the script would write.
3. Write `SKILL.md` to the outline in section 6. Include the router and the
   golden path. Keep it inside the line budget.
4. Write curated `ipc.md`, `windows.md`, and `patterns.md` from the personal
   skill, with the visibility rule from section 9 applied to the examples.
5. Write `sessions.md`, `console.md`, `resolve.md`, and
   `configuration-index.md`.
6. Read the skill as an agent would: trigger description, router, one golden
   path, then one deep link. Check that a config question does not require
   loading IPC, and an IPC task does not require loading the config essay.
7. Update `skills/index.md` / `skills/README.md` only if those files are the
   repo's skill catalog and are not empty placeholders. Do not invent a catalog
   entry format.
8. Leave `docs/_scratch/r-execution-routing.md` until the skill text has
   absorbed sections 1-7 and 9. Then archive both scratch notes.

Personal `~/.cursor/skills/arf-ipc`: after this skill reads well, replace that
`SKILL.md` with a short pointer ("use the `r-arf` skill; IPC lifecycle is
`references/ipc.md`"). Do that in a separate step so this repo's skill can be
reviewed on its own. Until then, two auto-invoked skills will disagree if the
personal one stays a full duplicate.

---

## 12. Acceptance checks

- `SKILL.md` `name` is `r-arf`. Description states what and when, third person,
  and mentions IPC, config, resolve, and the RStudio/btw boundary.
- `arf_version` metadata is `>= 0.5.2`.
- Golden path includes `--vanilla` and `--ipc-eval-unrestricted`.
- The skill tells the agent to paste R in chat and to prefer `--visible`.
- `R_EVAL_NOT_ALLOWED` is documented as do-not-retry, distinct from `R_BUSY`.
- Shutdown instructions name headless PIDs the agent started, and name the
  WinGet lock.
- No instruction to type into a live REPL, inject console input, edit
  `allowed_functions`, or call arf IPC against RStudio.
- `references/ipc.md` at the skill root is the curated page, not the upstream
  dump. Upstream lives under `references/vendor/`.
- `sync-docs.ps1` writes only under `references/vendor/`.
- Every `SKILL.md` link is one level deep and the target exists.
- `SKILL.md` stays under 400 lines.

---

## 13. Out of scope for this implementation

- A generic terminal/REPL skill for Python, Node, or WSL.
- An `r-btw` or `r-mcptools` skill. Only the boundary sentence belongs here.
- Changing `~/.cursor/mcp.json` or `BTW_RUN_R_ENABLED`.
- Rewriting vendor docs, vendoring `arf.schema.json`, or documenting reedline,
  themes, and keybindings beyond the config index.
- Installing or driving a PTY MCP. Mention once in `sessions.md` as another
  ecosystem, not a default.

---

## 14. Source map

| Claim in this plan | Where it was settled |
|---|---|
| Agent Shell cannot feed a live REPL | 2026-09-24 transcript, turns after the live `arf` prompt |
| IPC is the first-party drive cable; PTY MCP would be a different product | Same transcript, closing turns |
| Visibility: `--visible` plus paste source in chat | Transcript close, then scratch section 4 (chat paste affirmed) |
| Empty allowlist, unrestricted startup, do not edit `arf.toml` | Scratch section 6; personal `arf-ipc` as of 2026-09-28 |
| Hosts vs cables, extension REPL vs headless vs btw | Scratch sections 2, 3, and 7 |
| `r-arf` vs `r-cli` naming | Transcript; user: `r-cli` is the `{cli}` package |
| Sync script writes to the wrong directory | Scratch section 9; `scripts/sync-docs.ps1` |
| Vendor vs curated split | Transcript context-collection answer, adjusted by the later routing model |
