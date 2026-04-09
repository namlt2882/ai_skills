---
name: codegen
description: Production-ready code generation from PenNode JSON via MCP (v2)
phase: [codegen]
trigger:
  flags: [isCodeGen]
priority: 10
budget: 3000
category: base
mcp_tools:
  - export_nodes
  - get_codegen_prompt
  - get_design_md
  - batch_get
---

## Code Generation Workflow (v2 Multi-Step)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PRODUCTION CODEGEN WORKFLOW (v2)                         │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  STEP 1: ANALYZE         STEP 2: DISCOVER       STEP 3: DEDUPE    STEP 4: GENERATE│
│  ├─ Check project        ├─ Find existing      ├─ Hash nodes     ├─ Generate │
│  │  structure           │  implementations   ├─ Map duplicates │  code     │
│  ├─ Read .fig/.pen file ├─ Parse exports/     ├─ Extract shared ├─ With dedup│
│  └─ Validate design     │  src/components     └─ Create import  └─ + safety │
│                         │  dir                   refs           │           │
│                         └─ Check for            └─ Output manifest          │
│                            duplicate names                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

## MCP Tools for Code Generation (v2)

### 1. `export_nodes` - Primary Export Tool

Exports raw PenNode data with design variables and themes for code generation.

```javascript
// Export all nodes from a page
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "export_nodes",
  arguments: {
    filePath: "/path/to/design.fig",  // or .pen
    pageId: "page-1"  // optional, defaults to first page
  }
})

// Export specific nodes
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "export_nodes",
  arguments: {
    filePath: "/path/to/design.fig",
    nodeIds: ["node-1", "node-2", "node-3"],
    pageId: "page-1"
  }
})
```

**Returns:**
- Complete PenNode tree with children
- Design variables (colors, numbers, strings)
- Theme variants (light/dark modes)
- Layout properties (flex, padding, gap)
- Style properties (fills, strokes, effects)

### 2. `get_codegen_prompt` - Code Generation Guidelines

Retrieves design-to-code generation guidelines before generating frontend code.

```javascript
// Get full codegen guidelines
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "get_codegen_prompt",
  arguments: {}
})
```

**Returns:**
- PenNode schema documentation
- Layout system (flexbox rules)
- Semantic roles and their defaults
- Typography guidelines
- Color and style policies
- Icon handling
- Design examples
- Layered workflow guide

### Phase 1: ANALYZE
Check project structure and validate design readiness:
- Verify `.fig` or `.pen` file exists
- Check DESIGN.md has tokens via `get_design_md`
- Validate at least 1 page with nodes via `batch_get`
- Discover project structure (src/, lib/, etc.)
- Framework detection (React/HTML/Vue/SwiftUI/Flutter)
- **File:** `phases/codegen/analyze.md`

### Phase 2: DISCOVER
Find existing implementations:
- Scan src/components/ directory
- Parse existing component files
- Match PenNode roles to existing components
- Identify overwrite risks
- **File:** `phases/codegen/discover.md`

### Phase 3: DEDUPE
Component deduplication and shared extraction:
- SHA256 hash PenNode structure
- Group nodes by hash across pages
- Extract shared components (used 2+ times)
- Keep unique components (used once)
- Generate import manifest
- **File:** `phases/codegen/deduplicate.md`

### Phase 4: GENERATE
Production code generation:
- Call `get_codegen_prompt` first for guidelines
- Call `export_nodes` to get PenNode data
- Generate shared components first
- Generate unique components
- Inject shared imports
- Create backups before overwrite
- Update codegen-state.md manifest
- **File:** `phases/codegen/generate.md`

## Available Frameworks

| Framework | File |
|-----------|------|
| React + Tailwind | `codegen-react.md` |
| HTML + CSS | `codegen-html.md` |

> **Coming soon:** Vue, Svelte, SwiftUI, Flutter/Compose, React Native

## Input/Output

### Input
- `.fig` or `.pen` canvas file with design
- `codegen-state.md` baton (after phases 1-3)
- Framework guide (react/html)

### Output
- `src/components/ui/{Component}.tsx` (shared)
- `src/pages/{Page}/{Component}.tsx` (unique)
- `codegen-state.md` with generation manifest

## Chunking Strategy

For complex designs, use deduplication phase to create smart chunks:

```json
{
  "sharedComponents": [
    { "id": "Button", "hash": "sha256:abc", "usedIn": ["Page1", "Page2", "Page3"] }
  ],
  "uniqueComponents": [
    { "id": "HeroSection", "hash": "sha256:def", "usedIn": ["Page1"] }
  ]
}
```

**Rules:**
1. Shared components (3+ uses) → extract to shared location
2. Unique components (1 use) → keep page-specific
3. Component with shared dependencies → reference shared

## CLI Export (Optional)

For command-line export, use:

```bash
# Export to JSON
openpencil export design.fig --format json --out ./export/

# Export specific page
openpencil export design.fig --page "Page 1" --format json
```
