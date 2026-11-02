# Super Goals

A small work queue for coding agents, built from two skills and Linear.

You state goals. `super-goal-plan` turns each one into a short Linear issue that names
a skill. `super-goal-run` works through the issues in priority order, firing each as
its own worker session.

There is no server or database. It's about 200 lines of agent instructions, plus
Linear as the queue.

> **Status: experimental.** The skills have been dry-run on paper, but this version
> hasn't been run against a live Linear workspace yet. Start with `draft-only` issues.

## How it works

```text
"Triage 20 open issues"
        │
        ▼
 super-goal-plan ──▶ Linear issue
                     skill: issue-triage
                     + prompt, end state, labels
                            │
                            ▼
                     super-goal-run ──▶ one worker session per issue
                            ▲                     │
                            └── Done / Blocked ◀──┘
```

- **One goal is one issue.** The body is a short prompt that names a skill and says how
  to prove the work is finished.
- **The skill does the work.** Issues don't contain procedures.
- **Linear is the state machine.** Status is the queue, and labels hold the approval
  mode and resource.
- **Each goal gets a fresh session.** Claude Code workers use the native `/goal`
  feature. Codex workers use `codex exec`, and other hosts get a fresh session or
  subagent with the same condition.
- **You release the work.** New issues start in Backlog, and the runner only pulls
  Todo, so nothing runs until you've reviewed it.
- **Exclusive resources are serialized.** If only one worker can use something at a
  time, give it a `resource:` label. With several runners, add a lease tool. The
  [contract](skills/super-goal-plan/references/control-plane-contract.md) defines what
  that tool needs to do.

## Requirements

- An agent host that can load skills, such as Claude Code or Codex
- A Linear workspace, with the Linear MCP server connected to that host
- For Claude Code `/goal` workers: v2.1.139 or later
- The skills your issues name, installed where worker sessions can load them. This repo
  doesn't include any execution skills.
- Worker permissions set up in your host's settings. Workers run without you there, so
  a tool that isn't allowed stops them.

## Install

**Claude Code plugin:**

```bash
claude plugin marketplace add mcnutt1414/super-goals-oss
```

```bash
claude plugin install super-goals@super-goals
```

**Any host with a skills directory:** clone the repo and link the skills in.

```bash
git clone https://github.com/mcnutt1414/super-goals-oss.git
```

```bash
cd super-goals-oss && scripts/install-skills.sh ~/.claude/skills
```

For Codex, pass `~/.codex/skills` instead. The skills are linked to your clone, so keep
it in place. To try them in Claude Code for one session without installing, run
`claude --plugin-dir /path/to/super-goals-oss` from anywhere.

## Setup

In the Linear team that owns your project, add a `Blocked` status. Linear doesn't
include one by default, and the runner stops if it can't find one. The planner creates
the labels, including all three approval labels.

## Use it

1. Ask your agent to plan: *"Plan a super goal: triage the 20 oldest unlabeled issues
   in acme/api, in the Linear project agent-queue."*
2. Review the new issues in Backlog. Change any approval labels you want to raise, then
   move the ones you want to run to Todo.
3. Ask your agent to run: *"Run the super goals backlog in agent-queue for 2 hours."*
   It runs one worker at a time unless you ask for more. The time budget stops new
   workers, and running workers get to finish.
4. Check anything that ended in Blocked. A `Waiting for approval` comment means a
   `needs-approval` issue has its step prepared for you.

To check a plan first, ask for a dry run. It describes what would happen without
touching Linear.

See [examples/backlog.md](examples/backlog.md) for sample issues.

## Safety

Read this before running anything unattended.

**What it does:**

- Issues default to `draft-only`. A missing or unknown approval label, or more than
  one, is treated as `draft-only`.
- Only the label sets the approval mode. The runner ignores issue text that tries to
  raise it and tells workers to do the same.
- Issue bodies are never placed in a shell command. Workers read them from Linear.
- The runner only pulls from the one project you name.
- `needs-approval` workers prepare the irreversible step, comment it, and stop. The
  issue settles as Blocked until a human takes over.
- These rules are agent instructions, so they depend on the agent following them. They
  aren't enforced by code. A worker can still be misled by what it reads.

**What it doesn't do:**

- **No caps.** The runner doesn't count actions or limit volume.
- **No dedupe.** It doesn't remember past work, so it won't stop a skill from repeating
  an action.
- **No resume state.** Linear status is the only state. An interrupted run can leave
  issues In Progress for you to review.

Only use `autonomous-with-bounds` with a skill that enforces its own limits and dedupe.

**Issue text becomes agent input.** Anyone who can edit or comment on issues in your
project can influence what a worker does, so treat that access like write access to
your agent. Keep the permissions on your workers narrow, and don't run workers with
approvals or sandboxing bypassed.

**Follow the rules of the services you automate.** Many platforms restrict automated
messaging, posting, and account use. You're responsible for what your agents do with
your accounts.

## Layout

```text
skills/
  super-goal-plan/SKILL.md
  super-goal-run/SKILL.md
  super-goal-*/references/control-plane-contract.md   # shared, kept byte-identical
  super-goal-*/agents/openai.yaml                     # Codex interface
examples/backlog.md                                   # sample issues
scripts/
  install-skills.sh
  check-contract-sync.sh                              # guards the shared contract
  smoke-test.sh                                       # static checks on the skills
.claude-plugin/                                       # plugin and marketplace manifests
```

The two contract copies must stay byte-identical so either skill can be installed on
its own. Edit the `super-goal-plan` copy, then copy it over the other one.

## Tests

```bash
scripts/smoke-test.sh
```

This checks the structure and required text of the skills. It doesn't touch Linear or
run the loop.

## License

[MIT](LICENSE)
