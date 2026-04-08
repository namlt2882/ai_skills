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

Generate a cohesive design token system:

```json
{
  "palette": {
    "background": "#hex",
    "surface": "#hex",
    "text": "#hex",
    "textSecondary": "#hex",
    "primary": "#hex",
    "primaryLight": "#hex",
    "accent": "#hex",
    "border": "#hex"
  },
  "typography": {
    "headingFont": "font name",
    "bodyFont": "font name",
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
