---
name: cjk-typography
description: CJK (Chinese/Japanese/Korean) typography rules
phase: [generation]
trigger:
  keywords:
    - "/[\u4e00-\u9fff\u3040-\u309f\u30a0-\u30ff\uac00-\ud7af]/"
priority: 25
budget: 500
category: domain
---

# CJK Typography Rules

## Fonts
- Headings: "Noto Sans SC" (Chinese) / "Noto Sans JP" / "Noto Sans KR"
- Body: "Inter" or "Noto Sans SC"
- NEVER use "Space Grotesk"/"Manrope" for CJK headings

## Typography
- CJK lineHeight: headings 1.3-1.4, body 1.6-1.8
- letterSpacing: 0, NEVER negative for CJK

## CJK Buttons
- Each character is approximately fontSize wide
- Container width >= (charCount x fontSize) + padding

## Detection
- Detect CJK from user request language
- Use CJK fonts for ALL text nodes when CJK is detected
