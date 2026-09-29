---
name: r-arf
description: >-
  Run R with the arf CLI (https://github.com/eitsupi/arf). Use whenever R
  code needs to run: one-shot arf -e or arf -f, or a headless IPC session
  when state must persist across calls. Use when the question is about arf
  itself, its configuration, or which R it will start. If arf is not
  available, tell the user.
metadata:
  author: jimmy.briggs@jimbrig.com
  r_version: ">= 4.3"
  arf_version: ">= 0.5.2"
---

# arf

Run R with arf. Do not open the interactive console to execute code.

Show every R expression in the reply before running it.

arf chooses which R starts. Do not hardcode an R install path. `arf r resolve` prints the choice without starting R.

## Available

```sh
arf --version
```

If that fails, tell the user arf is not available and stop.

## One shot

Use this when nothing later needs the objects, packages, or options this code creates.

```sh
arf -e '<code>'
arf -f file.R
```

R starts, runs that input, and exits. There is no session to reuse and no IPC.

## A session

When later calls must see what earlier calls created, read [references/ipc.md](references/ipc.md) and follow it.

Read [references/patterns.md](references/patterns.md) if that session needs many dependent evals, a job longer than the client wait, graphics written to a file, or more than one session.

## Questions about arf

Use `arf --help` and `arf <command> --help`. If a doc and the installed binary disagree, follow the binary.

`arf ipc --help` shows a restricted server (`--ipc-eval-allow-function`). A session in this skill does not. Follow [references/ipc.md](references/ipc.md).

| Question | Read |
|---|---|
| `arf.toml` | [references/configuration.md](references/configuration.md) |
| IPC protocol, transport, JSON-RPC | [references/vendor/ipc.md](references/vendor/ipc.md) |
| Which R starts, beyond `arf r resolve` | [references/vendor/r-resolve.md](references/vendor/r-resolve.md) |
| Editor setup, migrating from radian | [references/vendor/editors.md](references/vendor/editors.md) |
| Prompt, color, keys, history, and the rest of the config | [references/vendor/configuration.md](references/vendor/configuration.md) |
