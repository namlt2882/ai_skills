# Design System

## 1. Typography

### Font Families
- Display/Headings: Space Grotesk
- Body: Inter
- CJK: Noto Sans SC / Noto Sans JP / Noto Sans KR

### Type Scale
| Style | Size | Weight | Letter Spacing | Line Height |
|-------|------|--------|----------------|-------------|
| Display | 40-56px | 700 | -1.5 | 1.1 |
| Heading | 28-36px | 700 | -0.5 | 1.2 |
| Subheading | 20-24px | 600 | -0.25 | 1.3 |
| Body | 15-18px | 400 | 0 | 1.5 |
| Caption | 13-14px | 400 | 0 | 1.4 |

### CJK Adjustments
- Line height: ≥ 1.3
- Letter spacing: 0 (never negative)

## 2. Colors

### Light Theme
```
Primary:        #6366F1 (Indigo)
Secondary:      #8B5CF6 (Purple)
Background:     #FFFFFF
Surface:        #F9FAFB
Border:         #E5E7EB
Text Primary:   #111111
Text Secondary: #6B7280
Text Subtle:    #9CA3AF
```

### Dark Theme
```
Primary:        #818CF8
Background:     #0F172A
Surface:        #1E293B
Border:         #334155
Text Primary:   #F9FAFB
Text Secondary: #CBD5E1
```

### Usage Rules
- Maximum 2 saturated colors per design
- WCAG AA contrast: 4.5:1 for body, 3:1 for large text
- Never use pure black (#000000) — use #111111 or #0F172A

## 3. Variables & Themes

### Color Variables
Store colors as variables in `.fig`/`.pen` files:
```json
{
  "variables": {
    "Primary": { "type": "COLOR", "value": "#6366F1" },
    "Background": { "type": "COLOR", "value": "#FFFFFF" },
    "Surface": { "type": "COLOR", "value": "#F9FAFB" }
  }
}
```

### Theme Collections
Create theme collections for multi-mode designs:
```json
{
  "collections": {
    "Color Scheme": {
      "modes": ["Light", "Dark"],
      "variables": {
        "Primary": { "Light": "#6366F1", "Dark": "#818CF8" },
        "Background": { "Light": "#FFFFFF", "Dark": "#0F172A" }
      }
    }
  }
}
```

### Variable Binding
Bind variables to node properties using `open-pencil` MCP:
```json
{
  "bindings": {
    "fills": "Primary",
    "opacity": "Opacity-Variable"
  }
}
```

## 4. Spacing

### 8px Grid System
```
Related elements:    8-16px
Component internal:  16-24px
Between components:  24-32px
Between sections:    48-80px
Page padding:        80px
```

### Common Values
- Card padding: 24px
- Button padding: [12, 24]
- Section padding: 80px vertical
- Grid gap: 24px

## 5. Components

### Button
```json
{
  "role": "button",
  "padding": [12, 24],
  "cornerRadius": 8,
  "layout": "horizontal",
  "justifyContent": "center",
  "alignItems": "center",
  "fill": [{ "type": "solid", "color": "#111111" }]
}
```

### Card
```json
{
  "role": "card",
  "padding": 24,
  "gap": 12,
  "cornerRadius": 12,
  "fill": [{ "type": "solid", "color": "#F9FAFB" }]
}
```

### Navbar
```json
{
  "role": "navbar",
  "height": 72,
  "layout": "horizontal",
  "padding": [0, 80],
  "justifyContent": "space_between",
  "alignItems": "center"
}
```

### Form Input
```json
{
  "role": "form-input",
  "height": 48,
  "cornerRadius": 10,
  "padding": [0, 16],
  "fill": [{ "type": "solid", "color": "#F9FAFB" }],
  "stroke": { "thickness": 1, "fill": [{ "type": "solid", "color": "#E5E7EB" }] }
}
```

## 6. Shadows

### Subtle (cards, list items)
```json
{ "type": "shadow", "offsetY": 1, "blur": 3, "color": "rgba(0,0,0,0.05)" }
```

### Medium (dropdowns, tooltips)
```json
{ "type": "shadow", "offsetY": 4, "blur": 12, "color": "rgba(0,0,0,0.08)" }
```

### Elevated (modals, overlays)
```json
{ "type": "shadow", "offsetY": 8, "blur": 24, "spread": -4, "color": "rgba(0,0,0,0.12)" }
```

## 7. Design Notes for Generation

When generating designs with OpenPencil via `open-pencil` MCP:

1. **Always use semantic roles** — `role: "button"`, `role: "card"`, `role: "navbar"`
2. **Include icon names** — Use PascalCase with "Icon" suffix (e.g., `name: "ZapIcon"`)
3. **Set textGrowth** — Use `"fixed-width"` for body text to enable wrapping
4. **Siblings same width** — All siblings in a row must use same width strategy
5. **No x/y in layout containers** — The engine positions children automatically
6. **Use variables for theming** — Store colors/spacing in variables for multi-mode support

### Icon Reference
Common Lucide icons (auto-resolved by post-processing):
- Navigation: `HomeIcon`, `MenuIcon`, `SearchIcon`, `UserIcon`, `SettingsIcon`
- Actions: `PlusIcon`, `DownloadIcon`, `PlayIcon`, `EditIcon`, `TrashIcon`
- Status: `CheckIcon`, `XIcon`, `AlertCircleIcon`, `InfoIcon`
- Arrows: `ArrowRightIcon`, `ChevronRightIcon`, `ChevronDownIcon`
- Features: `ZapIcon`, `ShieldIcon`, `LockIcon`, `GlobeIcon`, `LayersIcon`

## 8. File Formats

### `.fig` Format
Figma-compatible format with full variable/theme support. Use for designs that need:
- Multiple color modes (Light/Dark)
- Shared design tokens
- Theme switching

### `.pen` Format
OpenPencil native format. Use for:
- Simple designs without theming
- Quick prototypes
- Export/import workflows

### Accessing Files
Use `open-pencil` MCP tools to read and modify `.fig`/`.pen` files:
- `open_file` — Open a file
- `get_variables` — Read design variables
- `set_variables` — Update design variables
- `set_themes` — Manage theme collections
