---
name: image-processing-chat
description: Efficient image processing workflow for chat-based AI interactions. Covers model selection, image extraction, preprocessing, and model switching strategies for openclaw. Includes all OpenAI and Zhipu AI (z.ai) vision models.
---

# Image Processing for Chat — Efficient Workflow

Systematizes image extraction, preprocessing, and AI model selection for chat-based interactions in openclaw.

## When to Activate

- Processing images embedded in chat messages
- Extracting images from markdown, HTML, or rich text
- Preparing images for AI vision model analysis
- Switching between different vision models based on requirements
- Optimizing image processing for performance and cost

## Prerequisites

### Required AI Models

Before using this skill, ensure access to at least one of the following vision-capable AI models:

#### OpenAI Vision Models

| Model | Provider | Strengths | Use Case |
|-------|----------|-----------|----------|
| **GPT-5.2** | OpenAI | Latest flagship, superior reasoning, multimodal | Cutting-edge analysis, complex tasks |
| **GPT-4.5 Preview** | OpenAI | Enhanced NLP, reduced hallucinations, multimodal | High-quality general analysis |
| **GPT-4.1** | OpenAI | High intelligence, multimodal, structured output | Production-grade applications |
| **GPT-4.1-mini** | OpenAI | Fast, cost-effective, multimodal | Batch processing, cost-sensitive tasks |
| **GPT-4.1-nano** | OpenAI | Ultra-fast, lightweight, multimodal | Real-time, edge computing |
| **GPT-4o** | OpenAI | General purpose, good OCR, detailed analysis | Default choice for most tasks |
| **GPT-4o-mini** | OpenAI | Fast, cost-effective, multimodal | Quick analysis, batch processing |
| **GPT-4o Audio** | OpenAI | Vision + audio processing | Multimodal with audio input |
| **GPT-4o Realtime** | OpenAI | Real-time vision + audio | Live video/voice interactions |
| **GPT-4o mini Realtime** | OpenAI | Fast real-time vision + audio | Low-latency live interactions |
| **GPT-4 Turbo with Vision** | OpenAI | High intelligence, legacy support | Existing integrations |
| **GPT-4 Vision Preview** | OpenAI | Legacy vision capabilities | Backward compatibility |

#### Zhipu AI (z.ai) Vision Models

| Model | Provider | Strengths | Use Case |
|-------|----------|-----------|----------|
| **GLM-4.6V** | Zhipu AI | 106B parameters, SOTA vision, native tool calling | Complex visual reasoning, agent tasks |
| **GLM-4.6V-Flash** | Zhipu AI | 9B lightweight, fast, free to use | Local deployment, quick tasks |
| **GLM-4.6V-Flash-WEB** | Zhipu AI | Web-optimized, dual-mode (web + API) | Browser-based applications |
| **GLM-4.5V** | Zhipu AI | Previous generation, reliable | Legacy support |

#### Other Vision Models

| Model | Provider | Strengths | Use Case |
|-------|----------|-----------|----------|
| **Claude 3.5 Sonnet** | Anthropic | Excellent reasoning, nuanced understanding | Complex visual reasoning |
| **Claude 3.5 Haiku** | Anthropic | Fast, lightweight | Quick visual tasks |
| **Gemini 2.0 Flash** | Google | Fast, multimodal | Real-time processing |
| **Gemini 2.5 Pro** | Google | High accuracy, large context | Detailed document analysis |

### API Requirements

- Valid API keys for chosen model providers
- Rate limit awareness and quota management
- Understanding of token/image pricing models

### System Requirements

