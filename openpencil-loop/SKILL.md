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
├── phases/
│   ├── planning/
│   │   ├── design-type.md        ← Design type detection
│   │   └── decomposition.md      ← Task decomposition
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
    └── openpencil-ai/            ← For future AI integrations
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

**Required:** OpenPencil CLI (`npm install -g @zseven-w/openpencil`) + running instance (desktop or web server)

**Optional:** `.op/DESIGN.md` file, OpenPencil MCP Server, design reference images in `.op/references/`

## Multi-Agent Compatibility

This skill works across agent frameworks. Workflow, file formats, and phase logic are identical — only tool invocation syntax differs.

| Framework | Task Orchestration | MCP Tool Call | File I/O |
|-----------|-------------------|---------------|----------|
| **OpenCode** | `task(category, load_skills, ...)` | `skill_mcp({ mcp_name, tool_name, arguments })` | `read()`, `write()`, `edit()` |
| **Claude Code** | Background tasks via tool_use | `mcp__<server>__<tool>(args)` | `Read`, `Write`, `Edit` |
| **Codex** | `Agent.run()` or subprocess | HTTP MCP client or CLI | `fs.readFile`, `fs.writeFile` |
| **Aider** | Sequential (no native subagents) | CLI subprocess or HTTP | File read/write |
| **Custom** | Any orchestrator | MCP JSON-RPC or HTTP | Any filesystem API |

### Generic Patterns

```
// MCP Call — replace syntax per framework:
mcp_call("openpencil", "batch_get", { filePath, parentId, readDepth })
// OpenCode:    skill_mcp({ mcp_name: "openpencil", tool_name: "batch_get", arguments: {...} })
// Claude Code: mcp__openpencil__batch_get({ filePath, parentId, readDepth })
// Codex:       await openpencilMcp.batch_get({ filePath, parentId, readDepth })

// Task Dispatch — replace syntax per framework:
spawn_task(category="...", skills=[...], background=true, prompt="...")
// OpenCode:    task(category="ultrabrain", load_skills=["openpencil-design"], run_in_background=true, prompt="...")
// Claude Code: tool_use with subagent_type or background execution
// Codex:       Agent.run({ model: "o3", prompt: "...", background: true })
```

## Task Management

This skill uses **task orchestration** to avoid context dilution. The Build Loop follows 4 phases per loop type, each mapped to a task entry. Spawn subagents for each independent task.

### Sub-Skill Naming Convention

Sub-skills are referenced by their `name` field in frontmatter (no prefix needed within the same skill repo):

```
load_skills=[...]          // ECC resolves by name within skill repo
load_skills=["skill:name"] // explicit repo:skill:name for cross-repo
```

| Category | Sub-Skill Names |
|----------|----------------|
| **Planning** | `design-type`, `decomposition` |
| **Generation** | `design-system`, `schema`, `layout-rules`, `text-rules`, `jsonl-format` |
| **Validation** | `vision-feedback` |
| **Maintenance** | `local-edit`, `incremental-add` |
| **Codegen** | `analyze`, `discover`, `deduplicate`, `generate` |
| **Knowledge** | `role-definitions`, `icon-catalog`, `design-principles`, `examples`, `copywriting`, `codegen`, `codegen-react`, `codegen-html` |
| **Domains** | `landing-page`, `dashboard`, `mobile-app`, `form-ui`, `cjk-typography` |

### Phase-Based Tasks

| Task | Category | Skills | When to Use |
|------|----------|--------|-------------|
| **Phase 1: PLANNING** | `ultrabrain` | `design-type`, `decomposition` | User gives new design request |
| **Phase 2: GENERATION** | `ultrabrain` | `design-system`, `schema`, `layout-rules`, `text-rules`, `jsonl-format`, `role-definitions`, `icon-catalog` | Have decomposed plan, build each section |
| **Phase 3: VALIDATION** | `unspecified-high` | `vision-feedback` | Design is built, validate quality |
| **Phase 4: MAINTENANCE** | `ultrabrain` | `local-edit`, `incremental-add` | User wants to edit or add to existing design |
| **CodeGen: ANALYZE** | `unspecified-high` | `analyze` | Project structure check, design validation |
| **CodeGen: DISCOVER** | `explore` | `discover` | Find existing implementations in src/ |
| **CodeGen: DEDUPE** | `unspecified-high` | `deduplicate` | Hash-based component deduplication |
| **CodeGen: GENERATE** | `deep` | `generate`, `codegen`, `codegen-react`, `codegen-html` | Production code generation |

### Supporting Tasks

| Task | Category | Skills | When to Use |
|------|----------|--------|-------------|
| **Prompt Enhancement** | `unspecified-high` | `enhance-prompt`, `role-definitions` | User input is vague or needs structure |
| **DESIGN.md Creation** | `ultrabrain` | `design-system` | DESIGN.md missing and user confirms |
| **DESIGN.md Read** | `explore` | — | Check for existing DESIGN.md |
| **Domain Selection** | `ultrabrain` | `landing-page`, `dashboard`, `mobile-app`, `form-ui`, `cjk-typography` | Match design type to domain |
| **Project Documentation** | `writing` | `examples` | Updating PROJECT.md |

### Parallel Task Dispatch

Spawn independent tasks with `run_in_background=true`. Use consistent pageId conventions for multi-page work.

