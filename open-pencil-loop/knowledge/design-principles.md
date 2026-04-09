---
name: design-principles
description: Core design craft principles for open-pencil v2 output
phase: [generation]
trigger:
  keywords: [design, style, aesthetic, visual, layout, spacing, typography, color, principle]
priority: 25
budget: 1000
category: knowledge
---

# Design Principles

## Typography

| Level | Size | Weight | Line | Use |
|-------|------|--------|------|-----|
| Display | 48-64px | 700 | 1.05-1.1 | Hero headlines |
| H1 | 36-40px | 700 | 1.1-1.2 | Page titles |
| H2 | 28-32px | 600 | 1.2 | Section headings |
| H3 | 20-24px | 600 | 1.3 | Subsection titles |
| Body Large | 18px | 400 | 1.5 | Lead paragraphs |
| Body | 16px | 400 | 1.6 | Standard text |
| Small | 14px | 400 | 1.5 | Captions, labels |
| Tiny | 12px | 500 | 1.4 | Tags, metadata |

**Rules:** Tight (1.05-1.15) at 48px+, loose (1.5-1.6) at 16px. Max 65-75 chars for body. Headlines bold (700), body regular (400), labels medium (500). Never all caps body text.

## Color

**Palette Structure:** 1 Primary (brand/action), 1 Accent, 1 Neutral scale (white→black, 9 steps), semantic colors (red/green/yellow/blue).

**Usage:** Max 2 saturated colors per screen. Background: #F8FAFC (not pure white). Surface: #FFFFFF for cards. Text: #111827 (not pure black). Borders: #E5E7EB.

**Contrast:** Body text 4.5:1 min, large text (18px+) 3:1, interactive elements 3:1.

## Spacing (8-point grid)

| Token | Value | Use |
|-------|-------|-----|
| xs | 4px | Tight inline |
| sm | 8px | Related elements |
| md | 16px | Component padding |
| lg | 24px | Card padding |
| xl | 32px | Section gaps |
| 2xl | 48px | Large gaps |
| 3xl | 64px | Major breaks |
| 4xl | 80px | Section padding |
| 5xl | 120px | Hero padding |

**Patterns:** Component internal 16-24px. Card padding 24px (32px for feature). Section padding 80-120px vertical. Grid gaps 16px tight, 24px standard, 32px loose.

## Layout

**Container Widths:** Mobile 375px, Tablet 768px, Desktop 1200px, Wide 1440px.

**Z-Index:** Base 0, Elevated 10 (cards/buttons), Floating 20 (dropdowns/tooltips), Sticky 30 (sticky headers), Overlay 40 (modals), Toast 50 (notifications).

**Hero:** One headline (2-6 words), one subtitle (max 15 words), one CTA. 80-120px vertical padding.

**Navigation:** Logo left, 3-5 links center, CTA right. 64-80px height, sticky.

**Card Grid:** 3-4 cards per row, 24-32px gaps, consistent heights, equal padding.

**Footer:** Logo + tagline, 3-4 link columns, social icons, copyright. 48-64px vertical padding.

## Border Radius

| Token | Value | Use |
|-------|-------|-----|
| none | 0 | Sharp edges |
| sm | 4px | Small elements, tags |
| md | 8px | Buttons, inputs |
| lg | 12px | Cards, modals |
| xl | 16px | Large cards, images |
| full | 9999px | Pills, avatars |

## Shadows

| Token | Shadow | Use |
|-------|--------|-----|
| none | none | Flat design |
| sm | 0 1px 2px rgba(0,0,0,0.05) | Subtle |
| md | 0 4px 6px rgba(0,0,0,0.07) | Cards |
| lg | 0 10px 15px rgba(0,0,0,0.1) | Dropdowns |
| xl | 0 20px 25px rgba(0,0,0,0.1) | Modals |

## Responsive Breakpoints

| Breakpoint | Width | Behavior |
|------------|-------|----------|
| Mobile | < 640px | Single column, stacked |
| Tablet | 640-1024px | 2 columns, adjusted spacing |
| Desktop | > 1024px | Full layout, 3-4 columns |

## Anti-Patterns

1. Too many font sizes — stick to 5-6 max
2. Pure black text — use #111827 or #1F2937
3. Random spacing — always multiples of 8px
4. Inconsistent borders — pick one radius per component type
5. Low contrast — always check contrast ratios
6. Overcrowding — white space is not wasted space
7. Multiple shadows — one shadow per element, consistent