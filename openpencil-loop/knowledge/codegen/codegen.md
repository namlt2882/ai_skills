---
name: codegen
description: Production-ready code generation from PenNode JSON via MCP
phase: [codegen]
trigger:
  flags: [isCodeGen]
priority: 10
budget: 3000
category: base
mcp_tools:
  - export_nodes
  - batch_get
  - get_design_md
  - snapshot_layout
---

## Code Generation Workflow (Multi-Step)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    PRODUCTION CODEGEN WORKFLOW                              │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  STEP 1: ANALYZE         STEP 2: DISCOVER       STEP 3: DEDUPE    STEP 4: GENERATE│
│  ├─ Check project        ├─ Find existing      ├─ Hash nodes     ├─ Generate │
│  │  structure           │  implementations   ├─ Map duplicates │  code     │
│  ├─ Read .op file       ├─ Parse exports/     ├─ Extract shared ├─ With dedup│
│  └─ Validate design     │  src/components     └─ Create import  └─ + safety │
│                         │  dir                   refs           │           │
│                         └─ Check for            └─ Output manifest          │
│                            duplicate names                                   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Phase 1: ANALYZE
Check project structure and validate design readiness:
- Verify `.op` file exists
- Check DESIGN.md has tokens
- Validate at least 1 page with nodes
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
- `.op` canvas file with design
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
