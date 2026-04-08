---
name: deduplicate
description: SHA256 hash-based component deduplication and shared extraction
phase: [codegen]
trigger: null
priority: 30
budget: 2500
category: base
mcp_tools:
  - export_nodes
  - batch_get
---

> **MCP Tool Syntax:** Tool calls below use generic names (`export_nodes`, `batch_get`, etc.).
> Adapt to your agent framework: OpenCode → `skill_mcp()`, Claude Code → `mcp__openpencil__<tool>()`, Codex → `openpencilMcp.<tool>()`.
> See SKILL.md → "Multi-Agent Compatibility" for full mapping.

You are a **Component Deduplication Engine**. Your job is to identify repeated components across pages and extract them into shared libraries.

## Workflow

### Step 1: Export All Nodes
Get PenNode data from all pages:
```
For each page:
  export_nodes({
    filePath: "canvas/design.op",
    pageId: "page-uuid"
  })
```

### Step 2: Build Node Hashes
Normalize and hash each PenNode:
```
Normalized Node (exclude dynamic IDs):
{
  type: "frame",
  name: "Button",
  role: "button",
  width: "fit_content",
  height: 44,
  layout: "horizontal",
  gap: 8,
  padding: [12, 24],
  cornerRadius: 8,
  fill: [{ type: "solid", color: "#111111" }]
}

Hash = SHA256(JSON.stringify(sorted(normalizedNode)))
```

### Step 3: Map Duplicates
Group nodes by hash:
```
hashMap = {
  "sha256:abc123...": {
    nodes: [
      { pageId: "A", nodeId: "node-1", role: "button" },
      { pageId: "B", nodeId: "node-2", role: "button" }
    ],
    count: 2,
    firstUsedPage: "A"
  },
  "sha256:def456...": {
    nodes: [
      { pageId: "A", nodeId: "node-3", role: "hero" }
    ],
    count: 1,
    firstUsedPage: "A"
  }
}
```

### Step 4: Extract Shared Components
Component extraction rules:

#### SHARED (use count >= 2):
```
- Extract to: src/components/ui/{ComponentName}.tsx
- Import alias: "@/components/ui"
- Mark as shared across all pages using it

Example:
  sha256:abc123... (used in pages A, B, C)
    → Extract as: src/components/ui/Button.tsx
    → Import alias: "@/components/ui/Button"
    → Used in: A, B, C
```

#### UNIQUE (use count == 1):
```
- Extract to: src/pages/{PageName}/{ComponentName}.tsx
- Import alias: "@/pages/{PageName}"
- Mark as unique to single page

Example:
  sha256:def456... (used only in page A)
    → Extract as: src/pages/Landing/HeroSection.tsx
    → Import alias: "@/pages/Landing/HeroSection"
    → Used in: A only
```

### Step 5: Build Components Manifest
Create comprehensive manifest:
```
componentsManifest:
  - name: "Button"
    hash: "sha256:abc123..."
    type: "shared"  # or "unique"
    sourcePages: ["Landing", "Contact", "Pricing"]
    exportCount: 3
    outputPath: "src/components/ui/Button.tsx"
    importAlias: "@/components/ui/Button"
    exports: ["Button"]
    sharedWith: ["Landing", "Contact", "Pricing"]
    imports: []  # dependencies (resolved later)

  - name: "HeroSection"
    hash: "sha256:def456..."
    type: "unique"
    sourcePages: ["Landing"]
    exportCount: 1
    outputPath: "src/pages/Landing/HeroSection.tsx"
    importAlias: "@/pages/Landing/HeroSection"
    exports: ["HeroSection"]
    sharedWith: []
    imports: ["Button", "Card"]
```

### Step 6: Resolve Dependencies
Trace inter-component dependencies:
```
For each unique component:
  For each child node:
    If child has hash match in sharedComponents:
      Add sharedComponent.name to imports array

Example:
  HeroSection contains Button, Card
    imports: ["Button", "Card"]
```

### Step 7: Update Codegen State
Output `codegen-state.md` baton with:
```yaml
---
phase: deduplicate
duplicateAnalysis:
  totalNodes: 842
  uniqueHashes: 127
  sharedCount: 18
  uniqueCount: 109
sharedComponents:
  - hash: "sha256:abc123..."
    name: "Button"
    sourcePages: ["Landing", "Contact", "Pricing"]
    exportCount: 3
    outputPath: "src/components/ui/Button.tsx"
    importAlias: "@/components/ui/Button"
    exports: ["Button"]
    sharedWith: ["Landing", "Contact", "Pricing"]
    imports: []
  - hash: "sha256:def456..."
    name: "Card"
    sourcePages: ["Landing", "Features"]
    exportCount: 2
    outputPath: "src/components/ui/Card.tsx"
    importAlias: "@/components/ui/Card"
    exports: ["Card"]
    sharedWith: ["Landing", "Features"]
    imports: []
uniqueComponents:
  - hash: "sha256:xyz789..."
    name: "HeroSection"
    sourcePages: ["Landing"]
    exportCount: 1
    outputPath: "src/pages/Landing/HeroSection.tsx"
    importAlias: "@/pages/Landing/HeroSection"
    exports: ["HeroSection"]
    sharedWith: []
    imports: ["Button", "Card", "Navbar"]

componentsManifest:
  - name: "Button"
    type: "shared"
    outputPath: "src/components/ui/Button.tsx"
    importAlias: "@/components/ui"
    exports: ["Button"]
    dependencies: []
  - name: "HeroSection"
    type: "unique"
    outputPath: "src/pages/Landing/HeroSection.tsx"
    importAlias: "@/pages/Landing"
    exports: ["HeroSection"]
    dependencies: ["Button", "Card", "Navbar"]
---
```

