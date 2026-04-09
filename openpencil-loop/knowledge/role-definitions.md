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

# Semantic Roles — Complete Reference

**Core principle: Your explicit props ALWAYS override role defaults.**

Role defaults fill in unset properties. If you explicitly set `width: 520`, it overrides `fill_container`. If you don't set it, the role default applies.

---

## Role Override Rules

| Situation | What to Do |
|-----------|------------|
| Role default conflicts with your layout | **Override explicitly** — e.g., `section` has `alignItems=center` but you want left-aligned content → set `alignItems=MIN` |
| Role default is close but not quite right | **Override only the specific prop** — e.g., `button` has `height=44` but you want taller → set `height: 56` |
| Role default is perfect for your use case | **Trust the default** — no need to re-specify |
| Nested context changes behavior | **Role defaults cascade** — children inside `section` inherit section's `gap` and `padding` context |

---

## Layout Roles

### `section`
Vertical stack layout — use for page sections or major content blocks.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | vertical | Almost never — sections are vertical stacks |
| width | fill_container | Only if section has fixed max-width |
| height | fit_content | Only for hero or full-viewport sections |
| gap | 24 | Match content density (16 for dense, 40 for airy) |
| padding | [60, 80] | Match vertical rhythm (24 for compact, 120 for hero) |
| alignItems | center | Override to MIN for left-aligned content |

**Context note:** `section` children inherit `padding` context. A `button` inside a `section` with `padding=[60,80]` will visually "pad" into the section's content area.

### `row`
Horizontal line layout — use for button rows, icon+text combos, form fields.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | horizontal | Almost never |
| width | fill_container | Rare — rows usually fill parent width |
| gap | 16 | Match sibling spacing needs (8 for tight, 24 for loose) |
| alignItems | center | Only for top/bottom-aligned elements |

### `column`
Vertical stack without section padding — use inside cards or form panels.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | vertical | Almost never |
| width | fill_container | Rare |
| gap | 16 | Match internal element spacing |

---

## Interactive Roles

### `button`
Tap/click target. Default sizing is touch-friendly (44px height minimum).

| Property | Default | When to Override |
|----------|---------|------------------|
| padding | [12, 24] | Wider for prominent CTAs, narrower for compact toolbars |
| height | 44 | Taller (56px) for primary CTAs, shorter (36px) for inline actions |
| layout | horizontal | Rarely change |
| gap | 8 | Match icon presence (16 with icon, 0 without) |
| alignItems | center | Almost never |
| justifyContent | center | Rarely change |
| cornerRadius | 8 | Larger (12-16) for primary, smaller (4-6) for subtle |

**Context behavior:**
- Button in `navbar`: `padding=[8,16]`, `height=36` (compact toolbar style)
- Button in `card`: `padding=[12,24]`, `height=44` (standard CTA)
- Button in `form`: Same as card — form context doesn't change button defaults

### `input`
Single-line text entry field.

| Property | Default | When to Override |
|----------|---------|------------------|
| height | 48 | Taller (56px) for prominent inputs, shorter (40px) for compact forms |
| layout | horizontal | Rarely change |
| padding | [12, 16] | Match visual weight |
| alignItems | center | Rarely change |
| cornerRadius | 8 | Match other interactive elements in the form |

### `form-input`
Alias for `input` with form-specific semantics. Same defaults as `input`.

---

## Display Roles

### `card`
Container with visual separation. Use for dashboard metrics, product tiles, pricing tiers.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | vertical | Rarely change |
| gap | 12 | Match internal content density |
| cornerRadius | 12 | Larger (16-20) for featured cards, smaller (8) for subtle |
| clipContent | true | Almost never — cards should clip |
| padding | not set | Set explicitly based on card size |

**Height behavior:** `card` defaults to `fit_content`. If you want fixed-height cards (e.g., 200px stat cards), explicitly set `height: 200`.

### `stat-card`
Specialized card for KPI/metric displays. Shorter padding, tighter gap.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | vertical | Rarely change |
| gap | 8 | Tighter than generic card |
| padding | [24, 24] | Square-ish, not overly padded |
| cornerRadius | 12 | Match other cards in dashboard |

**Typical stat-card children:** label (body-text), value (heading), trend indicator (optional).

### `chip` / `badge`
Small inline status indicators.

| Property | Default | When to Override |
|----------|---------|------------------|
| height | 24 | Taller (32px) for featured badges |
| padding | [4, 12] | Wider for multi-word labels |
| cornerRadius | 12 | Pill shape — almost always keep |
| layout | horizontal | Rarely change |

