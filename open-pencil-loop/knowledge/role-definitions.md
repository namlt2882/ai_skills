---
name: role-definitions
description: Semantic role system for open-pencil v2 with default property values
phase: [generation]
trigger:
  keywords: [landing, marketing, hero, website, 官网, 首页, 产品页, table, grid, 表格, dashboard, data, admin, testimonial, pricing, footer, stats, 评价, 定价, 页脚, nav, button, card, heading]
priority: 35
budget: 2000
category: knowledge
---

# Semantic Roles (auto-fill unset properties)

Semantic roles automatically apply sensible defaults. Your explicit props ALWAYS override role defaults.

## Layout Roles

| Role | Description | Default Properties |
|------|-------------|-------------------|
| `section` | Page section container | `flex="col"`, `w="fill"`, `h="hug"`, `gap={24}`, `p={60}`, `align="center"` |
| `row` | Horizontal flex container | `flex="row"`, `w="fill"`, `gap={16}`, `align="center"` |
| `column` | Vertical flex container | `flex="col"`, `w="fill"`, `gap={16}` |
| `container` | Generic container | `w="fill"`, `h="hug"`, `maxW={1200}` |

## Interactive Roles

| Role | Description | Default Properties |
|------|-------------|-------------------|
| `button` | Clickable button | `h={44}`, `px={24}`, `py={12}`, `rounded={8}`, `flex="row"`, `gap={8}`, `align="center"`, `justify="center"` |
| `button-primary` | Primary action button | Same as `button` + `bg` from theme primary |
| `button-secondary` | Secondary button | Same as `button` + outline style |
| `input` | Text input container | `h={48}`, `px={16}`, `rounded={8}`, `bg="#F9FAFB"` |
| `input-field` | Form input wrapper | `w="fill"`, `h={48}`, `px={16}`, `rounded={8}` |
| `select` | Dropdown selector | Same as `input` + dropdown indicator |

## Display Roles

| Role | Description | Default Properties |
|------|-------------|-------------------|
| `card` | Content card | `flex="col"`, `gap={12}`, `rounded={12}`, `overflow="hidden"`, `bg="#FFF"` |
| `card-flat` | Card without shadow | Same as `card`, no shadow |
| `stat-card` | Statistics display card | `flex="col"`, `gap={8}`, `p={24}`, `rounded={12}` |
| `feature-card` | Feature highlight card | `flex="col"`, `gap={16}`, `p={24}`, `rounded={16}` |
| `image-card` | Card with image | `flex="col"`, `rounded={16}`, `overflow="hidden"` |

## Navigation Roles

| Role | Description | Default Properties |
|------|-------------|-------------------|
| `nav` | Navigation bar | `flex="row"`, `w="fill"`, `h={64}`, `px={24}`, `align="center"`, `justify="between"` |
| `nav-item` | Navigation link | `px={16}`, `py={8}`, `rounded={6}` |
| `footer` | Page footer | `flex="col"`, `w="fill"`, `p={48}`, `gap={32}`, `align="center"` |
| `hero` | Hero section | `flex="col"`, `w="fill"`, `minH={600}`, `p={80}`, `gap={24}`, `align="center"` |
| `sidebar` | Side navigation | `flex="col"`, `w={280}`, `h="fill"`, `p={16}`, `gap={8}` |

## Typography Roles

| Role | Description | Default Properties |
|------|-------------|-------------------|
| `heading` | Section heading | `size={28}`, `weight="bold"`, `line={1.2}`, `w="fill"` |
| `heading-large` | Hero/main heading | `size={48}`, `weight="bold"`, `line={1.1}`, `w="fill"` |
| `heading-small` | Sub-heading | `size={20}`, `weight="semibold"`, `line={1.3}` |
| `body` | Body text | `size={16}`, `weight="normal"`, `line={1.6}`, `w="fill"` |
| `body-large` | Emphasized body | `size={18}`, `weight="normal"`, `line={1.5}` |
| `body-small` | Caption/supporting | `size={14}`, `weight="normal"`, `line={1.5}` |
| `label` | Form label | `size={14}`, `weight="medium"` |
| `caption` | Small helper text | `size={12}`, `weight="normal"` |

## Content Roles

| Role | Description | Default Properties |
|------|-------------|-------------------|
| `avatar` | User avatar | `w={40}`, `h={40}`, `rounded="full"` |
| `badge` | Status/tag badge | `px={8}`, `py={4}`, `rounded={12}`, `size={12}` |
| `divider` | Separator line | `w="fill"`, `h={1}`, `bg="#E5E7EB"` |
| `spacer` | Empty space | `w="fill"`, `h={24}` |
| `icon` | Icon wrapper | `w={24}`, `h={24}`, `align="center"`, `justify="center"` |

## Usage

Apply roles to Frame and Text nodes:

```jsx
<Frame role="card" w={320} h={200}>
  <Text role="heading">Card Title</Text>
  <Text role="body">Card description text here.</Text>
</Frame>
```

Roles are hints. The system applies defaults, but you can override any property explicitly.
