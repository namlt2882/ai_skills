---
name: boolean-ops
description: Boolean vector operations for OpenPencil v2
phase: [generation]
trigger: null
priority: 5
budget: 1000
category: base
---

# Boolean Vector Operations for OpenPencil v2

Boolean operations combine multiple vector shapes (rectangles, ellipses, paths) into new shapes using set operations.

## Available Operations

### 1. Union (`boolean_union`)

Combines multiple shapes into one unified shape.

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_union",
  arguments: {
    ids: ["shape-1", "shape-2", "shape-3"]
  }
})
```

**Use cases:**
- Merge overlapping shapes into a single silhouette
- Create complex forms from simple primitives
- Combine multiple icon parts

**Example:**
```jsx
// Two overlapping circles become one merged shape
<Frame>
  <Ellipse id="circle1" w={100} h={100} x={0} y={0} />
  <Ellipse id="circle2" w={100} h={100} x={50} y={0} />
</Frame>
// After union: merged shape covering both circles
```

### 2. Subtract (`boolean_subtract`)

Removes the area of subsequent shapes from the first shape.

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_subtract",
  arguments: {
    ids: ["base-shape", "cutout-1", "cutout-2"]  // First minus the rest
  }
})
```

**Use cases:**
- Create cutout effects (holes, notches)
- Punch out shapes from backgrounds
- Create stencil-like designs
- Make donut/circular progress shapes

**Example:**
```jsx
// Rectangle with circular cutout
<Frame>
  <Rectangle id="card" w={200} h={100} bg="#3B82F6" />
  <Ellipse id="hole" w={40} h={40} x={80} y={30} />
</Frame>
// After subtract: blue card with transparent circle in center
```

### 3. Intersect (`boolean_intersect`)

Keeps only the overlapping area of all shapes.

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_intersect",
  arguments: {
    ids: ["shape-a", "shape-b", "shape-c"]
  }
})
```

**Use cases:**
- Create complex clipping masks
- Extract overlapping regions
- Design Venn diagram intersections
- Create unique geometric patterns

**Example:**
```jsx
// Two overlapping circles - keep only the overlap
<Frame>
  <Ellipse id="left" w={100} h={100} x={0} y={0} bg="#EF4444" />
  <Ellipse id="right" w={100} h={100} x={50} y={0} bg="#3B82F6" />
</Frame>
// After intersect: lens-shaped overlap area
```

### 4. Exclude (XOR) (`boolean_exclude`)

Keeps only the non-overlapping areas (symmetric difference).

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_exclude",
  arguments: {
    ids: ["shape-1", "shape-2"]
  }
})
```

**Use cases:**
- Create puzzle-piece effects
- Design complex borders
- Generate unique shapes from overlaps
- Boolean XOR for pattern creation

**Example:**
```jsx
// Two overlapping circles - remove overlap, keep unique parts
<Frame>
  <Ellipse id="left" w={100} h={100} x={0} y={0} />
  <Ellipse id="right" w={100} h={100} x={50} y={0} />
</Frame>
// After exclude: two crescents (lens removed)
```

## Operation Reference

| Operation | Result | Visual |
|-----------|--------|--------|
| **Union** | All areas combined | A ∪ B |
| **Subtract** | First minus others | A - B |
| **Intersect** | Only overlapping | A ∩ B |
| **Exclude** | Non-overlapping only | (A - B) ∪ (B - A) |

## Workflow Steps

1. **Create base shapes** - Position overlapping rectangles, ellipses, or paths
2. **Select shapes** - Note the IDs of shapes to combine
3. **Apply operation** - Call the appropriate boolean MCP tool
4. **Result** - Original shapes replaced with new combined shape

## Common Patterns

### Donut / Ring Shape
```javascript
// Large circle minus small circle
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_subtract",
  arguments: { ids: ["outer-circle", "inner-circle"] }
})
```

### Rounded Tab / Notch
```javascript
// Rectangle minus semicircle at top edge
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_subtract",
  arguments: { ids: ["base-rect", "notch-semi"] }
})
```

### Intersecting Banners
```javascript
// Two diagonal rectangles intersecting
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_intersect",
  arguments: { ids: ["diag-1", "diag-2"] }
})
```

### Complex Icon Merge
```javascript
// Multiple icon parts merged
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "boolean_union",
  arguments: { ids: ["icon-base", "icon-detail-1", "icon-detail-2"] }
})
```

## Important Notes

- **Order matters** for subtract operations (first shape is the base)
- **Result replaces** the selected shapes with the new boolean shape
- **Fill/stroke** properties come from the first shape in the list
- **Complex operations** can be chained: union then subtract, etc.

## Limitations

- All shapes must be vector-based (rectangles, ellipses, paths)
- Cannot boolean with frames, text, or images
- Result is a single vector path
- Original shapes are consumed in the operation
