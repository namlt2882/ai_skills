---
page: [page-name]
pageId: [orchestrator-assigned-id]
status: pending | in_progress | completed
session_id: null | ses_xxx
assigned_to: null | [subagent-session-id]
created_at: [timestamp]
updated_at: [timestamp]
---

**PAGE:** [Page name]

**DESIGN SYSTEM:**
[Extract relevant tokens from canvas/DESIGN.md:
- Colors: primary, background, text, border
- Typography: font families, type scale
- Spacing: unit, common values
- Components: button, card, input specs]

**PAGE STRUCTURE:**
1. [Section 1 description - what to build]
2. [Section 2 description]
3. [Section 3 description]

**TASK:**
[Explicit task description: what MCP calls to make, what the final output should look like]

**ORCHESTRATOR NOTES:**
[Any special instructions, constraints, or context the subagent needs to know]

**SUBAGENT INSTRUCTIONS:**

Before building, read these files:
```
read("canvas/DESIGN.md")  # Design tokens
skill_mcp({ mcp_name: "openpencil", tool_name: "get_design_prompt", arguments: { section: "schema" } })  // PenNode format via MCP (preferred)
```

Build workflow:
```
1. openpencil_open_document({ filePath: "canvas/design.op" })
2. openpencil_design_skeleton({ canvasWidth: 1200, rootFrame: {...}, sections: [...] })
3. openpencil_design_content({ sectionId: "...", children: [...], postProcess: true })
4. openpencil_design_refine({ rootId: "..." })
```

⚠️ Do NOT save files. Return "✅ Page built. Orchestrator: Please save."
