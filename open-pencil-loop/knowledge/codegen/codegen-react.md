---
name: codegen-react
description: React + Tailwind CSS code generation from PenNode (v2)
phase: [generation]
trigger:
  keywords: [react, tsx, tailwind]
  flags: [isCodeGen]
priority: 20
budget: 2000
category: knowledge
mcp_tools:
  - export_nodes
  - get_codegen_prompt
  - get_design_md
---

# React + Tailwind Code Generation (v2)

## MCP Data Input

### Step 1: Get Code Generation Guidelines

```javascript
// Always call first to get codegen guidelines
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "get_codegen_prompt",
  arguments: {}
})
```

### Step 2: Export PenNode Data

```javascript
// Get full node tree (per page — use pageId for multi-page)
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "export_nodes",
  arguments: {
    filePath: "/path/to/design.fig",  // or .pen
    pageId: "target-page-id"
  }
})

// Or get specific nodes
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "export_nodes",
  arguments: {
    filePath: "/path/to/design.fig",
    nodeIds: ["id1", "id2"],
    pageId: "target-page-id"
  }
})
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

## Example Generated Component

```tsx
// Generated from PenNode export
export function Card({ title, description }: CardProps) {
  return (
    <div className="flex flex-col gap-4 p-6 bg-white rounded-xl border border-gray-200">
      <h2 className="text-xl font-semibold text-gray-900">{title}</h2>
      <p className="text-base text-gray-600">{description}</p>
    </div>
  );
}
```
