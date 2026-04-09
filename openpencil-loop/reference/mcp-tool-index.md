# OpenPencil (https://github.com/ZSeven-W/openpencil) MCP Tool Index

Complete reference for all MCP tools. **MCP Server:** `openpencil` (non-hyphenated)

## JSX Render Format

OpenPencil uses JSX-style rendering via `batch_design` DSL.

| Shorthand | Full Property | Example |
|-----------|---------------|---------|
| `w` | `width` | `w={320}` |
| `h` | `height` | `h={200}` or `h="hug"` |
| `flex` | `layout` | `flex="col"` or `flex="row"` |
| `p` | `padding` | `p={24}` |
| `bg` | `fill` | `bg="#FFF"` |
| `gap` | `itemSpacing` | `gap={16}` |
| `rounded` | `cornerRadius` | `rounded={12}` |

**Example:** `<Frame name="Card" w={320} h={200} flex="col" gap={16} p={24} bg="#FFF" rounded={12}><Text size={18} weight="bold">Title</Text></Frame>`

## Tool Categories (All use `skill_mcp` + `mcp_name: openpencil`)

### 1. Document Operations

| Tool | Arguments |
|------|-----------|
| `open_document` | `filePath` |
| `save_file` | `filePath` |
| `new_document` | — |

### 2. Read Operations

| Tool | Arguments |
|------|-----------|
| `get_page_tree` | — |
| `get_node` | `id, depth?` |
| `find_nodes` | `name?, type?` (FRAME, RECTANGLE, ELLIPSE, TEXT...) |
| `query_nodes` | `selector: "//FRAME[@width < 300]"`, `limit?` |
| `get_selection` | `readDepth?` |
| `get_components` | `name?, limit?` |
| `list_pages` | — |
| `list_variables` | `type?: COLOR|FLOAT|STRING|BOOLEAN` |
| `get_current_page` | — |
| `batch_get` | `patterns, readDepth?, searchDepth?` |

**XPath Examples:** `//FRAME` · `//FRAME[@width < 300]` · `//TEXT[contains(@text, 'Hello')]` · `//SECTION//TEXT` · `//*[@cornerRadius > 0]`

### 3. Create Operations

| Tool | Arguments |
|------|-----------|
| `create_shape` | `type, x, y, width, height, name` |
| `insert_node` | `parent, data: {type, name, width, height...}, postProcess?` |
| `create_component` | `id` |
| `create_instance` | `component_id, x?, y?` |

**Shape types:** `FRAME`, `RECTANGLE`, `ELLIPSE`, `TEXT`, `LINE`, `STAR`, `POLYGON`, `SECTION`

### 4. Modify Operations

| Tool | Arguments |
|------|-----------|
| `update_node` | `nodeId, data` |
| `set_fill` | `id, color, gradient?, color_end?` |
| `set_stroke` | `id, color, weight, align?` |
| `set_layout` | `id, direction?, spacing?, padding?, align?, counter_align?` |
| `set_text` | `id, text` |
| `set_font` | `id, family, size, style?` |
| `set_effects` | `id, type, color, offset_x?, offset_y?, radius?, spread?` |
| `set_opacity` | `id, value: 0-1` |
| `set_visible` | `id, value: bool` |
| `set_locked` | `id, value: bool` |
| `set_rotation` | `id, angle` |
| `set_constraints` | `id, horizontal?, vertical?` |
| `set_minmax` | `id, min_width?, max_width?, min_height?, max_height?` |
| `set_text_resize` | `id, mode: NONE|WIDTH_AND_HEIGHT|HEIGHT|TRUNCATE` |
| `set_text_properties` | `id, align_horizontal?, align_vertical?, text_decoration?` |
| `set_blend` | `id, mode: NORMAL|DARKEN|MULTIPLY...` |
| `set_stroke_align` | `id, align: INSIDE|CENTER|OUTSIDE` |
| `set_radius` | `id, radius?, top_left?, top_right?, bottom_left?, bottom_right?` |
| `set_image_fill` | `id, image_data, scale_mode: FILL|FIT|CROP|TILE` |

**Effect types:** `DROP_SHADOW`, `INNER_SHADOW`, `FOREGROUND_BLUR`, `BACKGROUND_BLUR`

### 5. Structure Operations

| Tool | Arguments |
|------|-----------|
| `delete_node` | `nodeId` |
| `clone_node` | `id` |
| `copy_node` | `sourceId, parent, overrides?` |
| `reparent_node` | `id, parent_id` |
| `move_node` | `nodeId, parent?, index?` |
| `group_nodes` | `ids` |
| `ungroup_node` | `id` |
| `node_move` | `id, x, y` |
| `node_resize` | `id, width, height` |
| `rename_node` | `id, name` |
| `flatten_nodes` | `ids` |
| `node_to_component` | `ids` |

### 6. Boolean Operations

| Tool | Arguments |
|------|-----------|
| `boolean_union` | `ids` |
| `boolean_subtract` | `ids` |
| `boolean_intersect` | `ids` |
| `boolean_exclude` | `ids` |

