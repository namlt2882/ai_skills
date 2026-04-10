# OpenPencil MCP Tool Observation Contracts

**Documented Tools:** 5 core tools from layered design workflow  
**Date:** 2026-04-10  
**Reference:** `observation-contract.md` specification

---

## 1. design_skeleton

**Purpose:** Create layout skeleton with root frame + section frames for layered design workflow

### Success Case

```json
{
  "status": "success",
  "summary": "Created page skeleton with 1 root frame and 4 sections (Header, Hero, Content, Footer)",
  "next_actions": [
    "Call design_content for section 'Header' with children: logo, nav, avatar",
    "Call design_content for section 'Hero' with children: headline, subtext, CTA",
    "Call design_content for section 'Content' with children: card, list, spacer",
    "Call design_content for section 'Footer' with children: links, copyright",
    "Call design_refine with rootId 'abc-123' to validate and auto-fix layout issues"
  ],
  "artifacts": {
    "rootId": "abc-123",
    "sectionIds": ["sec-header", "sec-hero", "sec-content", "sec-footer"],
    "sectionNames": ["Header", "Hero", "Content", "Footer"],
    "totalSections": 4,
    "canvasWidth": 1200,
    "canvasHeight": 800,
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Continue with design_content calls per next_actions. Use sectionIds to reference sections in subsequent calls.

---

### Warning Case

```json
{
  "status": "warning",
  "summary": "design_skeleton: section count (2) below recommended minimum (4) for complex page",
  "next_actions": [
    "Consider adding more sections (e.g., Features, Testimonials, FAQ)",
    "Review page requirements to ensure all content areas covered",
    "Adjust section definitions if business needs require more sections"
  ],
  "artifacts": {
    "rootId": "abc-123",
    "sectionIds": ["sec-hero", "sec-content"],
    "sectionNames": ["Hero", "Content"],
    "totalSections": 2,
    "recommendedMin": 4,
    "canvasWidth": 1200,
    "canvasHeight": 800,
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Consider adding more sections before proceeding. Not blocking, but may result in incomplete page structure.

---

### Error Case

```json
{
  "status": "error",
  "summary": "design_skeleton requires valid .op file at filePath",
  "error": "ENOENT: canvas/design.op not found",
  "root_cause": "File does not exist or path is incorrect",
  "next_actions": [
    "Create file: echo '{\"version\":\"1.0.0\",\"children\":[]}' > canvas/design.op",
    "Verify file creation: ls -la canvas/design.op",
    "Re-run design_skeleton with the same parameters",
    "If still fails, check file permissions or path configuration"
  ],
  "artifacts": {
    "filePath": "canvas/design.op",
    "operation": "design_skeleton",
    "requiredFields": ["rootFrame", "sections"]
  }
}
```

**Agent Action:** Execute the create file command, then retry with same parameters. If still fails after 3 retries, escalate with diagnostic information.

---

## 2. design_content

**Purpose:** Populate a section with content nodes (text, shapes, images, icons)

### Success Case

```json
{
  "status": "success",
  "summary": "Populated 12 nodes into section 'Hero' (headline, subtext, CTA button, icon)",
  "next_actions": [
    "Call design_refine with rootId 'abc-123' to validate and auto-fix layout issues",
    "Review section 'Hero' for visual balance and spacing",
    "Proceed to next section if satisfied with current results"
  ],
  "artifacts": {
    "sectionId": "sec-hero",
    "sectionName": "Hero",
    "insertedCount": 12,
    "createdNodes": ["node-1", "node-2", "node-3", "node-4", "node-5", "node-6", "node-7", "node-8", "node-9", "node-10", "node-11", "node-12"],
    "nodeTypes": ["text", "text", "rectangle", "text", "ellipse", "text", "rectangle", "text", "text", "text", "text", "text"],
    "warnings": [],
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Continue with design_refine call. Verify results in design tool before proceeding to next section.

---

### Warning Case (Partial Success)

```json
{
  "status": "warning",
  "summary": "design_content: node count (3) below recommended minimum (5) for section 'Header'",
  "next_actions": [
    "Add more content nodes to section 'Header'",
    "Consider adding decorative elements (separator, spacer, icon)",
    "Verify section has visual weight and matches design requirements",
    "Re-run design_content after adding more nodes"
  ],
  "artifacts": {
    "sectionId": "sec-header",
    "sectionName": "Header",
    "insertedCount": 3,
    "createdNodes": ["node-1", "node-2", "node-3"],
    "nodeTypes": ["text", "text", "rectangle"],
    "warnings": ["Text node height estimation needed"],
    "recommendedMin": 5,
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Consider adding more content before proceeding. Not blocking, but may affect design quality. Review section requirements.

---

### Error Case

```json
{
  "status": "error",
  "summary": "design_content: Invalid sectionId 'invalid-uuid' not found in document",
  "error": "NOT_FOUND: Section 'invalid-uuid' does not exist",
  "root_cause": "Section ID does not match any section created by design_skeleton",
  "next_actions": [
    "List all sections: Call batch_get with pattern 'section'",
    "Verify sectionId from design_skeleton artifacts",
    "Re-run design_content with correct sectionId",
    "If sectionId is correct, check if design_skeleton was called successfully"
  ],
  "artifacts": {
    "sectionId": "invalid-uuid",
    "sectionName": "Invalid Section",
    "requestedChildren": ["headline", "subtext", "cta"],
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** List all sections to find correct IDs. Retry with valid sectionId. If still fails, verify design_skeleton was called successfully.

---

## 3. design_refine

**Purpose:** Run full-tree validation and auto-fixes on a design

### Success Case

```json
{
  "status": "success",
  "summary": "Applied 3 auto-fixes (role resolution, card row equalization, overflow fix)",
  "next_actions": [
    "Review fixes in design tool to verify correctness",
    "Check for any remaining layout issues",
    "Iterate with design_refine if issues remain",
    "Proceed to export or codegen if design is complete"
  ],
  "artifacts": {
    "rootId": "abc-123",
    "fixesApplied": 3,
    "fixes": [
      {
        "type": "role_resolution",
        "nodeId": "xyz-789",
        "message": "Role 'button' applied to node",
        "applied": true
      },
      {
        "type": "card_row_equalization",
        "nodeId": "abc-123",
        "message": "Card widths equalized to 320px",
        "applied": true
      },
      {
        "type": "overflow_fix",
        "nodeId": "def-456",
        "message": "Text overflow clipped with ellipsis",
        "applied": true
      }
    ],
    "fixedNodes": ["xyz-789", "abc-123", "def-456"],
    "layoutSnapshot": {
      "rootId": "abc-123",
      "tree": [...]
    },
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Review fixes in design tool. Iterate if issues remain. Proceed to export/codegen if design is complete.

---

### Warning Case (Auto-fixes Applied)

```json
{
  "status": "warning",
  "summary": "design_refine: Applied 2 auto-fixes but 1 validation warning remains",
  "next_actions": [
    "Review auto-fixes in design tool to verify correctness",
    "Address remaining warning: 'Text contrast ratio below WCAG AA standard'",
    "Manually adjust text color or background to meet accessibility requirements",
    "Re-run design_refine after manual fixes to verify resolution"
  ],
  "artifacts": {
    "rootId": "abc-123",
    "fixesApplied": 2,
    "warnings": [
      {
        "type": "accessibility",
        "nodeId": "node-123",
        "message": "Text contrast ratio below WCAG AA standard",
        "severity": "warning",
        "recommendedAction": "Increase contrast or adjust text size"
      }
    ],
    "fixedNodes": ["xyz-789", "abc-123"],
    "layoutSnapshot": {
      "rootId": "abc-123",
      "tree": [...]
    },
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Review auto-fixes. Address remaining warnings manually. Re-run design_refine after fixes.

---

### Error Case

```json
{
  "status": "error",
  "summary": "design_refine: Validation failed - root frame not found",
  "error": "NOT_FOUND: Root frame with rootId 'invalid-uuid' not found",
  "root_cause": "Root frame was deleted or never created by design_skeleton",
  "next_actions": [
    "List all frames: Call batch_get with pattern 'frame'",
    "Verify rootId from design_skeleton artifacts",
    "Re-run design_skeleton if root frame is missing",
    "If root frame exists, check if design_refine was called with correct rootId"
  ],
  "artifacts": {
    "rootId": "invalid-uuid",
    "operation": "design_refine",
    "validationRules": ["role_resolution", "card_row_equalization", "overflow_fix", "text_height_estimation"]
  }
}
```

**Agent Action:** List all frames to find correct rootId. Retry with valid rootId. If still fails, verify design_skeleton was called successfully.

---

## 4. insert_node

**Purpose:** Insert a new node into the document at specified position

### Success Case

```json
{
  "status": "success",
  "summary": "Inserted new Text node 'Title' with fontSize=24, weight='bold' into parent frame",
  "next_actions": [
    "Continue adding more nodes to parent frame if needed",
    "Call design_refine if layout issues arise after insertion",
    "Verify node appears in design tool at correct position"
  ],
  "artifacts": {
    "nodeId": "new-node-uuid",
    "parentId": "parent-frame-uuid",
    "nodeType": "text",
    "nodeName": "Title",
    "nodeData": {
      "type": "text",
      "content": "Title",
      "fontSize": 24,
      "fontWeight": "bold",
      "fill": "#000000"
    },
    "position": {
      "index": 0,
      "relativeTo": "first child"
    },
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Continue adding more nodes if needed. Call design_refine if layout issues arise.

---

### Warning Case (Node Exists)

```json
{
  "status": "warning",
  "summary": "insert_node: Node with name 'Title' already exists in parent frame",
  "next_actions": [
    "Check if node needs to be updated instead of inserted",
    "Call update_node to modify existing node properties",
    "Or delete existing node and insert new one if content differs significantly"
  ],
  "artifacts": {
    "nodeId": "existing-node-uuid",
    "parentId": "parent-frame-uuid",
    "nodeName": "Title",
    "nodeType": "text",
    "existingData": {
      "type": "text",
      "content": "Title",
      "fontSize": 24,
      "fontWeight": "bold"
    },
    "requestedData": {
      "type": "text",
      "content": "Title",
      "fontSize": 24,
      "fontWeight": "bold"
    },
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Consider updating existing node instead of inserting new one. Verify if content differs significantly.

---

### Error Case

```json
{
  "status": "error",
  "summary": "insert_node: Parent frame not found at parentId 'invalid-uuid'",
  "error": "NOT_FOUND: Parent frame 'invalid-uuid' does not exist",
  "root_cause": "Parent frame was deleted or never created",
  "next_actions": [
    "List all frames: Call batch_get with pattern 'frame'",
    "Verify parentId from design_skeleton or batch_design artifacts",
    "Re-run insert_node with correct parentId",
    "If parent frame is missing, create it first using insert_node or batch_design"
  ],
  "artifacts": {
    "nodeId": null,
    "parentId": "invalid-uuid",
    "nodeType": "text",
    "nodeName": "Title",
    "requestedData": {
      "type": "text",
      "content": "Title",
      "fontSize": 24,
      "fontWeight": "bold"
    },
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** List all frames to find correct parentId. Retry with valid parentId. If still fails, create parent frame first.

---

## 5. batch_design

**Purpose:** Execute multiple DSL operations in a single call

### Success Case

```json
{
  "status": "success",
  "summary": "Executed 3 DSL operations (insert 3 nodes into card frame, update card properties)",
  "next_actions": [
    "Verify nodes in design tool to ensure all operations completed",
    "Call design_refine if layout issues arise",
    "Proceed to next design phase if all operations successful"
  ],
  "artifacts": {
    "bindings": {
      "card": "card-frame-uuid",
      "title": "title-node-uuid",
      "body": "body-node-uuid",
      "button": "button-node-uuid"
    },
    "operations": 3,
    "operationTypes": ["insert", "insert", "update"],
    "createdNodes": ["title-node-uuid", "body-node-uuid", "button-node-uuid"],
    "updatedNodes": ["card-frame-uuid"],
    "dslOperations": [
      "I(parent, { type: 'frame', name: 'Card', width: 320, height: 400, ... })",
      "I(parent, { type: 'text', content: 'Title', fontSize: 18, ... })",
      "U('card-frame-uuid', { width: 320, cornerRadius: 12, ... })"
    ],
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Verify nodes in design tool. Call design_refine if layout issues arise.

---

### Warning Case (Some Operations Failed)

```json
{
  "status": "warning",
  "summary": "batch_design: 2 of 3 operations succeeded, 1 operation failed (node already exists)",
  "next_actions": [
    "Review failed operation: 'Node with name 'Title' already exists'",
    "Skip failed operation or update existing node instead",
    "Re-run batch_design with corrected operations",
    "Verify all nodes appear in design tool"
  ],
  "artifacts": {
    "bindings": {
      "card": "card-frame-uuid",
      "title": "title-node-uuid",
      "body": "body-node-uuid",
      "button": "button-node-uuid"
    },
    "operations": 3,
    "successfulOperations": 2,
    "failedOperations": [
      {
        "operation": "insert",
        "nodeId": null,
        "error": "Node with name 'Title' already exists",
        "dsl": "I(parent, { type: 'text', content: 'Title', ... })"
      }
    ],
    "createdNodes": ["body-node-uuid", "button-node-uuid"],
    "updatedNodes": ["card-frame-uuid"],
    "dslOperations": [
      "I(parent, { type: 'frame', name: 'Card', width: 320, ... })",
      "I(parent, { type: 'text', content: 'Title', ... })",
      "I(parent, { type: 'text', content: 'Body', ... })"
    ],
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Review failed operation. Skip or update existing node. Re-run batch_design with corrected operations.

---

### Error Case (DSL Syntax Error)

```json
{
  "status": "error",
  "summary": "batch_design: DSL syntax error in operation 2",
  "error": "SYNTAX_ERROR: Unexpected token '}' at line 2, column 15",
  "root_cause": "Malformed DSL operation - missing closing brace or invalid syntax",
  "next_actions": [
    "Review DSL operations for syntax errors",
    "Fix malformed operation: add missing closing brace",
    "Re-run batch_design with corrected operations",
    "Test DSL operations individually before batch execution"
  ],
  "artifacts": {
    "bindings": {},
    "operations": 3,
    "successfulOperations": 1,
    "failedOperations": [
      {
        "operation": 2,
        "nodeId": null,
        "error": "SYNTAX_ERROR: Unexpected token '}' at line 2, column 15",
        "dsl": "I(parent, { type: 'frame', name: 'Card', width: 320, height: 400, ... }"
      }
    ],
    "createdNodes": [],
    "updatedNodes": [],
    "dslOperations": [
      "I(parent, { type: 'frame', name: 'Card', width: 320, ... })",
      "I(parent, { type: 'frame', name: 'Card', width: 320, height: 400, ... }",
      "U('card-frame-uuid', { width: 320, cornerRadius: 12, ... })"
    ],
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action:** Review DSL operations for syntax errors. Fix malformed operation. Re-run batch_design with corrected operations.

---

## Summary of Observation Contract Patterns

### Status Field Usage

| Tool | Success | Warning | Error |
|------|---------|---------|-------|
| **design_skeleton** | ✅ | ✅ (low section count) | ✅ (file not found) |
| **design_content** | ✅ | ✅ (low node count) | ✅ (invalid sectionId) |
| **design_refine** | ✅ | ✅ (auto-fixes + warnings) | ✅ (validation failure) |
| **insert_node** | ✅ | ✅ (node exists) | ✅ (parent not found) |
| **batch_design** | ✅ | ✅ (partial success) | ✅ (DSL syntax error) |

### next_actions Field Patterns

**Design Continuation Tools (design_skeleton, design_content, design_refine):**
- Reference specific node IDs (rootId, sectionId)
- List subsequent tool calls (e.g., "Call design_content for section 'X'")
- Include iteration guidance (e.g., "Re-run design_refine if issues remain")

**Node Operation Tools (insert_node, batch_design):**
- Reference parent IDs and node IDs
- Suggest verification steps (e.g., "Verify nodes in design tool")
- Recommend follow-up actions (e.g., "Call design_refine if layout issues arise")

### artifacts Field Patterns

**Design Continuation Tools:**
- `rootId`: Root frame node ID
- `sectionIds` / `sectionName`: Section node IDs and names
- `insertedCount` / `createdNodes`: Number of nodes created
- `fixesApplied` / `fixedNodes`: Number of fixes applied

**Node Operation Tools:**
- `nodeId`: The affected node's ID
- `parentId`: Parent frame node ID
- `nodeType` / `nodeName`: Node type and name
- `bindings`: Mapping of DSL variable names to node IDs

---

## Related Files

- `openpencil-loop/phases/observation-contract.md` - Observation contract specification
- `openpencil-loop/reference/tool-output-analysis.md` - Current output format gaps
- `.sisyphus/notepads/openpencil-loop-harness-optimization/learnings.md` - Learnings log