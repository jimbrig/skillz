---
name: r-arf
description: >-
  Run R with the arf CLI (https://github.com/eitsupi/arf). Use when R code
  needs to run, when an R session must stay up across calls, or when the
  question is about arf itself. Confirm arf is on PATH, run one-shot code
  with arf -e or arf -f, or start a headless IPC session and evaluate
  against it. For arf questions, use arf --help and the vendored docs.
metadata:
  author: jimmy.briggs@jimbrig.com
  r_version: ">= 4.3"
  arf_version: ">= 0.5.2"
---

# arf

`arf` is an R console. Run R with it. Do not open the interactive console to execute code.

Confirm it is available before the first call:

```sh
arf --version
```

If that fails, `arf` is not on `PATH` in this shell. Stop. Do not switch to another way of running R.

## One shot

Use this when nothing later needs the objects, packages, or options this code creates.

```sh
arf -e '<code>'
arf -f file.R
```

R starts, runs that input, and exits. There is no session to reuse and no IPC.

## A session to reuse

Use this when later calls must see what earlier calls created. Start a headless session for this work and leave it running in the background. Do not attach to an interactive console someone else is using.

```sh
arf headless --json --vanilla --ipc-eval-unrestricted
```

Stdout prints one JSON object when the server can accept clients. Take `pid` from it. `ipc_policy.silent.mode` must be `unrestricted`.

`--vanilla` skips R init files and workspace save/restore. `--ipc-eval-unrestricted` is startup-only. Without it, silent eval rejects assignment, `|>`, control flow, and function calls before R runs.

For each evaluation, show that R source in the reply, then run it against this pid:

```sh
arf ipc eval --pid <PID> '<R>'
```

State stays in that process. The reply is JSON. `stdout`, `stderr`, `value`, and `error` are always present. In silent eval the printed result is `value`. An R error is `error` and the process still exits 0. Exit 2, 3, or 4 means the IPC call failed.

When the work is finished:

```sh
arf ipc shutdown --pid <PID>
```

`shutdown` applies only to a headless session.

## Questions about arf

Use `arf --help` and `arf <command> --help`. Upstream pages for IPC, configuration, editors, and which R starts are under [references/vendor/](references/vendor/). If a page and the installed binary disagree, follow the binary.
