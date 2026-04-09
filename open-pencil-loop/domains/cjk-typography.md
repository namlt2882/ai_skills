---
name: cjk-typography
description: CJK (Chinese/Japanese/Korean) typography rules
phase: [generation]
trigger:
  keywords:
    - "/[\\u4e00-\\u9fff\\u3040-\\u309f\\u30a0-\\u30ff\\uac00-\\ud7af]/"
priority: 25
budget: 500
category: domain
---

# CJK Typography Rules

## Fonts
- Headings: "Noto Sans SC" (Chinese) / "Noto Sans JP" / "Noto Sans KR"
- Body: "Inter" or "Noto Sans SC"
- NEVER use "Space Grotesk"/"Manrope" for CJK headings

## Typography
- CJK lineHeight: headings 1.3-1.4, body 1.6-1.8
- letterSpacing: 0, NEVER negative for CJK

JSX Example:
```jsx
{/* Chinese Landing Page - Proper Typography */}
<Frame w={1200} flex="col" p={[80,80]} gap={32} align="center">
  {/* Heading with CJK font */}
  <Text size={48} weight="bold" align="center" font="Noto Sans SC" lineHeight={1.3} letterSpacing={0}>
    构建更好的产品
  </Text>
  
  {/* Body text */}
  <Text size={18} fill="#64748B" align="center" font="Noto Sans SC" lineHeight={1.7} letterSpacing={0}>
    现代团队的平台解决方案
  </Text>
  
  {/* CTA Button - Chinese */}
  <Frame bg="#3B82F6" p={[16,40]} rounded={8}>
    <Text size={16} fill="#FFF" font="Noto Sans SC" letterSpacing={0}>
      免费试用
    </Text>
  </Frame>
</Frame>
```

## CJK Buttons
- Each character is approximately fontSize wide
- Container width >= (charCount x fontSize) + padding

JSX Example:
```jsx
{/* CJK Button sizing */}
<Frame flex="row" gap={16}>
  {/* 2 characters @ 16px + 32px padding each side */}
  <Frame h={48} p={[12,32]} rounded={8} bg="#3B82F6" align="center" justify="center">
    <Text size={16} fill="#FFF" font="Noto Sans SC">登录</Text>
  </Frame>
  
  {/* 4 characters @ 16px + 32px padding */}
  <Frame h={48} p={[12,32]} rounded={8} stroke="#E2E8F0" align="center" justify="center">
    <Text size={16} font="Noto Sans SC">了解更多</Text>
  </Frame>
  
  {/* 6 characters @ 14px + 24px padding */}
  <Frame h={44} p={[12,24]} rounded={8} bg="#000" align="center" justify="center">
    <Text size={14} fill="#FFF" font="Noto Sans SC">立即开始使用</Text>
  </Frame>
</Frame>
```

## Mixed CJK + English
JSX Example:
```jsx
<Frame w={1200} flex="col" p={[60,60]} gap={24}>
  {/* Mixed content */}
  <Text size={36} weight="bold" font="Noto Sans SC" lineHeight={1.3}>
    欢迎使用 ProductName
  </Text>
  
  <Text size={16} fill="#64748B" font="Noto Sans SC" lineHeight={1.7}>
    ProductName 是一个现代化的团队协作平台，
    帮助您的团队更高效地工作。
  </Text>
  
  {/* Feature cards with CJK */}
  <Frame flex="row" gap={24}>
    <Frame flex="col" p={24} gap={12} rounded={12} bg="#F8FAFC" grow={1}>
      <Frame w={40} h={40} rounded={8} bg="#EEF2FF" />
      <Text size={18} weight="600" font="Noto Sans SC">快速设置</Text>
      <Text size={14} fill="#64748B" font="Noto Sans SC" lineHeight={1.6}>
        几分钟内即可开始使用
      </Text>
    </Frame>
    
    <Frame flex="col" p={24} gap={12} rounded={12} bg="#F8FAFC" grow={1}>
      <Frame w={40} h={40} rounded={8} bg="#ECFDF5" />
      <Text size={18} weight="600" font="Noto Sans SC">安全可靠</Text>
      <Text size={14} fill="#64748B" font="Noto Sans SC" lineHeight={1.6}>
        企业级安全保障
      </Text>
    </Frame>
  </Frame>
</Frame>
```

## Japanese Typography
JSX Example:
```jsx
<Frame w={1200} flex="col" p={[80,80]} gap={32} align="center">
  <Text size={42} weight="bold" align="center" font="Noto Sans JP" lineHeight={1.3}>
    最高の製品を作る
  </Text>
  <Text size={16} fill="#64748B" align="center" font="Noto Sans JP" lineHeight={1.7}>
    モダンなチームのためのプラットフォーム
  </Text>
  <Frame bg="#3B82F6" p={[16,40]} rounded={8}>
    <Text size={16} fill="#FFF" font="Noto Sans JP">無料で試す</Text>
  </Frame>
</Frame>
```

## Korean Typography
JSX Example:
```jsx
<Frame w={1200} flex="col" p={[80,80]} gap={32} align="center">
  <Text size={42} weight="bold" align="center" font="Noto Sans KR" lineHeight={1.3}>
    더 나은 제품 만들기
  </Text>
  <Text size={16} fill="#64748B" align="center" font="Noto Sans KR" lineHeight={1.7}>
    현대 팀을 위한 플랫폼
  </Text>
  <Frame bg="#3B82F6" p={[16,40]} rounded={8}>
    <Text size={16} fill="#FFF" font="Noto Sans KR">무료로 시작</Text>
  </Frame>
</Frame>
```

## Detection
- Detect CJK from user request language
- Use CJK fonts for ALL text nodes when CJK is detected
