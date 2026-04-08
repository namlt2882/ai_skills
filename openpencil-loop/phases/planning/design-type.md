---
name: design-type
description: Design type detection and classification
phase: [planning]
trigger: null
priority: 5
budget: 1000
category: base
---

# Design Type Detection

## Type 1: Multi-section page
- Marketing, landing, informational pages
- Desktop: width=1200, height=0 (scrollable), 6-10 subtasks
- Structure: navigation - hero - content sections - CTA - footer

## Type 2: Single-task screen
- Functional UI (auth, forms, settings, profiles)
- Mobile: width=375, height=812 (fixed viewport), 1-5 subtasks
- Structure: header + focused content area only

## Type 3: Data-rich workspace
- Dashboards, admin panels, analytics
- Desktop: width=1200, height=0, 2-5 subtasks
- Structure: sidebar or topbar + content panels

## Width Selection
- Type 2 (single-task): ALWAYS width=375, height=812
- Types 1 & 3: width=1200, height=0

## Mobile vs Mockup
- "mobile" + screen type = ACTUAL mobile screen (375x812)
- Phone mockups only for "mockup"/"showcase"/"preview"