## INPUT
1. `codegen-state.md` from Phase 2 (discover)
2. All pages' PenNode data via `export_nodes`

## OUTPUT
`codegen-state.md` baton with deduplication analysis and components manifest

## HASHING ALGORITHM

### Node Normalization (for hashing):
```javascript
function normalizeNode(node) {
  return {
    type: node.type,
    name: node.name,
    role: node.role,
    width: node.width,
    height: node.height,
    layout: node.layout,
    gap: node.gap,
    padding: node.padding,
    cornerRadius: node.cornerRadius,
    fill: node.fill,
    stroke: node.stroke,
    // Exclude: id, x, y (dynamic properties)
    // Exclude: opacity (can vary per instance)
  };
}

function hashNode(node) {
  const normalized = normalizeNode(node);
  const sorted = sortKeys(normalized);
  const json = JSON.stringify(sorted);
  return sha256(json);
}
```

### Key Rules:
- ✅ INCLUDE: type, name, role, layout props, styles
- ✅ INCLUDE: fill colors (they define component identity)
- ❌ EXCLUDE: id, x, y (position is page-specific)
- ❌ EXCLUDE: opacity (can be overridden)
- ❌ EXCLUDE: children (handled by reference)

## RULES
- ✅ DO: Use SHA256 for consistent hashing
- ✅ DO: Normalize nodes before hashing (exclude dynamic props)
- ✅ DO: Extract shared components for reuse
- ✅ DO: Track dependencies between components
- ❌ DON'T: Hash based on node ID (changes per export)
- ❌ DON'T: Hash position data (x, y)
- ❌ DON'T: Skip duplicate detection even for small patterns

## EDGE CASES

### Case 1: Components with Same Role, Different Styles
```
Node A: role="button", fill="#111111"
Node B: role="button", fill="#6366F1"

Hash: DIFFERENT (different fill colors)
Result: TWO separate Button variants
```

### Case 2: Components with Same Style, Different Roles
```
Node A: role="button", fill="#111111"
Node B: role="input", fill="#111111"

Hash: DIFFERENT (different roles)
Result: Separate Button and Input components
```

### Case 3: Components with Same Structure, Different Children
```
Node A: layout="vertical", children=[text, icon]
Node B: layout="vertical", children=[icon, text]

Hash: DIFFERENT (children order differs)
Result: Different components (intentional)
```

### Case 4: Multi-page Shared Component
```
Page 1: HeroSection uses Button
Page 2: FeaturesSection uses Button
Page 3: ContactSection uses Button

Result: Extract Button as shared component
        Update all 3 pages to import from shared location
```

## ERROR HANDLING

| Error | Action |
|-------|--------|
| Export nodes failed | Retry once, then skip page |
| SHA256 hash collision | Log warning, manually verify |
| File path conflict | Append index: Button1.tsx, Button2.tsx |
| Dependency cycle detected | Log warning, break cycle |

## EXAMPLES

### Successful Deduplication
```
PENNODES (across 3 pages):
Page 1 (Landing):
  - Button (role="button", fill="#111") → hash: abc123
  - HeroSection (unique) → hash: def456

Page 2 (Contact):
  - Button (role="button", fill="#111") → hash: abc123 (duplicate!)
  - Form (unique) → hash: ghi789

Page 3 (Pricing):
  - Button (role="button", fill="#111") → hash: abc123 (duplicate!)
  - PricingCards (unique) → hash: jkl012

DEDUPLICATE:
✓ Button (abc123) → shared, used in 3 pages
✓ Extract as: src/components/ui/Button.tsx
✓ Update all 3 pages to reference shared Button
✓ HeroSection, Form, PricingCards remain unique

RESULT: 1 shared component, 3 unique components
```

### Complex Shared Component
```
SHARED COMPONENT:
ComponentName: Navbar
Used In: All 5 pages
Structure: Frame (layout=horizontal) > [Logo, NavLinks, UserMenu]

UNIQUE COMPONENTS:
- HeroSection (Page 1)
- FeaturesSection (Page 2)
- ContactSection (Page 3)
- PricingSection (Page 4)
- AboutSection (Page 5)

MANIFEST:
sharedComponents:
  - name: "Navbar"
    hash: "sha256:shared123"
    sourcePages: ["Page1", "Page2", "Page3", "Page4", "Page5"]
    exportCount: 5
    outputPath: "src/components/layout/Navbar.tsx"
    importAlias: "@/components/layout"

uniqueComponents:
  - name: "HeroSection"
    hash: "sha256:unique456"
    sourcePages: ["Page1"]
    exportCount: 1
    outputPath: "src/pages/Page1/HeroSection.tsx"
    importAlias: "@/pages/Page1"

DEPS:
  Navbar imports: none (top-level)
  HeroSection imports: Navbar
```