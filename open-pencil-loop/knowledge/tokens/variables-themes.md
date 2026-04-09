# Variables and Themes Management

OpenPencil v2 supports powerful variable systems with multi-mode values (light/dark themes) and theme presets. This guide covers creating, managing, and binding variables to build flexible design systems.

## Overview

Variables in OpenPencil are typed values that can be bound to node properties. They support multiple modes (like light/dark themes) and can be organized into collections. Theme presets (.optheme files) allow sharing variables across documents.

## Inspecting Existing Variables

### List All Collections

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "list_collections"
}
```

Returns all variable collections in the document.

### List All Variables

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "list_variables",
  "arguments": {
    "type": "COLOR"
  }
}
```

**Parameters:**
- `type`: Filter by "COLOR", "FLOAT", "STRING", or "BOOLEAN" (optional)

### Get Variable Details

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "get_variable",
  "arguments": {
    "id": "var-001"
  }
}
```

### Find Variables by Name

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "find_variables",
  "arguments": {
    "query": "primary",
    "type": "COLOR"
  }
}
```

## Creating Variable Collections

Collections organize related variables (e.g., "Colors", "Spacing", "Typography").

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "create_collection",
  "arguments": {
    "name": "Semantic Colors"
  }
}
```

**Returns:** Collection ID for use when creating variables.

## Creating Variables

### Color Variables

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "create_variable",
  "arguments": {
    "collection_id": "col-001",
    "name": "primary",
    "type": "COLOR",
    "value": "#3B82F6"
  }
}
```

### Float Variables (Spacing, Sizes)

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "create_variable",
  "arguments": {
    "collection_id": "col-002",
    "name": "spacing-md",
    "type": "FLOAT",
    "value": "16"
  }
}
```

### String Variables

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "create_variable",
  "arguments": {
    "collection_id": "col-003",
    "name": "font-heading",
    "type": "STRING",
    "value": "Inter"
  }
}
```

### Boolean Variables

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "create_variable",
  "arguments": {
    "collection_id": "col-004",
    "name": "use-animations",
    "type": "BOOLEAN",
    "value": "true"
  }
}
```

## Setting Mode-Specific Values

Variables can have different values per mode (e.g., light vs dark theme).

### Get Available Modes

First, get the collection to see its modes:

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "get_collection",
  "arguments": {
    "id": "col-001"
  }
}
```

### Set Value for Specific Mode

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "set_variable",
  "arguments": {
    "id": "var-001",
    "mode": "mode-light",
    "value": "#FFFFFF"
  }
}
```

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "set_variable",
  "arguments": {
    "id": "var-001",
    "mode": "mode-dark",
    "value": "#1A1A1A"
  }
}
```

**Common mode patterns:**
- Light/Dark: `mode-light`, `mode-dark`
- Density: `mode-compact`, `mode-comfortable`
- Brand: `mode-brand-a`, `mode-brand-b`

## Binding Variables to Nodes

Bind variables to node properties so changes propagate automatically.

### Bind to Fill

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "bind_variable",
  "arguments": {
    "node_id": "node-123",
    "variable_id": "var-001",
    "field": "fills"
  }
}
```

### Bind to Stroke

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "bind_variable",
  "arguments": {
    "node_id": "node-123",
    "variable_id": "var-002",
    "field": "strokes"
  }
}
```

### Bind to Size

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "bind_variable",
  "arguments": {
    "node_id": "node-123",
    "variable_id": "var-spacing-md",
    "field": "width"
  }
}
```

### Bind to Opacity

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "bind_variable",
  "arguments": {
    "node_id": "node-123",
    "variable_id": "var-opacity",
    "field": "opacity"
  }
}
```

**Bindable fields:** `fills`, `strokes`, `opacity`, `width`, `height`, `cornerRadius`, `strokeWeight`

## Managing Themes

### Set Theme Axes

Define theme axes with their variants (creates the mode structure):

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "set_themes",
  "arguments": {
    "themes": {
      "Color Scheme": ["Light", "Dark"],
      "Density": ["Compact", "Comfortable"],
      "Brand": ["Default", "Alternative"]
    },
    "replace": false
  }
}
```

**Parameters:**
- `themes`: Object mapping axis names to variant arrays
- `replace`: If true, replaces all existing themes (default: false, merges)

This creates mode combinations like:
- Light + Compact + Default
- Light + Compact + Alternative
- Dark + Comfortable + Default
- etc.

### Get Current Design.md

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "get_design_md"
}
```

