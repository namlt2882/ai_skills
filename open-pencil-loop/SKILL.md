---
name: open-pencil-loop
description: |
  Orchestrator for OpenPencil v2 design workflows. Use for creating, editing, and managing
  design documents with the OpenPencil desktop app. Triggers on: open-pencil, .fig, .pen,
  design system, component library, multi-page design, batch design, JSX rendering,
  design tokens, design-to-code.
  
  MCP: open-pencil (hyphenated). Desktop app must be running.
version: "2.0.0"
---

# OpenPencil v2 Skill Orchestrator

The definitive workflow guide for OpenPencil v2 — a design tool with MCP integration
for programmatic design creation and management.

## Architecture Overview

```
Claude Code ←MCP→ open-pencil server ←WebSocket RPC→ Desktop App
                                        ↓
                                    .fig/.pen files
```

**Key v2 Differences from v1:**
- MCP name: `open-pencil` (hyphenated, not `openpencil`)
- File formats: `.fig` and `.pen` (not `.op`)
- Rendering: JSX format (replaces PenNode JSON)
- CLI: `open-pencil` (replaces `op`)

## When to Use This Skill

Use the OpenPencil v2 skill when:

1. Creating new design documents (.fig or .pen files)
2. Building multi-page design systems or component libraries
3. Generating designs programmatically from specifications
4. Editing existing designs via MCP tools
5. Extracting design tokens (colors, typography, spacing)
6. Converting designs to code (React, CSS, etc.)
7. Performing batch operations across design files
8. Linting designs for consistency

## Prerequisites

### 1. Desktop App Running
The OpenPencil desktop application must be running. MCP commands will fail
if the app is not active.

### 2. MCP Configuration
Ensure your Claude Code settings include the open-pencil MCP server:

```json
{
  "mcpServers": {
    "open-pencil": {
      "command": "npx",
      "args": ["-y", "@opencode/open-pencil-mcp@latest"]
    }
  }
}
```

## Pre-Flight Check

**ALWAYS verify desktop app connectivity before any MCP operation:**

```bash
# Check if the desktop app is responsive
open-pencil ping

# Or verify via MCP (list available operations)
# If this fails, the desktop app is not running
```

If the desktop app is not running:
1. Ask the user to start OpenPencil
2. Wait for confirmation
3. Retry the MCP operation

## Task Management

Track your progress through the design workflow:

| Phase | Task | Status | Notes |
|-------|------|--------|-------|
| 1 | Pre-flight check | [ ] | Verify desktop app running |
| 2 | Open/create document | [ ] | Use .fig or .pen format |
| 3 | Build structure | [ ] | Skeleton → sections → content |
| 4 | Apply design tokens | [ ] | Variables, themes, colors |
| 5 | Refine and validate | [ ] | Lint, analyze, fix issues |
| 6 | Export deliverables | [ ] | Images, SVG, code |
| 7 | Save and close | [ ] | Explicit save required |

## Decision Workflow

For each operation, classify the decision:

| Level | Criteria | Action |
|-------|----------|--------|
| **Critical** | Destructive operations (delete, replace), file overwrites, major structural changes | STOP → Ask user explicitly |
| **Medium** | Style changes, layout adjustments, adding new elements | PROCEED → Inform user |
| **Automatic** | Read operations, analysis, exports, non-destructive queries | PROCEED → No notification |

## Phase Workflow Summary

### Phase 1: Document Setup
1. Run pre-flight check (desktop app running?)
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
1. **Explicitly save the file** (v2 does not auto-save)
2. Verify save was successful
3. Close or continue to next page

## Complete MCP Tool Reference

### File Operations

**CRITICAL: v2 does not auto-save. Always save explicitly using the desktop app menu (Ctrl+S / Cmd+S).**

### Page Operations

#### List Pages
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: list_pages
```

#### Add Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: add_page
  arguments:
    name: "Mobile View"
```

#### Switch Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: switch_page
  arguments:
    page: "Mobile View"  # Name or ID
```

#### Duplicate Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: duplicate_page
  arguments:
    pageId: "page-id-here"
    name: "Mobile View Copy"
```

#### Remove Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: remove_page
  arguments:
    pageId: "page-uuid"
