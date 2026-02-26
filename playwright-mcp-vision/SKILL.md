---
name: playwright-mcp-vision
description: Web scraping and automation using Playwright MCP with vision-based decision flow. Covers browser automation, vision model integration for understanding page content, parallel execution, antidetect browser support, resource control, language sensitivity, security sandboxing, profile management, and page indexing.
---

# Playwright MCP Vision — Web Scraping & Automation

Browser automation powered by Playwright MCP server with vision model integration for intelligent web scraping and automation tasks. Control Chrome, Firefox, or WebKit programmatically while leveraging AI vision models to understand and interact with web content.

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

- **Node.js** (v18 or higher) for running Playwright MCP
- **Playwright MCP Server**: `@playwright/mcp` package
- **Browser binaries**: Chromium, Firefox, or WebKit

### Required AI Models

Before using this skill, ensure access to at least one of the following vision-capable AI models:

#### OpenAI Vision Models

| Model | Provider Format | Strengths | Use Case |
|-------|----------------|-----------|----------|
| **GPT-5.2** | `openai/gpt-5.2` | Latest flagship, superior reasoning, multimodal | Complex page analysis, decision making |
| **GPT-4.1** | `openai/gpt-4.1` | High intelligence, multimodal, structured output | Production-grade scraping |
| **GPT-4o** | `openai/gpt-4o` | General purpose, good OCR, detailed analysis | Default choice for most tasks |
| **GPT-4o-mini** | `openai/gpt-4o-mini` | Fast, cost-effective, multimodal | Batch processing, cost-sensitive tasks |

#### Zhipu AI (z.ai) Vision Models

| Model | Provider Format | Strengths | Use Case |
|-------|----------------|-----------|----------|
| **GLM-4.6V** | `zai/glm-4.6v` | 106B parameters, SOTA vision, native tool calling | Complex visual reasoning, agent tasks |
| **GLM-4.6V-Flash** | `zai/glm-4.6v-flash` | 9B lightweight, fast, free to use | Local deployment, quick tasks |

#### Other Vision Models

| Model | Provider Format | Strengths | Use Case |
|-------|----------------|-----------|----------|
| **Claude 3.5 Sonnet** | `anthropic/claude-3-5-sonnet` | Excellent reasoning, nuanced understanding | Complex visual reasoning |
| **Gemini 2.0 Flash** | `google/gemini-2.0-flash` | Fast, multimodal | Real-time processing |

### API Requirements

- Valid API keys for chosen model providers
- Rate limit awareness and quota management
- Understanding of token/image pricing models

## Installation

### Install Playwright MCP

```bash
npm install -g @playwright/mcp
# Or
npx @playwright/mcp
```

### Install Browsers (first time)

```bash
npx playwright install chromium
npx playwright install firefox
npx playwright install webkit
```

### Start MCP Server

```bash
# Basic start
npx @playwright/mcp

# With options
npx @playwright/mcp --headless --browser chromium --viewport-size 1280x720
```

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. PAGE NAVIGATION                                      │
│     Navigate to target URL using browser_navigate       │
│     Wait for page load and dynamic content              │
├─────────────────────────────────────────────────────────┤
│  2. VISION ANALYSIS                                      │
│     Capture screenshot or page snapshot                 │
│     Send to vision model for understanding              │
│     Analyze page structure, elements, and content       │
├─────────────────────────────────────────────────────────┤
│  3. DECISION MAKING                                     │
│     Vision model identifies target elements             │
│     Determines next actions based on visual analysis    │
│     Handles dynamic layouts and variations              │
├─────────────────────────────────────────────────────────┤
│  4. ACTION EXECUTION                                     │
│     Execute browser actions (click, type, scroll)       │
│     Use selectors identified by vision model           │
│     Handle popups, modals, and overlays                 │
├─────────────────────────────────────────────────────────┤
│  5. DATA EXTRACTION                                     │
│     Extract structured data using browser_evaluate     │
│     Parse and format results                            │
│     Store or return extracted data                      │
├─────────────────────────────────────────────────────────┤
│  6. ITERATION (if needed)                               │
│     Repeat for multi-page workflows                    │
│     Handle pagination and navigation                    │
│     Process multiple URLs in parallel                   │
└─────────────────────────────────────────────────────────┘
```

## Vision-Based Decision Flow

### Page Understanding

Use vision models to understand page structure and identify interactive elements:

```typescript
interface PageAnalysis {
  layout: string
  interactiveElements: Array<{
    type: 'button' | 'link' | 'input' | 'dropdown' | 'checkbox'
    selector: string
    label: string
    position: { x: number; y: number }
    confidence: number
  }>
  contentSections: Array<{
    type: 'article' | 'list' | 'table' | 'form'
    selector: string
    description: string
  }>
  navigation: {
    menuItems: Array<{ label: string; selector: string }>
    breadcrumbs: Array<{ label: string; selector: string }>
  }
}

