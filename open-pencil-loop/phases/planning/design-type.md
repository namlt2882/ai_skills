---
name: design-type
description: Design type detection and classification for OpenPencil v2
phase: [planning]
trigger: null
priority: 5
budget: 1000
category: base
---

# Design Type Detection (v2)

OpenPencil v2 uses JSX format and supports `.fig` and `.pen` files. Design type determines canvas dimensions and structure.

## Type 1: Multi-section page
- Marketing, landing, informational pages
- Desktop: width=1200, height=0 (scrollable), 6-10 subtasks
- Structure: navigation - hero - content sections - CTA - footer
- **JSX Root Frame**: `<Frame name="Page" width={1200} height="auto" layout="vertical">`

## Type 2: Single-task screen
- Functional UI (auth, forms, settings, profiles)
- Mobile: width=375, height=812 (fixed viewport), 1-5 subtasks
- Structure: header + focused content area only
- **JSX Root Frame**: `<Frame name="Screen" width={375} height={812} layout="vertical">`

## Type 3: Data-rich workspace
- Dashboards, admin panels, analytics
- Desktop: width=1200, height=0, 2-5 subtasks
- Structure: sidebar or topbar + content panels
- **JSX Root Frame**: `<Frame name="Dashboard" width={1200} height="auto" layout="vertical">`

## Width Selection
- Type 2 (single-task): ALWAYS width=375, height=812
- Types 1 & 3: width=1200, height="auto"

## Mobile vs Mockup
- "mobile" + screen type = ACTUAL mobile screen (375x812)
- Phone mockups only for "mockup"/"showcase"/"preview"

## File Format Selection
- Use `.fig` for Figma-compatible design files
- Use `.pen` for OpenPencil native format
- Both formats support JSX rendering via open-pencil MCP