```

#### Rename Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: rename_page
  arguments:
    pageId: "page-uuid"
    name: "New Page Name"
```

#### Reorder Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: reorder_page
  arguments:
    pageId: "page-uuid"
    index: 0
```

#### Get Current Page
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_current_page
```

### Node Discovery

#### Get Page Tree
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_page_tree
```

#### Get Node by ID
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_node
  arguments:
    id: "0:1"
    depth: 2  # Optional: limit child recursion
```

#### Find Nodes by Name/Type
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: find_nodes
  arguments:
    name: "Button"  # Substring match
    type: "FRAME"   # Optional: FRAME, TEXT, RECTANGLE, etc.
```

#### Query Nodes with XPath
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: query_nodes
  arguments:
    selector: "//FRAME[@width < 300]"
    limit: 50
```

**XPath Examples:**
- `//FRAME` — all frames
- `//FRAME[@width < 300]` — frames narrower than 300px
- `//TEXT[contains(@text, 'Hello')]` — text nodes containing "Hello"
- `//SECTION//TEXT` — all text nodes inside sections

### JSX Rendering (v2 Format)

**Primary method for creating design content.**

```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: render
  arguments:
    jsx: |
      <Frame name="Card" w={320} h="hug" layout="vertical" gap={16} p={24} bg="#FFF" rounded={16}>
        <Text name="Title" size={18} weight="bold" color="#111">
          Card Title
        </Text>
        <Text name="Body" size={14} color="#666" lineHeight={1.5}>
          Card description text goes here.
        </Text>
        <Frame name="Actions" layout="horizontal" gap={8} justify="end">
          <Frame name="Button" w={100} h={40} bg="#007AFF" rounded={8} center>
            <Text size={14} weight="medium" color="#FFF">Save</Text>
          </Frame>
        </Frame>
      </Frame>
    parent_id: "0:1"  # Optional: render into specific container
    x: 100            # Optional: X position
    y: 100            # Optional: Y position
```

**JSX Props Reference:**

| Prop | Type | Description |
|------|------|-------------|
| `w` | number, "hug", "fill" | Width |
| `h` | number, "hug", "fill" | Height |
| `layout` | "vertical", "horizontal", "none" | Auto-layout direction |
| `gap` | number | Space between children |
| `p` | number | Padding (all sides) |
| `px`, `py` | number | Horizontal/vertical padding |
| `pt`, `pr`, `pb`, `pl` | number | Individual padding |
| `justify` | "start", "center", "end", "between" | Main axis alignment |
| `align` | "start", "center", "end", "stretch" | Cross axis alignment |
| `bg` | string | Background color (hex) |
| `rounded` | number | Corner radius |
| `name` | string | Layer name |
| `role` | string | Semantic role (button, card, heading, etc.) |

### Node Operations

#### Create Shape
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: create_shape
  arguments:
    type: "FRAME"  # FRAME, RECTANGLE, ELLIPSE, TEXT, LINE, etc.
    x: 100
    y: 100
    width: 200
    height: 100
    name: "My Shape"
```

#### Insert Node (Full PenNode)
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: insert_node
  arguments:
    parent: "0:10"  # null for root
    data:
      type: "frame"
      name: "Container"
      width: 400
      height: 300
      layout: "vertical"
      gap: 16
    postProcess: true
```

#### Create Component
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: create_component
  arguments:
    id: "0:5"
```

#### Create Instance
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: create_instance
  arguments:
    component_id: "comp-123"
    x: 200
    y: 200
```

#### Update Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: update_node
  arguments:
    nodeId: "0:5"
    data:
      name: "Updated Name"
      width: 300
      opacity: 0.9
```

#### Delete Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: delete_node
  arguments:
    nodeId: "0:5"
```

#### Clone Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: clone_node
  arguments:
    id: "0:5"
```

#### Reparent Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: reparent_node
  arguments:
    id: "0:5"
    parent_id: "0:10"
```

### Styling Operations

#### Set Fill
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_fill
  arguments:
    id: "0:5"
    color: "#FF5733"
    # For gradients:
    # gradient: "top-bottom"
    # color_end: "#33FF57"
