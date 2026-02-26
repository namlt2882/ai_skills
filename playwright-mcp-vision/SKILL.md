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

### System Requirements Verification

Before proceeding with installation, verify your system meets the requirements:

#### Check Node.js Installation

```bash
# Check if Node.js is installed
node --version

# Expected output: v18.x.x or higher
# If not installed or version is too old, see Installation section below
```

#### Check npm Installation

```bash
# Check if npm is installed (comes with Node.js)
npm --version

# Expected output: A version number (e.g., 9.x.x or higher)
```

#### Check Available Disk Space

Playwright browser binaries require approximately 300-500 MB of disk space:

```bash
# On macOS/Linux
df -h .

# On Windows
wmic logicaldisk get size,freespace,caption
```

#### Check Network Connectivity

You'll need internet access to download packages and browser binaries:

```bash
# Test connectivity to npm registry
curl -I https://registry.npmjs.org/

# Test connectivity to Playwright CDN
curl -I https://playwright.azureedge.net/
```

### Platform-Specific Requirements

#### macOS

- macOS 10.15 (Catalina) or later
- Xcode Command Line Tools (for some browser dependencies)

```bash
# Install Xcode Command Line Tools if needed
xcode-select --install
```

#### Linux

- Recent Linux distribution (Ubuntu 20.04+, Debian 11+, CentOS 8+, etc.)
- Required system libraries for browser dependencies

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y \
  libnss3 \
  libnspr4 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libxkbcommon0 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libasound2

# CentOS/RHEL
sudo yum install -y \
  nss \
  nspr \
  atk \
  at-spi2-atk \
  cups-libs \
  libdrm \
  libxkbcommon \
  libXcomposite \
  libXdamage \
  libXfixes \
  libXrandr \
  mesa-libgbm \
  alsa-lib
```

#### Windows

- Windows 10 or Windows 11
- Windows Build 17763 or later
- Visual C++ Redistributable (usually included)

```powershell
# Check Windows version
systeminfo | findstr /B /C:"OS Name" /C:"OS Version"

# Visual C++ Redistributable is typically pre-installed
# If needed, download from: https://aka.ms/vs/17/release/vc_redist.x64.exe
```

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

Follow these steps to install and configure Playwright MCP for web scraping and automation.

### Step 1: Install Node.js (if not already installed)

#### Check if Node.js is installed

```bash
# Check Node.js version
node --version

# If you see a version number (v18.x.x or higher), you can skip to Step 2
# If you see "command not found" or version < v18, proceed with installation
```

#### Install Node.js

**macOS (using Homebrew):**
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js 18 LTS or higher
brew install node@18
brew link node@18

# Verify installation
node --version
npm --version
```

**Linux (Ubuntu/Debian):**
```bash
# Using NodeSource repository
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verify installation
node --version
npm --version
```

**Linux (CentOS/RHEL):**
```bash
# Using NodeSource repository
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -
sudo yum install -y nodejs

# Verify installation
node --version
npm --version
```

**Windows:**
```powershell
# Download and run the official installer from:
# https://nodejs.org/en/download/

# Or using Chocolatey (if installed):
choco install nodejs-lts

# Verify installation in PowerShell or Command Prompt
node --version
npm --version
```

### Step 2: Install Playwright MCP Server

#### Check if Playwright MCP is already installed

```bash
# Check if globally installed
npm list -g @playwright/mcp

# If you see version information, it's already installed
# If you see "empty" or "UNMET DEPENDENCY", proceed with installation
```

#### Install Playwright MCP

```bash
# Install globally (recommended)
npm install -g @playwright/mcp

# Verify installation
npm list -g @playwright/mcp

# Alternative: Run without installation using npx
# npx @playwright/mcp
```

### Step 3: Install Browser Binaries

#### Check installed browsers

```bash
# Check which browsers are installed
npx playwright install --help

# List installed browsers
npx playwright install --dry-run chromium firefox webkit
```

#### Install browser binaries

```bash
# Install all browsers (recommended for full compatibility)
npx playwright install chromium firefox webkit

# Or install specific browsers only
npx playwright install chromium    # Chrome/Chromium
npx playwright install firefox     # Firefox
npx playwright install webkit      # Safari (macOS/Linux only)

# Install system dependencies for Linux (if needed)
npx playwright install-deps
```

**Note:** Browser binaries are approximately 300-500 MB total. This is a one-time download.

### Step 4: Verify Installation

```bash
# Test Playwright installation
npx playwright --version

# Test browser availability
npx playwright install --dry-run chromium firefox webkit

# Expected output should show browsers as "already installed"
```

