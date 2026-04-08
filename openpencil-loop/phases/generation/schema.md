---
name: schema
description: PenNode type schema reference
phase: [generation]
trigger: null
priority: 0
budget: 500
category: base
---

# PenNode Schema Reference

## Frame
```json
{
  "type": "frame",
  "name": "ComponentName",
  "width": 1200 | "fill_container" | "fit_content",
  "height": 0 | "fill_container" | "fit_content",
  "layout": "vertical" | "horizontal" | "none",
  "gap": 24,
  "padding": 24 | [T,R,B,L] | [V,H] | [T,R,B,L],
  "justifyContent": "start" | "center" | "end" | "space_between" | "space_around",
  "alignItems": "start" | "center" | "end" | "stretch",
  "clipContent": true | false,
  "cornerRadius": 12,
  "fill": [{"type": "solid", "color": "#hex"}],
  "stroke": {"thickness": 1, "fill": [{"type": "solid", "color": "#hex"}]},
  "effects": [{"type": "shadow", "offsetX": 0, "offsetY": 4, "blur": 12, "color": "rgba(0,0,0,0.1)"}]
}
```

## Text
```json
{
  "type": "text",
  "content": "Hello World",
  "fontSize": 16,
  "fontWeight": 400 | 500 | 600 | 700,
  "fontFamily": "Inter",
  "lineHeight": 1.5,
  "letterSpacing": 0,
  "textAlign": "left" | "center" | "right",
  "textGrowth": "auto" | "fixed-width" | "fixed-width-height",
  "fill": [{"type": "solid", "color": "#hex"}]
}
```

## Path/Icon
```json
{
  "type": "path",
  "name": "SearchIcon",
  "d": "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z",
  "width": 24,
  "height": 24,
  "fill": [{"type": "solid", "color": "#hex"}],
  "stroke": {"thickness": 2, "fill": [{"type": "solid", "color": "#hex"}]}
}
```

## Icon Font
```json
{
  "type": "icon_font",
  "iconFontName": "search",
  "width": 24,
  "height": 24,
  "fill": "#hex"
}
```

## Image
```json
{
  "type": "image",
  "src": "https://...",
  "width": 400,
  "height": 300
}
```

## Rectangle
```json
{
  "type": "rectangle",
  "width": 100,
  "height": 100,
  "cornerRadius": 12,
  "fill": [{"type": "solid", "color": "#hex"}]
}
```
