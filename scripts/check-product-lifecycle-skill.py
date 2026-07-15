#!/usr/bin/env python3
"""Run 65 deterministic quality gates for the product-lifecycle skill bundle."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Callable
from urllib.parse import unquote


EXPECTED_CHECK_COUNT = 65
README_MAX_LINES = 180

EXPECTED_ROLES = [
    "architect",
    "backend-developer",
    "data-analyst",
    "dba",
    "developer",
    "devops",
    "docwriter",
    "feedback-analyst",
    "frontend-developer",
    "iteration-planner",
    "market-analyst",
    "orchestrator",
    "proactive-scout",
    "product-manager",
    "project-manager",
    "qa-manager",
    "quality-gatekeeper",
    "reviewer",
    "security-engineer",
    "ui-designer",
]

EXPECTED_TEMPLATES = [
    "adr_template.md",
    "architecture_template.md",
    "backend_template.md",
    "data_template.md",
    "developer_template.md",
    "devops_template.md",
    "docwriter_template.md",
    "feedback_template.md",
    "frontend_template.md",
    "iteration_template.md",
    "market_template.md",
    "pmo_template.md",
    "product_template.md",
    "qa_template.md",
    "quality_report_template.md",
    "reviewer_template.md",
    "scout_template.md",
    "security_template.md",
    "ui_design_template.md",
    "workflow_plan_template.md",
]

EXPECTED_METHOD_SKILLS = [
    "brainstorming",
    "chinese-code-review",
    "chinese-commit-conventions",
    "chinese-documentation",
    "chinese-git-workflow",
    "dispatching-parallel-agents",
    "executing-plans",
    "finishing-a-development-branch",
    "mcp-builder",
    "receiving-code-review",
    "requesting-code-review",
    "subagent-driven-development",
    "systematic-debugging",
    "test-driven-development",
    "using-git-worktrees",
    "using-superpowers",
    "verification-before-completion",
    "workflow-runner",
    "writing-plans",
    "writing-skills",
]

SUPERPOWERS_SOURCE = {
    "repository": "https://github.com/jnMetaCode/superpowers-zh",
    "version": "1.7.0",
    "tag": "v1.7.0",
    "commit": "84026e57664cbb4d042f22b816db250f84890d62",
    "skill_count": 20,
    "license": "MIT",
    "frontmatter_policy": ["name", "description"],
}

REQUIRED_REFERENCES = [
    "docs/02-tools/SKILL-CODEX.md",
    "docs/02-tools/SKILL-CLAUDE-CODE.md",
    "docs/02-tools/SKILL-CURSOR.md",
    "docs/02-tools/SKILL-OTHER-TOOLS.md",
    "docs/03-workflow/WORKFLOW_DETAILS.md",
    "docs/04-reference/OUTPUT-PATHS.md",
    "docs/04-reference/SKILL-ASSETS.md",
]

NAVIGATION_DOCS = [
    "README.md",
    "docs/README.md",
    "docs/01-getting-started/QUICK-START.md",
    "docs/02-tools/HARNESS.md",
    "docs/02-tools/SKILL-CODEX.md",
    "docs/02-tools/SKILL-CLAUDE-CODE.md",
    "docs/02-tools/SKILL-OTHER-TOOLS.md",
    "docs/04-reference/CONSISTENCY-CHECKLIST.md",
    "docs/04-reference/DOC-MAP.md",
    "docs/04-reference/OUTPUT-PATHS.md",
    "docs/04-reference/SKILL-ASSETS.md",
]

OUTPUT_TYPES = [
    "market",
    "product",
    "architecture",
    "dev",
    "qa",
    "scout",
    "feedback",
    "iteration",
    "quality-gate",
    "misc",
]

SKILL_ENTRIES = {
    "root": {
        "path": Path("SKILL.md"),
        "name": "product-lifecycle",
        "max_lines": 140,
        "prompt_token": "$product-lifecycle",
    },
    "pl": {
        "path": Path(".agents/skills/pl/SKILL.md"),
        "name": "pl",
        "max_lines": 80,
        "prompt_token": "$pl",
    },
    "product-lifecycle": {
        "path": Path(".agents/skills/product-lifecycle/SKILL.md"),
        "name": "product-lifecycle",
        "max_lines": 80,
        "prompt_token": "$product-lifecycle",
    },
    "claude-pl": {
        "path": Path(".claude/skills/pl/SKILL.md"),
        "name": "pl",
        "max_lines": 40,
    },
    "cursor-product-lifecycle": {
        "path": Path(".cursor/skills/product-lifecycle/SKILL.md"),
        "name": "product-lifecycle",
        "max_lines": 40,
    },
}

HOST_ADAPTER_KEYS = ["pl", "product-lifecycle", "claude-pl", "cursor-product-lifecycle"]

OPENAI_YAML = {
    "pl": Path(".agents/skills/pl/agents/openai.yaml"),
    "product-lifecycle": Path(".agents/skills/product-lifecycle/agents/openai.yaml"),
}

DISALLOWED_PATTERNS = {
    "Claude-only frontmatter field": re.compile(
        r"^(when_to_use|argument-hint|allowed-tools):", re.MULTILINE
    ),
    "hard-coded home skill path": re.compile(r"~[/\\]\.claude[/\\]skills|~[/\\]\.Codex[/\\]skills"),
    "Claude Agent tool argument": re.compile(r"subagent_type\s*:"),
}


class CheckError(AssertionError):
    """Raised when a quality gate fails."""


@dataclass(frozen=True)
class Check:
    name: str
    fn: Callable[["Context"], None]


@dataclass
class Result:
    number: int
    name: str
    ok: bool
    error: str | None = None


class Context:
    def __init__(self, root: Path):
        self.root = root
        self.skill_texts = {
            key: self.read(entry["path"])
            for key, entry in SKILL_ENTRIES.items()
            if (self.root / entry["path"]).exists()
        }

    def path(self, rel_path: str | Path) -> Path:
        return self.root / rel_path

    def read(self, rel_path: str | Path) -> str:
        return self.path(rel_path).read_text(encoding="utf-8-sig")


def require(condition: bool, message: str) -> None:
    if not condition:
        raise CheckError(message)


def frontmatter(text: str) -> dict[str, str]:
    require(text.startswith("---\n"), "missing opening frontmatter delimiter")
    end = text.find("\n---", 4)
    require(end != -1, "missing closing frontmatter delimiter")
    fields: dict[str, str] = {}
    for raw_line in text[4:end].splitlines():
        line = raw_line.strip()
        if not line:
            continue
        require(":" in line, f"invalid frontmatter line: {raw_line!r}")
        key, value = line.split(":", 1)
        fields[key.strip()] = value.strip().strip('"')
    return fields


def all_skill_text(ctx: Context) -> str:
    return "\n".join(ctx.skill_texts.values())


def readme_text(ctx: Context) -> str:
    return ctx.read("README.md")


def role_files(ctx: Context) -> list[str]:
    return sorted(path.stem for path in ctx.path("agents").glob("*.md"))


def template_files(ctx: Context) -> list[str]:
    return sorted(path.name for path in ctx.path("templates").glob("*.md"))


def method_skill_dirs(ctx: Context) -> list[str]:
    skills_dir = ctx.path("skills")
    if not skills_dir.is_dir():
        return []
    return sorted(
        path.name
        for path in skills_dir.iterdir()
        if path.is_dir() and (path / "SKILL.md").is_file()
    )


def check_path_exists(ctx: Context, rel_path: str | Path) -> None:
    require(ctx.path(rel_path).exists(), f"missing {rel_path}")


def openai_text(ctx: Context, key: str) -> str:
    return ctx.read(OPENAI_YAML[key])


def has_all(text: str, snippets: list[str], label: str) -> None:
    missing = [snippet for snippet in snippets if snippet not in text]
    require(not missing, f"{label} missing snippets: {missing}")


def make_entry_exists(key: str) -> Callable[[Context], None]:
    return lambda ctx: check_path_exists(ctx, SKILL_ENTRIES[key]["path"])


def make_frontmatter_only_name_description(key: str) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        fields = frontmatter(ctx.skill_texts[key])
        require(set(fields) == {"name", "description"}, f"{key} frontmatter keys are {sorted(fields)}")

    return _check


def make_frontmatter_name(key: str) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        fields = frontmatter(ctx.skill_texts[key])
        expected = SKILL_ENTRIES[key]["name"]
        require(fields.get("name") == expected, f"{key} name is {fields.get('name')!r}, expected {expected!r}")

    return _check


def make_description_quality(key: str, required: list[str]) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        desc = frontmatter(ctx.skill_texts[key]).get("description", "")
        require(len(desc) >= 120, f"{key} description is too short")
        missing = [snippet for snippet in required if snippet not in desc]
        require(not missing, f"{key} description missing {missing}")

    return _check


def make_line_budget(key: str) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        line_count = len(ctx.skill_texts[key].splitlines())
        max_lines = int(SKILL_ENTRIES[key]["max_lines"])
        require(line_count <= max_lines, f"{key} has {line_count} lines, expected <= {max_lines}")

    return _check


def make_contains(key: str, snippets: list[str]) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        has_all(ctx.skill_texts[key], snippets, key)

    return _check


def make_openai_shape(key: str) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        text = openai_text(ctx, key)
        has_all(
            text,
            ["interface:", "display_name:", "short_description:", "default_prompt:", "policy:"],
            f"{key} openai.yaml",
        )

    return _check


def make_openai_prompt(key: str) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        token = str(SKILL_ENTRIES[key]["prompt_token"])
        require(token in openai_text(ctx, key), f"{key} default_prompt must contain {token}")

    return _check


def make_openai_policy(key: str) -> Callable[[Context], None]:
    def _check(ctx: Context) -> None:
        require(
            "allow_implicit_invocation: false" in openai_text(ctx, key),
            f"{key} must disable implicit invocation",
        )

    return _check


def check_references_exist(ctx: Context) -> None:
    missing = [rel_path for rel_path in REQUIRED_REFERENCES if not ctx.path(rel_path).exists()]
    require(not missing, f"missing references: {missing}")


def check_references_non_empty(ctx: Context) -> None:
    empty = [rel_path for rel_path in REQUIRED_REFERENCES if ctx.path(rel_path).stat().st_size == 0]
    require(not empty, f"empty references: {empty}")


def check_agents_dir_exists(ctx: Context) -> None:
    require(ctx.path("agents").is_dir(), "missing agents directory")


def check_templates_dir_exists(ctx: Context) -> None:
    require(ctx.path("templates").is_dir(), "missing templates directory")


def check_exact_role_set(ctx: Context) -> None:
    actual = role_files(ctx)
    require(actual == EXPECTED_ROLES, f"role set mismatch: {actual}")


def check_role_files_non_empty(ctx: Context) -> None:
    empty = [role for role in EXPECTED_ROLES if ctx.path(f"agents/{role}.md").stat().st_size == 0]
    require(not empty, f"empty role files: {empty}")


def check_asset_index_references_all_roles(ctx: Context) -> None:
    text = ctx.read("docs/04-reference/SKILL-ASSETS.md")
    missing = [role for role in EXPECTED_ROLES if f"agents/{role}.md" not in text]
    require(not missing, f"SKILL-ASSETS does not reference roles: {missing}")


def check_exact_template_set(ctx: Context) -> None:
    actual = template_files(ctx)
    missing = [template for template in EXPECTED_TEMPLATES if template not in actual]
    require(not missing, f"missing templates: {missing}")


def check_templates_non_empty(ctx: Context) -> None:
    empty = [template for template in EXPECTED_TEMPLATES if ctx.path(f"templates/{template}").stat().st_size == 0]
    require(not empty, f"empty templates: {empty}")


def check_exact_method_skill_set(ctx: Context) -> None:
    actual = method_skill_dirs(ctx)
    require(actual == EXPECTED_METHOD_SKILLS, f"method skill set mismatch: {actual}")


def check_method_skill_frontmatter(ctx: Context) -> None:
    errors: list[str] = []
    for skill_name in EXPECTED_METHOD_SKILLS:
        text = ctx.read(Path("skills") / skill_name / "SKILL.md")
        fields = frontmatter(text)
        if set(fields) != {"name", "description"}:
            errors.append(f"{skill_name}: keys={sorted(fields)}")
        elif fields.get("name") != skill_name:
            errors.append(f"{skill_name}: name={fields.get('name')!r}")
        elif len(fields.get("description", "")) < 10:
            errors.append(f"{skill_name}: description too short")
    require(not errors, "; ".join(errors))


def check_superpowers_source_manifest(ctx: Context) -> None:
    manifest = json.loads(ctx.read("skills/.superpowers-zh-source.json"))
    mismatches = {
        key: {"actual": manifest.get(key), "expected": expected}
        for key, expected in SUPERPOWERS_SOURCE.items()
        if manifest.get(key) != expected
    }
    require(not mismatches, f"superpowers source mismatch: {mismatches}")


def check_codex_method_mapping(ctx: Context) -> None:
    text = ctx.read("skills/using-superpowers/references/codex-tools.md")
    has_all(text, ["`spawn_agent`", "`wait_agent`", "`close_agent`", "`update_plan`"], "Codex tool map")
    require("| Task 返回结果 | `wait` |" not in text, "Codex tool map contains stale wait mapping")


def check_brainstorm_companion_security(ctx: Context) -> None:
    markers = {
        "skills/brainstorming/scripts/server.cjs": [
            "crypto.randomBytes(32)",
            "crypto.timingSafeEqual",
            "Content-Security-Policy",
            "Cross-Origin-Resource-Policy",
        ],
        "skills/brainstorming/scripts/helper.js": ["MAX_RECONNECT_MS", "brainstorm-session-key"],
        "skills/brainstorming/scripts/start-server.sh": ["server-instance-id", "--brainstorm-server-id="],
        "skills/brainstorming/scripts/stop-server.sh": ["command_has_server_id", "stale_pid"],
    }
    for rel_path, required in markers.items():
        has_all(ctx.read(rel_path), required, rel_path)


def check_output_types_covered(ctx: Context) -> None:
    text = ctx.read("docs/04-reference/OUTPUT-PATHS.md")
    missing = [output_type for output_type in OUTPUT_TYPES if f"current/{output_type}/" not in text]
    require(not missing, f"OUTPUT-PATHS missing: {missing}")


def check_host_adapters_exist(ctx: Context) -> None:
    missing = [key for key in HOST_ADAPTER_KEYS if key not in ctx.skill_texts]
    require(not missing, f"missing host adapters: {missing}")


def check_host_adapter_schema(ctx: Context) -> None:
    errors: list[str] = []
    for key in HOST_ADAPTER_KEYS:
        text = ctx.skill_texts[key]
        fields = frontmatter(text)
        expected_name = SKILL_ENTRIES[key]["name"]
        if set(fields) != {"name", "description"}:
            errors.append(f"{key}: keys={sorted(fields)}")
        elif fields.get("name") != expected_name:
            errors.append(f"{key}: name={fields.get('name')!r}")
        elif len(fields.get("description", "")) < 100:
            errors.append(f"{key}: description too short")
        max_lines = int(SKILL_ENTRIES[key]["max_lines"])
        if len(text.splitlines()) > max_lines:
            errors.append(f"{key}: exceeds {max_lines} lines")
    require(not errors, "; ".join(errors))


def check_aliases_point_to_root(ctx: Context) -> None:
    for key in HOST_ADAPTER_KEYS:
        require("PACKAGE_ROOT/SKILL.md" in ctx.skill_texts[key], f"{key} alias does not point to root SKILL.md")


def check_aliases_warn_pages(ctx: Context) -> None:
    for key in ["pl", "product-lifecycle"]:
        require("pages" in ctx.skill_texts[key], f"{key} alias lacks pages warning")


def check_aliases_preserve_worktree(ctx: Context) -> None:
    for key in HOST_ADAPTER_KEYS:
        text = ctx.skill_texts[key]
        require("Preserve unrelated worktree changes" in text, f"{key} adapter lacks worktree protection")


def check_root_has_dual_root_contract(ctx: Context) -> None:
    has_all(
        ctx.skill_texts["root"],
        ["## Resolve Roots", "PACKAGE_ROOT", "WORKSPACE_ROOT", "installed `PACKAGE_ROOT`"],
        "root dual-root contract",
    )


def check_readme_line_budget(ctx: Context) -> None:
    line_count = len(readme_text(ctx).splitlines())
    require(line_count <= README_MAX_LINES, f"README has {line_count} lines, expected <= {README_MAX_LINES}")


def check_readme_structure(ctx: Context) -> None:
    has_all(
        readme_text(ctx),
        [
            "## 快速开始",
            "### Codex",
            "## 选择运行方式",
            "## Skill 包结构",
            "PACKAGE_ROOT",
            "WORKSPACE_ROOT",
            "## 文档导航",
            "## 维护与验证",
            "docs/02-tools/SKILL-CODEX.md",
            "docs/04-reference/SKILL-ASSETS.md",
            "docs/04-reference/OUTPUT-PATHS.md",
            "docs/README.md",
        ],
        "README information architecture",
    )


def check_navigation_local_links(ctx: Context) -> None:
    broken: list[str] = []
    for rel_path in NAVIGATION_DOCS:
        source_path = ctx.path(rel_path)
        text = ctx.read(rel_path)
        for raw_target in re.findall(r"\[[^\]]+\]\(([^)]+)\)", text):
            target = raw_target.strip().strip("<>")
            if not target or target.startswith("#") or re.match(r"^[a-z][a-z0-9+.-]*://", target, re.I):
                continue
            local_target = unquote(target.split("#", 1)[0])
            resolved = source_path.parent / local_target
            if local_target and not resolved.exists():
                broken.append(f"{rel_path} -> {target}")
    require(not broken, f"navigation docs have broken local links: {broken}")


def check_readme_has_no_stale_paths(ctx: Context) -> None:
    stale_paths = [
        "docs/CONTEXT-MANAGEMENT.md",
        "docs/SECURITY.md",
        "docs/TOKEN-EFFICIENCY.md",
        "docs/INTERNATIONALIZATION.md",
        "docs/ACCESSIBILITY.md",
        "docs/QUICK-START.md",
        "docs/SKILL-CURSOR.md",
    ]
    found = [path for path in stale_paths if path in readme_text(ctx)]
    require(not found, f"README contains stale paths: {found}")


def check_asset_index_documents_layers(ctx: Context) -> None:
    has_all(
        ctx.read("docs/04-reference/SKILL-ASSETS.md"),
        [
            "## 包结构与真源",
            "运行资产",
            "宿主适配",
            "展示站点",
            "## 双根目录",
            "PACKAGE_ROOT",
            "WORKSPACE_ROOT",
            "## 修改归属",
        ],
        "SKILL-ASSETS package layers",
    )


def check_docs_index_exposes_codex_and_structure(ctx: Context) -> None:
    has_all(
        ctx.read("docs/README.md"),
        ["SKILL-CODEX", "02-tools/SKILL-CODEX.md", "包结构", "04-reference/SKILL-ASSETS.md"],
        "docs index",
    )


def check_maintenance_scripts_use_core_scope(ctx: Context) -> None:
    has_all(
        ctx.read("scripts/validate.ps1"),
        ["$ExpectedAgents = 20", "templates\\*_template.md", "$ExpectedAgents/$ExpectedAgents"],
        "PowerShell validation scope",
    )
    for rel_path in ["scripts/test-templates.sh", "scripts/validate-templates.sh"]:
        text = ctx.read(rel_path)
        has_all(text, ["templates/*_template.md", "20"], rel_path)
        require("templates/*.md" not in text, f"{rel_path} still scans non-core templates")
    has_all(ctx.read("scripts/test-agents.sh"), ["expected=20", "Step 0", "推荐方法论 skills"], "agent tests")
    workflow = ctx.read(".github/workflows/quality-gate.yml")
    has_all(
        workflow,
        [
            "python3 scripts/check-product-lifecycle-skill.py --root .",
            "run: bash scripts/test-agents.sh",
            "run: bash scripts/test-templates.sh",
            "run: bash scripts/validate-templates.sh",
        ],
        "quality-gate workflow",
    )
    require("test-agents.sh || true" not in workflow, "quality gate suppresses agent test failures")
    require("test-templates.sh || true" not in workflow, "quality gate suppresses template test failures")


def check_root_has_scope_gate(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["A. Full lifecycle", "B. Lean iteration", "C. Single role"], "root scope gate")


def check_root_has_routing_examples(ctx: Context) -> None:
    has_all(
        ctx.skill_texts["root"],
        ["## Routing Examples", "Mode A", "Mode B", "Mode C", "Do not use this skill"],
        "routing examples",
    )


def check_root_has_lean_defaults(ctx: Context) -> None:
    has_all(
        ctx.skill_texts["root"],
        ["New MVP", "Existing product feature", "Iteration planning", "Technical refactor", "UI/UX feature"],
        "root lean defaults",
    )


def check_root_has_web_search_boundary(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["Use web search only", "time-sensitive"], "root web search boundary")


def check_root_has_worktree_boundary(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["Preserve the user's worktree changes", "never revert unrelated"], "root worktree boundary")


def check_root_has_codex_execution(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["## Codex Execution", "current Codex tool instructions permit delegation"], "Codex execution")


def check_root_has_context_contract(ctx: Context) -> None:
    has_all(
        ctx.skill_texts["root"],
        ["## Context Contract", "precise task context", "Do not pass hidden reasoning", "full chat history"],
        "context contract",
    )


def check_root_has_role_prompt_template(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["You are the <role>", "Return changed files"], "role prompt template")


def check_root_has_maintenance_validation(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["## Maintenance Validation", "check-product-lifecycle-skill.py"], "maintenance validation")


def check_root_has_completion_standard(ctx: Context) -> None:
    has_all(ctx.skill_texts["root"], ["## Completion Standard", "validation performed"], "completion standard")


def check_no_claude_only_fields(ctx: Context) -> None:
    text = all_skill_text(ctx)
    pattern = DISALLOWED_PATTERNS["Claude-only frontmatter field"]
    require(not pattern.search(text), "found Claude-only frontmatter field")


def check_no_hardcoded_home_skill_paths(ctx: Context) -> None:
    text = all_skill_text(ctx)
    pattern = DISALLOWED_PATTERNS["hard-coded home skill path"]
    require(not pattern.search(text), "found hard-coded home skill path")


def check_no_subagent_type(ctx: Context) -> None:
    text = all_skill_text(ctx)
    pattern = DISALLOWED_PATTERNS["Claude Agent tool argument"]
    require(not pattern.search(text), "found subagent_type")


def check_no_agent_invocation(ctx: Context) -> None:
    for key, text in ctx.skill_texts.items():
        for line_number, line in enumerate(text.splitlines(), start=1):
            if "Agent(" in line and "Do not" not in line:
                raise CheckError(f"{key}:{line_number} contains Agent(...) invocation")


def check_subagent_permission_guidance(ctx: Context) -> None:
    for key, text in ctx.skill_texts.items():
        lowered = text.lower()
        if "subagent" in lowered:
            require("permit" in lowered, f"{key} subagent guidance lacks permission constraint")


def check_self_expected_count(ctx: Context) -> None:
    require(
        len(CHECKS) == EXPECTED_CHECK_COUNT,
        f"registered {len(CHECKS)} checks, expected {EXPECTED_CHECK_COUNT}",
    )


CHECKS: list[Check] = [
    Check("root SKILL.md exists", make_entry_exists("root")),
    Check("pl alias SKILL.md exists", make_entry_exists("pl")),
    Check("product-lifecycle alias SKILL.md exists", make_entry_exists("product-lifecycle")),
    Check("all four host adapters exist", check_host_adapters_exist),
    Check("all host adapters use thin portable schemas", check_host_adapter_schema),
    Check("root frontmatter contains only name and description", make_frontmatter_only_name_description("root")),
    Check("pl alias frontmatter contains only name and description", make_frontmatter_only_name_description("pl")),
    Check(
        "product-lifecycle alias frontmatter contains only name and description",
        make_frontmatter_only_name_description("product-lifecycle"),
    ),
    Check("root frontmatter name is product-lifecycle", make_frontmatter_name("root")),
    Check("pl alias frontmatter name is pl", make_frontmatter_name("pl")),
    Check("product-lifecycle alias frontmatter name is product-lifecycle", make_frontmatter_name("product-lifecycle")),
    Check("root description has explicit trigger and anti-trigger coverage", make_description_quality("root", ["/product-lifecycle", "/pl", "Do not use"])),
    Check("pl description has explicit trigger and anti-trigger coverage", make_description_quality("pl", ["/pl", "/product-lifecycle", "Do not use"])),
    Check(
        "product-lifecycle alias description has explicit trigger and anti-trigger coverage",
        make_description_quality("product-lifecycle", ["/product-lifecycle", "/pl", "Do not use"]),
    ),
    Check("root skill stays within context budget", make_line_budget("root")),
    Check("pl alias stays within context budget", make_line_budget("pl")),
    Check("product-lifecycle alias stays within context budget", make_line_budget("product-lifecycle")),
    Check("root contains non-PDF pages warning", make_contains("root", ["pages", "PDF"])),
    Check("aliases contain non-PDF pages warnings", check_aliases_warn_pages),
    Check("root contains package root resolution", make_contains("root", ["PACKAGE_ROOT", "agents/", "templates/", "docs/"])),
    Check("root separates package and workspace roots", check_root_has_dual_root_contract),
    Check("root contains A/B/C scope gate", check_root_has_scope_gate),
    Check("root contains routing examples", check_root_has_routing_examples),
    Check("root contains recommended lean role sets", check_root_has_lean_defaults),
    Check("asset index contains all 20 role references", check_asset_index_references_all_roles),
    Check("agents directory has the exact 20-role set", check_exact_role_set),
    Check("all role files are non-empty", check_role_files_non_empty),
    Check("required templates exist", check_exact_template_set),
    Check("required templates are non-empty", check_templates_non_empty),
    Check("bundled methods have the exact 20-skill set", check_exact_method_skill_set),
    Check("bundled methods use Codex-compatible frontmatter", check_method_skill_frontmatter),
    Check("bundled methods record superpowers-zh v1.7.0 provenance", check_superpowers_source_manifest),
    Check("bundled methods use current Codex tool mappings", check_codex_method_mapping),
    Check("brainstorm companion includes v1.7.0 security guards", check_brainstorm_companion_security),
    Check("required reference documents exist", check_references_exist),
    Check("required reference documents are non-empty", check_references_non_empty),
    Check("output reference covers all output types", check_output_types_covered),
    Check("all host adapters point back to root SKILL.md", check_aliases_point_to_root),
    Check("all host adapters protect unrelated worktree changes", check_aliases_preserve_worktree),
    Check("README stays within its context budget", check_readme_line_budget),
    Check("README exposes the concise user information architecture", check_readme_structure),
    Check("navigation document local links resolve", check_navigation_local_links),
    Check("README contains no pre-reorganization paths", check_readme_has_no_stale_paths),
    Check("asset index documents package layers and ownership", check_asset_index_documents_layers),
    Check("docs index exposes Codex and package structure", check_docs_index_exposes_codex_and_structure),
    Check("maintenance scripts validate the 20-role core scope", check_maintenance_scripts_use_core_scope),
    Check("pl openai.yaml has UI metadata shape", make_openai_shape("pl")),
    Check("product-lifecycle openai.yaml has UI metadata shape", make_openai_shape("product-lifecycle")),
    Check("pl default prompt invokes $pl", make_openai_prompt("pl")),
    Check("product-lifecycle default prompt invokes $product-lifecycle", make_openai_prompt("product-lifecycle")),
    Check("pl disables implicit invocation", make_openai_policy("pl")),
    Check("product-lifecycle disables implicit invocation", make_openai_policy("product-lifecycle")),
    Check("root documents web-search boundary", check_root_has_web_search_boundary),
    Check("root documents worktree safety boundary", check_root_has_worktree_boundary),
    Check("root documents Codex execution constraints", check_root_has_codex_execution),
    Check("root documents context contract", check_root_has_context_contract),
    Check("root includes reusable role prompt template", check_root_has_role_prompt_template),
    Check("root includes maintenance validation command", check_root_has_maintenance_validation),
    Check("root includes lifecycle completion standard", check_root_has_completion_standard),
    Check("skill entries contain no Claude-only frontmatter fields", check_no_claude_only_fields),
    Check("skill entries contain no hard-coded home skill paths", check_no_hardcoded_home_skill_paths),
    Check("skill entries contain no subagent_type argument", check_no_subagent_type),
    Check("skill entries contain no executable Agent(...) example", check_no_agent_invocation),
    Check("subagent guidance mentions permission constraints", check_subagent_permission_guidance),
    Check("the quality gate itself registers exactly 65 checks", check_self_expected_count),
]


def run_checks(root: Path) -> list[Result]:
    ctx = Context(root)
    results: list[Result] = []
    for number, check in enumerate(CHECKS, start=1):
        try:
            check.fn(ctx)
        except Exception as exc:  # noqa: BLE001 - report every gate failure cleanly.
            results.append(Result(number=number, name=check.name, ok=False, error=str(exc)))
        else:
            results.append(Result(number=number, name=check.name, ok=True))
    return results


def print_human(results: list[Result], concise: bool) -> None:
    if not concise:
        total = len(results)
        for result in results:
            status = "PASS" if result.ok else "FAIL"
            suffix = "" if result.ok else f" -- {result.error}"
            print(f"[{result.number:02d}/{total:02d} {status}] {result.name}{suffix}")

    failures = [result for result in results if not result.ok]
    if failures:
        print(f"[FAIL] {len(failures)} of {len(results)} product-lifecycle skill gates failed.")
    else:
        print(f"[OK] all {len(results)} product-lifecycle skill gates passed.")


def main() -> int:
    parser = argparse.ArgumentParser(description="Run 65 product-lifecycle skill quality gates.")
    parser.add_argument("--root", default=".", help="Repository root; defaults to current directory.")
    parser.add_argument("--json", action="store_true", help="Emit machine-readable JSON.")
    parser.add_argument("--concise", action="store_true", help="Only print the final human summary.")
    args = parser.parse_args()

    results = run_checks(Path(args.root).resolve())
    failures = [result for result in results if not result.ok]

    if args.json:
        print(
            json.dumps(
                {
                    "ok": not failures,
                    "total": len(results),
                    "passed": len(results) - len(failures),
                    "failed": len(failures),
                    "results": [result.__dict__ for result in results],
                },
                ensure_ascii=False,
                indent=2,
            )
        )
    else:
        print_human(results, concise=args.concise)

    return 0 if not failures else 1


if __name__ == "__main__":
    sys.exit(main())
