---
name: pinchtab-web-automation
description: Web scraping and automation using PinchTab (HTTP + CLI) with vision-based decision flow. Covers browser control, token-efficient snapshots, parallel instances, profile management, resource control, and vision-assisted extraction.
---

# PinchTab Vision — Web Scraping & Automation

Browser automation powered by **PinchTab** (standalone HTTP server + CLI) with vision model integration for intelligent web scraping and automation tasks. Control Chrome programmatically while leveraging AI vision models to reason over PinchTab's structured snapshot/text output (DOM-like refs + extracted text). Screenshots are optional and only needed for cases where visual context is required beyond structured snapshot/text.

## When to Activate

- Scraping websites with dynamic or complex layouts
- Automating browser interactions that require visual understanding
- Extracting data from websites with inconsistent structures
- Performing form submissions and multi-step workflows
- Navigating websites with anti-bot protections
- Testing web applications with visual validation
- Crawling and indexing web pages for analysis
- Automating repetitive web-based tasks

## Prerequisites

### Required Software

- **PinchTab** standalone HTTP server (12MB Go binary) with CLI support
- **Chrome/Chromium** (PinchTab auto-detects or bundles browser on most platforms)
- **curl** or **jq** for HTTP API usage (optional but recommended)

### System Requirements Verification

Before proceeding, verify your system meets the requirements:

#### Check PinchTab Installation

```bash
# Check if pinchtab is installed
pinchtab --help

# Expected output: CLI help text
```

#### Check Chrome/Chromium Availability

```bash
# macOS
mdfind "kMDItemDisplayName == 'Google Chrome'" | head -n 1

# Linux
which google-chrome || which chromium || which chromium-browser

# Windows (PowerShell)
Get-Command chrome -ErrorAction SilentlyContinue
```

### AI Model Options

PinchTab works with **text-only** or **vision-capable** models. Vision is optional and only required when screenshots or visual cues are necessary beyond snapshot/text.

#### Text-Only Models (No vision required)

- Any strong text model that can follow structured prompts and return JSON.
- Use `pinchtab snap` + `pinchtab text` as the primary inputs.

#### Vision-Capable Models (Optional)

Use these when screenshots or visual context are needed.

##### OpenAI Vision Models

| Model | Provider Format | Strengths | Use Case |
|-------|----------------|-----------|----------|
| **GPT-5.2** | `openai/gpt-5.2` | Latest flagship, superior reasoning, multimodal | Complex page analysis, decision making |
| **GPT-4.1** | `openai/gpt-4.1` | High intelligence, multimodal, structured output | Production-grade scraping |
| **GPT-4o** | `openai/gpt-4o` | General purpose, good OCR, detailed analysis | Default choice for most tasks |
| **GPT-4o-mini** | `openai/gpt-4o-mini` | Fast, cost-effective, multimodal | Batch processing, cost-sensitive tasks |

##### Zhipu AI (z.ai) Vision Models

| Model | Provider Format | Strengths | Use Case |
|-------|----------------|-----------|----------|
| **GLM-4.6V** | `zai/glm-4.6v` | 106B parameters, SOTA vision, native tool calling | Complex visual reasoning, agent tasks |
| **GLM-4.6V-Flash** | `zai/glm-4.6v-flash` | 9B lightweight, fast, free to use | Local deployment, quick tasks |

##### Other Vision Models

| Model | Provider Format | Strengths | Use Case |
|-------|----------------|-----------|----------|
| **Claude 3.5 Sonnet** | `anthropic/claude-3-5-sonnet` | Excellent reasoning, nuanced understanding | Complex visual reasoning |
| **Gemini 2.0 Flash** | `google/gemini-2.0-flash` | Fast, multimodal | Real-time processing |

### API Requirements

- Valid API keys for chosen model providers
- Rate limit awareness and quota management
- Understanding of token/image pricing models

## Installation

Follow these steps to install and configure PinchTab for web scraping and automation.

### Step 1: Install PinchTab

**macOS / Linux:**
```bash
curl -fsSL https://pinchtab.com/install.sh | bash
```

**npm:**
```bash
npm install -g pinchtab
```

**Docker:**
```bash
docker run -d -p 9867:9867 pinchtab/pinchtab
```

