# OpenPencil MCP Tool Output Format Analysis

**Analysis Date:** 2026-04-10  
**Tools Analyzed:** 10 core tools from `mcp-tool-index.md`  
**Observation Contract Standard:** status, summary, next_actions, artifacts

---

## Executive Summary

**Critical Finding:** All analyzed MCP tools return **raw data structures** without standardized observation contract fields (status, summary, next_actions, artifacts).

**Impact:** Draft review gave Observation Quality 4/10 - critical issue for agent observability and debugging.

**Recommendation:** Add observation contract wrapper to all tools (Priority: P0)

---

## Tool-by-Tool Analysis

### 1. openpencil_design_skeleton

**Current Return Format:**
```json
{
  "rootId": "uuid",
  "sections": [
    {
      "id": "uuid",
      "name": "SectionName",
      "height": 400,
      "layout": "vertical",
      ...
    }
  ]
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No human-readable summary of created structure
- ❌ `next_actions`: No guidance on next steps (e.g., "Call design_content for each section")
- ❌ `artifacts`: No reference to created nodes (rootId, sectionIds)

**Priority:** **P0** (Critical - blocks layered workflow)

**Example Gap:**
```json
// Current (raw data only)
{
  "rootId": "abc-123",
  "sections": [...]
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Created page skeleton with 4 sections (Header, Hero, Content, Footer)",
  "next_actions": [
    "Call design_content for section 'Header' with children: logo, nav, avatar",
    "Call design_content for section 'Hero' with children: headline, subtext, CTA",
    "Call design_refine with rootId 'abc-123' to validate and auto-fix"
  ],
  "artifacts": {
    "rootId": "abc-123",
    "sectionIds": ["def-456", "ghi-789", "jkl-012", "mno-345"],
    "createdNodes": 5
  }
}
```

---

### 2. openpencil_design_content

**Current Return Format:**
```json
{
  "inserted": 12,
  "warnings": ["Text node height estimation needed"],
  "snapshot": {
    "sectionId": "def-456",
    "children": [...]
  }
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of populated content
- ❌ `next_actions`: No guidance on next steps (e.g., "Call design_refine")
- ❌ `artifacts`: No reference to created nodes

**Priority:** **P0** (Critical - blocks layered workflow)

**Example Gap:**
```json
// Current (raw data only)
{
  "inserted": 12,
  "warnings": ["Text node height estimation needed"],
  "snapshot": {...}
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Populated 12 nodes into section 'Hero' (headline, subtext, CTA button)",
  "next_actions": [
    "Call design_refine with rootId 'abc-123' to validate and auto-fix layout issues"
  ],
  "artifacts": {
    "sectionId": "def-456",
    "insertedCount": 12,
    "warnings": ["Text node height estimation needed"],
    "createdNodes": ["node-1", "node-2", ...]
  }
}
```

---

### 3. openpencil_design_refine

**Current Return Format:**
```json
{
  "fixesApplied": [
    {"type": "role_resolution", "nodeId": "xyz-789", "message": "Role 'button' applied"},
    {"type": "card_row_equalization", "nodeId": "abc-123", "message": "Card widths equalized"}
  ],
  "layoutSnapshot": {
    "rootId": "abc-123",
    "tree": [...]
  }
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of fixes applied
- ❌ `next_actions`: No guidance on next steps (e.g., "Review fixes, iterate if needed")
- ❌ `artifacts`: No reference to modified nodes

**Priority:** **P0** (Critical - final validation step)

**Example Gap:**
```json
// Current (raw data only)
{
  "fixesApplied": [
    {"type": "role_resolution", "nodeId": "xyz-789", "message": "Role 'button' applied"},
    {"type": "card_row_equalization", "nodeId": "abc-123", "message": "Card widths equalized"}
  ],
  "layoutSnapshot": {...}
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Applied 3 auto-fixes (role resolution, card row equalization, overflow fix)",
  "next_actions": [
    "Review fixes in design tool",
    "Iterate if any issues remain (call design_refine again)"
  ],
  "artifacts": {
    "rootId": "abc-123",
    "fixesApplied": 3,
    "fixedNodes": ["xyz-789", "abc-123", "def-456"],
    "layoutSnapshot": {...}
  }
}
```

---

### 4. openpencil_insert_node

**Current Return Format:**
```json
{
  "nodeId": "new-node-uuid",
  "parent": "parent-uuid",
  "data": {...}
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of inserted node
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to created node

**Priority:** **P1** (High - frequently used in maintenance phase)

**Example Gap:**
```json
// Current (raw data only)
{
  "nodeId": "new-node-uuid",
  "parent": "parent-uuid",
  "data": {...}
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Inserted new Text node 'Title' with fontSize=24, weight='bold'",
  "next_actions": [
    "Continue adding more nodes to parent",
    "Call design_refine if layout issues arise"
  ],
  "artifacts": {
    "nodeId": "new-node-uuid",
    "parentId": "parent-uuid",
    "nodeType": "text",
    "nodeName": "Title"
  }
}
```

---

### 5. openpencil_batch_design

**Current Return Format:**
```json
{
  "bindings": {
    "card": "node-uuid-1",
    "title": "node-uuid-2",
    "body": "node-uuid-3"
  },
  "operations": 3
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of batch operations
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to created nodes

**Priority:** **P1** (High - frequently used for batch operations)

**Example Gap:**
```json
// Current (raw data only)
{
  "bindings": {
    "card": "node-uuid-1",
    "title": "node-uuid-2",
    "body": "node-uuid-3"
  },
  "operations": 3
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Executed 3 DSL operations (insert 3 nodes into card frame)",
  "next_actions": [
    "Verify nodes in design tool",
    "Call design_refine if layout issues arise"
  ],
  "artifacts": {
    "bindings": {
      "card": "node-uuid-1",
      "title": "node-uuid-2",
      "body": "node-uuid-3"
    },
    "operations": 3,
    "createdNodes": ["node-uuid-1", "node-uuid-2", "node-uuid-3"]
  }
}
```

---

### 6. openpencil_update_node

**Current Return Format:**
```json
{
  "nodeId": "node-uuid",
  "updated": true
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of updated properties
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to modified node

**Priority:** **P1** (High - frequently used in maintenance phase)

**Example Gap:**
```json
// Current (raw data only)
{
  "nodeId": "node-uuid",
  "updated": true
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Updated node 'Card' with width=320, cornerRadius=12, bg='#FFF'",
  "next_actions": [
    "Verify changes in design tool",
    "Call design_refine if layout issues arise"
  ],
  "artifacts": {
    "nodeId": "node-uuid",
    "updatedProperties": ["width", "cornerRadius", "fill"],
    "previousValues": {...},
    "newValues": {...}
  }
}
```

---

### 7. openpencil_delete_node

**Current Return Format:**
```json
{
  "nodeId": "node-uuid",
  "deleted": true
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of deleted node
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to deleted node

**Priority:** **P2** (Medium - less frequently used)

**Example Gap:**
```json
// Current (raw data only)
{
  "nodeId": "node-uuid",
  "deleted": true
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Deleted node 'OldButton' from parent frame",
  "next_actions": [
    "Verify deletion in design tool",
    "Call design_refine if layout issues arise"
  ],
  "artifacts": {
    "nodeId": "node-uuid",
    "nodeType": "frame",
    "nodeName": "OldButton",
    "parent": "parent-uuid"
  }
}
```

---

### 8. openpencil_batch_get

**Current Return Format:**
```json
{
  "nodes": [
    {
      "id": "node-uuid",
      "type": "frame",
      "name": "Card",
      ...
    }
  ],
  "count": 12
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of retrieved nodes
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to retrieved nodes

**Priority:** **P2** (Medium - read operation, less critical)

**Example Gap:**
```json
// Current (raw data only)
{
  "nodes": [
    {
      "id": "node-uuid",
      "type": "frame",
      "name": "Card",
      ...
    }
  ],
  "count": 12
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Retrieved 12 nodes matching pattern 'Card'",
  "next_actions": [
    "Process nodes for codegen or validation",
    "Call openpencil_batch_get if saving to file"
  ],
  "artifacts": {
    "nodes": [...],
    "count": 12,
    "nodeIds": ["node-uuid-1", "node-uuid-2", ...],
    "searchPattern": "Card"
  }
}
```

---

### 9. openpencil_open_document

**Current Return Format:**
```json
{
  "filePath": "design.op",
  "pageId": "page-uuid",
  "pages": [
    {
      "id": "page-uuid",
      "name": "Page 1",
      "children": [...]
    }
  ]
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of opened document
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to opened document

**Priority:** **P1** (High - initialization step)

**Example Gap:**
```json
// Current (raw data only)
{
  "filePath": "design.op",
  "pageId": "page-uuid",
  "pages": [...]
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Opened document 'design.op' with 1 page (Page 1)",
  "next_actions": [
    "Call design_skeleton to create page structure",
    "Or call batch_get to inspect existing content"
  ],
  "artifacts": {
    "filePath": "design.op",
    "pageId": "page-uuid",
    "pageCount": 1,
    "pageNames": ["Page 1"],
    "totalNodes": 5
  }
}
```

---

### 10. openpencil_batch_get

**Current Return Format:**
```json
{
  "nodes": [
    {
      "id": "node-uuid",
      "type": "frame",
      "name": "Card",
      ...
    }
  ],
  "format": "json"
}
```

**Missing Fields:**
- ❌ `status`: No success/failure indicator
- ❌ `summary`: No summary of exported nodes
- ❌ `next_actions`: No guidance on next steps
- ❌ `artifacts`: No reference to exported nodes

**Priority:** **P2** (Medium - export operation, less critical)

**Example Gap:**
```json
// Current (raw data only)
{
  "nodes": [
    {
      "id": "node-uuid",
      "type": "frame",
      "name": "Card",
      ...
    }
  ],
  "format": "json"
}

// Desired (with observation contract)
{
  "status": "success",
  "summary": "Exported 15 nodes to JSON format for codegen",
  "next_actions": [
    "Write exported nodes to file using filesystem_write_file",
    "Process nodes for React/HTML code generation"
  ],
  "artifacts": {
    "nodes": [...],
    "count": 15,
    "format": "json",
    "nodeIds": ["node-uuid-1", "node-uuid-2", ...],
    "exportedAt": "2026-04-10T12:00:00Z"
  }
}
```

---

## Summary of Gaps

| Tool | Missing Fields | Priority | Impact |
|------|----------------|----------|--------|
| design_skeleton | status, summary, next_actions, artifacts | **P0** | Blocks layered workflow |
| design_content | status, summary, next_actions, artifacts | **P0** | Blocks layered workflow |
| design_refine | status, summary, next_actions, artifacts | **P0** | Final validation step |
| insert_node | status, summary, next_actions, artifacts | **P1** | Frequently used |
| batch_design | status, summary, next_actions, artifacts | **P1** | Frequently used |
| update_node | status, summary, next_actions, artifacts | **P1** | Frequently used |
| delete_node | status, summary, next_actions, artifacts | **P2** | Less frequently used |
| batch_get | status, summary, next_actions, artifacts | **P2** | Read operation |
| open_document | status, summary, next_actions, artifacts | **P1** | Initialization step |
| ~~export_nodes~~ | Deprecated | **P2** | Replaced by openpencil_batch_get |

---

## Recommendation

### Priority 0 (Critical - Must Fix)
1. **design_skeleton**: Add observation contract wrapper to enable layered workflow
2. **design_content**: Add observation contract wrapper to enable layered workflow
3. **design_refine**: Add observation contract wrapper to enable final validation

### Priority 1 (High - Should Fix)
4. **insert_node**: Add observation contract wrapper for maintenance phase
5. **batch_design**: Add observation contract wrapper for batch operations
6. **update_node**: Add observation contract wrapper for maintenance phase
7. **open_document**: Add observation contract wrapper for initialization

### Priority 2 (Medium - Nice to Have)
8. **delete_node**: Add observation contract wrapper
9. **openpencil_batch_get**: Add observation contract wrapper
10. ~~export_nodes~~: Deprecated — replaced by openpencil_batch_get

---

## Implementation Approach

### Option 1: Modify MCP Server (Recommended)
- Add observation contract wrapper to all `openpencil_*` tools
- Return standardized format: `{ status, summary, next_actions, artifacts, data }`
- Update SKILL.md documentation to reflect new return format
- Update tests to verify observation contract compliance

### Option 2: Add Wrapper in SKILL.md
- Create helper functions in SKILL.md to wrap tool calls
- Add observation contract fields before returning to agents
- Less invasive, but requires manual wrapper for each tool

### Option 3: Post-Processing in SKILL.md
- Parse raw tool output and add observation contract fields
- Add status, summary, next_actions based on tool-specific logic
- Most flexible, but requires custom logic for each tool

**Recommendation:** Option 1 (Modify MCP Server) for consistency and maintainability.

---

## Next Steps

1. **Create observation contract specification** (separate task)
2. **Implement wrapper in MCP server** (separate task)
3. **Update SKILL.md documentation** (separate task)
4. **Update tests** (separate task)
5. **Verify observation quality** (separate task)

---

## Appendix: Observation Contract Specification

**Standard Format:**
```json
{
  "status": "success" | "error" | "partial",
  "summary": "Human-readable summary of operation",
  "next_actions": ["Action 1", "Action 2", ...],
  "artifacts": {
    "key1": "value1",
    "key2": "value2",
    ...
  },
  "data": { /* Original tool data */ }
}
```

**Status Codes:**
- `success`: Operation completed successfully
- `error`: Operation failed with error message
- `partial`: Operation completed with warnings (e.g., design_content with warnings)

**next_actions Guidelines:**
- Provide actionable next steps for the agent
- Reference specific node IDs or section IDs
- Include tool calls if needed (e.g., "Call design_refine with rootId 'abc-123'")

**artifacts Guidelines:**
- Include all relevant IDs (nodeId, sectionId, pageId, etc.)
- Include counts (insertedCount, fixesApplied, etc.)
- Include references to created/modified/deleted nodes