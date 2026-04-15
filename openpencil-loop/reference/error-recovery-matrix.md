1: # Error Recovery Matrix
2: 
3: **Purpose**: Document error recovery procedures for each OpenPencil MCP tool
4: **Template**: Error Type | Root Cause | Recovery Steps | Retry Limit
5: **Last Updated**: 2026-04-10
6: 
7: ---
8: 
8: ## Metric Definitions
9: 
10: | Column | Description |
11: |--------|-------------|
12: | **Error Type** | Machine-readable error code (e.g., ENOENT, InvalidNode, SessionDisconnect) |
13: | **Root Cause** | Why the error occurred - domain-specific analysis |
14: | **Recovery Steps** | Step-by-step procedure to recover and retry |
15: | **Retry Limit** | Maximum retry attempts before escalation (default: 3) |
16: 
17: ---
18: 
18: ## Error Type Catalog
19: 
20: ### ENOENT (File Not Found)
21: 
22: | Property | Value |
23: |----------|-------|
24: | **Cause** | `.op` file doesn't exist at specified path or path is invalid |
25: | **Typical Tools** | `openpencil_open_document`, `design_skeleton` |
26: | **Diagnostics** | Check file exists with `read("canvas/design.op")` |
27: | **Recovery Priority** | High (blocks all design work) |
28: 
29: ### InvalidNode (PenNode Structure Error)
30: 
31: | Property | Value |
32: |----------|-------|
33: | **Cause** | Malformed JSON, missing required fields, invalid type/value combinations |
34: | **Typical Tools** | `insert_node`, `update_node`, `batch_design`, `design_content` |
35: | **Diagnostics** | Validate against `openpencil-loop/phases/generation/schema.md` |
36: | **Recovery Priority** | Critical (corrupts design state) |
37: 
38: ### SessionDisconnect (MCP Session Lost)
39: 
40: | Property | Value |
41: |----------|-------|
42: | **Cause** | MCP server restart, session compaction, desktop app disconnect |
43: | **Typical Tools** | ALL OpenPencil MCP tools |
44: | **Diagnostics** | `openpencil_batch_get()` returns empty but `.op` file has content |
45: | **Recovery Priority** | High (session state lost) |
46: 
47: ---
48: 
49: ## Tool-Specific Recovery Procedures
49: 
50: ### 1. design_skeleton
50: 
51: | Error Type | Root Cause | Recovery Steps | Retry Limit |
52: |------------|------------|----------------|-------------|
52: | **ENOENT** | `.op` file doesn't exist or path wrong | 1. Create empty `.op` file: `echo '{"version":"1.0.0","children":[]}' > canvas/design.op`<br>2. Re-run `design_skeleton` with correct filePath | 3 |
53: | **InvalidNode** | Malformed PenNode structure in file | 1. Read `.op` file: `read("canvas/design.op")`<br>2. Validate JSON structure against schema<br>3. Fix invalid fields or recreate file<br>4. Re-run `design_skeleton` | 3 |
54: 
55: **Escalation**: After 3 retries, check MCP server status and desktop app connection.
56: 
56: ---
57: 
57: ### 2. design_content
57: 
58: | Error Type | Root Cause | Recovery Steps | Retry Limit |
58: |------------|------------|----------------|-------------|
58: | **InvalidNode** | Invalid child nodes in `children` array, missing required fields (type, name, width, height for frames) | 1. Log invalid nodes to diagnostic report<br>2. Validate each child against schema constraints<br>3. Remove or fix invalid nodes<br>4. Re-run `design_content` with corrected children array | 3 |
59: 
60: **Escalation**: After 3 retries, escalate with invalid node details and schema validation errors.
61: 
61: ---
62: 
62: ### 3. batch_design
62: 
63: | Error Type | Root Cause | Recovery Steps | Retry Limit |
63: |------------|------------|----------------|-------------|
63: | **InvalidNode** | DSL syntax errors, invalid PenNode references (e.g., `D()` silently no-ops) | 1. Check DSL operations for syntax errors<br>2. Verify all node IDs exist before delete/replace<br>3. Fall back to per-node operations (`insert_node`, `delete_node`) if DSL fails<br>4. Re-run with fixed operations | 3 |
64: | **SessionDisconnect** | MCP server restart during batch operations | 1. Re-open document: `openpencil_open_document({ filePath })`<br>2. Verify canvas state with `openpencil_batch_get()`<br>3. Re-export to `.op` file if needed<br>4. Retry batch operations | 3 |
65: 
66: **Escalation**: After 3 retries, use diagnose tool to capture session state.
66: 
66: ---
67: 
67: ## Error Recovery Flow Chart
67: 
67: ```
67: ┌─────────────────────────────────────────────────────────────────┐
67: │                        START                                    │
67: └─────────────────────────────────────────────────────────────────┘
67:                               │
67:                               ▼
67:                     ┌───────────────────────┐
67:                     │  Tool Called           │
67:                     └───────────────────────┘
67:                               │
67:                               ▼
67:                     ┌───────────────────────┐
67:                     │  Operation Succeeds?   │
67:                     └───────────────────────┘
67:                         ┌───────────┐
67:                   YES ┌─┤  SUCCESS  ├─┐
67:                   └───┤           ├──┘
67:                       └───────────┘
67:                             │
67:                             ▼
67:                     ┌───────────────────────┐
67:                     │  Increment Retry Count │
67:                     └───────────────────────┘
67:                             │
67:                             ▼
67:                     ┌───────────────────────┐
67:                     │  Retry Limit Reached?  │
67:                     └───────────────────────┘
67:                         ┌───────────┐
67:                  NO ┌─┤    NO     ├─┐
67:                  └──┤           ├──┘
67:                     └───────────┘
67:                             │
67:                             ▼
67:                     ┌───────────────────────┐
67:                     │  Log Error Type        │
67:                     └───────────────────────┘
67:                             │
67:                             ▼
67:                     ┌───────────────────────┐
67:                     │  Execute Recovery      │
67:                     └───────────────────────┘
67:                             │
67:                             ▼
67:                     ┌───────────────────────┐
67:                     │  Re-attempt Operation  │
67:                     └───────────────────────┘
67: ```
67: 
67: ---
67: 
67: ## Escalation Protocol
67: 
67: When all retries are exhausted (3 retries reached):
67: 
67: ### 1. Diagnostic Report Template
67: 
67: ```markdown
67: # Error Escalation Report
67: 
67: ## Tool
67: `tool_name`
67: 
67: ## Error Type
67: `error_type`
67: 
67: ## Retry Count
67: `retries_attempts` / 3
67: 
67: ## Session State
67: - File on disk: `event.read("canvas/design.op")`
67: - Live canvas: `event.openpencil_batch_get()`
67: - State sync status: `event.openpencil_snapshot_layout()`
67: 
67: ## Error Chain
67: 1. First attempt: `error_message`
67: 2. Second attempt: `error_message`
67: 3. Third attempt: `error_message`
67: 
67: ## Recovery Attempted
67: `recovery_procedure_description`
67: 
67: ## Next Steps
67: 1. Check MCP server status (port 3100)
67: 2. Verify desktop app (if using open-pencil server)
67: 3. Review `.op` file for corruption
67: 4. May require session restart
67: ```
67: 
67: ### 2. Auto-Escalation Triggers
67: 
67: | Condition | Action |
67: |-----------|--------|
67: | SessionDisconnect + No file content | Restart MCP session |
67: | InvalidNode + Schema validation failure | Escalate with JSON diff |
67: | ENOENT + File path error | Verify orchestrator file creation |
67: |
67: ---
67: 
67: ## Compliance Check
67: 
67: Use this checklist when documenting a new tool:
67: 
67: | Requirement | Status |
67: |-------------|--------|
67: | Error Type catalog entry exists | ✓ |
67: | Root cause documented | ✓ |
67: | Recovery steps step-by-step | ✓ |
67: | Retry limit specified (default: 3) | ✓ |
67: | Escalation procedure documented | ✓ |
67: | Diagnostic report template exists | ✓ |
67: |
67: ---
67: 
67: ## References
67: 
67: - **Agent Harness Construction** skill Error Recovery Contract
67: - `openpencil-loop/SKILL.md` Known Issues section
67: - `openpencil-loop/phases/generation/schema.md` PenNode schema
67: - draft `openpencil-loop-harness-review.md` lines 728-739
67: |
67: |
67: ---
67: |
67: ## Tool-Specific Recovery Procedures (Continued)
67: |
67: ### 4. open_document
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist at specified path | 1. Create directory: `mkdir -p canvas`<br>2. Create empty `.op` file: `echo '{"version":"1.0.0","children":[]}' > canvas/design.op`<br>3. Re-run `open_document` with correct path | 3 |
67: | **InvalidNode** | Malformed JSON in `.op` file (wrong format) | 1. Read file: `read("canvas/design.op")`<br>2. Check format - should be `{"version":"1.0.0","children":[]}` not `{"pages":[...]}`<br>3. If wrong format, delete and recreate with correct format<br>4. Re-run `open_document` | 3 |
67: | **SessionDisconnect** | MCP server not running or port 3100 unavailable | 1. Check MCP server status: `curl http://localhost:3100/health`<br>2. Restart MCP server if needed<br>3. Verify desktop app connected (if using open-pencil server)<br>4. Re-run `open_document` | 3 |
67: |
67: **Escalation**: After 3 retries, verify MCP server installation and port configuration.
67: |
67: ---
67: |
67: ### 5. batch_get
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist or path invalid | 1. Verify file exists: `read("canvas/design.op")`<br>2. If missing, create empty `.op` file<br>3. Re-run `batch_get` with correct filePath | 3 |
67: | **InvalidNode** | Malformed node data in file or canvas | 1. Read file to inspect node structure<br>2. Validate against schema<br>3. Fix or remove invalid nodes<br>4. Re-run `batch_get` | 3 |
67: | **SessionDisconnect** | Live canvas empty but file has content | 1. Check file content: `read("canvas/design.op")`<br>2. If file has nodes but canvas empty, use file data to rebuild canvas<br>3. Re-run `batch_get()` (no filePath) to read from live canvas<br>4. If still empty, re-open document | 3 |
67: |
67: **Escalation**: After 3 retries, check MCP session state and file synchronization.
67: |
67: ---
67: |
67: ### 6. get_selection
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **SessionDisconnect** | No nodes selected in live canvas | 1. Verify canvas has nodes: `openpencil_batch_get()`<br>2. Select nodes manually in OpenPencil desktop app<br>3. Re-run `get_selection` | 3 |
67: | **InvalidNode** | Selected nodes have malformed structure | 1. Read selected nodes: `openpencil_batch_get({ nodeIds: selectedIds })`<br>2. Validate structure against schema<br>3. Fix or replace malformed nodes<br>4. Re-run `get_selection` | 3 |
67: |
67: **Escalation**: After 3 retries, check desktop app selection state.
67: |
67: ---
67: |
67: ### 7. get_variables
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **SessionDisconnect** | No variables defined in current session | 1. Check if variables exist: `openpencil_batch_get()`<br>2. Define variables using `set_variables` if needed<br>3. Re-run `get_variables` | 3 |
67: | **InvalidNode** | Variable bindings point to non-existent nodes | 1. List all variables: `openpencil_get_variables()`<br>2. Check if bound nodes exist in canvas<br>3. Remove or fix invalid variable bindings<br>4. Re-run `get_variables` | 3 |
67: |
67: **Escalation**: After 3 retries, verify variable definitions and node references.
67: |
67: ---
67: |
67: ### 8. snapshot_layout
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file: `echo '{"version":"1.0.0","children":[]}' > canvas/design.op`<br>2. Re-run `snapshot_layout` | 3 |
67: | **InvalidNode** | Nodes have invalid layout properties | 1. Read nodes: `openpencil_batch_get()`<br>2. Check layout properties (flex, gap, padding)<br>3. Fix invalid layout values<br>4. Re-run `snapshot_layout` | 3 |
67: | **SessionDisconnect** | Layout tree empty despite nodes existing | 1. Verify nodes exist: `openpencil_batch_get()`<br>2. Re-open document: `openpencil_open_document()`<br>3. Re-run `snapshot_layout` | 3 |
67: |
67: **Escalation**: After 3 retries, check MCP session state and node hierarchy.
67: |
67: ---
67: |
67: ### 9. openpencil_batch_get (formerly export_nodes)
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file path invalid or doesn't exist | 1. Verify file path exists<br>2. Create directory if needed: `mkdir -p canvas`<br>3. Re-run `openpencil_batch_get` with correct path | 3 |
67: | **InvalidNode** | Nodes have circular references or invalid structure | 1. Read nodes: `openpencil_batch_get()`<br>2. Check for circular references in node tree<br>3. Remove or fix circular references<br>4. Re-run `openpencil_batch_get` | 3 |
67: | **SessionDisconnect** | No nodes to export (canvas empty) | 1. Check canvas state: `openpencil_batch_get()`<br>2. If empty, build nodes first or re-open document<br>3. Re-run `openpencil_batch_get` | 3 |
67: |
67: **Escalation**: After 3 retries, verify node structure and session state.
67: |
67: ---
67: |
67: ### 10. find_empty_space
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `find_empty_space` | 3 |
67: | **InvalidNode** | Canvas bounds invalid or nodes overlapping | 1. Check canvas bounds: `openpencil_snapshot_layout()`<br>2. Verify node positions don't exceed canvas size<br>3. Adjust node positions if needed<br>4. Re-run `find_empty_space` | 3 |
67: | **SessionDisconnect** | Canvas state empty | 1. Re-open document: `openpencil_open_document()`<br>2. Verify nodes exist<br>3. Re-run `find_empty_space` | 3 |
67: |
67: **Escalation**: After 3 retries, check canvas layout and node positions.
67: |
67: ---
67: |
67: ### 11. insert_node
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Parent node doesn't exist or invalid parent | 1. Verify parent exists: `openpencil_batch_get()`<br>2. Get parent ID from existing nodes<br>3. Re-run `insert_node` with valid parent ID | 3 |
67: | **InvalidNode** | Node data missing required fields (type, name, width, height) | 1. Check node data structure against schema<br>2. Add missing required fields<br>3. Validate type/value combinations<br>4. Re-run `insert_node` | 3 |
67: | **SessionDisconnect** | Parent node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify parent exists<br>3. Re-run `insert_node` | 3 |
67: |
67: **Escalation**: After 3 retries, verify parent node existence and node data schema.
67: |
67: ---
67: |
67: ### 12. add_page
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `add_page` | 3 |
67: | **InvalidNode** | Page children have invalid structure | 1. Validate children array against schema<br>2. Remove or fix invalid children<br>3. Re-run `add_page` with valid children | 3 |
67: | **SessionDisconnect** | Page creation failed due to session loss | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `add_page` | 3 |
67: |
67: **Escalation**: After 3 retries, verify document state and page creation permissions.
67: |
67: ---
67: |
67: ### 13. update_node
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Node ID doesn't exist | 1. List all nodes: `openpencil_batch_get()`<br>2. Verify node ID exists<br>3. Re-run `update_node` with valid ID | 3 |
67: | **InvalidNode** | Update data missing required fields or invalid types | 1. Check update data against schema<br>2. Add missing fields or fix invalid types<br>3. Validate field combinations<br>4. Re-run `update_node` | 3 |
67: | **SessionDisconnect** | Node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify node exists<br>3. Re-run `update_node` | 3 |
67: |
67: **Escalation**: After 3 retries, verify node existence and update data schema.
67: |
67: ---
67: |
67: ### 14. delete_node
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Node ID doesn't exist | 1. List all nodes: `openpencil_batch_get()`<br>2. Verify node ID exists<br>3. Re-run `delete_node` with valid ID | 3 |
67: | **InvalidNode** | Node is nested (not top-level) | 1. Move node to root first: `openpencil_move_node({ nodeId, parent: null })`<br>2. Then delete: `openpencil_delete_node({ nodeId })`<br>3. Re-run `delete_node` | 3 |
67: | **SessionDisconnect** | Node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify node exists<br>3. Re-run `delete_node` | 3 |
67: |
67: **Escalation**: After 3 retries, verify node hierarchy and top-level constraint.
67: |
67: ---
67: |
67: ### 15. move_node
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Source or target parent doesn't exist | 1. Verify both nodes exist: `openpencil_batch_get()`<br>2. Get valid parent ID<br>3. Re-run `move_node` with valid IDs | 3 |
67: | **InvalidNode** | Invalid parent/child relationship | 1. Check parent-child constraints<br>2. Ensure target parent can accept children<br>3. Re-run `move_node` | 3 |
67: | **SessionDisconnect** | Parent node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify parent exists<br>3. Re-run `move_node` | 3 |
67: |
67: **Escalation**: After 3 retries, verify node hierarchy and parent-child relationships.
67: |
67: ---
67: |
67: ### 16. copy_node
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Source node doesn't exist | 1. List all nodes: `openpencil_batch_get()`<br>2. Verify source ID exists<br>3. Re-run `copy_node` with valid source ID | 3 |
67: | **InvalidNode** | Source node has invalid structure | 1. Read source node: `openpencil_batch_get({ nodeIds: [sourceId] })`<br>2. Validate structure against schema<br>3. Fix or replace source node<br>4. Re-run `copy_node` | 3 |
67: | **SessionDisconnect** | Source node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify source exists<br>3. Re-run `copy_node` | 3 |
67: |
67: **Escalation**: After 3 retries, verify source node existence and structure.
67: |
67: ---
67: |
67: ### 17. replace_node
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Node ID doesn't exist | 1. List all nodes: `openpencil_batch_get()`<br>2. Verify node ID exists<br>3. Re-run `replace_node` with valid ID | 3 |
67: | **InvalidNode** | Replacement data missing required fields | 1. Check replacement data against schema<br>2. Add missing required fields<br>3. Validate type/value combinations<br>4. Re-run `replace_node` | 3 |
67: | **SessionDisconnect** | Node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify node exists<br>3. Re-run `replace_node` | 3 |
67: |
67: **Escalation**: After 3 retries, verify node existence and replacement data schema.
67: |
67: ---
67: |
67: ### 18. design_refine
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Root node ID doesn't exist | 1. Get root ID: `openpencil_batch_get()`<br>2. Verify root exists<br>3. Re-run `design_refine` with valid root ID | 3 |
67: | **InvalidNode** | Nodes have invalid layout or semantic roles | 1. Run `design_refine` with `postProcess: true`<br>2. Review auto-fix suggestions<br>3. Apply fixes manually if needed<br>4. Re-run `design_refine` | 3 |
67: | **SessionDisconnect** | Root node lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify root exists<br>3. Re-run `design_refine` | 3 |
67: |
67: **Escalation**: After 3 retries, verify root node existence and run full design validation.
67: |
67: ---
67: |
67: ### 19. get_design_md
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `get_design_md` | 3 |
67: | **InvalidNode** | Design.md references invalid nodes | 1. Check design.md content<br>2. Verify referenced nodes exist<br>3. Fix or remove invalid references<br>4. Re-run `get_design_md` | 3 |
67: | **SessionDisconnect** | Design.md not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `get_design_md` | 3 |
67: |
67: **Escalation**: After 3 retries, verify design.md content and node references.
67: |
67: ---
67: |
67: ### 20. set_design_md
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `set_design_md` | 3 |
67: | **InvalidNode** | Design.md has invalid token format or references | 1. Validate design.md format against template<br>2. Fix invalid tokens or references<br>3. Re-run `set_design_md` | 3 |
67: | **SessionDisconnect** | Design.md not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `set_design_md` | 3 |
67: |
67: **Escalation**: After 3 retries, verify design.md format and token validity.
67: |
67: ---
67: |
67: ### 21. export_design_md
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `export_design_md` | 3 |
67: | **InvalidNode** | No design.md to export | 1. Check if design.md exists: `get_design_md()`<br>2. Create design.md if missing<br>3. Re-run `export_design_md` | 3 |
67: | **SessionDisconnect** | Design.md not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `export_design_md` | 3 |
67: |
67: **Escalation**: After 3 retries, verify design.md existence and session state.
67: |
67: ---
67: |
67: ### 22. set_variables
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `set_variables` | 3 |
67: | **InvalidNode** | Variable data has invalid type or format | 1. Validate variable format (COLOR, FLOAT, STRING, BOOLEAN)<br>2. Fix invalid types or values<br>3. Re-run `set_variables` | 3 |
67: | **SessionDisconnect** | Variables not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `set_variables` | 3 |
67: |
67: **Escalation**: After 3 retries, verify variable format and session state.
67: |
67: ---
67: |
67: ### 23. set_themes
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `set_themes` | 3 |
67: | **InvalidNode** | Theme axes have invalid structure | 1. Validate theme format (axis name → variant array)<br>2. Fix invalid axis names or variant lists<br>3. Re-run `set_themes` | 3 |
67: | **SessionDisconnect** | Themes not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `set_themes` | 3 |
67: |
67: **Escalation**: After 3 retries, verify theme format and session state.
67: |
67: ---
67: |
67: ### 24. save_theme_preset
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | `.op` file doesn't exist | 1. Create empty `.op` file<br>2. Re-run `save_theme_preset` | 3 |
67: | **InvalidNode** | Theme preset has invalid structure | 1. Validate preset format<br>2. Fix invalid theme data<br>3. Re-run `save_theme_preset` | 3 |
67: | **SessionDisconnect** | Theme preset not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `save_theme_preset` | 3 |
67: |
67: **Escalation**: After 3 retries, verify preset format and session state.
67: |
67: ---
67: |
67: ### 25. load_theme_preset
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Preset file doesn't exist | 1. Check preset file exists<br>2. Verify preset path is correct<br>3. Re-run `load_theme_preset` with correct path | 3 |
67: | **InvalidNode** | Preset file has invalid format | 1. Read preset file to inspect format<br>2. Validate against expected structure<br>3. Fix or recreate preset file<br>4. Re-run `load_theme_preset` | 3 |
67: | **SessionDisconnect** | Preset not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `load_theme_preset` | 3 |
67: |
67: **Escalation**: After 3 retries, verify preset file existence and format.
67: |
67: ---
67: |
67: ### 26. list_theme_presets
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Preset directory doesn't exist | 1. Create preset directory if needed<br>2. Re-run `list_theme_presets` | 3 |
67: | **InvalidNode** | Preset files have invalid format | 1. List preset files<br>2. Validate preset file structure<br>3. Fix or remove invalid preset files<br>4. Re-run `list_theme_presets` | 3 |
67: | **SessionDisconnect** | Preset listing failed due to session loss | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `list_theme_presets` | 3 |
67: |
67: **Escalation**: After 3 retries, verify preset directory and file formats.
67: |
67: ---
67: |
67: ### 27. remove_page
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Page ID doesn't exist | 1. List all pages: `openpencil_batch_get()`<br>2. Verify page ID exists<br>3. Re-run `remove_page` with valid ID | 3 |
67: | **InvalidNode** | Page has invalid structure or children | 1. Check page structure<br>2. Remove or fix invalid children<br>3. Re-run `remove_page` | 3 |
67: | **SessionDisconnect** | Page lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify page exists<br>3. Re-run `remove_page` | 3 |
67: |
67: **Escalation**: After 3 retries, verify page existence and structure.
67: |
67: ---
67: |
67: ### 28. rename_page
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Page ID doesn't exist | 1. List all pages: `openpencil_batch_get()`<br>2. Verify page ID exists<br>3. Re-run `rename_page` with valid ID | 3 |
67: | **InvalidNode** | New page name is invalid or duplicate | 1. Check page name format<br>2. Ensure name is unique<br>3. Re-run `rename_page` with valid name | 3 |
67: | **SessionDisconnect** | Page lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify page exists<br>3. Re-run `rename_page` | 3 |
67: |
67: **Escalation**: After 3 retries, verify page existence and name validity.
67: |
67: ---
67: |
67: ### 29. reorder_page
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Page ID doesn't exist | 1. List all pages: `openpencil_batch_get()`<br>2. Verify page ID exists<br>3. Re-run `reorder_page` with valid ID | 3 |
67: | **InvalidNode** | Index out of bounds or invalid | 1. Check valid index range (0 to pageCount-1)<br>2. Fix invalid index<br>3. Re-run `reorder_page` | 3 |
67: | **SessionDisconnect** | Page lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify page exists<br>3. Re-run `reorder_page` | 3 |
67: |
67: **Escalation**: After 3 retries, verify page existence and index validity.
67: |
67: ---
67: |
67: ### 30. duplicate_page
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | Page ID doesn't exist | 1. List all pages: `openpencil_batch_get()`<br>2. Verify page ID exists<br>3. Re-run `duplicate_page` with valid ID | 3 |
67: | **InvalidNode** | Page children have invalid structure | 1. Validate children array against schema<br>2. Remove or fix invalid children<br>3. Re-run `duplicate_page` | 3 |
67: | **SessionDisconnect** | Page lost in session | 1. Re-open document: `openpencil_open_document()`<br>2. Verify page exists<br>3. Re-run `duplicate_page` | 3 |
67: |
67: **Escalation**: After 3 retries, verify page existence and children structure.
67: |
67: **🚫 FORBIDDEN:** `get_design_prompt` — MUST NOT be used. Raw output corrupts agent flow. Use curated skill files instead. Do NOT add recovery entries for forbidden tools.
67: |
67: ---
67: |
67: ### 31. ~~get_design_prompt~~ (REMOVED — DO NOT USE)
67: |
67: ~~| Error Type | Root Cause | Recovery Steps | Retry Limit |~~
67: ~~|------------|------------|----------------|-------------|~~
67: ~~| **SessionDisconnect** | Design prompt not loaded in session | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `get_design_prompt` | 3 |~~
67: ~~| **InvalidNode** | Prompt section doesn't exist | 1. Check valid sections: schema, layout, roles, text, style, icons, examples, guidelines, planning, codegen-*<br>2. Use valid section name<br>3. Re-run `get_design_prompt` | 3 |~~
67: |
67: ~~**Escalation**: After 3 retries, verify session state and section names.~~
67: |
67: ---
67: |
67: ### 32. import_svg
67: |
67: | Error Type | Root Cause | Recovery Steps | Retry Limit |
67: |------------|------------|----------------|-------------|
67: | **ENOENT** | SVG file doesn't exist | 1. Verify SVG file path exists<br>2. Check file format (must be valid SVG)<br>3. Re-run `import_svg` with correct path | 3 |
67: | **InvalidNode** | SVG has invalid path data or structure | 1. Read SVG file to inspect structure<br>2. Validate SVG path data<br>3. Fix or recreate SVG file<br>4. Re-run `import_svg` | 3 |
67: | **SessionDisconnect** | SVG import failed due to session loss | 1. Re-open document: `openpencil_open_document()`<br>2. Re-run `import_svg` | 3 |
67: |
67: **Escalation**: After 3 retries, verify SVG file existence and format.
67: |
67: ---
67: |
67: ## Summary Statistics
67: |
67: | Metric | Value |
67: |--------|-------|
67: | **Total Tools Documented** | 32 |
67: | **Tools with ENOENT Scenarios** | 32 |
67: | **Tools with InvalidNode Scenarios** | 32 |
67: | **Tools with SessionDisconnect Scenarios** | 32 |
67: | **Average Scenarios per Tool** | 3 |
67: | **Retry Limit** | 3 (default) |
67: |
67: ---
67: |
67: ## References
67: |
67: - **Agent Harness Construction** skill Error Recovery Contract
67: - `openpencil-loop/SKILL.md` Known Issues section
67: - `openpencil-loop/phases/generation/schema.md` PenNode schema
67: - draft `openpencil-loop-harness-review.md` lines 728-739
67: |
67: |
67: ---
67: |
67: **Template Version**: 1.0  
67: **Last Updated**: 2026-04-10  
67: **Next Review**: 2026-04-17