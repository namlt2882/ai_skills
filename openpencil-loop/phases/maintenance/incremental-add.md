---
name: incremental-add
description: Adding new elements to existing designs via MCP
phase: [maintenance]
trigger:
  keywords: [add, insert, new section, append]
priority: 20
budget: 1500
category: domain
mcp_tools:
  - batch_design
  - insert_node
  - copy_node
  - batch_get
---

> **MCP Tool Syntax:** `skill_mcp()` calls below use OpenCode syntax.
> Claude Code: `mcp__openpencil__<tool_name>(args)`. Codex: `openpencilMcp.<tool_name>(args)`.
> See SKILL.md → "Multi-Agent Compatibility".

## MCP Functions Used

```javascript
// Add new nodes using batch_design DSL (preferred for multiple nodes)
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "batch_design",
  arguments: {
    filePath: "path/to/design.op",
    operations: "parentId=I(null, { type: 'frame', name: 'NewSection', width: 'fill_container' })",
    postProcess: true
  }
})

// Insert a single node
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "insert_node",
  arguments: {
    filePath: "path/to/design.op",
    parent: "parent-node-id",
    data: { type: "frame", name: "NewCard", width: "fill_container" }
  }
})

// Copy existing node as template
skill_mcp({
  mcp_name: "openpencil",
  tool_name: "copy_node",
  arguments: {
    filePath: "path/to/design.op",
    sourceId: "template-node-id",
    parent: "parent-node-id",
    overrides: { name: "new-node-name", x: 0, y: 0 }
  }
})
```

## Workflow

1. **Get current structure** (if needed):
   ```
   skill_mcp({
     mcp_name: "openpencil",
     tool_name: "batch_get",
     arguments: { filePath: "path/to/design.op", parentId: "target-parent" }
   })
   ```

2. **Generate new nodes** following the rules below.

3. **Insert using** `batch_design` (preferred) or `insert_node`.

---

INCREMENTAL ADDITION RULES:

When adding new elements to an existing design:

CONTEXT AWARENESS:
- Analyze the existing design structure before adding new elements.
- Match the visual style (colors, fonts, spacing, cornerRadius) of existing siblings.
- Place new elements in logical positions within the hierarchy.

SIBLING CONSISTENCY:
- New cards in a card row MUST match existing cards' width/height strategy (typically fill_container).
- New inputs in a form MUST match existing inputs' width and height.
- New sections MUST use the same padding and gap patterns as existing sections.

INSERTION RULES:
- Use "_parent" to specify where the new node belongs in the tree.
- New sections append after the last existing section by default.
- New items within a list/grid append after the last existing item.
- Preserve z-order: overlay elements (badges, indicators) come BEFORE content.

COMMON PATTERNS:
- "Add a section" -> new frame with width="fill_container", height="fit_content", layout="vertical", matching section padding.
- "Add a card" -> new frame matching sibling card structure (same children pattern, same styles).
- "Add an input" -> new frame with role="input" or "form-input", width="fill_container", matching sibling inputs.
- "Add a button" -> new frame with role="button", matching existing button style.
- "Add a row" -> new frame with layout="horizontal", appropriate gap and alignment.

ID GENERATION:
- Use unique descriptive IDs for new nodes (e.g. "new-feature-card", "contact-section").
- Never reuse existing IDs.