### Step 5: Start MCP Server

#### Basic start

```bash
# Start with default settings
npx @playwright/mcp
```

#### Start with options

```bash
# Headless mode with specific browser and viewport
npx @playwright/mcp --headless --browser chromium --viewport-size 1280x720

# Headed mode (visible browser window)
npx @playwright/mcp --no-headless --browser firefox

# Custom user data directory (for persistent sessions)
npx @playwright/mcp --user-data-dir ./playwright-profile

# With proxy support
npx @playwright/mcp --proxy-server http://proxy.example.com:8080
```

#### Available options

| Option | Description | Default |
|--------|-------------|---------|
| `--headless` | Run in headless mode (no UI) | `true` |
| `--no-headless` | Run with visible browser window | - |
| `--browser` | Browser to use (chromium/firefox/webkit) | `chromium` |
| `--viewport-size` | Viewport dimensions (WIDTHxHEIGHT) | `1280x720` |
| `--user-data-dir` | Directory for browser profile data | - |
| `--proxy-server` | Proxy server URL | - |
| `--timeout` | Default timeout in milliseconds | `30000` |

### Platform-Specific Notes

#### macOS

- All browsers supported (Chromium, Firefox, WebKit)
- WebKit requires macOS 10.15 or later
- May need to grant browser permissions on first run

#### Linux

- Chromium and Firefox fully supported
- WebKit support varies by distribution
- May need additional system libraries (see Prerequisites)
- Running as root may require `--no-sandbox` flag

#### Windows

- Chromium and Firefox fully supported
- WebKit not available on Windows
- May need to run as Administrator for first-time setup
- Windows Defender may flag Playwright binaries (safe to allow)

### Troubleshooting Installation Issues

#### Node.js version too old

```bash
# Error: "Node.js version too old"
# Solution: Upgrade Node.js using the instructions in Step 1
```

#### Permission denied errors

```bash
# Error: "EACCES" or permission denied
# Solution: Fix npm permissions or use sudo (Linux/macOS)

# Fix npm permissions (recommended)
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

# Or use sudo (not recommended for security)
sudo npm install -g @playwright/mcp
```

#### Browser download failures

```bash
# Error: Browser download failed
# Solution: Check network connectivity and retry

# Set custom mirror if needed
export PLAYWRIGHT_DOWNLOAD_HOST=https://playwright.azureedge.net
npx playwright install chromium firefox webkit
```

#### Missing system dependencies (Linux)

```bash
# Error: "Error: Executable doesn't exist"
# Solution: Install system dependencies

npx playwright install-deps
```

## Setup Verification

After completing the installation, verify that everything is working correctly before proceeding with web scraping tasks.

### Quick Verification Checklist

```bash
# 1. Verify Node.js version (must be v18+)
node --version
# Expected: v18.x.x or higher

# 2. Verify npm version
npm --version
# Expected: A version number (e.g., 9.x.x or higher)

# 3. Verify Playwright MCP is installed
npm list -g @playwright/mcp
# Expected: @playwright/mcp@x.x.x

# 4. Verify Playwright version
npx playwright --version
# Expected: Version x.x.x

# 5. Verify browser binaries are installed
npx playwright install --dry-run chromium firefox webkit
# Expected: All browsers show "already installed"
```

### Test MCP Server Startup

```bash
# Start the MCP server in test mode
npx @playwright/mcp --help

# Expected: Help text with available options displayed
```

### Run Basic Browser Test

Create a simple test script to verify browser functionality:

```bash
# Create test script
cat > test-playwright.js << 'EOF'
const { chromium } = require('playwright');

(async () => {
  console.log('Launching browser...');
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  console.log('Navigating to example.com...');
  await page.goto('https://example.com');
  
  const title = await page.title();
  console.log('Page title:', title);
  
  await browser.close();
  console.log('Test completed successfully!');
})();
EOF

# Run the test
node test-playwright.js

# Expected output:
# Launching browser...
# Navigating to example.com...
# Page title: Example Domain
# Test completed successfully!

# Clean up test file
rm test-playwright.js
```

### Verify MCP Server Connection

```bash
# Start MCP server in background
npx @playwright/mcp --headless &
MCP_PID=$!

# Wait for server to start
sleep 3

# Check if process is running
ps -p $MCP_PID > /dev/null && echo "MCP Server is running" || echo "MCP Server failed to start"

# Stop the server
kill $MCP_PID 2>/dev/null
```

### Platform-Specific Verification

#### macOS

```bash
# Verify browser permissions
# On first run, you may need to grant screen recording and accessibility permissions
# Check System Preferences > Security & Privacy > Privacy

# Test WebKit browser (macOS only)
npx playwright install --dry-run webkit
```

