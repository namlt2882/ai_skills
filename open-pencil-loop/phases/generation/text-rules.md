---
name: text-rules
description: Text node rules for OpenPencil (https://github.com/open-pencil/open-pencil)
trigger: null
priority: 5
budget: 1000
category: base
---

# Text Node Rules for OpenPencil (https://github.com/open-pencil/open-pencil)

## JSX Text Props

```jsx
<Text
  size={16}                    // fontSize
  weight="bold"                // fontWeight: "normal" | "medium" | "semibold" | "bold" | number
  family="Inter"               // fontFamily
  fill="#1E293B"               // text color
  lineHeight={1.5}             // line height multiplier
  letterSpacing={-0.5}         // letter spacing in px or em
  align="left"                 // textAlign: left | center | right
  wrap={true}                  // text wrapping enabled
  opacity={1}                  // opacity 0-1
>
  Content here
</Text>
```

## NEVER Set Explicit Height on Text Nodes

Text nodes calculate their own height based on content. Setting explicit height causes truncation or overflow.

```jsx
// CORRECT
<Text size={16} wrap={true}>
  This text will auto-size its height
</Text>

// INCORRECT - DO NOT DO THIS
<Text size={16} h={50}>       {/* Never set height */}
  Truncated text
</Text>
```

## Line Height Guidelines

| Context | Line Height |
|---------|-------------|
| Display text (40px+) | 0.9-1.1 |
| Headings (20-36px) | 1.0-1.3 |
| Body text (14-18px) | 1.4-1.6 |
| Captions, labels (<14px) | 1.2-1.4 |

```jsx
// Display
<Text size={56} lineHeight={1.0} weight="bold">Hero</Text>

// Heading
<Text size={32} lineHeight={1.2} weight="bold">Title</Text>

// Body
<Text size={16} lineHeight={1.5}>Paragraph text</Text>
```

## CJK Line Height

Chinese, Japanese, Korean text needs extra breathing room:

| Context | Line Height |
|---------|-------------|
| CJK Headings | 1.3-1.4 |
| CJK Body | 1.6-1.8 |

```jsx
<Text size={16} lineHeight={1.7} family="Noto Sans SC">
  中文内容需要更大的行高
</Text>
```

## Letter Spacing

| Context | Letter Spacing |
|---------|----------------|
| Headlines | -0.5 to -1px |
| Body text | 0 |
| Uppercase labels | 1-3px |
| Monospace/code | 0 |

```jsx
<Text size={48} letterSpacing={-1} weight="bold">TIGHT</Text>
<Text size={12} letterSpacing={2} uppercase>LABEL</Text>
```

## Width Strategy

```jsx
// Text in vertical layout - fill container width
<Frame flex="col" w={400}>
  <Text size={16} wrap={true}>      {/* Will be 400px wide */}
    Long text that wraps...
  </Text>
</Frame>

// Text in horizontal row - auto width
<Frame flex="row" gap={8}>
  <Text size={14}>Label:</Text>      {/* Auto width */}
  <Text size={14} wrap={true}>Value text</Text>
</Frame>
```

## Text Hierarchy Examples

```jsx
<Frame flex="col" gap={8}>
  {/* Hero/Display */}
  <Text size={48} weight="bold" lineHeight={1.1} letterSpacing={-1}>
    Main Headline
  </Text>
  
  {/* Subtitle */}
  <Text size={20} fill="#64748B" lineHeight={1.4}>
    Supporting description text
  </Text>
  
  {/* Body */}
  <Text size={16} lineHeight={1.5} wrap={true}>
    Body paragraph with more content that wraps across multiple lines
    when the text is long enough to require wrapping behavior.
  </Text>
  
  {/* Caption */}
  <Text size={12} fill="#94A3B8" lineHeight={1.4}>
    Last updated 2 hours ago
  </Text>
</Frame>
```

## Font Weight Values

| Weight Name | Value |
|-------------|-------|
| thin | 100 |
| extralight | 200 |
| light | 300 |
| normal | 400 |
| medium | 500 |
| semibold | 600 |
| bold | 700 |
| extrabold | 800 |
| black | 900 |

```jsx
<Text weight="medium">Medium weight</Text>
<Text weight={600}>Semibold (numeric)</Text>
```

## MCP Text Node Creation

```javascript
skill_mcp({
  mcp_name: "open-pencil",
  tool_name: "insert_node",
  arguments: {
    parent: "parent-frame-id",
    data: {
      type: "text",
      name: "Heading",
      fontSize: 24,
      fontWeight: 700,
      fontFamily: "Inter",
      fill: [{ type: "solid", color: "#1E293B" }],
      lineHeight: 1.3,
      textAlign: "left",
      textGrowth: "fixed-width"    // For wrapping text
    }
  }
})
```
