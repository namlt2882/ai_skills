---
name: layout-rules
description: Auto-layout rules for frames (layout, gap, padding)
phase: [generation]
trigger: null
priority: 5
budget: 1000
category: base
---

# Layout Rules for OpenPencil (https://github.com/open-pencil/open-pencil)

## Layout Types (flex prop)

| Value | Behavior |
|-------|----------|
| `flex="col"` | Children stack top-to-bottom (vertical) |
| `flex="row"` | Children align left-to-right (horizontal) |
| No flex | Absolute positioning (use x, y) |

## Gap (Spacing Between Children)

```jsx
// Related elements
<Frame flex="col" gap={8}>     {/* Tight spacing */}
<Frame flex="col" gap={12}>    {/* Default spacing */}

// Groups
<Frame flex="col" gap={16}>    {/* Related groups */}
<Frame flex="col" gap={24}>    {/* Section groups */}

// Sections
<Frame flex="col" gap={32}>    {/* Major sections */}
<Frame flex="col" gap={48}>    {/* Page sections */}
```

## Padding

```jsx
// Uniform padding
<Frame p={16}>                 {/* All sides 16px */}
<Frame p={24}>                 {/* All sides 24px */}

// Vertical + Horizontal
<Frame p={[16, 24]}>           {/* 16px vertical, 24px horizontal */}

// Individual sides
<Frame pt={16} pr={24} pb={16} pl={24}>
<Frame px={24} py={16}>        {/* Shorthand for horizontal/vertical */}
```

### Padding Guidelines

| Context | Padding |
|---------|---------|
| Mobile content | 16-24px uniform |
| Desktop sections | [48, 24] or [60, 80] |
| Cards | 20-24px |
| Buttons | [12, 24] (vertical, horizontal) |
| Input fields | [12, 16] |

## Width/Height Strategies

```jsx
// Fixed size
<Frame w={320} h={200}>

// Hug content (size to children)
<Frame w="hug" h="hug">

// Fill container (stretch to parent)
<Frame w="fill" h="fill">
<Frame w="fill" h="hug">      {/* Full width, auto height */}
```

### Rules

- Never nest `fill` inside `hug` - causes layout errors
- Use `h="hug"` for content frames that grow with content
- Use `w="fill"` for full-width sections

## Alignment (justify, align props)

```jsx
// Horizontal alignment in vertical layout (justifyContent)
<Frame flex="col" justify="start">      {/* Align to top */}
<Frame flex="col" justify="center">     {/* Center vertically */}
<Frame flex="col" justify="end">        {/* Align to bottom */}
<Frame flex="col" justify="space-between"> {/* Space between items */}

// Vertical alignment in horizontal layout (alignItems)
<Frame flex="row" align="start">        {/* Align to left */}
<Frame flex="row" align="center">       {/* Center horizontally */}
<Frame flex="row" align="end">          {/* Align to right */}
<Frame flex="row" align="stretch">      {/* Stretch to fill */}
```

## Clip Content

```jsx
// Prevent children from rendering outside bounds
<Frame clipContent={true} rounded={16}>
  <Image w="fill" h={200} src="..." />
</Frame>
```

Use on cards with cornerRadius + image children to clip images to rounded corners.

## MCP Layout Tools

```javascript
// Create layout skeleton
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "design_skeleton",
  arguments: {
    filePath: "path/to/design.fig",
    rootFrame: {
      name: "Page",
      width: 1200,
      height: 0,
      layout: "vertical",
      gap: 0,
      fill: [{ type: "solid", color: "#FFFFFF" }],
      padding: { top: 0, right: 0, bottom: 0, left: 0 }
    },
    sections: [
      {
        name: "Header",
        height: 80,
        layout: "horizontal",
        padding: { left: 48, right: 48 },
        gap: 24,
        role: "header"
      },
      {
        name: "Hero",
        height: 600,
        layout: "vertical",
        padding: { top: 80, bottom: 80, left: 48, right: 48 },
        gap: 32,
        role: "hero",
        justifyContent: "center",
        alignItems: "center"
      }
    ]
  }
})
```