async function analyzePageWithVision(
  screenshot: Buffer,
  snapshot: string,
  model: string = 'openai/gpt-4o'
): Promise<PageAnalysis> {
  const prompt = `
    Analyze this web page screenshot and accessible snapshot.
    Identify:
    1. Page layout and structure
    2. All interactive elements (buttons, links, inputs, dropdowns, checkboxes)
    3. Content sections (articles, lists, tables, forms)
    4. Navigation elements (menu items, breadcrumbs)
    
    For each element, provide:
    - Type
    - CSS selector (best guess from snapshot)
    - Visible label/text
    - Position (approximate)
    - Confidence level (0-1)
    
    Return as JSON.
  `
  
  const response = await analyzeWithVisionModel(screenshot, prompt, model)
  return JSON.parse(response)
}
```

### Element Identification

Vision models help find elements when selectors are unreliable:

```typescript
async function findElementByVision(
  screenshot: Buffer,
  description: string,
  snapshot: string,
  model: string = 'openai/gpt-4o'
): Promise<{ selector: string; confidence: number }> {
  const prompt = `
    Find the element on this page that matches: "${description}"
    
    Use the accessible snapshot to identify the best CSS selector.
    Return the selector and your confidence (0-1).
    
    Format: {"selector": "css-selector", "confidence": 0.95}
  `
  
  const response = await analyzeWithVisionModel(screenshot, prompt, model)
  return JSON.parse(response)
}
```

### Action Planning

Plan multi-step workflows using vision understanding:

```typescript
interface ActionPlan {
  steps: Array<{
    action: 'navigate' | 'click' | 'type' | 'select' | 'scroll' | 'wait'
    selector?: string
    value?: string
    description: string
    expectedOutcome: string
  }>
}

