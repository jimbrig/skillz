# Evaluations

Cases live in this folder. A case is a task and a description of what must be observable when it is done. The file does not name a model, a vendor SDK, or a host's tools.

`skill_name` matches the suite directory. `skills` lists every skill the with-skill run loads. One file may name several. Runner config and transcripts go in `<name>/workspace/`, which this folder's `.gitignore` ignores.

Worked example: [r-arf/evals.json](r-arf/evals.json). Approach, tradeoffs, and sources: [docs/evals.md](../docs/evals.md).

## Cases

Start with 2 or 3. Each case has:

- `id` — integer
- `name` — short slug, used as a directory name
- `prompt` — something a person would type, with real paths and names when the task has them
- `expected_output` — prose for what success looks like
- `files` — optional inputs, paths relative to the suite directory
- `assertions` — added after the first run

Vary the wording. Include one edge: a refusal, a malformed input, or a request the skill should not follow literally. Leave `assertions` out until a run has happened. The first look at a transcript is what shows which checks are real.

```json
{
  "skill_name": "example",
  "skills": ["example"],
  "evals": [
    {
      "id": 1,
      "name": "short-slug",
      "prompt": "User's task, in the words they would use.",
      "expected_output": "What a successful run produces or does.",
      "assertions": [
        "A checkable statement about the trace or the files."
      ]
    }
  ]
}
```

Some runners name this list `expectations`. Keep `assertions` in the file. A runner that wants the other name maps the field.

Do not link these cases from `skills/<name>/SKILL.md`.

## Assertions

An assertion is true or false from evidence: a file, a command in the trace, a process outcome, or text the run actually emitted.

- Checkable: "A command starts arf headless with --vanilla."
- Too vague to grade: "The output is good."
- Too brittle: an exact sentence the model must print.

Grade the trace when the skill's job is a procedure. A correct final answer that both runs produce does not show that the skill did anything. Drop an assertion that passes with the skill and without it.

## Running

Run each case twice from a clean context. One run gets the skills named in the file and no others. The other gets those skills withheld, or gets the previous version of them. Same prompt, same inputs. When the file names several skills, the with-skill run is the one that can see all of them. The comparison is still against a run that sees none of them, unless you are comparing two versions of the same set.

Record the commands, the files written, and the final answer. When a case starts or attaches to processes, run cases one at a time. Parallel runs on one machine can see each other's processes.

Read the transcript from disk before grading. A claim that a file was written is not the file.

## Grading

For each assertion, record pass or fail and quote the evidence. A pass with no quote counts as a fail.

Write that record next to the run (`grading.json` in the iteration directory).

Then look across the pair of runs:

- Passed on both sides: drop the assertion.
- Failed on both sides: the assertion or the case is wrong. Fix that before editing the skill.
- Passed only with the skill: keep it. That is the skill's effect.

Add a short human note per case for anything an assertion cannot hold (the approach was wrong, the result was allowed but missed the point). An empty note means the run looked fine.

## Changing the skill

Generalize from the failed cases. A sentence that only makes this prompt pass will fail the next one.

Keep the skill short. If the pass rate stalls while `SKILL.md` grows, delete instructions and rerun.

Put the new run in a new `iteration-N` directory. Stop when the notes are empty, or when another pass does not change the result.

## Trigger checks

Whether the description should load the skill is a separate list: prompts that should load it, and near-miss prompts that should load a sibling or none. Keep that list out of `evals.json`. It tests the description. Add it when descriptions in the collection compete. It does not replace the behavior cases above.
