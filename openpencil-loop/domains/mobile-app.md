---
name: mobile-app
description: Mobile app screen design patterns (375x812)
phase: [generation]
trigger:
  keywords: [mobile, app, phone, ios, android]
priority: 35
budget: 1500
category: domain
---

# Mobile App Design Patterns (375x812)

## Viewport
- Root frame: width=375, height=812 (fixed viewport)
- This is an ACTUAL mobile screen, NOT a desktop page with phone mockup

## Status Bar
- height=44, padding=[0,16], layout="horizontal", alignItems="center"

## Header
- height=56-64, padding=[0,16], layout="horizontal"
- justifyContent="space_between", alignItems="center"

## Content Area
- padding=[0,16] or [16,16], gap=16-20
- layout="vertical", width="fill_container"

## Tab Bar (bottom navigation)
- height=80-84 (includes safe area)
- layout="horizontal", justifyContent="space_around"

## Form Screens
- All inputs width="fill_container", height=48, gap=16
- Primary button width="fill_container", height=48

## Spacing
- Touch targets: minimum 44x44px
- Safe area bottom: 28px padding
