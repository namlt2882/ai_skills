---
name: openpencil-loop
description: Iterative design development loop using OpenPencil (https://github.com/ZSeven-W/openpencil) CLI and MCP tools. Combines prompt enhancement, design system synthesis, and baton-passing orchestration. Use when building multi-page designs, iteratively refining UI components, creating design systems, or when you want to progressively develop a design with structured user feedback. Triggers on requests like "build a design system", "create multiple pages with OpenPencil", "iteratively design", "loop design", "design a login page", or when you want to enhance prompts for OpenPencil with design system context.
---

# OpenPencil Build Loop

## ⚠️ ROLE DETECTION (READ THIS FIRST - BEFORE ANYTHING ELSE)

**STOP. Before doing anything, determine YOUR role:**

### Check Your Task Prompt:

| If Your Prompt Says... | You Are... | Go To... |
|------------------------|------------|----------|
| "Onboard [project]", "Create DESIGN.md, PROJECT.md", "Dispatch subagents" | **ORCHESTRATOR** | `## 🎯 ORCHESTRATOR WORKFLOW` below |
| "Read prompts/XX-prompt.md and build the page" | **SUBAGENT/BUILDER** | `## 🔧 SUBAGENT BUILD WORKFLOW` below |
| "Analyze source code and extract tokens" | **ANALYZER** | `## 📊 ANALYZER WORKFLOW` below |
| "Verify page [name] has content" | **REVIEWER** | `## 🔍 REVIEWER WORKFLOW` below |

### ⚠️ Role → Sub-Skill Loading Matrix

| Role | MUST Load | SHOULD Load (Domain) | How to Load |
|------|-----------|----------------------|-------------|
| **ORCHESTRATOR** | Nothing | Nothing | — |
| **SUBAGENT** | `schema.md`, `layout-rules.md`, `role-definitions.md` | + `dashboard.md` (if dashboard page) | `read("openpencil-loop/...")` or `openpencil_get_design_prompt()` |
| **REVIEWER** | `schema.md` | Nothing | `read("openpencil-loop/...")` |
| **ANALYZER** | `design-system.md`, `schema.md` | Nothing | `read("openpencil-loop/...")` |

### Role Definitions:

```
ORCHESTRATOR (Coordinator - LIGHTWEIGHT):
├── Creates files: DESIGN.md, PROJECT.md, prompts/*.md
├── Creates pages: openpencil_add_page()
├── Dispatches subagents: task(prompt="Load sub-skills + Read prompts/XX...")
├── Dispatches reviewer: task(prompt="Load sub-skills + Verify page [name]...")
├── Saves work: openpencil_export_nodes() + filesystem_write_file()
├── Required sub-skills: None (coordination only)
└── NEVER: design_skeleton, design_content, insert_node (DELEGATE!)

SUBAGENT (Builder - HEAVY DESIGN WORK):
├── ⚠️ MANDATORY: Load sub-skills FIRST (see table below)
├── Reads: prompts/XX-prompt.md, DESIGN.md
├── Builds: design_skeleton, design_content, design_refine
├── Returns: "✅ Done. Orchestrator: Please verify and save."
├── Required sub-skills: schema.md, layout-rules.md, role-definitions.md
└── NEVER: add_page, export_nodes, save files

REVIEWER (Quality Gate - VERIFICATION ONLY):
├── ⚠️ MANDATORY: Load sub-skills FIRST (see table below)
├── Reads: prompts/XX-prompt.md to get pageId
├── Checks: openpencil_batch_get({ pageId, readDepth: 2 })
├── Verifies: node count > 1, children not empty
├── Returns: "PASS: X nodes found" or "FAIL: Only empty frame"
├── Required sub-skills: schema.md
└── NEVER: build designs, save files, modify anything

ANALYZER (Token Extractor):
├── ⚠️ MANDATORY: Load sub-skills FIRST (see table below)
├── Reads: src/**/*.js, src/**/*.tsx
├── Extracts: colors, typography, spacing
├── Writes: DESIGN.md
├── Required sub-skills: design-system.md, schema.md
└── NEVER: build designs
```

**⚠️ CRITICAL: Roles MUST load their required sub-skills BEFORE doing any work.**

### ⚠️ MANDATORY SUB-SKILL LOADING TABLE

| Role | Sub-Skills to Load | Full Path | Why Needed |
|------|-------------------|-----------|------------|
| **SUBAGENT** | `schema.md` | `openpencil-loop/phases/generation/schema.md` | PenNode structure - what valid nodes look like |
| | `layout-rules.md` | `openpencil-loop/phases/generation/layout-rules.md` | Auto-layout rules - how to structure flexbox |
| | `role-definitions.md` | `openpencil-loop/knowledge/role-definitions.md` | Semantic roles - button, card, navbar, table |
| | *(optional)* `design-system.md` | `openpencil-loop/phases/generation/design-system.md` | Token format - how to write DESIGN.md |
| | *(optional)* `text-rules.md` | `openpencil-loop/phases/generation/text-rules.md` | Typography rules - CJK, line height, sizing |
| | *(domain)* `dashboard.md` | `openpencil-loop/domains/dashboard.md` | Dashboard patterns - stats, charts, tables |
| **REVIEWER** | `schema.md` | `openpencil-loop/phases/generation/schema.md` | Know what valid nodes look like for verification |
| **ANALYZER** | `design-system.md` | `openpencil-loop/phases/generation/design-system.md` | Know what tokens to extract from source |
| | `schema.md` | `openpencil-loop/phases/generation/schema.md` | Understand node structure for component detection |
| **ORCHESTRATOR** | None | — | Coordination only - delegates all work |

### ⚠️ DOMAIN KNOWLEDGE (Load based on page type)

| Page Type | Domain File | Full Path | What It Contains |
|-----------|-------------|-----------|------------------|
| Dashboard | `dashboard.md` | `openpencil-loop/domains/dashboard.md` | Stats cards, charts, tables, filters, pagination |
| Landing Page | `landing-page.md` | `openpencil-loop/domains/landing-page.md` | Hero, features, CTA, footer, pricing |
| Form UI | `form-ui.md` | `openpencil-loop/domains/form-ui.md` | Form layouts, validation, multi-step, inputs |
| Mobile App | `mobile-app.md` | `openpencil-loop/domains/mobile-app.md` | 375x812 canvas, bottom nav, touch targets |
| CJK Typography | `cjk-typography.md` | `openpencil-loop/domains/cjk-typography.md` | Chinese/Japanese/Korean text handling |

### Sub-Skills Required by Role:

| Role | Required Sub-Skills | Load Via |
|------|---------------------|----------|
| **ORCHESTRATOR** | None (coordination only) | — |
| **SUBAGENT/BUILDER** | `schema.md`, `layout-rules.md`, `role-definitions.md` | `read()` or `openpencil_get_design_prompt()` |
| **REVIEWER** | `schema.md` | `read()` or `openpencil_get_design_prompt()` |
| **ANALYZER** | `design-system.md`, `schema.md` | `read()` or `openpencil_get_design_prompt()` |

### Sub-Skill File Locations:

```
openpencil-loop/
├── phases/generation/
│   ├── schema.md           ← PenNode structure (ALL roles except orchestrator)
│   ├── layout-rules.md     ← Auto-layout (SUBAGENT)
│   └── design-system.md    ← Token format (ANALYZER)
└── knowledge/
    └── role-definitions.md ← Semantic roles (SUBAGENT)
```

**⚠️ CRITICAL: If you don't know your role, ASK THE DISPATCHER. Do NOT assume.**

---

## 📚 SUB-SKILL QUICK REFERENCE CARD

**All sub-skill files live in:** `/Users/nam.lethanh/.config/opencode/skills/openpencil-loop/`

### Core Generation Skills (SUBAGENT must load):

| File | Path | Content |
|------|------|---------|
| **schema.md** | `phases/generation/schema.md` | PenNode types (frame, text, rectangle, etc.), properties, JSON schema |
| **layout-rules.md** | `phases/generation/layout-rules.md` | Auto-layout: flex, gap, padding, justifyContent, alignItems |
| **role-definitions.md** | `knowledge/role-definitions.md` | Semantic roles: button, card, navbar, table, form-input, etc. |
| **text-rules.md** | `phases/generation/text-rules.md` | Typography: font sizing, line height, CJK handling |
| **design-system.md** | `phases/generation/design-system.md` | Token format: how to write DESIGN.md |

### Domain Knowledge (Load based on page type):

| Domain | Path | Use When |
|--------|------|----------|
| **dashboard.md** | `domains/dashboard.md` | Building dashboards (stats, tables, charts, filters) |
| **landing-page.md** | `domains/landing-page.md` | Building marketing pages (hero, features, CTA) |
| **form-ui.md** | `domains/form-ui.md` | Building forms (inputs, validation, multi-step) |
| **mobile-app.md** | `domains/mobile-app.md` | Building mobile screens (375x812, touch targets) |
| **cjk-typography.md** | `domains/cjk-typography.md` | Chinese/Japanese/Korean text handling |

### Additional Knowledge:

| File | Path | Content |
|------|------|---------|
| **design-principles.md** | `knowledge/design-principles.md` | Design craft principles |
| **examples.md** | `knowledge/examples.md` | Component examples |
| **icon-catalog.md** | `knowledge/icon-catalog.md` | Available icon names |
| **copywriting.md** | `knowledge/copywriting.md` | Text/copy rules |

### Codegen Skills (ANALYZER/GOR code generation):

| File | Path | Content |
|------|------|---------|
| **codegen.md** | `knowledge/codegen/codegen.md` | Main codegen guide |
| **codegen-react.md** | `knowledge/codegen/codegen-react.md` | React component generation |
| **codegen-html.md** | `knowledge/codegen/codegen-html.md` | HTML generation |

---

## 🎯 ORCHESTRATOR WORKFLOW

**You are the ORCHESTRATOR. Your job is COORDINATION, not building.**

### What You DO:

| Phase | Actions | Tools |
|-------|---------|-------|
| **SETUP** | Create canvas/, DESIGN.md, PROJECT.md, prompts/*.md | `filesystem_*` |
| **CREATE PAGES** | Add pages to design.op | `openpencil_add_page()` |
| **DISPATCH** | Send subagents to build each page | `task(prompt="Read prompts/XX...")` |
| **VERIFY** | Send reviewer to check work | `task(prompt="Verify page [name] has content")` |
| **SAVE** | Export and save after PASS verification | `openpencil_export_nodes()`, `filesystem_write_file()` |

### What You NEVER Do:

```
❌ openpencil_design_skeleton()  → Delegate to subagent
❌ openpencil_design_content()   → Delegate to subagent
❌ openpencil_insert_node()      → Delegate to subagent
❌ Reading 50 source files       → Delegate to analyzer subagent
❌ Marking task done before VERIFIED → Must wait for reviewer PASS
```

### Quick Orchestrator Checklist:

```
1. [ ] Created canvas/design.op?
2. [ ] Created canvas/DESIGN.md?
3. [ ] Created canvas/PROJECT.md?
4. [ ] Created canvas/prompts/*.md for each page?
5. [ ] Added pages with openpencil_add_page()?
6. [ ] Updated prompts/*.md with pageIds?
7. [ ] Dispatched subagents to build?
8. [ ] Dispatched reviewers to verify? ← MANDATORY
9. [ ] Reviewer returned PASS? ← Only then...
10. [ ] Saved with openpencil_export_nodes()?
```

### ⚠️ MANDATORY: Verify Before Marking Done

**ALWAYS dispatch a reviewer after subagent completes:**

```
SUBAGENT returns: "✅ Page built with X nodes"
    ↓
ORCHESTRATOR dispatches REVIEWER: task(
    prompt="You are REVIEWER. 
            1. Load sub-skills: read('openpencil-loop/phases/generation/schema.md')
            2. Read: canvas/prompts/XX-prompt.md (get pageId)
            3. Check: openpencil_batch_get({ pageId, readDepth: 2 })
            4. Verify: node count > 1, children not empty
            5. Return: PASS or FAIL with evidence
            pageId: XXX"
)
    ↓
REVIEWER checks and returns: "PASS: X nodes found" or "FAIL: empty frame"
    ↓
IF PASS → Mark done, save file
IF FAIL → Re-dispatch subagent or escalate
```

**⚠️ Dispatch Prompt Templates (COPY-PASTE READY):**

```
# ═══════════════════════════════════════════════════════════════
# SUBAGENT DISPATCH TEMPLATE (Builder)
# ═══════════════════════════════════════════════════════════════

task(
    prompt="You are SUBAGENT/BUILDER. Your job is to BUILD ONE PAGE.
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  ⚠️  STEP 1: LOAD SUB-SKILLS (MANDATORY - DO NOT SKIP)       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Execute these reads BEFORE any other work:
            
            read('openpencil-loop/phases/generation/schema.md')
            → Learn PenNode structure (type, width, height, fill, stroke, children)
            
            read('openpencil-loop/phases/generation/layout-rules.md')
            → Learn auto-layout rules (flex, gap, padding, justifyContent, alignItems)
            
            read('openpencil-loop/knowledge/role-definitions.md')
            → Learn semantic roles (button, card, navbar, table, form-input)
            
            [IF DASHBOARD PAGE:]
            read('openpencil-loop/domains/dashboard.md')
            → Learn dashboard patterns (stats cards, tables, charts, filters)
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 2: READ CONTEXT FILES                                   ║
            ╚══════════════════════════════════════════════════════════════╝
            
            read('canvas/prompts/XX-prompt.md')  → Your task + pageId
            read('canvas/DESIGN.md')             → Design tokens (colors, typography)
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 3: BUILD WITH MCP TOOLS                                 ║
            ╚══════════════════════════════════════════════════════════════╝
            
            openpencil_open_document({ filePath: 'canvas/design.op' })
            openpencil_design_skeleton({ canvasWidth: 1200, rootFrame: {...}, sections: [...] })
            openpencil_design_content({ sectionId: '...', children: [...], postProcess: true })
            openpencil_design_refine({ rootId: '...' })
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 4: RETURN RESULTS (DO NOT SAVE)                         ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Return: '✅ [Page name] built with X nodes. Orchestrator: verify and save.'
            
            ⚠️ NEVER: openpencil_export_nodes(), filesystem_write_file(), add_page()
            These are ORCHESTRATOR tools. You only BUILD."
)

# ═══════════════════════════════════════════════════════════════
# REVIEWER DISPATCH TEMPLATE (Quality Gate)
# ═══════════════════════════════════════════════════════════════

task(
    prompt="You are REVIEWER. Your job is VERIFICATION ONLY.
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  ⚠️  STEP 1: LOAD SUB-SKILLS (MANDATORY - DO NOT SKIP)       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Execute this read BEFORE any other work:
            
            read('openpencil-loop/phases/generation/schema.md')
            → Learn what valid PenNode content looks like
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 2: GET PAGE ID                                         ║
            ╚══════════════════════════════════════════════════════════════╝
            
            read('canvas/prompts/XX-prompt.md')
            → Extract pageId from frontmatter
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 3: VERIFY CONTENT                                       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            openpencil_batch_get({ pageId: 'XXX', readDepth: 2 })
            
            CHECK:
            ✓ Node count > 1 (not just root frame)
            ✓ Root frame has children array
            ✓ Children array is not empty
            ✓ At least one section with content
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 4: RETURN VERDICT                                       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            PASS: '✅ PASS: Page [name] has X nodes with Y sections. Content verified.'
            FAIL: '❌ FAIL: Page [name] is empty (only root frame). Subagent did not build.'
            
            ⚠️ NEVER: build designs, save files, modify anything. READ-ONLY verification."
)

# ═══════════════════════════════════════════════════════════════
# ANALYZER DISPATCH TEMPLATE (Token Extractor)
# ═══════════════════════════════════════════════════════════════

task(
    prompt="You are ANALYZER. Your job is EXTRACTING TOKENS.
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  ⚠️  STEP 1: LOAD SUB-SKILLS (MANDATORY - DO NOT SKIP)       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Execute these reads BEFORE any other work:
            
            read('openpencil-loop/phases/generation/design-system.md')
            → Learn what tokens to extract (colors, typography, spacing, shadows)
            
            read('openpencil-loop/phases/generation/schema.md')
            → Understand component structure for detection
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 2: ANALYZE SOURCE FILES                                 ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Read: src/**/*.js, src/**/*.tsx, src/**/*.css
            
            EXTRACT:
            - Colors: primary, secondary, background, text, status (success/error/warning)
            - Typography: font-family, font-size, font-weight, line-height
            - Spacing: padding, margin, gap values
            - Components: button variants, card styles, input styles
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  STEP 3: WRITE DESIGN.MD                                      ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Write extracted tokens to: canvas/DESIGN.md
            
            ⚠️ NEVER: build designs, save .op files."
)
```

**⚠️ VIOLATION = SKILL FAILURE:**
- Marking task done without reviewer PASS
- Calling design_skeleton or insert_node yourself
- Skipping verification step

---

## 🔧 SUBAGENT BUILD WORKFLOW

**You are a SUBAGENT. Your job is BUILDING ONE PAGE.**

### ⚠️⚠️⚠️ PRE-FLIGHT CHECKLIST (MANDATORY - READ BEFORE ANY WORK)

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ STOP. READ THESE FILES FIRST OR YOUR BUILD WILL FAIL.        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. read("openpencil-loop/phases/generation/schema.md")        │
│     → Learn PenNode structure                                   │
│     → Know what type, width, height, fill, children mean        │
│     → Required to build VALID nodes                             │
│                                                                 │
│  2. read("openpencil-loop/phases/generation/layout-rules.md")  │
│     → Learn auto-layout (flexbox) rules                         │
│     → Know how to use layout, gap, padding, justifyContent      │
│     → Required to build CORRECT layouts                         │
│                                                                 │
│  3. read("openpencil-loop/knowledge/role-definitions.md")      │
│     → Learn semantic roles                                      │
│     → Know what role="button", role="card", role="table" mean   │
│     → Required to build SEMANTIC components                     │
│                                                                 │
│  4. [IF DASHBOARD] read("openpencil-loop/domains/dashboard.md")│
│     → Learn dashboard-specific patterns                         │
│     → Stats cards, tables, charts, filters, pagination          │
│     → Required for DASHBOARD pages                              │
│                                                                 │
│  ⚠️ SKIPPING THIS CHECKLIST = BUILD FAILURE                     │
│  ⚠️ YOUR NODES WILL BE INVALID WITHOUT THIS KNOWLEDGE           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Alternative: Use MCP Design Prompt (Faster)

```javascript
// Instead of reading 3 files, use MCP:
openpencil_get_design_prompt({ section: "schema" })  // PenNode schema
openpencil_get_design_prompt({ section: "layout" })  // Layout rules
openpencil_get_design_prompt({ section: "roles" })   // Semantic roles
openpencil_get_design_prompt({ section: "all" })     // Everything
```

### Your Task (from prompts/XX-prompt.md):

1. **LOAD** sub-skills (see checklist above) - ⛔ MANDATORY - DO NOT SKIP
2. **READ** your prompt file: `canvas/prompts/XX-prompt.md`
3. **READ** design tokens: `canvas/DESIGN.md`
4. **BUILD** using OpenPencil MCP tools
5. **RETURN** results - do NOT save

### MCP Tools to Use:

```
openpencil_open_document({ filePath: "canvas/design.op" })
openpencil_design_skeleton({ canvasWidth: 1200, rootFrame: {...}, sections: [...] })
openpencil_design_content({ sectionId: "...", children: [...], postProcess: true })
openpencil_design_refine({ rootId: "..." })
```

### What You NEVER Do:

```
❌ openpencil_add_page()         → Orchestrator only
❌ openpencil_export_nodes()     → Orchestrator only
❌ filesystem_write_file()       → Orchestrator only
```

### Success Message:

```
✅ [Page name] built with X nodes. Orchestrator: Please verify with reviewer, then save.
```

---

## 📊 ANALYZER WORKFLOW

**You are an ANALYZER. Your job is EXTRACTING TOKENS.**

### ⚠️⚠️⚠️ PRE-FLIGHT CHECKLIST (MANDATORY - READ BEFORE ANY ANALYSIS)

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ STOP. READ THESE FILES FIRST OR YOUR EXTRACTION WILL FAIL.   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. read("openpencil-loop/phases/generation/design-system.md") │
│     → Learn what tokens to extract                               │
│     → Colors, typography, spacing, shadows, components           │
│     → Required to KNOW WHAT TO LOOK FOR                          │
│                                                                 │
│  2. read("openpencil-loop/phases/generation/schema.md")        │
│     → Understand PenNode structure for component detection       │
│     → Know what type, name, fill, fontSize look like             │
│     → Required to DETECT COMPONENTS in source                    │
│                                                                 │
│  ⚠️ SKIPPING THIS CHECKLIST = EXTRACTION FAILURE                 │
│  ⚠️ YOU WILL MISS TOKENS WITHOUT THIS KNOWLEDGE                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Your Task:

1. **LOAD** sub-skills (see checklist above) - ⛔ MANDATORY
2. **READ** source files: `src/**/*.js`, `src/**/*.tsx`
3. **EXTRACT** tokens: colors, typography, spacing, components
4. **WRITE** to `canvas/DESIGN.md`
5. **RETURN** summary

### What You NEVER Do:

```
❌ Build designs → Not your job
❌ Save .op files → Not your job
```

---

## 🔍 REVIEWER WORKFLOW

**You are a REVIEWER. Your job is VERIFICATION ONLY.**

### ⚠️⚠️⚠️ PRE-FLIGHT CHECKLIST (MANDATORY - READ BEFORE ANY VERIFICATION)

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ STOP. READ THIS FILE FIRST OR YOUR VERIFICATION WILL FAIL.   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. read("openpencil-loop/phases/generation/schema.md")        │
│     → Learn what valid PenNode content looks like               │
│     → Know what type, children, fill, stroke should contain     │
│     → Required to DETECT EMPTY vs VALID nodes                   │
│                                                                 │
│  ⚠️ SKIPPING THIS CHECKLIST = VERIFICATION FAILURE               │
│  ⚠️ YOU CANNOT TELL IF A NODE IS EMPTY WITHOUT THIS KNOWLEDGE    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Your Task:

1. **LOAD** sub-skills (see checklist above) - ⛔ MANDATORY
2. **READ** the prompt file to get pageId: `canvas/prompts/XX-prompt.md`
3. **CHECK** the page content: `openpencil_batch_get({ pageId, readDepth: 2 })`
4. **VERIFY** the page has actual content (not just empty frame)
5. **RETURN** PASS or FAIL with evidence

### Verification Checklist:

```
✅ PASS criteria (ALL must be true):
   1. Node count > 1 (not just root frame)
   2. Root frame has children array
   3. Children array is not empty
   4. At least one section with content

