# Observation Contract Wrapper Module

## Purpose

Standardized output transformation for MCP tool results. Every MCP tool call in the openpencil-loop workflow must be wrapped through one of these templates before the result is consumed downstream.

Wrappers enforce a consistent contract:

```json
{
  "status": "OK | FAIL",
  "summary": "Human-readable summary of what happened",
  "next_actions": ["Recommended next step 1", "Recommended next step 2"],
  "artifacts": {
    "created": ["node-id-1"],
    "modified": ["node-id-2"],
    "deleted": []
  }
}
```

**Status rules:**
- `OK` — tool returned successfully with expected output
- `FAIL` — tool threw an error, returned degraded output, or validation checks failed

**When to wrap:**
- Every P0 tool call must be wrapped before any downstream logic reads the result
- P1 tool calls should be wrapped when used inside orchestration loops or multi-step workflows

---

## Wrapper Templates

### design_skeleton Wrapper

**P0 — Critical**

Raw tool output contains section IDs and guidelines. The wrapper extracts section mapping and validates all expected sections were created.

```
Wrap logic:
  1. Check response contains `sections` array with length > 0
  2. Verify each section has a non-empty `id` and `name`
  3. Collect all section IDs into artifacts.created
  4. If rootFrame ID present, add to artifacts.created
  5. On any missing field → status FAIL with diagnostic message
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "sections": [
    { "id": "sec-1", "name": "Hero", "role": "hero-section" },
    { "id": "sec-2", "name": "Features", "role": "features-section" },
    { "id": "sec-3", "name": "CTA", "role": "cta-section" }
  ],
  "rootFrame": { "id": "root-0" }
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Skeleton created with 3 sections: Hero, Features, CTA under root frame root-0",
  "next_actions": [
    "Run design_content for section Hero (sec-1)",
    "Run design_content for section Features (sec-2)",
    "Run design_content for section CTA (sec-3)"
  ],
  "artifacts": {
    "created": ["root-0", "sec-1", "sec-2", "sec-3"],
    "modified": [],
    "deleted": []
  }
}
```

**Failure case:**
```json
{
  "status": "FAIL",
  "summary": "design_skeleton returned 0 sections — root frame may exist but layout is empty",
  "next_actions": [
    "Retry design_skeleton with corrected section definitions",
    "Check section array is non-empty in the input parameters"
  ],
  "artifacts": {
    "created": [],
    "modified": [],
    "deleted": []
  }
}
```

---

### design_content Wrapper

**P0 — Critical**

Raw tool output contains inserted count, warnings, and a depth-limited snapshot. The wrapper validates insertion succeeded and surfaces warnings as next actions.

```
Wrap logic:
  1. Check `inserted` count > 0 (zero insertions is a FAIL)
  2. Collect warnings array — if non-empty, add each as a next_action prefixed with "WARNING: "
  3. Extract node IDs from the snapshot children and add to artifacts.created
  4. If snapshot is missing or empty → status FAIL
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "inserted": 5,
  "warnings": ["Text node 'subtitle' exceeded frame width — truncated"],
  "snapshot": {
    "id": "sec-1",
    "children": [
      { "id": "node-a", "type": "text" },
      { "id": "node-b", "type": "frame" },
      { "id": "node-c", "type": "text" },
      { "id": "node-d", "type": "rectangle" },
      { "id": "node-e", "type": "image" }
    ]
  }
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Inserted 5 nodes into section sec-1 with 1 warning(s)",
  "next_actions": [
    "WARNING: Text node 'subtitle' exceeded frame width — truncated",
    "Proceed to design_content for next section or run design_refine"
  ],
  "artifacts": {
    "created": ["node-a", "node-b", "node-c", "node-d", "node-e"],
    "modified": [],
    "deleted": []
  }
}
```

**Failure case:**
```json
{
  "status": "FAIL",
  "summary": "design_content inserted 0 nodes into section sec-2 — children array may be empty or invalid",
  "next_actions": [
    "Check children array contains valid PenNode objects",
    "Verify sectionId sec-2 exists and is a frame node",
    "Retry with corrected content definition"
  ],
  "artifacts": {
    "created": [],
    "modified": [],
    "deleted": []
  }
}
```

---

### design_refine Wrapper

**P0 — Critical**

Raw tool output contains a fixes list and layout snapshot. The wrapper validates the refine pass completed and surfaces each fix as informational context.

```
Wrap logic:
  1. Check response contains `fixes` array (may be empty — that's OK, means no fixes needed)
  2. Count fixes by category for summary
  3. If fixes applied → add modified rootFrame ID to artifacts.modified
  4. If response is missing or malformed → status FAIL
  5. Always include next_action to verify result visually or proceed to codegen
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "fixes": [
    "card-row: equalized 3 card heights to 280px",
    "overflow: enabled clipContent on frame node-12",
    "icon: resolved lucide:arrow-right → vector path"
  ],
  "snapshot": {
    "id": "root-0",
    "children": ["..."]
  }
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Refine pass completed with 3 fixes: card-row equalization, overflow fix, icon resolution",
  "next_actions": [
    "Visually verify the refined design matches expectations",
    "Proceed to code generation or export"
  ],
  "artifacts": {
    "created": [],
    "modified": ["root-0"],
    "deleted": []
  }
}
```

**Zero-fixes case (still OK):**
```json
{
  "status": "OK",
  "summary": "Refine pass completed — no fixes needed, design is clean",
  "next_actions": [
    "Proceed to code generation or export"
  ],
  "artifacts": {
    "created": [],
    "modified": [],
    "deleted": []
  }
}
```

---

### insert_node Wrapper

**P1 — High Priority**

Raw tool output returns the final node state after post-processing. The wrapper confirms the node was created and captures its ID.

