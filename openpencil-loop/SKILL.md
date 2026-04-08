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
│   │   └── vision-feedback.md     ← Vision QA (MCP: batch_get, snapshot_layout)
│   └── maintenance/
│       ├── local-edit.md         ← Update nodes (MCP: batch_design, update_node, delete_node, batch_get)
│       └── incremental-add.md     ← Add nodes (MCP: batch_design, insert_node, copy_node, batch_get)
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
│   └── next-prompt.md            ← Baton-passing template
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

## When to Use This Skill

Activate when you need ANY of these capabilities:
- **Design a new page** — Transform vague ideas into structured OpenPencil prompts with design system context
- **Continue existing project** — Pick up from `.op/next-prompt.md` baton file
- **Create design system** — Generate `.op/DESIGN.md` with user confirmation for colors, typography, components
- **Enhance prompts** — Add design system tokens, structure, and visual descriptions to vague user requests
- **Codify user decisions** — Store user preferences in DESIGN.md for consistency across iterations
- **Export code** — Generate React/Vue/SwiftUI components from OpenPencil designs

## Prerequisites

**Required:**
- OpenPencil CLI installed (`npm install -g @zseven-w/openpencil`)
- A running OpenPencil instance (desktop app or web server)

**Optional:**
- A `.op/DESIGN.md` file with design system specifications
- OpenPencil MCP Server — enables direct manipulation via MCP tools
- Design reference images in `.op/references/`

## Task Management

This skill uses **task orchestration** to avoid context dilution. The Build Loop follows 4 phases, each mapped to a task entry below. Spawn subagents for each independent task.

### Phase-Based Tasks

