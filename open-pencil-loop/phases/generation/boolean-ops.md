---
name: boolean-ops
description: Boolean vector operations for OpenPencil (https://github.com/open-pencil/open-pencil)
phase: [generation]
trigger: null
priority: 5
budget: 1000
category: base
---

# Boolean Vector Operations

## Operations

| Operation | Result | Tool |
|-----------|--------|------|
| **Union** | All areas combined (A ∪ B) | `boolean_union` |
| **Subtract** | First minus others (A - B) | `boolean_subtract` |
| **Intersect** | Only overlapping area (A ∩ B) | `boolean_intersect` |
| **Exclude** | Non-overlapping only (XOR) | `boolean_exclude` |

## MCP Usage

```javascript
// Union - merge shapes
skill_mcp({ mcp_name: "open-pencil", tool_name: "boolean_union", arguments: { ids: ["a", "b", "c"] }})

// Subtract - first minus rest (order matters!)
skill_mcp({ mcp_name: "open-pencil", tool_name: "boolean_subtract", arguments: { ids: ["base", "cutout"] }})

// Intersect - keep only overlap
skill_mcp({ mcp_name: "open-pencil", tool_name: "boolean_intersect", arguments: { ids: ["a", "b"] }})

// Exclude - remove overlap, keep unique parts
skill_mcp({ mcp_name: "open-pencil", tool_name: "boolean_exclude", arguments: { ids: ["a", "b"] }})
```

## Common Patterns

**Donut/Ring:** Subtract small circle from large circle
**Notch/Tab:** Subtract semicircle from rectangle top edge
**Puzzle pieces:** Exclude two overlapping rectangles
**Clipping mask:** Intersect two overlapping shapes
**Icon merge:** Union multiple icon parts

## Notes
- Order matters for subtract (first shape = base)
- Result replaces selected shapes
- Fill/stroke from first shape in list
- Only vector shapes (rect, ellipse, path), not frames/text/images
- Original shapes consumed in operation