```

#### Set Stroke
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_stroke
  arguments:
    id: "0:5"
    color: "#000000"
    weight: 2
    align: "INSIDE"  # INSIDE, CENTER, OUTSIDE
```

#### Set Layout
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_layout
  arguments:
    id: "0:5"
    direction: "VERTICAL"  # HORIZONTAL, VERTICAL
    spacing: 16
    padding: 24
    align: "CENTER"
    counter_align: "STRETCH"
```

#### Set Text Content
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_text
  arguments:
    id: "0:5"
    text: "New text content"
```

#### Set Font
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_font
  arguments:
    id: "0:5"
    family: "Inter"
    size: 16
    style: "Bold"
```

#### Set Effects
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_effects
  arguments:
    id: "0:5"
    type: "DROP_SHADOW"
    color: "#000000"
    offset_x: 0
    offset_y: 4
    radius: 8
    spread: 0
```

#### Set Opacity
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_opacity
  arguments:
    id: "0:5"
    value: 0.8  # 0-1
```

#### Set Visibility
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_visible
  arguments:
    id: "0:5"
    value: false
```

#### Set Locked
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_locked
  arguments:
    id: "0:5"
    value: true
```

#### Set Rotation
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_rotation
  arguments:
    id: "0:5"
    angle: 45
```

#### Set Constraints
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_constraints
  arguments:
    id: "0:5"
    horizontal: "STRETCH"  # MIN, CENTER, MAX, STRETCH, SCALE
    vertical: "CENTER"
```

#### Set Min/Max
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_minmax
  arguments:
    id: "0:5"
    min_width: 200
    max_width: 600
    min_height: 100
    max_height: 400
```

#### Set Text Resize
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_text_resize
  arguments:
    id: "0:5"
    mode: "WIDTH_AND_HEIGHT"  # NONE, WIDTH_AND_HEIGHT, HEIGHT, TRUNCATE
```

#### Set Text Properties
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_text_properties
  arguments:
    id: "0:5"
    align_horizontal: "CENTER"  # LEFT, CENTER, RIGHT, JUSTIFIED
    align_vertical: "CENTER"  # TOP, CENTER, BOTTOM
    text_decoration: "UNDERLINE"  # NONE, UNDERLINE, STRIKETHROUGH
```

#### Set Blend Mode
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_blend
  arguments:
    id: "0:5"
    mode: "MULTIPLY"  # NORMAL, DARKEN, MULTIPLY, etc.
```

#### Set Stroke Align
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_stroke_align
  arguments:
    id: "0:5"
    align: "OUTSIDE"  # INSIDE, CENTER, OUTSIDE
```

#### Set Corner Radius
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_radius
  arguments:
    id: "0:5"
    radius: 12
    top_left: 8
    top_right: 16
    bottom_left: 16
    bottom_right: 8
```

#### Set Image Fill
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_image_fill
  arguments:
    id: "0:5"
    image_data: "base64encoded..."
    scale_mode: "FILL"  # FILL, FIT, CROP, TILE
```

### Structure Operations

#### Move Node (Coordinates)
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_move
  arguments:
    id: "0:5"
    x: 200
    y: 300
```

#### Resize Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_resize
  arguments:
    id: "0:5"
    width: 400
    height: 300
```

#### Rename Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: rename_node
  arguments:
    id: "0:5"
    name: "Hero Section"
```

#### Group Nodes
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: group_nodes
  arguments:
    ids: ["0:5", "0:6", "0:7"]
```

#### Ungroup Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: ungroup_node
  arguments:
    id: "0:5"
```

#### Flatten Nodes
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: flatten_nodes
  arguments:
    ids: ["0:5", "0:6"]
```

#### Convert to Component
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_to_component
  arguments:
    ids: ["0:5", "0:6"]
```

#### Copy Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: copy_node
  arguments:
    sourceId: "0:5"
    parent: "0:10"
    overrides:
      x: 100
      y: 100
```

### Boolean Operations

Combine multiple shapes into complex vectors:

```yaml
# Union (combine)
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: boolean_union
  arguments:
    ids: ["0:5", "0:6", "0:7"]

# Subtract (first minus rest)
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: boolean_subtract
  arguments:
    ids: ["0:5", "0:6"]

# Intersect
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: boolean_intersect
  arguments:
    ids: ["0:5", "0:6"]

# Exclude (XOR)
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: boolean_exclude
  arguments:
    ids: ["0:5", "0:6"]
```

### Export Operations

#### Export as Image
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: export_image
  arguments:
    ids: ["0:5", "0:6"]  # Omit for all top-level nodes
    format: "PNG"  # PNG, JPG, WEBP
    scale: 2
```

#### Export as SVG
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: export_svg
  arguments:
    ids: ["0:5"]  # Omit for all top-level nodes
```

### Analysis Tools (Design Tokens)

#### Analyze Colors
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: analyze_colors
  arguments:
    limit: 30
    show_similar: true
    threshold: 15
```

Returns: Color palette with frequencies, variable bindings, similar color clusters.

#### Analyze Typography
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: analyze_typography
  arguments:
    limit: 30
    group_by: "family"  # family, size, weight
```

#### Analyze Spacing
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: analyze_spacing
  arguments:
    grid: 8  # Base grid size to check
```

#### Find Clusters (Repeated Patterns)
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: analyze_clusters
  arguments:
    min_count: 2
    min_size: 30
    limit: 20
```

### Design Variables

#### List Variables
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: list_variables
  arguments:
    type: "COLOR"  # Optional: COLOR, FLOAT, STRING, BOOLEAN
```

#### Create Variable
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: create_variable
  arguments:
    collection_id: "coll-id"
    name: "Primary Blue"
    type: "COLOR"
    value: "#007AFF"
```

#### Set Variable Value
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_variable
  arguments:
    id: "var-id"
    mode: "mode-id"
    value: "#007AFF"
```

#### Bind Variable to Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: bind_variable
  arguments:
    node_id: "0:5"
    variable_id: "var-id"
    field: "fills"  # fills, strokes, opacity, width, height, etc.
```

#### Get Variable
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_variable
  arguments:
    id: "var-id"
```

#### Find Variables
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: find_variables
  arguments:
    query: "primary"
    type: "COLOR"  # Optional: COLOR, FLOAT, STRING, BOOLEAN
```

#### Create Collection
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: create_collection
  arguments:
    name: "Brand Colors"
```

#### Get Collection
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_collection
  arguments:
    id: "coll-id"
```

#### List Collections
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: list_collections
```

#### Delete Variable
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: delete_variable
  arguments:
    id: "var-id"
```

#### Delete Collection
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: delete_collection
  arguments:
    id: "coll-id"
```

### Themes

#### Set Themes
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_themes
  arguments:
    themes:
      Color: ["Light", "Dark"]
      Density: ["Compact", "Comfortable"]
```

### Design System

#### Get Design MD
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_design_md
```

#### Set Design MD
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_design_md
  arguments:
    markdown: |
      # Design System
      
      ## Colors
      - Primary: #007AFF
      - Secondary: #5856D6
      
      ## Typography
      - Heading: Inter Bold 24px
      - Body: Inter Regular 16px
```

#### Export Design MD
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: export_design_md
```

### Import/Export

#### Import SVG
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: import_svg
  arguments:
    svgPath: "/path/to/icon.svg"
    parent: "0:1"  # Optional
    maxDim: 400
```

#### Export Nodes as Data
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: export_nodes
  arguments:
    nodeIds: ["0:5", "0:6"]  # Omit for all
```

### Layout Utilities

#### Snapshot Layout
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: snapshot_layout
  arguments:
    maxDepth: 2
    parentId: "0:1"  # Optional
```

#### Find Empty Space
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: find_empty_space
  arguments:
    direction: "right"  # top, right, bottom, left
    width: 400
    height: 300
    padding: 50
    nodeId: "0:5"  # Optional: search relative to node
```

#### Page Bounds
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: page_bounds
```

#### Viewport Get
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: viewport_get
```

#### Viewport Set
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: viewport_set
  arguments:
    x: 600
    y: 400
    zoom: 1.5
```

#### Zoom to Fit
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: viewport_zoom_to_fit
  arguments:
    ids: ["0:5", "0:6"]
