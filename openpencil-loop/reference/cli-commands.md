# OpenPencil CLI Command Reference

**CLI Package:** `@zseven-w/openpencil`  
**Install:** `npx @zseven-w/openpencil --help`  
**Total Commands:** 35 (+ 9 export formats)

---

## CLI vs MCP Overview

| Capability | CLI | MCP |
|------------|-----|-----|
| **App Control** | ✅ `op start/stop/status` | ❌ Not available |
| **File Persistence** | ✅ `op save <file.op>` | ❌ No save tool |
| **Selection** | ✅ `op selection` | ✅ `openpencil_get_selection` |
| **Node Query** | ✅ `op get [--type] [--name] [--id]` | ✅ `openpencil_batch_get` |
| **Node CRUD** | ✅ `op insert/update/delete/move/copy/replace` | ✅ Full MCP equivalents |
| **Batch DSL** | ✅ `op design <dsl>` | ✅ `openpencil_batch_design` |
| **Layered Design** | ✅ `op design:skeleton/content/refine` | ✅ Full MCP equivalents |
| **Code Export** | ✅ `op export <format>` | ❌ No code generation |
| **Variables & Themes** | ✅ Full suite | ✅ Full MCP equivalents |
| **Page Operations** | ✅ Full suite | ✅ Mostly (no `page list`) |
| **SVG Import** | ✅ `op import:svg` | ✅ `openpencil_import_svg` |
| **Figma Import** | ✅ `op import:figma` | ❌ CLI-only |
| **Layout Info** | ✅ `op layout` | ❌ CLI-only |
| **Empty Space** | ✅ `op find-space` | ✅ `openpencil_find_empty_space` |

**Critical:** MCP tools have **no file persistence** — always run `op save <file.op>` after MCP changes when working with `.op` files!

---

## Command Categories

### 1. App Control

| CLI Command | Flags | MCP Equivalent | Description |
|-------------|-------|----------------|-------------|
| `op start` | `[--desktop\|--web]` | — | Launch OpenPencil app |
| `op stop` | — | — | Stop running instance |
| `op status` | — | — | Check if app is running |

**CLI-only.** No MCP equivalent for app lifecycle control.

---

### 2. Document Operations

| CLI Command | Arguments / Flags | MCP Equivalent | Description |
|-------------|-------------------|----------------|-------------|
| `op open` | `[file.op]` | `openpencil_open_document` | Open `.op` file or connect to live canvas |
| `op save` | `<file.op>` | — ⚠️ | Save current document to file |
| `op get` | `[--type X] [--name Y] [--id Z] [--depth N]` | `openpencil_batch_get` | Query/search nodes |
| `op selection` | — | `openpencil_get_selection` | Get current canvas selection |

**Notes:**
- `op save` is **mandatory** for file persistence — no MCP save tool exists
- `op get` without args returns top-level page children; add flags to filter by type, name, or ID
- `op open` without a path connects to the running live canvas

---

### 3. Node Manipulation

| CLI Command | Arguments / Flags | MCP Equivalent | Description |
|-------------|-------------------|----------------|-------------|
| `op insert` | `<json> [--parent P] [--index N] [--post-process]` | `openpencil_insert_node` | Insert new node |
| `op update` | `<id> <json> [--post-process]` | `openpencil_update_node` | Update node properties |
| `op delete` | `<id>` | `openpencil_delete_node` | Delete node and children |
| `op move` | `<id> --parent <P> [--index N]` | `openpencil_move_node` | Move node to new parent |
| `op copy` | `<id> [--parent P]` | `openpencil_copy_node` | Deep-copy node |
| `op replace` | `<id> <json> [--post-process]` | `openpencil_replace_node` | Replace node with new data |

**DSL equivalents:** `I()`, `U()`, `D()`, `M()`, `C()`, `R()`

---

### 4. Design Commands

| CLI Command | Arguments / Flags | MCP Equivalent | Description |
|-------------|-------------------|----------------|-------------|
| `op design` | `<dsl\|@file\|->` | `openpencil_batch_design` | Execute batch DSL operations |
| `op design:skeleton` | `<json\|@file\|->` | `openpencil_design_skeleton` | Create root frame + section skeleton |
| `op design:content` | `<section-id> <json\|@file\|->` | `openpencil_design_content` | Populate a section with content nodes |
| `op design:refine` | `--root-id <id>` | `openpencil_design_refine` | Validate + auto-fix full design tree |

