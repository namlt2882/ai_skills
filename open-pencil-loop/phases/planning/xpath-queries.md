---
name: xpath-queries
description: XPath query patterns for targeting nodes in OpenPencil (https://github.com/open-pencil/open-pencil)
docs: https://github.com/nanodocumet/open-pencil
trigger: null
phase: [planning]
priority: 5
budget: 1000
category: base
---

# XPath Queries (v2)

OpenPencil (https://github.com/open-pencil/open-pencil) supports XPath selectors for querying and targeting nodes. Use with `query_nodes` MCP tool.

## Available Node Types

| XPath Type | Description |
|------------|-------------|
| `//FRAME` | Frame containers with auto-layout |
| `//TEXT` | Text nodes |
| `//RECTANGLE` | Rectangular shapes |
| `//ELLIPSE` | Circular/oval shapes |
| `//LINE` | Line elements |
| `//STAR` | Star shapes |
| `//POLYGON` | Polygon shapes |
| `//SECTION` | Section containers |
| `//GROUP` | Group nodes |
| `//COMPONENT` | Component definitions |
| `//INSTANCE` | Component instances |
| `//VECTOR` | Vector/path elements |

## Basic Queries

### Select All Nodes of Type
```xpath
//FRAME          - All frames
//TEXT           - All text nodes
//RECTANGLE      - All rectangles
//ELLIPSE        - All ellipses
```

### Select by Attribute
```xpath
//FRAME[@width < 300]                    - Frames narrower than 300px
//FRAME[@width > 600]                    - Frames wider than 600px
//FRAME[@height = 812]                   - Frames exactly 812px tall
//FRAME[@cornerRadius > 0]               - Frames with rounded corners
//FRAME[@opacity < 1]                    - Frames with transparency
//TEXT[@fontSize > 20]                   - Text larger than 20px
//TEXT[@fontWeight = 700]                - Bold text (700 weight)
//TEXT[@lineHeight > 1.5]                - Text with extra line spacing
```

### Select by Name
```xpath
//FRAME[@name = 'Hero']                  - Exact match
//FRAME[starts-with(@name, 'Button')]    - Names starting with "Button"
//FRAME[contains(@name, 'Card')]         - Names containing "Card"
//TEXT[contains(@text, 'Hello')]         - Text nodes containing "Hello"
//TEXT[starts-with(@text, 'Welcome')]    - Text starting with "Welcome"
```

## Hierarchical Queries

### Parent-Child Relationships
```xpath
//SECTION/FRAME          - Direct frame children of sections
//SECTION//FRAME         - All frames inside sections (any depth)
//FRAME/TEXT             - Direct text children of frames
//FRAME//TEXT            - All text inside frames (any depth)
//GROUP/*                - All direct children of groups
```

### Specific Paths
```xpath
//PAGE/SECTION/FRAME     - Frames inside sections inside pages
//NAV//BUTTON            - All buttons anywhere inside nav
//CARD/HEADER/TEXT       - Text in headers of cards
```

## Combined Queries

### Type + Attribute + Hierarchy
```xpath
//SECTION//FRAME[@width < 300]           - Narrow frames inside sections
//FRAME[contains(@name, 'Card')]//TEXT   - All text inside card frames
//SECTION[@name = 'Hero']//FRAME         - All frames in Hero section
```

### Multiple Conditions
```xpath
//FRAME[@width > 300 and @height > 200]
//TEXT[@fontSize >= 16 and @fontSize <= 24]
//RECTANGLE[@cornerRadius > 0 and @fill = '#FFFFFF']
```

## Layout Queries

### Layout Mode
```xpath
//FRAME[@layoutMode = 'HORIZONTAL']      - Horizontal auto-layout frames
//FRAME[@layoutMode = 'VERTICAL']        - Vertical auto-layout frames
//FRAME[@layoutMode = 'NONE']            - Frames without auto-layout
```

### Spacing and Padding
```xpath
//FRAME[@itemSpacing > 16]               - Frames with large gaps between items
//FRAME[@paddingTop > 0]                 - Frames with top padding
//FRAME[@paddingBottom = @paddingTop]    - Frames with symmetrical vertical padding
```

### Alignment
```xpath
//FRAME[@primaryAxisAlignItems = 'CENTER']
//FRAME[@counterAxisAlignItems = 'STRETCH']
```

## Style Queries

### Fill and Stroke
```xpath
//*[@fill = '#FFFFFF']                   - Nodes with white fill
//*[@fill]                               - Nodes with any fill
//FRAME[@strokeWeight > 0]               - Frames with borders
//RECTANGLE[@stroke = '#000000']         - Rectangles with black borders
```

### Effects
```xpath
//*[@effects]                            - Nodes with any effects (shadows, blur)
//FRAME[@dropShadow = true]              - Frames with drop shadows
```

## Visibility Queries

```xpath
//*[@visible = false]                    - Hidden nodes
//*[@visible = true]                     - Visible nodes (explicit)
//*[@locked = true]                      - Locked nodes
//*[@opacity = 0]                        - Fully transparent nodes
```

## Practical Examples

### Find All Buttons
```xpath
//FRAME[contains(@name, 'Button') or contains(@name, 'Btn')]
//COMPONENT[contains(@name, 'Button')]
//INSTANCE[contains(@name, 'Button')]
```

### Find All Headings
```xpath
//TEXT[@fontSize >= 24 or contains(@name, 'Heading') or contains(@name, 'H1') or contains(@name, 'H2') or contains(@name, 'Title')]
```

### Find Navigation Elements
```xpath
//FRAME[contains(@name, 'Nav') or contains(@name, 'Header') or contains(@name, 'Menu')]
//SECTION[contains(@name, 'Navigation')]
```

### Find Cards
```xpath
//FRAME[contains(@name, 'Card') and @cornerRadius > 0]
//RECTANGLE[contains(@name, 'Card')]
//COMPONENT[contains(@name, 'Card')]
```

### Find Images
```xpath
//RECTANGLE[@fill contains 'image']
//ELLIPSE[@fill contains 'image']
//GROUP[contains(@name, 'Image') or contains(@name, 'Photo')]
```

### Find Interactive Elements
```xpath
//FRAME[@cornerRadius > 0 and (@strokeWeight > 0 or @effects)]
//COMPONENT[contains(@name, 'Button') or contains(@name, 'Input') or contains(@name, 'Card')]
```

### Find Responsive Breakpoints
```xpath
//FRAME[@width = 375]                    - Mobile frames
//FRAME[@width = 768]                    - Tablet frames  
//FRAME[@width = 1200]                   - Desktop frames
//FRAME[@width >= 1400]                  - Large desktop frames
```

## Query Best Practices

1. **Start Broad, Then Narrow**: Begin with `//FRAME` then add filters
2. **Use Contains for Flexibility**: `contains(@name, 'Button')` matches "PrimaryButton", "SubmitButton", etc.
3. **Check Hierarchy**: Use `/` for direct children, `//` for any depth
4. **Combine Conditions**: Use `and`/`or` for complex selections
5. **Test Queries**: Run queries iteratively to verify results

## MCP Tool Usage

Query nodes using the open-pencil MCP:

```json
{
  "tool_name": "query_nodes",
  "arguments": {
    "selector": "//FRAME[@width < 300]",
    "limit": 50
  }
}
```

Results include node IDs that can be used with:
- `update_node`
- `delete_node`
- `move_node`
- `copy_node`
