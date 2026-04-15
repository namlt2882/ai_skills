# Tool Decision Tree

**Purpose:** Choose the correct OpenPencil MCP tool when overlapping options exist.

**Context:** Multiple tools can achieve similar goals. This guide helps agents pick the right tool based on operation type and scope.

**Source:** Based on agent harness construction review findings - overlapping tool semantics were identified as a weakness (see `.sisyphus/drafts/openpencil-loop-harness-review.md` lines 90-117).

---

## Decision Matrix

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    TOOL SELECTION DECISION TREE                           │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  Goal → Operation Type → Scale → Tool Choice                             │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Insert Operations

### Decision Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  INSERT NODE - Which tool to use?                                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  START                                                                    │
│       ↓                                                                   │
│  Q1: Building ENTIRE page from scratch?                                  │
│       │                                                                   │
│       └─ YES → design_content (layered workflow)                        │
│                 ↓                                                         │
│                 1. Call design_skeleton first                           │
│                 2. Then call design_content for each section            │
│                 3. Finally call design_refine for validation            │
│                 ↓                                                         │
│                 Result: Full page with validated structure              │
│                                                                           │
│       └─ NO → Continue...                                                 │
│                                                                           │
│  Q2: Adding SINGLE node to EXISTING structure?                           │
│       │                                                                   │
│       └─ YES → insert_node                                                │
│                 ↓                                                         │
│                 - Simple, validated insertion                            │
│                 - Validated PenNode structure                            │
│                 - Auto-apply postProcess if needed                      │
│                 ↓                                                         │
│                 Result: Single node added to canvas                      │
│                                                                           │
│       └─ NO → Continue...                                                 │
│                                                                           │
│  Q3: Adding MULTIPLE nodes atomically?                                   │
│       │                                                                   │
│       └─ YES → batch_design I()                                           │
│                 ↓                                                         │
│                 - All-or-nothing operation                               │
│                 - DSL format: root=I(parent, {...})                      │
│                 - Performance: single MCP call                           │
│                 ↓                                                         │
│                 Result: Multiple nodes added atomically                  │
│                                                                           │
│       └─ NO → Use insert_node multiple times (not atomic)               │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### Concrete Rules

| Condition | Tool | DSL/Params | Example |
|-----------|------|------------|---------|
| Building entire page | `design_skeleton` + `design_content` + `design_refine` | Layered workflow | `design_skeleton({ rootFrame, sections })` → `design_content({ sectionId, children })` |
| Adding 1 node | `insert_node` | `insert_node({ parent, data })` | `insert_node({ parent: "sec1", data: { type: "text", content: "Hello" } })` |
| Adding multiple nodes atomically | `batch_design I()` | DSL format | `batch_design({ operations: "root=I(null, {...})" })` |
| Adding multiple nodes non-atomically | `insert_node` (multiple calls) | Repeat calls | Call `insert_node` in loop |

### When NOT to use `design_content`

```
 Avoid design_content when:
   ✖ Building individual components (use insert_node instead)
   ✖ Adding nodes outside layered workflow (use insert_node or batch_design)
   ✖ Making small updates (use update_node instead)
```

---

## Update Operations

### Decision Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  UPDATE NODE - Which tool to use?                                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  START                                                                    │
│       ↓                                                                   │
│  Q1: Updating SINGLE existing node?                                      │
│       │                                                                   │
│       └─ YES → update_node                                                │
│                 ↓                                                         │
│                 - Partial merge (only provided props update)            │
│                 - Safe for single node                                   │
│                 - Preserves unmentioned properties                       │
│                 ↓                                                         │
│                 Result: Single node updated                              │
│                                                                           │
│       └─ NO → Continue...                                                 │
│                                                                           │
│  Q2: Updating MULTIPLE nodes atomically?                                 │
│       │                                                                   │
│       └─ YES → batch_design U()                                           │
│                 ↓                                                         │
│                 - All-or-nothing operation                               │
│                 - DSL format: U(path, {...})                             │
│                 - Performance: single MCP call                           │
│                 ↓                                                         │
│                 Result: Multiple nodes updated atomically                │
│                                                                           │
│       └─ NO → Apply updates individually with update_node               │
│                                                                           │
│  Q3: Replacing entire node structure?                                    │
│       │                                                                   │
│       └─ YES → replace_node                                               │
│                 ↓                                                         │
│                 - Deletes old node completely                            │
│                 - Inserts new node with fresh data                       │
│                 - New IDs generated                                      │
│                 ↓                                                         │
│                 Result: Node completely replaced                         │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### Concrete Rules

