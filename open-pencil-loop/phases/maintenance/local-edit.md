---
name: local-edit
description: Design modification engine for updating existing nodes via OpenPencil MCP
trigger: null
priority: 0
budget: 2000
category: base
---

# Design Modification Engine

Update existing design nodes based on user instructions.

## Tools

| Tool | Use | Args |
|------|-----|------|
| `update_node` | Any property change | `nodeId, data: {...}` |
| `set_fill` | Background/fill color | `id, color` or `gradient, color, color_end` |
| `set_stroke` | Borders | `id, color, weight, align` |
| `set_layout` | Auto-layout config | `id, direction, spacing, padding, align, counterAlign` |
| `set_text` | Text content | `id, text` |
| `set_font` | Typography | `id, family, size, style` |
| `set_text_properties` | Text layout | `id, align_horizontal, align_vertical, auto_resize` |
| `set_effects` | Shadows/blurs | `id, type, color, radius, offset_x/y, spread` |
| `set_radius` | Corner radius | `id, radius` or individual corners |
| `set_opacity` | Transparency | `id, value` (0-1) |
| `set_visible` | Show/hide | `id, value` |

## Examples

```javascript
// Update node properties
update_node({ nodeId: "btn-id", data: { width: 320, cornerRadius: 8 }})

// Solid fill
set_fill({ id: "frame-id", color: "#3B82F6" })

// Gradient fill
set_fill({ id: "frame-id", gradient: "top-bottom", color: "#3B82F6", color_end: "#1D4ED8" })

// Border
set_stroke({ id: "frame-id", color: "#E5E7EB", weight: 1, align: "INSIDE" })

// Auto-layout
set_layout({ id: "frame-id", direction: "VERTICAL", spacing: 12, padding: 16, align: "MIN", counterAlign: "STRETCH" })

// Text content
set_text({ id: "text-id", text: "New label" })

// Typography
set_font({ id: "text-id", family: "Inter", size: 16, style: "SemiBold" })

// Drop shadow
set_effects({ id: "card-id", type: "DROP_SHADOW", color: "#00000020", radius: 8, offset_x: 0, offset_y: 4, spread: 0 })

// Background blur
set_effects({ id: "frame-id", type: "BACKGROUND_BLUR", radius: 12 })

// Corner radius (all)
set_radius({ id: "frame-id", radius: 12 })

// Individual corners
set_radius({ id: "frame-id", top_left: 12, top_right: 12, bottom_right: 0, bottom_left: 0 })

// Opacity
set_opacity({ id: "node-id", value: 0.8 })

// Visibility
set_visible({ id: "node-id", value: false })
```

## Workflow

1. **Get nodes** if not provided: `batch_get: {patterns: [{name: "Button"}]}`
2. **Identify targets** from user instruction
3. **Apply changes** with appropriate tool
4. **Verify** by getting updated node

## Rules
- **PRESERVE IDs** - always reference existing node IDs
- **PARTIAL UPDATES** - update only specified properties
- **DO NOT CHANGE UNRELATED PROPS** - don't modify position unless requested
- **DESIGN VARIABLES** - prefer variable refs over hardcoded values
- **LAYOUT SAFETY** - ensure children won't be clipped after changes

## Common Patterns

**Make button primary:**
```javascript
set_fill({ id: "button-id", color: "#3B82F6" })
set_fill({ id: "button-text-id", color: "#FFFFFF" })
set_stroke({ id: "button-id", color: "#3B82F6", weight: 0 })
```

**Add shadow to card:**
```javascript
set_effects({ id: "card-id", type: "DROP_SHADOW", color: "#00000020", radius: 16, offset_x: 0, offset_y: 8 })
```

**Update typography:**
```javascript
set_font({ id: "heading-id", size: 24, weight: 700 })
update_node({ nodeId: "heading-id", data: { lineHeight: 32 }})
```