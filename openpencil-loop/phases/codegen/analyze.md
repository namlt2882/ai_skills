---
name: analyze
description: Project structure analysis and design validation for codegen
phase: [codegen]
trigger: null
priority: 10
budget: 1500
category: base
mcp_tools:
  - batch_get
  - get_design_md
  - snapshot_layout
  - export_nodes
---

> **MCP Tool Syntax:** Tool calls below use generic names (`export_nodes`, `batch_get`, etc.).
> Adapt to your agent framework: OpenCode → `skill_mcp()`, Claude Code → `mcp__openpencil__<tool>()`, Codex → `openpencilMcp.<tool>()`.
> See SKILL.md → "Multi-Agent Compatibility" for full mapping.

You are a **Project Structure Analyzer**. Your job is to check if the design is ready for code generation and gather project context.

## Workflow

### Step 1: Check Canvas File
```
1. Verify .op file exists (from next-prompt.md or user config)
2. Read design using: export_nodes({ filePath, pageId })
3. Get design metadata: get_design_md({ filePath })
4. Check layout structure: snapshot_layout({ filePath })
```

### Step 2: Validate Design
Validate these conditions:
- [ ] Canvas file exists and is readable
- [ ] At least 1 page with nodes (not empty skeleton)
- [ ] DESIGN.md exists with design tokens (colors, typography, spacing)
- [ ] No validation errors from previous iteration

### Step 3: Discover Project Structure
```
1. Check for src/ directory (React/Vue) or app/ (Flutter)
2. Check for lib/ directory (Go/Dart)
3. Identify component directory pattern:
   - React: src/components/ or src/components/ui/
   - Vue: src/components/
   - Flutter: lib/widgets/ or lib/components/
4. Check for existing implementation files (.tsx, .jsx, .vue, .dart)
```

### Step 4: Read Existing Project Files (if any)
Use filesystem tools to check:
```
- Read src/components/ directory structure
- Look for .tsx, .jsx, .vue, .dart, .swift files
- Parse existing component names
- Identify framework patterns (shadcn/ui, MUI, etc.)
```

### Step 5: Build Codegen State
Output `codegen-state.md` baton with:
```yaml
---
phase: analyze
canvas: path/to/design.op
pages:
  - pageId: "uuid"
    name: "PageName"
    nodeCount: 42
    validated: true
designTokens: { primary: "#6366F1", ... }
framework: react  # detect from project structure
projectStructure:
  srcDir: "src"
  componentsDir: "src/components"
  exists: true
---
```

## INPUT
1. `.op/next-prompt.md` or `.op/PROJECT.md` with design reference
2. User-specified framework (React/HTML/Vue/SwiftUI/Flutter)

## OUTPUT
`codegen-state.md` baton with project analysis results

## RULES
- ✅ DO: Check all required conditions before proceeding
- ✅ DO: Read existing project structure even if incomplete
- ✅ DO: Detect framework from component directory patterns
- ❌ DON'T: Proceed if canvas file missing
- ❌ DON'T: Proceed if DESIGN.md missing design tokens
- ❌ DON'T: Assume component directory path — verify it exists

## ERROR HANDLING
| Error | Action |
|-------|--------|
| Canvas file missing | Report error: `.op` file not found at configured path |
| DESIGN.md missing | Report error: Design tokens required for code generation |
| No pages with nodes | Report error: Design not complete (empty skeleton) |
| Component dir missing | Warn: No existing components found, will generate new |
| Framework detection failed | Fallback to user-specified framework |

## EXAMPLES

### Successful Analysis
```
USER: "Export React code for my landing page design"

ANALYZE:
✓ Canvas exists: canvas/design.op
✓ 2 pages with 84 nodes total
✓ DESIGN.md found with colors, typography, spacing
✓ src/components/ directory exists
✓ framework: react
✓ No existing Button.tsx or Card.tsx detected

OUTPUT:codegen-state.md with phase: analyze, pages[], designTokens, framework
```

### Error Case
```
USER: "Export code for my new project"

ANALYZE:
✗ .op file not found at canvas/mydesign.op

OUTPUT: Error message, stop codegen workflow
```

### Partial Analysis
```
USER: "Export code for my existing project"

ANALYZE:
✓ Canvas exists: canvas/app.op
✓ DESIGN.md exists
✓ src/components/ exists
✓ Found existing: Button.tsx, Card.tsx, Form.tsx
✗ No shared component detection yet (defer to next phase)

OUTPUT:codegen-state.md with existingComponents populated
```