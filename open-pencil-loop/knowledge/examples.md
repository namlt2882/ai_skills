---
name: examples
description: Reference examples for common UI components using JSX format (v2)
phase: [generation]
trigger:
  keywords: [example, sample, show me, how to, 示例, 样例, 怎么, component, jsx, code]
priority: 50
budget: 1500
category: knowledge
---

# UI Component Examples (JSX Format)

All examples use open-pencil v2 JSX syntax. Node types: `Frame`, `Text`, `Rectangle`, `Ellipse`, `Path`, `Image`.

## Button Variants

### Primary Button
```jsx
<Frame role="button" bg="#3B82F6" px={24} py={12} rounded={8}>
  <Text color="#FFF" size={16} weight="semibold">Get Started</Text>
</Frame>
```

### Button with Icon
```jsx
<Frame role="button" bg="#3B82F6" flex="row" gap={8} align="center" px={24} py={12} rounded={8}>
  <Text color="#FFF" size={16} weight="semibold">Continue</Text>
  <Path name="ArrowRightIcon" w={16} h={16} fill="#FFF" />
</Frame>
```

### Secondary Button (Outline)
```jsx
<Frame role="button" bg="transparent" border="1px solid #E5E7EB" px={24} py={12} rounded={8}>
  <Text color="#374151" size={16} weight="semibold">Cancel</Text>
</Frame>
```

### Icon Button
```jsx
<Frame role="button" bg="#F3F4F6" w={40} h={40} rounded={8} align="center" justify="center">
  <Path name="PlusIcon" w={20} h={20} fill="#374151" />
</Frame>
```

## Cards

### Basic Card
```jsx
<Frame role="card" w={320} h={200} bg="#FFF" rounded={12} p={24} shadow="md">
  <Text size={20} weight="bold" color="#111827">Card Title</Text>
  <Text size={16} color="#6B7280" mt={8}>Card description goes here.</Text>
</Frame>
```

### Feature Card with Icon
```jsx
<Frame role="feature-card" w={360} bg="#FFF" rounded={16} p={32} shadow="md">
  <Frame w={56} h={56} bg="#DBEAFE" rounded={12} align="center" justify="center">
    <Path name="ZapIcon" w={28} h={28} fill="#3B82F6" />
  </Frame>
  <Text size={20} weight="bold" color="#111827" mt={20}>Fast Performance</Text>
  <Text size={16} color="#6B7280" mt={8} line={1.5}>Optimized for speed with minimal overhead.</Text>
</Frame>
```

### Image Card
```jsx
<Frame role="image-card" w={340} bg="#FFF" rounded={16} overflow="hidden" shadow="md">
  <Image src="https://picsum.photos/340/200" w={340} h={200} />
  <Frame p={20}>
    <Text size={18} weight="semibold" color="#111827">Card Title</Text>
    <Text size={14} color="#6B7280" mt={4}>Subtitle text here</Text>
  </Frame>
</Frame>
```

### Stat Card
```jsx
<Frame role="stat-card" w={240} bg="#FFF" rounded={12} p={24} shadow="sm">
  <Text size={14} color="#6B7280" weight="medium">Total Revenue</Text>
  <Text size={36} weight="bold" color="#111827" mt={8}>$48.2K</Text>
  <Frame flex="row" gap={4} align="center" mt={8}>
    <Path name="TrendingUpIcon" w={16} h={16} fill="#10B981" />
    <Text size={14} color="#10B981" weight="medium">+12.5%</Text>
  </Frame>
</Frame>
```

## Form Elements

### Input Field
```jsx
<Frame role="input-field" w="fill" h={48} bg="#F9FAFB" rounded={8} px={16} flex="row" align="center">
  <Text color="#9CA3AF" size={16}>Enter your email...</Text>
</Frame>
```

### Input with Icon
```jsx
<Frame role="input-field" w="fill" h={48} bg="#F9FAFB" rounded={8} px={16} flex="row" gap={12} align="center">
  <Path name="MailIcon" w={20} h={20} fill="#9CA3AF" />
  <Text color="#9CA3AF" size={16}>Email address</Text>
</Frame>
```

### Search Input
```jsx
<Frame role="input-field" w={320} h={48} bg="#F3F4F6" rounded={24} px={20} flex="row" gap={12} align="center">
  <Path name="SearchIcon" w={20} h={20} fill="#9CA3AF" />
  <Text color="#9CA3AF" size={16}>Search...</Text>
</Frame>
```

### Label + Input Group
```jsx
<Frame flex="col" gap={8} w="fill">
  <Text size={14} weight="medium" color="#374151">Email Address</Text>
  <Frame role="input-field" w="fill" h={48} bg="#F9FAFB" border="1px solid #E5E7EB" rounded={8} px={16} flex="row" align="center">
    <Text color="#111827" size={16}>user@example.com</Text>
  </Frame>
</Frame>
```

