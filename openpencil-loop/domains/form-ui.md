---
name: form-ui
description: Form, input, and interactive element design guidelines
phase: [generation]
trigger:
  keywords: [form, input, login, signup, sign up, register, password, email, 搜索, 表单, 登录, 注册]
priority: 30
budget: 1500
category: domain
---

# Form UI Design Patterns

## Layout
- Mobile: 375x812. Web: 1200x800 (single) or 1200x3000-5000 (landing page)

## Buttons
- height 44-52px, cornerRadius 8-12, padding [12, 24]
- Icon+text: layout="horizontal", gap=8
- Icon-only buttons: 44x44, justifyContent/alignItems="center"

## Inputs
- height 44px, light bg, subtle border
- width="fill_container" in forms

## Cards
- cornerRadius 12-16, clipContent: true
- CARD ROW ALIGNMENT: sibling cards ALL use width/height="fill_container"

## Phone Mockup
- ONE "frame", width 260-300, height 520-580, cornerRadius 32
- NEVER use ellipse for decorative shapes
- NEVER use emoji as icons
