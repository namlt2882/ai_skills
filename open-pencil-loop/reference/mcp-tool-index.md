# OpenPencil (https://github.com/open-pencil/open-pencil) MCP Tool Index

Complete reference for all 90+ MCP tools. **MCP Server:** `open-pencil` (hyphenated)

## JSX Render Format (v2)

OpenPencil (https://github.com/open-pencil/open-pencil) uses JSX-style rendering.

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

## Tool Categories (All use `tool: skill_mcp` + `mcp_name: open-pencil`)

### 1. Document Operations

| Tool | Arguments |
|------|-----------|
| `open_file` | `filePath` |
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
**XPath Attributes:** `name`, `width`, `height`, `x`, `y`, `visible`, `opacity`, `cornerRadius`, `fontSize`, `fontFamily`, `fontWeight`, `layoutMode`, `itemSpacing`, `paddingTop`, `paddingRight`, `paddingBottom`, `paddingLeft`, `strokeWeight`, `rotation`, `locked`, `blendMode`, `text`, `lineHeight`, `letterSpacing`

### 3. Create Operations

| Tool | Arguments |
|------|-----------|
| `create_shape` | `type, x, y, width, height, name` |
| `render` | `jsx, parent_id?, x?, y?` |
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
**Layout directions:** `HORIZONTAL`, `VERTICAL`
**Layout align:** `MIN`, `CENTER`, `MAX`, `SPACE_BETWEEN`
**Counter align:** `MIN`, `CENTER`, `MAX`, `STRETCH`
**Blend modes:** `NORMAL`, `DARKEN`, `MULTIPLY`, `COLOR_BURN`, `LIGHTEN`, `SCREEN`, `COLOR_DODGE`, `OVERLAY`, `SOFT_LIGHT`, `HARD_LIGHT`, `DIFFERENCE`, `EXCLUSION`, `HUE`, `SATURATION`, `COLOR`, `LUMINOSITY`

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
**Bind fields:** `fills`, `strokes`, `opacity`, `width`, `height`...

### 9. Analysis Tools

| Tool | Arguments | Returns |
|------|-----------|---------|
| `analyze_colors` | `limit?, show_similar?, threshold?` | Palette with frequencies, similar clusters |
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

**Directions:** `top`, `right`, `bottom`, `left`

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

### 15. Codegen

| Tool | Arguments | Returns |
|------|-----------|---------|
| `get_codegen_prompt` | — | Code generation guidelines |
| `export_nodes` | `nodeIds?` | Raw PenNode data |
| `get_design_prompt` | `section?` | Design knowledge |
| `design_to_tokens` | `format: css|tailwind|json, collection?, type?` | Token definitions |
| `design_to_component_map` | `page?` | Component decomposition |

**Design prompt sections:** `all`, `schema`, `layout`, `roles`, `text`, `style`, `icons`, `examples`, `guidelines`, `planning`
**Token formats:** `css`, `tailwind`, `json`

### 16. Layered Design Workflow

Three-step workflow: **skeleton → content → refine**

**Step 1:** `design_skeleton`
```
rootFrame: {name, width, height, layout, gap?, padding?, fill?}
sections: [{name, height, layout, role?, justifyContent?, alignItems?, gap?, padding?, fill?}]
styleGuide?: {palette?, fonts?, aesthetic?}
```

**Step 2:** `design_content`
```
sectionId, children: [{type, role?, content?, fontSize?, fontWeight?, fill?}], postProcess?
```

**Step 3:** `design_refine`
```
rootId
```
Applies: role resolution, card equalization, overflow fixes, text height, icon resolution, layout sanitization.

### 17. Utilities

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

**Calc functions:** `+`, `-`, `*`, `/`, `%`, `**`, `(`, `)`, `min`, `max`, `floor`, `ceil`, `round`, `abs`, `sqrt`, `pow`

## Quick Reference Patterns

**Create card:** `render: {jsx: "<Frame name='Card' w={320} h='hug' flex='col' gap={16} p={24} bg='#FFF' rounded={12}><Text size={18} weight='bold'>Title</Text><Text size={14} fill='#666'>Description</Text></Frame>"}`

**Find buttons:** `query_nodes: {selector: "//FRAME[@name='Button']"}`

**Export:** `export_image: {format: "PNG", scale: 2}`

**Set spacing:** `set_layout: {id, spacing: 16, padding: 24}`

---

*Generated for OpenPencil (https://github.com/open-pencil/open-pencil) - MCP Server: `open-pencil`*
