---
name: icon-catalog
description: Lucide icon names and usage rules for open-pencil v2
phase: [generation]
trigger:
  keywords: [icon, iconography, symbol, arrow, search, menu, lucide, icon]
priority: 20
budget: 1000
category: knowledge
---

# Icon Usage

## Icon Types

open-pencil uses Lucide icons via path nodes. Icons are rendered as SVG paths with automatic name resolution.

### Path Icons (v2 Standard)

Use `type="path"` with Lucide icon names (PascalCase + "Icon" suffix):

```jsx
<Path name="SearchIcon" w={24} h={24} fill="#333" />
<Path name="ArrowRightIcon" w={20} h={20} />
```

## Lucide Icon Names

### Navigation
| Icon | Name | Common Use |
|------|------|------------|
| Home | `HomeIcon` | Home link, dashboard |
| Menu | `MenuIcon` | Mobile menu toggle |
| X / Close | `XIcon` | Close, dismiss |
| Chevron Right | `ChevronRightIcon` | Expand, next |
| Chevron Left | `ChevronLeftIcon` | Back, previous |
| Chevron Down | `ChevronDownIcon` | Dropdown, expand |
| Chevron Up | `ChevronUpIcon` | Collapse |
| Arrow Right | `ArrowRightIcon` | CTA, external link |
| Arrow Left | `ArrowLeftIcon` | Back navigation |
| Arrow Up | `ArrowUpIcon` | Upload, scroll top |
| Arrow Down | `ArrowDownIcon` | Download, scroll |

### Actions
| Icon | Name | Common Use |
|------|------|------------|
| Search | `SearchIcon` | Search input, find |
| Plus | `PlusIcon` | Add, create new |
| Minus | `MinusIcon` | Remove, decrease |
| Edit / Pencil | `PencilIcon` | Edit action |
| Trash | `TrashIcon` | Delete, remove |
| Copy | `CopyIcon` | Duplicate |
| Check | `CheckIcon` | Confirm, done |
| Check Circle | `CheckCircleIcon` | Success state |
| Refresh | `RefreshCwIcon` | Reload, sync |
| Settings | `SettingsIcon` | Configuration |
| Filter | `FilterIcon` | Filter results |
| More | `MoreHorizontalIcon` | Additional options |
| More Vertical | `MoreVerticalIcon` | Menu actions |

### User & Social
| Icon | Name | Common Use |
|------|------|------------|
| User | `UserIcon` | Profile, account |
| Users | `UsersIcon` | Team, group |
| Heart | `HeartIcon` | Like, favorite |
| Star | `StarIcon` | Rating, bookmark |
| Bell | `BellIcon` | Notifications |
| Mail | `MailIcon` | Email, messages |
| Message | `MessageCircleIcon` | Chat, comments |
| Send | `SendIcon` | Submit message |
| Share | `ShareIcon` | Share content |
| Link | `LinkIcon` | URL, hyperlink |
| Lock | `LockIcon` | Private, secure |
| Unlock | `UnlockIcon` | Public, accessible |

### Media
| Icon | Name | Common Use |
|------|------|------------|
| Image | `ImageIcon` | Image placeholder |
| Camera | `CameraIcon` | Photo, capture |
| Play | `PlayIcon` | Video play |
| Pause | `PauseIcon` | Video pause |
| Volume | `Volume2Icon` | Audio on |
| Mute | `VolumeXIcon` | Audio off |
| Download | `DownloadIcon` | Save file |
| Upload | `UploadIcon` | Send file |
| File | `FileIcon` | Document |
| Folder | `FolderIcon` | Directory |

### Status & Feedback
| Icon | Name | Common Use |
|------|------|------------|
| Info | `InfoIcon` | Information |
| Alert Circle | `AlertCircleIcon` | Warning |
| Alert Triangle | `AlertTriangleIcon` | Error, caution |
| Help | `HelpCircleIcon` | Support, FAQ |
| Eye | `EyeIcon` | View, visible |
| Eye Off | `EyeOffIcon` | Hidden, private |
| Loader | `Loader2Icon` | Loading spinner |

### Commerce
| Icon | Name | Common Use |
|------|------|------------|
| Shopping Cart | `ShoppingCartIcon` | Cart, purchase |
| Credit Card | `CreditCardIcon` | Payment |
| Dollar | `DollarSignIcon` | Money, price |
| Tag | `TagIcon` | Label, pricing |
| Gift | `GiftIcon` | Promotion |
| Truck | `TruckIcon` | Shipping |

### Time
| Icon | Name | Common Use |
|------|------|------------|
| Calendar | `CalendarIcon` | Date picker |
| Clock | `ClockIcon` | Time, history |
| Timer | `TimerIcon` | Countdown |
| History | `HistoryIcon` | Recent activity |

### Layout
| Icon | Name | Common Use |
|------|------|------------|
| Grid | `GridIcon` | Grid view |
| List | `ListIcon` | List view |
| Layout | `LayoutIcon` | Dashboard |
| Columns | `ColumnsIcon` | Split view |
| Maximize | `MaximizeIcon` | Full screen |
| Minimize | `MinimizeIcon` | Exit full screen |

### Brand (Social)
| Icon | Name | Common Use |
|------|------|------------|
| Github | `GithubIcon` | GitHub link |
| Twitter | `TwitterIcon` | Twitter/X link |
| LinkedIn | `LinkedinIcon` | LinkedIn link |
| Instagram | `InstagramIcon` | Instagram link |
| Youtube | `YoutubeIcon` | YouTube link |
| Facebook | `FacebookIcon` | Facebook link |

## Icon Sizes

| Size | Use Case | Dimension |
|------|----------|-----------|
| xs | Inline text, badges | 14px |
| sm | Buttons, inputs | 16px |
| md | Navigation, cards | 20px |
| lg | Feature icons, CTAs | 24px |
| xl | Hero icons, empty states | 32px |
| 2xl | Illustrations | 48px |

## Usage Examples

```jsx
// Button with icon
<Frame role="button" bg="#3B82F6" px={24} py={12} rounded={8} flex="row" gap={8} align="center">
  <Text color="#FFF" weight="medium">Get Started</Text>
  <Path name="ArrowRightIcon" w={16} h={16} fill="#FFF" />
</Frame>

// Search input with icon
<Frame role="input-field" bg="#F9FAFB" flex="row" gap={12} align="center">
  <Path name="SearchIcon" w={20} h={20} fill="#6B7280" />
  <Text color="#6B7280">Search...</Text>
</Frame>

// Feature card with icon
<Frame role="feature-card" bg="#FFF">
  <Path name="ZapIcon" w={32} h={32} fill="#F59E0B" />
  <Text role="heading-small">Fast Performance</Text>
  <Text role="body">Lightning quick response times.</Text>
</Frame>
```

## Rules

1. **NEVER use emoji as icons**. Always use Lucide icons.
2. Icon names are PascalCase with "Icon" suffix (e.g., `SearchIcon`, not `search`)
3. Match icon size to context: buttons use 16px, navigation 20-24px
4. Keep icon colors consistent with text color in the same container
5. Use `flex="row"` and `gap` to align icons with text
