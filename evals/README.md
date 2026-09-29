# Evaluations

| Path | What it is |
|---|---|
| `<name>/evals.json` | Authored cases for that suite |
| `AGENTS.md` | How to write and grade cases |
| `<name>/workspace/` | Runner output, ignored by `.gitignore` in this folder |

`skill_name` matches the suite directory. `skills` lists every skill the with-skill run loads. One file may name several.

Cases describe the task and what must be observable. They do not name a model or a host. Runner config and transcripts go in `workspace/`.

`r-arf/evals.json` loads `r-arf`. A suite whose prompts can hit more than one skill lists each of them in `skills`.

Read [AGENTS.md](AGENTS.md) before adding or running evals. Approach, tradeoffs, and sources: [docs/evals.md](../docs/evals.md).