```
Wrap logic:
  1. Check response contains a valid `id` field
  2. If auto-replace happened (root-level frame), note in summary
  3. Add node ID to artifacts.created
  4. If response is null or missing ID → status FAIL
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "id": "new-42",
  "type": "frame",
  "name": "Card",
  "width": 320,
  "height": 200,
  "children": []
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Created frame node 'Card' (new-42) — 320x200px",
  "next_actions": [
    "Populate children if needed, or proceed with next operation"
  ],
  "artifacts": {
    "created": ["new-42"],
    "modified": [],
    "deleted": []
  }
}
```

---

### batch_design Wrapper

**P1 — High Priority**

Raw tool output returns results for each DSL operation. The wrapper aggregates successes and failures across all operations.

```
Wrap logic:
  1. Iterate all operation results
  2. Count successful inserts, updates, copies vs failures
  3. Collect all created/modified/deleted IDs
  4. If any operation failed → status FAIL with partial success noted in summary
  5. If all succeeded → status OK
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "results": [
    { "operation": "I", "binding": "header", "id": "b1", "success": true },
    { "operation": "I", "binding": "body", "id": "b2", "success": true },
    { "operation": "U", "id": "b1", "success": true },
    { "operation": "I", "binding": "footer", "id": "b3", "success": true }
  ]
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Batch design completed: 3 inserts, 1 update — all succeeded",
  "next_actions": [
    "Run design_refine to validate and auto-fix the batch output"
  ],
  "artifacts": {
    "created": ["b1", "b2", "b3"],
    "modified": ["b1"],
    "deleted": []
  }
}
```

**Partial failure case:**
```json
{
  "status": "FAIL",
  "summary": "Batch design partially failed: 2 of 3 inserts succeeded, 1 failed (footer: invalid parent)",
  "next_actions": [
    "Review failed operation for footer — parent ID may not exist",
    "Fix the DSL and re-run the failed operation",
    "Run design_refine on successfully created nodes"
  ],
  "artifacts": {
    "created": ["b1", "b2"],
    "modified": [],
    "deleted": []
  }
}
```

---

### update_node Wrapper

**P1 — High Priority**

Raw tool output returns the updated node state. The wrapper confirms the update applied and captures the changed fields.

```
Wrap logic:
  1. Check response contains the target `id`
  2. Compare returned fields against expected changes (if known)
  3. Add node ID to artifacts.modified
  4. If response is null or unchanged → status FAIL
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "id": "node-7",
  "type": "text",
  "content": "Updated heading",
  "fontSize": 32,
  "fontWeight": "Bold"
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Updated text node 'node-7' — content and font properties changed",
  "next_actions": [
    "Verify visual output if this is a user-facing change"
  ],
  "artifacts": {
    "created": [],
    "modified": ["node-7"],
    "deleted": []
  }
}
```

---

### open_document Wrapper

**P1 — High Priority**

Raw tool output returns document metadata, context summary, and design prompt. The wrapper confirms the connection is live and extracts key metadata.

```
Wrap logic:
  1. Check response contains non-empty `metadata` or `context`
  2. Extract page count and current page name for summary
  3. If design prompt present, note it is available
  4. If response is empty or connection failed → status FAIL
```

**Raw → Wrapped Example:**

Raw:
```json
{
  "metadata": {
    "name": "My Design",
    "pages": 3,
    "currentPage": "Home"
  },
  "context": "Design for a SaaS landing page...",
  "designPrompt": "..."
}
```

Wrapped:
```json
{
  "status": "OK",
  "summary": "Connected to document 'My Design' — 3 pages, current page: Home",
  "next_actions": [
    "Read current page structure with batch_get or snapshot_layout",
    "Load design prompt for context-aware generation"
  ],
  "artifacts": {
    "created": [],
    "modified": [],
    "deleted": []
  }
}
```

**Failure case:**
```json
{
  "status": "FAIL",
  "summary": "open_document returned empty response — canvas may not be running or file path is invalid",
  "next_actions": [
    "Verify OpenPencil desktop app is running",
    "Check file path is correct and accessible",
    "Retry connection"
  ],
  "artifacts": {
    "created": [],
    "modified": [],
    "deleted": []
  }
}
```

---

## Usage Instructions

### In Orchestrator Workflows

Apply wrappers immediately after each MCP tool call, before branching or conditional logic:

```
1. Call MCP tool (e.g., design_skeleton)
2. Pass raw result through the corresponding wrapper template
3. If status == FAIL → halt or retry per error guidance
4. If status == OK → use artifacts and next_actions to drive the next step
```

### In Subagent Prompts

Include the relevant wrapper contract in the subagent's task prompt so the subagent knows how to structure its output:

```
Your output for design_skeleton must follow this contract:
{ status, summary, next_actions, artifacts }
See observation-wrapper.md for the full template.
```

### In Validation Gates

Use wrapped outputs as gate conditions between phases:

```
Phase gate: design_skeleton complete?
  → Check observation.status == "OK"
  → Check observation.artifacts.created includes all expected section IDs
  → If not → retry or escalate
```

### Combining Multiple Tool Calls

When a workflow step calls multiple tools sequentially, wrap each individually, then produce a combined observation:

```json
{
  "status": "OK",
  "summary": "Skeleton + content + refine pipeline completed for 3 sections",
  "next_actions": ["Visual verification", "Export or codegen"],
  "artifacts": {
    "created": ["root-0", "sec-1", "sec-2", "sec-3", "node-a", "node-b"],
    "modified": [],
    "deleted": []
  },
  "sub_observations": [
    { "tool": "design_skeleton", "status": "OK" },
    { "tool": "design_content", "status": "OK", "count": 3 },
    { "tool": "design_refine", "status": "OK", "fixes": 3 }
  ]
}
```
