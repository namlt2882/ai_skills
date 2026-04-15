# Orchestrator Workflow

**Role:** ORCHESTRATOR — Coordinator, NOT a builder.

## What You DO

| Phase | Actions | Tools |
|-------|---------|-------|
| **SETUP** | Create canvas/, DESIGN.md, PROJECT.md, prompts/*.md | `filesystem_*` |
| **CREATE PAGES** | Add pages to design.op | `openpencil_add_page()` |
| **DISPATCH** | Send subagents to build each page | `task(category="quick", prompt="Read prompts/XX...")` |
| **VERIFY** | Send reviewer to check work | `task(category="deep", prompt="Verify page [name] has content")` |
| **SAVE** | Export and save after PASS verification | `openpencil_read_nodes()`, `filesystem_write_file()` |

## What You NEVER Do

```
❌ openpencil_design_skeleton()  → Delegate to subagent
❌ openpencil_design_content()   → Delegate to subagent
❌ openpencil_insert_node()      → Delegate to subagent
❌ Reading 50 source files       → Delegate to analyzer subagent
❌ Marking task done before VERIFIED → Must wait for reviewer PASS
```

## Quick Orchestrator Checklist

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
10. [ ] Saved with openpencil_read_nodes()?
```

## MANDATORY: Verify Before Marking Done

**ALWAYS dispatch a reviewer after subagent completes:**

```
SUBAGENT returns: "✅ Page built with X nodes"
    ↓
ORCHESTRATOR dispatches REVIEWER: task(
    category="deep",
    prompt="You are REVIEWER. 
            1. Load sub-skills: openpencil_get_design_prompt({ section: "schema" })
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

## Dispatch Prompt Templates

### SUBAGENT DISPATCH TEMPLATE

```
task(
    category="quick",
    prompt="You are SUBAGENT/BUILDER. Your job is to BUILD ONE PAGE.
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  ⚠️  STEP 1: LOAD SUB-SKILLS (MANDATORY - DO NOT SKIP)       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Execute these reads BEFORE any other work:
            
            openpencil_get_design_prompt({ section: "schema" })
            → Learn PenNode structure (type, width, height, fill, stroke, children)
            
            openpencil_get_design_prompt({ section: "layout" })
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
            
            ⚠️ NEVER: openpencil_read_nodes(), filesystem_write_file(), add_page()
            These are ORCHESTRATOR tools. You only BUILD."
)
```

### REVIEWER DISPATCH TEMPLATE

```
task(
    category="deep",
    prompt="You are REVIEWER. Your job is VERIFICATION ONLY.
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  ⚠️  STEP 1: LOAD SUB-SKILLS (MANDATORY - DO NOT SKIP)       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Execute this read BEFORE any other work:
            
            openpencil_get_design_prompt({ section: "schema" })
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
```

### ANALYZER DISPATCH TEMPLATE

```
task(
    category="deep",
    prompt="You are ANALYZER. Your job is EXTRACTING TOKENS.
            
            ╔══════════════════════════════════════════════════════════════╗
            ║  ⚠️  STEP 1: LOAD SUB-SKILLS (MANDATORY - DO NOT SKIP)       ║
            ╚══════════════════════════════════════════════════════════════╝
            
            Execute these reads BEFORE any other work:
            
            read('openpencil-loop/phases/generation/design-system.md')
            → Learn what tokens to extract (colors, typography, spacing, shadows)
            
            openpencil_get_design_prompt({ section: "schema" })
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

## VIOLATION = SKILL FAILURE

- Marking task done without reviewer PASS
- Calling design_skeleton or insert_node yourself
- Skipping verification step

## Orchestrator Workflow (MANDATORY)

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
    category="deep",
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
    category="quick",
    load_skills=["openpencil-loop"],
    prompt="Read canvas/prompts/01-dashboard-prompt.md and build the page.
            Use openpencil_design_skeleton, openpencil_design_content, openpencil_design_refine.
            ⚠️ Do NOT save files. Return results and remind orchestrator to save."
  )
  edit canvas/prompts/01-dashboard-prompt.md → set session_id: <session_id>
  
  # Wait for completion
  edit canvas/prompts/01-dashboard-prompt.md → status: completed

PHASE 4: SAVE AND ITERATE
  # Primary: Use CLI for persistence
  op save canvas/design.op

  # Backup: MCP export (if CLI unavailable)
  # openpencil_read_nodes() → get JSON
  # filesystem_write_file() → save to design.op

  Repeat Phase 3 for each remaining page
  Can dispatch multiple subagents in parallel for independent pages
```

## Prompt File Format

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

## Orchestrator Updates Prompt File After Subagent Completes

```markdown
---
...
status: completed
session_id: ses_abc123
updated_at: 2026-04-10T12:00:00Z
---
```

## NEVER Do This

```
❌ Dispatch subagent WITHOUT prompt file → no tracking, no accountability
❌ Subagent updates prompt files → orchestrator only
❌ Subagent creates its own page → concurrent page creation causes chaos
❌ Subagent saves file → concurrent write corruption
❌ Skip DESIGN.md/PROJECT.md → subagents have no context
```

## Orchestrator Rules

| Rule | Why |
|------|-----|
| **Create prompt files first** | Subagents need task definition + pageId |
| **Create ALL pages first** | Need pageIds before dispatching subagents |
| **Pass prompt file path to EVERY subagent** | No ambiguity, subagent knows exact task |
| **Collect results → update prompt + save** | Track status, persist work |
| **Subagents return results only** | No file I/O from subagents |

## File Structure Convention

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

## Design Files: Orchestrator-Owned Source of Truth

**⚠️ CRITICAL: These files are the ONLY reliable source of truth. The live canvas is volatile and can be lost.**

The orchestrator MUST create, maintain, and protect these files. Subagents read from them — they do NOT create or modify them.

| File | Purpose | Owner | Persists? |
|------|---------|-------|-----------|
| **`canvas/*.op`** | Visual canvas — actual design nodes | Orchestrator | ✅ Yes (via export) |
| **`canvas/DESIGN.md`** | Design tokens — colors, typography, spacing, components | Orchestrator | ✅ Yes (file) |
| **`canvas/PROJECT.md`** | Roadmap — completed pages, next tasks, decisions | Orchestrator | ✅ Yes (file) |

## Orchestrator File Management Responsibilities

| Task | How | When |
|------|-----|-------|
| **Create DESIGN.md** | Copy from `templates/DESIGN.md`, fill with project tokens | Once at project start |
| **Create PROJECT.md** | Copy from `templates/PROJECT.md`, fill with sitemap | Once at project start |
| **Update DESIGN.md** | Add new tokens, component specs as discovered | After each page analyzed |
| **Update PROJECT.md** | Mark pages complete, add next tasks | After each page done |
| **Export canvas to .op** | `openpencil_read_nodes()` + `filesystem_write_file()` | After each session + before session end |
| **Read .op before work** | `openpencil_batch_get()` + `read(".op")` to compare | Every session start |
