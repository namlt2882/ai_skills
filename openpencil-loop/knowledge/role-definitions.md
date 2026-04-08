---
name: role-definitions
description: Semantic role system with default property values
phase: [generation]
trigger:
  keywords: [landing, marketing, hero, website, 官网, 首页, 产品页, table, grid, 表格, dashboard, data, admin, testimonial, pricing, footer, stats, 评价, 定价, 页脚]
priority: 35
budget: 2000
category: knowledge
---

# Semantic Roles (auto-fill unset properties)

## Layout Roles
- section: layout=vertical, width=fill_container, height=fit_content, gap=24, padding=[60,80], alignItems=center
- row: layout=horizontal, width=fill_container, gap=16, alignItems=center
- column: layout=vertical, width=fill_container, gap=16

## Interactive Roles
- button: padding=[12,24], height=44, layout=horizontal, gap=8, alignItems=center, justifyContent=center, cornerRadius=8
- input: height=48, layout=horizontal, padding=[12,16], alignItems=center, cornerRadius=8
- form-input: width=fill_container, height=48, padding=[12,16], cornerRadius=8

## Display Roles
- card: layout=vertical, gap=12, cornerRadius=12, clipContent=true
- stat-card: layout=vertical, gap=8, padding=[24,24], cornerRadius=12

## Typography Roles
- heading: lineHeight=1.2, textGrowth=fixed-width, width=fill_container
- body-text: lineHeight=1.5, textGrowth=fixed-width, width=fill_container

**Your explicit props ALWAYS override role defaults.**