async function planActionsWithVision(
  screenshot: Buffer,
  goal: string,
  snapshot: string,
  model: string = 'openai/gpt-5.2'
): Promise<ActionPlan> {
  const prompt = `
    Goal: ${goal}
    
    Analyze this page and create a step-by-step action plan to achieve the goal.
    Consider:
    - Current page state
    - Available interactive elements
    - Potential obstacles (modals, popups, required fields)
    - Navigation paths
    
    For each step, specify:
    - Action type
    - Target selector (if applicable)
    - Value to input (if applicable)
    - Description of what to do
    - Expected outcome
    
    Return as JSON.
  `
  
  const response = await analyzeWithVisionModel(screenshot, prompt, model)
  return JSON.parse(response)
}
```

## MCP Tools Reference

| Tool | Description | Vision Integration |
|------|-------------|-------------------|
| `browser_navigate` | Navigate to URL | Initial page load |
| `browser_click` | Click element by selector | Vision-identified selectors |
| `browser_type` | Type text into input | Form filling |
| `browser_select_option` | Select dropdown option | Form interaction |
| `browser_get_text` | Get text content | Data extraction |
| `browser_evaluate` | Execute JavaScript | Advanced extraction |
| `browser_snapshot` | Get accessible page snapshot | Vision model input |
| `browser_close` | Close browser context | Cleanup |
| `browser_choose_file` | Upload file | Form submission |
| `browser_press` | Press keyboard key | Keyboard shortcuts |
| `browser_screenshot` | Capture screenshot | Vision model input |

## Common Use Cases

### 1. Vision-Guided Data Scraping

```typescript
async function scrapeWithVision(
  url: string,
  dataRequirements: string[],
  model: string = 'openai/gpt-4o'
): Promise<Record<string, any>> {
  // Navigate to page
  await browser_navigate({ url })
  
  // Get page snapshot and screenshot
  const snapshot = await browser_snapshot()
  const screenshot = await browser_screenshot()
  
  // Analyze page with vision
  const prompt = `
    Extract the following data from this page:
    ${dataRequirements.map(r => `- ${r}`).join('\n')}
    
    Use the accessible snapshot to find selectors for each data point.
    Return as JSON with keys matching the requirements.
  `
  
  const analysis = await analyzeWithVisionModel(screenshot, prompt, model)
  const selectors = JSON.parse(analysis)
  
  // Extract data using identified selectors
  const result: Record<string, any> = {}
  for (const [key, selector] of Object.entries(selectors)) {
    result[key] = await browser_evaluate({
      script: `() => document.querySelector('${selector}')?.textContent?.trim()`
    })
  }
  
  return result
}
```

### 2. Form Automation with Vision

```typescript
async function fillFormWithVision(
  url: string,
  formData: Record<string, any>,
  model: string = 'openai/gpt-4o'
): Promise<void> {
  // Navigate to form
  await browser_navigate({ url })
  
  // Get page state
  const snapshot = await browser_snapshot()
  const screenshot = await browser_screenshot()
  
  // Analyze form structure
  const prompt = `
    Analyze this form and identify:
    1. All input fields with their labels
    2. Field types (text, email, password, select, checkbox, radio)
    3. Submit button selector
    4. Any validation requirements
    
    Map these field labels to the provided data:
    ${JSON.stringify(formData, null, 2)}
    
    Return as JSON with field selectors and values.
  `
  
  const analysis = await analyzeWithVisionModel(screenshot, prompt, model)
  const fieldMappings = JSON.parse(analysis)
  
  // Fill form fields
  for (const field of fieldMappings.fields) {
    if (field.type === 'select') {
      await browser_select_option({
        selector: field.selector,
        value: field.value
      })
    } else if (field.type === 'checkbox' || field.type === 'radio') {
      if (field.value) {
        await browser_click({ selector: field.selector })
      }
    } else {
      await browser_type({
        selector: field.selector,
        text: field.value
      })
    }
  }
  
  // Submit form
  await browser_click({ selector: fieldMappings.submitSelector })
}
```

### 3. Multi-Page Workflow Automation

```typescript
async function automateWorkflow(
  steps: Array<{
    url?: string
    action: string
    description: string
  }>,
  model: string = 'openai/gpt-5.2'
): Promise<void> {
  for (const step of steps) {
    // Navigate if URL provided
    if (step.url) {
      await browser_navigate({ url: step.url })
    }
    
    // Get current page state
    const snapshot = await browser_snapshot()
    const screenshot = await browser_screenshot()
    
    // Plan action with vision
    const prompt = `
      Current action: ${step.action}
      Description: ${step.description}
      
      Analyze this page and determine the best way to perform this action.
      Consider:
      - Available interactive elements
      - Current page state
      - Potential obstacles
      
      Return the action type, selector (if needed), and any value.
    `
    
    const analysis = await analyzeWithVisionModel(screenshot, prompt, model)
    const action = JSON.parse(analysis)
    
    // Execute action
    switch (action.type) {
      case 'click':
        await browser_click({ selector: action.selector })
        break
      case 'type':
        await browser_type({ selector: action.selector, text: action.value })
        break
      case 'select':
        await browser_select_option({ selector: action.selector, value: action.value })
        break
      case 'scroll':
        await browser_evaluate({ script: `() => window.scrollTo(0, ${action.position})` })
        break
      case 'wait':
        await new Promise(resolve => setTimeout(resolve, action.duration))
        break
    }
  }
}
```

## Parallel Execution

### Concurrent Page Processing

```typescript
async function scrapeMultiplePages(
  urls: string[],
  dataRequirements: string[],
  model: string = 'openai/gpt-4o',
  concurrency: number = 3
): Promise<Record<string, any>[]> {
  const results: Record<string, any>[] = []
  
  // Process URLs in batches
  for (let i = 0; i < urls.length; i += concurrency) {
    const batch = urls.slice(i, i + concurrency)
    
    const batchResults = await Promise.all(
      batch.map(url => scrapeWithVision(url, dataRequirements, model))
    )
    
    results.push(...batchResults)
    
    // Rate limiting delay between batches
    if (i + concurrency < urls.length) {
      await new Promise(resolve => setTimeout(resolve, 1000))
    }
  }
  
  return results
}
```

### Parallel Element Extraction

```typescript
async function extractMultipleElements(
  selectors: string[],
  model: string = 'openai/gpt-4o-mini'
): Promise<Record<string, string>> {
  const results: Record<string, string> = {}
  
  await Promise.all(
    selectors.map(async (selector) => {
      results[selector] = await browser_evaluate({
        script: `(sel) => document.querySelector(sel)?.textContent?.trim()`,
        args: [selector]
      })
    })
  )
  
  return results
}
```

## Antidetect Browser Support

### Browser Fingerprinting Evasion

```typescript
interface AntidetectConfig {
  userAgent?: string
  viewport?: { width: number; height: number }
  locale?: string
  timezone?: string
  permissions?: string[]
  webgl?: boolean
  canvas?: boolean
  webrtc?: boolean
}