### 7. Export Operations

| Tool | Arguments |
|------|-----------|
| `export_image` | `ids?, format: PNG|JPG|WEBP, scale?` |
| `export_svg` | `ids?` |
| `export_nodes` | `nodeIds?` |

### 8. Variables & Themes

| Tool | Arguments |
|------|-----------|
| `create_variable` | `collection_id, name, type, value` |
| `set_variable` | `id, mode, value` |
| `bind_variable` | `node_id, variable_id, field` |
| `get_variable` | `id` |
| `find_variables` | `query, type?` |
| `delete_variable` | `id` |
| `create_collection` | `name` |
| `get_collection` | `id` |
| `list_collections` | — |
| `delete_collection` | `id` |
| `set_themes` | `themes: {Color: [Light, Dark]...}, replace?` |
| `get_variables` | — |
| `set_variables` | `variables, replace?` |

**Variable types:** `COLOR`, `FLOAT`, `STRING`, `BOOLEAN`

### 9. Analysis Tools

| Tool | Arguments | Returns |
|------|-----------|---------|
| `analyze_colors` | `limit?, show_similar?, threshold?` | Palette with frequencies |
| `analyze_typography` | `limit?, group_by?` | Font families, sizes, weights |
| `analyze_spacing` | `grid?` | Gap/padding with grid compliance |
| `analyze_clusters` | `limit?, min_count?, min_size?` | Repeated patterns |

### 10. Page Operations

| Tool | Arguments |
|------|-----------|
| `add_page` | `name, children?` |
| `remove_page` | `pageId` |
| `rename_page` | `pageId, name` |
| `duplicate_page` | `pageId, name?` |
| `reorder_page` | `pageId, index` |
| `switch_page` | `page` |

### 11. Design MD

| Tool | Arguments |
|------|-----------|
| `get_design_md` | — |
| `set_design_md` | `markdown, autoExtract?` |
| `export_design_md` | — |

### 12. Layout Analysis

| Tool | Arguments |
|------|-----------|
| `snapshot_layout` | `maxDepth?, parentId?` |
| `find_empty_space` | `direction, width, height, padding?, nodeId?` |
| `page_bounds` | — |

### 13. Theme Presets

| Tool | Arguments |
|------|-----------|
| `save_theme_preset` | `presetPath, name?` |
| `load_theme_preset` | `presetPath` |
| `list_theme_presets` | `directory` |

### 14. File Management

| Tool | Arguments |
|------|-----------|
| `import_svg` | `svgPath, maxDim?, parent?, postProcess?` |

### 15. Codegen & Design Knowledge

| Tool | Arguments | Returns |
|------|-----------|---------|
| `get_codegen_prompt` | — | Code generation guidelines |
| `get_design_prompt` | `section?` | Design knowledge |
| `design_to_tokens` | `format: css|tailwind|json, collection?, type?` | Token definitions |
| `design_to_component_map` | `page?` | Component decomposition |
| `design_skeleton` | `rootFrame, sections, styleGuide?` | Create section structure |
| `design_content` | `sectionId, children, postProcess?` | Populate section content |
| `design_refine` | `rootId` | Validate + auto-fix |

**Design prompt sections:** `all`, `schema`, `layout`, `roles`, `text`, `style`, `icons`, `examples`, `guidelines`, `planning`
**Token formats:** `css`, `tailwind`, `json`

### 16. Utilities

| Tool | Arguments |
|------|-----------|
| `node_bounds` | `id` |
| `node_tree` | `id, depth?` |
| `node_ancestors` | `id, depth?` |
| `node_children` | `id` |
| `node_bindings` | `id` |
| `viewport_get` | — |
| `viewport_set` | `x, y, zoom` |
| `viewport_zoom_to_fit` | `ids` |
| `list_fonts` | `family?` |
| `select_nodes` | `ids` |
| `diff_jsx` | `from, to` |
| `diff_create` | `from, to, depth?` |
| `diff_show` | `id, props` |
| `describe` | `id, depth?, grid?` |
| `arrange` | `mode: grid|row|column, cols?, gap?, ids?` |
| `calc` | `expr` |

## Quick Reference Patterns

**Create card via batch_design:**
```javascript
batch_design({
  operations: [
    "I(root, {type:'Frame',name:'Card',w:320,h:'hug',flex:'col',gap:16,p:24,bg:'#FFF',rounded:12})",
    "I(card, {type:'Text',name:'Title',size:18,weight:'bold',content:'Title'})",
    "I(card, {type:'Text',name:'Body',size:14,fill:'#666',content:'Description'})"
  ]
})
```

**Find buttons:**
```javascript
query_nodes({ selector: "//FRAME[@name='Button']" })
```

**Export:**
```javascript
export_image({ format: "PNG", scale: 2 })
```

**Set spacing:**
```javascript
set_layout({ id, spacing: 16, padding: 24 })
```

---

*Generated for OpenPencil (https://github.com/ZSeven-W/openpencil) - MCP Server: `openpencil`*
