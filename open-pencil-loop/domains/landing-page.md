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

```jsx
<Frame w={1200} h={72} flex="row" bg="#FFF" p={[0,80]} justify="space-between" align="center">
  <Text size={20} weight="bold">Logo</Text>
  <Frame flex="row" gap={32}>
    <Text size={14}>Features</Text>
    <Text size={14}>Pricing</Text>
    <Text size={14}>About</Text>
  </Frame>
  <Frame bg="#000" p={[12,24]} rounded={8}>
    <Text size={14} fill="#FFF">Get Started</Text>
  </Frame>
</Frame>
```

## Hero Section

```jsx
<Frame w={1200} h="auto" flex="col" p={[80,80]} gap={24} bg="#F8FAFC">
  <Text size={48} weight="bold" align="center">Build Better Products</Text>
  <Text size={18} fill="#64748B" align="center">The platform for modern teams</Text>
  <Frame flex="row" gap={16} justify="center">
    <Frame bg="#000" p={[16,32]} rounded={8}>
      <Text size={16} fill="#FFF">Start Free Trial</Text>
    </Frame>
    <Frame p={[16,32]} rounded={8} stroke="#E2E8F0">
      <Text size={16}>Learn More</Text>
    </Frame>
  </Frame>
</Frame>
```

## Feature Sections

```jsx
<Frame w={1200} h="auto" flex="col" p={[80,80]} gap={48}>
  <Text size={36} weight="bold" align="center">Key Features</Text>
  <Frame flex="row" gap={24}>
    <Frame flex="col" p={24} gap={16} rounded={16} fill="#FFF" stroke="#E2E8F0" grow={1}>
      <Frame w={48} h={48} rounded={12} bg="#EEF2FF" />
      <Text size={20} weight="600">Fast Setup</Text>
      <Text size={14} fill="#64748B">Get started in minutes</Text>
    </Frame>
    <Frame flex="col" p={24} gap={16} rounded={16} fill="#FFF" stroke="#E2E8F0" grow={1}>
      <Frame w={48} h={48} rounded={12} bg="#ECFDF5" />
      <Text size={20} weight="600">Secure</Text>
      <Text size={14} fill="#64748B">Enterprise-grade security</Text>
    </Frame>
    <Frame flex="col" p={24} gap={16} rounded={16} fill="#FFF" stroke="#E2E8F0" grow={1}>
      <Frame w={48} h={48} rounded={12} bg="#FEF3C7" />
      <Text size={20} weight="600">Scalable</Text>
      <Text size={14} fill="#64748B">Grows with your team</Text>
    </Frame>
  </Frame>
</Frame>
```

## Common Patterns
- Centered content container ~1040-1160px
- Consistent cornerRadius (12-16px for cards)
- clipContent: true on cards with images