# OpenPencil MCP Tool Observation Contract

## Purpose

Standardized output format for all OpenPencil MCP tools. Enables agents to:

1. **Understand status**: Immediate success/warning/error identification
2. **Know next steps**: Structured action list for proceeding
3. **Track artifacts**: Identify key IDs, files, and outputs
4. **Recover from errors**: Retry instructions and stop conditions

---

## Fields

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `status` | string | ✅ Yes | Outcome: `"success"`, `"warning"`, or `"error"` |
| `summary` | string | ✅ Yes | One-line description of what happened |
| `next_actions` | array | ✅ Yes | Array of actionable next steps for the agent |
| `artifacts` | object | ⚠️ Conditional | Node IDs, file paths, or other outputs relevant to the current tool |

---

## Status Field Definitions

### `success`
Tool completed successfully. The agent can proceed to the next step in the workflow.

### `warning`
Tool completed but with caveats. The agent should continue but verify results or consider alternatives.

### `error`
Tool failed. The agent must stop, report the error, and follow retry instructions if provided.

---

## Field Usage Patterns by Tool Type

### Design Continuation Tools (design_skeleton, design_content, design_refine)

Return `artifacts` with:

- `rootId`: Root frame node ID
- `sectionIds`: Array of created section node IDs
- `filePath`: Path to the `.op` file being worked on

### File I/O Tools (open_document, read_nodes)

Return `artifacts` with:

- `filePath`: Path to the file
- `nodeCount`: Number of nodes in the document
- `pageIds`: Array of page IDs (for multi-page documents)

### Node Operation Tools (insert_node, update_node, delete_node)

Return `artifacts` with:

- `nodeId`: The affected node's ID
- `filePath`: Path to the `.op` file
- `operation`: Type of operation performed

---

## Examples

### Success Example

```json
{
  "status": "success",
  "summary": "Created skeleton with 1 root frame and 4 sections",
  "next_actions": [
    "Call design_content for each section using sectionId",
    "Start with sec1 (Header section)",
    "After all sections populated, call design_refine"
  ],
  "artifacts": {
    "rootId": "abc123",
    "sectionIds": ["sec1", "sec2", "sec3", "sec4"],
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action**: Continue with design_content calls per next_actions.

---

### Warning Example

```json
{
  "status": "warning",
  "summary": "design_content: node count (3) below recommended minimum (5)",
  "next_actions": [
    "Add more content nodes to the section",
    "Consider adding decorative elements (separator, spacer, icon)",
    "Verify section has visual weight"
  ],
  "artifacts": {
    "sectionId": "sec1",
    "nodeCount": 3,
    "recommendedMin": 5,
    "filePath": "canvas/design.op"
  }
}
```

**Agent Action**: Consider adding more content before proceeding. Not blocking, but may affect design quality.

---

### Error Example

```json
{
  "status": "error",
  "summary": "design_skeleton requires valid .op file at filePath",
  "error": "ENOENT: canvas/design.op not found",
  "root_cause": "File does not exist or path is incorrect",
  "next_actions": [
    "Create file: echo '{\"version\":\"1.0.0\",\"children\":[]}' > canvas/design.op",
    "Re-run design_skeleton with the same parameters"
  ],
  "artifacts": {
    "filePath": "canvas/design.op",
    " operation": "design_skeleton"
  }
}
```

**Agent Action**: Execute the create file command, then retry with same parameters. If still fails, escalate or stop.

---

## Human-Readable Format (for CLI/Debug Output)

```
✅ SUCCESS: Created skeleton with 1 root frame and 4 sections
   → Artifacts: rootId=abc123, sectionIds=[sec1, sec2, sec3, sec4]
   → Next: Call design_content for each section using sectionId

⚠️ WARNING: design_content: node count (3) below recommended minimum (5)
   → Artifacts: sectionId=sec1, nodeCount=3, recommendedMin=5
   → Next: Add more content nodes to the section

❌ ERROR: design_skeleton requires valid .op file at filePath
   → Error: ENOENT: canvas/design.op not found
   → Root cause: File does not exist or path is incorrect
   → Next: Create file: echo '{"version":"1.0.0","children":[]}' > canvas/design.op
   → Then: Re-run design_skeleton with same parameters
```

---

## MCP Tool Compliance Matrix

| Tool | Returns status | Returns summary | Returns next_actions | Returns artifacts | Notes |
|------|---------------|-----------------|---------------------|-------------------|-------|
| `openpencil_open_document` | ✅ | ✅ | ✅ | ✅ | Use artifact.filePath for subsequent calls |
| `openpencil_design_skeleton` | ✅ | ✅ | ✅ | ✅ | Artifacts include rootId and sectionIds |
| `openpencil_design_content` | ✅ | ✅ | ✅ | ✅ | Artifacts include sectionId and nodeCount |
| `openpencil_design_refine` | ✅ | ✅ | ✅ | ✅ | Artifacts include rootId and fix summary |
| `openpencil_insert_node` | ✅ | ✅ | ✅ | ✅ | Artifacts include nodeId |
| `openpencil_update_node` | ✅ | ✅ | ✅ | ✅ | Artifacts include nodeId |
| `openpencil_delete_node` | ✅ | ✅ | ✅ | ✅ | Artifacts include nodeId |
| `openpencil_read_nodes` | ✅ | ✅ | ✅ | ✅ | Artifacts include nodeCount and filePath |
| `openpencil_batch_get` | ✅ | ✅ | ✅ | ✅ | Artifacts include nodeCount and pageIds |

---

## Agent Implementation Checklist

When implementing or reviewing MCP tools for OpenPencil:

- [ ] `status` field always present (success/warning/error)
- [ ] `summary` field is one clear sentence
- [ ] `next_actions` is an array of actionable steps (not questions)
- [ ] `artifacts` object contains relevant IDs and paths
- [ ] Error responses include retry instructions
- [ ] Success responses indicate what to do next in the workflow
- [ ] Warning responses explain the impact and mitigation

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0.0 | 2026-04-10 | Initial specification |

---

## Related Files

- openpencil_get_design_prompt({ section: "schema" }) - PenNode schema reference
- `.sisyphus/drafts/openpencil-loop-harness-review.md` - Draft review with observation format recommendations (lines 203-235)
