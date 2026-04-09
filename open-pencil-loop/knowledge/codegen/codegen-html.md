---
name: codegen-html
description: HTML + CSS code generation from PenNode (v2)
phase: [generation]
trigger:
  keywords: [html, css, vanilla, static]
  flags: [isCodeGen]
priority: 20
budget: 2000
category: knowledge
mcp_tools:
  - export_nodes
  - get_codegen_prompt
  - get_design_md
---

# HTML + CSS Code Generation (v2)

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
// Use pageId for multi-page apps
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "export_nodes",
  arguments: {
    filePath: "/path/to/design.fig",  // or .pen
    pageId: "target-page-id"
  }
})

// Export specific nodes
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "export_nodes",
  arguments: {
    filePath: "/path/to/design.fig",
    nodeIds: ["node-1", "node-2"],
    pageId: "target-page-id"
  }
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

## Example Generated Output

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Generated Design</title>
  <style>
    :root {
      --primary-color: #3b82f6;
      --text-color: #1f2937;
      --bg-color: #ffffff;
    }

    .card {
      display: flex;
      flex-direction: column;
      gap: 16px;
      padding: 24px;
      background: var(--bg-color);
      border-radius: 12px;
      border: 1px solid #e5e7eb;
    }

    .card-title {
      font-size: 20px;
      font-weight: 600;
      color: var(--text-color);
    }
  </style>
</head>
<body>
  <div class="card">
    <h2 class="card-title">Title</h2>
  </div>
</body>
</html>
```
