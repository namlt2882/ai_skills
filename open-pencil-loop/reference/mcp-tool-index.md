# OpenPencil v2 MCP Tool Index

Complete reference for all 90+ MCP tools in the OpenPencil v2 design system.

**MCP Server Name:** `open-pencil` (with hyphen)

---

## Table of Contents

1. [Document Operations](#1-document-operations)
2. [Read Operations](#2-read-operations)
3. [Create Operations](#3-create-operations)
4. [Modify Operations](#4-modify-operations)
5. [Structure Operations](#5-structure-operations)
6. [Boolean Operations](#6-boolean-operations)
7. [Export Operations](#7-export-operations)
8. [Variables & Themes](#8-variables--themes)
9. [Analysis Tools](#9-analysis-tools)
10. [Page Operations](#10-page-operations)
11. [Design MD](#11-design-md)
12. [Layout Analysis](#12-layout-analysis)
13. [Theme Presets](#13-theme-presets)
14. [File Management](#14-file-management)
15. [Codegen](#15-codegen)
16. [Layered Design Workflow](#16-layered-design-workflow)
17. [Utilities](#17-utilities)

---

## JSX Render Format (v2)

OpenPencil v2 uses JSX-style rendering. Property mappings from shorthand to full:

| Shorthand | Full Property | Example |
|-----------|---------------|---------|
| `w` | `width` | `w={320}` |
| `h` | `height` | `h={200}` or `h="hug"` |
| `flex` | `layout` | `flex="col"` or `flex="row"` |
| `p` | `padding` | `p={24}` |
| `bg` | `fill` | `bg="#FFF"` or `bg="#000000"` |
| `gap` | `itemSpacing` | `gap={16}` |
| `rounded` | `cornerRadius` | `rounded={12}` |

**Example JSX:**
```jsx
<Frame name="Card" w={320} h={200} flex="col" gap={16} p={24} bg="#FFF" rounded={12}>
  <Text size={18} weight="bold">Title</Text>
  <Text size={14} fill="#666">Description</Text>
</Frame>
```

---

## 1. Document Operations

### `open_file`
Open an existing .op file or connect to the live Electron canvas.

```json
{
  "tool_name": "open_file",
  "arguments": {
    "filePath": "/path/to/design.fig"
  }
}
```

**Note:** Omit `filePath` to connect to the live canvas.

---

### `save_file`
Save the current document to disk.

```json
{
  "tool_name": "save_file",
  "arguments": {
    "filePath": "/path/to/design.fig"
  }
}
```

---

### `new_document`
Create a new blank document.

```json
{
  "tool_name": "new_document",
  "arguments": {}
}
```

---

## 2. Read Operations

### `get_page_tree`
Get the node tree of the current page. Returns lightweight hierarchy.

```json
{
  "tool_name": "get_page_tree",
  "arguments": {}
}
```

---

### `get_node`
Get detailed properties of a node by ID.

```json
{
  "tool_name": "get_node",
  "arguments": {
    "id": "123:456",
    "depth": 2
  }
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `id` | string | Node ID |
| `depth` | number | Max depth of children to include (0 = node only) |

---

### `find_nodes`
Find nodes by name pattern and/or type.

```json
{
  "tool_name": "find_nodes",
  "arguments": {
    "name": "button",
    "type": "FRAME"
  }
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `name` | string | Name substring to match (case-insensitive) |
| `type` | enum | `FRAME`, `RECTANGLE`, `ELLIPSE`, `TEXT`, `LINE`, `STAR`, `POLYGON`, `SECTION`, `GROUP`, `COMPONENT`, `INSTANCE`, `VECTOR` |

---

### `query_nodes`
Query nodes using XPath selectors. Most powerful selection tool.

```json
{
  "tool_name": "query_nodes",
  "arguments": {
    "selector": "//FRAME[@width < 300]",
    "limit": 50
  }
}
```

#### XPath Query Examples

| Selector | Description |
|----------|-------------|
| `//FRAME` | All frames |
| `//FRAME[@width < 300]` | Frames narrower than 300px |
| `//COMPONENT[starts-with(@name, 'Button')]` | Components starting with "Button" |
| `//SECTION/FRAME` | Direct frame children of sections |
| `//SECTION//TEXT` | All text nodes inside sections |
| `//*[@cornerRadius > 0]` | Any node with corner radius |
| `//TEXT[contains(@text, 'Hello')]` | Text nodes containing "Hello" |
| `//FRAME[@opacity < 1]` | Semi-transparent frames |
| `//TEXT[@fontSize > 16]` | Large text elements |

**Available Attributes:** `name`, `width`, `height`, `x`, `y`, `visible`, `opacity`, `cornerRadius`, `fontSize`, `fontFamily`, `fontWeight`, `layoutMode`, `itemSpacing`, `paddingTop`, `paddingRight`, `paddingBottom`, `paddingLeft`, `strokeWeight`, `rotation`, `locked`, `blendMode`, `text`, `lineHeight`, `letterSpacing`

---

### `get_selection`
Get the currently selected nodes on the live canvas.

```json
{
  "tool_name": "get_selection",
  "arguments": {
    "readDepth": 2
  }
}
```

---

### `get_components`
List all components in the document.

```json
{
  "tool_name": "get_components",
  "arguments": {
    "name": "Button",
    "limit": 50
  }
}
```

---

### `list_pages`
List all pages in the document.

```json
{
  "tool_name": "list_pages",
  "arguments": {}
}
```

---

### `list_variables`
List all design variables (colors, numbers, strings, booleans).

```json
{
  "tool_name": "list_variables",
  "arguments": {
    "type": "COLOR"
  }
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `type` | enum | Filter by `COLOR`, `FLOAT`, `STRING`, `BOOLEAN` |

---

### `get_current_page`
Get the current page name and ID.

```json
{
  "tool_name": "get_current_page",
  "arguments": {}
}
```

---

### `batch_get`
Search and read nodes in one call. Returns nodes with children truncated.

```json
{
  "tool_name": "batch_get",
  "arguments": {
    "patterns": [{"type": "FRAME", "name": "Card"}],
    "readDepth": 2,
    "searchDepth": 5
  }
}
```

---

## 3. Create Operations

### `create_shape`
Create a basic shape on the canvas.

```json
{
  "tool_name": "create_shape",
  "arguments": {
    "type": "FRAME",
    "x": 100,
    "y": 100,
    "width": 320,
    "height": 200,
    "name": "Card Container"
  }
}
```

**Types:** `FRAME`, `RECTANGLE`, `ELLIPSE`, `TEXT`, `LINE`, `STAR`, `POLYGON`, `SECTION`

---

### `render` (JSX)
Render JSX to design nodes. Primary creation method in v2.

```json
{
  "tool_name": "render",
  "arguments": {
    "jsx": "<Frame name=\"Card\" w={320} h={200} flex=\"col\" gap={16} p={24} bg=\"#FFF\" rounded={12}><Text size={18} weight=\"bold\">Title</Text></Frame>",
    "parent_id": "123:456",
    "x": 100,
    "y": 100
  }
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `jsx` | string | JSX string to render |
| `parent_id` | string | Parent node ID (omit for root) |
| `replace_id` | string | Node ID to replace |
| `x`, `y` | number | Position of root node |

**Full JSX Example:**
```jsx
<Frame name="Hero" w={1200} h={600} flex="col" gap={24} p={48} bg="#1a1a1a" rounded={0}>
  <Text size={48} weight="bold" fill="#ffffff">Headline</Text>
  <Text size={18} fill="#cccccc">Subheadline text here</Text>
  <Frame w={200} h={48} bg="#007AFF" rounded={8} flex="col" align="center">
    <Text size={16} weight="medium" fill="#ffffff">Get Started</Text>
  </Frame>
</Frame>
```

---

### `insert_node`
Insert a new node with full PenNode data structure.

```json
{
  "tool_name": "insert_node",
  "arguments": {
    "parent": "123:456",
    "data": {
      "type": "frame",
      "name": "Container",
      "width": 400,
      "height": 300,
      "layout": "vertical",
      "gap": 16,
      "padding": {"top": 24, "right": 24, "bottom": 24, "left": 24},
      "fill": [{"type": "solid", "color": "#FFFFFF"}]
    },
    "postProcess": true
  }
}
```

---

### `create_component`
Convert a frame/group into a reusable component.

```json
{
  "tool_name": "create_component",
  "arguments": {
    "id": "123:456"
  }
}
```

---

### `create_instance`
Create an instance of a component.

```json
{
  "tool_name": "create_instance",
  "arguments": {
    "component_id": "789:012",
    "x": 200,
    "y": 200
  }
}
```

---

## 4. Modify Operations

### `update_node`
Update properties of an existing node.

```json
{
  "tool_name": "update_node",
  "arguments": {
    "nodeId": "123:456",
    "data": {
      "name": "Updated Card",
      "width": 400,
      "height": 250,
      "fill": [{"type": "solid", "color": "#F5F5F5"}]
    }
  }
}
```

---

### `set_fill`
Set the fill color or gradient on a node.

```json
{
  "tool_name": "set_fill",
  "arguments": {
    "id": "123:456",
    "color": "#FF5733",
    "gradient": "top-bottom",
    "color_end": "#33FF57"
  }
}
```

**Gradient directions:** `top-bottom`, `bottom-top`, `left-right`, `right-left`

---

### `set_stroke`
Set the stroke (border) of a node.

```json
{
  "tool_name": "set_stroke",
  "arguments": {
    "id": "123:456",
    "color": "#000000",
    "weight": 2,
    "align": "INSIDE"
  }
}
```

**Align options:** `INSIDE`, `CENTER`, `OUTSIDE`

---

### `set_layout`
Set auto-layout (flexbox) on a frame.

```json
{
  "tool_name": "set_layout",
  "arguments": {
    "id": "123:456",
    "direction": "VERTICAL",
    "align": "CENTER",
    "counter_align": "STRETCH",
    "spacing": 16,
    "padding": 24,
    "padding_horizontal": 32,
    "padding_vertical": 16
  }
}
```

| Parameter | Type | Description |
|-----------|------|-------------|
| `direction` | enum | `HORIZONTAL`, `VERTICAL` |
| `align` | enum | `MIN`, `CENTER`, `MAX`, `SPACE_BETWEEN` |
| `counter_align` | enum | `MIN`, `CENTER`, `MAX`, `STRETCH` |
| `spacing` | number | Gap between items |
| `padding` | number | Equal padding on all sides |
| `padding_horizontal` | number | Left/right padding |
| `padding_vertical` | number | Top/bottom padding |

---

### `set_text`
Set text content of a text node.

```json
{
  "tool_name": "set_text",
  "arguments": {
    "id": "123:456",
    "text": "New content here"
  }
}
```

---

### `set_font`
Set font properties of a text node.

```json
{
  "tool_name": "set_font",
  "arguments": {
    "id": "123:456",
    "family": "Inter",
    "size": 16,
    "style": "Bold"
  }
}
```

---

### `set_effects`
Set effects on a node (drop shadow, inner shadow, blur).

```json
{
  "tool_name": "set_effects",
  "arguments": {
    "id": "123:456",
    "type": "DROP_SHADOW",
    "color": "#000000",
    "offset_x": 0,
    "offset_y": 4,
    "radius": 8,
    "spread": 0
  }
}
```

**Effect types:** `DROP_SHADOW`, `INNER_SHADOW`, `FOREGROUND_BLUR`, `BACKGROUND_BLUR`

---

### `set_opacity`
Set opacity of a node (0-1).

```json
{
  "tool_name": "set_opacity",
  "arguments": {
    "id": "123:456",
    "value": 0.8
  }
}
```

---

### `set_visible`
Set visibility of a node.

```json
{
  "tool_name": "set_visible",
  "arguments": {
    "id": "123:456",
    "value": false
  }
}
```

---

### `set_locked`
Set locked state of a node.

```json
{
  "tool_name": "set_locked",
  "arguments": {
    "id": "123:456",
    "value": true
  }
}
```

---

### `set_rotation`
Set rotation angle of a node in degrees.

```json
{
  "tool_name": "set_rotation",
  "arguments": {
    "id": "123:456",
    "angle": 45
  }
}
```

---

### `set_constraints`
Set resize constraints for a node within its parent.

```json
{
  "tool_name": "set_constraints",
  "arguments": {
    "id": "123:456",
    "horizontal": "STRETCH",
    "vertical": "CENTER"
  }
}
```

**Constraint options:** `MIN`, `CENTER`, `MAX`, `STRETCH`, `SCALE`

---

### `set_minmax`
Set min/max width and height constraints on a node.

```json
{
  "tool_name": "set_minmax",
  "arguments": {
    "id": "123:456",
    "min_width": 200,
    "max_width": 600,
    "min_height": 100,
    "max_height": 400
  }
}
```

---

### `set_text_resize`
Set text auto-resize mode.

```json
{
  "tool_name": "set_text_resize",
  "arguments": {
    "id": "123:456",
    "mode": "WIDTH_AND_HEIGHT"
  }
}
```

**Modes:** `NONE`, `WIDTH_AND_HEIGHT`, `HEIGHT`, `TRUNCATE`

---

### `set_text_properties`
Set text layout properties.

```json
{
  "tool_name": "set_text_properties",
  "arguments": {
    "id": "123:456",
    "align_horizontal": "CENTER",
    "align_vertical": "CENTER",
    "auto_resize": "HEIGHT",
    "direction": "LTR",
    "text_decoration": "UNDERLINE"
  }
}
```

| Parameter | Options |
|-----------|---------|
| `align_horizontal` | `LEFT`, `CENTER`, `RIGHT`, `JUSTIFIED` |
| `align_vertical` | `TOP`, `CENTER`, `BOTTOM` |
| `text_decoration` | `NONE`, `UNDERLINE`, `STRIKETHROUGH` |

---

### `set_blend`
Set blend mode of a node.

```json
{
  "tool_name": "set_blend",
  "arguments": {
    "id": "123:456",
    "mode": "MULTIPLY"
  }
}
```

**Blend modes:** `NORMAL`, `DARKEN`, `MULTIPLY`, `COLOR_BURN`, `LIGHTEN`, `SCREEN`, `COLOR_DODGE`, `OVERLAY`, `SOFT_LIGHT`, `HARD_LIGHT`, `DIFFERENCE`, `EXCLUSION`, `HUE`, `SATURATION`, `COLOR`, `LUMINOSITY`

---

### `set_stroke_align`
Set stroke alignment of a node.

```json
{
  "tool_name": "set_stroke_align",
  "arguments": {
    "id": "123:456",
    "align": "OUTSIDE"
  }
}
```

---

### `set_radius`
Set corner radius (supports individual corners).

```json
{
  "tool_name": "set_radius",
  "arguments": {
    "id": "123:456",
    "radius": 12,
    "top_left": 8,
    "top_right": 16,
    "bottom_left": 16,
    "bottom_right": 8
  }
}
```

---

### `set_image_fill`
Set an image fill on a node from base64-encoded image data.

```json
{
  "tool_name": "set_image_fill",
  "arguments": {
    "id": "123:456",
    "image_data": "base64encodedstring...",
    "scale_mode": "FILL"
  }
}
```

**Scale modes:** `FILL`, `FIT`, `CROP`, `TILE`

---

## 5. Structure Operations

### `delete_node`
Delete a node and all its children.

```json
{
  "tool_name": "delete_node",
  "arguments": {
    "nodeId": "123:456"
  }
}
```

---

### `clone_node`
Duplicate a node.

```json
{
  "tool_name": "clone_node",
  "arguments": {
    "id": "123:456"
  }
}
```

---

### `copy_node`
Deep-copy a node and insert the clone under a parent.

```json
{
  "tool_name": "copy_node",
  "arguments": {
    "sourceId": "123:456",
    "parent": "789:012",
    "overrides": {"x": 100, "y": 100}
  }
}
```

---

### `reparent_node`
Move a node into a different parent.

```json
{
  "tool_name": "reparent_node",
  "arguments": {
    "id": "123:456",
    "parent_id": "789:012"
  }
}
```

---

### `move_node`
Move a node to a new parent or root level.

```json
{
  "tool_name": "move_node",
  "arguments": {
    "nodeId": "123:456",
    "parent": "789:012",
    "index": 2
  }
}
```

---

### `group_nodes`
Group selected nodes together.

```json
{
  "tool_name": "group_nodes",
  "arguments": {
    "ids": ["123:456", "789:012", "345:678"]
  }
}
```

---

### `ungroup_node`
Ungroup a group node.

```json
{
  "tool_name": "ungroup_node",
  "arguments": {
    "id": "123:456"
  }
}
```

---

### `node_move`
Move a node to new coordinates.

```json
{
  "tool_name": "node_move",
  "arguments": {
    "id": "123:456",
    "x": 200,
    "y": 300
  }
}
```

---

### `node_resize`
Resize a node.

```json
{
  "tool_name": "node_resize",
  "arguments": {
    "id": "123:456",
    "width": 400,
    "height": 300
  }
}
```

---

### `rename_node`
Rename a node in the layers panel.

```json
{
  "tool_name": "rename_node",
  "arguments": {
    "id": "123:456",
    "name": "Hero Section"
  }
}
```

---

### `flatten_nodes`
Flatten nodes into a single vector.

```json
{
  "tool_name": "flatten_nodes",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

### `node_to_component`
Convert one or more frames/groups into components.

```json
{
  "tool_name": "node_to_component",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

## 6. Boolean Operations

### `boolean_union`
Union (combine) multiple nodes into one.

```json
{
  "tool_name": "boolean_union",
  "arguments": {
    "ids": ["123:456", "789:012", "345:678"]
  }
}
```

---

### `boolean_subtract`
Subtract the second node from the first.

```json
{
  "tool_name": "boolean_subtract",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

### `boolean_intersect`
Intersect multiple nodes (keep only overlapping area).

```json
{
  "tool_name": "boolean_intersect",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

### `boolean_exclude`
Exclude (XOR) multiple nodes.

```json
{
  "tool_name": "boolean_exclude",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

## 7. Export Operations

### `export_image`
Export nodes as a raster image (PNG, JPG, WEBP).

```json
{
  "tool_name": "export_image",
  "arguments": {
    "ids": ["123:456"],
    "format": "PNG",
    "scale": 2
  }
}
```

| Parameter | Options |
|-----------|---------|
| `format` | `PNG`, `JPG`, `WEBP` |
| `scale` | 0.1 to 4 (multiplier) |

**Note:** Omit `ids` to export all top-level nodes.

---

### `export_svg`
Export nodes as SVG markup.

```json
{
  "tool_name": "export_svg",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

## 8. Variables & Themes

### `create_variable`
Create a new variable in a collection.

```json
{
  "tool_name": "create_variable",
  "arguments": {
    "collection_id": "col-123",
    "name": "Primary Blue",
    "type": "COLOR",
    "value": "#007AFF"
  }
}
```

**Types:** `COLOR`, `FLOAT`, `STRING`, `BOOLEAN`

---

### `set_variable`
Set the value of a variable for a specific mode.

```json
{
  "tool_name": "set_variable",
  "arguments": {
    "id": "var-123",
    "mode": "mode-dark",
    "value": "#0056B3"
  }
}
```

---

### `bind_variable`
Bind a variable to a node property.

```json
{
  "tool_name": "bind_variable",
  "arguments": {
    "node_id": "123:456",
    "variable_id": "var-123",
    "field": "fills"
  }
}
```

**Fields:** `fills`, `strokes`, `opacity`, `width`, `height`, etc.

---

### `get_variable`
Get a variable by ID.

```json
{
  "tool_name": "get_variable",
  "arguments": {
    "id": "var-123"
  }
}
```

---

### `find_variables`
Find variables by name pattern.

```json
{
  "tool_name": "find_variables",
  "arguments": {
    "query": "primary",
    "type": "COLOR"
  }
}
```

---

### `delete_variable`
Delete a variable.

```json
{
  "tool_name": "delete_variable",
  "arguments": {
    "id": "var-123"
  }
}
```

---

### `create_collection`
Create a new variable collection.

```json
{
  "tool_name": "create_collection",
  "arguments": {
    "name": "Brand Colors"
  }
}
```

---

### `get_collection`
Get a variable collection by ID.

```json
{
  "tool_name": "get_collection",
  "arguments": {
    "id": "col-123"
  }
}
```

---

### `list_collections`
List all variable collections.

```json
{
  "tool_name": "list_collections",
  "arguments": {}
}
```

---

### `delete_collection`
Delete a variable collection and all its variables.

```json
{
  "tool_name": "delete_collection",
  "arguments": {
    "id": "col-123"
  }
}
```

---

### `set_themes`
Create or update theme axes and their variants.

```json
{
  "tool_name": "set_themes",
  "arguments": {
    "themes": {
      "Color": ["Light", "Dark"],
      "Density": ["Compact", "Comfortable"]
    },
    "replace": false
  }
}
```

---

### `get_variables`
Get all design variables and themes.

```json
{
  "tool_name": "get_variables",
  "arguments": {}
}
```

---

### `set_variables`
Add or update design variables.

```json
{
  "tool_name": "set_variables",
  "arguments": {
    "variables": {
      "Primary": {"type": "COLOR", "value": "#007AFF"},
      "Spacing": {"type": "FLOAT", "value": "16"}
    },
    "replace": false
  }
}
```

---

## 9. Analysis Tools

### `analyze_colors`
Analyze color palette usage across the current page.

```json
{
  "tool_name": "analyze_colors",
  "arguments": {
    "limit": 30,
    "show_similar": true,
    "threshold": 15
  }
}
```

| Parameter | Description |
|-----------|-------------|
| `threshold` | Distance threshold for clustering similar colors (0-50) |
| `show_similar` | Include clusters of similar colors |

---

### `analyze_typography`
Analyze typography usage across the current page.

```json
{
  "tool_name": "analyze_typography",
  "arguments": {
    "limit": 30,
    "group_by": "family"
  }
}
```

**Group by:** `family`, `size`, `weight`

---

### `analyze_spacing`
Analyze spacing values (gap, padding) across the current page.

```json
{
  "tool_name": "analyze_spacing",
  "arguments": {
    "grid": 8
  }
}
```

---

### `analyze_clusters`
Find repeated design patterns (potential components).

```json
{
  "tool_name": "analyze_clusters",
  "arguments": {
    "limit": 20,
    "min_count": 2,
    "min_size": 30
  }
}
```

---

## 10. Page Operations

### `add_page`
Add a new page to the document.

```json
{
  "tool_name": "add_page",
  "arguments": {
    "name": "Mobile Views",
    "children": []
  }
}
```

---

### `remove_page`
Remove a page from the document.

```json
{
  "tool_name": "remove_page",
  "arguments": {
    "pageId": "page-123"
  }
}
```

---

### `rename_page`
Rename a page.

```json
{
  "tool_name": "rename_page",
  "arguments": {
    "pageId": "page-123",
    "name": "Desktop Layouts"
  }
}
```

---

### `duplicate_page`
Duplicate a page (deep-clone with new IDs).

```json
{
  "tool_name": "duplicate_page",
  "arguments": {
    "pageId": "page-123",
    "name": "Desktop Layouts Copy"
  }
}
```

---

### `reorder_page`
Move a page to a new position.

```json
{
  "tool_name": "reorder_page",
  "arguments": {
    "pageId": "page-123",
    "index": 0
  }
}
```

---

### `switch_page`
Switch to a different page.

```json
{
  "tool_name": "switch_page",
  "arguments": {
    "page": "Mobile Views"
  }
}
```

---

## 11. Design MD

### `get_design_md`
Get the design.md (design system specification) from the document.

```json
{
  "tool_name": "get_design_md",
  "arguments": {}
}
```

---

### `set_design_md`
Import a design.md into the document.

```json
{
  "tool_name": "set_design_md",
  "arguments": {
    "markdown": "# Design System\n\n## Colors\n- Primary: #007AFF\n...",
    "autoExtract": false
  }
}
```

---

### `export_design_md`
Export the design.md as markdown text.

```json
{
  "tool_name": "export_design_md",
  "arguments": {}
}
```

---

## 12. Layout Analysis

### `snapshot_layout`
Get the hierarchical bounding box layout tree.

```json
{
  "tool_name": "snapshot_layout",
  "arguments": {
    "maxDepth": 2,
    "parentId": "123:456"
  }
}
```

---

### `find_empty_space`
Find empty canvas space in a given direction.

```json
{
  "tool_name": "find_empty_space",
  "arguments": {
    "direction": "right",
    "width": 400,
    "height": 300,
    "padding": 50,
    "nodeId": "123:456"
  }
}
```

**Directions:** `top`, `right`, `bottom`, `left`

---

### `page_bounds`
Get bounding box of all objects on the current page.

```json
{
  "tool_name": "page_bounds",
  "arguments": {}
}
```

---

## 13. Theme Presets

### `save_theme_preset`
Save themes and variables as a reusable .optheme file.

```json
{
  "tool_name": "save_theme_preset",
  "arguments": {
    "presetPath": "/path/to/my-theme.optheme",
    "name": "Corporate Theme"
  }
}
```

---

### `load_theme_preset`
Load a .optheme preset file into the document.

```json
{
  "tool_name": "load_theme_preset",
  "arguments": {
    "presetPath": "/path/to/my-theme.optheme"
  }
}
```

---

### `list_theme_presets`
List all .optheme preset files in a directory.

```json
{
  "tool_name": "list_theme_presets",
  "arguments": {
    "directory": "/path/to/themes/"
  }
}
```

---

## 14. File Management

### `import_svg`
Import a local SVG file as editable PenNodes.

```json
{
  "tool_name": "import_svg",
  "arguments": {
    "svgPath": "/path/to/icon.svg",
    "maxDim": 400,
    "parent": "123:456",
    "postProcess": true
  }
}
```

---

## 15. Codegen

### `get_codegen_prompt`
Get design-to-code generation guidelines.

```json
{
  "tool_name": "get_codegen_prompt",
  "arguments": {}
}
```

---

### `export_nodes`
Export raw PenNode data with design variables and themes.

```json
{
  "tool_name": "export_nodes",
  "arguments": {
    "nodeIds": ["123:456", "789:012"]
  }
}
```

---

### `get_design_prompt`
Get design knowledge prompt for AI generation.

```json
{
  "tool_name": "get_design_prompt",
  "arguments": {
    "section": "planning"
  }
}
```

**Sections:** `all`, `schema`, `layout`, `roles`, `text`, `style`, `icons`, `examples`, `guidelines`, `planning`

---

### `design_to_tokens`
Extract design tokens as CSS, Tailwind, or JSON.

```json
{
  "tool_name": "design_to_tokens",
  "arguments": {
    "format": "css",
    "collection": "Brand",
    "type": "COLOR"
  }
}
```

**Formats:** `css`, `tailwind`, `json`

---

### `design_to_component_map`
Analyze and return structured component decomposition.

```json
{
  "tool_name": "design_to_component_map",
  "arguments": {
    "page": "Components"
  }
}
```

---

## 16. Layered Design Workflow

Three-step workflow for systematic design generation:

### Step 1: `design_skeleton`
Create a layout skeleton with root frame + section frames.

```json
{
  "tool_name": "design_skeleton",
  "arguments": {
    "rootFrame": {
      "name": "Landing Page",
      "width": 1200,
      "height": 0,
      "layout": "vertical",
      "gap": 0,
      "padding": {"top": 0, "right": 0, "bottom": 0, "left": 0},
      "fill": [{"type": "solid", "color": "#FFFFFF"}]
    },
    "sections": [
      {
        "name": "Hero",
        "height": 600,
        "layout": "vertical",
        "role": "hero",
        "justifyContent": "center",
        "alignItems": "center",
        "fill": [{"type": "solid", "color": "#1a1a1a"}]
      },
      {
        "name": "Features",
        "height": 800,
        "layout": "horizontal",
        "role": "features",
        "gap": 32,
        "padding": {"top": 64, "right": 48, "bottom": 64, "left": 48}
      }
    ],
    "styleGuide": {
      "palette": {
        "primary": "#007AFF",
        "background": "#FFFFFF",
        "text": "#1a1a1a"
      },
      "fonts": {
        "heading": "Inter",
        "body": "Inter"
      },
      "aesthetic": "Modern clean design with bold typography"
    }
  }
}
```

Returns section IDs for use in step 2.

---

### Step 2: `design_content`
Populate a section with content nodes.

```json
{
  "tool_name": "design_content",
  "arguments": {
    "sectionId": "section-hero-123",
    "children": [
      {
        "type": "text",
        "role": "heading",
        "content": "Welcome to OpenPencil",
        "fontSize": 48,
        "fontWeight": "bold",
        "fill": [{"type": "solid", "color": "#FFFFFF"}]
      },
      {
        "type": "text",
        "role": "body",
        "content": "Design at the speed of thought",
        "fontSize": 18,
        "fill": [{"type": "solid", "color": "#CCCCCC"}]
      },
      {
        "type": "frame",
        "role": "button",
        "width": 200,
        "height": 48,
        "fill": [{"type": "solid", "color": "#007AFF"}],
        "cornerRadius": 8,
        "children": [
          {
            "type": "text",
            "content": "Get Started",
            "fontSize": 16,
            "fontWeight": "medium",
            "fill": [{"type": "solid", "color": "#FFFFFF"}]
          }
        ]
      }
    ],
    "postProcess": true
  }
}
```

---

### Step 3: `design_refine`
Run full-tree validation and auto-fixes.

```json
{
  "tool_name": "design_refine",
  "arguments": {
    "rootId": "root-frame-123"
  }
}
```

Applies: role resolution, card row equalization, overflow fixes, text height estimation, icon resolution, layout sanitization, clipContent enforcement.

---

## 17. Utilities

### `node_bounds`
Get absolute bounding box of a node.

```json
{
  "tool_name": "node_bounds",
  "arguments": {
    "id": "123:456"
  }
}
```

---

### `node_tree`
Get a node tree with types and hierarchy.

```json
{
  "tool_name": "node_tree",
  "arguments": {
    "id": "123:456",
    "depth": 3
  }
}
```

---

### `node_ancestors`
Get the ancestor chain from a node to the page root.

```json
{
  "tool_name": "node_ancestors",
  "arguments": {
    "id": "123:456",
    "depth": 5
  }
}
```

---

### `node_children`
Get direct children of a node.

```json
{
  "tool_name": "node_children",
  "arguments": {
    "id": "123:456"
  }
}
```

---

### `node_bindings`
Get variable bindings for a node.

```json
{
  "tool_name": "node_bindings",
  "arguments": {
    "id": "123:456"
  }
}
```

---

### `viewport_get`
Get current viewport position and zoom level.

```json
{
  "tool_name": "viewport_get",
  "arguments": {}
}
```

---

### `viewport_set`
Set viewport position and zoom.

```json
{
  "tool_name": "viewport_set",
  "arguments": {
    "x": 600,
    "y": 400,
    "zoom": 1.5
  }
}
```

---

### `viewport_zoom_to_fit`
Zoom viewport to fit specified nodes.

```json
{
  "tool_name": "viewport_zoom_to_fit",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

### `list_fonts`
List fonts used in the current page.

```json
{
  "tool_name": "list_fonts",
  "arguments": {
    "family": "Inter"
  }
}
```

---

### `select_nodes`
Select one or more nodes by ID (for UI feedback).

```json
{
  "tool_name": "select_nodes",
  "arguments": {
    "ids": ["123:456", "789:012"]
  }
}
```

---

### `diff_jsx`
Structural diff between two nodes in JSX format.

```json
{
  "tool_name": "diff_jsx",
  "arguments": {
    "from": "123:456",
    "to": "789:012"
  }
}
```

---

### `diff_create`
Create a structural diff between two node trees.

```json
{
  "tool_name": "diff_create",
  "arguments": {
    "from": "123:456",
    "to": "789:012",
    "depth": 10
  }
}
```

---

### `diff_show`
Preview what would change if properties were applied.

```json
{
  "tool_name": "diff_show",
  "arguments": {
    "id": "123:456",
    "props": "{\"opacity\": 1, \"fill\": \"#FF0000\", \"width\": 200}"
  }
}
```

---

### `describe`
Get semantic description of one or more nodes.

```json
{
  "tool_name": "describe",
  "arguments": {
    "id": "123:456",
    "depth": 3,
    "grid": 8
  }
}
```

---

### `arrange`
Arrange top-level nodes in a grid, row, or column layout.

```json
{
  "tool_name": "arrange",
  "arguments": {
    "mode": "grid",
    "cols": 3,
    "gap": 40,
    "ids": ["123:456", "789:012", "345:678"]
  }
}
```

**Modes:** `grid`, `row`, `column`

---

### `calc`
Arithmetic calculator for design calculations.

```json
{
  "tool_name": "calc",
  "arguments": {
    "expr": "[\"1440 * 8 / 12\", \"(952 - 16) / 2\", \"floor(390 * 0.6)\"]"
  }
}
```

Supports: `+`, `-`, `*`, `/`, `%`, `**`, `(`, `)`, `min`, `max`, `floor`, `ceil`, `round`, `abs`, `sqrt`, `pow`

---

## Quick Reference

### Common Task Patterns

**Create a card component:**
```json
{"tool_name": "render", "arguments": {"jsx": "<Frame name='Card' w={320} h='hug' flex='col' gap={16} p={24} bg='#FFF' rounded={12}><Text size={18} weight='bold'>Title</Text><Text size={14} fill='#666'>Description text</Text></Frame>"}}
```

**Find and update all buttons:**
```json
{"tool_name": "query_nodes", "arguments": {"selector": "//FRAME[@name='Button']"}}
```

**Export current design:**
```json
{"tool_name": "export_image", "arguments": {"format": "PNG", "scale": 2}}
```

**Apply consistent spacing:**
```json
{"tool_name": "set_layout", "arguments": {"id": "123:456", "spacing": 16, "padding": 24}}
```

---

*Generated for OpenPencil v2 - JSX-based design system*
*MCP Server: `open-pencil`*
