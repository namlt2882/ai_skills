---
name: offline-guidance
description: Offline and desktop app requirement guidance for OpenPencil workflows. Use when deciding between official (desktop app required) and fork (offline capable) workflows.
version: "1.0.0"
---

# Offline & Desktop App Guidance

## Desktop App Requirement (Official)

The official `open-pencil-loop` skill **REQUIRES** the Open-Pencil desktop app to be running.

### Why Required
The official MCP server (`@opencode/open-pencil-mcp`) communicates with the desktop app via **WebSocket RPC** at `ws://127.0.0.1:7601`. All read/write operations are proxied through the desktop app, which manages the actual `.fig`/`.pen` file state.

### Setup Steps
1. **Download:** https://github.com/open-pencil/open-pencil
2. **Install:** Follow platform-specific instructions (macOS/Windows/Linux)
3. **Launch:** Start the desktop app before using MCP
4. **Configure MCP:**
   ```json
   {
     "mcpServers": {
       "open-pencil": {
         "command": "npx",
         "args": ["-y", "@opencode/open-pencil-mcp@latest"]
       }
     }
   }
   ```
5. **Verify:** Run `openpencil ping` to confirm connection

### Pre-Flight Check (Always Run First)
```bash
openpencil ping  # Verify desktop app responsive
```
If fails: ask user to start OpenPencil → wait → retry.

### Benefits of Desktop App
- **Live preview:** See changes rendered in real-time
- **Native file handling:** Automatic `.fig`/`.pen` file management
- **Auto-save capable:** Desktop app handles file persistence
- **Interactive editing:** Can manually adjust designs alongside MCP operations

---

## Offline Capability (Fork)

The fork `openpencil-loop` operates **in-memory** without requiring the desktop app.

### Why No Desktop App Needed
The fork's MCP server (`openpencil`) manages document state entirely in memory. All operations work on an in-memory representation that must be manually persisted.

### File Persistence (CRITICAL)

> ⚠️ **WARNING:** OpenPencil MCP tools operate **IN-MEMORY ONLY**. Changes are NOT written to disk automatically. Re-opening the file LOSES ALL WORK.

**Manual persistence pattern:**
```
1. After all design work:
   batch_get({pageId, readDepth: -1})  → Get full document JSON
   filesystem_write_file({path, content: JSON})  → Write to disk
2. Verify: Read file back to confirm save
```

### Benefits of In-Memory
- **No desktop app dependency:** Works in CI/CD, headless environments
- **Faster operations:** No WebSocket round-trips
- **Parallel capable:** Can target multiple pages simultaneously
- **Portable:** Works anywhere MCP is available

---

## Choosing Your Workflow

### Use Official (Desktop App) When:
- You need **live preview** during design
- You're doing **interactive prototyping** with manual adjustments
- You want **automatic file persistence**
- You're working on a **single complex page**
- You need **export capabilities** (PNG, SVG, code)

### Use Fork (Offline) When:
- You're running in **CI/CD** or headless environments
- You need **parallel multi-page** design
- You're doing **batch operations** across many files
- You want to **extract design tokens** programmatically
- You don't have access to a **display** (SSH, containers)

### Hybrid Approach
You can use both in the same project:
1. Use **fork** for initial batch generation (parallel page creation)
2. Export the result
3. Open in **official** desktop app for interactive refinement
4. Save final version

---

## Troubleshooting

### Desktop App Won't Connect
1. Check app is running: `openpencil ping`
2. Check WebSocket port: `ws://127.0.0.1:7601`
3. Restart the desktop app
4. Restart MCP server

### Fork Loses Work
1. Always call `batch_get` + `filesystem_write_file` after design sessions
2. Save frequently during long sessions
3. Consider checkpointing: save after each page completion

### MCP Config Issues
- Official: `"open-pencil"` (hyphenated)
- Fork: `"openpencil"` (one word)
- These are different MCP servers — don't mix namespaces
