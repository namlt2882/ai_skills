# Design Token Extraction Workflow

Extract design tokens from OpenPencil documents using the built-in analysis MCP tools. This workflow captures colors, typography, spacing, and patterns to build a reusable design system.

## Overview

Design tokens are the atomic values that define your visual language. OpenPencil provides analysis tools to extract these from existing designs and convert them into shareable formats.

## Extraction Workflow

### Step 1: Extract Color Palette

Use `analyze_colors` to find all colors used in the document.

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "analyze_colors",
  "arguments": {
    "limit": 30,
    "show_similar": true,
    "threshold": 15
  }
}
```

**Parameters:**
- `limit`: Maximum colors to return (default: 30)
- `show_similar`: Group similar colors that could be merged (default: false)
- `threshold`: Color distance threshold for clustering, 0-50 (default: 15)

**Output includes:**
- Color hex values with frequency counts
- Variable bindings if colors use variables
- Similar color clusters for consolidation opportunities

**Example output:**
```json
{
  "colors": [
    { "color": "#1A1A1A", "count": 45, "boundToVariable": "var-001" },
    { "color": "#FFFFFF", "count": 38 },
    { "color": "#3B82F6", "count": 12, "boundToVariable": "var-002" }
  ],
  "clusters": [
    { "colors": ["#F5F5F5", "#FAFAFA"], "suggestion": "Merge to #F5F5F5" }
  ]
}
```

### Step 2: Extract Typography

Use `analyze_typography` to catalog all font styles.

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "analyze_typography",
  "arguments": {
    "limit": 30,
    "group_by": "family"
  }
}
```

**Parameters:**
- `limit`: Maximum styles to return (default: 30)
- `group_by`: Group results by "family", "size", or "weight"

**Output includes:**
- Font families used
- Font sizes with frequency
- Font weights distribution
- Line heights and letter spacing

**Example output:**
```json
{
  "typography": [
    { "family": "Inter", "size": 16, "weight": 400, "count": 23 },
    { "family": "Inter", "size": 24, "weight": 600, "count": 8 },
    { "family": "SF Mono", "size": 14, "weight": 400, "count": 5 }
  ]
}
```

### Step 3: Analyze Spacing

Use `analyze_spacing` to check grid compliance and spacing values.

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "analyze_spacing",
  "arguments": {
    "grid": 8
  }
}
```

**Parameters:**
- `grid`: Base grid size to check against (default: 8)

**Output includes:**
- Gap values used (margin, padding, item spacing)
- Grid compliance percentage
- Off-grid values that may need adjustment

**Example output:**
```json
{
  "spacing": {
    "gaps": [8, 16, 24, 32],
    "paddings": [16, 24, 32],
    "grid_compliance": 0.94,
    "off_grid_values": [5, 13]
  }
}
```

### Step 4: Find Repeated Patterns

Use `analyze_clusters` to identify components and repeated structures.

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "analyze_clusters",
  "arguments": {
    "limit": 20,
    "min_count": 2,
    "min_size": 30
  }
}
```

**Parameters:**
- `limit`: Maximum clusters to return (default: 20)
- `min_count`: Minimum instances to form a cluster (default: 2)
- `min_size`: Minimum node size in pixels (default: 30)

**Output includes:**
- Groups of similar nodes by structure
- Potential components to extract
- Instance counts for each pattern

**Example output:**
```json
{
  "clusters": [
    {
      "signature": "button-primary",
      "count": 12,
      "avg_size": { "width": 120, "height": 44 },
      "common_props": { "cornerRadius": 8, "fill": "#3B82F6" }
    }
  ]
}
```

### Step 5: Export to Token Formats

Use `design_to_tokens` to export extracted tokens as CSS, Tailwind, or JSON.

```json
{
  "mcp_name": "open-pencil",
  "tool_name": "design_to_tokens",
  "arguments": {
    "format": "css",
    "collection": "Primitives",
    "type": "COLOR"
  }
}
```

**Parameters:**
- `format`: Output format - "css", "tailwind", or "json"
- `collection`: Filter by collection name (optional)
- `type`: Filter by variable type - "COLOR", "FLOAT", "STRING", "BOOLEAN" (optional)

**Format examples:**

**CSS output:**
```css
:root {
  --color-primary: #3B82F6;
  --color-text: #1A1A1A;
  --color-background: #FFFFFF;
  --spacing-sm: 8px;
  --spacing-md: 16px;
}

[data-theme="dark"] {
  --color-text: #FFFFFF;
  --color-background: #1A1A1A;
}
```

**Tailwind output:**
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: '#3B82F6',
        text: '#1A1A1A',
        background: '#FFFFFF',
      },
      spacing: {
        sm: '8px',
        md: '16px',
      }
    }
  }
}
```

**JSON output:**
```json
{
  "variables": [
    { "name": "primary", "type": "COLOR", "value": "#3B82F6" },
    { "name": "text", "type": "COLOR", "value": "#1A1A1A" }
  ]
}
```

## Complete Workflow Example

Run the full extraction pipeline:

```bash
# 1. Analyze colors
mcp open-pencil analyze_colors --limit 30 --show_similar

# 2. Extract typography
mcp open-pencil analyze_typography --group_by family

# 3. Check spacing grid compliance
mcp open-pencil analyze_spacing --grid 8

# 4. Find component patterns
mcp open-pencil analyze_clusters --min_count 3

# 5. Export to CSS
mcp open-pencil design_to_tokens --format css

# 6. Export to Tailwind config
mcp open-pencil design_to_tokens --format tailwind
```

## Best Practices

1. **Run analysis before creating variables** — Understand what's already in the document before defining the token structure

2. **Use `show_similar: true`** — Find near-duplicate colors that should be consolidated

3. **Check grid compliance** — Aim for 90%+ compliance with your base grid (8px is standard)

4. **Identify clusters first** — Use pattern analysis to find components before manual extraction

5. **Export multiple formats** — Generate both CSS (for developers) and JSON (for design tools)

6. **Filter by collection** — When exporting, use collection filters to separate primitives from semantic tokens

## Integration with Variables

After extraction, create variables from the analyzed tokens:

1. Use analyzed colors to define `COLOR` variables
2. Use spacing values to define `FLOAT` variables
3. Use typography to guide string/boolean flags

See `variables-themes.md` for creating and managing these variables.
