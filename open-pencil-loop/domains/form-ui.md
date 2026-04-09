---
name: form-ui
description: Form, input, and interactive element design guidelines
phase: [generation]
trigger:
  keywords: [form, input, login, signup, register, password, email, 搜索, 表单, 登录, 注册]
priority: 30
budget: 1500
category: domain
---

# Form UI Design Patterns

## Buttons

- height 44-52px, cornerRadius 8-12, padding [12, 24]
- Icon+text: layout="horizontal", gap=8
- Icon-only: 44x44, align/justify="center"

```jsx
// Primary
<Frame h={48} p={[12,24]} rounded={8} bg="#3B82F6" align="center" justify="center">
  <Text size={16} fill="#FFF" weight="600">Submit</Text>
</Frame>

// Secondary
<Frame h={48} p={[12,24]} rounded={8} stroke="#E2E8F0" align="center" justify="center">
  <Text size={16} weight="600">Cancel</Text>
</Frame>

// With Icon
<Frame flex="row" h={48} p={[12,24]} rounded={8} bg="#000" align="center" gap={8}>
  <Frame w={20} h={20} fill="#FFF" />
  <Text size={16} fill="#FFF" weight="600">Download</Text>
</Frame>

// Icon-only
<Frame w={44} h={44} rounded={8} bg="#F1F5F9" align="center" justify="center">
  <Frame w={20} h={20} fill="#64748B" />
</Frame>
```

## Inputs

- height 44px, light bg, subtle border
- width="fill_container" in forms

```jsx
// Label + Input
<Frame flex="col" gap={8}>
  <Text size={14} weight="500">Email Address</Text>
  <Frame h={48} p={[0,16]} rounded={8} stroke="#E2E8F0" align="center">
    <Text size={16} fill="#94A3B8">name@company.com</Text>
  </Frame>
</Frame>

// Input with Icon
<Frame flex="col" gap={8}>
  <Text size={14} weight="500">Search</Text>
  <Frame flex="row" h={48} p={[0,12]} rounded={8} stroke="#E2E8F0" align="center" gap={12}>
    <Frame w={20} h={20} fill="#94A3B8" />
    <Text size={16} fill="#94A3B8">Search...</Text>
  </Frame>
</Frame>

// Input with Action (password show)
<Frame flex="col" gap={8}>
  <Text size={14} weight="500">Password</Text>
  <Frame flex="row" h={48} p={[0,12,0,16]} rounded={8} stroke="#E2E8F0" align="center">
    <Text size={16} flex={1}>••••••••</Text>
    <Frame w={36} h={36} rounded={6} align="center" justify="center">
      <Text size={12} fill="#3B82F6">Show</Text>
    </Frame>
  </Frame>
</Frame>
```

## Cards

- cornerRadius 12-16, clipContent: true
- CARD ROW ALIGNMENT: sibling cards ALL use width/height="fill_container"

```jsx
<Frame flex="row" gap={24}>
  {/* Card 1 */}
  <Frame flex="col" p={24} gap={16} rounded={16} fill="#FFF" stroke="#E2E8F0" grow={1}>
    <Frame w={48} h={48} rounded={12} bg="#EEF2FF" />
    <Text size={20} weight="600">Plan Selection</Text>
    <Text size={14} fill="#64748B">Choose the right plan</Text>
    <Frame flex="row" gap={8}>
      <Frame flex="row" p={[12,16]} rounded={8} bg="#3B82F6" grow={1} justify="center">
        <Text size={14} fill="#FFF" weight="500">Monthly</Text>
      </Frame>
      <Frame flex="row" p={[12,16]} rounded={8} stroke="#E2E8F0" grow={1} justify="center">
        <Text size={14} weight="500">Yearly</Text>
      </Frame>
    </Frame>
  </Frame>
  
  {/* Card 2 */}
  <Frame flex="col" p={24} gap={16} rounded={16} fill="#FFF" stroke="#E2E8F0" grow={1}>
    <Frame w={48} h={48} rounded={12} bg="#ECFDF5" />
    <Text size={20} weight="600">Payment Info</Text>
    <Text size={14} fill="#64748B">Enter card details</Text>
    <Frame flex="col" gap={12}>
      <Frame h={44} p={[0,16]} rounded={8} stroke="#E2E8F0">
        <Text size={14} fill="#94A3B8">Card number</Text>
      </Frame>
      <Frame flex="row" gap={12}>
        <Frame h={44} p={[0,16]} rounded={8} stroke="#E2E8F0" grow={1}>
          <Text size={14} fill="#94A3B8">MM/YY</Text>
        </Frame>
        <Frame h={44} p={[0,16]} rounded={8} stroke="#E2E8F0" grow={1}>
          <Text size={14} fill="#94A3B8">CVC</Text>
        </Frame>
      </Frame>
    </Frame>
  </Frame>
</Frame>
```

## Checkboxes and Radios

```jsx
// Checkbox
<Frame flex="row" gap={12} align="center">
  <Frame w={20} h={20} rounded={4} stroke="#CBD5E1" align="center" justify="center">
    <Frame w={12} h={12} rounded={2} bg="#3B82F6" />
  </Frame>
  <Text size={14}>I agree to the terms</Text>
</Frame>

// Radio Group
<Frame flex="col" gap={12}>
  <Text size={14} weight="500">Select option</Text>
  <Frame flex="row" gap={12} align="center">
    <Frame w={20} h={20} rounded={10} stroke="#3B82F6" align="center" justify="center">
      <Frame w={10} h={10} rounded={5} bg="#3B82F6" />
    </Frame>
    <Text size={14}>Option A</Text>
  </Frame>
  <Frame flex="row" gap={12} align="center">
    <Frame w={20} h={20} rounded={10} stroke="#CBD5E1" align="center" justify="center" />
    <Text size={14}>Option B</Text>
  </Frame>
</Frame>
```

## Rules

- Phone mockup: ONE frame, width 260-300, height 520-580, cornerRadius 32
- NEVER use ellipse for decorative shapes
- NEVER use emoji as icons