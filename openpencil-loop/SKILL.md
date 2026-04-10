---
name: openpencil-loop
description: Iterative design development loop using OpenPencil (https://github.com/ZSeven-W/openpencil) CLI and MCP tools. Combines prompt enhancement, design system synthesis, and baton-passing orchestration. Use when building multi-page designs, iteratively refining UI components, creating design systems, or when you want to progressively develop a design with structured user feedback. Triggers on requests like "build a design system", "create multiple pages with OpenPencil", "iteratively design", "loop design", "design a login page", or when you want to enhance prompts for OpenPencil with design system context.
---

# OpenPencil Build Loop

> **⚠️ LAZY LOADING:** This file contains only role detection + dispatch. Each role's full workflow is in `phases/{role}/workflow.md`. Read that file when you know your role.

---
## ⚠️ ROLE DETECTION (READ THIS FIRST)

**STOP. Determine your role from your prompt:**

### Role Lookup Table

| Prompt Contains... | You Are... | Go To File... |
|---------------------|------------|---------------|
| "Onboard [project]", "Create DESIGN.md, PROJECT.md", "Dispatch subagents" | **ORCHESTRATOR** | `phases/orchestrator/workflow.md` |
| "Read prompts/XX-prompt.md and build the page" | **SUBAGENT/BUILDER** | `phases/subagent/workflow.md` |
| "Analyze source code and extract tokens" | **ANALYZER** | `phases/analyzer/workflow.md` |
| "Verify page [name] has content" | **REVIEWER** | `phases/reviewer/workflow.md` |

---
## KEY REFERENCES

**Sub-Skill Loading:** Read files directly based on your role:
- SUBAGENT: `read("openpencil-loop/phases/generation/schema.md")`, `read("openpencil-loop/phases/generation/layout-rules.md")`, `read("openpencil-loop/knowledge/role-definitions.md")`
- REVIEWER: `read("openpencil-loop/phases/generation/schema.md")`
- ANALYZER: `read("openpencil-loop/phases/generation/design-system.md")`, `read("openpencil-loop/phases/generation/schema.md")`

**File Structure:**
```
openpencil-loop/
├── phases/
│   ├── orchestrator/workflow.md
│   ├── subagent/workflow.md
│   ├── reviewer/workflow.md
│   ├── analyzer/workflow.md
│   └── generation/
│       ├── schema.md
│       ├── layout-rules.md
│       └── design-system.md
└── knowledge/role-definitions.md
```

---
## FILE INDEX

| File | Purpose |
|------|---------|
| `phases/orchestrator/workflow.md` | Orchestrator workflow |
| `phases/subagent/workflow.md` | Subagent workflow |
| `phases/reviewer/workflow.md` | Reviewer workflow |
| `phases/analyzer/workflow.md` | Analyzer workflow |
| `phases/generation/schema.md` | PenNode schema |
| `phases/generation/layout-rules.md` | Layout rules |
| `phases/generation/design-system.md` | Token format |
| `knowledge/role-definitions.md` | Component semantic roles |
| `reference/tool-decision-tree.md` | Tool selection guide |
| `TEST-SPEC.md` | Regression tests |
| `phases/observation-contract.md` | Standardized output format |