### Step 2: Start PinchTab Server

```bash
# Start with default settings
pinchtab
```

### Step 3: Verify Installation

```bash
# Check CLI access
pinchtab --help

# Verify server is running
curl -s http://localhost:9867/health
```

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. PAGE NAVIGATION                                      │
│     Navigate to target URL using pinchtab nav            │
│     Wait for page load and dynamic content               │
├─────────────────────────────────────────────────────────┤
│  2. SNAPSHOT + TEXT                                      │
│     Use pinchtab snap for structure + refs               │
│     Use pinchtab text for token-efficient content        │
├─────────────────────────────────────────────────────────┤
│  3. VISION ANALYSIS                                      │
│     Send snapshot/text to vision model                   │
│     Identify interactive elements + targets              │
├─────────────────────────────────────────────────────────┤
│  4. ACTION EXECUTION                                     │
│     Execute pinchtab click/fill/press/scroll             │
│     Use stable element refs from snapshot                │
├─────────────────────────────────────────────────────────┤
│  5. DATA EXTRACTION                                      │
│     Extract with pinchtab text + optional snapshots      │
│     Parse structured data from model output              │
├─────────────────────────────────────────────────────────┤
│  6. ITERATION (if needed)                                │
│     Repeat for multi-page workflows                      │
│     Handle pagination and navigation                     │
│     Process multiple instances in parallel               │
└─────────────────────────────────────────────────────────┘
```

## PinchTab HTTP API Reference (Core)

| Endpoint | Purpose |
|----------|---------|
| `POST /instances` | Create instance (returns instance id) |
| `POST /instances/{id}/tabs` | Create a tab (returns tab id) |
| `POST /instances/{id}/tabs/{tabId}/navigate` | Navigate to URL |
| `GET /instances/{id}/tabs/{tabId}/snapshot?filter=interactive` | Snapshot with interactive refs |
| `GET /instances/{id}/tabs/{tabId}/text` | Extract page text |
| `POST /instances/{id}/tabs/{tabId}/action` | Perform click/fill/press/scroll |

## Vision-Based Decision Flow

### Page Understanding

Use PinchTab snapshot + text for vision and reasoning. These are structured (DOM-like) snapshots + extracted text that a vision model can reason over. Screenshots are optional and only needed when the structured snapshot/text is insufficient. Fetch them via HTTP to avoid local script wrappers:

```typescript
interface PageAnalysis {
  layout: string
  interactiveElements: Array<{
    ref: string
    type: 'button' | 'link' | 'input' | 'dropdown' | 'checkbox'
    label: string
    confidence: number
  }>
  contentSections: Array<{
    type: 'article' | 'list' | 'table' | 'form'
    description: string
  }>
}

async function analyzePageWithVision(
  snapshot: string,
  text: string,
  model: string = 'openai/gpt-4o'
): Promise<PageAnalysis> {
  const prompt = `
    Analyze this page snapshot and text.
    Identify:
    1. Page layout and structure
    2. All interactive elements (buttons, links, inputs, dropdowns, checkboxes)
    3. Content sections (articles, lists, tables, forms)

    For each element, provide:
    - Ref (from snapshot)
    - Type
    - Visible label/text
    - Confidence level (0-1)

    Return as JSON.
  `

  const response = await analyzeWithVisionModel({ snapshot, text }, prompt, model)
  return JSON.parse(response)
}
```

### Element Identification

```typescript
async function findElementByVision(
  snapshot: string,
  description: string,
  model: string = 'openai/gpt-4o'
): Promise<{ ref: string; confidence: number }> {
  const prompt = `
    Find the element that matches: "${description}"
    Return the PinchTab ref and confidence (0-1).
    Format: {"ref": "e5", "confidence": 0.95}
  `

  const response = await analyzeWithVisionModel({ snapshot }, prompt, model)
  return JSON.parse(response)
}
```

### Action Planning

```typescript
interface ActionPlan {
  steps: Array<{
    action: 'navigate' | 'click' | 'fill' | 'press' | 'scroll' | 'wait'
    ref?: string
    value?: string
    description: string
    expectedOutcome: string
  }>
}

