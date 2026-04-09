---
name: lint-check
description: Design lint integration for OpenPencil (https://github.com/open-pencil/open-pencil)
trigger: null
priority: 0
budget: 2000
category: base
---

# Design Lint Validator

## CLI (Lint only available via CLI, not MCP)

```bash
openpencil lint path/to/design.fig              # Full lint
openpencil lint path/to/design.fig --fix         # Auto-fix
openpencil lint path/to/design.fig --rules spacing,typography,color  # Specific rules
openpencil lint path/to/design.fig --format json # JSON output
```

## Lint Rules Categories

### Spacing
- **grid-alignment** - All positions/sizes align to 8px grid
- **consistent-padding** - Sibling frames use consistent padding
- **consistent-gap** - Sibling containers use consistent gap
- **minimum-touch-target** - Interactive elements ≥ 44x44px

### Typography
- **font-family-limits** - Max 2 font families per document
- **font-size-scale** - Sizes follow scale (12,14,16,18,20,24,32,48)
- **line-height-ratio** - Line height 1.2-1.6x font size
- **contrast-ratio** - Text minimum 4.5:1 contrast

### Color
- **color-count** - Max unique colors (< 12 recommended)
- **similar-colors** - Flags nearly identical colors
- **variable-usage** - Use design variables not hardcoded
- **brand-compliance** - Colors match brand palette

### Layout
- **frame-nesting** - Avoid > 5 levels deep
- **auto-layout-usage** - Use auto-layout for dynamic content
- **absolute-positioning** - Flag excessive absolute positioning
- **scrollable-content** - Ensure scrollable areas have bounds

### Naming
- **descriptive-names** - No "Frame 123"
- **component-naming** - Follow naming conventions
- **variant-naming** - Consistent variant patterns

### Assets
- **image-optimization** - Flag oversized images
- **vector-preference** - Prefer vectors for icons
- **icon-consistency** - Same icon set throughout

## Workflow

1. Run lint: `openpencil lint path/to/file.fig --format json`
2. Analyze by category and severity
3. Prioritize: errors before warnings, layout before cosmetic
4. Apply fixes using `update_node` for props, `batch_update` for multiple
5. Re-run lint to verify

## Fix Examples

```javascript
// Spacing - inconsistent padding
update_node({ nodeId: "card-id", data: { padding: { top: 16, right: 16, bottom: 16, left: 16 } }})

// Spacing - gap alignment
update_node({ nodeId: "parent-id", data: { spacing: 16 }})

// Typography - font size to scale
set_font({ id: "text-id", size: 16, weight: 400 })

// Color - hardcoded to variable
bind_variable({ node_id: "frame-id", variable_id: "var-primary", field: "fills" })

// Layout - enable auto-layout
set_layout({ id: "frame-id", direction: "VERTICAL", spacing: 12, padding: 16 })
```