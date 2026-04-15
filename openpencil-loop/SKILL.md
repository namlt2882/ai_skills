---
name: openpencil-loop
description: Use when the user wants to build, iterate, or refine designs with OpenPencil — creating multi-page layouts, design systems, UI components, pages, or any iterative design workflow. Triggers on: "build pages with OpenPencil", "create a design loop", "iterate on design", "design login page", "build dashboard", "add new page to design", "OpenPencil workflow", "batch design", "design skeleton", or any request mentioning openpencil_batch_design, openpencil_design_skeleton, openpencil_design_content, openpencil_get_design_prompt, openpencil_add_page, openpencil_batch_get, openpencil_insert_node, openpencil_design_refine, or openpencil_save.
---

## Overview

The OpenPencil Loop is a multi-role orchestration system to work with OpenPencil (https://github.com/ZSeven-W/openpencil) where agents cycle through design phases—ORCHESTRATOR, SUBAGENT/BUILDER, REVIEWER, and ANALYZER—using lazy-loading for each role's workflow. Each phase loads its detailed workflow on-demand from `phases/{role}/workflow.md`, keeping the main SKILL.md lightweight while enabling complex iterative design. The loop continues until the design meets quality criteria.

# OpenPencil Build Loop

> **⚠️ LAZY LOADING:** This file contains only role detection + dispatch. Each role's full workflow is in `phases/{role}/workflow.md`. Read that file when you know your role.

> **⚠️ CRITICAL - FILE PERSISTENCE:** OpenPencil MCP tools operate **IN-MEMORY ONLY**. Changes are NOT written to disk. The `.op` file remains `{"version":"1.0.0","children":[]}` on disk even after `insert_node`/`batch_design`. Re-opening the file LOSES ALL WORK.
>
> **CLI `op save` is the simplest persistence method.** After each session, run: `op save canvas/design.op` (include the path). See `reference/cli-commands.md` line 45.
>
> **Fallback:** If CLI is unavailable, use `filesystem_write_file()` with `openpencil_batch_get()` output. See `reference/mcp-tool-index.md` lines 173-194.

> **⚠️ CRITICAL - batch_design D() Limitation:** The delete operation `D()` in batch_design **silently fails** (no-op). Always use `delete_node` tool directly for reliable node deletion. See `reference/mcp-tool-index.md` line 175 for workaround details.

---
## ⚠️ ROLE DETECTION (READ THIS FIRST)

**STOP. Determine your role from your prompt:**

### Role Lookup Table

| Prompt Contains... | You Are... | Go To File... |
|---------------------|------------|---------------|
| "Onboard [project]", "Create DESIGN.md, PROJECT.md", "Dispatch subagents" | **ORCHESTRATOR** | `phases/orchestrator/workflow.md` |
| "Read prompts/XX-prompt.md and build the page" | **SUBAGENT/BUILDER** | `phases/subagent/workflow.md` |
| "Analyze source code and extract tokens" | **ANALYZER** | `phases/analyzer/workflow.md` |
| "Verify page [name] has content" | **REVIEWER** | `phases/reviewer/workflow.md` |

### Fallback Role

If your prompt doesn't match any pattern above, **default to ORCHESTRATOR** and read `phases/orchestrator/workflow.md`. The orchestrator role is the safest fallback because it coordinates rather than builds.

**Fallback rule:** Unclear role → ORCHESTRATOR. Never attempt to build without orchestrator coordination.

---
## KEY REFERENCES

**Path Convention:** All paths are relative to the workspace root (where you invoked the skill). The skill directory is `{workspace}/openpencil-loop/`. When reading workflow files, use absolute paths like `read("/Users/nam.lethanh/Documents/code/wave/ai_skills/openpencil-loop/knowledge/role-definitions.md")` to avoid ambiguity.

**Sub-Skill Loading:** Read files directly based on your role:
- SUBAGENT: `openpencil_get_design_prompt({ section: "schema" })`, `openpencil_get_design_prompt({ section: "layout" })`, `read("{skill_path}/knowledge/role-definitions.md")`
- REVIEWER: `openpencil_get_design_prompt({ section: "schema" })`
- ANALYZER: `read("{skill_path}/phases/generation/design-system.md")`, `openpencil_get_design_prompt({ section: "schema" })`

> **Tip:** Replace `{skill_path}` with the absolute path to this skill directory.

**File Structure:**

```
openpencil-loop/                     ← Skill directory (read-only)
├── SKILL.md
├── phases/
│   ├── orchestrator/workflow.md     ← ORCHESTRATOR role
│   ├── subagent/workflow.md        ← SUBAGENT/BUILDER role
│   ├── reviewer/workflow.md        ← REVIEWER role
│   ├── analyzer/workflow.md         ← ANALYZER role
│   └── generation/
│       └── design-system.md
├── knowledge/
│   └── role-definitions.md
├── domains/
│   └── dashboard.md
├── reference/
│   ├── cli-commands.md
│   ├── mcp-tool-index.md
│   └── tool-decision-tree.md
└── TEST-SPEC.md

{workspace}/canvas/                 ← Project files (orchestrator creates)
├── design.op                        ← OpenPencil canvas
├── DESIGN.md                        ← Design tokens
├── PROJECT.md                       ← Roadmap
└── prompts/                        ← Per-page task prompts
    ├── 01-dashboard-prompt.md
    └── 02-login-prompt.md
```

---
## CLI Quick Reference

> Full documentation: `reference/cli-commands.md`

**Most-used commands**:
- `op start` - Launch OpenPencil
- `op design:refine` - Post-process design
- `op export --format react` - Code export (NOT PNG - use MCP)
- `op get` - Get current selection
- `op page list` - List pages

---
## Multi-Provider Support (v0.7.2+)

AI agent loops work with multiple providers:
- **Fixed**: GLM/DeepSeek/Qwen/dashscope/StepFun tool-call translation
- **Preset**: StepFun `step_plan/v1`
- **Fallback**: Minimal-skills for resilience

---
## Mac CLI Discovery Troubleshooting

If `op` not found, try login-shell probe:
```bash
$SHELL -ilc 'command -v op'
```

Managed shells may need expanded PATH:
- nvm/fnm: `~/.npm-packages/bin`, nvm dirs
- pnpm: `~/Library/pnpm`
- bun: `~/.bun/bin`
- mise/asdf: `~/.asdf/shims`, `~/.local/share/mise`
- volta: `~/.volta/bin`
- cargo: `~/.cargo/bin`

---
## FILE INDEX

| File | Purpose |
|------|---------|
| `phases/orchestrator/workflow.md` | Orchestrator workflow |
| `phases/subagent/workflow.md` | Subagent workflow |
| `phases/reviewer/workflow.md` | Reviewer workflow |
| `phases/analyzer/workflow.md` | Analyzer workflow |
| `phases/observation-wrapper.md` | MCP output transformation contract |
| `phases/generation/design-system.md` | Token format |
| `knowledge/role-definitions.md` | Component semantic roles |
| `reference/tool-decision-tree.md` | Tool selection guide |
| `reference/cli-commands.md` | CLI command reference v0.7.2 |
| `reference/mcp-tool-index.md` | MCP tool mappings |
| `TEST-SPEC.md` | Regression tests |
| `phases/observation-contract.md` | Standardized output format |