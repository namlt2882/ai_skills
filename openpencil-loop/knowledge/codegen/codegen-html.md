---
name: codegen-html
description: HTML + CSS code generation from PenNode
phase: [generation]
trigger:
  keywords: [html, css, vanilla, static]
  flags: [isCodeGen]
priority: 20
budget: 2000
category: knowledge
mcp_tools:
  - export_nodes
---

# HTML + CSS Code Generation

## MCP Data Input

```javascript
// Use pageId for multi-page apps
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "export_nodes",
  arguments: { filePath: "path/to/design.op", pageId: "target-page-id" }
})
```

## Output Format
- HTML5 (`.html`)
- Semantic HTML elements
- CSS classes in `<style>` block
- CSS custom properties for design variables

## Layout Mapping
- `layout: "vertical"` → `display: flex; flex-direction: column`
- `layout: "horizontal"` → `display: flex; flex-direction: row`
- `gap: N` → `gap: Npx`
- `justifyContent: "space_between"` → `justify-content: space-between`
- `alignItems: "center"` → `align-items: center`
- `clipContent: true` → `overflow: hidden`

## Color & Fill Mapping
- Solid fill `#hex` → `background: #hex`
- Text fill → `color: #hex`

## Typography
- `fontSize` → `font-size: Npx`
- `fontWeight` → `font-weight: N`
- `lineHeight` → `line-height: value`
- `textAlign` → `text-align: left|center|right`

## Variable References
- `$variable` → `var(--variable-name)` in CSS custom properties
