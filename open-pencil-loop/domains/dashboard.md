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

JSX Example:
```jsx
<Frame w={1200} h="auto" flex="row" bg="#F1F5F9">
  {/* Sidebar */}
  <Frame w={260} h="auto" flex="col" p={[16,24]} gap={8} bg="#FFF">
    <Text size={20} weight="bold" p={[8,0]}>Dashboard</Text>
    <Frame flex="row" gap={12} p={[12,16]} rounded={8} bg="#F8FAFC">
      <Frame w={20} h={20} bg="#3B82F6" rounded={4} />
      <Text size={14} weight="500">Overview</Text>
    </Frame>
    <Frame flex="row" gap={12} p={[12,16]} rounded={8}>
      <Frame w={20} h={20} bg="#94A3B8" rounded={4} />
      <Text size={14}>Analytics</Text>
    </Frame>
    <Frame flex="row" gap={12} p={[12,16]} rounded={8}>
      <Frame w={20} h={20} bg="#94A3B8" rounded={4} />
      <Text size={14}>Settings</Text>
    </Frame>
  </Frame>
  
  {/* Main Content */}
  <Frame flex="col" p={24} gap={24} grow={1}>
    <Text size={28} weight="bold">Overview</Text>
    {/* Metrics Row */}
    <Frame flex="row" gap={16}>
      <Frame flex="col" p={20} gap={8} rounded={12} bg="#FFF" grow={1}>
        <Text size={14} fill="#64748B">Total Revenue</Text>
        <Text size={28} weight="bold">$45,231</Text>
        <Text size={12} fill="#22C55E">+20.1%</Text>
      </Frame>
      <Frame flex="col" p={20} gap={8} rounded={12} bg="#FFF" grow={1}>
        <Text size={14} fill="#64748B">Active Users</Text>
        <Text size={28} weight="bold">2,345</Text>
        <Text size={12} fill="#22C55E">+15.2%</Text>
      </Frame>
      <Frame flex="col" p={20} gap={8} rounded={12} bg="#FFF" grow={1}>
        <Text size={14} fill="#64748B">Conversion</Text>
        <Text size={28} weight="bold">3.24%</Text>
        <Text size={12} fill="#EF4444">-2.1%</Text>
      </Frame>
    </Frame>
  </Frame>
</Frame>
```

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

JSX Example:
```jsx
<Frame flex="col" rounded={12} bg="#FFF" overflow="hidden">
  {/* Header */}
  <Frame flex="row" p={[16,20]} bg="#F8FAFC" gap={16}>
    <Text size={14} weight="600" w={200}>Customer</Text>
    <Text size={14} weight="600" w={120}>Status</Text>
    <Text size={14} weight="600" w={100}>Amount</Text>
    <Text size={14} weight="600" flex={1}>Date</Text>
  </Frame>
  {/* Row 1 */}
  <Frame flex="row" p={[16,20]} gap={16} strokeBottom="#E2E8F0">
    <Frame flex="row" gap={12} w={200} align="center">
      <Frame w={32} h={32} rounded={16} bg="#E2E8F0" />
      <Text size={14}>Sarah Chen</Text>
    </Frame>
    <Frame w={120} align="center">
      <Frame px={12} py={4} rounded={12} bg="#ECFDF5">
        <Text size={12} fill="#16A34A" weight="500">Active</Text>
      </Frame>
    </Frame>
    <Text size={14} w={100}>$350.00</Text>
    <Text size={14} fill="#64748B" flex={1}>Apr 8, 2025</Text>
  </Frame>
  {/* Row 2 */}
  <Frame flex="row" p={[16,20]} gap={16}>
    <Frame flex="row" gap={12} w={200} align="center">
      <Frame w={32} h={32} rounded={16} bg="#E2E8F0" />
      <Text size={14}>Mike Ross</Text>
    </Frame>
    <Frame w={120} align="center">
      <Frame px={12} py={4} rounded={12} bg="#FEF3C7">
        <Text size={12} fill="#CA8A04" weight="500">Pending</Text>
      </Frame>
    </Frame>
    <Text size={14} w={100}>$125.00</Text>
    <Text size={14} fill="#64748B" flex={1}>Apr 7, 2025</Text>
  </Frame>
</Frame>
```

## Spacing
- Main content padding=[24,24], gap=16-24
- Cards: padding=[20,24], gap=12-16
- cornerRadius: 12px across cards
