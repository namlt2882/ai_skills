---
name: decomposition
description: Orchestrator task decomposition — splits UI requests into subtasks
phase: [planning]
trigger: null
priority: 0
budget: 3000
category: base
---

# Task Decomposition

## Output Format
```json
{
  "rootFrame": {"id": "page", "name": "Page", "width": 1200, "height": 0, "layout": "vertical", "gap": 0, "fill": [{"type": "solid", "color": "#F8FAFC"}]},
  "styleGuide": {"palette": {...}, "fonts": {...}, "aesthetic": "..."},
  "subtasks": [{"id": "nav", "label": "Navigation Bar", "elements": "logo, nav links, sign-in button", "region": {"width": 1200, "height": 72}}]
}
```

## Rules
- ELEMENT BOUNDARIES: Each subtask has "elements" field listing specific UI elements. NO overlap between subtasks.
- FORM INTEGRITY: Keep inputs + submit button in SAME subtask
- Combine related elements: "Hero with title + image + CTA" = ONE subtask
- Each subtask ~10-30 nodes. Split only if >40 nodes.
- REQUIRED: "styleGuide" always included
- CJK FONT: use Noto Sans fonts for CJK content

## Root Frame
- fill: use styleGuide palette background
- gap: landing pages gap=0, mobile/dashboards gap=16-24
- height: mobile=812, desktop=0

## Multi-screen / Multi-page Apps
- Add `"screen":"name"` to subtasks sharing same page
- Same screen subtasks go in one root frame

## Multi-Page Decomposition

When decomposing for multi-page parallel build:

```
For each page in the app:
  1. Create page first (get pageId via add_page)
  2. Decompose that page's content into subtasks
  3. Output ONE decomposition per page with pageId attached
```

Multi-page decomposition output format:
```json
{
  "pages": [
    {
      "pageId": "uuid-from-add_page",
      "pageName": "LoginScreen",
      "rootFrame": {...},
      "styleGuide": {...},
      "subtasks": [...]
    },
    {
      "pageId": "uuid-from-add_page",
      "pageName": "DashboardScreen",
      "rootFrame": {...},
      "styleGuide": {...},
      "subtasks": [...]
    }
  ]
}
```

Rules:
- Each page gets its own decomposition block
- Capture pageId from `add_page` response — agents need it for parallel build
- Design system (styleGuide) should be consistent across all pages
