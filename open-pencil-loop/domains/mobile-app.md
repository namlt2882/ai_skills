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

JSX Example:
```jsx
<Frame w={375} h={44} flex="row" bg="#FFF" p={[0,16]} justify="space-between" align="center">
  <Text size={14} weight="600">9:41</Text>
  <Frame flex="row" gap={4}>
    <Frame w={16} h={16} bg="#000" />
    <Frame w={16} h={16} bg="#000" />
    <Frame w={24} h={16} rounded={4} bg="#000" />
  </Frame>
</Frame>
```

## Header
- height=56-64, padding=[0,16], layout="horizontal"
- justifyContent="space_between", alignItems="center"

JSX Example:
```jsx
<Frame w={375} h={56} flex="row" bg="#FFF" p={[0,16]} justify="space-between" align="center">
  <Frame w={40} h={40} rounded={20} bg="#F1F5F9" />
  <Text size={17} weight="600">Home</Text>
  <Frame w={40} h={40} rounded={20} bg="#F1F5F9" />
</Frame>
```

## Content Area
- padding=[0,16] or [16,16], gap=16-20
- layout="vertical", width="fill_container"

JSX Example:
```jsx
<Frame w={375} flex="col" p={16} gap={20}>
  {/* Search Bar */}
  <Frame w="auto" h={44} flex="row" bg="#F1F5F9" rounded={10} p={[0,12]} align="center">
    <Frame w={20} h={20} bg="#94A3B8" rounded={4} />
    <Text size={16} fill="#94A3B8" ml={8}>Search...</Text>
  </Frame>
  
  {/* Featured Card */}
  <Frame w="auto" h={180} rounded={16} bg="#3B82F6" p={20} flex="col" justify="flex-end">
    <Text size={20} fill="#FFF" weight="bold">Featured</Text>
    <Text size={14} fill="#FFF" opacity={0.8}>Discover new content</Text>
  </Frame>
  
  {/* Quick Actions */}
  <Frame flex="row" gap={12}>
    <Frame flex="col" grow={1} p={16} rounded={12} bg="#F8FAFC" align="center" gap={8}>
      <Frame w={40} h={40} rounded={20} bg="#EEF2FF" />
      <Text size={12}>Action 1</Text>
    </Frame>
    <Frame flex="col" grow={1} p={16} rounded={12} bg="#F8FAFC" align="center" gap={8}>
      <Frame w={40} h={40} rounded={20} bg="#ECFDF5" />
      <Text size={12}>Action 2</Text>
    </Frame>
    <Frame flex="col" grow={1} p={16} rounded={12} bg="#F8FAFC" align="center" gap={8}>
      <Frame w={40} h={40} rounded={20} bg="#FEF3C7" />
      <Text size={12}>Action 3</Text>
    </Frame>
    <Frame flex="col" grow={1} p={16} rounded={12} bg="#F8FAFC" align="center" gap={8}>
      <Frame w={40} h={40} rounded={20} bg="#FEE2E2" />
      <Text size={12}>Action 4</Text>
    </Frame>
  </Frame>
</Frame>
```

## Tab Bar (bottom navigation)
- height=80-84 (includes safe area)
- layout="horizontal", justifyContent="space_around"

JSX Example:
```jsx
<Frame w={375} h={84} flex="row" bg="#FFF" pt={8} pb={28} justify="space-around" align="flex-start" strokeTop="#E2E8F0">
  <Frame flex="col" gap={4} align="center">
    <Frame w={24} h={24} rounded={4} bg="#3B82F6" />
    <Text size={10} fill="#3B82F6">Home</Text>
  </Frame>
  <Frame flex="col" gap={4} align="center">
    <Frame w={24} h={24} rounded={4} bg="#94A3B8" />
    <Text size={10} fill="#94A3B8">Search</Text>
  </Frame>
  <Frame flex="col" gap={4} align="center">
    <Frame w={24} h={24} rounded={4} bg="#94A3B8" />
    <Text size={10} fill="#94A3B8">Profile</Text>
  </Frame>
</Frame>
```

## Form Screens
- All inputs width="fill_container", height=48, gap=16
- Primary button width="fill_container", height=48

JSX Example:
```jsx
<Frame w={375} flex="col" p={24} gap={24}>
  <Text size={28} weight="bold">Sign In</Text>
  
  <Frame flex="col" gap={16}>
    <Frame flex="col" gap={8}>
      <Text size={14} weight="500">Email</Text>
      <Frame h={48} p={[0,16]} rounded={8} stroke="#E2E8F0" align="center">
        <Text size={16} fill="#94A3B8">Enter your email</Text>
      </Frame>
    </Frame>
    
    <Frame flex="col" gap={8}>
      <Text size={14} weight="500">Password</Text>
      <Frame h={48} p={[0,16]} rounded={8} stroke="#E2E8F0" align="center">
        <Text size={16} fill="#94A3B8">Enter your password</Text>
      </Frame>
    </Frame>
  </Frame>
  
  <Frame h={48} rounded={8} bg="#3B82F6" align="center" justify="center">
    <Text size={16} fill="#FFF" weight="600">Sign In</Text>
  </Frame>
  
  <Text size={14} fill="#3B82F6" align="center">Forgot password?</Text>
</Frame>
```

## Spacing
- Touch targets: minimum 44x44px
- Safe area bottom: 28px padding
