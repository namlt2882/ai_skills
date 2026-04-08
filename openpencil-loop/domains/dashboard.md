---
name: dashboard
description: Dashboard and admin panel design patterns
phase: [generation]
trigger:
  keywords: [dashboard, admin, analytics, data]
priority: 35
budget: 1500
category: domain
---

# Dashboard Design Patterns

## Structure
- Root frame: width=1200, height=0, layout="horizontal" (sidebar + main content)
- Sidebar: width=240-280, height="fill_container", layout="vertical"
- Main content: width="fill_container", layout="vertical", gap=16-24

## Sidebar
- Logo/brand at top, padding=[24,16]
- Navigation items with icon + text
- Active item: accent background or left border

## Metrics Row
- Horizontal layout with 3-4 stat-cards
- Each card: icon + value (28-36px, bold) + label (14px, muted)
- padding=[20,24], gap=8, cornerRadius=12

## Data Tables
- Table header: background fill, bold text
- Table rows: alternating subtle backgrounds
- Status badges: pill-shaped with semantic colors

## Spacing
- Main content padding=[24,24], gap=16-24
- Cards: padding=[20,24], gap=12-16
- cornerRadius: 12px across cards