#### Linux

```bash
# Verify system dependencies
ldd $(npx playwright which chromium) | grep "not found"

# If any libraries are missing, install them:
npx playwright install-deps

# Test with Xvfb (virtual display) if needed
Xvfb :99 -screen 0 1280x720x24 &
export DISPLAY=:99
npx playwright install --dry-run chromium
```

#### Windows

```bash
# Verify Windows Defender exclusions (if needed)
# Add Playwright cache directory to exclusions:
# %USERPROFILE%\AppData\Local\ms-playwright

# Test browser launch
npx playwright code --help
```

### Common Issues and Solutions

#### Issue: "command not found: node"

**Solution:** Node.js is not installed or not in PATH. Follow Step 1 in Installation section.

#### Issue: "EACCES: permission denied"

**Solution:** Fix npm permissions or use sudo (see Troubleshooting in Installation section).

#### Issue: "Browser not found"

**Solution:** Install browser binaries:
```bash
npx playwright install chromium firefox webkit
```

#### Issue: "Error: Executable doesn't exist at <path>"

**Solution:** Reinstall browsers and check system dependencies:
```bash
npx playwright install --force chromium
npx playwright install-deps  # Linux only
```

#### Issue: "Network error" during browser download

**Solution:** Check network connectivity and set mirror:
```bash
export PLAYWRIGHT_DOWNLOAD_HOST=https://playwright.azureedge.net
npx playwright install chromium firefox webkit
```

#### Issue: MCP server won't start

**Solution:** Check for port conflicts and verify installation:
```bash
# Check if port is in use
lsof -i :3000  # macOS/Linux
netstat -ano | findstr :3000  # Windows

# Reinstall MCP server
npm uninstall -g @playwright/mcp
npm install -g @playwright/mcp
```

### Performance Verification

```bash
# Test browser launch speed
time npx playwright code --help

# Test page load performance
cat > perf-test.js << 'EOF'
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();
  
  const start = Date.now();
  await page.goto('https://example.com');
  const loadTime = Date.now() - start;
  
  console.log(`Page loaded in ${loadTime}ms`);
  
  await browser.close();
})();
EOF

node perf-test.js
rm perf-test.js

# Expected: Page loads in < 2000ms on typical connection
```

### Final Verification

Run this comprehensive verification script:

```bash
cat > verify-setup.sh << 'EOF'
#!/bin/bash

echo "=== Playwright MCP Setup Verification ==="
echo ""

# Check Node.js
echo "1. Checking Node.js..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "   ✓ Node.js installed: $NODE_VERSION"
    if [[ $NODE_VERSION < "v18" ]]; then
        echo "   ✗ Node.js version too old (need v18+)"
        exit 1
    fi
else
    echo "   ✗ Node.js not found"
    exit 1
fi

# Check npm
echo "2. Checking npm..."
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "   ✓ npm installed: $NPM_VERSION"
else
    echo "   ✗ npm not found"
    exit 1
fi

# Check Playwright MCP
echo "3. Checking Playwright MCP..."
if npm list -g @playwright/mcp &> /dev/null; then
    MCP_VERSION=$(npm list -g @playwright/mcp | grep @playwright/mcp | awk '{print $2}')
    echo "   ✓ Playwright MCP installed: $MCP_VERSION"
else
    echo "   ✗ Playwright MCP not found"
    exit 1
fi

# Check Playwright
echo "4. Checking Playwright..."
if npx playwright --version &> /dev/null; then
    PW_VERSION=$(npx playwright --version)
    echo "   ✓ Playwright installed: $PW_VERSION"
else
    echo "   ✗ Playwright not found"
    exit 1
fi

# Check browsers
echo "5. Checking browser binaries..."
BROWSERS=("chromium" "firefox" "webkit")
ALL_INSTALLED=true
for browser in "${BROWSERS[@]}"; do
    if npx playwright install --dry-run $browser 2>&1 | grep -q "already installed"; then
        echo "   ✓ $browser installed"
    else
        echo "   ✗ $browser not installed"
        ALL_INSTALLED=false
    fi
done

if [ "$ALL_INSTALLED" = false ]; then
    echo ""
    echo "   Run: npx playwright install chromium firefox webkit"
    exit 1
fi

echo ""
echo "=== All checks passed! ==="
echo "You're ready to use Playwright MCP Vision."
EOF

chmod +x verify-setup.sh
./verify-setup.sh
rm verify-setup.sh
```

If all checks pass, your Playwright MCP Vision setup is complete and ready for use!

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
