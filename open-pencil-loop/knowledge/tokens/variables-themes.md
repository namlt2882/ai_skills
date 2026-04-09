# Variables and Themes Management

OpenPencil (https://github.com/open-pencil/open-pencil) supports typed variables with multi-mode values (light/dark themes) and theme presets (.optheme files).

## Variable Types

`COLOR` · `FLOAT` · `STRING` · `BOOLEAN`

## Inspection Tools

| Tool | Arguments |
|------|-----------|
| `list_collections` | — |
| `list_variables` | `type?: COLOR|FLOAT|STRING|BOOLEAN` |
| `get_variable` | `id` |
| `find_variables` | `query, type?` |
| `get_collection` | `id` |

## Creating

| Tool | Arguments |
|------|-----------|
| `create_collection` | `name` → returns collection ID |
| `create_variable` | `collection_id, name, type, value` |

**Example:** `create_variable: {collection_id: "col-001", name: "primary", type: "COLOR", value: "#3B82F6"}`

## Mode-Specific Values

Variables support different values per mode (light/dark, compact/comfortable, brand variants).

| Tool | Arguments |
|------|-----------|
| `set_variable` | `id, mode, value` |

**Modes:** `mode-light`, `mode-dark`, `mode-compact`, `mode-comfortable`, `mode-brand-a`...

**Example:** `set_variable: {id: "var-bg", mode: "mode-dark", value: "#1A1A1A"}`

## Binding Variables to Nodes

Bind variables to node properties so changes propagate automatically.

| Tool | Arguments |
|------|-----------|
| `bind_variable` | `node_id, variable_id, field` |

**Fields:** `fills`, `strokes`, `opacity`, `width`, `height`, `cornerRadius`, `strokeWeight`

**Example:** `bind_variable: {node_id: "node-123", variable_id: "var-bg", field: "fills"}`

## Themes

### Set Theme Axes

```yaml
set_themes: {themes: {Color Scheme: [Light, Dark], Density: [Compact, Comfortable], Brand: [Default, Alternative]}, replace?: false}
```

Creates mode combinations: Light+Compact+Default, Light+Compact+Alternative, Dark+Comfortable+Default, etc.

### Design MD

| Tool | Arguments |
|------|-----------|
| `get_design_md` | — |
| `export_design_md` | — |

## Theme Presets (.optheme files)

| Tool | Arguments |
|------|-----------|
| `save_theme_preset` | `presetPath, name?` |
| `load_theme_preset` | `presetPath` |
| `list_theme_presets` | `directory` |

## Workflow

**1. Create collections:**
```
create_collection: {name: "Primitive Colors"}
create_collection: {name: "Semantic Colors"}
create_collection: {name: "Spacing"}
set_themes: {themes: {Color Scheme: [Light, Dark]}}
```

**2. Create variables:**
```
create_variable: {collection_id: col-prim, name: "blue-500", type: COLOR, value: "#3B82F6"}
create_variable: {collection_id: col-sem, name: "background", type: COLOR, value: "#FFFFFF"}
set_variable: {id: var-bg, mode: mode-dark, value: "#1A1A1A"}
```

**3. Bind to elements:**
```
bind_variable: {node_id: frame-001, variable_id: var-bg, field: fills}
bind_variable: {node_id: heading-001, variable_id: var-text, field: fills}
```

**4. Export:**
```
save_theme_preset: {presetPath: ./brand-theme.optheme, name: "Brand Theme v1"}
design_to_tokens: {format: css}  # or tailwind, json
```

## Best Practices

1. **Organize into collections** — primitives (blue-500) vs semantic (background, text-primary)
2. **Name consistently** — kebab-case: `color-primary`, `spacing-lg`, `font-heading`
3. **Limit theme axes** — 2-3 axes max; more creates exponential mode combinations
4. **Bind at component level** — bind to instances, not every leaf node
5. **Export presets for sharing** — .optheme files for team sharing
6. **Document with design.md** — use `export_design_md`

## Common Patterns

**Light/Dark Toggle:**
```yaml
set_themes: {themes: {Color Scheme: [Light, Dark]}}
# Then set mode-specific values for surface, text, border colors
```

**Density Modes:**
```yaml
set_themes: {themes: {Color Scheme: [Light, Dark], Density: [Compact, Comfortable]}}
# Use density to control padding and gap values
```

**Brand Variants:**
```yaml
set_themes: {themes: {Brand: [Default, Corporate, Playful]}}
# Swap primary colors and font families per brand
```

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
