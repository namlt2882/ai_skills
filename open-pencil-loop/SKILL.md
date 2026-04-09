---
name: open-pencil-loop
description: |
  Orchestrator for OpenPencil (https://github.com/open-pencil/open-pencil) design workflows. Use for creating, editing, and managing
  design documents with the OpenPencil desktop app. Triggers on: open-pencil, .fig, .pen,
  design system, component library, multi-page design, batch design, JSX rendering,
  design tokens, design-to-code.
  
  MCP: open-pencil (hyphenated). Desktop app must be running.
version: "2.0.0"
---

# OpenPencil (https://github.com/open-pencil/open-pencil) Skill Orchestrator

```
Claude Code ←MCP→ open-pencil server ←WebSocket RPC→ Desktop App
                                         ↓
                                     .fig/.pen files
```

**Key v2 Differences:** MCP: `open-pencil` (hyphenated) | Formats: `.fig`, `.pen` | JSX rendering | CLI: `openpencil`

## When to Use

1. Creating/editing design documents (.fig, .pen)
2. Multi-page design systems, component libraries
3. Programmatic design generation from specs
4. Design token extraction, code export
5. Batch operations, linting

## Prerequisites

**1. Desktop App Running** — MCP fails if app isn't active.

**2. MCP Config:**
```json
{ "mcpServers": { "open-pencil": { "command": "npx", "args": ["-y", "@opencode/open-pencil-mcp@latest"] } } }
```

## Pre-Flight Check

```bash
openpencil ping  # Verify desktop app responsive
```
If fails: ask user to start OpenPencil → wait → retry.

## Task Phases

| Phase | Task | Status |
|-------|------|--------|
| 1 | Pre-flight check | [ ] |
| 2 | Open/create document | [ ] |
| 3 | Build structure (skeleton → sections → content) | [ ] |
| 4 | Apply design tokens (variables, themes, colors) | [ ] |
| 5 | Refine and validate (lint, analyze, fix) | [ ] |
| 6 | Export (images, SVG, code) | [ ] |
| 7 | Save and close | [ ] |

## Decision Levels

| Level | Criteria | Action |
|-------|----------|--------|
| **Critical** | Destructive ops, file overwrites, major structural changes | STOP → Ask user |
| **Medium** | Style changes, layout adjustments, new elements | PROCEED → Inform user |
| **Automatic** | Read ops, analysis, exports, non-destructive queries | PROCEED silently |

## Core Workflow

### Phase 1: Document Setup
1. Pre-flight check (desktop app running?)
2. Open existing file or create new document
3. Verify file format (.fig or .pen)

### Phase 2: Structure Creation
1. Create root frame (page container)
2. Add section frames (header, hero, content, footer)
3. Configure auto-layout for each section

### Phase 3: Content Population
1. Render JSX components into sections
2. Apply semantic roles (button, card, heading, etc.)
3. Set design tokens (colors, typography, spacing)

### Phase 4: Refinement
1. Run design analysis (colors, typography, spacing, clusters)
2. Apply fixes for any issues
3. Run linter for consistency

### Phase 5: Export
1. Export images (PNG/JPG) for preview
2. Export SVG for vector assets
3. Generate code (React, CSS) if needed
4. Save theme preset for reuse

### Phase 6: Save
**CRITICAL: v2 does NOT auto-save.** Explicitly save via desktop app menu (Ctrl+S / Cmd+S).

## Sub-Skills Reference

Sub-skills are referenced by their `name` field in frontmatter. Load via `load_skills=[...]`.

```
load_skills=[...]          // ECC resolves by name within skill repo
load_skills=["skill:name"] // explicit repo:skill:name for cross-repo
```

| Category | Sub-Skill Names |
|----------|----------------|
| **Planning** | `design-type`, `decomposition`, `xpath-queries` |
| **Generation** | `design-system`, `jsx-format`, `layout-rules`, `text-rules`, `boolean-ops` |
| **Validation** | `vision-feedback`, `lint-check` |
| **Maintenance** | `local-edit`, `incremental-add` |
| **Knowledge** | `role-definitions`, `icon-catalog`, `design-principles`, `examples`, `copywriting`, `codegen`, `codegen-react`, `codegen-html` |
| **Domains** | `landing-page`, `dashboard`, `mobile-app`, `form-ui`, `cjk-typography`, `figma-import` |

### Phase-Based Tasks

| Task | Category | Skills | When to Use |
|------|----------|--------|-------------|
| **Design: PLANNING** | `ultrabrain` | `design-type`, `decomposition` | New design request |
| **Design: GENERATION** | `ultrabrain` | `design-system`, `jsx-format`, `layout-rules`, `text-rules` | Building sections from plan |
| **Design: VALIDATION** | `ultrabrain` | `vision-feedback`, `lint-check` | Quality check after generation |
| **Design: MAINTENANCE** | `ultrabrain` | `local-edit`, `incremental-add` | Edit or extend existing design |
| **Codegen: ANALYZE** | `unspecified-high` | `codegen` | Check project structure |
| **Codegen: GENERATE** | `deep` | `codegen`, `codegen-react`, `codegen-html` | Export to production code |
| **Prompt Enhancement** | `unspecified-high` | `enhance-prompt`, `role-definitions` | Vague user input needs structure |
| **Domain Selection** | `unspecified-high` | `landing-page`, `dashboard`, `mobile-app`, `form-ui`, `cjk-typography` | Match design to domain |
| **DESIGN.md Read** | `explore` | — | Check for existing design system |

### Parallel Task Dispatch

Sub-skills are **NOT** auto-discovered by ECC (ECC only sees top-level skill repos).
Use `read()` to lazy-load sub-skill content into your prompt context.

**Pattern:**
```typescript
// 1. Lazy-load sub-skill content
const designTypeContent = read({ filePath: "phases/planning/design-type.md" })
const decoContent = read({ filePath: "phases/planning/decomposition.md" })
const copyContent = read({ filePath: "knowledge/copywriting.md" })

// 2. Inject into task prompts as context
task(category="ultrabrain", load_skills=[], run_in_background=true, 
  prompt=`You are a design type detector.\n\nContext from design-type.md:\n${designTypeContent}\n\nDetect design type for: ...`)
task(category="ultrabrain", load_skills=[], run_in_background=true, 
  prompt=`You are a task decomposer.\n\nContext from decomposition.md:\n${decoContent}\n\nDecompose: ...`)
```

**Naming convention** (from sub-skill frontmatter `name` field):
- Planning: `phases/planning/design-type.md`, `phases/planning/decomposition.md`, `phases/planning/xpath-queries.md`
- Generation: `phases/generation/design-system.md`, `phases/generation/jsx-format.md`, `phases/generation/layout-rules.md`, `phases/generation/text-rules.md`, `phases/generation/boolean-ops.md`
- Validation: `phases/validation/vision-feedback.md`, `phases/validation/lint-check.md`
- Maintenance: `phases/maintenance/local-edit.md`, `phases/maintenance/incremental-add.md`
- Knowledge: `knowledge/role-definitions.md`, `knowledge/icon-catalog.md`, `knowledge/design-principles.md`, `knowledge/examples.md`, `knowledge/copywriting.md`, `knowledge/codegen/`, `knowledge/codegen-react.md`, `knowledge/codegen-html.md`
- Domains: `domains/landing-page.md`, `domains/dashboard.md`, `domains/mobile-app.md`, `domains/form-ui.md`, `domains/cjk-typography.md`, `domains/figma-import.md`

## MCP Tool Reference

Full reference: `reference/mcp-tool-index.md` (90+ tools)

**Common call pattern:**
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil   # hyphenated!
  tool_name: <TOOL_NAME>
  arguments: { ... }
```

### High-Frequency Tools

| Tool | Purpose |
|------|---------|
| `render` | JSX → node (primary v2 method). Props: `w/h` (num|"hug"|"fill"), `layout` ("vertical"|"horizontal"), `gap`, `p/px/py`, `justify`, `align`, `bg`, `rounded`, `name`, `role` |
| `batch_design` | DSL operations: `I(parent, {data})` insert, `U(id, {props})` update, `C(id, parent, {overrides})` copy |
| `get_page_tree` / `get_node` | Node discovery |
| `snapshot_layout` | Bounding box tree |
| `design_skeleton` / `design_content` / `design_refine` | Layered workflow (skeleton → content → refine) |
| `analyze_colors` / `analyze_typography` / `analyze_spacing` / `analyze_clusters` | Design QA |
| `export_nodes` / `export_image` | Export to code or images |
| `get_design_md` / `set_design_md` | Design system persistence |
| `list_variables` / `set_variables` / `bind_variable` | Design token management |

### Layered Design Workflow (skeleton → content → refine)

```yaml
# Step 1: Skeleton — creates section frames, returns section IDs
design_skeleton: {rootFrame: {name, width, height, layout}, sections: [{name, height, layout, role?}]}

# Step 2: Content — populates sections with nodes
design_content: {sectionId, children: [{type, role?, content}], postProcess?}

# Step 3: Refine — validates, auto-fixes overflow/roles/icons/layout
design_refine: {rootId}
```

## CLI Reference

```bash
# File operations
openpencil tree <file.fig>              # Document structure
openpencil find <file.fig> "pattern"    # Find nodes by name
openpencil node <file.fig> <id>         # Node details
openpencil query <file.fig> "selector"  # XPath query

# Export
openpencil export <file.fig> --format png --output ./exports/
openpencil convert <file.fig> --to react --output ./components/

# Analysis
openpencil lint <file.fig>              # Consistency check
openpencil analyze <file.fig>            # Full report

# Variables
openpencil variables <file.fig>

# Evaluation (JSX)
openpencil eval <file.fig> '<Frame w={100} h={100} bg="#FFF"/>'
```
CLI works offline on saved files. MCP requires desktop app.

## File Management

### Save Discipline

**CRITICAL: v2 does NOT auto-save.**

Pattern:
1. After significant changes: save explicitly
2. Before exports: save to ensure latest state
3. After batch operations: save before closing

```yaml
save_file: {filePath: "/path/to/design.fig"}
```

### File Formats

| Format | Extension | Use Case |
|--------|-----------|----------|
| Figma-compatible | `.fig` | Sharing, maximum compatibility |
| OpenPencil native | `.pen` | Smaller size, OpenPencil-only |
| Theme preset | `.optheme` | Reusable theme + variables |

## Multi-Page Parallel Build

### Approach: Sequential with Shared Components

1. Create base components on Page 1
2. Convert to components (reusable)
3. Create additional pages
4. Reference base components on each page

## Complete Loop Example

```yaml
# 1. Pre-flight
openpencil ping

# 2. Open document
open_file: {filePath: "/path/to/design.fig"}

# 3. Create page structure
render: {
  jsx: |
    <Frame name="Landing Page" w={1200} h="hug" layout="vertical" gap={0}>
      <Frame name="Header" h={80} w="fill" bg="#FFF" px={24} center>
        <Text size={20} weight="bold">Logo</Text>
      </Frame>
      <Frame name="Hero" h={400} w="fill" bg="#F5F5F5" p={48} layout="vertical" gap={16}>
        <Text size={48} weight="bold">Welcome</Text>
        <Text size={18} color="#666">Description goes here</Text>
      </Frame>
    </Frame>
}

# 4. Get page tree to find node IDs
get_page_tree

# 5. Update specific node
set_fill: {id: "0:3", color: "#007AFF"}

# 6. Analyze design
analyze_colors

# 7. Export preview
export_image: {format: "PNG", scale: 2}

# 8. CRITICAL: Save file
save_file: {filePath: "/path/to/design.fig"}
```

## Limitations & Workarounds

| Limitation | Workaround |
|------------|------------|
| Desktop app required | Always pre-flight check |
| No auto-save | Explicit save_file calls |
| Single user | Coordinate access |
| No real-time sync | Re-query after UI edits |
| WebSocket dependency | Retry with exponential backoff |

## Common Patterns

### Button Component
```yaml
render: {jsx: '<Frame name="Button" w="hug" h={40} px={16} bg="#007AFF" rounded={8} center role="button"><Text size={14} weight="medium" color="#FFF">Click Me</Text></Frame>'}
```

### Card with Shadow
```yaml
render: {jsx: '<Frame name="Card" w={320} h="hug" p={24} bg="#FFF" rounded={16}><Text name="Title" size={18} weight="bold" mb={8}>Card Title</Text><Text name="Body" size={14} color="#666">Card content</Text></Frame>'}
set_effects: {id: "card-id", type: "DROP_SHADOW", color: "#00000020", offset_x: 0, offset_y: 4, radius: 12}
```

### Responsive Layout
```yaml
render: {jsx: '<Frame name="Container" w={1200} h="hug" layout="horizontal" gap={16} wrap><Frame w={384} h={200} bg="#F5F5F5" rounded={8}/><Frame w={384} h={200} bg="#F5F5F5" rounded={8}/><Frame w={384} h={200} bg="#F5F5F5" rounded={8}/></Frame>'}
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Desktop app not responding | `openpencil ping` → verify app open → check WebSocket port (8080) → restart app |
| MCP tool failures | Verify `"open-pencil"` (hyphenated) in config → check app running → retry with delay |
| Export issues | Use `get_page_tree` to verify IDs → check file permissions → verify shapes are vector-compatible |

## References

- MCP Tool Index: `reference/mcp-tool-index.md`
- v1 Skill: `~/.config/opencode/skills/openpencil-loop/SKILL.md`
- CLI Help: `openpencil --help`
