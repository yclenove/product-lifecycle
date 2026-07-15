---
name: pl
description: Short Claude Code alias for the product-lifecycle 20-agent workflow. Use only when the user explicitly invokes /pl or /product-lifecycle, requests a full or lean product lifecycle, coordinates multiple product roles, or needs lifecycle artifacts such as PRD, architecture, implementation, QA, and quality-gate reports. Do not use for ordinary coding tasks, small bug fixes, or single-file edits.
---

# Product Lifecycle Short Alias

Delegate the workflow to the repository root skill.

1. Resolve `PACKAGE_ROOT` to the nearest ancestor containing `SKILL.md`, `agents/`, `templates/`, `skills/`, and `docs/`.
2. Set `WORKSPACE_ROOT` to the active business repository.
3. Read `PACKAGE_ROOT/SKILL.md` completely and follow it.
4. Use Claude Code-specific behavior only as described in `PACKAGE_ROOT/docs/02-tools/SKILL-CLAUDE-CODE.md`.
5. Keep package assets in `PACKAGE_ROOT` and business outputs in `WORKSPACE_ROOT`.

Preserve unrelated worktree changes and load only the selected role, template, and method files.
