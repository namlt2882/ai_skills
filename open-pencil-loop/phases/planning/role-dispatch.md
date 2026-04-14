---
name: role-dispatch
description: Role-based dispatch patterns for multi-agent OpenPencil workflows. Use when orchestrating parallel design builds with ORCHESTRATOR, SUBAGENT, REVIEWER, and ANALYZER roles.
version: "1.0.0"
---

# Role-Based Dispatch for OpenPencil Workflows

## Role Definitions

### ORCHESTRATOR
**Purpose:** Multi-page planning, page creation, subagent dispatch, final assembly.

**Responsibilities:**
- Create pages via `add_page`
- Read prompt files for each page
- Dispatch SUBAGENTs to build individual pages
- Dispatch REVIEWERs to verify completed pages
- Dispatch ANALYZERs to extract design tokens
- Save final document via `save_file`

**Tools to USE:** `add_page`, `list_pages`, `export_nodes`, `save_file`, `batch_get`
**Tools to AVOID:** `design_skeleton`, `design_content`, `design_refine` (delegate these)

**Dispatch Prompt Template for SUBAGENT:**
```
You are a SUBAGENT building page [PAGE_NAME] for [PROJECT_NAME].

READ these files first:
- phases/generation/schema.md (PenNode types)
- phases/generation/layout-rules.md (flexbox rules)
- knowledge/role-definitions.md (semantic roles)

PAGE PROMPT:
[paste page-specific prompt content here]

EXECUTE:
1. design_skeleton with the section structure
2. design_content for each section
3. design_refine for validation

RETURN: Summary of nodes created, any warnings.
DO NOT: add_page, save_file, or dispatch other agents.
```

**Dispatch Prompt Template for REVIEWER:**
```
You are a REVIEWER verifying page [PAGE_NAME].

EXECUTE:
1. batch_get({pageId: "[PAGE_ID]", readDepth: 2})
2. Check: node count > 1
3. Check: has visible children with content
4. Check: no empty text nodes

RETURN: PASS or FAIL with specific issues found.
DO NOT: build, save, or modify any nodes.
```

**Dispatch Prompt Template for ANALYZER:**
```
You are an ANALYZER extracting design tokens from source code.

SOURCE FILES: [list source file paths]

EXECUTE:
1. Read each source file
2. Extract: colors (hex), typography (font-family, size, weight), spacing values
3. Map to OpenPencil variable format

RETURN: JSON with categories: colors, typography, spacing.
DO NOT: build, save, or modify any nodes.
```

---

### SUBAGENT (Builder)
**Purpose:** Single-page execution using the layered design workflow.

**Responsibilities:**
- Read pre-flight files (schema, layout-rules, role-definitions)
- Build one page using: design_skeleton → design_content → design_refine
- Return result summary to ORCHESTRATOR

**Pre-Flight Checklist (MANDATORY before building):**
1. `read("phases/generation/schema.md")` — Understand PenNode types
2. `read("phases/generation/layout-rules.md")` — Understand flexbox rules
3. `read("knowledge/role-definitions.md")` — Understand semantic roles

**Build Sequence:**
```yaml
# Step 1: Create section structure
design_skeleton:
  rootFrame: {name, width, height, layout}
  sections: [{name, height, layout, role}]

# Step 2: Populate each section
design_content:
  sectionId: "<from-step-1>"
  children: [{type, role, content, children}]

# Step 3: Validate and fix
design_refine:
  rootId: "<root-frame-id>"
```

**Return Format:**
```
PAGE: [name]
SECTIONS: [count]
NODES: [total count]
WARNINGS: [any issues found]
STATUS: COMPLETE
```

---

### REVIEWER
**Purpose:** Quality gate — read-only verification of completed pages.

**Verification Checklist:**
1. `batch_get({pageId, readDepth: 2})` — Get page content
2. Check node count > 1 (page has content)
3. Check for visible children (not empty frame)
4. Check text nodes have content (not empty strings)
5. Check layout consistency (no overflow)

**Return Format:**
```
VERDICT: PASS or FAIL
PAGE: [name]
NODES: [count]
ISSUES: [list of specific problems, if any]
```

---

### ANALYZER
**Purpose:** Design token extraction from source code.

**Extraction Targets:**
- Colors → `list_variables` / `set_variables` format
- Typography → font-family, size, weight, line-height
- Spacing → padding, gap, margin values
- Component patterns → reusable frame structures

**Return Format:**
```json
{
  "colors": {"primary": "#007AFF", "secondary": "#5856D6"},
  "typography": {"heading": {"family": "Inter", "size": 32, "weight": "bold"}},
  "spacing": {"base": 8, "scale": [0, 4, 8, 12, 16, 24, 32, 48]}
}
```

---

## Tool Decision Tree

### Insert Operations
| Scenario | Tool | Why |
|----------|------|-----|
| Single node into known parent | `insert_node` | Direct, simple |
| Page of structured content | `design_content` | Auto-postProcess, bulk insert |
| Atomic multi-operation batch | `batch_design` `I()` | All succeed or all fail |
| JSX component | `render` | Parses JSX syntax |

### Update Operations
| Scenario | Tool | Why |
|----------|------|-----|
| Single property change | `update_node` | Lightweight |
| Multiple property changes | `batch_design` `U()` | Atomic batch |
| Full node replacement | `replace_node` | Complete swap |

### Delete Operations
| Scenario | Tool | Why |
|----------|------|-----|
| Any deletion | `delete_node` | **ALWAYS use this!** `batch_design` `D()` silently no-ops |

### Analysis Operations
| Scenario | Tool | Why |
|----------|------|-----|
| Color audit | `analyze_colors` | Frequency + variable binding |
| Typography audit | `analyze_typography` | Font usage patterns |
| Spacing audit | `analyze_spacing` | Grid compliance |
| Pattern detection | `analyze_clusters` | Repeated structures → components |

---

## Error Recovery

| Error | Recovery |
|-------|----------|
| Desktop app not responding | `openpencil ping` → restart app → retry |
| Invalid node ID | `get_page_tree` → find correct ID → retry |
| Layout overflow | `design_refine` → auto-fix → verify |
| Duplicate variable names | `list_variables` → check existing → use unique names |