- Image processing libraries: `sharp` (Node.js) or `Pillow` (Python)
- Base64 encoding/decoding capabilities
- File I/O permissions for temporary storage

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. IMAGE EXTRACTION                                      │
│     Parse chat message for embedded images               │
│     Handle multiple formats (base64, URLs, attachments)  │
├─────────────────────────────────────────────────────────┤
│  2. MODEL SELECTION                                      │
│     Analyze task requirements                           │
│     Select optimal model based on criteria              │
├─────────────────────────────────────────────────────────┤
│  3. PREPROCESSING                                        │
│     Resize/optimize for model constraints                │
│     Format conversion if needed                          │
│     Quality adjustment                                   │
├─────────────────────────────────────────────────────────┤
│  4. API CALL                                             │
│     Construct request with image data                   │
│     Include prompt/context                               │
│     Handle response                                      │
├─────────────────────────────────────────────────────────┤
│  5. RESULT PROCESSING                                    │
│     Parse AI response                                    │
│     Extract relevant information                         │
│     Format for chat output                               │
├─────────────────────────────────────────────────────────┤
│  6. MODEL SWITCH (if needed)                             │
│     Evaluate result quality                              │
│     Switch to alternative model if criteria not met     │
└─────────────────────────────────────────────────────────┘
```

## Image Extraction

### From Markdown

```typescript
// Extract images from markdown chat messages
function extractImagesFromMarkdown(message: string): string[] {
  const imageRegex = /!\[.*?\]\((.*?)\)/g
  const images: string[] = []
  let match
  
  while ((match = imageRegex.exec(message)) !== null) {
    images.push(match[1]) // URL or base64 data
  }
  
  return images
}
```

### From HTML/Rich Text

```typescript
// Extract images from HTML content
function extractImagesFromHTML(html: string): string[] {
  const parser = new DOMParser()
  const doc = parser.parseFromString(html, 'text/html')
  const imgElements = doc.querySelectorAll('img')
  
  return Array.from(imgElements).map(img => 
    img.src || img.getAttribute('data-src')
  ).filter(Boolean)
}
```

### From Base64 Data URIs

```typescript
// Parse and validate base64 image data
function parseBase64Image(dataUri: string): { 
  mimeType: string
  base64: string 
  size: number 
} | null {
  const match = dataUri.match(/^data:(image\/\w+);base64,(.+)$/)
  
  if (!match) return null
  
  const [, mimeType, base64] = match
  const size = Math.ceil((base64.length * 3) / 4) // Approximate size
  
  return { mimeType, base64, size }
}
```

## Multiple Image Handling

### Batch Processing Strategy

When processing multiple images from a single chat message, use these strategies for efficiency:

```typescript
interface BatchProcessingOptions {
  maxConcurrent: number      // Max parallel API calls
  batchSize: number          // Images per batch
  combineResults: boolean    // Merge results into single response
  deduplicate: boolean       // Remove duplicate images
}

async function processMultipleImages(
  images: Buffer[],
  prompt: string,
  model: string,
  options: BatchProcessingOptions = {}
): Promise<{ results: string[]; combined: string }> {
  const {
    maxConcurrent = 3,
    batchSize = 5,
    combineResults = true,
    deduplicate = true
  } = options
  
  // Deduplicate images by hash
  let uniqueImages = images
  if (deduplicate) {
    const seen = new Set<string>()
    uniqueImages = images.filter(img => {
      const hash = crypto.createHash('md5').update(img).digest('hex')
      if (seen.has(hash)) return false
      seen.add(hash)
      return true
    })
  }
  
  // Process in batches
  const batches: Buffer[][] = []
  for (let i = 0; i < uniqueImages.length; i += batchSize) {
    batches.push(uniqueImages.slice(i, i + batchSize))
  }
  
  // Process batches with concurrency limit
  const results: string[] = []
  for (const batch of batches) {
    const batchResults = await Promise.all(
      batch.map(async (img, idx) => {
        // Add image index to prompt for context
        const imagePrompt = `[Image ${results.length + idx + 1}]\n${prompt}`
        return await analyzeWithOpenAI([img], imagePrompt, model)
      })
    )
    results.push(...batchResults)
    
    // Rate limiting delay between batches
    if (batches.indexOf(batch) < batches.length - 1) {
      await new Promise(resolve => setTimeout(resolve, 1000))
    }
  }
  
  // Combine results
  const combined = combineResults
    ? results.map((r, i) => `**Image ${i + 1}:**\n${r}`).join('\n\n')
    : results[0] || ''
  
  return { results, combined }
}
```

### Parallel vs Sequential Processing

```typescript
// Parallel processing (faster, but may hit rate limits)
async function processImagesParallel(
  images: Buffer[],
  prompt: string,
  model: string
): Promise<string[]> {
  return await Promise.all(
    images.map((img, i) =>
      analyzeWithOpenAI([img], `[Image ${i + 1}] ${prompt}`, model)
    )
  )
}

// Sequential processing (slower, but respects rate limits)
async function processImagesSequential(
  images: Buffer[],
  prompt: string,
  model: string
): Promise<string[]> {
  const results: string[] = []
  for (let i = 0; i < images.length; i++) {
    results.push(
      await analyzeWithOpenAI([images[i]], `[Image ${i + 1}] ${prompt}`, model)
    )
    // Delay between requests
    if (i < images.length - 1) {
      await new Promise(resolve => setTimeout(resolve, 500))
    }
  }
  return results
}
```

### Smart Batching for Large Image Sets

```typescript
async function smartBatchProcess(
  images: Buffer[],
  prompt: string,
  model: string
): Promise<string> {
  const imageCount = images.length
  
  // Strategy based on image count
  if (imageCount <= 3) {
    // Small batch: process all together
    const results = await processImagesParallel(images, prompt, model)
    return results.map((r, i) => `**Image ${i + 1}:**\n${r}`).join('\n\n')
  } else if (imageCount <= 10) {
    // Medium batch: parallel with rate limiting
    const { combined } = await processMultipleImages(images, prompt, model, {
      maxConcurrent: 3,
      batchSize: 5,
      combineResults: true
    })
    return combined
  } else {
    // Large batch: sequential with summary
    const results = await processImagesSequential(images, prompt, model)
    
    // Generate summary
    const summary = `Processed ${imageCount} images. Key findings:\n` +
      results.slice(0, 5).map((r, i) =>
        `${i + 1}. ${r.substring(0, 100)}...`
      ).join('\n') +
      `\n\n(Showing first 5 of ${imageCount} results)`
    
    return summary
  }
}
```

## Image Size Optimization

### Automatic Size Reduction

Reduce image size before sending to API to save costs and improve performance:

```typescript
interface ImageOptimizationOptions {
  maxWidth?: number
  maxHeight?: number
  quality?: number        // JPEG quality (1-100)
  format?: 'jpeg' | 'png' | 'webp'
  maxSizeKB?: number     // Target max size in KB
  stripMetadata?: boolean // Remove EXIF data
}

