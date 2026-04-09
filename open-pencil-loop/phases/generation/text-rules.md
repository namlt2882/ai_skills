---
name: text-rules
description: Text node rules for OpenPencil (https://github.com/open-pencil/open-pencil)
trigger: null
priority: 5
budget: 1000
category: base
---

# Text Node Rules

## Props

```jsx
<Text size={16} weight="bold" family="Inter" fill="#1E293B" lineHeight={1.5} letterSpacing={-0.5} align="left" wrap={true}>
  Content here
</Text>
```

| Prop | Description |
|------|-------------|
| size | fontSize in px |
| weight | "normal"\|"medium"\|"semibold"\|"bold"\|number |
| family | fontFamily name |
| fill | text color |
| lineHeight | line height multiplier (0.9-1.8) |
| letterSpacing | letter spacing in px (0 for body, -0.5 to -1 for headlines) |
| align | "left"\|"center"\|"right" |
| wrap | text wrapping enabled |

## NEVER set explicit height on text nodes
Text nodes calculate their own height. Explicit height causes truncation/overflow.

## Line Height Guidelines

| Context | Line Height |
|---------|-------------|
| Display (40px+) | 0.9-1.1 |
| Headings (20-36px) | 1.0-1.3 |
| Body (14-18px) | 1.4-1.6 |
| Captions (<14px) | 1.2-1.4 |
| CJK Headings | 1.3-1.4 |
| CJK Body | 1.6-1.8 |

## Letter Spacing

| Context | Value |
|---------|-------|
| Headlines | -0.5 to -1px |
| Body text | 0 |
| Uppercase labels | 1-3px |
| Monospace/code | 0 |

## Font Weight Values

normal=400, medium=500, semibold=600, bold=700

## Width Strategy
- In vertical layout: use `wrap={true}` for fill-width text
- In horizontal row: auto width for labels, wrap for values

## CJK
Use `family="Noto Sans SC"` (Chinese), `"Noto Sans JP"` (Japanese), `"Noto Sans KR"` (Korean). No negative letterSpacing for CJK.