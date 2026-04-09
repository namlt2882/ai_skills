---
name: vision-feedback
description: Vision-based design QA validation with export_image
trigger: null
priority: 0
budget: 3000
category: base
---

# Vision-Based Design QA

## Workflow

1. `export_image` - export design as PNG for visual QA
2. `batch_get` - get node tree to cross-reference node IDs
3. Analyze screenshot for design quality issues
4. Output JSON with quality score, issues, and fix instructions

## MCP Tools

```javascript
// Export image
skill_mcp({ mcp_name: "open-pencil", tool_name: "export_image", arguments: { filePath: "path/to/file.fig", format: "PNG", scale: 2 }})

// Get node tree
skill_mcp({ mcp_name: "open-pencil", tool_name: "batch_get", arguments: { filePath: "path/to/file.fig", patterns: [{ type: "frame" }] }})

// Get specific node
skill_mcp({ mcp_name: "open-pencil", tool_name: "get_node", arguments: { id: "node-id" }})
```

## Visual Issues to Check

1. **WIDTH INCONSISTENCY** - Sibling form inputs/buttons/cards with different widths → use "FILL"
2. **ELEMENT TOO NARROW** - Buttons/inputs narrower than parent → width="FILL"
3. **SPACING** - Uneven padding, inconsistent gaps
4. **OVERFLOW** - Text/elements visually clipped
5. **ALIGNMENT** - Elements misaligned (e.g., form fields not left-aligned)
6. **TEXT CENTERING** - Text shifted instead of centered → parent counter_align="CENTER" or text FILL width
7. **MISSING ICONS** - Path nodes rendered as empty rectangles
8. **COLOR ISSUES** - Poor contrast, wrong bg colors
9. **TYPOGRAPHY** - Inconsistent font sizes, wrong weights
10. **MISSING BORDERS** - Inputs/cards without visible border
11. **STRUCTURAL INCONSISTENCY** - Sibling elements with different patterns
12. **MISSING ELEMENTS** - Reference design elements missing

## Output Format

Output ONLY JSON, no markdown fences:

```json
{
  "qualityScore": 8,
  "issues": ["description1", "description2"],
  "fixes": [{ "nodeId": "actual-id", "property": "width", "value": "FILL" }],
  "structuralFixes": []
}
```

### Quality Score
- 9-10: Production-ready
- 7-8: Good with minor issues
- 5-6: Acceptable, needs improvement
- 1-4: Significant problems

### Allowed Fix Properties
width, height, padding, spacing, fontSize, fontWeight, cornerRadius, opacity, fill, stroke, align, counterAlign

### Text Clipping
If text node has explicit height AND content appears clipped → set auto_resize="HEIGHT" and height="HUG". Text nodes should rarely have explicit pixel heights.

## Rules
- Use REAL node IDs from tree, never fabricate
- Fix ALL inconsistent siblings, not just one
- If design correct: `{"qualityScore":9,"issues":[],"fixes":[],"structuralFixes":[]}`
- Keep fixes minimal, fix clear bugs not stylistic preferences
- NEVER change HUG to fixed pixel on auto-layout frame (creates empty whitespace)