Returns the current design system spec including themes and variables.

### Export Design.md

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "export_design_md"
}
```

Exports themes and variables as markdown for documentation.

## Theme Presets

Theme presets (.optheme files) are reusable packages of variables and themes.

### Save Theme Preset

Export current document's themes and variables to a .optheme file:

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "save_theme_preset",
  "arguments": {
    "presetPath": "/path/to/my-theme.optheme",
    "name": "My Brand Theme"
  }
}
```

### Load Theme Preset

Import a .optheme file into the current document:

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "load_theme_preset",
  "arguments": {
    "presetPath": "/path/to/my-theme.optheme"
  }
}
```

### List Available Presets

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "list_theme_presets",
  "arguments": {
    "directory": "/path/to/presets/"
  }
}
```

## Complete Workflow Example

### 1. Create a Design System from Scratch

```bash
# Create collections
mcp open-pencil create_collection --name "Primitive Colors"
mcp open-pencil create_collection --name "Semantic Colors"
mcp open-pencil create_collection --name "Spacing"

# Set up theme axes
mcp open-pencil set_themes --themes '{"Color Scheme": ["Light", "Dark"]}'
```

### 2. Create Variables with Mode Support

```bash
# Primitive colors (single value)
mcp open-pencil create_variable --collection_id col-prim --name "blue-500" --type COLOR --value "#3B82F6"
mcp open-pencil create_variable --collection_id col-prim --name "gray-900" --type COLOR --value "#1A1A1A"

# Semantic colors (light/dark modes)
mcp open-pencil create_variable --collection_id col-sem --name "background" --type COLOR --value "#FFFFFF"
mcp open-pencil set_variable --id var-bg --mode mode-dark --value "#1A1A1A"

mcp open-pencil create_variable --collection_id col-sem --name "text-primary" --type COLOR --value "#1A1A1A"
mcp open-pencil set_variable --id var-text --mode mode-dark --value "#FFFFFF"
```

### 3. Bind Variables to Design Elements

```bash
# Bind background color to frame
mcp open-pencil bind_variable --node_id frame-001 --variable_id var-bg --field fills

# Bind text color to heading
mcp open-pencil bind_variable --node_id heading-001 --variable_id var-text --field fills
```

### 4. Export and Share

```bash
# Save as preset
mcp open-pencil save_theme_preset --presetPath ./brand-theme.optheme --name "Brand Theme v1"

# Export as CSS
mcp open-pencil design_to_tokens --format css

# Export as Tailwind config
mcp open-pencil design_to_tokens --format tailwind
```

## Best Practices

1. **Organize into collections** — Separate primitives (blue-500, gray-900) from semantic tokens (background, text-primary)

2. **Name consistently** — Use kebab-case: `color-primary`, `spacing-lg`, `font-heading`

3. **Limit theme axes** — 2-3 axes is manageable; more creates exponential mode combinations

4. **Bind at component level** — Bind variables to component instances, not every leaf node

5. **Export presets for sharing** — Use .optheme files to share themes across team members

6. **Document with design.md** — Use `export_design_md` to generate documentation

## Common Patterns

### Light/Dark Toggle

```json
{
  "set_themes": {
    "themes": { "Color Scheme": ["Light", "Dark"] }
  }
}
```

Then set mode-specific values for surface, text, and border colors.

### Density Modes

```json
{
  "set_themes": {
    "themes": {
      "Color Scheme": ["Light", "Dark"],
      "Density": ["Compact", "Comfortable"]
    }
  }
}
```

Use density to control padding and gap values.

### Brand Variants

```json
{
  "set_themes": {
    "themes": {
      "Brand": ["Default", "Corporate", "Playful"]
    }
  }
}
```

Swap primary colors and font families per brand.

## Variable Lifecycle

| Action | Tool |
|--------|------|
| Create collection | `create_collection` |
| Create variable | `create_variable` |
| Update value | `set_variable` |
| Bind to node | `bind_variable` |
| Delete variable | `delete_variable` |
| Delete collection | `delete_collection` |
| Export preset | `save_theme_preset` |
| Import preset | `load_theme_preset` |