async function setupAntidetectBrowser(config: AntidetectConfig): Promise<void> {
  // Set custom user agent
  if (config.userAgent) {
    await browser_evaluate({
      script: `(ua) => Object.defineProperty(navigator, 'userAgent', { value: ua, writable: false })`,
      args: [config.userAgent]
    })
  }
  
  // Set viewport
  if (config.viewport) {
    await browser_evaluate({
      script: `(w, h) => { window.innerWidth = w; window.innerHeight = h; }`,
      args: [config.viewport.width, config.viewport.height]
    })
  }
  
  // Set locale
  if (config.locale) {
    await browser_evaluate({
      script: `(loc) => Object.defineProperty(navigator, 'language', { value: loc })`,
      args: [config.locale]
    })
  }
  
  // Set timezone
  if (config.timezone) {
    await browser_evaluate({
      script: `(tz) => { 
        const originalDate = Date;
        Date = function(...args) {
          const date = new originalDate(...args);
          date.toLocaleString = function() {
            return originalDate.prototype.toLocaleString.call(this, 'en-US', { timeZone: tz });
          };
          return date;
        };
      }`,
      args: [config.timezone]
    })
  }
  
  // Disable WebGL
  if (config.webgl === false) {
    await browser_evaluate({
      script: `() => { 
        const getParameter = WebGLRenderingContext.prototype.getParameter;
        WebGLRenderingContext.prototype.getParameter = function(parameter) {
          if (parameter === 37445) return 'Intel Inc.';
          if (parameter === 37446) return 'Intel Iris OpenGL Engine';
          return getParameter.call(this, parameter);
        };
      }`
    })
  }
  
  // Disable Canvas fingerprinting
  if (config.canvas === false) {
    await browser_evaluate({
      script: `() => {
        const originalToDataURL = HTMLCanvasElement.prototype.toDataURL;
        HTMLCanvasElement.prototype.toDataURL = function() {
          const context = this.getContext('2d');
          const imageData = context.getImageData(0, 0, this.width, this.height);
          for (let i = 0; i < imageData.data.length; i += 4) {
            imageData.data[i] += Math.floor(Math.random() * 3) - 1;
            imageData.data[i + 1] += Math.floor(Math.random() * 3) - 1;
            imageData.data[i + 2] += Math.floor(Math.random() * 3) - 1;
          }
          context.putImageData(imageData, 0, 0);
          return originalToDataURL.apply(this, arguments);
        };
      }`
    })
  }
}
```

### Random User Agent Rotation

```typescript
const USER_AGENTS = [
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:121.0) Gecko/20100101 Firefox/121.0',
  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Safari/605.1.15'
]