## Navigation

### Nav Item
```jsx
<Frame role="nav-item" px={16} py={8} rounded={6}>
  <Text size={16} weight="medium" color="#374151">Products</Text>
</Frame>
```

### Active Nav Item
```jsx
<Frame role="nav-item" px={16} py={8} rounded={6} bg="#EFF6FF">
  <Text size={16} weight="medium" color="#3B82F6">Dashboard</Text>
</Frame>
```

### Logo
```jsx
<Frame flex="row" gap={10} align="center">
  <Frame w={32} h={32} bg="#3B82F6" rounded={8} />
  <Text size={20} weight="bold" color="#111827">Brand</Text>
</Frame>
```

## Layout Components

### Section
```jsx
<Frame role="section" w="fill" bg="#F8FAFC" p={80} flex="col" align="center">
  <Text role="heading-large" align="center">Section Title</Text>
  <Text role="body" align="center" mt={16} maxW={600}>Section description goes here.</Text>
</Frame>
```

### Container
```jsx
<Frame w="fill" maxW={1200} mx="auto" px={24}>
  {/* Content */}
</Frame>
```

### Row Layout
```jsx
<Frame flex="row" gap={24} w="fill" align="center">
  <Frame w={200} h={120} bg="#DBEAFE" rounded={12} />
  <Frame w={200} h={120} bg="#DBEAFE" rounded={12} />
  <Frame w={200} h={120} bg="#DBEAFE" rounded={12} />
</Frame>
```

### Grid Layout (3 columns)
```jsx
<Frame flex="row" gap={24} w="fill" wrap="wrap">
  <Frame w={360} h={240} bg="#FFF" rounded={12} shadow="md" />
  <Frame w={360} h={240} bg="#FFF" rounded={12} shadow="md" />
  <Frame w={360} h={240} bg="#FFF" rounded={12} shadow="md" />
</Frame>
```

## Hero Section

```jsx
<Frame role="hero" w="fill" minH={600} bg="#F8FAFC" flex="col" align="center" justify="center" p={80}>
  <Text size={56} weight="bold" color="#111827" align="center" maxW={800} line={1.1}>
    Build Better Products
  </Text>
  <Text size={20} color="#6B7280" align="center" mt={24} maxW={600} line={1.5}>
    Create stunning designs with our powerful tools and intuitive interface.
  </Text>
  <Frame flex="row" gap={16} mt={40}>
    <Frame role="button" bg="#3B82F6" px={32} py={16} rounded={8}>
      <Text color="#FFF" size={18} weight="semibold">Get Started</Text>
    </Frame>
    <Frame role="button" bg="transparent" border="1px solid #E5E7EB" px={32} py={16} rounded={8}>
      <Text color="#374151" size={18} weight="semibold">Learn More</Text>
    </Frame>
  </Frame>
</Frame>
```

## Footer

```jsx
<Frame role="footer" w="fill" bg="#111827" p={64} flex="col" align="center">
  <Text size={24} weight="bold" color="#FFF">Brand</Text>
  <Text size={16} color="#9CA3AF" mt={16} align="center">Building the future of design.</Text>
  <Frame flex="row" gap={32} mt={32}>
    <Text size={14} color="#9CA3AF">Products</Text>
    <Text size={14} color="#9CA3AF">Company</Text>
    <Text size={14} color="#9CA3AF">Resources</Text>
    <Text size={14} color="#9CA3AF">Support</Text>
  </Frame>
  <Text size={14} color="#6B7280" mt={48}>2024 Brand. All rights reserved.</Text>
</Frame>
```

## Badge

```jsx
<Frame flex="row" gap={6} align="center" px={10} py={4} bg="#DBEAFE" rounded={12}>
  <Frame w={6} h={6} bg="#3B82F6" rounded="full" />
  <Text size={12} weight="medium" color="#3B82F6">Active</Text>
</Frame>
```

## Avatar

```jsx
<Frame role="avatar" w={40} h={40} rounded="full" bg="#3B82F6" align="center" justify="center">
  <Text size={16} weight="semibold" color="#FFF">JD</Text>
</Frame>
```

## Divider

```jsx
<Frame w="fill" h={1} bg="#E5E7EB" my={32} />
```

## Empty State

```jsx
<Frame w="fill" h={400} flex="col" align="center" justify="center">
  <Path name="InboxIcon" w={64} h={64} fill="#D1D5DB" />
  <Text size={20} weight="semibold" color="#374151" mt={24}>No items yet</Text>
  <Text size={16} color="#9CA3AF" mt={8}>Create your first item to get started.</Text>
  <Frame role="button" bg="#3B82F6" px={24} py={12} rounded={8} mt={24}>
    <Text color="#FFF" size={16} weight="semibold">Create Item</Text>
  </Frame>
</Frame>
```
