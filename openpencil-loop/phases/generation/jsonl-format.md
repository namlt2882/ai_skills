---
name: jsonl-format
description: PenNode flat JSONL output format
phase: [generation]
trigger: null
priority: 0
budget: 1500
category: base
---

# PenNode JSONL Format

Output ONE node per line as JSON.

## Types
- frame (width,height,layout,gap,padding,justifyContent,alignItems,clipContent,cornerRadius,fill,stroke,effects)
- rectangle, ellipse
- text (content,fontFamily,fontSize,fontWeight,fill,textAlign,textGrowth,lineHeight)
- icon_font (iconFontName,width,height,fill)
- path (d,width,height,fill,stroke)
- image (width,height,src)

## Shared
id, type, name, role, x, y, opacity
width/height: number | "fill_container" | "fit_content"
padding: number | [v,h] | [T,R,B,L]
Fill=[{"type":"solid","color":"#hex"}]

## Rules
- Section root: width="fill_container", height="fit_content", layout="vertical"
- No x/y on children in layout frames
- Width consistency: siblings use SAME width strategy
- Text: NEVER set explicit height. textGrowth="fixed-width" for wrapping
- Icons: icon_font nodes with iconFontName (lucide names)
- Buttons: frame(padding=[12,24]) > text
- Z-order: Earlier siblings render on top

## Format
_parent (null=root, else parent-id). Parent before children.
```json
{"_parent":null,"id":"root","type":"frame","name":"Hero",...}
{"_parent":"root","id":"header","type":"frame","name":"Header",...}
```
