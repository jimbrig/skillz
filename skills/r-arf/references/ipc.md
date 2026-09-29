# arf IPC

Read this before using IPC. One long-lived R process is the server. Short `arf ipc` calls are the client. Objects and loaded packages stay in that process between calls.

```text
[background terminal]   arf headless --json --vanilla --ipc-eval-unrestricted
[agent shell calls]     arf ipc eval --pid <PID> '<R>'
```

Do not open a second R (`Rscript`, `R.exe`) for work that belongs in this session.

## Start

```sh
arf ipc list
```

`list` reads session files and works while R is busy. It does not include `ipc_policy`.

If this task already started a headless session, reuse that pid. Otherwise start one server and leave it running in a background terminal:

```sh
arf headless --json --vanilla --ipc-eval-unrestricted
```

Stdout prints one JSON object when the server can accept clients. Take `pid` from it. `ipc_policy.silent.mode` must be `unrestricted`.

`--vanilla` skips R init files and workspace save/restore. It does not lift the IPC allowlist. `--ipc-eval-unrestricted` is startup-only and overrides `[ipc.eval]` in `arf.toml` for this process. Do not edit `allowed_functions` to make a session usable.

The server inherits the terminal's working directory. Start it from the project root, or `setwd()` after. Early evals can return `R_BUSY` until the JSON has been printed. Retry that code only.

Reusing a headless session you did not just start: run `arf ipc session --pid <PID>` and read `ipc_policy.silent.mode` before the first assignment. If it is `restricted`, leave that session alone and start your own.

## Eval

Show the R expression in the reply, then:

```sh
arf ipc eval --pid <PID> '<R>'
```

Pass `--pid` once it is known.

The reply is JSON. `stdout`, `stderr`, `value`, and `error` are always present. In silent eval the printed result is `value`. An assignment is invisible, so `value` is null. An R error is `error` and the process still exits 0.

Exit 2, 3, or 4 means the IPC call failed. Read `error.code` before deciding what to do.

| Code | Exit | What to do |
|---|---|---|
| `R_BUSY` | 4 | Headless queues evals. Retry with backoff after startup. On an interactive session, R rejected the call. Poll `arf ipc session`. |
| `R_EVAL_NOT_ALLOWED` | 4 | Silent eval hit the allowlist. R did not run. Do not retry. On your server, restart with `--ipc-eval-unrestricted`. On a session you do not own, stop. |
| `USER_IS_TYPING` | 4 | Interactive only. Wait. |
| `SESSION_AMBIGUOUS` | 3 | Pass `--pid`. |
| `SESSION_NOT_FOUND` | 3 | Start `arf headless` as above. |
| `INCOMPLETE_INPUT` | 4 | Send a complete expression. |
| `INPUT_ALREADY_PENDING` | 4 | Interactive only. Wait. |
| `TRANSPORT_ERROR` | 2 | The server is gone. Check the background terminal. |

`arf ipc session` and `arf ipc history` do not touch R and work while R is busy. `--timeout <ms>` (default 300000) bounds the client wait. R keeps running after a client timeout.

On PowerShell, wrap the R expression in single quotes and use double quotes inside R. `$` in a double-quoted PowerShell string is expanded by the shell. For more than one line, or for quotes that will not survive the shell, write a temp `.R` file that assigns `result` and eval `source('C:/path/to/script.R'); result`. A bare `source()` is invisible, so `value` is null unless the eval also returns `result`. Use forward slashes in paths passed to R.

## Visible eval

Silent eval is the default. It returns the JSON above and does not echo the source into the server terminal.

`arf ipc eval --visible` skips the allowlist. On a headless session it runs immediately and still fills `value` and `error`. Use it when someone is watching that terminal. Still show the R source in the reply. `--visible` shows output. It does not reliably echo assignments.

`arf ipc send` prints into the server and returns only `{"accepted": true}`. On an interactive session, `send` and `--visible` wait for a person to approve. Do not use either to get around a restricted session you do not own.

## Shutdown

When the work is finished:

```sh
arf ipc shutdown --pid <PID>
```

Shutdown applies only to a headless session this task started. Closing the terminal is not shutdown. On Windows the `arf.exe` child keeps running and locks the WinGet package, so a later upgrade can remove `arf` from `PATH`.

Do not shut down `session_type` `interactive` or `null`. Do not stop an editor arf (`arf --no-save --no-restore`). Do not stop every `arf` process.

## Someone else's session

An interactive arf has IPC only if it was started with `--with-ipc` or the person ran `:ipc start`. Silent eval there is restricted. Keep those evals to bare names and literals. Do not assign, do not `shutdown`, and do not `send`.

For real work, start your own headless server.

## More

JSON-RPC methods, sockets, and the security model: [vendor/ipc.md](vendor/ipc.md).
