# R execution & context routing (scratch)

Temporary notes from the 2026-09-24 exploration sessions. Purpose: lock the
mental model before curating `r-arf` / btw skills. Not a skill yet — verify this
against intent, then promote pieces into real skills.

**Last thorough verification pass:** 2026-09-24 evening (live arf/btw on this
machine + Cursor agent docs + upstream arf v0.5.0/0.5.2 notes + btw/mcptools
help via btw MCP tools). See §13 for evidence and claim strength.

---

## 1. Hard constraint (Cursor Agent)

Agent Shell runs **discrete commands** (optionally backgrounded) and can **read**
terminal output. It does **not** send keystrokes / stdin into an already-running
interactive TTY (arf REPL, `python`, etc.).

**Verified (Desktop Agent):** official docs describe execute + monitor output
only ([Agent overview](https://cursor.com/docs/agent/overview.md),
[Terminal tool](https://cursor.com/docs/agent/tools/terminal.md)). No
stdin-to-running-TTY API. CLI Shell Mode is even stricter (interactive prompts
unsupported; 30s timeout) — different surface, same conclusion for REPL drive.

Consequences:

- Opening interactive `arf` in a terminal does **not** give the agent a drive API
  for later turns.
- A reusable live R process needs an explicit **drive cable**:
  - arf → `arf ipc …` (**only if that arf process has IPC enabled**)
  - RStudio (and other MCP-registered sessions) → btw MCP (`run_r`, env, …)
- There is **no** stock option that is both (a) agent-driven persistent R and
  (b) a full human-style typed REPL transcript the user watches line-for-line.

Persistence ≠ drivability ≠ visibility. Agents constantly conflate these three.

Optional future cables (not stock here): PTY MCP, computer-use, DIY pipes —
mention in skills as “other ecosystems,” not defaults.

---

## 2. Hosts vs cables (do not mix)

| Host | What it is | How an agent drives it |
|---|---|---|
| **arf** | arf’s own R process | `arf ipc` **only if IPC is on** (headless or `--with-ipc` / `:ipc start`) |
| **RStudio** | RStudio’s own R (`rsession`) | **btw MCP** (`btw_mcp_session` / `mcp_session` in that R) — never arf IPC |
| Batch R | short-lived process per invocation | `Rscript` / `R.exe` / `Rterm` / `arf -e` / `arf -f` |

**Wrong phrasing (do not use):** “arf IPC against the user’s RStudio.”  
arf cannot be the host of an RStudio session. Different processes, different
cables.

### Critical machine detail: “R Interactive” arf ≠ IPC server

On this Cursor setup the R extension’s default terminal can be **arf** as the
console binary, e.g.:

```text
arf.exe --no-save --no-restore
```

(Parent: Cursor.exe. Observed PID example: 34732.)

That process:

- **is** an arf-hosted R (human / extension owned),
- typically has **no IPC** (`arf ipc list` empty for it),
- may still appear in **btw** `list_r_sessions` as something like `skillz (arf)`
  because `btw_mcp_session()` / `mcptools::mcp_session()` registered it — that is
  **MCP session discovery**, not arf IPC.

So three different things share the word “arf”:

1. **Extension REPL arf** — human-visible; agent cannot `arf ipc` it unless IPC
   was enabled; **never kill on agent cleanup**.
2. **Agent headless arf + IPC** — agent-owned drive cable; shutdown by PID.
3. **btw row labeled `(arf)`** — means “MCP can see that R”; prefer btw only for
   *inspect that session*, not as substitute for (2) when doing agent-owned work.

**btw discovery ≠ arf IPC discovery.**  
`list_r_sessions` uses mcptools per-user sockets. `arf ipc list` reads arf
session metadata / named pipes. One can be non-empty while the other is empty
(observed: btw showed `skillz (arf)` + `jimmy (RStudio)` while `arf ipc list`
was `[]`).

---

## 3. Intent → tool (the router)

These are the intents that matter. Everything else is a footnote.

### A. Agent needs its own long-lived / non-batch R session

**Use: agent-owned arf headless + IPC.**

Meaning:

1. Agent **creates** the session (`arf headless …`).
2. Agent **reuses that one** for the task (many `arf ipc eval` calls).
3. Agent **shuts it down** when done (`arf ipc shutdown --pid …`).

Not: attach to Jimmy’s arf. Jimmy is usually in **RStudio**, not arf. Attaching
to a human interactive arf+IPC session is **rare**.

Not: the extension’s `arf --no-save --no-restore` tab — that is Jimmy’s/editor’s
session unless he explicitly asks the agent to use it (and even then, without
IPC the agent still cannot drive it via `arf ipc`).

Lifecycle rules:

- Prefer **one** agent R session unless there is a real reason for two.
- `arf ipc list` first — if **this task** already started a headless session,
  reuse it; do not open another “because it’s easier.”
- Always `--vanilla` for agent sandboxes unless the user asked for their profile.
- For 0.5.x silent eval: start with `--ipc-eval-unrestricted` (and/or use
  `--visible`). Empty `[ipc.eval].allowed_functions` rejects almost all real code
  on silent eval.
- Do not hardcode R install paths. Prefer arf’s resolver (`arf r resolve`).
  Selection uses `--r-home` / `--with-r-version` / `ARF_R_HOME` /
  `ARF_R_VERSION` / `arf.toml` / rig / PATH — **not** “whatever feels right.”
  Inherited env `R_HOME` is only a discovery-layer input when config falls into
  PATH mode (upstream precedence); on this machine resolve currently picks
  `startup.r_source` → **rig** → R 4.6.1 even when `R_HOME` is set.
- **Shutdown only PIDs the agent started.** Closing a Cursor terminal tab does
  not reliably tear down Windows arf (orphan risk). Prefer
  `arf ipc shutdown --pid` for headless.
- **Never** blanket `Stop-Process` on all `arf`. That destroys the user’s R
  extension terminal. Track agent-owned PIDs only.
- Interactive sessions: `arf ipc shutdown` returns `METHOD_NOT_FOUND` (“shutdown
  is only available in headless mode”). If the agent started interactive arf for
  a demo, end **that PID only** — still never “all arf.”

### B. Help / context about R — no need to execute code

**Use: btw MCP tools first.**

Examples: help pages, vignettes, NEWS, CRAN search, “is package installed?”,
platform/sessioninfo, function signatures from **local** installed packages.

Prefer btw over:

- web search for the same local help, and
- running R / `Rscript` / arf IPC “just to print `?foo` or `args()`”.

**Do not run code when docs/env tools suffice.**

Upstream btw explicitly recommends coding agents omit overlapping tools and use
groups like `docs` + `pkg` (+ optionally `env` / `sessioninfo` / `cran`). Local
`run_r` is opt-in (`BTW_RUN_R_ENABLED` / `btw_tools("run")` / tools list
including `'run'`).

### C. Vision into the user’s RStudio session

**Use: btw** (`list_r_sessions` → `select_r_session` → env describe / data frame
describe / `btw_tool_run_r` as needed).

This is common (shape of a data.frame, what’s in `globalenv()`, etc.).

Requires `btw_mcp_session()` / `mcptools::mcp_session()` in that R (often via
`.Rprofile`). Without sessions, tools run in the **MCP server’s own** R process
(not RStudio).

Notes from live trial:

- `btw_tool_run_r` **does** mutate RStudio `globalenv` (objects appear in the
  Environment pane — confirmed: `x`, `y`, `agent_marker`).
- Console is often **silent** — do not assume the user saw the code there.
- Selecting/poking a stale session can surface `later::execLater` callback
  errors in the R console (observed once; restarting RStudio cleared it).

### D. Batch / one-shot

`arf -e`, `Rscript -e`, etc. Fine. No session lifecycle. Use when state across
steps is not needed.

---

## 4. Visibility (required for every execution path)

Terminal/`--visible`/Environment pane are **unreliable** as the user’s audit log.

**Skill rule:** whenever the agent executes R (arf IPC, btw `run_r`, or batch),
it must **show the user all R code it runs in the chat** (before or as it runs).

Reasons this matters:

- User often wants agent-driven R for codebase changes instead of manual
  edit/diff — needs to see what ran.
- Headless `--visible` mostly shows **output**, not full input echo (observed:
  `cat`/`print` lines appeared; earlier assignments did not echo as typed code).
- `arf ipc history` records commands (good audit for arf; still paste in chat).
- btw `run_r` updates Environment without echoing to the RStudio console.
- Interactive arf `ipc send` / `--visible` may **prompt for approval** (0.5.0+)
  and can time out waiting — still not a dependable transcript.

Chat = source of truth for “what R did the agent run.”

---

## 5. Method cheat-sheet

| Method | Persistent? | Agent-drivable? | User sees code by default? | Role |
|---|---|---|---|---|
| `Rscript` / `R` / `Rterm` / `arf -e` | No | Yes (each call) | stdout in agent terminal | Batch only |
| Interactive arf, no IPC (incl. R extension `arf --no-save --no-restore`) | Yes if left open | **No** via `arf ipc` | Yes if *user* types | Human / editor REPL |
| Same arf, if also MCP-registered | Yes | Via **btw** only (inspect/`run_r`) | Usually silent console | Rare; don’t confuse with agent IPC |
| Agent headless arf + IPC | Yes | Yes (`arf ipc`) | Partial output; **must paste code in chat** | **Default agent long-lived R** |
| Human arf + `--with-ipc` (rare) | Yes | Yes (careful; approval) | REPL-ish; may prompt | Attach only; don’t shutdown |
| btw docs/env/cran/… | N/A | Yes (MCP) | N/A | Help/context; no code |
| btw `run_r` → RStudio | Yes (that session) | Yes | Environment yes; console often no; **must paste code in chat** | User session vision / mutate |

---

## 6. arf IPC allowlist (0.5.x) — short

**Upstream breaking change in v0.5.0** (still current on this machine: **arf 0.5.2**,
WinGet shim `C:\Program Files\WinGet\Links\arf.exe`).

Silent `arf ipc eval` (default) is **syntactic** allowlist-gated
(`[ipc.eval].allowed_functions`, default `[]`). Not an R sandbox.

Empty allowlist allows roughly: pure literals (`1`, `"hi"`, `TRUE`) and bare
names (`mtcars`). **Not** `1 + 1` (`+` must be listed). Nested calls all need
entries. Assignments / control flow / `|>` / `:::` rejected in restricted mode.

**Re-verified this pass:** restricted headless + empty allowlist → `1+1` =
`R_EVAL_NOT_ALLOWED`; `1` OK; `--visible` assignment OK; then
`shutdown --pid` cleaned up. User extension arf PID left untouched.

Agent-owned servers: `--ipc-eval-unrestricted` at startup, and/or `--visible`
(bypass allowlist; shows in session output). Do **not** maintain a giant function
list for trusted local agent use.

Policy rejects ≠ R eval errors (different IPC error shape / exit). R errors in
successful IPC responses still exit 0 with result `error` field set.

`--vanilla` skips R profiles; it does **not** skip `arf.toml` IPC policy
(this machine: `[ipc.eval] allowed_functions = []`).

Interactive (0.5.0+): `send` and `eval --visible` show submitted code and ask
for confirmation unless `:ipc send-policy allow`. Headless runs visible
requests immediately without that prompt.

Personal `~/.cursor/skills/arf-ipc` still declares `arf_min_version: "0.4.5"` and
shows silent `library()` / `|>` examples — **stale for 0.5.x** until updated or
retired into `skills/r-arf`.

---

## 7. Non-conflation rules (hard)

1. **btw questions → btw MCP tools.** Never Shell/`Rscript`/arf IPC to fetch btw
   help, list tools, or “check what btw can do.”
2. **Agent long-lived R → arf IPC the agent started.** Not btw `run_r` on an arf
   row in `list_r_sessions` when a dedicated agent IPC server exists for the task.
3. **RStudio → btw only.** Never frame this as arf IPC.
4. **Extension REPL arf ≠ agent IPC.** Do not `arf ipc` it unless IPC is actually
   enabled; do not kill it during agent cleanup.
5. **Don’t run R to answer doc questions.**
6. **Don’t open extra arf terminals** when one agent session already serves the task.
7. **Don’t use one tool as transport for another** (arf to read btw; btw to replace
   agent arf IPC; etc.).
8. **Cleanup only agent-owned PIDs.** Never blanket-kill `arf`. Prefer
   `arf ipc shutdown` for headless the agent started.
9. **Always paste executed R into chat.**

---

## 8. Naming in this repo

| Skill folder | Means |
|---|---|
| `r-arf` | arf console / IPC / agent-owned R execution |
| `r-cli` | R **`{cli}`** package — **not** “command line” / not arf |

Keep the `r-` namespace prefix. Do not rename `r-arf` → `r-cli` or bare `arf`.

Likely future split (not decided): general **terminal/REPL** skill (Shell ≠ TTY,
one session, PID hygiene) → `r-arf` + `r-btw`/`r-mcptools` → consumers
(`r-package-dev`, `r-cli` for messaging style only).

Personal `~/.cursor/skills/arf-ipc`: stub/retire after `skills/r-arf` absorbs a
0.5.2-correct golden path.

---

## 9. Skill packaging guidance (when curating for real)

Split by ownership of concerns:

- **Generic terminal/REPL skill (optional):** §1 + “one long-lived process” +
  “only tear down what you started” — applies to python/node/WSL too.
- **`r-arf`:** intent A + D (agent arf IPC + batch-via-arf notes); lifecycle;
  allowlist; Windows shutdown hygiene; PID tracking; chat visibility; “not for
  RStudio / not for docs / not extension REPL.”
- **btw / r-btw skill:** intents B + C; tool map (`docs_*` vs `run_r` vs
  `select_r_session`); chat visibility for `run_r`; “not for agent-owned
  multi-step R when arf IPC is the task executor.”
- **Consumers** (`r-package-dev`, etc.): one-line gates + links — do not embed
  IPC tutorials.
- **`r-cli`:** how to format messages *inside* R code the agent runs — not which
  cable runs it. `r-arf`/`r-btw` may point at it for user-facing messaging.

Optional shared **router blurb** (same table + §7 rules) at the top of both R
skills so neither “wins” by accident.

Vendor docs (`configuration.md`, full `ipc.md`, …) under `references/vendor/` —
load on demand (e.g. configuring arf). Curated agent refs stay separate so sync
doesn’t overwrite them. **`sync-docs.ps1` bug confirmed:**  
`Join-Path $PSScriptRoot "references"` → `skills/r-arf/scripts/references`
(wrong). Should write `../references/vendor/` (+ manifest).

Default agent R posture to encode:

```text
arf headless --json --vanilla --ipc-eval-unrestricted
arf ipc eval --visible --pid <PID> '<code>'   # plus paste <code> in chat
…
arf ipc shutdown --pid <PID>
```

---

## 10. Failures / lessons from these sessions (so skills prevent them)

| Mistake | Correction |
|---|---|
| Assumed Shell can type into live `arf` | Needs IPC or other side channel |
| Win32 console inject / ridiculous hacks | Out of scope; use IPC |
| Used arf IPC to read btw package help | Use `btw_tool_docs_*` |
| Claimed “arf IPC against RStudio” | Impossible; different hosts |
| Implied every Shell call = new R | Wrong; problem is drive API, not persistence |
| Opened multiple arf terminals for one exploration | One agent session; reuse |
| Blanket `Stop-Process` on all `arf` | Killed user’s R extension session — never again |
| Assumed `--visible` = full code transcript | Mostly output; chat must carry code |
| Assumed btw `run_r` prints in RStudio console | Objects may appear with silent console |
| Interactive `ipc send` without expecting approval | Timed out waiting on human/policy (0.5+) |
| Treated empty allowlist as “literals including `1+1`” | Operators need allowlisting; use unrestricted for agents |
| Personal `arf-ipc` golden path without 0.5 allowlist | Stale for current arf |
| Confused extension arf with IPC-capable arf | Check `arf ipc list`; `--no-save --no-restore` ≠ headless IPC |

---

## 11. One-paragraph summary

For **agent-owned persistent R**, the agent starts **one** headless arf IPC
session, reuses it, pastes all R into chat, and shuts down that PID only. For
**docs/help without execution**, and for **seeing or lightly using RStudio
state**, use **btw** — never arf-as-RStudio and never Shell-as-btw. The editor’s
interactive arf tab is not an agent IPC server unless IPC is enabled — and even
when btw can *see* it, that is MCP discovery, not a reason to conflate cables.
Batch one-shots are fine when persistence isn’t needed. No stock path gives a
perfect shared live REPL transcript; skills must say that once and then route by
intent without conflating hosts or tools.

---

## 12. Open / verify with Jimmy

- [x] Intent table matches stated preferences (A–D) — Jimmy affirmed scratch as solid.
- [x] Chat-paste of all R mandatory even with `--visible` — affirmed.
- [ ] Decide fate of personal `arf-ipc` vs `skills/r-arf`.
- [ ] Decide whether `mcp.json` should **keep** staged
      `btw_mcp_server(list(..., 'run'))` + `BTW_RUN_R_ENABLED=true` permanently
      (currently present in `~/.cursor/mcp.json` from this exploration).
- [ ] Decide whether a generic terminal/REPL skill should exist above `r-arf`.
- [ ] Promote this file into real skill text; then delete or archive this scratch.

---

## 13. Verification log (2026-09-24 evening)

### Machine / install

| Fact | Evidence | Strength |
|---|---|---|
| arf **0.5.2** via WinGet shim | `arf --version`; `where.exe arf` → `C:\Program Files\WinGet\Links\arf.exe` | Confirmed |
| `[ipc.eval] allowed_functions = []` in user config | `%APPDATA%\arf\arf.toml` | Confirmed |
| Resolve → R 4.6.1 via rig / `startup.r_source` | `arf r resolve` JSON | Confirmed |
| Env `R_HOME` set but not the selected_by source here | `$env:R_HOME` set; resolve `selected_by.source` = arf.toml | Confirmed for this config; PATH-mode caveat in upstream docs |
| RStudio 2026.09.0+174 desktop available | btw `sessioninfo_platform` after select | Confirmed |
| btw sessions: `1: skillz (arf)`, `2: jimmy (RStudio)` | `list_r_sessions` | Confirmed |
| Extension arf: `--no-save --no-restore`, no IPC in `arf ipc list` | WMI CommandLine on live PID; `arf ipc list` → `[]` | Confirmed |
| `mcp.json` includes `run` + `BTW_RUN_R_ENABLED` | `~/.cursor/mcp.json` (staged this session) | Confirmed present; permanence TBD |
| `sync-docs.ps1` writes under `scripts/references` | script source | Confirmed bug |
| Personal `arf-ipc` min version 0.4.5 | skill frontmatter | Confirmed stale vs 0.5.2 |

### Behavior re-checks

| Claim | Evidence | Strength |
|---|---|---|
| Desktop Agent: no stdin to running TTY | Cursor docs + cursor-guide | Confirmed |
| Silent empty allowlist blocks `1+1`, allows `1` | Live headless restricted retest | Confirmed |
| `--visible` bypasses allowlist on headless | Live retest + upstream 0.5.0 notes | Confirmed |
| `shutdown` headless-only | Live `METHOD_NOT_FOUND` on interactive earlier; upstream docs | Confirmed |
| Interactive visible/send needs approval (0.5+) | Upstream v0.5.0 release notes; timeouts observed | Confirmed |
| Headless `--visible` ≠ full input echo | Terminal showed prints, not assignment source | Confirmed (UX) |
| btw `run_r` mutates RStudio env; console often silent | Live assign; user saw Environment objects | Confirmed |
| btw docs tools work without Shell/arf | `btw_tool_docs_help_page` this pass | Confirmed |
| MCP session registration via `mcp_session` / `btw_mcp_session` | mcptools + btw help | Confirmed |
| WinGet portable lock if orphan arf left running | Personal `arf-ipc` skill (operational) | **Plausible / not re-proven this pass** — keep as hygiene warning |
| Closing Cursor tab leaves orphan child on Windows | Personal skill + prior session experience | **Operational** — treat as true for skill hygiene |

### Intentionally not re-opened

Did **not** start a long-lived agent headless for this pass beyond a
start→test→shutdown cycle (PID tracked and shut down). Did **not** kill
extension arf PID 34732.
