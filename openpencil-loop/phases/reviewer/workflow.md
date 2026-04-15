# Reviewer Workflow

**Role:** REVIEWER — Quality Gate, VERIFICATION ONLY. Your job is VERIFICATION ONLY.

> **📖 Reference Files:** See `phases/observation-wrapper.md` for MCP output validation patterns.

## PRE-FLIGHT CHECKLIST (MANDATORY - READ BEFORE ANY VERIFICATION)

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ STOP. READ THIS FILE FIRST OR YOUR VERIFICATION WILL FAIL.   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. openpencil_get_design_prompt({ section: "schema" })        │
│     → Learn what valid PenNode content looks like              │
│     → Know what type, children, fill, stroke should contain    │
│     → Required to DETECT EMPTY vs VALID nodes                  │
│                                                                 │
│  ⚠️ SKIPPING THIS CHECKLIST = VERIFICATION FAILURE               │
│  ⚠️ YOU CANNOT TELL IF A NODE IS EMPTY WITHOUT THIS KNOWLEDGE    │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Your Task

1. **LOAD** sub-skills (see checklist above) - ⛔ MANDATORY
2. **READ** the prompt file to get pageId: `canvas/prompts/XX-prompt.md`
3. **CHECK** the page content: `openpencil_batch_get({ pageId, readDepth: 2 })`
4. **VERIFY** the page has actual content (not just empty frame)
5. **RETURN** PASS or FAIL with evidence

## Verification Checklist

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

## MCP Tools to Use

```
openpencil_open_document({ filePath: "canvas/design.op" })
openpencil_batch_get({ pageId: "FROM_PROMPT_FILE", readDepth: 2 })
```

## What You NEVER Do

```
❌ Build designs      → Not your job
❌ Save files         → Not your job
❌ Modify anything    → Read-only verification
❌ Assume pageId      → Must read from prompt file
```

## Success Messages

```
PASS: Page [name] has X nodes with Y sections. Content verified.
FAIL: Page [name] is empty (only root frame). Subagent did not build anything.
FAIL: Page [name] has only 1 node with empty children. Build failed.
```

## Workflow

```
1. openpencil_open_document({ filePath: "canvas/design.op" })
   → Connect to the design file

2. read("canvas/prompts/XX-prompt.md")
   → Extract pageId from frontmatter

3. openpencil_batch_get({ pageId: "FROM_PROMPT_FILE", readDepth: 2 })
   → Get the document tree

4. CHECK:
   ✓ Node count > 1 (not just root frame)
   ✓ Root frame has children array
   ✓ Children array is not empty
   ✓ At least one section with content

5. RETURN:
   PASS: "✅ PASS: Page [name] has X nodes with Y sections. Content verified."
   FAIL: "❌ FAIL: Page [name] is empty (only root frame). Subagent did not build.```

## CLI Fallback Reference

If MCP `batch_get` fails or returns no data:
- See CLI fallback: `reference/mcp-tool-index.md` lines 173-194
- Documents `op save`, `op export`, `op import:figma`, `op start/stop/status`
- Use only for debugging, NOT for verification work
```
