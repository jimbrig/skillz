# Evaluations

A suite is a set of realistic tasks. Each task runs twice from a clean context: once with the skills named in the file, once without them (or against the previous version of that same set). Grading uses evidence from the run. The case file does not name a model or a host.

How to write and grade a case: [evals/AGENTS.md](../evals/AGENTS.md). Folder map: [evals/README.md](../evals/README.md).

## Where cases live

```text
evals/<suite>/evals.json     authored cases
evals/<suite>/workspace/     runner output, gitignored
```

`skill_name` matches `<suite>`. `skills` lists every skill the with-skill run loads. One suite may name several skills, which is how a prompt that could hit `r-arf`, a btw skill, or another R skill stays one test.

The [Agent Skills guide](https://agentskills.io/skill-creation/evaluating-skills) puts `evals/evals.json` inside a single skill package. That fits a skill you publish alone. It fits this collection poorly, because a case that exists to tell two skills apart has no single package to live in. Copying one suite into a package is a publishing step, when you need it.

## What a pass is

An assertion has to be checkable from the trace, the files written, or the process outcome. The steps are in `evals/AGENTS.md`.

For a skill whose job is a procedure, grade the trace. Two runs can both return the right value and still differ in the command that produced it. `evals/r-arf/evals.json` is that kind of suite: the result of `x * 6` can be 42 either way, and the assertions are about `arf headless`, pid reuse, and shutdown.

Grade the product when the skill's job is the product. A chart file, a row count, or valid JSON can be checked without caring which commands ran. Those checks are more stable than wording checks, and they miss a skill that was ignored while the model still produced a plausible file.

A pass with no quoted evidence counts as a fail. Qualities that will not sit in a true/false line (the approach was allowed and still missed the point) go in a short human note on that case.

Two other ways to judge a run:

- **Answer only.** Cheap, and it hides a skill that changed the path while both sides got the answer right.
- **Blind comparison.** [skill-creator](https://github.com/anthropics/skills/blob/main/skills/skill-creator/references/schemas.md) can score two outputs without saying which skill produced which. Use it when both runs pass the assertions and you still need to pick a version. The judge is another model, so it will sometimes prefer style.

## Baseline

The first baseline is a run with the named skills withheld. That is the measurement of whether the skill did anything. An assertion that passes on both sides does not belong in the file.

Once a skill already works, the useful baseline is the previous version, not an empty context. You are then measuring a change. [Promptfoo's skill guide](https://www.promptfoo.dev/docs/guides/test-agent-skills/) is set up for that: same tasks, same model, swap the skill text.

Running only the with-skill side is faster and does not show whether the skill mattered.

## When assertions are written

`expected_output` is written with the prompt. Assertions are added after the first run, once the transcript shows which checks are real. This follows the [Agent Skills guide](https://agentskills.io/skill-creation/evaluating-skills).

Writing every assertion up front pins intent before you have seen a run. The cost is a file full of checks the model already passes with no skill, which inflates the with-skill score. Add those only when you already know they fail without the skill.

## Description checks

Behavior cases assume the skills in `skills` were loaded. They do not test whether a description would have loaded them.

Whether a description should fire is a separate list: prompts that should load the skill, and near-miss prompts that should load a sibling or none. The [description guide](https://agentskills.io/skill-creation/optimizing-descriptions) treats a query as passing when it triggers on more than half of several runs, because the same prompt will not trigger every time. Add that list when descriptions in the collection compete. Folding it into `evals.json` mixes routing with procedure.

## Runners

The case file stays the same across hosts. The runner is whatever executes it. Runner config and transcripts stay in `workspace/`.

| Runner | What it gives you | What it costs |
|---|---|---|
| The agent host you already use | The same tool access and skill loading as day-to-day work | Harder to repeat in CI. Cases that start processes have to run one at a time on a shared machine, or they see each other's processes |
| [skill-creator](https://github.com/anthropics/skills/blob/main/skills/skill-creator/references/schemas.md) on Claude Code | Executor, grader, benchmark summary, and a review view, in that host's loop | That host. Its schema calls the assertion list `expectations`; map `assertions` across |
| [Promptfoo](https://www.promptfoo.dev/docs/guides/test-agent-skills/) | Repeatable runs, a `skill-used` check, and side-by-side skill versions for Claude, Codex, and OpenCode | Those hosts' skill paths, not this repo's `skills/` layout, unless you stage a fixture |

One run per case is enough while the suite is small and the failures are obvious. Run a case three times when it flips between passes, or when you are measuring description triggering. Variance on a single run is noise.

## Sources

- [Evaluating skill output quality](https://agentskills.io/skill-creation/evaluating-skills) — prompts, with-skill and without-skill runs, assertions, grading.
- [Optimizing skill descriptions](https://agentskills.io/skill-creation/optimizing-descriptions) — separate checks for whether a description should load a skill.
- [skill-creator schemas](https://github.com/anthropics/skills/blob/main/skills/skill-creator/references/schemas.md) — grading records, benchmarks, and blind comparison. The assertion list is named `expectations`.
- [Test Agent Skills](https://www.promptfoo.dev/docs/guides/test-agent-skills/) — a runner that compares skill versions and checks which skill was used.
