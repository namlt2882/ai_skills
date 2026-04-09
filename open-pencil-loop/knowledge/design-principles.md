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

Craft principles for creating polished, professional designs.

## Typography

### Type Scale
Create clear hierarchy with meaningful size jumps:

| Level | Size | Weight | Line Height | Use |
|-------|------|--------|-------------|-----|
| Display | 48-64px | 700 | 1.05-1.1 | Hero headlines |
| H1 | 36-40px | 700 | 1.1-1.2 | Page titles |
| H2 | 28-32px | 600 | 1.2 | Section headings |
| H3 | 20-24px | 600 | 1.3 | Subsection titles |
| Body Large | 18px | 400 | 1.5 | Lead paragraphs |
| Body | 16px | 400 | 1.6 | Standard text |
| Small | 14px | 400 | 1.5 | Captions, labels |
| Tiny | 12px | 500 | 1.4 | Tags, metadata |

### Typography Rules
- **Tight at large sizes**: 48px+ headlines get 1.05-1.15 line height
- **Loose at small sizes**: 16px body gets 1.5-1.6 line height
- **Max width for readability**: Body text should wrap at 65-75 characters
- **Weight contrast**: Headlines bold (700), body regular (400), labels medium (500)
- **Never all caps for body text**: Use sentence case

## Color

### Palette Structure
- **1 Primary**: Your brand/action color (blue, purple, etc.)
- **1 Accent**: Secondary highlight (often complementary)
- **1 Neutral scale**: Grays from white to black (9 steps)
- **Semantic colors**: Red (error), green (success), yellow (warning), blue (info)

### Color Usage
- **Max 2 saturated colors** on any screen
- **Background**: Slightly tinted (#F8FAFC) not pure white (#FFFFFF)
- **Surface**: White (#FFFFFF) for cards on tinted backgrounds
- **Text**: Near-black (#111827) not pure black (#000000)
- **Borders**: Light gray (#E5E7EB) for subtle separation

### Contrast Requirements
- **Body text**: 4.5:1 minimum (WCAG AA)
- **Large text (18px+)**: 3:1 minimum
- **Interactive elements**: 3:1 against adjacent colors

## Spacing

### 8-Point Grid
All spacing uses multiples of 8px:

| Token | Value | Use |
|-------|-------|-----|
| xs | 4px | Tight inline spacing |
| sm | 8px | Related elements |
| md | 16px | Component padding |
| lg | 24px | Card padding |
| xl | 32px | Section gaps |
| 2xl | 48px | Large section gaps |
| 3xl | 64px | Major section breaks |
| 4xl | 80px | Section padding |
| 5xl | 120px | Hero padding |

### Spacing Patterns
- **Component internal**: 16-24px (buttons, inputs)
- **Card padding**: 24px standard, 32px for feature cards
- **Section padding**: 80-120px vertical, 24-48px horizontal
- **Grid gaps**: 16px tight, 24px standard, 32px loose

## Layout

### Container Widths
| Type | Width | Use |
|------|-------|-----|
| Mobile | 375px | Phone breakpoint |
| Tablet | 768px | Tablet breakpoint |
| Desktop | 1200px | Standard max-width |
| Wide | 1440px | Full-width layouts |

### Common Patterns

**Hero Section**
- One headline (2-6 words)
- One subtitle (1 sentence, max 15 words)
- One primary CTA button
- Centered or left-aligned
- 80-120px vertical padding

**Navigation**
- Logo on left
- 3-5 links in center
- CTA button on right
- 64-80px height
- Sticky positioning

**Card Grid**
- 3-4 cards per row (desktop)
- 24-32px gaps
- Consistent card heights
- Equal padding inside cards

**Footer**
- Logo + tagline
- Link columns (3-4 max)
- Social icons
- Copyright + legal
- 48-64px vertical padding

### Z-Index Scale
| Level | Z-Index | Use |
|-------|---------|-----|
| Base | 0 | Default content |
| Elevated | 10 | Cards, buttons |
| Floating | 20 | Dropdowns, tooltips |
| Sticky | 30 | Sticky headers |
| Overlay | 40 | Modals, backdrops |
| Toast | 50 | Notifications |

## Visual Style

### Border Radius
| Token | Value | Use |
|-------|-------|-----|
| none | 0 | Sharp edges |
| sm | 4px | Small elements, tags |
| md | 8px | Buttons, inputs |
| lg | 12px | Cards, modals |
| xl | 16px | Large cards, images |
| full | 9999px | Pills, avatars |

### Shadows
| Token | Shadow | Use |
|-------|--------|-----|
| none | none | Flat design |
| sm | 0 1px 2px rgba(0,0,0,0.05) | Subtle elevation |
| md | 0 4px 6px rgba(0,0,0,0.07) | Cards |
| lg | 0 10px 15px rgba(0,0,0,0.1) | Dropdowns |
| xl | 0 20px 25px rgba(0,0,0,0.1) | Modals |

## Responsive Breakpoints

| Breakpoint | Width | Behavior |
|------------|-------|----------|
| Mobile | < 640px | Single column, stacked |
| Tablet | 640-1024px | 2 columns, adjusted spacing |
| Desktop | > 1024px | Full layout, 3-4 columns |

## Design Anti-Patterns

Avoid these common mistakes:

1. **Too many font sizes** - Stick to 5-6 sizes maximum
2. **Pure black text** - Use #111827 or #1F2937 instead
3. **Random spacing** - Always use multiples of 8px
4. **Inconsistent borders** - Pick one radius and stick with it per component type
5. **Low contrast** - Always check contrast ratios
6. **Overcrowding** - White space is not wasted space
7. **Multiple shadows** - One shadow per element, consistent across the design
