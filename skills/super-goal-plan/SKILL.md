---
name: super-goal-plan
description: Use when turning a goal you state ("audit dependencies in 3 repos", "triage 20 open issues", "draft release notes for v2") into simple Linear issues a runner can execute. Each issue is ONE goal written as a short prompt that names the skill to use.
triggers:
  - "plan a super goal"
  - "create a super goal backlog"
  - "turn a goal into a linear task"
---

# Super Goal Plan

Turn the goals the user states into Linear issues. Keep it simple: **one goal = one issue = a short prompt that names a skill.** The named skill does the real work; the issue is just the prompt, the skill to run, and how the prompt is bounded.

The shared vocabulary is in `references/control-plane-contract.md`. For a dry run, follow that file's dry-run section and create nothing.

## What an issue looks like

For each goal, create ONE Linear issue:

- **Title** — the goal in a line, ending with the skill, e.g.
  `Triage 20 open issues — issue-triage`
- **Body** — the skill on its own first line, then 2-4 plain sentences the runner reads as its prompt. The last sentence states how a worker proves it finished:
  ```
  skill: issue-triage

  Triage the 20 oldest unlabeled issues in the acme/api repo.
  Use the skill's own labels and conventions.
  Done when each of the 20 issues has a proposed label in a comment on this Linear issue.
  ```
- **Labels** — `super-goal`, `resource:<name|none>`, `approval:<draft-only|needs-approval|autonomous-with-bounds>`.

## How to plan

1. **Use the goals and numbers the user gave.** Do not break one goal into batches unless they ask.
2. **Pick one skill per issue.** Use the skill the user named. If they didn't name one, choose the best-fit *installed* skill and say which you chose. If no installed skill fits, stop and tell the user rather than writing a procedure into the issue.
3. **Write the body as a prompt**, not a procedure. If you catch yourself writing steps, stop: the skill is the steps.
4. **Write a checkable end state.** A worker must be able to show it in its own output: a count, an exit code, a comment on the issue.
5. **Set the approval label.** Use `draft-only` unless the user explicitly asked for more for this goal. Never infer `autonomous-with-bounds`. For `needs-approval`, end the body with `Ready for approval when...`, because the step itself stays undone.
6. **Set the resource label.** Use `resource:none` unless the goal needs something only one worker can use at a time.
7. **Create the issue in Backlog,** in the project the user names and that project's team, asking which team if it has more than one. First create any missing labels, including `super-goal` and all three `approval:` labels. Don't move issues to Todo: that's the human's review step.
8. **Create issues in the order they should run.** The runner pulls by priority, then oldest first. Set a priority only if the user ranked the goals.
9. **One issue per goal.** If a goal is genuinely two activities, make two issues, each naming its own skill.

## Do NOT

- Do not create a parent "GOAL" control ticket. Each issue IS a goal.
- Do not name `super-goal-run` as an issue's skill. Name the execution skill.
- Do not restate the skill's procedure in the body.
- Do not put secrets or personal data in an issue. Issue text is passed to agents as their prompt.

## Output

The created issue IDs, their titles, the skill each names, and each approval label — one line per issue. Then remind the user to review them and move them to Todo.