| Condition | Tool | DSL/Params | Example |
|-----------|------|------------|---------|
| Updating 1 node (partial) | `update_node` | `update_node({ nodeId, data })` | `update_node({ nodeId: "node1", data: { width: 200 } })` |
| Updating multiple nodes atomically | `batch_design U()` | DSL format | `batch_design({ operations: 'U("node1", {width: 200})' })` |
| Replacing entire node structure | `replace_node` | `replace_node({ nodeId, data })` | `replace_node({ nodeId: "node1", data: { type: "rectangle", ... } })` |

### When NOT to use `batch_design U()`

```
 Avoid batch_design U() when:
   ✖ Updating single nodes (use update_node instead)
   ✖ Making quick one-off updates (update_node is simpler)
   ✖ Need granular error recovery per node (update_node returns individual results)
```

---

## Delete Operations

### Decision Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  DELETE NODE - Which tool to use?                                       │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  START                                                                    │
│       ↓                                                                   │
│  ⚠️ CRITICAL: batch_design D() SILENTLY NO-OPS                          │
│       ↓                                                                   │
│  ALWAYS USE: delete_node                                                │
│       ↓                                                                   │
│  For SINGLE node deletion: delete_node(nodeId)                          │
│       ↓                                                                   │
│  Result: Node deleted with error handling                               │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### Concrete Rules

| Condition | Tool | DSL/Params | Example |
|-----------|------|------------|---------|
| Deleting single node | `delete_node` | `delete_node({ nodeId })` | `delete_node({ nodeId: "node1" })` |
| Deleting multiple nodes | `delete_node` (multiple calls) | Repeat calls | Call `delete_node` for each nodeId |

### Why `delete_node` Always

```
PROBLEM: batch_design DSL's D() operation silently fails (no-ops)
  - MCP server does not implement D() in batch DSL
  - No error message or warning returned
  - Agent thinks deletion succeeded when it didn't

SOLUTION: Always use delete_node(nodeId)
  - Proper error handling
  - Clear success/failure response
  - Atomic single-node deletion
```

---

## Bulk Operations

### Decision Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│  BULK OPERATIONS - Which tool to use?                                   │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  START                                                                    │
│       ↓                                                                   │
│  Q1: Are ALL operations the SAME type?                                   │
│       │                                                                   │
│       └─ YES → batch_design (all I() or all U())                        │
│                 ↓                                                         │
│                 - Atomic: all succeed or all fail                        │
│                 - Performance: single MCP call                           │
│                 - DSL: compact operations string                         │
│                 ↓                                                         │
│                 Result: Atomic bulk operation                            │
│                                                                           │
│       └─ NO → Use individual tools in parallel                          │
│                 ↓                                                         │
│                 - Different operations per tool                          │
│                 - Run insert_node, update_node, etc. in parallel        │
│                 - Manual atomicity control                               │
│                 ↓                                                         │
│                 Result: Mixed operations (not atomic)                   │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### Concrete Rules

| Scenario | Tool | DSL/Params | Example |
|----------|------|------------|---------|
| Multiple inserts only | `batch_design` with `I()` | `operations: "a=I(p1,...)\nb=I(p2,...)"` | Insert all nodes in one call |
| Multiple updates only | `batch_design` with `U()` | `operations: 'U("n1", {...})\nU("n2", {...})'` | Update all nodes in one call |
| Mixed operations | Individual tools | `insert_node`, `update_node`, etc. | Call each tool separately |
| Complex nested structures | `design_skeleton` + `design_content` | Layered workflow | Build entire page with validation |

### When NOT to use `batch_design`

