---
name: product-lifecycle
description: Product-lifecycle 20-agent workflow for Cursor. Use when the user explicitly asks for a product lifecycle, full or lean product iteration, coordinated product roles, or lifecycle artifacts such as PRD, architecture, implementation, QA, and quality-gate reports. Do not use for ordinary coding tasks, small bug fixes, or single-file edits.
---

# Product Lifecycle Cursor Adapter

Delegate the workflow to the repository root skill.

1. Resolve `PACKAGE_ROOT` to the installed product-lifecycle package containing `SKILL.md`, `agents/`, `templates/`, `skills/`, and `docs/`.
2. Set `WORKSPACE_ROOT` to the active business repository.
3. Read `PACKAGE_ROOT/SKILL.md` completely and follow it.
4. Read `PACKAGE_ROOT/docs/02-tools/SKILL-CURSOR.md` only for Cursor-specific setup or delegation behavior.
5. Keep package assets in `PACKAGE_ROOT` and business outputs in `WORKSPACE_ROOT`.

Use Cursor delegation only when available and permitted. Preserve unrelated worktree changes and load only selected resources.