async function optimizeImage(
  imageBuffer: Buffer,
  options: ImageOptimizationOptions = {}
): Promise<Buffer> {
  const {
    maxWidth = 1920,
    maxHeight = 1920,
    quality = 85,
    format = 'jpeg',
    maxSizeKB = 500,
    stripMetadata = true
  } = options
  
  let pipeline = sharp(imageBuffer)
  
  // Get original metadata
  const metadata = await pipeline.metadata()
  
  // Strip metadata if requested
  if (stripMetadata) {
    pipeline = pipeline.withMetadata()
  }
  
  // Calculate dimensions maintaining aspect ratio
  let width = metadata.width || maxWidth
  let height = metadata.height || maxHeight
  
  if (width > maxWidth || height > maxHeight) {
    const ratio = Math.min(maxWidth / width, maxHeight / height)
    width = Math.round(width * ratio)
    height = Math.round(height * ratio)
    pipeline = pipeline.resize(width, height, {
      withoutEnlargement: true,
      fit: 'inside'
    })
  }
  
  // Convert format
  switch (format) {
    case 'jpeg':
      pipeline = pipeline.jpeg({ quality, progressive: true })
      break
    case 'png':
      pipeline = pipeline.png({ compressionLevel: 9, adaptiveFiltering: true })
      break
    case 'webp':
      pipeline = pipeline.webp({ quality, effort: 6 })
      break
  }
  
  let optimized = await pipeline.toBuffer()
  
  // Iteratively reduce if still too large
  let iterations = 0
  while (optimized.length > maxSizeKB * 1024 && iterations < 5) {
    const newQuality = Math.max(50, quality - (iterations * 10))
    pipeline = sharp(imageBuffer).resize(width, height, {
      withoutEnlargement: true,
      fit: 'inside'
    }).jpeg({ quality: newQuality })
    optimized = await pipeline.toBuffer()
    iterations++
  }
  
  console.log(`Optimized: ${(metadata.size || 0) / 1024}KB -> ${optimized.length / 1024}KB`)
  return optimized
}
```

### Batch Optimization for Multiple Images

```typescript
async function optimizeImageBatch(
  images: Buffer[],
  options: ImageOptimizationOptions = {}
): Promise<Buffer[]> {
  // Process in parallel for speed
  return await Promise.all(
    images.map(img => optimizeImage(img, options))
  )
}
```

### Adaptive Optimization Based on Model

```typescript
function getOptimizationForModel(model: string): ImageOptimizationOptions {
  const modelConfigs: Record<string, ImageOptimizationOptions> = {
    // OpenAI models - 20MB limit, optimize for speed
    'gpt-5.2': { maxWidth: 2048, maxHeight: 2048, quality: 85, maxSizeKB: 500 },
    'gpt-4.1': { maxWidth: 2048, maxHeight: 2048, quality: 85, maxSizeKB: 500 },
    'gpt-4o': { maxWidth: 2048, maxHeight: 2048, quality: 85, maxSizeKB: 500 },
    'gpt-4o-mini': { maxWidth: 1536, maxHeight: 1536, quality: 80, maxSizeKB: 300 },
    'gpt-4.1-nano': { maxWidth: 1024, maxHeight: 1024, quality: 75, maxSizeKB: 200 },
    
    // Zhipu AI models - 20MB limit, can handle larger images
    'glm-4.6v': { maxWidth: 4096, maxHeight: 4096, quality: 90, maxSizeKB: 1000 },
    'glm-4.6v-flash': { maxWidth: 2048, maxHeight: 2048, quality: 85, maxSizeKB: 500 },
    
    // Anthropic models - 10MB limit, need more aggressive optimization
    'claude-3-5-sonnet': { maxWidth: 1536, maxHeight: 1536, quality: 80, maxSizeKB: 300 },
    'claude-3-5-haiku': { maxWidth: 1024, maxHeight: 1024, quality: 75, maxSizeKB: 200 },
    
    // Google models - 20MB limit
    'gemini-2.0-flash': { maxWidth: 2048, maxHeight: 2048, quality: 85, maxSizeKB: 500 },
    'gemini-2.5-pro': { maxWidth: 4096, maxHeight: 4096, quality: 90, maxSizeKB: 1000 }
  }
  
  return modelConfigs[model] || { maxWidth: 1920, maxHeight: 1920, quality: 85, maxSizeKB: 500 }
}
```

### End-to-End Processing Pipeline

```typescript
async function processChatImages(
  images: Buffer[],
  prompt: string,
  model: string
): Promise<string> {
  // Step 1: Deduplicate images
  const uniqueImages = deduplicateImages(images)
  
  // Step 2: Optimize images for model
  const optimizationOptions = getOptimizationForModel(model)
  const optimizedImages = await optimizeImageBatch(uniqueImages, optimizationOptions)
  
  // Step 3: Process based on count
  if (optimizedImages.length === 1) {
    return await analyzeWithOpenAI(optimizedImages, prompt, model)
  } else {
    const { combined } = await processMultipleImages(
      optimizedImages,
      prompt,
      model,
      { maxConcurrent: 3, batchSize: 5, combineResults: true }
    )
    return combined
  }
}