function getRandomUserAgent(): string {
  return USER_AGENTS[Math.floor(Math.random() * USER_AGENTS.length)]
}

async function rotateUserAgent(): Promise<void> {
  const userAgent = getRandomUserAgent()
  await browser_evaluate({
    script: `(ua) => Object.defineProperty(navigator, 'userAgent', { value: ua, writable: false })`,
    args: [userAgent]
  })
}
```

## Resource Control

### Memory Management

```typescript
interface ResourceLimits {
  maxPages: number
  maxConcurrentRequests: number
  maxMemoryMB: number
  maxCpuPercent: number
}

class ResourceManager {
  private activePages = 0
  private activeRequests = 0
  
  constructor(private limits: ResourceLimits) {}
  
  async withPage<T>(fn: () => Promise<T>): Promise<T> {
    while (this.activePages >= this.limits.maxPages) {
      await new Promise(resolve => setTimeout(resolve, 100))
    }
    
    this.activePages++
    try {
      return await fn()
    } finally {
      this.activePages--
    }
  }
  
  async withRequest<T>(fn: () => Promise<T>): Promise<T> {
    while (this.activeRequests >= this.limits.maxConcurrentRequests) {
      await new Promise(resolve => setTimeout(resolve, 50))
    }
    
    this.activeRequests++
    try {
      return await fn()
    } finally {
      this.activeRequests--
    }
  }
}
```

### Request Throttling

```typescript
class RequestThrottler {
  private lastRequestTime = 0
  private requestCount = 0
  private requestTimes: number[] = []
  
  constructor(
    private minInterval: number = 1000,
    private maxRequestsPerMinute: number = 60
  ) {}
  
  async throttle(): Promise<void> {
    const now = Date.now()
    
    // Enforce minimum interval
    const timeSinceLastRequest = now - this.lastRequestTime
    if (timeSinceLastRequest < this.minInterval) {
      await new Promise(resolve => setTimeout(resolve, this.minInterval - timeSinceLastRequest))
    }
    
    // Enforce rate limit
    this.requestTimes = this.requestTimes.filter(t => now - t < 60000)
    if (this.requestTimes.length >= this.maxRequestsPerMinute) {
      const oldestRequest = this.requestTimes[0]
      const waitTime = 60000 - (now - oldestRequest)
      await new Promise(resolve => setTimeout(resolve, waitTime))
    }
    
    this.requestTimes.push(now)
    this.lastRequestTime = now
  }
}
```

## Language Sensitivity

### Multi-Language Page Handling

```typescript
interface LanguageConfig {
  defaultLanguage: string
  supportedLanguages: string[]
  autoDetect: boolean
}

async function detectPageLanguage(): Promise<string> {
  const html = await browser_evaluate({
    script: `() => document.documentElement.lang || document.body.getAttribute('lang') || 'en'`
  })
  
  return html || 'en'
}

async function adaptToLanguage(
  config: LanguageConfig,
  model: string = 'openai/gpt-4o'
): Promise<void> {
  if (!config.autoDetect) return
  
  const detectedLanguage = await detectPageLanguage()
  
  if (!config.supportedLanguages.includes(detectedLanguage)) {
    console.log(`Unsupported language: ${detectedLanguage}, using default: ${config.defaultLanguage}`)
    return
  }
  
  // Adjust prompts and selectors based on language
  const languagePrompts: Record<string, string> = {
    en: 'Analyze this page and identify...',
    es: 'Analiza esta página e identifica...',
    fr: 'Analysez cette page et identifiez...',
    de: 'Analysieren Sie diese Seite und identifizieren Sie...',
    zh: '分析此页面并识别...',
    ja: 'このページを分析して識別してください...',
    ko: '이 페이지를 분석하고 식별하세요...'
  }
  
  return languagePrompts[detectedLanguage] || languagePrompts[config.defaultLanguage]
}
```

## Security Sandboxing

### Isolated Browser Context

```typescript
interface SandboxConfig {
  blockDownloads: boolean
  blockPopups: boolean
  blockThirdPartyCookies: boolean
  allowedDomains: string[]
  blockedDomains: string[]
}

async function setupSandbox(config: SandboxConfig): Promise<void> {
  // Block downloads
  if (config.blockDownloads) {
    await browser_evaluate({
      script: `() => {
        const originalOpen = window.open;
        window.open = function() { return null; };
      }`
    })
  }
  
  // Block popups
  if (config.blockPopups) {
    await browser_evaluate({
      script: `() => {
        window.addEventListener('beforeunload', (e) => {
          e.preventDefault();
          e.returnValue = '';
        });
      }`
    })
  }
  
  // Block third-party cookies
  if (config.blockThirdPartyCookies) {
    await browser_evaluate({
      script: `() => {
        const originalCookie = document.cookie;
        Object.defineProperty(document, 'cookie', {
          get: () => originalCookie,
          set: () => {}
        });
      }`
    })
  }
  
  // Domain filtering
  await browser_evaluate({
    script: `(allowed, blocked) => {
      const originalFetch = window.fetch;
      window.fetch = function(url, options) {
        const urlObj = new URL(url, window.location.href);
        
        if (blocked.some(domain => urlObj.hostname.includes(domain))) {
          return Promise.reject(new Error('Blocked domain'));
        }
        
        if (allowed.length > 0 && !allowed.some(domain => urlObj.hostname.includes(domain))) {
          return Promise.reject(new Error('Domain not in allowlist'));
        }
        
        return originalFetch.apply(this, arguments);
      };
    }`,
    args: [config.allowedDomains, config.blockedDomains]
  })
}
```

## Profile Management

### Browser Profile Persistence

```typescript
interface BrowserProfile {
  name: string
  cookies: Array<{ name: string; value: string; domain: string }>
  localStorage: Record<string, string>
  sessionStorage: Record<string, string>
  userAgent?: string
  viewport?: { width: number; height: number }
}

async function saveProfile(name: string): Promise<BrowserProfile> {
  const cookies = await browser_evaluate({
    script: `() => document.cookie.split(';').map(c => {
      const [name, value] = c.trim().split('=');
      return { name, value, domain: window.location.hostname };
    })`
  })
  
  const localStorage = await browser_evaluate({
    script: `() => {
      const result = {};
      for (let i = 0; i < localStorage.length; i++) {
        const key = localStorage.key(i);
        result[key] = localStorage.getItem(key);
      }
      return result;
    }`
  })
  
  const sessionStorage = await browser_evaluate({
    script: `() => {
      const result = {};
      for (let i = 0; i < sessionStorage.length; i++) {
        const key = sessionStorage.key(i);
        result[key] = sessionStorage.getItem(key);
      }
      return result;
    }`
  })
  
  return {
    name,
    cookies,
    localStorage,
    sessionStorage
  }
}