---

## Typography Roles

### `heading`
Large text for section titles, card headers, hero text.

| Property | Default | When to Override |
|----------|---------|------------------|
| lineHeight | 1.2 | Larger (1.4) for short headings, smaller (1.1) for large display text |
| textGrowth | fixed-width | Almost never — headings should not auto-wrap |
| width | fill_container | Rare — headings usually fill container |

**Size:** Set `fontSize` explicitly (not in role defaults). Common: 14-18px for card headings, 24-32px for section titles, 48-64px for hero text.

### `body-text`
Standard readable text for descriptions, paragraphs.

| Property | Default | When to Override |
|----------|---------|------------------|
| lineHeight | 1.5 | Larger (1.6-1.8) for long-form reading, smaller (1.4) for dense UI |
| textGrowth | fixed-width | Rarely change |
| width | fill_container | Rarely change |

### `label`
Small descriptive text above form fields or stats.

| Property | Default | When to Override |
|----------|---------|------------------|
| fontSize | 12 | Standard for field labels |
| fontWeight | 500 | Bolder (600) for required fields |
| lineHeight | 1.4 | Rarely change |
| textDecoration | none | Use `underline` for links |

---

## Icon Roles

### `icon`
Vector icon in a container. Not a role itself but `icon-size` token controls.

| Token | Value | Use |
|-------|-------|-----|
| icon-size/small | 16px | Inline with text, form field suffix |
| icon-size/medium | 24px | Toolbar buttons, navigation icons |
| icon-size/large | 32px+ | Feature icons, empty states |

Icon is typically a child of `button` or `row` with gap=8 between icon and label.

---

## Semantic Zone Roles

### `navbar`
Top navigation bar.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | horizontal | Rarely change |
| height | 64 | Taller (80px) for featured nav, shorter (48px) for minimal |
| gap | 24 | Space between nav items |
| padding | [0, 24] | Horizontal padding only |
| fill | #FFFFFF | Light theme navbar |

### `sidebar`
Vertical navigation panel.

| Property | Default | When to Override |
|----------|---------|------------------|
| layout | vertical | Rarely change |
| width | 240 | Fixed width sidebar |
| gap | 4 | Tight spacing for nav items |
| padding | [16, 16] | Compact padding |

---

## Using Roles in Practice

### Example 1: Custom-width section
```javascript
// Role defaults give section: layout=vertical, width=fill_container
// Override width to create max-width container:
openpencil_update_node({ nodeId: "hero-section", data: { width: 1200 } })

// Or at creation time in batch_design:
"I(hero-section, { type: 'frame', name: 'Hero', width: 1200, layout: 'vertical' })"
```

### Example 2: Left-aligned section content
```javascript
// Role default: section.alignItems = center
// Override to left-align:
"I(about-section, { type: 'frame', name: 'About', alignItems: 'MIN' })"
```

### Example 3: Dense card grid vs airy showcase
```javascript
// Dense: override gap from role default 12 → 8
"I(stats-grid, { type: 'frame', name: 'StatsGrid', gap: 8, children: [...] })"

// Airy: override gap 12 → 40
"I(showcase-grid, { type: 'frame', name: 'ShowcaseGrid', gap: 40, children: [...] })"
```

### Example 4: Button context overrides
```javascript
// Primary CTA button — override height and padding for prominence
"I(primary-btn, { type: 'frame', role: 'button', height: 56, padding: [16, 32], cornerRadius: 12 })"

// Compact toolbar button — override height and padding smaller
"I(toolbar-btn, { type: 'frame', role: 'button', height: 36, padding: [8, 12], cornerRadius: 6 })"
```

---

## Common Mistakes

| Mistake | Why It's Wrong | Correct |
|---------|---------------|---------|
| Setting every prop explicitly | Ignores role defaults, makes code verbose | Only set props that differ from default |
| Never overriding section alignItems | Sections default to center-aligned, but content is usually left-aligned | Check: does your content look centered when it should be left-aligned? Override `alignItems: MIN` |
| Forgetting card clipContent | Cards without clipContent overflow their children | Role default includes `clipContent: true` — trust it |
| Setting height on fill_container children | If parent has `width: fill_container`, setting fixed `height` on children can cause overflow | Let content determine height with `fit_content` |
| Overriding role AND setting same prop | e.g., `role: 'button'` then `height: 44` when role already sets `height: 44` | Only override what actually differs |