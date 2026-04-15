# Subagent (Builder) Workflow

**Role:** SUBAGENT — Builder, HEAVY DESIGN WORK. Your job is to BUILD ONE PAGE.

## PRE-FLIGHT CHECKLIST (MANDATORY - READ BEFORE ANY WORK)

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ STOP. READ THESE FILES FIRST OR YOUR BUILD WILL FAIL.        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. read("openpencil-loop/phases/generation/schema.md")        │
│     → Learn PenNode structure                                   │
│     → Know what type, width, height, fill, children mean      │
│     → Required to build VALID nodes                            │
│                                                                 │
│  2. read("openpencil-loop/phases/generation/layout-rules.md")  │
│     → Learn auto-layout (flexbox) rules                         │
│     → Know how to use layout, gap, padding, justifyContent      │
│     → Required to build CORRECT layouts                         │
│                                                                 │
│  3. read("openpencil-loop/knowledge/role-definitions.md")     │
│     → Learn semantic roles                                      │
│     → Know what role="button", role="card", role="table" mean   │
│     → Required to build SEMANTIC components                     │
│                                                                 │
│  4. [IF DASHBOARD] read("openpencil-loop/domains/dashboard.md")│
│     → Learn dashboard-specific patterns                         │
│     → Stats cards, tables, charts, filters, pagination         │
│     → Required for DASHBOARD pages                              │
│                                                                 │
│  ⚠️ SKIPPING THIS CHECKLIST = BUILD FAILURE                     │
│  ⚠️ YOUR NODES WILL BE INVALID WITHOUT THIS KNOWLEDGE           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Your Task (from prompts/XX-prompt.md)

1. **LOAD** sub-skills (see checklist above) - ⛔ MANDATORY - DO NOT SKIP
2. **READ** your prompt file: `canvas/prompts/XX-prompt.md`
3. **READ** design tokens: `canvas/DESIGN.md`
4. **BUILD** using OpenPencil MCP tools
5. **RETURN** results - do NOT save

## MCP Tools to Use

```
openpencil_open_document({ filePath: "canvas/design.op" })
openpencil_design_skeleton({ canvasWidth: 1200, rootFrame: {...}, sections: [...] })
openpencil_design_content({ sectionId: "...", children: [...], postProcess: true })
openpencil_design_refine({ rootId: "..." })
```

## What You NEVER Do

```
❌ openpencil_add_page()         → Orchestrator only
❌ openpencil_read_nodes()     → Orchestrator only
❌ filesystem_write_file()       → Orchestrator only
```

## Success Message

```
✅ [Page name] built with X nodes. Orchestrator: Please verify with reviewer, then save.
```

## Complete Build Workflow

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

## Subagent Must Not

- Save files (`openpencil_read_nodes`, `filesystem_write_file`)
- Create pages (`openpencil_add_page`)
- Modify DESIGN.md, PROJECT.md, or prompt files

| Can Do | Cannot Do |
|--------|-----------|
| Read DESIGN.md, PROJECT.md, .op, prompts/*.md | Create or modify any prompt files |
| `batch_design({ pageId: 'FROM_PROMPT_FILE' })` | Create pages (`add_page`) |
| `insert_node({ pageId: 'FROM_PROMPT_FILE', ... })` | Save files |
| `update_node({ pageId: 'FROM_PROMPT_FILE', ... })` | Omit `pageId` |
| `snapshot_layout({ pageId: 'FROM_PROMPT_FILE' })` | Assume which page to work on |

## FIRST: Read Your Assigned Prompt File

```
1. read("canvas/prompts/01-login-prompt.md")   → YOUR task, pageId, design system
2. read("canvas/DESIGN.md")                    → understand tokens (if not in prompt)
3. read("canvas/PROJECT.md")                   → understand project status
```

Then work on your assigned page using the pageId from the prompt file.

**AFTER COMPLETING:** Return results and remind orchestrator:
"✅ [Page name] done. Please update prompt file and save canvas."

---

## CLI Fallback Reference

If MCP tool fails, see CLI fallback: `reference/cli-commands.md` lines 173-194

**MUST NOT use CLI for building** - CLI is orchestrator-only. Subagents MUST use MCP tools only.
If MCP tools fail, report the specific error to orchestrator - DO NOT switch to CLI spontaneously.