```
 Avoid batch_design when:
   ✖ Operations are mixed types (I, U, D) - use individual tools
   ✖ Need different error handling per operation
   ✖ Batch size exceeds 10-15 operations (break into chunks)
   ✖ Debugging - individual tools provide clearer error messages
```

---

## 5 Key Decision Scenarios

### Scenario 1: Build Dashboard Page from Scratch

```
Goal: Create complete dashboard with header, stats, charts sections

Decision Tree:
  Q1: Building ENTIRE page from scratch? YES
  → Use: design_skeleton → design_content → design_refine

Workflow:
  1. openpencil_design_skeleton({
       canvasWidth: 1200,
       rootFrame: { name: "Dashboard", width: 1200, height: 0 },
       sections: [
         { name: "Header", height: 64, role: "navbar" },
         { name: "Stats", height: 200, role: "stats-grid" },
         { name: "Charts", height: 0, role: "chart-container" }
       ]
     })
  → Returns: { rootId, sections: [{ id: "sec1", ... }, ...] }

  2. openpencil_design_content({
       sectionId: "sec1",
       children: [headerText, navItems],
       postProcess: true
     })

  3. openpencil_design_content({
       sectionId: "sec2",
       children: [statCards],
       postProcess: true
     })

  4. openpencil_design_content({
       sectionId: "sec3",
       children: [charts],
       postProcess: true
     })

  5. openpencil_design_refine({ rootId: "rootId" })
  → Validates structure, auto-fixes, returns fixes applied
```

### Scenario 2: Add Single Card to Existing Section

```
Goal: Add a new stats card to existing dashboard

Decision Tree:
  Q1: Building ENTIRE page? NO
  Q2: Adding SINGLE node? YES
  → Use: insert_node

Workflow:
  openpencil_insert_node({
    parent: "statSectionId",
    data: {
      type: "rectangle",
      name: "StatCard",
      width: 240,
      height: 120,
      fill: [{ type: "solid", color: "#FFFFFF" }],
      cornerRadius: 8,
      children: [
        { type: "text", content: "Revenue", fontSize: 14 },
        { type: "text", content: "$42,500", fontSize: 24, fontWeight: 600 }
      ]
    },
    postProcess: true
  })
  → Returns: inserted node with auto-generated ID
```

### Scenario 3: Update Multiple Cards' Widths

```
Goal: Change all stat cards from 240px to 300px wide

Decision Tree:
  Q1: Updating multiple nodes? YES
  Q2: All operations same type (updates)? YES
  → Use: batch_design U()

Workflow:
  openpencil_batch_design({
    operations: `
      U("statCard1", { width: 300 })
      U("statCard2", { width: 300 })
      U("statCard3", { width: 300 })
      U("statCard4", { width: 300 })
    `,
    postProcess: true
  })
  → Returns: updated nodes
```

### Scenario 4: Delete Empty Section

```
Goal: Remove empty footer section from page

Decision Tree:
  ⚠️ CRITICAL: batch_design D() silently no-ops
  → ALWAYS: delete_node

Workflow:
  openpencil_delete_node({ nodeId: "footerSectionId" })
  → Returns: success/failure with proper error handling
```

### Scenario 5: Create Multi-Page Application

```
Goal: Build login page, dashboard, and settings page

Decision Tree:
  Q1: Building ENTIRE pages? YES
  Q2: Multiple pages? YES
  → Use: Orchestrator pattern with layered workflow per page

Workflow:
  ORCHESTRATOR:
    1. Create pages: openpencil_add_page({ name: "Login" })
    2. Create pages: openpencil_add_page({ name: "Dashboard" })
    3. Dispatch subagents: task(...)

  SUBAGENT (for Login page):
    1. load sub-skills
    2. design_skeleton(...) → rootId, sections
    3. design_content(...) → populate header, form, footer
    4. design_content(...) → populate form fields
    5. design_refine(...)
    6. Return: "✅ Login page built. Orchestrator: verify and save."

  REVIEWER:
    1. load sub-skills
    2. batch_get({ pageId })
    3. Verify: node count > 1
    4. Return: PASS or FAIL

  ORCHESTRATOR:
    1. Collect all subagent results
    2. If all PASS: read_nodes() → filesystem_write_file(".op")
    3. Update PROJECT.md, DESIGN.md
```

