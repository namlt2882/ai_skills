---
name: parallel-design
description: Parallel design capability comparison between open-pencil-loop (official) and openpencil-loop (fork). Use when deciding which workflow to use for multi-page design projects.
version: "1.0.0"
---

# Parallel Design Capability

## Overview

The official `open-pencil-loop` and the fork `openpencil-loop` have fundamentally different architectures that affect parallel design capability.

## Architecture Comparison

### Official (open-pencil-loop)
- **MCP Server:** `@opencode/open-pencil-mcp` → Desktop App (WebSocket RPC)
- **State:** Desktop app holds the live document state
- **Page Targeting:** `switch_page` required before editing (sets `figma.currentPage`)
- **File Persistence:** Desktop app handles save natively
- **Parallel:** ❌ NOT supported — must switch pages sequentially

### Fork (openpencil-loop)
- **MCP Server:** `openpencil` → In-memory only (no desktop app)
- **State:** MCP server holds document in memory
- **Page Targeting:** `pageId` parameter on all tools (direct targeting)
- **File Persistence:** Manual `filesystem_write_file` required
- **Parallel:** ✅ Supported — different pages can be edited simultaneously

## Code Evidence

### Official (read.ts line 160):
```typescript
figma.currentPage = target  // Must switch before edit
```

### Fork (node-routes.ts lines 51, 80, 100):
```typescript
pageId: { type: 'string', description: 'Target page ID' }  // Direct targeting
```

## Action Flow Comparison

### Official Sequential Workflow
```
ORCHESTRATOR:
  1. switch_page({ page: "Page 1" })
  2. design_skeleton → design_content → design_refine
  3. switch_page({ page: "Page 2" })
  4. design_skeleton → design_content → design_refine
  5. ... repeat for each page
```

### Fork Parallel Workflow
```
ORCHESTRATOR:
  1. Dispatch SUBAGENT-A → batch_design({ pageId: "page1", ... })
  2. Dispatch SUBAGENT-B → batch_design({ pageId: "page2", ... })
  3. Both run in parallel (no page switching needed)
  4. Collect results from both
```

## When to Use Which

| Use Case | Recommended Skill | Why |
|----------|-------------------|-----|
| Single-page interactive design | `open-pencil-loop` (Official) | Desktop app provides live preview |
| Multi-page sequential build | `open-pencil-loop` (Official) | Reliable save, live editing |
| Parallel multi-page build | `openpencil-loop` (Fork) | pageId direct targeting |
| CI/CD batch operations | `openpencil-loop` (Fork) | No desktop app needed |
| Design token extraction | `openpencil-loop` (Fork) | In-memory, fast |
| Interactive prototyping | `open-pencil-loop` (Official) | Desktop app rendering |

## Migration Notes

If you need to switch between official and fork:

1. **MCP namespace:** `open-pencil` → `openpencil` (or vice versa)
2. **Save behavior:** Fork requires manual `filesystem_write_file`, official uses `save_file`
3. **Page targeting:** Fork uses `pageId` parameter, official uses `switch_page` call
4. **Desktop app:** Fork doesn't need it, official requires it running

## Key Limitations

### Official Limitations
- Cannot edit two pages simultaneously (must switch_page between)
- Desktop app must be running for any MCP operation
- WebSocket connection required (local network only)

### Fork Limitations
- No desktop app means no live preview
- File persistence is manual (must write JSON to disk)
- No auto-save (all work lost if process crashes before manual save)
- Different MCP namespace means different tool call syntax