function deduplicateImages(images: Buffer[]): Buffer[] {
  const seen = new Set<string>()
  return images.filter(img => {
    const hash = crypto.createHash('md5').update(img).digest('hex')
    if (seen.has(hash)) return false
    seen.add(hash)
    return true
  })
}
```

## Model Selection Strategy

### Decision Matrix

| Requirement | Recommended Model | Rationale |
|-------------|-------------------|-----------|
| **General analysis** | GPT-4o | Best balance of quality, speed, cost |
| **OCR heavy** | GPT-4o | Superior text recognition |
| **Complex reasoning** | Claude 3.5 Sonnet | Better at nuanced understanding |
| **Speed critical** | GPT-4o-mini / Haiku | Fastest response times |
| **Cost sensitive** | GPT-4o-mini / Haiku | Lowest per-image cost |
| **Large documents** | Gemini 2.5 Pro | Largest context window |
| **Batch processing** | GPT-4o-mini | Best throughput/cost ratio |

### Selection Algorithm

```typescript
interface ModelSelectionCriteria {
  taskType: 'general' | 'ocr' | 'reasoning' | 'quick' | 'batch'
  imageCount: number
  maxLatency?: number // ms
  maxCost?: number // USD
  priority: 'speed' | 'quality' | 'cost'
}

function selectModel(criteria: ModelSelectionCriteria): string {
  const { taskType, imageCount, maxLatency, maxCost, priority } = criteria
  
  // Priority-based selection
  if (priority === 'speed') {
    return imageCount > 5 ? 'gpt-4o-mini' : 'claude-3-5-haiku'
  }
  
  if (priority === 'cost') {
    return 'gpt-4o-mini'
  }
  
  // Quality priority (default)
  switch (taskType) {
    case 'ocr':
      return 'gpt-4o'
    case 'reasoning':
      return 'claude-3-5-sonnet'
    case 'quick':
      return 'claude-3-5-haiku'
    case 'batch':
      return 'gpt-4o-mini'
    default:
      return 'gpt-4o'
  }
}
```

## Image Preprocessing

### Resize for Model Constraints

```typescript
import sharp from 'sharp'