async function planActionsWithVision(
  snapshot: string,
  goal: string,
  model: string = 'openai/gpt-5.2'
): Promise<ActionPlan> {
  const prompt = `
    Goal: ${goal}

    Analyze this page and create a step-by-step action plan to achieve the goal.
    Use PinchTab refs for interactive elements.
    Return as JSON.
  `

  const response = await analyzeWithVisionModel({ snapshot }, prompt, model)
  return JSON.parse(response)
}
```

## Common Use Cases

### 1. Vision-Guided Data Scraping

```bash
# Create instance
INSTANCE_ID=$(curl -s -X POST http://localhost:9867/instances \
  -d '{"profile":"work"}' | jq -r '.id')

# Create tab
TAB_ID=$(curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs" | jq -r '.id')

# Navigate
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://example.com"}'

# Snapshot + text
SNAPSHOT=$(curl -s "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/snapshot?filter=interactive")
TEXT=$(curl -s "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/text")
```

### 2. Form Automation with Vision

```bash
# Click, fill, and press actions via HTTP
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/action" \
  -d '{"kind":"click","ref":"e5"}'

curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/action" \
  -d '{"kind":"fill","ref":"e3","text":"user@example.com"}'

curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/action" \
  -d '{"kind":"press","ref":"e7","key":"Enter"}'
```

### 3. Multi-Page Workflow Automation

```bash
# Execute actions from a vision-generated plan
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/action" \
  -d '{"kind":"click","ref":"e12"}'

curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/action" \
  -d '{"kind":"scroll","y":900}'
```

## Parallel Execution

### Concurrent Page Processing

```bash
# Start one server per port (each server instance must be running)
pinchtab --port 9867
pinchtab --port 9868

# Create instances on each running server
curl -s -X POST http://localhost:9867/instances -d '{"profile":"alice"}' | jq -r '.id'
curl -s -X POST http://localhost:9868/instances -d '{"profile":"bob"}' | jq -r '.id'
```

## Profile Management

### Persistent Profiles

```bash
# Create a named profile
pinchtab instances create --profile=work

# Reuse profile across sessions
pinchtab instances create --profile=work
```

## Resource Control

### Instance Throttling

Use a simple concurrency gate in your HTTP client (queue requests or limit in-flight requests) instead of ad-hoc scripts.

## Anti-Detection Strategy

1. Add randomized delays between actions (jitter around 200–1200ms).
2. Prefer human-like scrolling (incremental scrolls with brief pauses) over large jumps.
3. Use persistent profiles for consistent cookies and local storage state.
4. Rotate user agents only if PinchTab supports it (confirm support before relying on UA rotation).

## Best Practices

### Token Efficiency

1. Prefer `pinchtab text` and `pinchtab snap` over screenshots.
2. Use snapshots with `-i` to get stable refs for interactions.
3. Cache snapshots when repeating similar tasks.

### Error Handling

Use HTTP-level retries with exponential backoff around PinchTab endpoints.

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| **PinchTab not found** | CLI not installed | Reinstall via curl or npm |
| **No Chrome detected** | Browser missing | Install Chrome/Chromium |
| **Snapshot missing refs** | Non-interactive elements | Use `pinchtab snap -i -c` |
| **Actions failing** | Stale refs | Refresh snapshot before action |
| **Rate limiting** | Too many requests | Add throttling and retries |

## Quick Reference

### HTTP Examples

```bash
# Start server
pinchtab

# Create instance + tab
INSTANCE_ID=$(curl -s -X POST http://localhost:9867/instances -d '{"profile":"work"}' | jq -r '.id')
TAB_ID=$(curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs" | jq -r '.id')

# Navigate and snapshot
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://example.com"}'
curl -s "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/snapshot?filter=interactive"

# Click by ref
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/action" \
  -d '{"kind":"click","ref":"e5"}'

# Extract token-efficient text
curl -s "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/text"
```

## Related Skills

- [`image-processing-chat`](../image-processing-chat/SKILL.md) — Vision model integration and image handling
- [`search-first`](../search-first/SKILL.md) — Research alternative scraping approaches
- [`api-design`](../api-design/SKILL.md) — Design scraping API endpoints
- [`coding-standards`](../coding-standards/SKILL.md) — Follow consistent coding patterns