---

## Tool Selection Quick Reference

### Insert Operations

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    INSERT DECISION TREE                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Building entire page from scratch?  ──YES──→ design_content      │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │ NO                                          │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Adding single node?  ─────YES──→ insert_node                     │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │ NO                                          │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Adding multiple nodes atomically?  ──YES──→ batch_design I()     │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │ NO                                          │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Use insert_node (multiple calls, not atomic)                     │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### Update Operations

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    UPDATE DECISION TREE                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Updating single node?  ───YES──→ update_node                     │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │ NO                                          │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Updating multiple nodes atomically?  ──YES──→ batch_design U()  │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │ NO                                          │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Replacing entire node?  ──YES──→ replace_node                    │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │ NO                                          │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  Update individual nodes with update_node                         │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

### Delete Operations

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    DELETE DECISION TREE                                  │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                           │
│  ⚠️  CRITICAL: batch_design D() silently no-ops!                        │
│                                                                           │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  ALL DELETE OPERATIONS → delete_node                              │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                            │                                             │
│                            ▼                                             │
│  ┌────────────────────────────────────────────────────────────────────┐  │
│  │  openpencil_delete_node({ nodeId })                               │  │
│  └────────────────────────────────────────────────────────────────────┘  │
│                                                                           │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Anti-Patterns to Avoid

### ❌ Wrong: Using batch_design D() for deletion

```
WRONG:
  batch_design({ operations: 'D("nodeId")' })
  → No error, but node NOT deleted

CORRECT:
  delete_node({ nodeId: "nodeId" })
  → Returns success/failure with proper error handling
```

### ❌ Wrong: Using batch_design U() for single update

```
WRONG:
  batch_design({ operations: 'U("nodeId", { width: 200 })' })
  → Overkill for single node

CORRECT:
  update_node({ nodeId: "nodeId", data: { width: 200 } })
  → Simpler, clearer, same result
```

### ❌ Wrong: Using insert_node for entire page build

```
WRONG:
  for (let i = 0; i < 100; i++) {
    insert_node({ parent: "root", data: {...} })
  }
  → 100 MCP calls, no validation, slow

CORRECT:
  design_skeleton({ rootFrame, sections })
  design_content({ sectionId, children, postProcess: true })
  design_refine({ rootId })
  → 3 MCP calls, validated structure, optimized
```

---

## Summary Rules

| Operation | Tool | When | DSL/Params |
|-----------|------|------|------------|
| **Insert single** | `insert_node` | Adding 1 node | `insert_node({ parent, data })` |
| **Insert entire page** | `design_content` | Building page from scratch | Layered workflow |
| **Insert multiple** | `batch_design I()` | Atomically add many nodes | `operations: "I(p, d)\nI(p, d)"` |
| **Update single** | `update_node` | Changing 1 node | `update_node({ nodeId, data })` |
| **Update multiple** | `batch_design U()` | Atomically update many nodes | `operations: 'U(n, d)\nU(n, d)'` |
| **Replace node** | `replace_node` | Complete node replacement | `replace_node({ nodeId, data })` |
| **Delete any** | `delete_node` | Removing nodes (always) | `delete_node({ nodeId })` |

---

## Verification Checklist

Before choosing a tool, verify:

```
[ ] Am I building entire page from scratch? (→ design_content)
[ ] Am I updating single node? (→ update_node)
[ ] Am I updating multiple nodes? (→ batch_design U() or update_node xN)
[ ] Am I deleting a node? (→ delete_node - NEVER D() in batch_design)
[ ] Are all operations the same type? (→ batch_design if YES)
[ ] Do I need atomicity? (→ batch_design if YES)
```

---

## Related Documentation

- **SKILL.md** - Main skill documentation for openpencil-loop
- **mcp-tool-index.md** - Complete MCP tool reference (includes file persistence warning)
- **agent-harness-construction review** - Overlapping tool semantics analysis

---

**Last Updated:** 2026-04-10
**Based on:** Agent Harness Construction review findings