**DSL format for `op design`:**
```
binding=I(parent, { ...nodeData })   # Insert
U(nodeId, { ...updates })            # Update
binding=C(sourceId, parent, {})      # Copy
binding=R(nodeId, { ...newData })    # Replace
M(nodeId, parent, index?)            # Move
D(nodeId)                            # Delete
```

**Usage examples:**
```bash
# Pipe DSL from stdin
echo 'root=I(null, { "type": "frame", "width": 1200 })' | op design -

# From file
op design @my-design.dsl

# Inline
op design 'root=I(null, { "type": "frame", "width": 1200 })'
```

---

### 5. Export

| CLI Command | Arguments / Flags | MCP Equivalent | Description |
|-------------|-------------------|----------------|-------------|
| `op export` | `<format> [--out file]` | — | Export design as code or image |

**Supported formats:**

| Format | CLI Flag | MCP Equivalent | Output |
|--------|----------|----------------|--------|
| `react` | `op export react` | — | React components |
| `html` | `op export html` | — | HTML markup |
| `vue` | `op export vue` | — | Vue components |
| `svelte` | `op export svelte` | — | Svelte components |
| `flutter` | `op export flutter` | — | Flutter widgets |
| `swiftui` | `op export swiftui` | — | SwiftUI views |
| `compose` | `op export compose` | — | Compose Multiplatform |
| `rn` | `op export rn` | — | React Native |
| `css` | `op export css` | — | CSS styles |

**All code export formats are CLI-only.** No MCP equivalent for code generation.

> **Note:** PNG/JPG/WEBP raster export is the desktop app only (`Cmd+Shift+P`). The MCP server has no raster export tool. Code export (`op export react`, etc.) is CLI-only.

---

### 6. Variables & Themes

| CLI Command | Arguments | MCP Equivalent | Description |
|-------------|-----------|----------------|-------------|
| `op vars` | — | `openpencil_get_variables` | Get all design variables |
| `op vars:set` | `<json>` | `openpencil_set_variables` | Set design variables |
| `op themes` | — | `openpencil_get_themes` | Get all theme axes |
| `op themes:set` | `<json>` | `openpencil_set_themes` | Set theme axes and variants |
| `op theme:save` | `<file.optheme>` | `openpencil_save_theme_preset` | Save theme as preset file |
| `op theme:load` | `<file.optheme>` | `openpencil_load_theme_preset` | Load theme from preset file |
| `op theme:list` | `[dir]` | `openpencil_list_theme_presets` | List `.optheme` preset files |

---

### 7. Page Operations

| CLI Command | Arguments | MCP Equivalent | Description |
|-------------|-----------|----------------|-------------|
| `op page list` | — | — ⚠️ | List all pages (CLI-only) |
| `op page add` | `[--name N]` | `openpencil_add_page` | Add new page |
| `op page remove` | `<id>` | `openpencil_remove_page` | Delete page |
| `op page rename` | `<id> <name>` | `openpencil_rename_page` | Rename page |
| `op page reorder` | `<id> <index>` | `openpencil_reorder_page` | Move page to position |
| `op page duplicate` | `<id>` | `openpencil_duplicate_page` | Clone page |

**Note:** `op page list` has no MCP equivalent. Use `openpencil_open_document` to get page metadata.

---

### 8. Import

| CLI Command | Arguments | MCP Equivalent | Description |
|-------------|-----------|----------------|-------------|
| `op import:svg` | `<file.svg>` | `openpencil_import_svg` | Import local SVG as editable nodes |
| `op import:figma` | `<file.fig>` | — | Import Figma file (CLI-only) |

---

### 9. Layout

| CLI Command | Flags | MCP Equivalent | Description |
|-------------|-------|----------------|-------------|
| `op layout` | `[--parent P] [--depth N]` | — | Get hierarchical layout tree (CLI-only) |
| `op find-space` | `[--direction right\|bottom\|left\|top]` | `openpencil_find_empty_space` | Find empty canvas space |

---

## CLI ↔ MCP Tool Mapping Table

