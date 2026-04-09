---
name: jsx-format
description: JSX rendering format for OpenPencil v2
trigger: null
priority: 10
budget: 1500
category: base
---

# JSX Format for OpenPencil v2

OpenPencil v2 uses JSX syntax for declarative design generation. This format is parsed and converted to PenNode structures internally.

## Prop Mapping Reference

| JSX Prop | PenNode Property | Description |
|----------|-----------------|-------------|
| `w` | `width` | Width in pixels or "fill" / "hug" |
| `h` | `height` | Height in pixels or "fill" / "hug" |
| `flex` | `layout` | Layout direction: "col" (vertical), "row" (horizontal) |
| `p` | `padding` | Padding (number or [v,h] array) |
| `bg` | `fill` | Background fill color |
| `gap` | `itemSpacing` | Gap between children |
| `rounded` | `cornerRadius` | Corner radius |
| `stroke` | `stroke` | Border/stroke color |
| `strokeWidth` | `strokeWeight` | Border thickness |
| `opacity` | `opacity` | Opacity 0-1 |
| `x` | `x` | X position (absolute) |
| `y` | `y` | Y position (absolute) |

## Complete JSX Syntax

### Frame (Container)

```jsx
<Frame
  name="Card"
  w={320}                    // width: 320
  h={200}                    // height: 200 (omit or 0 for auto)
  flex="col"                 // layout: vertical
  gap={16}                   // itemSpacing: 16
  p={24}                     // padding: 24 (or [vertical, horizontal])
  bg="#FFF"                  // fill: solid white
  rounded={12}               // cornerRadius: 12
  stroke="#E2E8F0"           // stroke color
  strokeWidth={1}            // stroke weight
  opacity={1}                // opacity
  clipContent={true}         // clip children
>
  {/* children */}
</Frame>
```

### Text Node

```jsx
<Text
  size={18}                  // fontSize: 18
  weight="bold"              // fontWeight: "bold" (or 400, 500, 600, 700)
  family="Inter"             // fontFamily
  fill="#1E293B"             // text color
  lineHeight={1.5}           // line height multiplier
  letterSpacing={-0.5}       // letter spacing
  align="left"               // textAlign: left | center | right
  wrap={true}                // text wrapping enabled
>
  Hello World
</Text>
```

### Rectangle

```jsx
<Rectangle
  w={100}
  h={100}
  bg="#3B82F6"
  rounded={8}
  stroke="#1D4ED8"
  strokeWidth={2}
/>
```

### Ellipse

```jsx
<Ellipse
  w={80}
  h={80}
  bg="#EF4444"
  stroke="#B91C1C"
/>
```

### Icon (Path)

```jsx
<Path
  name="SearchIcon"
  w={24}
  h={24}
  fill="#64748B"
  d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"
/>
```

### Image

```jsx
<Image
  w={400}
  h={300}
  src="https://example.com/image.jpg"
  rounded={12}
/>
```

## Complex Example

```jsx
<Frame name="Card" w={320} h="hug" flex="col" gap={16} p={24} bg="#FFF" rounded={16}>
  <Frame flex="row" gap={12} align="center">
    <Ellipse w={48} h={48} bg="#3B82F6" />
    <Frame flex="col" gap={4}>
      <Text size={18} weight="bold" fill="#1E293B">John Doe</Text>
      <Text size={14} fill="#64748B">Product Designer</Text>
    </Frame>
  </Frame>
  <Text size={14} fill="#475569" wrap={true}>
    Passionate about creating intuitive user experiences and beautiful interfaces.
  </Text>
  <Frame flex="row" gap={8} justify="end">
    <Text size={12} weight="medium" fill="#3B82F6">View Profile →</Text>
  </Frame>
</Frame>
```

## Frame Props Reference

```typescript
interface FrameProps {
  name?: string;              // Layer name
  w?: number | "fill" | "hug"; // Width
  h?: number | "fill" | "hug"; // Height (0 or "hug" for auto)
  flex?: "col" | "row";       // Layout direction
  gap?: number;               // Space between children
  p?: number | [number, number]; // Padding [vertical, horizontal] or uniform
  px?: number;                // Horizontal padding only
  py?: number;                // Vertical padding only
  pt?: number;                // Top padding
  pr?: number;                // Right padding
  pb?: number;                // Bottom padding
  pl?: number;                // Left padding
  bg?: string;                // Background color
  rounded?: number;           // Corner radius
  stroke?: string;            // Border color
  strokeWidth?: number;       // Border thickness
  opacity?: number;           // 0-1 opacity
  clipContent?: boolean;      // Clip children to bounds
  justify?: "start" | "center" | "end" | "space-between" | "space-around";
  align?: "start" | "center" | "end" | "stretch";
  x?: number;                 // Absolute X position
  y?: number;                 // Absolute Y position
}
```

## MCP Integration

Use `open-pencil` MCP with JSX via the render tool:

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "render",
  arguments: {
    jsx: '<Frame name="Card" w={320} h={200} flex="col" gap={16} p={24} bg="#FFF" rounded={16}><Text size={18} weight="bold">Title</Text></Frame>',
    parent_id: "parent-node-id"  // or null for root
  }
})
```

Or use the `render` tool for multiple JSX operations:
