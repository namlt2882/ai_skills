---
name: examples
description: Reference examples for common UI components
phase: [generation]
trigger:
  keywords: [example, sample, show me, how to, 示例, 样例, 怎么]
priority: 50
budget: 1000
category: knowledge
---

# UI Component Examples

## Button
```json
{"id":"btn-1","type":"frame","role":"button","width":180,"cornerRadius":8,"fill":[{"type":"solid","color":"#3B82F6"}],"children":[{"id":"btn-text","type":"text","content":"Continue","fontSize":16,"fontWeight":600,"fill":[{"type":"solid","color":"#FFF"}]}]}
```

## Card
```json
{"id":"card-1","type":"frame","role":"card","width":320,"height":340,"fill":[{"type":"solid","color":"#FFF"}],"effects":[{"type":"shadow","offsetX":0,"offsetY":4,"blur":12,"color":"rgba(0,0,0,0.1)"}],"children":[{"id":"card-body","type":"frame","width":"fill_container","height":"fit_content","layout":"vertical","padding":20,"gap":8,"children":[{"id":"card-title","type":"text","role":"heading","content":"Title","fontSize":20,"fontWeight":700}]}]}
```

## Input Field
```json
{"id":"input-1","type":"frame","role":"form-input","width":"fill_container","height":48,"cornerRadius":8,"fill":[{"type":"solid","color":"#F9FAFB"}]}
```