| Task | Category | Skills | Background | MCP Tools | Sub-Skills | When to Use |
|------|----------|--------|------------|-----------|------------|-------------|
| **Phase 1: PLANNING** | `ultrabrain` | `openpencil-design` | `true` | design_skeleton | phases/planning/design-type.md, phases/planning/decomposition.md | User gives new design request |
| **Phase 2: GENERATION** | `ultrabrain` | `openpencil-design` | `true` | batch_design, insert_node | phases/generation/*.md, knowledge/role-definitions.md, knowledge/icon-catalog.md | Have decomposed plan, build each section |
| **Phase 3: VALIDATION** | `ultrabrain` | `openpencil-design` | `true` | batch_get, snapshot_layout | phases/validation/vision-feedback.md | Design is built, validate quality |
| **Phase 4: MAINTENANCE** | `ultrabrain` | `openpencil-design` | `true` | batch_design, update_node, delete_node, insert_node | phases/maintenance/*.md | User wants to edit or add to existing design |

### Supporting Tasks

| Task | Category | Skills | Background | MCP Tools | When to Use |
|------|----------|--------|------------|-----------|-------------|
| **Prompt Enhancement** | `writing` | `enhance-prompt` | `true` | MCP tools for reading codegen guidelines | User input is vague or needs structure |
| **DESIGN.md Creation** | `ultrabrain` | `taste-design` | `true` | No MCP tools needed for creation | DESIGN.md missing and user confirms |
| **DESIGN.md Read** | `explore` | none | `true` | No MCP tools (just file read) | Check for existing DESIGN.md |
| **Code Export** | `unspecified-high` | none | `true` | export_nodes | User requests code export |
| **Project Documentation** | `ultrabrain` | none | `true` | No MCP tools | Updating PROJECT.md |

**Parallel subagent execution avoids context dilution:**
```typescript
// Fire these simultaneously — continue working while they run
task(category="explore", load_skills=[], run_in_background=true, description="Check DESIGN.md", prompt="Check if .op/DESIGN.md exists. Return file content if found, or 'NOT FOUND' if missing.")
task(category="writing", load_skills=["enhance-prompt"], run_in_background=true, description="Enhance prompt", prompt="Enhance this design prompt with structured page sections and visual descriptions...")

// Collect results when system notifies completion
```

## Decision Workflow

### Critical Decisions (Always Ask User)
These require explicit user confirmation before proceeding:

| Decision | What to Ask |
|----------|-------------|
| **Design System** | "No DESIGN.md found. Create one with default values or customize?" |
| **Colors** | "Color palette: Primary (accent), Background, Text roles?" |
| **Typography** | "Font families for headings, body? (e.g., Space Grotesk + Inter)" |
| **Spacing/Shadow** | "Spacing approach (8px grid)? Shadow depth (subtle/medium/elevated)?" |
| **Components** | "Button shape, card roundness, input style preferences?" |
| **Export Format** | "Export to code? (React/Vue/SwiftUI/Flutter/etc.)" |

### Medium Decisions (Offer Guidance, Allow Override)
These provide defaults with user override:

| Decision | Default | What to Offer |
|----------|---------|---------------|
| **Layout** | Vertical | "Vertical or horizontal layout?" |
| **Color Palette** | Zinc/Slate base | "Warm or cool gray base? Saturated accent?" |
| **Responsive** | Mobile-first | "Mobile-first or desktop-first strategy?" |
| **Density** | Balanced (5/10) | "Gallery airy (low) or cockpit dense (high)?" |

### Automatic Decisions (No Confirmation Needed)
These use sensible defaults:

| Decision | Default Value |
|----------|---------------|
| **Prompt enhancement** | Add structure, visual descriptions |
| **Component styling** | Apply semantic roles with smart defaults |
| **Project structure** | Section-based with sitemap tracking |
| **Export location** | `src/components/` or `lib/widgets/` |

## Overview

The Build Loop pattern enables continuous, autonomous design development through a "baton" system. Each iteration cycles through 4 phases defined in the **Task Management** table above: PLANNING → GENERATION → VALIDATION → MAINTENANCE → (repeat).

## Phase Workflow Summary

The Build Loop follows 4 phases, each implemented as a Task Management entry above:

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| 1. PLANNING | Phase 1: PLANNING | design-type.md, decomposition.md | design_skeleton |
| 2. GENERATION | Phase 2: GENERATION | design-system.md, schema.md, layout-rules.md, text-rules.md, jsonl-format.md | batch_design, insert_node |
| 3. VALIDATION | Phase 3: VALIDATION | vision-feedback.md | batch_get, snapshot_layout |
| 4. MAINTENANCE | Phase 4: MAINTENANCE | local-edit.md, incremental-add.md | batch_design, update_node, delete_node |

For detailed phase content, see the sub-skill files referenced above.

## OpenPencil MCP Tools (Actual from ZSeven-W/openpencil)

```javascript
// Document operations
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "open_document",
  arguments: { filePath: "path/to/design.op" }
})

// Read nodes
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "batch_get",
  arguments: { filePath: "path/to/design.op", parentId: "node-id", readDepth: 2 }
})

// Node CRUD (insert, update, delete, move, copy, replace)
// All node tools support pageId to target a specific page (defaults to first page)
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "insert_node",
  arguments: { filePath: "path/to/design.op", parent: "parent-id", data: {...}, postProcess: true, pageId: "target-page-id" }
})

skill_mcp({
  mcp_name: "openpencil",
  tool_name: "update_node",
  arguments: { filePath: "path/to/design.op", nodeId: "node-id", data: {...}, pageId: "target-page-id" }
})

skill_mcp({
  mcp_name: "openpencil",
  tool_name: "delete_node",
  arguments: { filePath: "path/to/design.op", nodeId: "node-to-delete", pageId: "target-page-id" }
})

skill_mcp({
  mcp_name: "openpencil",
  tool_name: "move_node",
  arguments: { filePath: "path/to/design.op", nodeId: "node-id", parent: "new-parent", index: 0, pageId: "target-page-id" }
})

skill_mcp({
  mcp_name: "openpencil",
  tool_name: "copy_node",
  arguments: { filePath: "path/to/design.op", sourceId: "source-id", parent: "parent-id", overrides: {...}, pageId: "target-page-id" }
})

skill_mcp({
  mcp_name: "openpencil",
  tool_name: "replace_node",
  arguments: { filePath: "path/to/design.op", nodeId: "node-id", data: {...}, pageId: "target-page-id" }
})

// Batch design (DSL) — pageId targets which page to write to
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "batch_design",
  arguments: {
    filePath: "path/to/design.op",
    operations: "root=I(null, {...})\nchild=I(root, {...})",
    postProcess: true,
    pageId: "target-page-id"
  }
})

// Layered design workflow
skill_mcp({ mcp_name: "openpencil", tool_name: "design_skeleton", arguments: {...} })
skill_mcp({ mcp_name: "openpencil", tool_name: "design_content", arguments: {...} })
skill_mcp({ mcp_name: "openpencil", tool_name: "design_refine", arguments: {...} })

// Variables & themes
skill_mcp({ mcp_name: "openpencil", tool_name: "get_variables", arguments: { filePath: "..." } })
skill_mcp({ mcp_name: "openpencil", tool_name: "set_variables", arguments: { filePath: "...", variables: {...} } })
skill_mcp({ mcp_name: "openpencil", tool_name: "set_themes", arguments: { filePath: "...", themes: {...} } })

// Design MD
skill_mcp({ mcp_name: "openpencil", tool_name: "get_design_md", arguments: { filePath: "..." } })
skill_mcp({ mcp_name: "openpencil", tool_name: "set_design_md", arguments: { filePath: "...", markdown: "..." } })
skill_mcp({ mcp_name: "openpencil", tool_name: "export_design_md", arguments: { filePath: "..." } })

// Layout & structure
skill_mcp({ mcp_name: "openpencil", tool_name: "snapshot_layout", arguments: { filePath: "...", maxDepth: 2 } })
skill_mcp({ mcp_name: "openpencil", tool_name: "find_empty_space", arguments: { filePath: "...", width: 100, height: 100, direction: "right" } })

// Pages
skill_mcp({ mcp_name: "openpencil", tool_name: "add_page", arguments: { filePath: "...", name: "Page 2" } })
skill_mcp({ mcp_name: "openpencil", tool_name: "remove_page", arguments: { filePath: "...", pageId: "..." } })
skill_mcp({ mcp_name: "openpencil", tool_name: "rename_page", arguments: { filePath: "...", pageId: "...", name: "New Name" } })
skill_mcp({ mcp_name: "openpencil", tool_name: "reorder_page", arguments: { filePath: "...", pageId: "...", index: 0 } })
skill_mcp({ mcp_name: "openpencil", tool_name: "duplicate_page", arguments: { filePath: "...", pageId: "..." } })

// Import/export
skill_mcp({ mcp_name: "openpencil", tool_name: "import_svg", arguments: { filePath: "...", svgPath: "..." } })
skill_mcp({ mcp_name: "openpencil", tool_name: "export_nodes", arguments: { filePath: "..." } })

// Design prompt (knowledge)
skill_mcp({ mcp_name: "openpencil", tool_name: "get_design_prompt", arguments: { section: "schema" } })
```

**MCP Cannot Do:**
- Screenshot capture (use Playwright)
- AI code generation (use AI with knowledge files)
- Trigger sub-skills (use read() or task())

---

## Complete Loop Example

```
User: "I want a mobile login screen with social login options"

PHASE 1: PLANNING
- Detect: Type 2 (Single-task screen, 375x812)
- Output subtasks:
  - "header" — Logo + title
  - "form" — Email/password inputs
  - "submit" — Primary button
  - "social" — Google/Apple login buttons

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

See Task Management (Phase-Based Tasks) for sub-skills to spawn per section.

Build multiple pages in the same `.op` file simultaneously using page-scoped agents.

### Why Multi-Page?

- Each page is a fully independent design canvas (own width/height/viewport)
- Page content does NOT affect other pages — safe for parallel writes
- Single `.op` file = one source of truth, easier to manage than multiple files

### Page Data Model

`.op` files store pages at top level:

```json
{
  "pages": [
    { "id": "page-uuid-1", "name": "Page 1", "children": [...] },
    { "id": "page-uuid-2", "name": "Page 2", "children": [...] }
  ]
}
```

All node operations accept `pageId` to target a specific page. Omit → defaults to first page.

### Parallel Build Workflow

```
Step 1: Create pages (sequential — needed to get pageIds)
  add_page(name="LoginScreen")     → pageId-A
  add_page(name="DashboardScreen") → pageId-B
  add_page(name="SettingsScreen")   → pageId-C

Step 2: Decompose each page into subtasks (sequential)
  openpencil-loop → page-A subtasks: header, form, social-login
  openpencil-loop → page-B subtasks: sidebar, metrics-row, chart-area
  openpencil-loop → page-C subtasks: profile-form, notifications

Step 3: Build in parallel (each page isolated)
  Agent-Login:     batch_design({ pageId: pageId-A, ... })  // Login page
  Agent-Dashboard:  batch_design({ pageId: pageId-B, ... })  // Dashboard page
  Agent-Settings:  batch_design({ pageId: pageId-C, ... })  // Settings page

Step 4: Validate each page (can be parallel)
  Agent-Login:     snapshot_layout + screenshot review
  Agent-Dashboard: snapshot_layout + screenshot review
  Agent-Settings:  snapshot_layout + screenshot review

Step 5: Export all pages (sequential — single file export)
  export_nodes({ pageId: pageId-A })
  export_nodes({ pageId: pageId-B })
  export_nodes({ pageId: pageId-C })
```

### Page Templates

For apps with consistent UI chrome (nav bars, tab bars), create a template page first:

```
1. Design the master template (LoginScreen-Template)
   - Nav bar, tab bar, safe areas
   - Leave content area empty (placeholder frame)

2. Duplicate for each actual screen
   duplicate_page(pageId: templatePageId, name: "Login - Email")

3. Fill in page-specific content on each duplicate
```

### Rules

- ✅ DO: Create pages first, then build in parallel
- ✅ DO: Use `pageId` on every node operation to be explicit
- ✅ DO: `add_page` returns the new `pageId` — capture it
- ❌ DON'T: Build on the same page from multiple agents simultaneously (race condition)
- ❌ DON'T: Omit `pageId` when working with multi-page documents (ambiguous)

### Code Export Per Page

Each page exports independently:

```
export_nodes({ filePath: "app.op", pageId: pageId-A })  // Login screen
export_nodes({ filePath: "app.op", pageId: pageId-B })  // Dashboard screen
```

---

## File Management

**Canvas file location — ALWAYS use a fixed path:**
```
canvas/
  └── design.op    ← ONE file, same location across all iterations
```

- Store the `.op` file in a `canvas/` subdirectory next to your project files
- Use the SAME file path throughout the entire loop — never create ad-hoc copies
- File path examples: `./canvas/design.op` or `~/projects/login/canvas/login.op`

**Save discipline — prevent state loss:**
- Save via MCP after every maintenance phase: `skill_mcp({ tool_name: "batch_design", arguments: {...} })` already auto-saves
- After batch_design operations: the file is saved automatically
- After manual edits in the OpenPencil app: trigger a save explicitly
- If using CLI: `op save` after operations
- Before closing the OpenPencil app: always save first

**Never do this:**
- ❌ `canvas/v1.op`, `canvas/v2_final.op`, `canvas/backup.op` — scattered copies
- ❌ Working on a file and closing without saving
- ❌ Overwriting the .op file without a backup of the previous state

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