async function loadProfile(profile: BrowserProfile): Promise<void> {
  // Restore cookies
  for (const cookie of profile.cookies) {
    await browser_evaluate({
      script: `(name, value, domain) => {
        document.cookie = `${name}=${value}; domain=${domain}; path=/`;
      }`,
      args: [cookie.name, cookie.value, cookie.domain]
    })
  }
  
  // Restore localStorage
  for (const [key, value] of Object.entries(profile.localStorage)) {
    await browser_evaluate({
      script: `(key, value) => localStorage.setItem(key, value)`,
      args: [key, value]
    })
  }
  
  // Restore sessionStorage
  for (const [key, value] of Object.entries(profile.sessionStorage)) {
    await browser_evaluate({
      script: `(key, value) => sessionStorage.setItem(key, value)`,
      args: [key, value]
    })
  }
}
```

## Page Indexing

### Content Indexing

```typescript
interface PageIndex {
  url: string
  title: string
  description: string
  keywords: string[]
  links: Array<{ text: string; url: string }>
  images: Array<{ src: string; alt: string }>
  headings: Array<{ level: number; text: string }>
  timestamp: number
}

async function indexPage(model: string = 'openai/gpt-4o'): Promise<PageIndex> {
  const url = await browser_evaluate({ script: `() => window.location.href` })
  const title = await browser_evaluate({ script: `() => document.title` })
  const description = await browser_evaluate({
    script: `() => document.querySelector('meta[name="description"]')?.content || ''`
  })
  
  // Get screenshot for vision analysis
  const screenshot = await browser_screenshot()
  
  // Use vision model to extract keywords and content
  const prompt = `
    Analyze this page and extract:
    1. Main keywords (5-10)
    2. All links with their text and URLs
    3. All images with their sources and alt text
    4. All headings with their levels and text
    
    Return as JSON.
  `
  
  const analysis = await analyzeWithVisionModel(screenshot, prompt, model)
  const { keywords, links, images, headings } = JSON.parse(analysis)
  
  return {
    url,
    title,
    description,
    keywords,
    links,
    images,
    headings,
    timestamp: Date.now()
  }
}
```

### Site Crawling

```typescript
async function crawlSite(
  startUrl: string,
  maxPages: number = 100,
  model: string = 'openai/gpt-4o'
): Promise<PageIndex[]> {
  const visited = new Set<string>()
  const queue: string[] = [startUrl]
  const indexes: PageIndex[] = []
  
  while (queue.length > 0 && indexes.length < maxPages) {
    const url = queue.shift()!
    
    if (visited.has(url)) continue
    visited.add(url)
    
    try {
      await browser_navigate({ url })
      
      const index = await indexPage(model)
      indexes.push(index)
      
      // Add new links to queue
      for (const link of index.links) {
        if (!visited.has(link.url) && isSameDomain(startUrl, link.url)) {
          queue.push(link.url)
        }
      }
    } catch (error) {
      console.error(`Failed to crawl ${url}:`, error)
    }
  }
  
  return indexes
}

function isSameDomain(url1: string, url2: string): boolean {
  const domain1 = new URL(url1).hostname
  const domain2 = new URL(url2).hostname
  return domain1 === domain2
}
```

## Configuration Options

```bash
# Security
--allowed-hosts example.com,api.example.com
--blocked-origins malicious.com
--ignore-https-errors

# Browser settings
--browser chromium|firefox|webkit
--headless
--viewport-size 1920x1080
--user-agent "Custom Agent"

# Timeouts
--timeout-action 10000      # Action timeout (ms)
--timeout-navigation 30000  # Navigation timeout (ms)

# Output
--output-dir ./playwright-output
--save-trace
--save-video 1280x720

