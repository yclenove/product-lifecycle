---
name: product-lifecycle
description: Product-lifecycle 20-agent product development workflow. Use only when the user explicitly invokes /product-lifecycle or /pl, asks to run a product lifecycle, start a full or lean product iteration, coordinate multiple product roles, or produce lifecycle artifacts such as PRD, architecture, implementation, QA, and quality gate reports. Do not use for ordinary coding tasks, small bug fixes, single-file edits, or simple explanations.
---

# Product Lifecycle

Coordinate product work through role prompts, templates, method skills, and iteration artifacts. Keep context small: choose scope first, then load only the assets needed for the next role.

## Resolve Roots

Resolve two roots before reading or writing files:

- `PACKAGE_ROOT`: the nearest ancestor containing `SKILL.md`, `agents/`, `templates/`, `skills/`, and `docs/`. Treat it as read-only runtime assets unless the user is maintaining this package.
- `WORKSPACE_ROOT`: the user's active product repository. Read product context and write code or lifecycle artifacts here.

The roots may be the same while maintaining product-lifecycle, but a globally installed package normally sits outside the business workspace. Never write product artifacts into an installed `PACKAGE_ROOT` by default.

Codex note: when reading Markdown, code, or config files, do not pass a `pages` parameter. Use page ranges only for PDFs.

## Scope Gate

Choose one scope before running roles. If the request is sufficiently clear but names no mode, use Lean iteration and state the selected roles.

| Mode | Use when | Role count |
|---|---|---|
| A. Full lifecycle | New product, major release, enterprise iteration, or explicit all-role request | all 20 roles |
| B. Lean iteration | Most features, refactors with product impact, and iteration planning | orchestrator plus 2-6 roles |
| C. Single role | The user requests one discipline such as PM, architect, QA, or reviewer | exactly one role |

## Routing Examples

| Request | Route |
|---|---|
| `/product-lifecycle 全量跑一个新 SaaS 产品` | Mode A |
| `/pl 给已有系统做一个新功能` | Mode B |
| `只让 architect 评估重构影响` | Mode C |
| `规划下一轮迭代，已有用户反馈` | Mode B with feedback and planning roles |
| `修一个普通 bug` | Do not use this skill unless explicitly invoked |

## Load By Need

| Need | Read from `PACKAGE_ROOT` |
|---|---|
| Role and template selection | `docs/04-reference/SKILL-ASSETS.md` |
| Output location and naming | `docs/04-reference/OUTPUT-PATHS.md` |
| Dependency ordering or feedback loops | `docs/03-workflow/WORKFLOW_DETAILS.md` |
| Codex behavior | `docs/02-tools/SKILL-CODEX.md` |
| Claude Code behavior | `docs/02-tools/SKILL-CLAUDE-CODE.md` |
| Cursor behavior | `docs/02-tools/SKILL-CURSOR.md` |
| OpenCode or generic harnesses | `docs/02-tools/SKILL-OTHER-TOOLS.md` |
| Long-running work | `docs/07-long-running/README.md` |

When a role recommends a method skill, read `skills/<name>/SKILL.md`. On Codex, consult `skills/using-superpowers/references/codex-tools.md` only when a method uses legacy tool names.

## Execute

1. Inspect `WORKSPACE_ROOT`, its git status, and existing `docs/iterations/current/` artifacts.
2. Select the mode, roles, dependencies, expected outputs, and validation gates.
3. Start with `agents/orchestrator.md` unless Mode C names another role.
4. Read each role prompt and matching template only when that role is ready to run.
5. Run independent roles in parallel only when the current harness permits it and their inputs do not overlap.
6. Write iteration artifacts under `WORKSPACE_ROOT/docs/iterations/current/<type>/` according to `OUTPUT-PATHS.md`.
7. Loop through implementation, review, QA, and quality gates until the selected scope is verified.

Operating boundaries:

- Preserve the user's worktree changes; inspect status first and never revert unrelated work.
- Use web search only for time-sensitive market, competitor, pricing, legal, policy, or ecosystem claims.
- Keep package assets and business outputs separate.

## Recommended Lean Role Sets

| Scenario | Roles |
|---|---|
| New MVP | orchestrator, product-manager, architect, developer, qa-manager, quality-gatekeeper |
| Existing product feature | orchestrator, product-manager, architect, developer, qa-manager, quality-gatekeeper |
| Iteration planning | orchestrator, feedback-analyst, proactive-scout, iteration-planner, product-manager |
| Technical refactor | orchestrator, architect, developer, reviewer, qa-manager, quality-gatekeeper |
| UI/UX feature | orchestrator, product-manager, ui-designer, frontend-developer, qa-manager |
| Security-sensitive work | orchestrator, architect, security-engineer, developer, quality-gatekeeper |

## Codex Execution

Codex subagent tools are optional. Dispatch independent roles only when subagent tools are available and the current Codex tool instructions permit delegation; otherwise run roles sequentially in the current task. Current tool instructions override static tool-name mappings.

Treat bundled method skills as package resources; they do not need to appear in Codex's global skill catalog when this skill reads them by path. Do not emit Claude-specific `Agent(...)` syntax in Codex.

## Context Contract

Pass precise task context to each role or subagent: user goal, selected mode, relevant workspace artifacts, role prompt, template, destination under `WORKSPACE_ROOT`, and validation requirements. Do not pass hidden reasoning, full chat history, unrelated file dumps, or expected answers.

Use this handoff shape:

```text
You are the <role> in the product-lifecycle workflow.
Read <PACKAGE_ROOT>/agents/<role>.md and the required template.
Work on <WORKSPACE_ROOT> for this goal: <goal>.
Read only the relevant existing iteration artifacts.
Write to the path required by OUTPUT-PATHS.md.
Return changed files, decisions, risks, and validation performed.
```

## Completion Standard

Before finishing:

- Every selected role produced an artifact or code change, or explicitly reported why it was skipped.
- All artifacts are under the correct `WORKSPACE_ROOT/docs/iterations/` path.
- Relevant tests, linters, previews, or document checks passed.
- The handoff states changed files, decisions, validation performed, residual risks, and the next role or iteration.

## Maintenance Validation

When maintaining this package, run the deterministic 65-gate check:

```bash
python scripts/check-product-lifecycle-skill.py --root .
```

Do not run package-maintenance checks during ordinary lifecycle executions.