```

#### List Fonts
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: list_fonts
  arguments:
    family: "Inter"  # Optional filter
```

#### Select Nodes
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: select_nodes
  arguments:
    ids: ["0:5", "0:6"]
```

#### Arrange Nodes
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: arrange
  arguments:
    mode: "grid"  # grid, row, column
    cols: 3
    gap: 40
    ids: ["0:5", "0:6", "0:7"]
```

#### Calculator
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: calc
  arguments:
    expr: ["1440 * 8 / 12", "(952 - 16) / 2", "floor(390 * 0.6)"]
```

### Node Analysis

#### Get Node Bounds
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_bounds
  arguments:
    id: "0:5"
```

#### Get Node Tree
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_tree
  arguments:
    id: "0:5"
    depth: 3
```

#### Get Node Ancestors
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_ancestors
  arguments:
    id: "0:5"
    depth: 5
```

#### Get Node Children
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_children
  arguments:
    id: "0:5"
```

#### Get Node Bindings
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: node_bindings
  arguments:
    id: "0:5"
```

#### Describe Node
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: describe
  arguments:
    id: "0:5"
    depth: 3
    grid: 8
```

#### Diff JSX
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: diff_jsx
  arguments:
    from: "0:5"
    to: "0:6"
```

### Theme Presets

#### Save Theme Preset
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: save_theme_preset
  arguments:
    presetPath: "/path/to/theme.optheme"
    name: "My Theme"
```

#### Load Theme Preset
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: load_theme_preset
  arguments:
    presetPath: "/path/to/theme.optheme"
```

#### List Theme Presets
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: list_theme_presets
  arguments:
    directory: "/path/to/presets/"
```

### Code Generation

#### Get Codegen Prompt
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_codegen_prompt
```

Returns guidelines for generating frontend code from designs.

#### Get Design Prompt
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_design_prompt
  arguments:
    section: "planning"  # all, schema, layout, roles, text, style, icons, examples, guidelines, planning
```

#### Extract Design Tokens
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: design_to_tokens
  arguments:
    format: "css"  # css, tailwind, json
    collection: "Brand"
    type: "COLOR"
```

#### Get Component Map
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: design_to_component_map
  arguments:
    page: "Components"
```

### Layered Design Workflow

Three-step workflow for systematic design generation:

#### Step 1: Design Skeleton
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: design_skeleton
  arguments:
    rootFrame:
      name: "Landing Page"
      width: 1200
      height: 0
      layout: "vertical"
    sections:
      - name: "Hero"
        height: 600
        layout: "vertical"
        role: "hero"
    styleGuide:
      palette:
        primary: "#007AFF"
      fonts:
        heading: "Inter"
        body: "Inter"
```

Returns section IDs for use in step 2.

#### Step 2: Design Content
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: design_content
  arguments:
    sectionId: "section-uuid"
    children:
      - type: "text"
        role: "heading"
        content: "Welcome"
    postProcess: true
```

#### Step 3: Design Refine
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: design_refine
  arguments:
    rootId: "root-uuid"
```

Applies: role resolution, card row equalization, overflow fixes, text height estimation, icon resolution, layout sanitization.

## CLI Reference

The `open-pencil` CLI provides command-line access to design operations:

```bash
# File operations
open-pencil tree <file.fig>              # Show document structure
open-pencil find <file.fig> "pattern"    # Find nodes by name
open-pencil node <file.fig> <id>         # Get node details
open-pencil query <file.fig> "selector"  # XPath query

# Export
open-pencil export <file.fig> --format png --output ./exports/
open-pencil convert <file.fig> --to react --output ./components/

# Analysis
open-pencil lint <file.fig>              # Check design consistency
open-pencil analyze <file.fig>           # Full analysis report

# Variables
open-pencil variables <file.fig>         # List design variables

# Evaluation (JSX)
open-pencil eval <file.fig> '<Frame w={100} h={100} bg="#FFF"/>'
```

**Note:** CLI commands work offline on saved files. MCP requires desktop app.

## File Management

### Save Discipline

**CRITICAL: OpenPencil v2 does NOT auto-save.**

Always follow this pattern:

1. **After significant changes:** Save explicitly
2. **Before exports:** Save to ensure latest state
3. **After batch operations:** Save before closing