```typescript
// OpenCode — independent tasks run in parallel:
task(category="ultrabrain", load_skills=["design-type"],    run_in_background=true, prompt="Detect design type for: ...")
task(category="ultrabrain", load_skills=["decomposition"], run_in_background=true, prompt="Decompose: ...")
task(category="writing",    load_skills=["copywriting"],   run_in_background=true, prompt="Enhance: ...")

// Claude Code: tool_use with background=true
// Codex: Agent.run({ model: "o3-mini", prompt: "...", background: true })
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

YAML frontmatter with `design` and `device` fields, followed by structured sections carrying design system context and page structure forward.

```markdown
---
design: saas-landing-page
device: desktop
---

Build the Pricing section. Three-tier pricing table with Free, Pro (highlighted as recommended), and Enterprise plans.

**DESIGN SYSTEM:**
- Typography: Space Grotesk (headings), Inter (body)
- Primary: #6366F1, Background: #FFFFFF, Surface: #F9FAFB
- Button: cornerRadius 8, padding [12,24], fill #111111
- Card: cornerRadius 12, padding 24, fill #F9FAFB
- Spacing: 8px grid, section padding 80px

**Page Structure:**
1. Section header — "Simple, transparent pricing" + subtitle
2. Toggle — Monthly/Annual billing switch
3. Pricing cards row — Free, Pro (highlighted), Enterprise
4. FAQ accordion — 4-6 common questions
```

**Critical baton rules:**
- ✅ ALWAYS update the baton after each iteration with the next task
- ✅ ALWAYS include DESIGN SYSTEM section — copy relevant tokens from `.op/DESIGN.md`
- ✅ ALWAYS include Page Structure section — enumerate sections to build
- ✅ Set `device` to match the target viewport (`desktop` or `mobile`)
- ❌ NEVER leave the baton empty or with only frontmatter — next agent has no context
- ❌ NEVER skip the DESIGN SYSTEM section — generation quality degrades without tokens

Full template: `templates/next-prompt.md`

### Enhance Prompt Example

Transforms vague input into structured OpenPencil-ready prompts with design system context. Triggered automatically when user input lacks structure.

**Original:** `make me a login page`

**Enhanced:** Design a modern login page with clean visual hierarchy. Include DESIGN SYSTEM section (typography, colors, spacing, component tokens), Page Structure (left panel hero + right panel form with email/password inputs, forgot password link, sign in button, social login row, signup footer link), Layout notes (horizontal split desktop 1200px), and Visual Notes (subtle shadow, rounded inputs).

See `enhance-prompt` skill for the full transformation pipeline.

## Phase Workflow Summary

**Design Build Loop** (for UI design):

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| 1. PLANNING | Phase 1: PLANNING | design-type.md, decomposition.md | design_skeleton |
| 2. GENERATION | Phase 2: GENERATION | design-system.md, schema.md, layout-rules.md, text-rules.md, jsonl-format.md | batch_design, insert_node |
| 3. VALIDATION | Phase 3: VALIDATION | vision-feedback.md | batch_get, snapshot_layout |
| 4. MAINTENANCE | Phase 4: MAINTENANCE | local-edit.md, incremental-add.md | batch_design, update_node, delete_node |

**Codegen Build Loop** (for production code):

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| 1. ANALYZE | CodeGen Phase 1: ANALYZE | analyze.md | batch_get, get_design_md, snapshot_layout |
| 2. DISCOVER | CodeGen Phase 2: DISCOVER | discover.md | batch_get, export_nodes |
| 3. DEDUPE | CodeGen Phase 3: DEDUPE | deduplicate.md | export_nodes |
| 4. GENERATE | CodeGen Phase 4: GENERATE | generate.md | export_nodes |

For detailed phase content, see the sub-skill files referenced above. Baton template: `templates/codegen-state.md`

## OpenPencil MCP Tools

All MCP calls follow: `mcp_call(server, tool, arguments)`. Below shows OpenCode syntax — see **Multi-Agent Compatibility** for Claude Code/Codex equivalents.

```javascript
// Document: open_document({ filePath })
// Read: batch_get({ filePath, parentId, readDepth })
// CRUD: insert_node, update_node, delete_node, move_node, copy_node, replace_node
//       All support pageId to target specific page (defaults to first)
// Batch DSL: batch_design({ filePath, operations, postProcess, pageId })
// Layered: design_skeleton, design_content, design_refine
// Variables: get_variables, set_variables, set_themes
// Design MD: get_design_md, set_design_md, export_design_md
// Layout: snapshot_layout({ filePath, maxDepth }), find_empty_space({ filePath, width, height, direction })
// Pages: add_page, remove_page, rename_page, reorder_page, duplicate_page
// Import/Export: import_svg({ filePath, svgPath }), export_nodes({ filePath })
// Knowledge: get_design_prompt({ section: "schema" })
```

**MCP Cannot Do:** Screenshot capture (use Playwright), AI code generation (use AI with knowledge files), Trigger sub-skills (use read() or task())

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

Step 4: Validate each page (can be parallel)
  Agent-Login:     snapshot_layout + screenshot review
  Agent-Dashboard: snapshot_layout + screenshot review

Step 5: Export all pages (sequential — single file export)
  export_nodes({ pageId: pageId-A })
  export_nodes({ pageId: pageId-B })
```

### Page Templates

For apps with consistent UI chrome, create a template page first, then `duplicate_page()` for each actual screen and fill in page-specific content.

### Rules

- ✅ DO: Create pages first, then build in parallel
- ✅ DO: Use `pageId` on every node operation to be explicit
- ✅ DO: `add_page` returns the new `pageId` — capture it
- ❌ DON'T: Build on the same page from multiple agents simultaneously (race condition)
- ❌ DON'T: Omit `pageId` when working with multi-page documents (ambiguous)

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
