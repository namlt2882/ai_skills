# OpenPencil MCP Tool Index

**MCP Prefix:** `openpencil_*` (40 tools, NO desktop app needed)

All tools are called directly: `openpencil_<tool_name>({ arguments })`

## ⚠️ CRITICAL: No File Persistence

**All `openpencil_*` tools operate IN-MEMORY ONLY.** Changes are NOT written to disk.

- After `insert_node` / `batch_design`, nodes exist in live canvas
- The `.op` file on disk remains `{"version":"1.0.0","children":[]}`
- Re-opening the file **LOSES ALL WORK**

**Workaround:** Manually export after each session:
```javascript
const nodes = openpencil_batch_get({ readDepth: 5 })
filesystem_write_file({ path: "canvas/design.op", content: JSON.stringify({ version: "1.0.0", children: nodes.nodes }) })
```

---

## Available Tools (40 total)

### Document Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `open_document` | `filePath` | Open/create `.op` file, connect to live canvas (⚠️ in-memory only, no persistence) |

**Note:** `save_file` does NOT exist for `openpencil_*` prefix. Use `filesystem_write_file()` to manually persist.

### Read Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `batch_get` | `patterns?, nodeIds?, pageId?, parentId?, readDepth?, searchDepth?` | Search and read nodes |
| `get_selection` | `readDepth?` | Get currently selected nodes |
| `get_variables` | `type?: COLOR\|FLOAT\|STRING\|BOOLEAN` | List design variables |
| `snapshot_layout` | `filePath?, maxDepth?, pageId?, parentId?` | Get hierarchical bounding box tree |
| `read_nodes` | `nodeIds?, depth?, pageId?, filePath?, includeVariables?` | Read nodes with depth control (replaces deprecated export_nodes) |
| `find_empty_space` | `width, height, direction, nodeId?, padding?` | Find empty canvas space |

### Create Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `insert_node` | `parent, data: {type, name, width, height...}, canvasWidth?, pageId?, postProcess?` | Insert new node |
| `add_page` | `name?, children?, filePath?` | Add new page |

### Modify Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `update_node` | `nodeId, data, canvasWidth?, pageId?, postProcess?` | Update node properties |
| `delete_node` | `nodeId, filePath?, pageId?` | Delete node (top-level only) |
| `move_node` | `nodeId, parent, index?, filePath?, pageId?` | Move node to new parent |
| `copy_node` | `sourceId, parent, overrides?, filePath?, pageId?` | Deep copy node |
| `replace_node` | `nodeId, data, canvasWidth?, pageId?, postProcess?` | Replace node entirely |

### Batch Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `batch_design` | `operations, canvasWidth?, filePath?, pageId?, postProcess?` | Execute DSL operations |
| `design_skeleton` | `rootFrame, sections, canvasWidth?, filePath?, pageId?, styleGuide?` | Create page structure |
| `design_content` | `sectionId, children, canvasWidth?, pageId?, postProcess?` | Populate section content |
| `design_refine` | `rootId, canvasWidth?, filePath?, pageId?` | Validate + auto-fix |

### Design MD Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `get_design_md` | `filePath?` | Get design.md specification |
| `set_design_md` | `markdown?, autoExtract?, filePath?` | Import design.md |
| `export_design_md` | `filePath?` | Export design.md as markdown |

### Variables & Themes

| Tool | Arguments | Description |
|------|-----------|-------------|
| `set_variables` | `variables, filePath?, replace?` | Set design variables |
| `set_themes` | `themes, filePath?, replace?` | Set theme axes |

### Theme Presets

| Tool | Arguments | Description |
|------|-----------|-------------|
| `save_theme_preset` | `presetPath, filePath?, name?` | Save theme as preset |
| `load_theme_preset` | `presetPath, filePath?` | Load theme preset |
| `list_theme_presets` | `directory` | List available presets |

### Page Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `add_page` | `name?, children?, filePath?` | Create new page |
| `remove_page` | `pageId, filePath?` | Delete page |
| `rename_page` | `pageId, name, filePath?` | Rename page |
| `reorder_page` | `pageId, index, filePath?` | Move page position |
| `duplicate_page` | `pageId, name?, filePath?` | Clone page |

### Design Knowledge