# Antidetect
--disable-webgl
--disable-canvas
--disable-webrtc
```

## Best Practices

### Performance Optimization

1. **Use Vision Models Strategically**
   - Cache page analysis results
   - Use lighter models (GPT-4o-mini) for simple tasks
   - Batch multiple questions in single vision API call

2. **Parallel Processing**
   - Process multiple pages concurrently
   - Use resource limits to prevent overload
   - Implement proper rate limiting

3. **Smart Caching**
   ```typescript
   const analysisCache = new Map<string, PageAnalysis>()
   
   async function getCachedAnalysis(url: string): Promise<PageAnalysis> {
     if (analysisCache.has(url)) {
       return analysisCache.get(url)!
     }
     
     const analysis = await analyzePageWithVision(url)
     analysisCache.set(url, analysis)
     return analysis
   }
   ```

### Error Handling

```typescript
async function safeScrape(
  url: string,
  dataRequirements: string[],
  model: string = 'openai/gpt-4o',
  retries: number = 3
): Promise<Record<string, any> | null> {
  for (let attempt = 0; attempt < retries; attempt++) {
    try {
      return await scrapeWithVision(url, dataRequirements, model)
    } catch (error) {
      if (attempt === retries - 1) {
        console.error(`Failed to scrape ${url} after ${retries} attempts:`, error)
        return null
      }
      
      // Wait before retry
      await new Promise(resolve => setTimeout(resolve, 1000 * (attempt + 1)))
    }
  }
  
  return null
}
```

### Security Considerations

1. **Domain Whitelisting**
   - Only allow navigation to trusted domains
   - Block known malicious domains
   - Validate all URLs before navigation

2. **Input Sanitization**
   - Sanitize all user inputs before using in selectors
   - Use parameterized queries for JavaScript execution
   - Validate all extracted data

3. **Rate Limiting**
   - Respect website rate limits
   - Implement exponential backoff
   - Use random delays between requests

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| **Vision model timeout** | Large screenshots or slow model | Resize screenshots, use faster model |
| **Element not found** | Dynamic content or timing issues | Add wait conditions, retry with vision |
| **Anti-bot detection** | Suspicious behavior patterns | Use antidetect features, rotate user agents |
| **Memory leaks** | Too many open pages | Implement page limits, close unused pages |
| **Rate limiting** | Too many requests | Implement throttling, add delays |
| **Language issues** | Non-English content | Use language detection, adjust prompts |

### Debug Mode

```typescript
const DEBUG = process.env.DEBUG_PLAYWRIGHT_VISION === 'true'

async function debugScrape(
  url: string,
  dataRequirements: string[],
  model: string = 'openai/gpt-4o'
): Promise<Record<string, any>> {
  if (DEBUG) {
    console.log('[DEBUG] Starting scrape')
    console.log('- URL:', url)
    console.log('- Requirements:', dataRequirements)
    console.log('- Model:', model)
  }
  
  const startTime = Date.now()
  const result = await scrapeWithVision(url, dataRequirements, model)
  const duration = Date.now() - startTime
  
  if (DEBUG) {
    console.log('[DEBUG] Scrape complete')
    console.log('- Duration:', duration, 'ms')
    console.log('- Result:', result)
  }
  
  return result
}
```

## Quick Reference

### Vision Model Selection

| Task | Recommended Model | Reason |
|------|-------------------|--------|
| Simple page analysis | `openai/gpt-4o-mini` | Fast, cost-effective |
| Complex workflows | `openai/gpt-5.2` | Best reasoning |
| OCR-heavy tasks | `openai/gpt-4o` | Superior text recognition |
| Batch processing | `zai/glm-4.6v-flash` | Free option |
| Agent tasks | `zai/glm-4.6v` | Native tool calling |

### Command Line Examples

```bash
# Start with antidetect features
npx @playwright/mcp --headless --disable-webgl --disable-canvas

# Set default vision model
export DEFAULT_VISION_MODEL="openai/gpt-4o"

# Enable debug mode
export DEBUG_PLAYWRIGHT_VISION="true"

# Set rate limits
export MAX_REQUESTS_PER_MINUTE="60"
export MIN_REQUEST_INTERVAL="1000"
```

## Related Skills

- [`image-processing-chat`](../image-processing-chat/SKILL.md) — Vision model integration and image handling
- [`search-first`](../search-first/SKILL.md) — Research alternative scraping approaches
- [`api-design`](../api-design/SKILL.md) — Design scraping API endpoints
- [`coding-standards`](../coding-standards/SKILL.md) — Follow consistent coding patterns
