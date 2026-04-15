---
name: design-system
description: Design system token generation from product descriptions
phase: [generation]
trigger: null
priority: 20
budget: 1000
category: base
---

# Design System Token Generation

Generate a cohesive design token system. For defaults, see `get_design_prompt("style")`. Use these values only when user refreshes or explicitly modifies:

```json
{
  "palette": {
    "background": "#F8FAFC",
    "surface": "#FFFFFF",
    "text": "#0F172A",
    "textSecondary": "#475569",
    "primary": "#2563EB",
    "primaryLight": "#60A5FA",
    "accent": "#0EA5E9",
    "border": "#E2E8F0"
  },
  "typography": {
    "headingFont": "Space Grotesk",
    "bodyFont": "Inter",
    "scale": [14, 16, 20, 28, 40, 56]
  },
  "spacing": { "unit": 8, "scale": [4, 8, 12, 16, 24, 32, 48, 64, 80, 96] },
  "radius": [4, 8, 12, 16],
  "aesthetic": "2-5 word style"
}
```

## Rules
- Match colors to personality: tech/SaaS - blue/indigo, creative - amber/coral, finance - navy/emerald, health - sage/teal
- Font pairing: heading distinctive (Space Grotesk, Outfit), body readable (Inter, DM Sans)
- CJK: use "Noto Sans SC"/"JP"/"KR" for headings
- Dark theme: background (#0F172A), light text, bright accents
- Radius: 0-4 sharp, 8-12 modern, 16+ playful