| CLI Command | MCP Tool | Notes |
|-------------|----------|-------|
| `op start` | — | CLI-only: app lifecycle |
| `op stop` | — | CLI-only: app lifecycle |
| `op status` | — | CLI-only: app lifecycle |
| `op open [file.op]` | `openpencil_open_document` | Same semantics |
| `op save <file.op>` | — | ⚠️ **NO MCP EQUIVALENT** — mandatory for persistence |
| `op get [--type] [--name] [--id] [--depth]` | `openpencil_batch_get` | CLI flags map to MCP `patterns`/`nodeIds` params |
| `op selection` | `openpencil_get_selection` | Same semantics |
| `op insert <json> [--parent P]` | `openpencil_insert_node` | Same args |
| `op update <id> <json>` | `openpencil_update_node` | Same args |
| `op delete <id>` | `openpencil_delete_node` | Same args |
| `op move <id> --parent P` | `openpencil_move_node` | Same args |
| `op copy <id> [--parent P]` | `openpencil_copy_node` | Same args |
| `op replace <id> <json>` | `openpencil_replace_node` | Same args |
| `op design <dsl>` | `openpencil_batch_design` | DSL string or `@file` or `-` (stdin) |
| `op design:skeleton <json>` | `openpencil_design_skeleton` | Same args |
| `op design:content <id> <json>` | `openpencil_design_content` | Same args |
| `op design:refine --root-id <id>` | `openpencil_design_refine` | Same args |
| `op export <format>` | — | CLI-only: code generation |
| `op vars` | `openpencil_get_variables` | Same semantics |
| `op vars:set <json>` | `openpencil_set_variables` | Same args |
| `op themes` | `openpencil_get_themes` | Read themes |
| `op themes:set <json>` | `openpencil_set_themes` | Same args |
| `op theme:save <file.optheme>` | `openpencil_save_theme_preset` | Same args |
| `op theme:load <file.optheme>` | `openpencil_load_theme_preset` | Same args |
| `op theme:list [dir]` | `openpencil_list_theme_presets` | Same args |
| `op page list` | — | ⚠️ CLI-only — no MCP list-pages tool |
| `op page add [--name N]` | `openpencil_add_page` | Same args |
| `op page remove <id>` | `openpencil_remove_page` | Same args |
| `op page rename <id> <name>` | `openpencil_rename_page` | Same args |
| `op page reorder <id> <index>` | `openpencil_reorder_page` | Same args |
| `op page duplicate <id>` | `openpencil_duplicate_page` | Same args |
| `op import:svg <file.svg>` | `openpencil_import_svg` | Same args |
| `op import:figma <file.fig>` | — | CLI-only: no MCP Figma import |
| `op layout [--parent P]` | — | CLI-only: no MCP layout tree |
| `op find-space [--direction]` | `openpencil_find_empty_space` | Same args |

---

## CLI-only Commands

These commands have **no MCP equivalent** and require the CLI:

| Command | Category | Why CLI-only |
|---------|----------|--------------|
| `op start [--desktop\|--web]` | App Control | Desktop app lifecycle |
| `op stop` | App Control | Desktop app lifecycle |
| `op status` | App Control | Desktop app lifecycle |
| `op save <file.op>` | Persistence | **No MCP save tool** — critical for file durability |
| `op export react` | Code Export | MCP has no code generation |
| `op export html` | Code Export | MCP has no code generation |
| `op export vue` | Code Export | MCP has no code generation |
| `op export svelte` | Code Export | MCP has no code generation |
| `op export flutter` | Code Export | MCP has no code generation |
| `op export swiftui` | Code Export | MCP has no code generation |
| `op export compose` | Code Export | MCP has no code generation |
| `op export rn` | Code Export | MCP has no code generation |
| `op export css` | Code Export | MCP has no code generation |
| `op import:figma <file.fig>` | Import | No MCP Figma integration |
| `op page list` | Pages | No MCP page-listing tool |
| `op layout` | Layout | No MCP layout tree |

---

## MCP-only Capabilities

These MCP tools have **no direct CLI equivalent**:

| MCP Tool | Reason |
|----------|--------|
| `openpencil_snapshot_layout` | Layout snapshot — no CLI equivalent |
| `openpencil_find_empty_space` | Find empty canvas space — no CLI equivalent |
| `openpencil_search_all_unique_properties` | Bulk property search — no CLI equivalent |
| `openpencil_replace_all_matching_properties` | Bulk property replace — no CLI equivalent |
| `openpencil_get_style_guide` / `openpencil_get_style_guide_tags` | Style guide lookup — no CLI equivalent |
| `openpencil_codegen_*` (4 tools) | Incremental codegen — no CLI equivalent |
| `openpencil_read_nodes` | Deep node reading with depth control — no CLI equivalent |

