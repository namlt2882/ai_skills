---
name: codegen
description: Code generation from PenNode JSON via MCP
phase: [generation]
trigger:
  flags: [isCodeGen]
priority: 10
budget: 3000
category: base
mcp_tools:
  - export_nodes
---

## Code Generation Workflow

```
Step 1: Get node data from OpenPencil
  skill_mcp({
    mcp_name: "openpencil",
    tool_name: "export_nodes",
    arguments: { filePath: "path/to/design.op", pageId: "target-page-id" }
  })

Step 2: Read framework-specific codegen guide
  read("openpencil-loop/knowledge/codegen/codegen-{framework}.md")

Step 3: Generate code using the framework patterns
```

**For multi-page apps:** Run Step 1 per page (pageId for each), generate code for each page separately.

## Available Frameworks

| Framework | File |
|-----------|------|
| React + Tailwind | `codegen-react.md` |
| HTML + CSS | `codegen-html.md` |

> **Coming soon:** Vue, Svelte, SwiftUI, Flutter/Compose, React Native

## Chunking Strategy

For complex designs, split into chunks:

```json
{
  "chunks": [
    { "id": "chunk-1", "name": "navbar", "nodeIds": [...], "dependencies": [] },
    { "id": "chunk-2", "name": "hero", "nodeIds": [...], "dependencies": ["chunk-1"] }
  ]
}
```

**Rules:**
1. Top-level frames with roles → each becomes a chunk
2. Repeated sibling structures (3+) → single chunk with iteration
3. Root layout → derive from top-level container's layout
4. Dependencies → if chunk B is visually nested in chunk A, B depends on A