async function preprocessImage(
  imageBuffer: Buffer,
  targetModel: string
): Promise<Buffer> {
  const modelConstraints = {
    'gpt-4o': { maxWidth: 2048, maxHeight: 2048, maxSizeMB: 20 },
    'gpt-4o-mini': { maxWidth: 2048, maxHeight: 2048, maxSizeMB: 20 },
    'claude-3-5-sonnet': { maxWidth: 4096, maxHeight: 4096, maxSizeMB: 10 },
    'claude-3-5-haiku': { maxWidth: 4096, maxHeight: 4096, maxSizeMB: 10 },
    'gemini-2.0-flash': { maxWidth: 2048, maxHeight: 2048, maxSizeMB: 20 },
    'gemini-2.5-pro': { maxWidth: 4096, maxHeight: 4096, maxSizeMB: 20 }
  }
  
  const constraints = modelConstraints[targetModel as keyof typeof modelConstraints]
  
  let pipeline = sharp(imageBuffer)
  
  // Get metadata
  const metadata = await pipeline.metadata()
  
  // Resize if needed
  if (metadata.width && metadata.width > constraints.maxWidth) {
    pipeline = pipeline.resize(constraints.maxWidth, null, {
      withoutEnlargement: true,
      fit: 'inside'
    })
  }
  
  if (metadata.height && metadata.height > constraints.maxHeight) {
    pipeline = pipeline.resize(null, constraints.maxHeight, {
      withoutEnlargement: true,
      fit: 'inside'
    })
  }
  
  // Optimize
  pipeline = pipeline.jpeg({ quality: 85 })
  
  return pipeline.toBuffer()
}
```

### Format Conversion

```typescript
async function convertToSupportedFormat(
  imageBuffer: Buffer,
  sourceFormat: string
): Promise<{ buffer: Buffer; mimeType: string }> {
  const supportedFormats = ['jpeg', 'png', 'webp', 'gif']
  
  if (supportedFormats.includes(sourceFormat.toLowerCase())) {
    return { buffer: imageBuffer, mimeType: `image/${sourceFormat}` }
  }
  
  // Convert unsupported formats to JPEG
  const converted = await sharp(imageBuffer)
    .jpeg({ quality: 90 })
    .toBuffer()
  
  return { buffer: converted, mimeType: 'image/jpeg' }
}
```

## API Integration

### OpenAI Vision API

```typescript
async function analyzeWithOpenAI(
  images: Buffer[],
  prompt: string,
  model: string = 'gpt-4o'
): Promise<string> {
  const base64Images = await Promise.all(
    images.map(img => img.toString('base64'))
  )
  
  const content = [
    { type: 'text', text: prompt },
    ...base64Images.map(b64 => ({
      type: 'image_url',
      image_url: { url: `data:image/jpeg;base64,${b64}` }
    }))
  ]
  
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`
    },
    body: JSON.stringify({
      model,
      messages: [{ role: 'user', content }],
      max_tokens: 4096
    })
  })
  
  const data = await response.json()
  return data.choices[0].message.content
}
```

### Anthropic Claude API

```typescript
async function analyzeWithClaude(
  images: Buffer[],
  prompt: string,
  model: string = 'claude-3-5-sonnet-20241022'
): Promise<string> {
  const content = [
    { type: 'text', text: prompt },
    ...images.map(img => ({
      type: 'image',
      source: {
        type: 'base64',
        media_type: 'image/jpeg',
        data: img.toString('base64')
      }
    }))
  ]
  
  const response = await fetch('https://api.anthropic.com/v1/messages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'x-api-key': process.env.ANTHROPIC_API_KEY,
      'anthropic-version': '2023-06-01',
      'anthropic-dangerous-direct-browser-access': 'true'
    },
    body: JSON.stringify({
      model,
      max_tokens: 4096,
      messages: [{ role: 'user', content }]
    })
  })
  
  const data = await response.json()
  return data.content[0].text
}
```

### Google Gemini API

```typescript
async function analyzeWithGemini(
  images: Buffer[],
  prompt: string,
  model: string = 'gemini-2.0-flash-exp'
): Promise<string> {
  const parts = [
    { text: prompt },
    ...images.map(img => ({
      inline_data: {
        mime_type: 'image/jpeg',
        data: img.toString('base64')
      }
    }))
  ]
  
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${process.env.GOOGLE_API_KEY}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ contents: [{ parts }] })
    }
  )
  
  const data = await response.json()
  return data.candidates[0].content.parts[0].text
}
```

## Model Switching Strategy

### When to Switch Models

Switch to an alternative model when:

1. **Quality Issues**
   - OCR accuracy below 90%
   - Missing key visual elements
   - Hallucinations in description
   - Inconsistent results across similar images

2. **Performance Issues**
   - Response time exceeds threshold
   - Rate limit errors
   - Timeout errors

3. **Cost Issues**
   - Budget exceeded
   - Unexpected high token usage

4. **Capability Gaps**
   - Model cannot handle specific image type
   - Specialized analysis needed (medical, technical diagrams)

### Switch Decision Tree

```
┌─────────────────────────────────────┐
│  Evaluate Current Result            │
└──────────────┬──────────────────────┘
               │
       ┌───────┴───────┐
       │               │
   Quality OK?    Quality Poor?
       │               │
       ▼               ▼
    Keep Model    ┌─────────────┐
                  │ Task Type?  │
                  └──────┬──────┘
                         │
        ┌────────────────┼────────────────┐
        │                │                │
    OCR Failed?   Reasoning Failed?  General Issue?
        │                │                │
        ▼                ▼                ▼
   Try Claude      Try GPT-4o       Try Gemini
   (better OCR)   (better logic)   (different)
```

### Implementation

```typescript
interface ModelSwitchConfig {
  maxRetries: number
  qualityThreshold: number
  latencyThreshold: number
  fallbackChain: string[]
}

async function analyzeWithFallback(
  images: Buffer[],
  prompt: string,
  initialModel: string,
  config: ModelSwitchConfig
): Promise<{ result: string; modelUsed: string }> {
  let currentModel = initialModel
  let attempts = 0
  const fallbackChain = config.fallbackChain
  
  while (attempts <= config.maxRetries) {
    const startTime = Date.now()
    
    try {
      let result: string
      
      if (currentModel.startsWith('gpt')) {
        result = await analyzeWithOpenAI(images, prompt, currentModel)
      } else if (currentModel.startsWith('glm')) {
        result = await analyzeWithZhipuAI(images, prompt, currentModel)
      } else if (currentModel.startsWith('claude')) {
        result = await analyzeWithClaude(images, prompt, currentModel)
      } else if (currentModel.startsWith('gemini')) {
        result = await analyzeWithGemini(images, prompt, currentModel)
      } else {
        throw new Error(`Unknown model: ${currentModel}`)
      }
      
      const latency = Date.now() - startTime
      
      // Quality check (implement based on task)
      const qualityScore = await assessQuality(result, prompt)
      
      if (qualityScore >= config.qualityThreshold && 
          latency <= config.latencyThreshold) {
        return { result, modelUsed: currentModel }
      }
      
      // Try next model in chain
      if (attempts < fallbackChain.length) {
        currentModel = fallbackChain[attempts]
        attempts++
        continue
      }
      
      return { result, modelUsed: currentModel }
      
    } catch (error) {
      attempts++
      
      if (attempts <= fallbackChain.length) {
        currentModel = fallbackChain[attempts - 1]
        continue
      }
      
      throw error
    }
  }
  
  throw new Error('All model attempts failed')
}
```

### Fallback Chain Examples

```typescript
// OpenAI-first fallback chain
const openaiFallbackChain = [
  'gpt-5.2',
  'gpt-4.1',
  'gpt-4o',
  'gpt-4.1-mini'
]

// Zhipu AI-first fallback chain
const zhipuFallbackChain = [
  'glm-4.6v',
  'glm-4.6v-flash',
  'glm-4.5v'
]

// Cross-provider fallback chain
const crossProviderFallbackChain = [
  'gpt-5.2',
  'glm-4.6v',
  'claude-3-5-sonnet',
  'gpt-4o-mini',
  'glm-4.6v-flash'
]

// Cost-optimized fallback chain (includes free option)
const costOptimizedFallbackChain = [
  'glm-4.6v-flash', // Free
  'gpt-4.1-mini',
  'gpt-4o-mini'
]
```

## Best Practices

### Performance Optimization

1. **Smart Batch Processing**
   ```typescript
   // Use smart batching based on image count
   const result = await smartBatchProcess(images, prompt, model)
   ```
   - Deduplicate images before processing
   - Use adaptive batching (parallel for small sets, sequential for large)
   - Implement rate limiting between batches
   - Combine results intelligently

2. **Image Optimization**
   ```typescript
   // Always optimize before sending to API
   const optimized = await optimizeImageBatch(images, getOptimizationForModel(model))
   ```
   - Use model-specific optimization settings
   - Strip EXIF/metadata to reduce size
   - Target appropriate max size (200-1000KB based on model)
   - Use progressive JPEG for faster loading

3. **Caching**
   ```typescript
   // Cache results for identical images
   const imageHash = crypto.createHash('md5').update(imageBuffer).digest('hex')
   const cached = await cache.get(imageHash)
   if (cached) return cached
   ```

4. **Progressive Loading**
   ```typescript
   // Show partial results while processing
   for (const image of images) {
     const result = await analyzeImage(image)
      emitPartialResult(result)
   }
   ```

### Cost Management

1. **Aggressive Image Optimization**
   - Always resize to model's optimal dimensions
   - Use lower quality (75-85%) for quick tasks
   - Target 200-500KB for most models
   - Use WebP format when supported (better compression)

2. **Strategic Model Selection**
   - Use GPT-4.1-nano/GLM-4.6V-Flash for quick tasks
   - Use GLM-4.6V-Flash (FREE) for cost-sensitive workloads
   - Reserve GPT-5.2/GLM-4.6V for complex analysis only
   - Consider local deployment with GLM-4.6V-Flash-WEB for zero API costs

3. **Token Management**
   - Set appropriate `max_tokens` (1024-4096 based on task)
   - Use concise, focused prompts
   - Batch similar requests when possible
   - Enable prompt caching for repeated queries

### Multiple Image Handling

1. **Deduplication**
   ```typescript
   // Always deduplicate before processing
   const uniqueImages = deduplicateImages(images)
   ```
   - Use MD5 hash for reliable deduplication
   - Saves API calls and costs
   - Improves processing speed

2. **Adaptive Batching Strategy**
   - **1-3 images**: Process in parallel (fastest)
   - **4-10 images**: Batch with concurrency limit (balanced)
   - **10+ images**: Sequential with summary (most efficient)

3. **Result Aggregation**
   - Combine results with clear labeling
   - Generate summaries for large batches
   - Provide context for each image in combined output

### Error Handling

```typescript
async function safeImageAnalysis(
  images: Buffer[],
  prompt: string,
  provider: 'openai' | 'zhipu' | 'any' = 'any'
): Promise<{ success: boolean; result?: string; error?: string; modelUsed?: string }> {
  try {
    // Validate inputs
    if (!images.length) {
      return { success: false, error: 'No images provided' }
    }
    
    // Check image sizes
    const totalSize = images.reduce((sum, img) => sum + img.length, 0)
    if (totalSize > 50 * 1024 * 1024) { // 50MB limit
      return { success: false, error: 'Images too large' }
    }
    
    // Select fallback chain based on provider preference
    let initialModel: string
    let fallbackChain: string[]
    
    if (provider === 'openai') {
      initialModel = 'gpt-5.2'
      fallbackChain = ['gpt-4.1', 'gpt-4o', 'gpt-4.1-mini']
    } else if (provider === 'zhipu') {
      initialModel = 'glm-4.6v'
      fallbackChain = ['glm-4.6v-flash', 'glm-4.5v']
    } else {
      // Cross-provider fallback
      initialModel = 'gpt-5.2'
      fallbackChain = ['glm-4.6v', 'claude-3-5-sonnet-20241022', 'gpt-4o-mini', 'glm-4.6v-flash']
    }
    
    const { result, modelUsed } = await analyzeWithFallback(images, prompt, initialModel, {
      maxRetries: 3,
      qualityThreshold: 0.8,
      latencyThreshold: 30000,
      fallbackChain
    })
    
    return { success: true, result, modelUsed }
    
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Unknown error'
    }
  }
}
```

## Integration with openclaw

### Chat Message Handler

```typescript
async function handleChatMessageWithImages(
  message: string,
  attachments?: { type: 'image'; data: Buffer }[],
  provider: 'openai' | 'zhipu' | 'any' = 'any'
): Promise<string> {
  // Extract images from markdown
  const markdownImages = extractImagesFromMarkdown(message)
  
  // Combine with attachments
  const allImages = [
    ...markdownImages.filter(url => url.startsWith('data:')).map(uri => {
      const parsed = parseBase64Image(uri)
      return Buffer.from(parsed!.base64, 'base64')
    }),
    ...(attachments || []).map(a => a.data)
  ]
  
  if (allImages.length === 0) {
    // No images, handle as text-only
    return await handleTextMessage(message)
  }
  
  // Determine task type from message
  const taskType = inferTaskType(message)
  
  // Select model
  const model = selectModel({
    taskType,
    imageCount: allImages.length,
    priority: 'quality',
    provider
  })
  
  // Select fallback chain based on provider
  let fallbackChain: string[]
  if (provider === 'openai') {
    fallbackChain = ['gpt-4.1', 'gpt-4o', 'gpt-4.1-mini']
  } else if (provider === 'zhipu') {
    fallbackChain = ['glm-4.6v-flash', 'glm-4.5v']
  } else {
    fallbackChain = ['glm-4.6v', 'claude-3-5-sonnet-20241022', 'gpt-4o-mini', 'glm-4.6v-flash']
  }
  
  // Analyze images
  const { result, modelUsed } = await analyzeWithFallback(
    allImages,
    message,
    model,
    {
      maxRetries: 2,
      qualityThreshold: 0.75,
      latencyThreshold: 20000,
      fallbackChain
    }
  )
  
  // Add model attribution
  return `[Analyzed with ${modelUsed}]\n\n${result}`
}

function inferTaskType(message: string): 'general' | 'ocr' | 'reasoning' | 'quick' | 'realtime' | 'agent' | 'local' {
  const lower = message.toLowerCase()
  
  if (lower.includes('read') || lower.includes('text') || lower.includes('ocr')) {
    return 'ocr'
  }
  
  if (lower.includes('explain') || lower.includes('analyze') || lower.includes('understand')) {
    return 'reasoning'
  }
  
  if (lower.includes('quick') || lower.includes('fast')) {
    return 'quick'
  }
  
  if (lower.includes('realtime') || lower.includes('live') || lower.includes('video')) {
    return 'realtime'
  }
  
  if (lower.includes('agent') || lower.includes('tool') || lower.includes('action')) {
    return 'agent'
  }
  
  if (lower.includes('local') || lower.includes('offline') || lower.includes('private')) {
    return 'local'
  }
  
  return 'general'
}
```

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| **Invalid image format** | Unsupported MIME type | Convert to JPEG/PNG before sending |
| **Image too large** | Exceeds model limits | Resize/optimize image |
| **Rate limit error** | Too many requests | Implement backoff/retry |
| **Poor OCR results** | Low resolution or complex layout | Switch to GPT-4o/GLM-4.6V, preprocess image |
| **Slow response** | Large images or slow model | Use GPT-4.1-nano/GLM-4.6V-Flash, reduce image size |
| **Hallucinations** | Model uncertainty | Switch to Claude/GLM-4.6V, add more context |
| **Zhipu API auth error** | Invalid API key format | Check API key format (usually includes id.secret) |
| **Local GLM not responding** | Docker container not running | Check `docker ps`, restart container |
| **Realtime latency too high** | Network or model limitations | Use GPT-4o mini Realtime, reduce image size |
| **Agent tool calling fails** | Model doesn't support native tools | Use GLM-4.6V for native tool calling |

### Debug Mode

```typescript
const DEBUG = process.env.DEBUG_IMAGE_PROCESSING === 'true'

async function debugAnalyze(
  images: Buffer[],
  prompt: string,
  model: string
): Promise<string> {
  if (DEBUG) {
    console.log('[DEBUG] Image Analysis')
    console.log('- Model:', model)
    console.log('- Image count:', images.length)
    console.log('- Total size:', images.reduce((s, i) => s + i.length, 0) / 1024, 'KB')
    console.log('- Prompt length:', prompt.length)
  }
  
  const startTime = Date.now()
  let result: string
  
  // Route to appropriate API based on model
  if (model.startsWith('gpt')) {
    result = await analyzeWithOpenAI(images, prompt, model)
  } else if (model.startsWith('glm')) {
    result = await analyzeWithZhipuAI(images, prompt, model)
  } else if (model.startsWith('claude')) {
    result = await analyzeWithClaude(images, prompt, model)
  } else if (model.startsWith('gemini')) {
    result = await analyzeWithGemini(images, prompt, model)
  } else {
    throw new Error(`Unknown model: ${model}`)
  }
  
  const duration = Date.now() - startTime
  
  if (DEBUG) {
    console.log('[DEBUG] Analysis complete')
    console.log('- Duration:', duration, 'ms')
    console.log('- Result length:', result.length)
    console.log('- Provider:', model.startsWith('gpt') ? 'OpenAI' :
                          model.startsWith('glm') ? 'Zhipu AI' :
                          model.startsWith('claude') ? 'Anthropic' : 'Google')
  }
  
  return result
}
```

## Quick Reference

### Model Comparison

| Model | Max Image Size | Context | Speed | Cost | Best For |
|-------|----------------|---------|-------|------|----------|
| **OpenAI Models** |
| GPT-5.2 | 20MB | 128K+ | Medium | High | Cutting-edge tasks |
| GPT-4.5 Preview | 20MB | 128K | Medium | Medium | High-quality analysis |
| GPT-4.1 | 20MB | 128K | Fast | Medium | Production apps |
| GPT-4.1-mini | 20MB | 128K | Fast | Low | Batch processing |
| GPT-4.1-nano | 20MB | 128K | Ultra-fast | Very Low | Real-time, edge |
| GPT-4o | 20MB | 128K | Fast | Medium | General use |
| GPT-4o-mini | 20MB | 128K | Fast | Low | Batch/quick |
| GPT-4o Realtime | 20MB | 128K | Real-time | Medium | Live video |
| GPT-4o mini Realtime | 20MB | 128K | Real-time | Low | Low-latency live |
| GPT-4 Turbo Vision | 20MB | 128K | Medium | Medium | Legacy support |
| **Zhipu AI Models** |
| GLM-4.6V | 20MB | 128K | Medium | Low | Agent tasks, reasoning |
| GLM-4.6V-Flash | 20MB | 128K | Fast | **FREE** | Local deployment |
| GLM-4.6V-Flash-WEB | 20MB | 128K | Fast | **FREE** | Browser apps |
| GLM-4.5V | 20MB | 128K | Medium | Low | Legacy support |
| **Other Models** |
| Claude 3.5 Sonnet | 10MB | 200K | Medium | High | Reasoning |
| Claude 3.5 Haiku | 10MB | 200K | Fast | Low | Quick tasks |
| Gemini 2.0 Flash | 20MB | 1M | Fast | Low | Real-time |
| Gemini 2.5 Pro | 20MB | 1M | Medium | Medium | Large docs |

### Command Line Examples

```bash
# Set preferred model (OpenAI)
export DEFAULT_VISION_MODEL="gpt-5.2"

# Set preferred model (Zhipu AI)
export DEFAULT_VISION_MODEL="glm-4.6v"

# Set Zhipu API key
export ZHIPU_API_KEY="your-zhipu-api-key"

# Enable debug mode
export DEBUG_IMAGE_PROCESSING="true"

# Set quality threshold
export VISION_QUALITY_THRESHOLD="0.8"

# Set local GLM deployment URL
export GLM_LOCAL_API_URL="http://localhost:8080/v1/vision/completion"
```

## Related Skills

- [`search-first`](../search-first/SKILL.md) — Research alternative image processing libraries
- [`api-design`](../api-design/SKILL.md) — Design image processing API endpoints
- [`coding-standards`](../coding-standards/SKILL.md) — Follow consistent coding patterns