---

## Global Flags

All `op` commands support these global flags:

| Flag | Argument | Description |
|------|----------|-------------|
| `--file` | `<path>` | Target `.op` file (default: live canvas) |
| `--page` | `<id>` | Target page ID (default: first/active page) |
| `--pretty` | — | Human-readable JSON output |
| `--help` | — | Show command help |
| `--version` | — | Show CLI version |

**Examples:**
```bash
# Target a specific file and page
op get --file design.op --page page-123 --type frame --pretty

# Save to specific file
op save ./output/design.op

# Export React code with pretty output
op export react --out ./src/components --file design.op

# Insert node into specific file/page
op insert '{"type":"text","content":"Hello"}' --parent frame-id --file design.op --page page-id
```

---

## Common Workflows

### File-Based Design (CLI + MCP hybrid)

```bash
# 1. Open file (CLI or MCP)
op open design.op

# 2. Make changes via MCP tools (in agent)
# openpencil_insert_node({ ... })
# openpencil_update_node({ ... })

# 3. Save back to disk (CLI — MANDATORY)
op save design.op
```

### Code Generation from Design

```bash
# Generate React components
op export react --out ./src/components --file design.op

# Generate Flutter widgets
op export flutter --out ./lib/widgets --file design.op

# Generate SwiftUI views
op export swiftui --out ./Sources/Views --file design.op
```

### Layered Design Build

```bash
# Step 1: Skeleton
op design:skeleton '{"name":"Page","width":1200,...}' | op design:content <id> @content.json

# Step 2: Refine
op design:refine --root-id <root-id>

# Step 3: Persist
op save output.op
```

---

## Complete Command List

### App Control (3)
- `op start [--desktop|--web]`
- `op stop`
- `op status`

### Document (4)
- `op open [file.op]`
- `op save <file.op>`
- `op get [--type X] [--name Y] [--id Z] [--depth N]`
- `op selection`

### Nodes (6)
- `op insert <json> [--parent P] [--index N] [--post-process]`
- `op update <id> <json> [--post-process]`
- `op delete <id>`
- `op move <id> --parent <P> [--index N]`
- `op copy <id> [--parent P]`
- `op replace <id> <json> [--post-process]`

### Design (4)
- `op design <dsl|@file|->`
- `op design:skeleton <json|@file|->`
- `op design:content <section-id> <json|@file|->`
- `op design:refine --root-id <id>`

### Export (1 command, 9 formats)
- `op export <format> [--out file]`
  - Formats: `react`, `html`, `vue`, `svelte`, `flutter`, `swiftui`, `compose`, `rn`, `css`

### Variables & Themes (7)
- `op vars`
- `op vars:set <json>`
- `op themes`
- `op themes:set <json>`
- `op theme:save <file.optheme>`
- `op theme:load <file.optheme>`
- `op theme:list [dir]`

### Pages (6)
- `op page list`
- `op page add [--name N]`
- `op page remove <id>`
- `op page rename <id> <name>`
- `op page reorder <id> <index>`
- `op page duplicate <id>`

### Import (2)
- `op import:svg <file.svg>`
- `op import:figma <file.fig>`

### Layout (2)
- `op layout [--parent P] [--depth N]`
- `op find-space [--direction right|bottom|left|top]`

**Total:** 35 commands (+ 9 export format variants)

---

## Key Takeaways

1. **`op save` is mandatory** — MCP tools have no file persistence
2. **Code generation is CLI-only** — no MCP equivalent for `react/flutter/swiftui/etc`
3. **`op design`** (singular) runs batch DSL — maps to `openpencil_batch_design`
4. **`op export`** for code only — PNG export is desktop-app only (Cmd+Shift+P)
5. **`op selection`** and **`op get`** are separate commands with different purposes
6. **Figma import and `op layout` are CLI-only** — no MCP equivalent

---

*OpenPencil CLI: `@zseven-w/openpencil`*  
*MCP Server: `openpencil` (desktop app must be running for live canvas)*
