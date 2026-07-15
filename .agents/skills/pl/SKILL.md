---
name: pl
description: Short Codex alias for the product-lifecycle 20-agent product development workflow. Use only when the user explicitly invokes /pl or /product-lifecycle, asks to run a product lifecycle, start a full or lean product iteration, coordinate multiple product roles, or produce lifecycle artifacts such as PRD, architecture, implementation, QA, and quality gate reports. Do not use for ordinary coding tasks, small bug fixes, or single-file edits.
---

# Product Lifecycle Short Alias

Use this as the explicit `/pl` entry and delegate all behavior to the repository root skill.

1. Resolve `PACKAGE_ROOT` to the nearest ancestor containing `SKILL.md`, `agents/`, `templates/`, `skills/`, and `docs/`.
2. Set `WORKSPACE_ROOT` to the active business repository; it may differ from `PACKAGE_ROOT`.
3. Read `PACKAGE_ROOT/SKILL.md` completely and follow its scope gate, routing, output, and completion rules.
4. Read only the role, template, method, and reference files selected by the root skill.
5. Write business code and lifecycle artifacts under `WORKSPACE_ROOT`, never into an installed package by default.

Do not emit Claude-specific `Agent(...)` syntax. Use Codex delegation only when available, appropriate, and permitted by current tool instructions. Do not pass a `pages` parameter for non-PDF files. Preserve unrelated worktree changes.
