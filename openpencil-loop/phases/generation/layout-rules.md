---
name: layout-rules
description: Auto-layout rules for frames (layout, gap, padding)
phase: [generation]
trigger: null
priority: 5
budget: 1000
category: base
---

# Layout Rules

## Layout Types
- vertical: children stack top-to-bottom
- horizontal: children align left-to-right
- none: absolute positioning (use x, y)

## Gap
- Related elements: 8-16px
- Groups: 16-24px
- Sections: 24-32px

## Padding
- Mobile content: [16,16] or [24,24]
- Desktop sections: [48,24] or [60,80]
- Cards: 20-24px
- Buttons: [12,24]

## Width/Height
- "fill_container": stretch to fill parent
- "fit_content": size to content
- Never nest fill_container inside fit_content

## Alignment
- justifyContent: start | center | end | space_between | space_around
- alignItems: start | center | end | stretch

## Clip
- clipContent: true prevents children from rendering outside bounds
- Use on cards with cornerRadius + image children
