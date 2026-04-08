---
name: text-rules
description: Text node rules (textGrowth, lineHeight, font sizing)
phase: [generation]
trigger: null
priority: 5
budget: 1000
category: base
---

# Text Node Rules

## textGrowth
- "auto": single line, no wrapping (for buttons, labels)
- "fixed-width": wrap text, auto-calculate height (for body text, paragraphs)
- "fixed-width-height": fixed width AND height (rarely needed)

## NEVER set explicit height on text nodes

## lineHeight
- Display (40px+): 0.9-1.1
- Heading (20-36px): 1.0-1.3
- Body (14-18px): 1.4-1.6

## CJK lineHeight
- Headings: 1.3-1.4
- Body: 1.6-1.8

## letterSpacing
- Headlines: -0.5 to -1
- Body: 0
- Uppercase labels: 1-3

## Width Strategy
- text nodes in vertical layout: width="fill_container"
- text nodes in horizontal inline context: use auto width