| Tool | Arguments | Description |
|------|-----------|-------------|
| `get_design_prompt` | `section?: all\|schema\|layout\|roles\|text\|style\|icons\|examples\|guidelines\|planning` | Get design knowledge prompt. Use "section" to retrieve a focused subset. Default: all. **TIP: For production, prefer curated skill files** (`phases/generation/schema.md`, `phases/generation/layout-rules.md`, `knowledge/role-definitions.md`, `phases/generation/design-system.md`) which are pre-processed and validated.

### Import

| Tool | Arguments | Description |
|------|-----------|-------------|
| `import_svg` | `svgPath, canvasWidth?, filePath?, maxDim?, pageId?, parent?, postProcess?` | Import SVG file |

### Code Generation

| Tool | Arguments | Description |
|------|-----------|-------------|
| `codegen_plan` | `plan, filePath?, pageId?` | Submit code generation plan (validates, returns executionPlan) |
| `codegen_submit_chunk` | `planId, result` | Submit generated code for one chunk |
| `codegen_assemble` | `planId, framework` | Retrieve all chunk results for final assembly |
| `codegen_clean` | `planId` | Clean up abandoned codegen plan |

### Style & Bulk Property Operations

| Tool | Arguments | Description |
|------|-----------|-------------|
| `get_style_guide_tags` | — | List available style guide tags |
| `get_style_guide` | `tags?, name?, platform?` | Get style guide for design inspiration |
| `search_all_unique_properties` | `parents, properties, filePath?, pageId?` | Recursively search unique property values |
| `replace_all_matching_properties` | `parents, properties, filePath?, pageId?` | Recursively replace matching property values |

---

## JSX Render Format (batch_design DSL)

| Shorthand | Full Property | Example |
|-----------|---------------|---------|
| `w` | `width` | `w={320}` |
| `h` | `height` | `h={200}` or `h="hug"` |
| `flex` | `layout` | `flex="col"` or `flex="row"` |
| `p` | `padding` | `p={24}` |
| `bg` | `fill` | `bg="#FFF"` |
| `gap` | `itemSpacing` | `gap={16}` |
| `rounded` | `cornerRadius` | `rounded={12}` |

**DSL Operations:**
```
binding=I(parent, { ...nodeData })  — Insert node
U(nodeId, { ...updates })           — Update node
binding=C(sourceId, parent, { overrides }) — Copy node
binding=R(nodeId, { ...newNodeData }) — Replace node
M(nodeId, parent, index?)           — Move node
D(nodeId)                           — Delete (⚠️ known issue: may not work)
```

**Example:**
```javascript
openpencil_batch_design({
  operations: [
    "card=I(null, {type:'frame',name:'Card',w:320,h:'hug',layout:'vertical',gap:16,padding:24,fill:'#FFF',cornerRadius:12})",
    "I(card, {type:'text',name:'Title',fontSize:18,fontWeight:'bold',content:'Title'})",
    "I(card, {type:'text',name:'Body',fontSize:14,fill:'#666',content:'Description'})"
  ],
  postProcess: true
})
```

---

## Known Issues

| Issue | Workaround |
|-------|------------|
| `D()` in batch_design silently no-ops | Use `delete_node` directly |
| `delete_node` only works for top-level nodes | Move nested nodes to root first, then delete |
| `pageId` may target wrong page for page 2+ | Operate on page 1 only, or recreate pages |
| `copy_node` requires `sourceId` not `nodeId` | Use `sourceId` parameter |
| `design_skeleton` creates equal-width sections | Use `update_node` to set explicit widths after |

---

## CLI Fallback for Missing MCP Capabilities

**Critical**: MCP lacks several capabilities that CLI provides. Use CLI when MCP cannot perform the needed operation.

| MCP Missing | CLI Alternative | When to Use |
|-------------|-----------------|-------------|
| NO save tool | `op save <file.op>` | **ALWAYS after MCP changes** |
| NO code export | `op export --format react/html/vue/etc` | Code generation needs |
| NO Figma import | `op import:figma <file.fig>` | Figma workflow |
| NO app control | `op start/stop/status` | Lifecycle management |

**Why MCP doesn't have these:**
- Save: The MCP server operates in-memory only; file I/O requires CLI
- Code export: Generates React/Vue/Flutter code - not PenNode JSON
- Figma import: Parses .fig files - outside MCP's JSON focus

**CLI save pattern (MANDATORY after design work):**
```bash
op save mydesign.op   # Persist MCP changes to disk
```

See: `reference/cli-commands.md` for full CLI ↔ MCP mapping

---

*OpenPencil MCP Server: `openpencil` (https://github.com/ZSeven-W/openpencil)*