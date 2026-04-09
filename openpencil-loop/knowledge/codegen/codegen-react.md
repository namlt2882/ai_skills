---
name: codegen-react
description: React + Tailwind CSS code generation from PenNode
phase: [generation]
trigger:
  keywords: [react, tsx, tailwind]
  flags: [isCodeGen]
priority: 20
budget: 2000
category: knowledge
mcp_tools:
  - export_nodes
  - batch_get
---

# React + Tailwind Code Generation

## MCP Data Input

```javascript
// Get full node tree (per page — use pageId for multi-page)
openpencil_export_nodes({ filePath: "path/to/design.op", pageId: "target-page-id" })

// Or get specific nodes
openpencil_batch_get({ filePath: "path/to/design.op", nodeIds: ["id1", "id2"], pageId: "target-page-id" })
```

## Output Format
- TypeScript TSX (`.tsx`)
- Functional components with `export function ComponentName()`
- Tailwind CSS for all styling

## Layout Mapping
- `layout: "vertical"` → `flex flex-col`
- `layout: "horizontal"` → `flex flex-row`
- `gap: N` → `gap-[Npx]`
- `padding` → `p-[Npx]` or `pt-[N] pr-[N] pb-[N] pl-[N]`
- `padding: [vertical, horizontal]` → `py-[Vpx] px-[Hpx]`
- `justifyContent` → `justify-{start|center|end|between|around}`
- `alignItems` → `items-{start|center|end|stretch}`
- `clipContent: true` → `overflow-hidden`

## Color & Fill Mapping
- Solid fill `#hex` → `bg-[#hex]`
- Variable ref `$name` → `bg-[var(--name)]`
- Text fill → `text-[#hex]` or `text-[var(--name)]`

## Border & Stroke Mapping
- `stroke.thickness` → `border-[Npx]`
- `stroke.color` → `border-[#hex]`

## Corner Radius
- Uniform → `rounded-[Npx]`
- Ellipse → `rounded-full`

## Typography
- `fontSize` → `text-[Npx]`
- `fontWeight` (numeric) → `font-[weight]`
- `lineHeight` → `leading-[value]`
- `textAlign` → `text-{left|center|right|justify}`

## Dimensions
- Fixed → `w-[Npx] h-[Npx]`
- `fill_container` width → `w-full`
- `fill_container` height → `h-full`

## Variable References
- `$variable` → `var(--variable-name)` in CSS
