---
name: design-system
description: Design token generation from product descriptions
phase: [generation]
trigger: null
priority: 20
budget: 1000
category: base
---

# Design System Token Generation

Generate a cohesive design token system for OpenPencil v2:

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

## Applying Tokens in JSX

```jsx
// Background colors
<Frame bg="#0F172A">           {/* palette.background */}
<Frame bg="#1E293B">           {/* palette.surface */}

// Text colors
<Text fill="#F8FAFC">          {/* palette.text */}
<Text fill="#94A3B8">          {/* palette.textSecondary */}

// Accent colors
<Frame bg="#3B82F6">           {/* palette.primary */}
<Frame bg="#60A5FA">           {/* palette.primaryLight */}

// Border colors
<Frame strokeColor="#334155">  {/* palette.border */}
```

## Rules
- Match colors to personality: tech/SaaS - blue/indigo, creative - amber/coral, finance - navy/emerald, health - sage/teal
- Font pairing: heading distinctive (Space Grotesk, Outfit), body readable (Inter, DM Sans)
- CJK: use "Noto Sans SC"/"JP"/"KR" for headings
- Dark theme: background (#0F172A), light text, bright accents
- Radius: 0-4 sharp, 8-12 modern, 16+ playful

## MCP Variables Integration

Use `open-pencil` MCP to persist design tokens:

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "set_variables",
  arguments: {
    filePath: "path/to/design.fig",
    variables: {
      "primary": { type: "COLOR", value: "#3B82F6" },
      "background": { type: "COLOR", value: "#0F172A" },
      "spacing-unit": { type: "FLOAT", value: "8" }
    }
  }
})
```

## Theme Variants

Define light/dark themes using `set_themes`:

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "set_themes",
  arguments: {
    filePath: "path/to/design.fig",
    themes: {
      "Color Scheme": ["Light", "Dark"],
      "Density": ["Compact", "Comfortable"]
    }
  }
})
```
