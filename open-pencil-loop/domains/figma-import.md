---
name: figma-import
description: Figma file import and round-trip workflows
dependencies: []
phase: [generation, refinement]
trigger:
  keywords: [figma, .fig, import, round-trip, convert, pen]
priority: 20
budget: 1500
category: domain
---

# Figma Import and Round-Trip Workflows

## Overview
OpenPencil supports importing Figma designs through multiple pathways:
1. **SVG Import via MCP** - Convert Figma exports to editable PenNodes
2. **CLI Conversion** - Batch convert .fig files to .pen format
3. **Round-Trip Workflow** - Edit in OpenPencil, export back to Figma-compatible formats

## SVG Import via MCP

Use the `import_svg` MCP tool to import SVG files exported from Figma:

```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: import_svg
  arguments:
    svgPath: "/path/to/exported-design.svg"
    parent: null
    postProcess: true
    maxDim: 400
```

### Workflow
1. In Figma: Select frame → Right-click → Copy as SVG
2. Save to local file or use clipboard
3. Call `import_svg` with the file path
4. The SVG is converted to editable PenNodes

### JSX Example of Imported Structure
After import, the structure becomes:
```jsx
<Frame name="Imported from Figma" w={400} h={300}>
  {/* Converted from SVG paths */}
  <Path d="M0 0 L100 0 L100 100 L0 100 Z" fill="#3B82F6" />
  <Rectangle x={20} y={20} w={100} h={50} fill="#EF4444" rounded={8} />
  <Text x={20} y={90} size={14} fill="#000">Label Text</Text>
</Frame>
```

## CLI Conversion

Use the `openpencil` CLI for batch conversions:

```bash
# Convert .fig file to .pen format
openpencil convert input.fig --output output.pen

# Convert with specific options
openpencil convert design.fig --output design.pen --scale 2x --include-hidden

# Batch convert directory
openpencil convert ./figma-exports/*.fig --output-dir ./openpencil/
```

### Supported Conversions
| Source | Target | Notes |
|--------|--------|-------|
| .fig | .pen | Full structure preservation |
| .fig | .svg | Vector-only export |
| .pen | .fig | Round-trip back to Figma |
| .pen | .svg | Standard SVG export |

## Round-Trip Workflow

Edit designs in OpenPencil and export back to Figma:

### Step 1: Import from Figma
```bash
# Export from Figma as .fig or SVG
# Import to OpenPencil
openpencil import design.fig --create-new
```

### Step 2: Edit in OpenPencil
```jsx
// Modify the design using JSX
<Frame w={1200} h="auto" flex="col">
  {/* Your edits here */}
  <Frame flex="row" p={24} bg="#3B82F6">
    <Text size={24} fill="#FFF">Modified Design</Text>
  </Frame>
</Frame>
```

### Step 3: Export Back to Figma
```bash
# Export as Figma-compatible format
openpencil export design.pen --format figma --output design-export.fig

# Or export as SVG for direct Figma import
openpencil export design.pen --format svg --output design-export.svg
```

## MCP Tools for Figma Workflows

### Import SVG
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: import_svg
  arguments:
    svgPath: "/absolute/path/to/file.svg"
    parent: null  # null for root level
    postProcess: true  # Apply role defaults, icon resolution
    maxDim: 400  # Scale to max dimension
```

### Batch Operations
For complex multi-node operations, use the `render` tool with JSX:

## Best Practices

### Preparing Figma Files for Import
1. **Flatten complex components** before export
2. **Outline strokes** to preserve appearance
3. **Group related elements** logically
4. **Use meaningful layer names** (preserved in import)
5. **Export at 1x scale** (let OpenPencil handle scaling)

### Post-Import Cleanup
After importing SVG from Figma:
```jsx
// Organize imported layers
<Frame name="Clean Structure" w={1200} h={800}>
  <Section name="Header">
    {/* Logo, nav */}
  </Section>
  <Section name="Content">
    {/* Main content */}
  </Section>
  <Section name="Footer">
    {/* Footer elements */}
  </Section>
</Frame>
```

### Variable Mapping
Map Figma styles to OpenPencil variables:
```yaml
tool: skill_mcp
arguments:
  mcp_name: open-pencil
  tool_name: set_variables
  arguments:
    variables:
      primary: { type: "COLOR", value: "#3B82F6" }
      secondary: { type: "COLOR", value: "#64748B" }
      heading-font: { type: "STRING", value: "Inter" }
```

## Limitations

| Feature | Figma Support | Notes |
|---------|---------------|-------|
| Auto Layout | Partial | Converted to flex layout |
| Components | Partial | Converted to groups |
| Effects/Shadows | Yes | Preserved as CSS-like properties |
| Gradients | Yes | Supported |
| Text Styles | Partial | Font/size preserved |
| Prototyping | No | Design only, no interactions |
| Constraints | Partial | Converted to sizing modes |

## Troubleshooting

### Import Issues
- **Empty result**: Check SVG export settings, use "Outline text"
- **Misaligned elements**: Ensure artboard is aligned to pixel grid
- **Missing fonts**: Install fonts locally or use fallback

### Export Issues
- **Size mismatch**: Check export scale settings
- **Color differences**: Verify color profiles match
- **Text rendering**: Use "Convert to outlines" for complex typography

## File Format Reference

### .fig Format
- Figma's native binary format
- Requires conversion for OpenPencil
- Best for: Complete design preservation

### .pen Format
- OpenPencil's native format (JSON-based)
- Direct editing via MCP
- Best for: Live editing, version control

### .svg Format
- Universal vector format
- Interoperable with most tools
- Best for: Simple graphics, web export