❌ FAIL criteria (ANY is true):
   1. Only 1 node (empty frame)
   2. Children array is []
   3. Root frame name is just "Frame" (default, not named)
```

### MCP Tools to Use:

```
openpencil_open_document({ filePath: "canvas/design.op" })
openpencil_batch_get({ pageId: "FROM_PROMPT_FILE", readDepth: 2 })
```

### What You NEVER Do:

```
❌ Build designs      → Not your job
❌ Save files         → Not your job
❌ Modify anything    → Read-only verification
❌ Assume pageId      → Must read from prompt file
```

### Success Messages:

```
PASS: Page [name] has X nodes with Y sections. Content verified.
FAIL: Page [name] is empty (only root frame). Subagent did not build anything.
FAIL: Page [name] has only 1 node with empty children. Build failed.
```

---

## Architecture: Sub-Skills Reference

```
openpencil-loop/
├── SKILL.md                       ← Main orchestrator (THIS FILE)
├── TEST-SPEC.md                   ← Regression test suite (RUN AFTER UPDATES)
├── phases/
│   ├── planning/
│   │   ├── design-type.md        ← Design type detection
│   │   └── decomposition.md      ← Task decomposition
│   ├── prompt-enhancement/
│   │   └── prompt-enhancement.md ← Stitch-style prompt enhancement
│   ├── generation/
│   │   ├── design-system.md      ← Design token generation
│   │   ├── jsonl-format.md       ← PenNode JSONL format
│   │   ├── layout-rules.md       ← Auto-layout rules
│   │   ├── text-rules.md         ← Text node rules
│   │   └── schema.md             ← PenNode schema reference
│   ├── validation/
│   │   └── vision-feedback.md    ← Vision QA (MCP: batch_get, snapshot_layout)
│   ├── maintenance/
│   │   ├── local-edit.md         ← Update nodes (MCP: batch_design, update_node, delete_node)
│   │   └── incremental-add.md    ← Add nodes (MCP: batch_design, insert_node, copy_node)
│   └── codegen/
│       ├── analyze.md            ← Project structure & design validation
│       ├── discover.md           ← Find existing implementations in src/
│       ├── deduplicate.md        ← SHA256-based component deduplication
│       └── generate.md           ← Production code generation with safety
├── knowledge/
│   ├── codegen/
│   │   ├── codegen.md            ← Codegen main (MCP: export_nodes)
│   │   ├── codegen-react.md      ← React (MCP: export_nodes)
│   │   └── codegen-html.md       ← HTML (MCP: export_nodes)
│   ├── role-definitions.md       ← Semantic roles
│   ├── icon-catalog.md           ← Icon names
│   ├── design-principles.md      ← Design craft principles
│   ├── examples.md               ← Component examples
│   └── copywriting.md            ← Copy rules
├── domains/
│   ├── landing-page.md           ← Landing page patterns
│   ├── dashboard.md              ← Dashboard patterns
│   ├── mobile-app.md             ← Mobile app patterns
│   ├── form-ui.md                ← Form patterns
│   └── cjk-typography.md         ← CJK typography
├── templates/
│   ├── DESIGN.md                 ← Design spec template
│   ├── PROJECT.md                ← Project template
│   ├── prompts-template.md         ← Multi-agent task prompt template
│   ├── prompts-template.md         ← Multi-agent task prompt template
│   └── codegen-state.md          ← Codegen state baton template
├── scripts/
│   ├── run-tests.sh              ← Test runner
│   ├── init-project.sh           ← Project setup
│   └── test-run.sh               ← Smoke test
├── evals/
│   ├── eval-0/, eval-1/, eval-2/
│   ├── evals.json
│   └── metadata.json
└── reference/
    └── mcp-tool-index.md        ← Complete MCP tool reference (90+ tools)
