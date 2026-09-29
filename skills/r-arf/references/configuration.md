# arf configuration

Read this when the question is about `arf.toml`. The file on Windows is `%APPDATA%\arf\arf.toml`.

```sh
arf config check
arf config init
```

`init` writes a default file. `init --force` overwrites one. Do not run `--force` against a config someone is using.

Keys an agent run actually hits:

| Key | What it does |
|---|---|
| `startup.r_source` | `"auto"`, `"rig"`, or `{ path = "..." }`. `"auto"` uses rig's default when rig can resolve one. |
| `[ipc.eval] allowed_functions` | Exact functions silent `arf ipc eval` may call. Empty by default. An empty list still allows bare literals and bare names. |

Do not edit `allowed_functions` so an agent session can assign or call `library()`. Start that server with `--ipc-eval-unrestricted`. See [ipc.md](ipc.md).

`arf r resolve` prints which R would start. Precedence, override files, and the JSON fields are in [vendor/r-resolve.md](vendor/r-resolve.md). The process environment variable `R_HOME` is not what arf uses.

Prompt, editor keys, colors, history, and completion are the human console. Those keys, and everything else in the file, are in [vendor/configuration.md](vendor/configuration.md).
