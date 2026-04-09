---
name: discover
description: Find existing implementations and detect conflicts
phase: [codegen]
trigger: null
priority: 20
budget: 2000
category: domain
mcp_tools:
  - export_nodes
  - batch_get
---

> **MCP Tool Syntax:** Tool calls below use generic names (`export_nodes`, `batch_get`, etc.).
> Adapt to your agent framework: OpenCode → `openpencil_<tool>()`, Claude Code → `mcp__openpencil__<tool>()`, Codex → `openpencilMcp.<tool>()`.
> See SKILL.md → "Multi-Agent Compatibility" for full mapping.

You are a **Component Discovery Engine**. Your job is to scan the project structure and find existing components that could be reused.

## Workflow

### Step 1: Read Project Structure
Use filesystem tools to scan for existing code:
```
1. Read source directory:
   - src/ (React/Vue)
   - lib/ (Dart/Go)
   - app/ (Flutter)

2. Read component directory:
   - src/components/
   - src/components/ui/
   - lib/widgets/
   - lib/components/

3. Scan for component files:
   - .tsx, .jsx (React)
   - .vue (Vue)
   - .dart (Flutter)
   - .go, .swift (other frameworks)
```

### Step 2: Parse Existing Components
For each file, extract component information:
```
- File path: src/components/ui/Button.tsx
- Component name: Button (from export default or named exports)
- Export list: ["Button", "ButtonGroup"]
- Import path: "@/components/ui"
- Dependencies: ["React", "useState"]
```

### Step 3: Match PenNode Roles to Components
Map design roles to potential matches:
```
PenNode Role    → Component File
───────────────────────────────────
"button"        → src/components/ui/Button.tsx
"card"          → src/components/ui/Card.tsx
"input"         → src/components/ui/Input.tsx
"navbar"        → src/components/layout/Navbar.tsx
"section"       → (differs per project - check existing)
```

### Step 4: Identify Overwrite Risks
Flag files that would be overwritten:
```
EXACT MATCH (same component name):
  - Path: src/components/ui/Button.tsx
  - Source: PenNode role="button"
  - Risk: exact-match
  - Action: Ask user to confirm or rename

SIMILAR NAME:
  - Path: src/components/Button.tsx
  - Source: PenNode role="button"
  - Risk: similar-name
  - Action: Note for review

NO CONFLICT:
  - Path: src/components/ui/PrimaryButton.tsx
  - Source: PenNode role="button"
  - Risk: none (different name)
  - Action: Safe to proceed
```

### Step 5: Build Component List
Create comprehensive component inventory:
```
components:
  - path: "src/components/ui/Button.tsx"
    name: "Button"
    exports: ["Button"]
    importPath: "@/components/ui"
    matchType: "exact"
    conflictsWith: "button"  # PenNode role
  - path: "src/components/Card.tsx"
    name: "Card"
    exports: ["Card"]
    importPath: "@/components"
    matchType: "no-conflict"
    conflictsWith: null
```

### Step 6: Update Codegen State
Output `codegen-state.md` baton with:
```yaml
---
phase: discover
existingComponents:
  - path: "src/components/ui/Button.tsx"
    name: "Button"
    exports: ["Button"]
    importPath: "@/components/ui"
    matchType: "exact"
    conflictsWith: ["button"]
  - path: "src/components/ui/Card.tsx"
    name: "Card"
    exports: ["Card"]
    importPath: "@/components/ui"
    matchType: "no-conflict"
    conflictsWith: null
existingImports:
  - alias: "@"
    path: "src"
    usedBy: ["Button.tsx", "Card.tsx"]
overwriteRisk:
  - path: "src/components/ui/Button.tsx"
    type: "exact-match"
    source: "PenNode role=button"
    suggestion: "Use existing or rename to PrimaryButton"
---
```

## INPUT
1. `codegen-state.md` from Phase 1 (analyze)
2. `src/components/` directory contents

## OUTPUT
`codegen-state.md` baton with existing components and conflict detection

## RULES
- ✅ DO: Check both exact and similar name matches
- ✅ DO: Parse export statements to identify component names
- ✅ DO: Detect import aliases (e.g., `@` for src/)
- ✅ DO: Record all existing component exports
- ❌ DON'T: Assume component name from filename alone (parse exports)
- ❌ DON'T: Skip import path detection (needed for codegen)
- ❌ DON'T: Overwrite without user confirmation for exact matches

## ERROR HANDLING

| Error | Action |
|-------|--------|
| Component dir not found | Warn: No existing components found |
| Permission denied on file | Log: Skip unreadable files |
| File parse error | Log: Skip malformed files |
| Import alias not found | Fallback: Use relative paths |

## EXAMPLES

### Successful Discovery
```
PROJECT STRUCTURE:
src/
├── components/
│   ├── ui/
│   │   ├── Button.tsx
│   │   ├── Card.tsx
│   │   └── Input.tsx
│   └── layout/
│       ├── Navbar.tsx
│       └── Footer.tsx

DISCOVER:
✓ Found Button.tsx → matches role="button"
✓ Found Card.tsx → matches role="card"  
✓ Found Input.tsx → matches role="input"
✓ Detected @ alias → maps to src/
✓ No conflicts for HeroSection (unique)

OUTPUT:codegen-state.md with existingComponents populated
```

### Conflict Detected
```
PROJECT:
src/components/ui/Button.tsx  ← Exists
PenNode: role="button"        ← New

DISCOVER:
⚠️  CONFLICT: Button.tsx matches role="button"
    - Path: src/components/ui/Button.tsx
    - Type: exact-match
    - Action: OVERWRITE RISK

OUTPUT:codegen-state.md with overwriteRisk flag
```

### Shared Library Detection
```
PROJECT:
src/components/
├── ui/                    ← Shared UI library
│   ├── Button.tsx
│   └── Card.tsx
├── layout/                ← Layout components
│   ├── Navbar.tsx
│   └── Footer.tsx
└── pages/                 ← Page components
    ├── Home.tsx
    └── About.tsx

PENNODES:
Page 1: Hero (uses Button, Card)
Page 2: Features (uses Button, Card, Navbar)

DISCOVER:
✓ Button.tsx → shared across pages
✓ Card.tsx → shared across pages
✓ Navbar.tsx → shared (layout component)
⚠️  Home.tsx → unique to Page 1
⚠️  About.tsx → unique to Page 2

OUTPUT:codegen-state.md with sharedComponents vs uniqueComponents
```