---
name: landing-page
description: Landing page and marketing site design patterns
phase: [generation]
trigger:
  keywords: [landing, marketing, hero, homepage]
priority: 35
budget: 1500
category: domain
---

# Landing Page Design Patterns

## Structure
- Navigation - Hero - Features - Social Proof - CTA - Footer
- Each section: width="fill_container", height="fit_content", layout="vertical"
- Root frame: width=1200, height=0 (auto-expands), gap=0

## Navigation
- justifyContent="space_between", 3 groups: logo | nav-links | CTA button
- padding=[0,80], alignItems="center", height 64-80px

## Hero Section
- padding=[80,80] or larger
- ONE headline (40-56px), ONE subtitle (16-18px), ONE CTA button
- Optional visual: phone mockup or illustration on the right

## Feature Sections
- Cards: width="fill_container", height="fill_container" for even row alignment
- Alternate section backgrounds (#FFFFFF / #F8FAFC)
- Section vertical padding: 80-120px

## Common Patterns
- Centered content container ~1040-1160px
- Consistent cornerRadius (12-16px for cards)
- clipContent: true on cards with images