```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: save_file
  arguments:
    filePath: "/path/to/design.fig"
```

### File Formats

| Format | Extension | Description |
|--------|-----------|-------------|
| Figma-compatible | `.fig` | Primary format, supports all features |
| OpenPencil native | `.pen` | Compact format, OpenPencil-specific |
| Theme preset | `.optheme` | Reusable theme + variables |

**Use `.fig` for:** Sharing with Figma users, maximum compatibility
**Use `.pen` for:** Smaller file size, OpenPencil-only workflows

## Multi-Page Parallel Build Workflow

For building multiple pages simultaneously:

### Approach 1: Sequential with Shared Components

1. Create base components on Page 1
2. Convert to components (reusable)
3. Create additional pages
4. Reference base components on each page

## Complete Loop Example

Here's a complete workflow from start to finish:

```yaml
# 1. Pre-flight check
- Run: open-pencil ping
- If fails: Ask user to start desktop app

# 2. Open or create document
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: open_file
  arguments:
    filePath: "/path/to/design.fig"

# 3. Create page structure
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: render
  arguments:
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

# 4. Get page tree to find node IDs
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: get_page_tree

# 5. Update specific node
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_fill
  arguments:
    id: "0:3"  # Hero section ID from tree
    color: "#007AFF"

# 6. Analyze design
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: analyze_colors

# 7. Export preview
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: export_image
  arguments:
    format: "PNG"
    scale: 2

# 8. CRITICAL: Save file
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: save_file
  arguments:
    filePath: "/path/to/design.fig"
```

## MCP Limitations

| Limitation | Description | Workaround |
|------------|-------------|------------|
| Desktop app required | MCP cannot function without desktop app | Always run pre-flight check |
| No auto-save | Changes are not persisted automatically | Explicit save_file calls |
| Single user | Only one MCP connection at a time | Coordinate access |
| No real-time sync | Changes from UI not immediately visible | Re-query after UI edits |
| WebSocket dependency | Network issues break connection | Retry with exponential backoff |

## Common Patterns

### Creating a Button Component

```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: render
  arguments:
    jsx: |
      <Frame name="Button" w="hug" h={40} px={16} bg="#007AFF" rounded={8} center role="button">
        <Text size={14} weight="medium" color="#FFF">Click Me</Text>
      </Frame>
```

### Creating a Card with Shadow

```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: render
  arguments:
    jsx: |
      <Frame name="Card" w={320} h="hug" p={24} bg="#FFF" rounded={16}>
        <Text name="Title" size={18} weight="bold" mb={8}>Card Title</Text>
        <Text name="Body" size={14} color="#666">Card content</Text>
      </Frame>
# Then apply shadow
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_effects
  arguments:
    id: "card-id"
    type: "DROP_SHADOW"
    color: "#00000020"
    offset_x: 0
    offset_y: 4
    radius: 12
```

### Responsive Layout

```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: render
  arguments:
    jsx: |
      <Frame name="Container" w={1200} h="hug" layout="horizontal" gap={16} wrap>
        <Frame w={384} h={200} bg="#F5F5F5" rounded={8} />
        <Frame w={384} h={200} bg="#F5F5F5" rounded={8} />
        <Frame w={384} h={200} bg="#F5F5F5" rounded={8} />
      </Frame>
```

## Troubleshooting

### Desktop App Not Responding
```bash
# Check if app is running
open-pencil ping

# If no response:
# 1. Ask user to verify OpenPencil is open
# 2. Check WebSocket port (default: 8080)
# 3. Restart desktop app
```

### MCP Tool Failures
- Verify MCP config uses `"open-pencil"` (hyphenated)
- Check desktop app is running before MCP calls
- Retry with delay if WebSocket times out

### Export Issues
- Ensure nodes exist (use get_page_tree to verify IDs)
- Check file permissions for output directory
- For SVG export, verify shapes are vector-compatible

## References

- MCP Tool Index: See `reference/mcp-tool-index.md`
- v1 Skill (for comparison): `~/.config/opencode/skills/openpencil-loop/SKILL.md`
- CLI Help: `open-pencil --help`