```

## When to Use

Activate when you need ANY of these capabilities:
- **Design a new page** — Transform vague ideas into structured OpenPencil prompts with design system context
- **Continue existing project** — Pick up from `prompts/*.md` files and PROJECT.md
- **Create design system** — Generate `.op/DESIGN.md` with user confirmation for colors, typography, components
- **Enhance prompts** — Add design system tokens, structure, and visual descriptions to vague user requests
- **Codify user decisions** — Store user preferences in DESIGN.md for consistency across iterations
- **Export code** — Generate React/Vue/SwiftUI components from OpenPencil designs

---

## Design Files: Orchestrator-Owned Source of Truth

**⚠️ CRITICAL: These files are the ONLY reliable source of truth. The live canvas is volatile and can be lost.**

The orchestrator MUST create, maintain, and protect these files. Subagents read from them — they do NOT create or modify them.

### The 3 Design File Types

| File | Purpose | Owner | Persists? |
|------|---------|--------|-----------|
| **`canvas/*.op`** | Visual canvas — actual design nodes | Orchestrator | ✅ Yes (via export) |
| **`canvas/DESIGN.md`** | Design tokens — colors, typography, spacing, components | Orchestrator | ✅ Yes (file) |
| **`canvas/PROJECT.md`** | Roadmap — completed pages, next tasks, decisions | Orchestrator | ✅ Yes (file) |

### Why These Files Matter

```
SUBAGENT STARTS WORK
    ↓
Reads DESIGN.md → understands tokens, colors, typography
Reads PROJECT.md → knows what's done, what's next
Reads *.op file → sees existing designs
    ↓
Subagent works on assigned pageId only
    ↓
Returns results to orchestrator
    ↓
ORCHESTRATOR updates DESIGN.md/PROJECT.md/*.op
    ↓
Next subagent reads updated files → fresh context
```

**Without these files:** Each subagent must re-analyze source code from scratch → wasted time, inconsistent interpretation.

**With these files:** Subagent reads, understands, and continues in minutes.

### Orchestrator File Management Responsibilities

| Task | How | When |
|------|-----|-------|
| **Create DESIGN.md** | Copy from `templates/DESIGN.md`, fill with project tokens | Once at project start |
| **Create PROJECT.md** | Copy from `templates/PROJECT.md`, fill with sitemap | Once at project start |
| **Update DESIGN.md** | Add new tokens, component specs as discovered | After each page analyzed |
| **Update PROJECT.md** | Mark pages complete, add next tasks | After each page done |
| **Export canvas to .op** | `openpencil_export_nodes()` + `filesystem_write_file()` | After each session + before session end |
| **Read .op before work** | `openpencil_batch_get()` + `read(".op")` to compare | Every session start |

### ⚠️ CRITICAL: .op File Is The Canvas Snapshot

The `.op` file is NOT the source of truth during work — it's a **snapshot** saved by the orchestrator.

```
Session Start:
  1. Read .op file → know what's already designed
  2. Read DESIGN.md → know the design system
  3. Read PROJECT.md → know roadmap
  4. openpencil_open_document() → sync live canvas

During Session:
  - Work on live canvas (in-memory)
  - Subagents build pages on assigned pageIds

Session End (ORCHESTRATOR MUST):
  1. openpencil_export_nodes() → get all nodes
  2. filesystem_write_file() → persist to .op
  3. Update PROJECT.md → mark completed
  4. Update DESIGN.md → document any new tokens
```

### File Structure Convention

```
canvas/
├── design.op        ← OpenPencil canvas (orchestrator-exported)
├── DESIGN.md        ← Design tokens (orchestrator-maintained)
├── PROJECT.md       ← Roadmap + status (orchestrator-maintained)
└── prompts/         ← Task prompts for subagents (orchestrator-created)
    ├── 01-login-prompt.md
    ├── 02-dashboard-prompt.md
    └── 03-settings-prompt.md
```

### Prompt Files vs Baton File

**`prompts/*.md` (Multi-agent, RECOMMENDED):**
- One file per task/page
- Explicit session tracking
- Orchestrator updates status
- Subagent reads and executes

**Legacy baton format removed.** Use `prompts/*.md` for all multi-agent work.

**Orchestrator MUST:**
- Create these files at project start
- Update them after each significant milestone
- Read them BEFORE dispatching subagents
- Export/save .op file BEFORE session end

**Subagents MUST:**
- Read DESIGN.md and PROJECT.md at start
- Never create or modify these files
- Return results + remind orchestrator to update

## Prerequisites

**Required:** OpenPencil MCP Server (`openpencil` — 34 tools, no desktop app needed)

**Optional:** OpenPencil CLI (`npm install -g @zseven-w/openpencil`), `.op/DESIGN.md` file, design reference images in `.op/references/`

## Quick Start

**⚠️ Step 0: Create and populate design files FIRST (orchestrator only)**

```bash
# 1. Create canvas directory
mkdir -p canvas

# 2. Create .op file (empty canvas)
echo '{"version":"1.0.0","children":[]}' > canvas/design.op

# 3. Copy templates (ORCHESTRATOR creates these)
cp openpencil-loop/templates/DESIGN.md canvas/DESIGN.md
cp openpencil-loop/templates/PROJECT.md canvas/PROJECT.md

# 4. Populate DESIGN.md from source code analysis
# (This is the orchestrator's job — see DESIGN.md file for template)
```

**Minimal working sequence to create a design from scratch:**

```bash
# 1. Open canvas via MCP (connects to .op file)
openpencil_open_document({ filePath: "canvas/design.op" })
// → returns { document, context, designPrompt }

# 2. Create page structure
openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: "Page", width: 375, height: 812 }, sections: [...] })
// → returns { rootId, sections: [{ id, name, guidelines, suggestedRoles }] }

# 3. Add content to a section
openpencil_design_content({ sectionId: "section-id", children: [...], postProcess: true })

# 4. Validate + auto-fix
openpencil_design_refine({ rootId: "root-id" })

# 5. BEFORE SESSION END: Export canvas to .op file
openpencil_export_nodes()
// → save result to filesystem_write_file()
```

### `.op` File Format

The `.op` file must use this JSON structure (NOT `{"pages":[...]}`):

```json
{
  "version": "1.0.0",
  "children": []
}
```

**Note:** `init-project.sh` creates a file with `{"pages":[...]}` format. `open_document` automatically rewrites it to the correct format when opened. For manual creation, use the structure above.

### Prerequisites for `design_skeleton`

`design_skeleton` requires an **existing valid `.op` file**. It will fail with `ENOENT` if the file doesn't exist, or `Invalid document format` if the JSON is malformed.

## ⚠️ CRITICAL: No File Persistence + Session State Sync Issues

**`openpencil_*` tools operate IN-MEMORY ONLY** — changes are NOT written to disk!

### Session State Verification (MANDATORY BEFORE ANY WORK)

**⚠️ IMPORTANT:** Always check BOTH sources before starting work. MCP session state is NOT synchronized with:
1. The `.op` file on disk
2. The OpenPencil desktop app's live canvas

| Check | Tool | Expected |
|-------|------|----------|
| File on disk | `read("canvas/design.op")` | Actual node data or `{"version":"1.0.0","children":[]}` if empty |
| Live canvas | `openpencil_batch_get()` (no filePath) | Actual node data or `[]` if empty |

**DISCREPANCY SCENARIOS:**

| File Content | Live Canvas | Meaning |
|--------------|-------------|---------|
| Has nodes | Has nodes | Both in sync ✅ |
| Has nodes | Empty `[]` | Session reset — file has work, canvas lost |
| Empty `[]` | Has nodes | Desktop app has unsaved work, session doesn't see it |
| Empty `[]` | Empty `[]` | All lost — start fresh |

**⚠️ CRITICAL BUG:** After session reset/compaction, `openpencil_batch_get()` returns empty even if desktop app still shows designs. The MCP session disconnects from desktop app state.

### Recommended Pre-flight Workflow

```
1. openpencil_open_document({ filePath: "canvas/design.op" })
   → Check document.childCount / document.pageCount metadata

2. openpencil_export_nodes()
   → Check if nodes array is non-empty

3. read("canvas/design.op")
   → Compare with export_nodes() result

4. If discrepancy found:
   - File has work, canvas empty → Use file data, rebuild canvas
   - Canvas has work, file empty → Export canvas, write to file
   - Both empty → Start fresh

5. Document findings in baton file:
   "State: [file: X nodes | canvas: Y nodes | action: ...]"
```

| Behavior | What Happens |
|----------|--------------|
| After `insert_node` / `batch_design` | Nodes exist in live canvas |
| `.op` file on disk | Still `{"version":"1.0.0","children":[]}` |
| Re-opening the file | **ALL WORK LOST** — empty document |
| `batch_get({ filePath })` | Returns empty (reads from disk) |
| `batch_get()` (no filePath) | Shows nodes (reads from memory) |

### Workaround: Manual Export

After each session, manually persist your work:

```javascript
// 1. Get the nodes from live canvas
const nodes = openpencil_batch_get({ readDepth: 5 })

// 2. Export to JSON file (manual write)
filesystem_write_file({ 
  path: "canvas/design.op", 
  content: JSON.stringify({ version: "1.0.0", children: nodes.nodes }, null, 2)
})

// OR use export_nodes to get raw PenNode JSON
const exported = openpencil_export_nodes()
filesystem_write_file({ path: "canvas/design-export.json", content: JSON.stringify(exported) })
```

**Root Cause:** The `openpencil` MCP server (port 3100) has no `save_file` tool. The `open-pencil` server (port 7600) has `save_file` but requires the desktop app.

**Recommendation:** Run OpenPencil desktop app and use `open-pencil_*` tools if you need file persistence, or manually write the `.op` file after each session.

---

## Known Issues & Limitations

| Issue | Severity | Workaround |
|-------|---------|-----------|
| **NO FILE PERSISTENCE** | 🔴 CRITICAL | See above — manually export after each session |
| **SESSION STATE NOT SYNCED** | 🔴 CRITICAL | After reset/compaction, canvas appears empty. ALWAYS check both file + canvas before work (see State Verification above) |
| **Concurrent sub-agent file saves** | 🔴 CRITICAL | Sub-agents MUST NOT save files. Only orchestrator saves. Sub-agents must remind orchestrator to save after completion. |
| **Subagents working on wrong page** | 🔴 CRITICAL | Orchestrator MUST pass explicit `pageId` to each subagent. Subagents must NEVER omit pageId. |
| **Subagent returns done but built nothing** | 🔴 CRITICAL | **MANDATORY: Dispatch reviewer after every subagent completion.** Reviewer verifies nodes exist before marking done. |
| **Background subagents may lack MCP access** | 🔴 CRITICAL | If subagent can't access MCP tools, use `run_in_background=false` for synchronous execution with tool access. |
| **`pageId` targets wrong page** | High | Multi-page operations on page 2+ fail. Workaround: operate on page 1 only, or use `add_page`/`duplicate_page` to re-create pages |
| **`batch_design D()` silently no-ops** | High | Use `delete_node` for single node deletion. D() in batch DSL does not work |
| **`copy_node` param is `sourceId`, not `nodeId`** | Medium | Always use `sourceId` when calling `copy_node` |
| **`design_skeleton` creates equal-width sections** | Medium | Sections get equal split of parent width. For asymmetric splits (e.g. 520/680), use `update_node` after skeleton creation to set explicit `width` |
| **`delete_node` only works for top-level nodes** | Medium | Cannot delete nested children directly. Workaround: move node to root first, then delete |
| **`batch_design` DSL fails on complex nested JSON** | Medium | For complex multi-node trees, use `insert_node` per-node or the layered `design_skeleton → design_content → design_refine` workflow |
| **`open_document` auto-rewrites `.op` format** | Low | Files created with `{"pages":[...]}` are auto-corrected to `{"version":"1.0.0","children":[]}` on open. Manual `.op` creation should use correct format |
| **No MCP screenshot capability** | Medium | Visual validation requires Playwright browser automation or manual capture from OpenPencil app |

---

## Testing

**After ANY update to this skill, run the regression test suite:**

```bash
# Read and follow TEST-SPEC.md
read("openpencil-loop/TEST-SPEC.md")

# Quick checklist:
# 1. MCP naming: openpencil_* works, open-pencil_* does not
# 2. File persistence: manual save workaround works
# 3. Parallel build: multi-page works
# 4. Sub-agent discipline: pattern documented
# 5. Minimal prompts: all 5 tests pass
```

**Full test spec:** `TEST-SPEC.md` — 6 test categories, 15+ individual tests, regression checklist.

## Multi-Agent Compatibility

This skill works across agent frameworks. Workflow, file formats, and phase logic are identical — only tool invocation syntax differs.

### ⚠️ CRITICAL: Sub-Agent File Save Discipline

**Sub-agents MUST NOT save files.** Only the orchestrator can save files.

| Role | Can Save? | Reason |
|------|-----------|--------|
| **Orchestrator** | ✅ YES | Single point of file write — prevents race conditions |
| **Sub-agent** | ❌ NO | Concurrent file writes cause data loss/corruption |

**Sub-agent pattern:**
```
1. Sub-agent completes work (design, validation, etc.)
2. Sub-agent returns result + REMINDS orchestrator:
   "✅ Work complete. Orchestrator: Please save the file now."
3. Orchestrator collects all sub-agent results
4. Orchestrator saves file ONCE
```

**Why this matters:**
- Multiple sub-agents saving same file → race condition → data loss
- Sub-agents may overwrite each other's work
- Only orchestrator has full context to merge results correctly

| Framework | Task Orchestration | Tool Call | File I/O |
|-----------|-------------------|-----------|----------|
| **OpenCode** | `task(category, load_skills, ...)` | `openpencil_*()` direct tool calls | `read()`, `write()`, `edit()` |
| **Claude Code** | Background tasks via tool_use | `mcp__open_pencil__<tool>(args)` | `Read`, `Write`, `Edit` |
| **Codex** | `Agent.run()` or subprocess | HTTP MCP client or CLI | `fs.readFile`, `fs.writeFile` |
| **Aider** | Sequential (no native subagents) | CLI subprocess or HTTP | File read/write |
| **Custom** | Any orchestrator | MCP JSON-RPC or HTTP | Any filesystem API |

### OpenCode Tool Call Pattern

**OpenCode users**: The `openpencil_*` tools are **native tools** — call them directly without `skill_mcp`:

```
// ✅ CORRECT — native tools, call directly:
openpencil_open_document({ filePath: "canvas/design.op" })
openpencil_batch_design({ operations: [...] })
openpencil_add_page({ name: "LoginScreen" })
openpencil_insert_node({ parent: "rootId", data: {...} })
openpencil_export_nodes({ filePath: "canvas/design.op" })

// ❌ NOT NEEDED — skill_mcp not required for openpencil tools:
skill_mcp({ mcp_name: "openpencil", tool_name: "batch_design", arguments: {...} })
```

### Generic Patterns (Other Frameworks)

```
// OpenCode — call directly:
openpencil_batch_get({ filePath, parentId, readDepth })

// Claude Code — use mcp prefix:
mcp__openpencil__batch_get({ filePath, parentId, readDepth })

// Codex — use MCP client:
await openpencilMcp.batch_get({ filePath, parentId, readDepth })

// Task Dispatch — CORRECT pattern (read file + inject content):
// 1. Read the sub-skill file directly
// 2. Inject content into prompt with load_skills=[]
read("openpencil-loop/phases/planning/design-type.md")
task(category="ultrabrain", load_skills=[], run_in_background=true, prompt="SUB-SKILL:\n${fileContent}\n\nTASK: ...")

// ❌ WRONG — load_skills does not support nested sub-skills:
// task(category="ultrabrain", load_skills=["design-type"], ...)  // will not load correctly
```

## Task Management

This skill uses **task orchestration** to avoid context dilution. The Build Loop follows 4 phases per loop type, each mapped to a task entry. Spawn subagents for each independent task.

### Sub-Skill Loading Pattern

**IMPORTANT:** Sub-skill files cannot be loaded via `load_skills=[...]`. The ECC skill loader does not support nested sub-skills. You MUST read the file directly and inject its content into the task prompt.

```
❌ WRONG (does not work):
task(category="ultrabrain", load_skills=["design-type"], prompt="...")

✅ CORRECT (read file + inject content):
read("openpencil-loop/phases/planning/design-type.md")
// → inject file content into prompt
task(category="ultrabrain", load_skills=[], prompt="CONTENT:\n${fileContent}\n\nTASK: ...")
```

### Sub-Skill File Reference

| Category | Sub-Skill Files | When to Use |
|----------|----------------|-------------|
| **Planning** | `phases/planning/design-type.md`, `decomposition.md` | User gives new design request |
| **Prompt Enhancement** | `phases/prompt-enhancement/prompt-enhancement.md`, `knowledge/role-definitions.md` | Transform vague ideas into structured prompts |
| **Generation** | `phases/generation/design-system.md`, `schema.md`, `layout-rules.md`, `text-rules.md`, `jsonl-format.md` | Build each section |
| **Validation** | `phases/validation/vision-feedback.md` | Design is built, validate quality |
| **Maintenance** | `phases/maintenance/local-edit.md`, `incremental-add.md` | Edit or add to existing design |
| **CodeGen** | `phases/codegen/analyze.md`, `discover.md`, `deduplicate.md`, `generate.md` | Production code generation |
| **Knowledge** | `knowledge/role-definitions.md`, `icon-catalog.md`, `design-principles.md`, `examples.md`, `copywriting.md` | Prompt enhancement, semantic roles |
| **Domains** | `domains/landing-page.md`, `dashboard.md`, `mobile-app.md`, `form-ui.md`, `cjk-typography.md` | Match design type to domain |
| **Codegen Guides** | `knowledge/codegen/codegen.md`, `codegen-react.md`, `codegen-html.md` | Framework-specific code generation |

### Phase-Based Tasks

> **Critical:** Always use `load_skills=[]` and inject sub-skill file content directly into the prompt. See **Sub-Skill Loading Pattern** above.

| Task | Category | Sub-Skill Files | When to Use |
|------|----------|----------------|-------------|
| **Phase 1: PLANNING** | `ultrabrain` | `design-type.md`, `decomposition.md` | User gives new design request |
| **Phase 2: GENERATION** | `ultrabrain` | `design-system.md`, `schema.md`, `layout-rules.md`, `text-rules.md`, `jsonl-format.md` | Have decomposed plan, build each section |
| **Phase 3: VALIDATION** | `unspecified-high` | `vision-feedback.md` | Design is built, validate quality |
| **Phase 4: MAINTENANCE** | `ultrabrain` | `local-edit.md`, `incremental-add.md` | User wants to edit or add to existing design |
| **CodeGen: ANALYZE** | `unspecified-high` | `analyze.md` | Project structure check, design validation |
| **CodeGen: DISCOVER** | `explore` | `discover.md` | Find existing implementations in src/ |
| **CodeGen: DEDUPE** | `unspecified-high` | `deduplicate.md` | Hash-based component deduplication |
| **CodeGen: GENERATE** | `deep` | `generate.md` | Production code generation |

### Supporting Tasks

| Task | Category | Sub-Skill Files | When to Use |
|------|----------|----------------|-------------|
| **Prompt Enhancement** | `unspecified-high` | `prompt-enhancement.md`, `role-definitions.md` | User input is vague or needs structure |
| **DESIGN.md Creation** | `ultrabrain` | `design-system.md` | DESIGN.md missing and user confirms |
| **DESIGN.md Read** | `explore` | — | Check for existing DESIGN.md |
| **Domain Selection** | `ultrabrain` | `landing-page.md`, `dashboard.md`, `mobile-app.md`, `form-ui.md`, `cjk-typography.md` | Match design type to domain |
| **Project Documentation** | `writing` | `examples.md` | Updating PROJECT.md |

### Parallel Task Dispatch

Spawn independent tasks with `run_in_background=true`. Use consistent pageId conventions for multi-page work.

**Always use `load_skills=[]` and inject sub-skill content directly:**

```typescript
// CORRECT — read file + inject content:
const designTypeContent = read("openpencil-loop/phases/planning/design-type.md")
const decompositionContent = read("openpencil-loop/phases/planning/decomposition.md")

task(
  category="ultrabrain",
  load_skills=[],  // ALWAYS empty — sub-skills cannot be loaded
  run_in_background=true,
  prompt=`
SUB-SKILL CONTENT (design-type.md):
${designTypeContent}

SUB-SKILL CONTENT (decomposition.md):
${decompositionContent}

TASK: Detect design type and decompose: [user request]

⚠️ IMPORTANT: Do NOT save files. Return your result and remind the orchestrator to save.
[...remaining prompt details...]
`
)
```

**Sub-agent reminder template (include in every task prompt):**
```
⚠️ FILE SAVE RULE: You are a sub-agent. Do NOT save any files.
After completing your work, return results and remind the orchestrator:
"✅ [Task name] complete. Orchestrator: Please save the file now."
```

## Decision Workflow

| Decision | Type | What to Ask / Default |
|----------|------|----------------------|
| **Design System** | Critical | "No DESIGN.md found. Create one with default values or customize?" |
| **Colors** | Critical | "Color palette: Primary (accent), Background, Text roles?" |
| **Typography** | Critical | "Font families for headings, body? (e.g., Space Grotesk + Inter)" |
| **Spacing/Shadow** | Critical | "Spacing approach (8px grid)? Shadow depth (subtle/medium/elevated)?" |
| **Components** | Critical | "Button shape, card roundness, input style preferences?" |
| **Export Format** | Critical | "Export to code? (React/Vue/SwiftUI/Flutter/etc.)" |
| **Layout** | Medium | Default: Vertical. Offer: "Vertical or horizontal layout?" |
| **Color Palette** | Medium | Default: Zinc/Slate base. Offer: "Warm or cool gray base?" |
| **Responsive** | Medium | Default: Mobile-first. Offer: "Mobile-first or desktop-first?" |
| **Density** | Medium | Default: Balanced (5/10). Offer: "Gallery airy or cockpit dense?" |
| **Prompt enhancement** | Auto | Add structure, visual descriptions |
| **Component styling** | Auto | Apply semantic roles with smart defaults |
| **Project structure** | Auto | Section-based with sitemap tracking |
| **Export location** | Auto | `src/components/` or `lib/widgets/` |

## Overview

The Build Loop pattern enables continuous, autonomous design development through a "baton" system. Two mode sets:

- **Design Build Loop:** PLANNING → GENERATION → VALIDATION → MAINTENANCE → (repeat)
- **Codegen Build Loop:** ANALYZE → DISCOVER → DEDUPE → GENERATE

Each codegen iteration uses `.op/codegen-state.md` to pass state between phases.

### Enhance Prompt Example

Transforms vague input into structured OpenPencil-ready prompts with design system context. Triggered automatically when user input lacks structure.

**Original:** `make me a login page`

**Enhanced:** Design a modern login page with clean visual hierarchy. Include DESIGN SYSTEM section (typography, colors, spacing, component tokens), Page Structure (left panel hero + right panel form with email/password inputs, forgot password link, sign in button, social login row, signup footer link), Layout notes (horizontal split desktop 1200px), and Visual Notes (subtle shadow, rounded inputs).

See `prompt-enhancement` sub-skill for the full transformation pipeline.

## Phase Workflow Summary

**Design Build Loop** (for UI design):

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| 1. PLANNING | Phase 1: PLANNING | design-type.md, decomposition.md | design_skeleton |
| 2. GENERATION | Phase 2: GENERATION | design-system.md, schema.md, layout-rules.md, text-rules.md, jsonl-format.md | batch_design, insert_node |
| 3. VALIDATION | Phase 3: VALIDATION | vision-feedback.md | batch_get, snapshot_layout |
| 4. MAINTENANCE | Phase 4: MAINTENANCE | local-edit.md, incremental-add.md | batch_design, update_node, delete_node |

| **Codegen Build Loop** (for production code) — **2-step process** |

| Phase | Task | Key Sub-Skills | MCP Tools |
|-------|------|----------------|-----------|
| **Step 1: Export** | CodeGen Phase 1-3 | analyze.md, discover.md, deduplicate.md | `export_nodes` returns PenNode JSON |
| **Step 2: Generate** | CodeGen Phase 4: GENERATE | generate.md | Feed JSON + `get_design_prompt(section: "codegen-react")` to AI model |

**Codegen is 2-step:** `export_nodes` returns raw PenNode JSON — it does NOT generate React/HTML code. Use the exported JSON as input to an LLM with `get_design_prompt(section: "codegen-react")` (or vue/swiftui/compose/etc.) providing framework-specific codegen guidance.

For detailed phase content, see the sub-skill files referenced above. Baton template: `templates/codegen-state.md`

## OpenPencil MCP Tools

All tools are called directly: `openpencil_<tool_name>({ arguments })`. See **Multi-Agent Compatibility** for Claude Code/Codex syntax.

```javascript
// Document: openpencil_open_document({ filePath })
// Read: openpencil_batch_get({ filePath, parentId, readDepth })
// CRUD: openpencil_insert_node, openpencil_update_node, openpencil_delete_node, openpencil_move_node, openpencil_copy_node, openpencil_replace_node
//       All support pageId to target specific page (defaults to first page — ⚠️ KNOWN ISSUE: pageId may target wrong page for page 2+)
// Batch DSL: openpencil_batch_design({ operations, postProcess, pageId })
// Layered: openpencil_design_skeleton, openpencil_design_content, openpencil_design_refine
// Variables: openpencil_get_variables, openpencil_set_variables, openpencil_set_themes
// Design MD: openpencil_get_design_md, openpencil_set_design_md, openpencil_export_design_md
// Layout: openpencil_snapshot_layout({ maxDepth }), openpencil_find_empty_space({ width, height, direction })
// Pages: openpencil_add_page, openpencil_remove_page, openpencil_rename_page, openpencil_reorder_page, openpencil_duplicate_page
// Import/Export: openpencil_import_svg({ svgPath }), openpencil_export_nodes({ filePath })
// Knowledge: openpencil_get_design_prompt({ section: "schema" })
```

**MCP Cannot Do:** Screenshot capture (use Playwright), AI code generation (use AI with knowledge files), Trigger sub-skills (use read() or task())

**Full MCP Reference:** `reference/mcp-tool-index.md` (34 tools with arguments)

## Agent Platform Tools Reference

Beyond MCP, this skill uses built-in agent tools. Full syntax mapping per framework:

| Category | Purpose | OpenCode | Claude Code | Codex |
|----------|---------|----------|-------------|-------|
| **Filesystem** | Read/write/edit files, list dirs, search, create dirs | `read()`, `write()`, `edit()`, `filesystem_*()` | `Read`, `Write`, `Edit`, `Glob`, `Bash` | `fs.*`, `glob.sync()` |
| **LSP** | Diagnostics, goto def, find refs, symbols, rename | `lsp_diagnostics()`, `lsp_goto_definition()`, etc. | `Bash(tsc --noEmit)` | LSP client |
| **AST** | Search/replace code patterns | `ast_grep_search()`, `ast_grep_replace()` | ast-grep CLI | ast-grep CLI |
| **Task Mgmt** | Create/list/get/update/delete tasks | `task_create()`, `task_list()`, `task_update()` | `TodoWrite`, `TodoRead` | Custom tracker |
| **Browser** | Screenshot, navigate, snapshot | `playwright_browser_*()` | Playwright CLI | Puppeteer |
| **Session** | Background tasks, output collection, cancel | `task(run_in_background)`, `background_output()`, `background_cancel()` | tool_use background | `Agent.run(background)` |

**Codegen phase → tool mapping:**
- **Analyze:** `read()`, `lsp_diagnostics()`, `filesystem_list_directory()` — check .op file, scan project
- **Discover:** `filesystem_search_files()`, `lsp_symbols()`, `ast_grep_search()` — find components, parse exports
- **Deduplicate:** `read()`, in-memory hashing — hash nodes, map duplicates
- **Generate:** `write()`, `filesystem_create_directory()`, `lsp_diagnostics()` — write files, validate output

---

## Complete Loop Example

```
User: "I want a mobile login screen with social login options"

PHASE 1: PLANNING
- Detect: Type 2 (Single-task screen, 375x812)
- Output subtasks: "header" (Logo+title), "form" (Email/password), "submit" (Primary button), "social" (Google/Apple login)

PHASE 2: GENERATION
- Build each section via MCP insert_node / batch_design
- Export code: AI generates semantic React component

PHASE 3: VALIDATION
- Capture screenshot via Playwright
- Analyze issues → qualityScore
- Apply fixes via MCP

PHASE 4: MAINTENANCE
- User: "add a forgot password link"
- Use incremental-add.md → append link after password input
```

---

## Multi-Page Orchestration (ORCHESTRATOR COORDINATES, SUBAGENTS BUILD)

Build multiple pages in the same `.op` file. **Critical: ORCHESTRATOR coordinates files and dispatches subagents — subagents do ALL design work.**

### Architecture

```
ORCHESTRATOR (LIGHTWEIGHT)              SUBAGENTS (HEAVY DESIGN WORK)
─────────────────────────────────    ──────────────────────────────────────
1. Create canvas/ directory            (idle)
2. Create DESIGN.md template           (idle)
3. Create PROJECT.md template          (idle)
4. Create prompts/*.md files           (idle)
5. Dispatch ANALYZER subagent      ──► Analyzer: reads src/, extracts tokens
6. Wait + read DESIGN.md               Analyzer: writes to DESIGN.md
7. openpencil_add_page("Dashboard")    (idle)
8. Update prompt with pageId           (idle)
9. Dispatch BUILDER subagent       ──► Builder: reads prompt, builds page
10. Wait for completion                 Builder: returns "Done. Save."
11. openpencil_export_nodes()          (idle)
12. filesystem_write_file()            (idle)
13. Update prompt file status          (idle)
14. Repeat for each page               (parallel subagents possible)
```

### Orchestrator Workflow (MANDATORY)

```
PHASE 1: SETUP (orchestrator does)
  mkdir -p canvas/prompts
  echo '{"version":"1.0.0","children":[]}' > canvas/design.op
  cp templates/DESIGN.md canvas/DESIGN.md
  cp templates/PROJECT.md canvas/PROJECT.md
  
  # Create prompt files
  write canvas/prompts/01-dashboard-prompt.md (status: pending)
  write canvas/prompts/02-config-prompt.md (status: pending)
  ...

PHASE 2: ANALYZE (delegate to subagent)
  task(
    category="unspecified-high",
    prompt="Analyze GoldTracer portal src/ for design tokens.
            Read: src/App.js, src/pages/, src/components/
            Extract: colors (dark bg, surface, status colors), typography, spacing
            Write tokens to: canvas/DESIGN.md
            ⚠️ Do NOT build designs. Only analyze and write DESIGN.md."
  )
  # Wait for completion, then verify DESIGN.md

PHASE 3: BUILD PAGES (orchestrator creates pages, subagents build content)
  # For each page:
  openpencil_add_page({ name: "Dashboard" }) → pageId
  edit canvas/prompts/01-dashboard-prompt.md → add pageId, set status: in_progress
  
  task(
    category="visual-engineering",
    load_skills=["openpencil-loop"],
    prompt="Read canvas/prompts/01-dashboard-prompt.md and build the page.
            Use openpencil_design_skeleton, openpencil_design_content, openpencil_design_refine.
            ⚠️ Do NOT save files. Return results and remind orchestrator to save."
  )
  
  # Wait for completion
  openpencil_export_nodes() → get JSON
  filesystem_write_file() → save to design.op
  edit canvas/prompts/01-dashboard-prompt.md → status: completed

PHASE 4: ITERATE
  Repeat Phase 3 for each remaining page
  Can dispatch multiple subagents in parallel for independent pages
```

### Prompt File Format

Each `prompts/<number>-<name>-prompt.md` file:

```markdown
---
page: [name]
pageId: [orchestrator-assigned-id]
status: pending | in_progress | completed
session_id: null | ses_xxx
assigned_to: null | [subagent-session-id]
created_at: [timestamp]
updated_at: [timestamp]
---

**PAGE:** [Page name]

**DESIGN SYSTEM (from DESIGN.md):**
[Extract relevant tokens: colors, typography, spacing]

**PAGE STRUCTURE:**
1. [Section 1 description]
2. [Section 2 description]

**TASK:**
[Explicit task description with exact MCP calls to make]

**ORCHESTRATOR NOTES:**
[Any special instructions or context]
```

### Orchestrator Updates Prompt File After Subagent Completes

```markdown
---
...
status: completed
session_id: ses_abc123
updated_at: 2026-04-10T12:00:00Z
---
```

**⚠️ NEVER do this:**
```
❌ Dispatch subagent WITHOUT prompt file → no tracking, no accountability
❌ Subagent updates prompt files → orchestrator only
❌ Subagent creates its own page → concurrent page creation causes chaos
❌ Subagent saves file → concurrent write corruption
❌ Skip DESIGN.md/PROJECT.md → subagents have no context
```
```

### Subagent Behavior

**FIRST: Read your assigned prompt file:**

```
1. read("canvas/prompts/01-login-prompt.md")   → YOUR task, pageId, design system
2. read("canvas/DESIGN.md")                    → understand tokens (if not in prompt)
3. read("canvas/PROJECT.md")                   → understand project status
```

Then work on your assigned page using the pageId from the prompt file.

**AFTER COMPLETING:** Return results and remind orchestrator:
"✅ [Page name] done. Please update prompt file and save canvas."

### Subagent Build Workflow (MANDATORY FOR ALL BUILDERS)

**⚠️ IMPORTANT: `load_skills=["openpencil-loop"]` only loads this SKILL.md file.**

Subagents MUST read sub-skill files for detailed instructions:

```
# REQUIRED READING for design builders:
read("openpencil-loop/phases/generation/design-system.md")  # Design token format
read("openpencil-loop/phases/generation/schema.md")        # PenNode schema
read("openpencil-loop/phases/generation/layout-rules.md")  # Auto-layout rules
read("openpencil-loop/knowledge/role-definitions.md")      # Semantic roles (button, card, navbar)

# OR read the design prompt section:
openpencil_get_design_prompt({ section: "schema" })    # PenNode schema
openpencil_get_design_prompt({ section: "layout" })    # Layout rules
openpencil_get_design_prompt({ section: "roles" })    # Semantic roles
```

**MCP TOOLS TO USE:**

| Phase | Tools | Purpose |
|-------|-------|---------|
| **Setup** | `openpencil_open_document({ filePath })` | Connect to canvas |
| **Skeleton** | `openpencil_design_skeleton({ canvasWidth, rootFrame, sections })` | Create page structure |
| **Content** | `openpencil_design_content({ sectionId, children, postProcess: true })` | Add content to sections |
| **Refine** | `openpencil_design_refine({ rootId })` | Validate + auto-fix |
| **Check** | `openpencil_batch_get({ readDepth: 2 })` | Verify nodes created |
| **NEVER** | `openpencil_export_nodes`, `filesystem_write_file` | Orchestrator only! |

**COMPLETE BUILD WORKFLOW:**

```
1. openpencil_open_document({ filePath: "canvas/design.op" })
   → Connect to the design file

2. openpencil_design_skeleton({
     canvasWidth: 1200,
     rootFrame: { name: "Dashboard", width: 1200, height: 0, layout: "vertical", fill: [...] },
     sections: [
       { name: "TopBar", height: 56, layout: "horizontal", role: "navbar" },
       { name: "Content", height: 0, layout: "vertical", role: "section" }
     ]
   })
   → Returns { rootId, sections: [{ id, name, guidelines }] }

3. For each section:
   openpencil_design_content({
     sectionId: "section-id-from-step-2",
     children: [
       { type: "frame", name: "Card", role: "card", width: 200, height: 100, ... }
     ],
     postProcess: true
   })

4. openpencil_design_refine({ rootId: "root-id-from-step-2" })
   → Validates layout, resolves icons, applies role defaults

5. openpencil_batch_get({ readDepth: 2 })
   → Verify nodes were created

6. Return: "✅ Page built with X nodes. Orchestrator: Please save."
```

**SUBAGENT MUST NOT:**
- Save files (`openpencil_export_nodes`, `filesystem_write_file`)
- Create pages (`openpencil_add_page`)
- Modify DESIGN.md, PROJECT.md, or prompt files

| Can Do | Cannot Do |
|--------|-----------|
| Read DESIGN.md, PROJECT.md, .op, prompts/*.md | Create or modify any prompt files |
| `batch_design({ pageId: 'FROM_PROMPT_FILE' })` | Create pages (`add_page`) |
| `insert_node({ pageId: 'FROM_PROMPT_FILE', ... })` | Save files |
| `update_node({ pageId: 'FROM_PROMPT_FILE', ... })` | Omit `pageId` |
| `snapshot_layout({ pageId: 'FROM_PROMPT_FILE' })` | Assume which page to work on |

### Page Templates

For apps with consistent UI chrome, create a template page first, then `duplicate_page()` for each actual screen and fill in page-specific content.

### Orchestrator Rules

| Rule | Why |
|------|-----|
| **Create prompt files first** | Subagents need task definition + pageId |
| **Create ALL pages first** | Need pageIds before dispatching subagents |
| **Pass prompt file path to EVERY subagent** | No ambiguity, subagent knows exact task |
| **Collect results → update prompt + save** | Track status, persist work |
| **Subagents return results only** | No file I/O from subagents |

### Subagent Rules

| Rule | Why |
|------|-----|
| **Use the pageId given by orchestrator** | Only that page, not "first page" |
| **Return results + remind orchestrator** | "✅ Done. Orchestrator: save file." |
| **No page creation** | Orchestrator owns pages |
| **No file saves** | Orchestrator only |

---

## File Management

**Canvas file location — ALWAYS use a fixed path:**
```
canvas/
  └── design.op    ← ONE file, same location across all iterations
```

- Store `.op` in `canvas/` subdirectory next to project files
- Use SAME file path throughout entire loop — never create ad-hoc copies
- Examples: `./canvas/design.op` or `~/projects/login/canvas/login.op`

**Save discipline:**
- `batch_design` auto-saves. After manual edits in OpenPencil app: trigger save explicitly
- If using CLI: `op save` after operations
- Before closing OpenPencil app: always save first

**Never do:** `canvas/v1.op`, `canvas/v2_final.op`, `canvas/backup.op` — scattered copies; working on file and closing without saving; overwriting .op without backup

### `.op/DESIGN.md` Schema

Design system specification file. Created once (with user confirmation), then referenced by every generation phase. Sections: Typography, Colors (light/dark themes), Spacing (8px grid), Components (Button/Card/Navbar/Form specs with JSON), Shadows (Subtle/Medium/Elevated), Design Notes (generation rules, icon reference, semantic role usage).

Full template: `templates/DESIGN.md`

### `.op/PROJECT.md` Schema

Project roadmap file. Tracks overall design direction, completed screens, and future plans. Updated after each iteration. Sections: Vision, Design System Reference, Device Targets, Screens (Sitemap with checkboxes), Roadmap, Ideas.

Full template: `templates/PROJECT.md`

---

## OpenPencil CLI Quick Reference

```bash
op start [--desktop|--web]           # Launch app
op design '<dsl>'                    # Batch design (inline, @file, or stdin)
op insert '<json>' [--parent P]     # Insert node
op update <id> '<json>'              # Update node
op delete <id>                       # Delete node
op move <id> <parent> [index]        # Move node
op copy <id> <parent>                # Deep-copy node
op replace <id> '<json>'             # Replace node
op get [--depth N] [--pretty]        # Get document tree
op export <react|html|vue|flutter|swiftui|compose|css> --out <file>   # Export code
op design:skeleton '<json>'          # Create section structure
op design:content <id> '<json>'      # Populate section content
op design:refine --root_id <id>     # Validate + auto-fix
```

**PNG/SVG images** must be captured manually from OpenPencil app.
