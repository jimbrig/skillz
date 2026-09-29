# Session patterns

The lifecycle is [ipc.md](ipc.md). This file is for work that is still that session and no longer one eval.

## Several evals

Keep one server. Assign intermediates. Load a package once with `library()` on the unrestricted server. It stays loaded.

```sh
arf ipc eval --pid <PID> 'library(dplyr)'
arf ipc eval --pid <PID> 'by_cyl <- mtcars |> count(cyl)'
arf ipc eval --pid <PID> 'by_cyl'
```

`arf ipc history --pid <PID> --limit 10` is the log of completed commands, with `exit_status`.

After R writes a file, check that file in the same session before treating the write as done.

## Long jobs

Headless runs evals one at a time. `--timeout` bounds the client wait, not the R job.

- Run `arf ipc eval --timeout <ms> --pid <PID> '<job>'` and let that call finish. Other evals queue behind it. `arf ipc session` and `arf ipc history` still respond. While busy, `session` reports `r` as null and sets `r_unavailable_reason`.
- Or have the job write progress to a file and poll that file.

Do not spam eval retries while R is busy.

## Graphics

Headless uses file devices. Write a file and read that file.

```sh
arf ipc eval --pid <PID> 'png("plot.png", width = 900, height = 600); plot(mtcars$wt, mtcars$mpg); dev.off()'
```

`ggplot2::ggsave()` writes a file the same way.

## More than one session

One headless session per task. Pass `--pid` whenever more than one session exists, or the client returns `SESSION_AMBIGUOUS`.

Shut down only the headless pid this task started.
