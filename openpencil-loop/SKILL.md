---
name: openpencil-loop
description: Iterative design development loop using OpenPencil (https://github.com/ZSeven-W/openpencil) CLI and MCP tools. Combines prompt enhancement, design system synthesis, and baton-passing orchestration. Use when building multi-page designs, iteratively refining UI components, creating design systems, or when you want to progressively develop a design with structured user feedback. Triggers on requests like "build a design system", "create multiple pages with OpenPencil", "iteratively design", "loop design", "design a login page", or when you want to enhance prompts for OpenPencil with design system context.
---

# OpenPencil Build Loop

You are an **autonomous design builder** participating in an iterative design-development loop. Your goal is to generate designs using OpenPencil, integrate them into the project, and prepare instructions for the next iteration.

## Architecture: Sub-Skills Reference

```
openpencil-loop/
├── SKILL.md                       ← Main orchestrator (THIS FILE)
├── TEST-SPEC.md                   ← Regression test suite (RUN AFTER UPDATES)
├── phases/
│   ├── planning/
│   │   ├── design-type.md        ← Design type detection
│   │   └── decomposition.md      ← Task decomposition
│   ├── prompt-enhancement/
│   │   └── prompt-enhancement.md ← Stitch-style prompt enhancement
│   ├── generation/
│   │   ├── design-system.md      ← Design token generation
│   │   ├── jsonl-format.md       ← PenNode JSONL format
│   │   ├── layout-rules.md       ← Auto-layout rules
│   │   ├── text-rules.md         ← Text node rules
│   │   └── schema.md             ← PenNode schema reference
│   ├── validation/
│   │   └── vision-feedback.md    ← Vision QA (MCP: batch_get, snapshot_layout)
│   ├── maintenance/
│   │   ├── local-edit.md         ← Update nodes (MCP: batch_design, update_node, delete_node)
│   │   └── incremental-add.md    ← Add nodes (MCP: batch_design, insert_node, copy_node)
│   └── codegen/
│       ├── analyze.md            ← Project structure & design validation
│       ├── discover.md           ← Find existing implementations in src/
│       ├── deduplicate.md        ← SHA256-based component deduplication
│       └── generate.md           ← Production code generation with safety
├── knowledge/
│   ├── codegen/
│   │   ├── codegen.md            ← Codegen main (MCP: export_nodes)
│   │   ├── codegen-react.md      ← React (MCP: export_nodes)
│   │   └── codegen-html.md       ← HTML (MCP: export_nodes)
│   ├── role-definitions.md       ← Semantic roles
│   ├── icon-catalog.md           ← Icon names
│   ├── design-principles.md      ← Design craft principles
│   ├── examples.md               ← Component examples
│   └── copywriting.md            ← Copy rules
├── domains/
│   ├── landing-page.md           ← Landing page patterns
│   ├── dashboard.md              ← Dashboard patterns
│   ├── mobile-app.md             ← Mobile app patterns
│   ├── form-ui.md                ← Form patterns
│   └── cjk-typography.md         ← CJK typography
├── templates/
│   ├── DESIGN.md                 ← Design spec template
│   ├── PROJECT.md                ← Project template
│   ├── next-prompt.md            ← Baton-passing template
│   └── codegen-state.md          ← Codegen state baton template
├── scripts/
│   ├── run-tests.sh              ← Test runner
│   ├── init-project.sh           ← Project setup
│   └── test-run.sh               ← Smoke test
├── evals/
│   ├── eval-0/, eval-1/, eval-2/
│   ├── evals.json
│   └── metadata.json
└── reference/
    └── mcp-tool-index.md        ← Complete MCP tool reference (90+ tools)
```

## When to Use

Activate when you need ANY of these capabilities:
- **Design a new page** — Transform vague ideas into structured OpenPencil prompts with design system context
- **Continue existing project** — Pick up from `.op/next-prompt.md` baton file
- **Create design system** — Generate `.op/DESIGN.md` with user confirmation for colors, typography, components
- **Enhance prompts** — Add design system tokens, structure, and visual descriptions to vague user requests
- **Codify user decisions** — Store user preferences in DESIGN.md for consistency across iterations
- **Export code** — Generate React/Vue/SwiftUI components from OpenPencil designs

## Prerequisites

**Required:** OpenPencil MCP Server (`openpencil` — 34 tools, no desktop app needed)

**Optional:** OpenPencil CLI (`npm install -g @zseven-w/openpencil`), `.op/DESIGN.md` file, design reference images in `.op/references/`

## Quick Start

Minimal working sequence to create a design from scratch:

```bash
# 1. Create a minimal .op file (valid format required)
echo '{"version":"1.0.0","children":[]}' > canvas/design.op

# 2. Connect to live canvas via MCP
openpencil_open_document({ filePath: "canvas/design.op" })
// → returns { document, context, designPrompt }

# 3. Create page structure
openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: "Page", width: 375, height: 812 }, sections: [...] })
// → returns { rootId, sections: [{ id, name, guidelines, suggestedRoles }] }

# 4. Add content to a section
openpencil_design_content({ sectionId: "section-id", children: [...], postProcess: true })

# 5. Validate + auto-fix
openpencil_design_refine({ rootId: "root-id" })
```

### `.op` File Format

The `.op` file must use this JSON structure (NOT `{"pages":[...]}`):

```json
{
  "version": "1.0.0",
  "children": []
}
```

**Note:** `init-project.sh` creates a file with `{"pages":[...]}` format. `open_document` automatically rewrites it to the correct format when opened. For manual creation, use the structure above.

### Prerequisites for `design_skeleton`

`design_skeleton` requires an **existing valid `.op` file**. It will fail with `ENOENT` if the file doesn't exist, or `Invalid document format` if the JSON is malformed.

## ⚠️ CRITICAL: No File Persistence

**`openpencil_*` tools operate IN-MEMORY ONLY** — changes are NOT written to disk!

| Behavior | What Happens |
|----------|--------------|
| After `insert_node` / `batch_design` | Nodes exist in live canvas |
| `.op` file on disk | Still `{"version":"1.0.0","children":[]}` |
| Re-opening the file | **ALL WORK LOST** — empty document |
| `batch_get({ filePath })` | Returns empty (reads from disk) |
| `batch_get()` (no filePath) | Shows nodes (reads from memory) |

### Workaround: Manual Export

After each session, manually persist your work:

```javascript
// 1. Get the nodes from live canvas
const nodes = openpencil_batch_get({ readDepth: 5 })

// 2. Export to JSON file (manual write)
filesystem_write_file({ 
  path: "canvas/design.op", 
  content: JSON.stringify({ version: "1.0.0", children: nodes.nodes }, null, 2)
})

// OR use export_nodes to get raw PenNode JSON
const exported = openpencil_export_nodes()
filesystem_write_file({ path: "canvas/design-export.json", content: JSON.stringify(exported) })
```

**Root Cause:** The `openpencil` MCP server (port 3100) has no `save_file` tool. The `open-pencil` server (port 7600) has `save_file` but requires the desktop app.

**Recommendation:** Run OpenPencil desktop app and use `open-pencil_*` tools if you need file persistence, or manually write the `.op` file after each session.

---

## Known Issues & Limitations

| Issue | Severity | Workaround |
|-------|---------|------------|
| **NO FILE PERSISTENCE** | 🔴 CRITICAL | See above — manually export after each session |
| **Concurrent sub-agent file saves** | 🔴 CRITICAL | Sub-agents MUST NOT save files. Only orchestrator saves. Sub-agents must remind orchestrator to save after completion. |
| **`pageId` targets wrong page** | High | Multi-page operations on page 2+ fail. Workaround: operate on page 1 only, or use `add_page`/`duplicate_page` to re-create pages |
| **`batch_design D()` silently no-ops** | High | Use `delete_node` for single node deletion. D() in batch DSL does not work |
| **`copy_node` param is `sourceId`, not `nodeId`** | Medium | Always use `sourceId` when calling `copy_node` |
| **`design_skeleton` creates equal-width sections** | Medium | Sections get equal split of parent width. For asymmetric splits (e.g. 520/680), use `update_node` after skeleton creation to set explicit `width` |
| **`delete_node` only works for top-level nodes** | Medium | Cannot delete nested children directly. Workaround: move node to root first, then delete |
| **`batch_design` DSL fails on complex nested JSON** | Medium | For complex multi-node trees, use `insert_node` per-node or the layered `design_skeleton → design_content → design_refine` workflow |
| **`open_document` auto-rewrites `.op` format** | Low | Files created with `{"pages":[...]}` are auto-corrected to `{"version":"1.0.0","children":[]}` on open. Manual `.op` creation should use correct format |
| **No MCP screenshot capability** | Medium | Visual validation requires Playwright browser automation or manual capture from OpenPencil app |

---

## Testing

**After ANY update to this skill, run the regression test suite:**

```bash
# Read and follow TEST-SPEC.md
read("openpencil-loop/TEST-SPEC.md")

# Quick checklist:
# 1. MCP naming: openpencil_* works, open-pencil_* does not
# 2. File persistence: manual save workaround works
# 3. Parallel build: multi-page works
# 4. Sub-agent discipline: pattern documented
# 5. Minimal prompts: all 5 tests pass
```

**Full test spec:** `TEST-SPEC.md` — 6 test categories, 15+ individual tests, regression checklist.

## Multi-Agent Compatibility

This skill works across agent frameworks. Workflow, file formats, and phase logic are identical — only tool invocation syntax differs.

### ⚠️ CRITICAL: Sub-Agent File Save Discipline

**Sub-agents MUST NOT save files.** Only the orchestrator can save files.

| Role | Can Save? | Reason |
|------|-----------|--------|
| **Orchestrator** | ✅ YES | Single point of file write — prevents race conditions |
| **Sub-agent** | ❌ NO | Concurrent file writes cause data loss/corruption |

**Sub-agent pattern:**
```
1. Sub-agent completes work (design, validation, etc.)
2. Sub-agent returns result + REMINDS orchestrator:
   "✅ Work complete. Orchestrator: Please save the file now."
3. Orchestrator collects all sub-agent results
4. Orchestrator saves file ONCE
```

**Why this matters:**
- Multiple sub-agents saving same file → race condition → data loss
- Sub-agents may overwrite each other's work
- Only orchestrator has full context to merge results correctly

| Framework | Task Orchestration | Tool Call | File I/O |
|-----------|-------------------|-----------|----------|
| **OpenCode** | `task(category, load_skills, ...)` | `openpencil_*()` direct tool calls | `read()`, `write()`, `edit()` |
| **Claude Code** | Background tasks via tool_use | `mcp__open_pencil__<tool>(args)` | `Read`, `Write`, `Edit` |
| **Codex** | `Agent.run()` or subprocess | HTTP MCP client or CLI | `fs.readFile`, `fs.writeFile` |
| **Aider** | Sequential (no native subagents) | CLI subprocess or HTTP | File read/write |
| **Custom** | Any orchestrator | MCP JSON-RPC or HTTP | Any filesystem API |

### OpenCode Tool Call Pattern

**OpenCode users**: The `openpencil_*` tools are **native tools** — call them directly without `skill_mcp`:

```
// ✅ CORRECT — native tools, call directly:
openpencil_open_document({ filePath: "canvas/design.op" })
openpencil_batch_design({ operations: [...] })
openpencil_add_page({ name: "LoginScreen" })
openpencil_insert_node({ parent: "rootId", data: {...} })
openpencil_export_nodes({ filePath: "canvas/design.op" })

// ❌ NOT NEEDED — skill_mcp not required for openpencil tools:
skill_mcp({ mcp_name: "openpencil", tool_name: "batch_design", arguments: {...} })
```

### Generic Patterns (Other Frameworks)

```
// OpenCode — call directly:
openpencil_batch_get({ filePath, parentId, readDepth })

// Claude Code — use mcp prefix:
mcp__openpencil__batch_get({ filePath, parentId, readDepth })

// Codex — use MCP client:
await openpencilMcp.batch_get({ filePath, parentId, readDepth })

// Task Dispatch — CORRECT pattern (read file + inject content):
// 1. Read the sub-skill file directly
// 2. Inject content into prompt with load_skills=[]
read("openpencil-loop/phases/planning/design-type.md")
task(category="ultrabrain", load_skills=[], run_in_background=true, prompt="SUB-SKILL:\n${fileContent}\n\nTASK: ...")

// ❌ WRONG — load_skills does not support nested sub-skills:
// task(category="ultrabrain", load_skills=["design-type"], ...)  // will not load correctly
```

## Task Management

This skill uses **task orchestration** to avoid context dilution. The Build Loop follows 4 phases per loop type, each mapped to a task entry. Spawn subagents for each independent task.

### Sub-Skill Loading Pattern

**IMPORTANT:** Sub-skill files cannot be loaded via `load_skills=[...]`. The ECC skill loader does not support nested sub-skills. You MUST read the file directly and inject its content into the task prompt.

```
❌ WRONG (does not work):
task(category="ultrabrain", load_skills=["design-type"], prompt="...")

✅ CORRECT (read file + inject content):
read("openpencil-loop/phases/planning/design-type.md")
// → inject file content into prompt
task(category="ultrabrain", load_skills=[], prompt="CONTENT:\n${fileContent}\n\nTASK: ...")
```

### Sub-Skill File Reference

| Category | Sub-Skill Files | When to Use |
|----------|----------------|-------------|
| **Planning** | `phases/planning/design-type.md`, `decomposition.md` | User gives new design request |
| **Prompt Enhancement** | `phases/prompt-enhancement/prompt-enhancement.md`, `knowledge/role-definitions.md` | Transform vague ideas into structured prompts |
| **Generation** | `phases/generation/design-system.md`, `schema.md`, `layout-rules.md`, `text-rules.md`, `jsonl-format.md` | Build each section |
| **Validation** | `phases/validation/vision-feedback.md` | Design is built, validate quality |
| **Maintenance** | `phases/maintenance/local-edit.md`, `incremental-add.md` | Edit or add to existing design |
| **CodeGen** | `phases/codegen/analyze.md`, `discover.md`, `deduplicate.md`, `generate.md` | Production code generation |
| **Knowledge** | `knowledge/role-definitions.md`, `icon-catalog.md`, `design-principles.md`, `examples.md`, `copywriting.md` | Prompt enhancement, semantic roles |
| **Domains** | `domains/landing-page.md`, `dashboard.md`, `mobile-app.md`, `form-ui.md`, `cjk-typography.md` | Match design type to domain |
| **Codegen Guides** | `knowledge/codegen/codegen.md`, `codegen-react.md`, `codegen-html.md` | Framework-specific code generation |

### Phase-Based Tasks

> **Critical:** Always use `load_skills=[]` and inject sub-skill file content directly into the prompt. See **Sub-Skill Loading Pattern** above.

| Task | Category | Sub-Skill Files | When to Use |
|------|----------|----------------|-------------|
| **Phase 1: PLANNING** | `ultrabrain` | `design-type.md`, `decomposition.md` | User gives new design request |
| **Phase 2: GENERATION** | `ultrabrain` | `design-system.md`, `schema.md`, `layout-rules.md`, `text-rules.md`, `jsonl-format.md` | Have decomposed plan, build each section |
| **Phase 3: VALIDATION** | `unspecified-high` | `vision-feedback.md` | Design is built, validate quality |
| **Phase 4: MAINTENANCE** | `ultrabrain` | `local-edit.md`, `incremental-add.md` | User wants to edit or add to existing design |
| **CodeGen: ANALYZE** | `unspecified-high` | `analyze.md` | Project structure check, design validation |
| **CodeGen: DISCOVER** | `explore` | `discover.md` | Find existing implementations in src/ |
| **CodeGen: DEDUPE** | `unspecified-high` | `deduplicate.md` | Hash-based component deduplication |
| **CodeGen: GENERATE** | `deep` | `generate.md` | Production code generation |

### Supporting Tasks

| Task | Category | Sub-Skill Files | When to Use |
|------|----------|----------------|-------------|
| **Prompt Enhancement** | `unspecified-high` | `prompt-enhancement.md`, `role-definitions.md` | User input is vague or needs structure |
| **DESIGN.md Creation** | `ultrabrain` | `design-system.md` | DESIGN.md missing and user confirms |
| **DESIGN.md Read** | `explore` | — | Check for existing DESIGN.md |
| **Domain Selection** | `ultrabrain` | `landing-page.md`, `dashboard.md`, `mobile-app.md`, `form-ui.md`, `cjk-typography.md` | Match design type to domain |
| **Project Documentation** | `writing` | `examples.md` | Updating PROJECT.md |

### Parallel Task Dispatch

Spawn independent tasks with `run_in_background=true`. Use consistent pageId conventions for multi-page work.

**Always use `load_skills=[]` and inject sub-skill content directly:**

```typescript
// CORRECT — read file + inject content:
const designTypeContent = read("openpencil-loop/phases/planning/design-type.md")
const decompositionContent = read("openpencil-loop/phases/planning/decomposition.md")

task(
  category="ultrabrain",
  load_skills=[],  // ALWAYS empty — sub-skills cannot be loaded
  run_in_background=true,
  prompt=`
SUB-SKILL CONTENT (design-type.md):
${designTypeContent}

SUB-SKILL CONTENT (decomposition.md):
${decompositionContent}

TASK: Detect design type and decompose: [user request]

⚠️ IMPORTANT: Do NOT save files. Return your result and remind the orchestrator to save.
[...remaining prompt details...]
`
)
```

**Sub-agent reminder template (include in every task prompt):**
```
⚠️ FILE SAVE RULE: You are a sub-agent. Do NOT save any files.
After completing your work, return results and remind the orchestrator:
"✅ [Task name] complete. Orchestrator: Please save the file now."
```

## Decision Workflow

| Decision | Type | What to Ask / Default |
|----------|------|----------------------|
| **Design System** | Critical | "No DESIGN.md found. Create one with default values or customize?" |
| **Colors** | Critical | "Color palette: Primary (accent), Background, Text roles?" |
| **Typography** | Critical | "Font families for headings, body? (e.g., Space Grotesk + Inter)" |
| **Spacing/Shadow** | Critical | "Spacing approach (8px grid)? Shadow depth (subtle/medium/elevated)?" |
| **Components** | Critical | "Button shape, card roundness, input style preferences?" |
| **Export Format** | Critical | "Export to code? (React/Vue/SwiftUI/Flutter/etc.)" |
| **Layout** | Medium | Default: Vertical. Offer: "Vertical or horizontal layout?" |
| **Color Palette** | Medium | Default: Zinc/Slate base. Offer: "Warm or cool gray base?" |
| **Responsive** | Medium | Default: Mobile-first. Offer: "Mobile-first or desktop-first?" |
| **Density** | Medium | Default: Balanced (5/10). Offer: "Gallery airy or cockpit dense?" |
| **Prompt enhancement** | Auto | Add structure, visual descriptions |
| **Component styling** | Auto | Apply semantic roles with smart defaults |
| **Project structure** | Auto | Section-based with sitemap tracking |
| **Export location** | Auto | `src/components/` or `lib/widgets/` |

## Overview

The Build Loop pattern enables continuous, autonomous design development through a "baton" system. Two mode sets:

- **Design Build Loop:** PLANNING → GENERATION → VALIDATION → MAINTENANCE → (repeat)
- **Codegen Build Loop:** ANALYZE → DISCOVER → DEDUPE → GENERATE

Each codegen iteration uses `.op/codegen-state.md` to pass state between phases.

### Baton Format (`.op/next-prompt.md`)

Stitch-compatible format: YAML frontmatter with `page` field, followed by a one-line description and structured sections carrying design system context and page structure forward.

```markdown
---
page: pricing
---
A clean pricing page with three tiers, monthly/annual toggle, and FAQ section.

**DESIGN SYSTEM (REQUIRED):**
[Copy from .op/DESIGN.md Section 6]

**Page Structure:**
1. Section header — "Simple, transparent pricing" + subtitle
2. Toggle — Monthly/Annual billing switch
3. Pricing cards row — Free, Pro (highlighted), Enterprise
4. FAQ accordion — 4-6 common questions
```

**Critical baton rules:**
- ✅ ALWAYS update the baton after each iteration with the next task
- ✅ ALWAYS include `page` frontmatter field — output filename without extension
- ✅ ALWAYS include `**DESIGN SYSTEM (REQUIRED):**` section — copy from `.op/DESIGN.md`
- ✅ ALWAYS include `**Page Structure:**` section — numbered list of sections to build
- ❌ NEVER leave the baton empty or with only frontmatter — next agent has no context
- ❌ NEVER skip the DESIGN SYSTEM section — generation quality degrades without tokens

Full template: `templates/next-prompt.md`

### Enhance Prompt Example

Transforms vague input into structured OpenPencil-ready prompts with design system context. Triggered automatically when user input lacks structure.

**Original:** `make me a login page`

**Enhanced:** Design a modern login page with clean visual hierarchy. Include DESIGN SYSTEM section (typography, colors, spacing, component tokens), Page Structure (left panel hero + right panel form with email/password inputs, forgot password link, sign in button, social login row, signup footer link), Layout notes (horizontal split desktop 1200px), and Visual Notes (subtle shadow, rounded inputs).

See `prompt-enhancement` sub-skill for the full transformation pipeline.

## Phase Workflow Summary

**Design Build Loop** (for UI design):

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| 1. PLANNING | Phase 1: PLANNING | design-type.md, decomposition.md | design_skeleton |
| 2. GENERATION | Phase 2: GENERATION | design-system.md, schema.md, layout-rules.md, text-rules.md, jsonl-format.md | batch_design, insert_node |
| 3. VALIDATION | Phase 3: VALIDATION | vision-feedback.md | batch_get, snapshot_layout |
| 4. MAINTENANCE | Phase 4: MAINTENANCE | local-edit.md, incremental-add.md | batch_design, update_node, delete_node |

| **Codegen Build Loop** (for production code) — **2-step process** |

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| **Step 1: Export** | CodeGen Phase 1-3 | analyze.md, discover.md, deduplicate.md | `export_nodes` returns PenNode JSON |
| **Step 2: Generate** | CodeGen Phase 4: GENERATE | generate.md | Feed JSON + `get_design_prompt(section: "codegen-react")` to AI model |

**Codegen is 2-step:** `export_nodes` returns raw PenNode JSON — it does NOT generate React/HTML code. Use the exported JSON as input to an LLM with `get_design_prompt(section: "codegen-react")` (or vue/swiftui/compose/etc.) providing framework-specific codegen guidance.

For detailed phase content, see the sub-skill files referenced above. Baton template: `templates/codegen-state.md`

## OpenPencil MCP Tools

All tools are called directly: `openpencil_<tool_name>({ arguments })`. See **Multi-Agent Compatibility** for Claude Code/Codex syntax.

```javascript
// Document: openpencil_open_document({ filePath })
// Read: openpencil_batch_get({ filePath, parentId, readDepth })
// CRUD: openpencil_insert_node, openpencil_update_node, openpencil_delete_node, openpencil_move_node, openpencil_copy_node, openpencil_replace_node
//       All support pageId to target specific page (defaults to first page — ⚠️ KNOWN ISSUE: pageId may target wrong page for page 2+)
// Batch DSL: openpencil_batch_design({ operations, postProcess, pageId })
// Layered: openpencil_design_skeleton, openpencil_design_content, openpencil_design_refine
// Variables: openpencil_get_variables, openpencil_set_variables, openpencil_set_themes
// Design MD: openpencil_get_design_md, openpencil_set_design_md, openpencil_export_design_md
// Layout: openpencil_snapshot_layout({ maxDepth }), openpencil_find_empty_space({ width, height, direction })
// Pages: openpencil_add_page, openpencil_remove_page, openpencil_rename_page, openpencil_reorder_page, openpencil_duplicate_page
// Import/Export: openpencil_import_svg({ svgPath }), openpencil_export_nodes({ filePath })
// Knowledge: openpencil_get_design_prompt({ section: "schema" })
```

**MCP Cannot Do:** Screenshot capture (use Playwright), AI code generation (use AI with knowledge files), Trigger sub-skills (use read() or task())

**Full MCP Reference:** `reference/mcp-tool-index.md` (34 tools with arguments)

## Agent Platform Tools Reference

Beyond MCP, this skill uses built-in agent tools. Full syntax mapping per framework:

| Category | Purpose | OpenCode | Claude Code | Codex |
|----------|---------|----------|-------------|-------|
| **Filesystem** | Read/write/edit files, list dirs, search, create dirs | `read()`, `write()`, `edit()`, `filesystem_*()` | `Read`, `Write`, `Edit`, `Glob`, `Bash` | `fs.*`, `glob.sync()` |
| **LSP** | Diagnostics, goto def, find refs, symbols, rename | `lsp_diagnostics()`, `lsp_goto_definition()`, etc. | `Bash(tsc --noEmit)` | LSP client |
| **AST** | Search/replace code patterns | `ast_grep_search()`, `ast_grep_replace()` | ast-grep CLI | ast-grep CLI |
| **Task Mgmt** | Create/list/get/update/delete tasks | `task_create()`, `task_list()`, `task_update()` | `TodoWrite`, `TodoRead` | Custom tracker |
| **Browser** | Screenshot, navigate, snapshot | `playwright_browser_*()` | Playwright CLI | Puppeteer |
| **Session** | Background tasks, output collection, cancel | `task(run_in_background)`, `background_output()`, `background_cancel()` | tool_use background | `Agent.run(background)` |

**Codegen phase → tool mapping:**
- **Analyze:** `read()`, `lsp_diagnostics()`, `filesystem_list_directory()` — check .op file, scan project
- **Discover:** `filesystem_search_files()`, `lsp_symbols()`, `ast_grep_search()` — find components, parse exports
- **Deduplicate:** `read()`, in-memory hashing — hash nodes, map duplicates
- **Generate:** `write()`, `filesystem_create_directory()`, `lsp_diagnostics()` — write files, validate output

---

## Complete Loop Example

```
User: "I want a mobile login screen with social login options"

PHASE 1: PLANNING
- Detect: Type 2 (Single-task screen, 375x812)
- Output subtasks: "header" (Logo+title), "form" (Email/password), "submit" (Primary button), "social" (Google/Apple login)

PHASE 2: GENERATION
- Build each section via MCP insert_node / batch_design
- Export code: AI generates semantic React component

PHASE 3: VALIDATION
- Capture screenshot via Playwright
- Analyze issues → qualityScore
- Apply fixes via MCP

PHASE 4: MAINTENANCE
- User: "add a forgot password link"
- Use incremental-add.md → append link after password input
```

---

## Multi-Page Parallel Build

Build multiple pages in the same `.op` file simultaneously using page-scoped agents. Each page is a fully independent design canvas (own width/height/viewport) — content does NOT affect other pages. Single `.op` file = one source of truth.

### Page Data Model

`.op` files store pages at top level. All node operations accept `pageId` to target a specific page. Omit → defaults to first page.

### Parallel Build Workflow

```
Step 1: Create pages (sequential — needed to get pageIds)
  add_page(name="LoginScreen")     → pageId-A
  add_page(name="DashboardScreen") → pageId-B

Step 2: Decompose each page into subtasks (sequential)
  openpencil-loop → page-A subtasks: header, form, social-login
  openpencil-loop → page-B subtasks: sidebar, metrics-row, chart-area

Step 3: Build in parallel (each page isolated)
  Agent-Login:     batch_design({ pageId: pageId-A, ... })
  Agent-Dashboard: batch_design({ pageId: pageId-B, ... })
  ⚠️ Sub-agents do NOT save files — return results only

Step 4: Collect results + ORCHESTRATOR SAVES (sequential)
  Orchestrator receives: "✅ Login page built. Please save file."
  Orchestrator receives: "✅ Dashboard page built. Please save file."
  Orchestrator: export_nodes() + filesystem_write_file()

Step 5: Validate each page (can be parallel)
  Agent-Login:     snapshot_layout + screenshot review
  Agent-Dashboard: snapshot_layout + screenshot review
  ⚠️ Sub-agents do NOT save — return validation results

Step 6: Export all pages (sequential — single file export)
  export_nodes({ pageId: pageId-A })
  export_nodes({ pageId: pageId-B })
  Orchestrator saves final .op file
```

### Page Templates

For apps with consistent UI chrome, create a template page first, then `duplicate_page()` for each actual screen and fill in page-specific content.

### Rules

- ✅ DO: Create pages first, then build in parallel
- ✅ DO: Use `pageId` on every node operation to be explicit
- ✅ DO: `add_page` returns the new `pageId` — capture it
- ✅ DO: **Only orchestrator saves files** — sub-agents return results and remind orchestrator to save
- ❌ DON'T: Build on the same page from multiple agents simultaneously (race condition)
- ❌ DON'T: Omit `pageId` when working with multi-page documents (ambiguous)
- ❌ DON'T: Let sub-agents save files — causes concurrent write conflicts
- ⚠️ **KNOWN ISSUE**: `pageId` parameter may target the wrong page for page 2+. When building multi-page designs, prefer operating on page 1 only, or use `add_page`/`duplicate_page` to reconstruct pages

---

## File Management

**Canvas file location — ALWAYS use a fixed path:**
```
canvas/
  └── design.op    ← ONE file, same location across all iterations
```

- Store `.op` in `canvas/` subdirectory next to project files
- Use SAME file path throughout entire loop — never create ad-hoc copies
- Examples: `./canvas/design.op` or `~/projects/login/canvas/login.op`

**Save discipline:**
- `batch_design` auto-saves. After manual edits in OpenPencil app: trigger save explicitly
- If using CLI: `op save` after operations
- Before closing OpenPencil app: always save first

**Never do:** `canvas/v1.op`, `canvas/v2_final.op`, `canvas/backup.op` — scattered copies; working on file and closing without saving; overwriting .op without backup

### `.op/DESIGN.md` Schema

Design system specification file. Created once (with user confirmation), then referenced by every generation phase. Sections: Typography, Colors (light/dark themes), Spacing (8px grid), Components (Button/Card/Navbar/Form specs with JSON), Shadows (Subtle/Medium/Elevated), Design Notes (generation rules, icon reference, semantic role usage).

Full template: `templates/DESIGN.md`

### `.op/PROJECT.md` Schema

Project roadmap file. Tracks overall design direction, completed screens, and future plans. Updated after each iteration. Sections: Vision, Design System Reference, Device Targets, Screens (Sitemap with checkboxes), Roadmap, Ideas.

Full template: `templates/PROJECT.md`

---

## OpenPencil CLI Quick Reference

```bash
op start [--desktop|--web]           # Launch app
op design '<dsl>'                    # Batch design (inline, @file, or stdin)
op insert '<json>' [--parent P]     # Insert node
op update <id> '<json>'              # Update node
op delete <id>                       # Delete node
op move <id> <parent> [index]        # Move node
op copy <id> <parent>                # Deep-copy node
op replace <id> '<json>'             # Replace node
op get [--depth N] [--pretty]        # Get document tree
op export <react|html|vue|flutter|swiftui|compose|css> --out <file>   # Export code
op design:skeleton '<json>'          # Create section structure
op design:content <id> '<json>'      # Populate section content
op design:refine --root_id <id>     # Validate + auto-fix
```

**PNG/SVG images** must be captured manually from OpenPencil app.
