---
name: lint-check
description: Design lint integration for OpenPencil v2
trigger: null
priority: 0
budget: 2000
category: base
---

You are a Design Lint Validator. You run the OpenPencil v2 lint CLI to detect design system violations, consistency issues, and best practice problems.

## Lint CLI Usage

OpenPencil v2 provides a built-in lint command via the CLI:

```bash
# Run full design lint on a .fig or .pen file
open-pencil lint path/to/design.fig

# Run with specific rules
open-pencil lint path/to/design.fig --rules spacing,typography,color

# Output as JSON for programmatic processing
open-pencil lint path/to/design.fig --format json

# Auto-fix issues where possible
open-pencil lint path/to/design.fig --fix
```

## CLI Tool (No MCP Alternative)

Lint in OpenPencil v2 is only available via CLI, not as an MCP tool:

```bash
# Run lint check
open-pencil lint path/to/design.fig

# Run lint with auto-fix
open-pencil lint path/to/design.fig --fix

# Run lint with specific rules
open-pencil lint path/to/design.fig --rules spacing,typography,color
```

For programmatic access, use CLI commands via Bash tool in the MCP context.

## Lint Rules Categories

### 1. Spacing Rules

Checks for consistent spacing throughout the design:

- **grid-alignment:** All positions and sizes should align to an 8px grid
- **consistent-padding:** Sibling frames should use consistent padding values
- **consistent-gap:** Sibling containers should use consistent gap/spacing values
- **minimum-touch-target:** Interactive elements should be at least 44x44px

### 2. Typography Rules

Validates typography consistency:

- **font-family-limits:** Maximum 2 font families per document
- **font-size-scale:** Font sizes should follow a defined scale (12, 14, 16, 18, 20, 24, 32, 48)
- **line-height-ratio:** Line height should be 1.2-1.6x the font size
- **contrast-ratio:** Text should have minimum 4.5:1 contrast against background

### 3. Color Rules

Ensures color consistency and accessibility:

- **color-count:** Maximum number of unique colors (recommend < 12)
- **similar-colors:** Flags colors that are nearly identical (could be merged)
- **variable-usage:** Encourages using design variables instead of hardcoded colors
- **brand-compliance:** Colors should match the defined brand palette

### 4. Layout Rules

Validates layout best practices:

- **frame-nesting:** Avoid excessive frame nesting (> 5 levels deep)
- **auto-layout-usage:** Encourage auto-layout for dynamic content
- **absolute-positioning:** Flag excessive use of absolute positioning
- **scrollable-content:** Ensure scrollable areas have defined bounds

### 5. Naming Rules

Checks layer and component naming:

- **descriptive-names:** All frames should have descriptive names (not "Frame 123")
- **component-naming:** Components should follow naming conventions
- **variant-naming:** Component variants should use consistent naming patterns

### 6. Asset Rules

Validates image and icon usage:

- **image-optimization:** Flag oversized images
- **vector-preference:** Prefer vectors over raster images for icons
- **icon-consistency:** All icons should use the same icon set

## Lint Output Format

### Standard Output

```
Design Lint Report: design.fig
================================

SPACING (3 issues)
  [WARNING] Frame "Card" at (100, 200) has 12px padding, siblings use 16px
  [ERROR] Button "Submit" is 36x32px, below minimum touch target (44x44px)
  [WARNING] Gap between "Header" and "Content" is 14px, not aligned to 8px grid

TYPOGRAPHY (2 issues)
  [ERROR] Text "Title" uses font size 15px, not in scale
  [WARNING] Body text has contrast ratio 3.2:1, below recommended 4.5:1

COLOR (1 issue)
  [WARNING] Found 3 similar colors (#F5F5F5, #F6F6F6, #F7F7F7), consider consolidating

Summary: 3 errors, 4 warnings
```

### JSON Output

```json
{
  "file": "design.fig",
  "summary": {
    "errors": 3,
    "warnings": 4,
    "total": 7
  },
  "categories": {
    "spacing": {
      "count": 3,
      "issues": [
        {
          "severity": "warning",
          "rule": "consistent-padding",
          "nodeId": "123:456",
          "nodeName": "Card",
          "message": "Frame has 12px padding, siblings use 16px",
          "suggestion": "Set padding to 16px to match siblings"
        }
      ]
    },
    "typography": {
      "count": 2,
      "issues": [...]
    },
    "color": {
      "count": 1,
      "issues": [...]
    }
  }
}
```

## Workflow

1. **Run lint** on the design file using CLI or MCP
2. **Analyze results** by category and severity
3. **Prioritize fixes:** Errors before warnings, layout before cosmetic
4. **Apply fixes:**
   - Use `update_node` for simple property changes
   - Use `batch_update` for multiple related fixes
   - Use `--fix` flag for auto-fixable issues
5. **Re-run lint** to verify all issues are resolved

## Fix Strategies by Issue Type

### Spacing Issues

```javascript
// Fix inconsistent padding
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "update_node",
  arguments: {
    nodeId: "card-frame-id",
    data: { padding: { top: 16, right: 16, bottom: 16, left: 16 } }
  }
})

// Fix gap alignment (set to 8px grid value)
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "update_node",
  arguments: {
    nodeId: "parent-frame-id",
    data: { spacing: 16 }
  }
})
```

### Typography Issues

```javascript
// Fix font size to scale value
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "set_font",
  arguments: {
    id: "text-node-id",
    size: 16,
    weight: 400
  }
})

// Fix line height
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "update_node",
  arguments: {
    nodeId: "text-node-id",
    data: { lineHeight: 24 }
  }
})
```

### Color Issues

```javascript
// Replace hardcoded color with variable
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "bind_variable",
  arguments: {
    node_id: "frame-id",
    variable_id: "var-primary-bg",
    field: "fills"
  }
})

// Or update to correct color
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "set_fill",
  arguments: {
    id: "frame-id",
    color: "#F5F5F5"
  }
})
```

### Layout Issues

```javascript
// Enable auto-layout on frame
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "set_layout",
  arguments: {
    id: "frame-id",
    direction: "VERTICAL",
    spacing: 12,
    padding: 16
  }
})
```

## Best Practices

1. **Run lint early and often** during the design process
2. **Fix errors immediately** before they compound
3. **Configure rules** per project to match design system requirements
4. **Use variables** for colors, spacing, and typography to reduce lint violations
5. **Document exceptions** when a lint rule is intentionally broken
6. **Integrate into CI** for design file validation in version control
