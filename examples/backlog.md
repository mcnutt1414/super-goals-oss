# Example backlog

Three issues, listed in priority order. The skill names are placeholders, so swap in
skills you have installed.

## 1. Audit dependencies in acme/api — dependency-audit

Labels: `super-goal`, `resource:none`, `approval:draft-only`

```text
skill: dependency-audit

Audit the production dependencies of the acme/api repo for known vulnerabilities.
Use the skill's own severity rules. Don't change any files.
Done when the findings, or a note that there are none, are in a comment on this issue.
```

## 2. Prepare the staging data refresh — staging-refresh

Labels: `super-goal`, `resource:staging-db`, `approval:needs-approval`

`staging-db` is an exclusive resource, so only one worker uses it at a time.

```text
skill: staging-refresh

Prepare a refresh of the staging database from the latest sanitized snapshot.
Do not run the restore.
Ready for approval when the snapshot name and restore command are in a comment on this
issue.
```

This one settles as Blocked with a `Waiting for approval` comment, and a human runs the
restore.

## 3. Draft release notes for v2.0 — release-notes

Labels: `super-goal`, `resource:none`, `approval:draft-only`

```text
skill: release-notes

Draft release notes for acme/api v2.0 from the commits since v1.9.
Group changes the way the skill's template does.
Done when the draft is in a comment on this issue.
```
