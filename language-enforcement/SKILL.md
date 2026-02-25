---
name: language-enforcement
description: Language detection and enforcement for AI chat responses. Ensures AI models respond in the same language as the user's input, with support for English, Vietnamese, Chinese, and other languages. Includes detection strategies, verification methods, and handling language mismatches.
---

# Language Enforcement — Detect and Match User Language

Systematizes language detection and enforcement for AI chat responses in openclaw, ensuring models like GLM-4.x respond in the same language as the user's input.

## When to Activate

- Processing chat messages where language consistency is critical
- Working with AI models that may respond in unexpected languages (e.g., GLM-4.x returning Chinese for English/Vietnamese input)
- Implementing multilingual chat interfaces
- Building language-aware AI agents
- Debugging language mismatch issues in AI responses

## Prerequisites

### Supported Languages

Primary focus on:
- **English** (en) - Latin script, ASCII-friendly
- **Vietnamese** (vi) - Latin script with diacritics (á, à, ả, ã, ạ, etc.)
- **Chinese** (zh) - Hanzi characters, Simplified/Traditional

Extensible to:
- Other Asian languages (Japanese, Korean, Thai)
- European languages (French, German, Spanish, etc.)
- Right-to-left languages (Arabic, Hebrew)

### Language Detection Libraries

Choose based on your runtime environment:

#### Node.js / TypeScript
```json
{
  "dependencies": {
    "franc": "^6.1.0",           // Statistical language detection
    "langdetect": "^2.0.0",      // Naive Bayes classifier
    "cld3": "^3.0.0"            // Google Compact Language Detector v3
  }
}
```

#### Python
```python
# pip install langdetect
# pip install fasttext
# pip install pycld3
```

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. INPUT LANGUAGE DETECTION                             │
│     Extract user message text                            │
│     Clean and preprocess input                           │
│     Detect primary language                              │
│     Calculate confidence score                           │
├─────────────────────────────────────────────────────────┤
│  2. LANGUAGE INJECTION                                   │
│     Add explicit language instruction to system prompt  │
│     Include language context in user message             │
│     Set language-specific parameters                     │
├─────────────────────────────────────────────────────────┤
│  3. MODEL RESPONSE                                       │
│     Send request to AI model                             │
│     Receive model response                               │
├─────────────────────────────────────────────────────────┤
│  4. RESPONSE VERIFICATION                                │
│     Detect response language                             │
│     Compare with input language                          │
│     Calculate match confidence                           │
├─────────────────────────────────────────────────────────┤
│  5. MISMATCH HANDLING (if needed)                        │
│     ┌─────────────┐  ┌──────────────┐  ┌─────────────┐ │
│     │  Retry with │  │  Translate   │  │  Accept &   │ │
│     │  Stronger   │  │  Response    │  │  Warn User  │ │
│     │  Prompt     │  │  On-the-fly  │  │             │ │
│     └─────────────┘  └──────────────┘  └─────────────┘ │
└─────────────────────────────────────────────────────────┘
```

## Language Detection

### Input Language Detection

#### Basic Detection with Franc (Node.js)

```typescript
import franc from 'franc'

interface LanguageDetection {
  language: string      // ISO 639-1 code (en, vi, zh, etc.)
  confidence: number    // 0-1 score
  script?: string       // Script family (Latin, Han, etc.)
}

function detectInputLanguage(text: string): LanguageDetection {
  // Clean input: remove code blocks, URLs, emojis
  const cleanedText = cleanTextForDetection(text)
  
  // Detect language
  const languageCode = franc(cleanedText)
  
  // Calculate confidence based on text length and detection certainty
  const confidence = calculateConfidence(cleanedText, languageCode)
  
  // Determine script family
  const script = detectScript(cleanedText)
  
  return {
    language: languageCode,
    confidence,
    script
  }
}

function cleanTextForDetection(text: string): string {
  return text
    // Remove code blocks
    .replace(/```[\s\S]*?```/g, '')
    .replace(/`[^`]+`/g, '')
    // Remove URLs
    .replace(/https?:\/\/\S+/g, '')
    // Remove common technical terms
    .replace(/\b(API|HTTP|JSON|XML|SQL|CSS|HTML)\b/gi, '')
    // Remove emojis
    .replace(/[\p{Emoji_Presentation}\p{Extended_Pictographic}]/gu, '')
    // Normalize whitespace
    .replace(/\s+/g, ' ')
    .trim()
}

function calculateConfidence(text: string, languageCode: string): number {
  const textLength = text.length
  
  // Minimum text length for reliable detection
  if (textLength < 10) return 0.3
  if (textLength < 30) return 0.5
  if (textLength < 100) return 0.7
  
  // High confidence for longer texts
  return 0.9
}

function detectScript(text: string): string {
  // Check for Chinese characters
  if (/[\u4e00-\u9fff]/.test(text)) return 'Han'
  // Check for Vietnamese diacritics
  if (/[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i.test(text)) return 'Latin'
  // Default to Latin for English and other Latin-script languages
  return 'Latin'
}
```

#### Python Detection with langdetect

```python
from langdetect import detect, detect_langs
from langdetect.lang_detect_exception import LangDetectException
import re

class LanguageDetector:
    def __init__(self):
        self.language_map = {
            'en': 'English',
            'vi': 'Vietnamese',
            'zh-cn': 'Chinese (Simplified)',
            'zh-tw': 'Chinese (Traditional)',
        }
    
    def detect(self, text: str) -> dict:
        """Detect language from input text."""
        cleaned = self._clean_text(text)
        
        try:
            # Get all probabilities
            langs = detect_langs(cleaned)
            primary = langs[0]
            
            return {
                'language': primary.lang,
                'language_name': self.language_map.get(primary.lang, primary.lang),
                'confidence': primary.prob,
                'script': self._detect_script(cleaned)
            }
        except LangDetectException:
            # Fallback to script-based detection
            return {
                'language': self._detect_by_script(cleaned),
                'confidence': 0.5,
                'script': self._detect_script(cleaned)
            }
    
    def _clean_text(self, text: str) -> str:
        """Remove code blocks, URLs, and technical terms."""
        text = re.sub(r'```[\s\S]*?```', '', text)
        text = re.sub(r'`[^`]+`', '', text)
        text = re.sub(r'https?://\S+', '', text)
        text = re.sub(r'\b(API|HTTP|JSON|XML|SQL|CSS|HTML)\b', '', text, flags=re.IGNORECASE)
        return text.strip()
    
    def _detect_script(self, text: str) -> str:
        """Detect script family from characters."""
        if re.search(r'[\u4e00-\u9fff]', text):
            return 'Han'
        return 'Latin'
    
    def _detect_by_script(self, text: str) -> str:
        """Fallback detection based on script."""
        if re.search(r'[\u4e00-\u9fff]', text):
            return 'zh-cn'
        if re.search(r'[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]', text, re.IGNORECASE):
            return 'vi'
        return 'en'
```

### Response Language Verification

```typescript
interface VerificationResult {
  matches: boolean
  inputLanguage: string
  responseLanguage: string
  confidence: number
  mismatchReason?: string
}

function verifyResponseLanguage(
  inputLanguage: LanguageDetection,
  responseText: string
): VerificationResult {
  // Detect response language
  const responseLanguage = detectInputLanguage(responseText)
  
  // Compare languages
  const matches = inputLanguage.language === responseLanguage.language
  
  // Special case: Vietnamese vs English (both Latin script)
  const isLatinMismatch = 
    inputLanguage.script === 'Latin' && 
    responseLanguage.script === 'Latin' &&
    inputLanguage.language !== responseLanguage.language
  
  // Calculate overall confidence
  const confidence = Math.min(
    inputLanguage.confidence,
    responseLanguage.confidence
  )
  
  return {
    matches: matches || !isLatinMismatch,
    inputLanguage: inputLanguage.language,
    responseLanguage: responseLanguage.language,
    confidence,
    mismatchReason: isLatinMismatch 
      ? 'Latin script languages detected but codes differ' 
      : undefined
  }
}
```

## Language Injection Strategies

### System Prompt Modification

```typescript
interface LanguagePromptConfig {
  language: string
  languageName: string
  strict: boolean
  maxRetries: number
}

function buildLanguagePrompt(
  config: LanguagePromptConfig,
  originalPrompt: string
): string {
  const languageInstructions = {
    en: "You must respond in English only.",
    vi: "Bạn phải trả lời bằng tiếng Việt.",
    zh: "你必须用中文回答。"
  }
  
  const strictInstructions = config.strict
    ? " This is a strict requirement. Do not use any other language."
    : " Please match the user's language preference."
  
  return `${languageInstructions[config.language]}${strictInstructions}\n\n${originalPrompt}`
}
```

### User Message Context

```typescript
function addLanguageContext(
  userMessage: string,
  detectedLanguage: LanguageDetection
): string {
  const languagePrefixes = {
    en: '[English] ',
    vi: '[Tiếng Việt] ',
    zh: '[中文] '
  }
  
  return `${languagePrefixes[detectedLanguage.language]}${userMessage}`
}
```

### Model-Specific Parameters

```typescript
interface ModelLanguageConfig {
  model: string
  language: string
  temperature?: number
  topP?: number
}

function getModelLanguageConfig(config: ModelLanguageConfig): object {
  // GLM-4.x specific settings
  if (config.model.startsWith('glm-4')) {
    return {
      model: config.model,
      temperature: 0.7,
      top_p: 0.9,
      // Some models support language parameters
      ...(config.language === 'zh' ? { language: 'zh-CN' } : {})
    }
  }
  
  // OpenAI models
  if (config.model.startsWith('gpt-')) {
    return {
      model: config.model,
      temperature: 0.7
    }
  }
  
  return { model: config.model }
}
```

## Mismatch Handling Strategies

### Strategy 1: Retry with Stronger Prompt

```typescript
async function handleLanguageMismatchRetry(
  originalMessage: string,
  originalResponse: string,
  detectedLanguage: LanguageDetection,
  apiCall: (prompt: string) => Promise<string>,
  maxRetries: number = 2
): Promise<string> {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    // Build stronger language instruction
    const strongerPrompt = buildStrictLanguagePrompt(
      originalMessage,
      detectedLanguage,
      attempt
    )
    
    // Retry API call
    const newResponse = await apiCall(strongerPrompt)
    
    // Verify new response
    const verification = verifyResponseLanguage(detectedLanguage, newResponse)
    
    if (verification.matches) {
      return newResponse
    }
  }
  
  // All retries failed, return original with warning
  return addLanguageWarning(originalResponse, detectedLanguage)
}

function buildStrictLanguagePrompt(
  message: string,
  language: LanguageDetection,
  attempt: number
): string {
  const strictness = attempt === 1 ? 'Please' : 'You MUST'
  const languageNames = {
    en: 'English',
    vi: 'Vietnamese',
    zh: 'Chinese'
  }
  
  return `${strictness} respond in ${languageNames[language.language]} only. 
Do not use any other language. Your response must be entirely in ${languageNames[language.language]}.

${message}`
}
```

### Strategy 2: On-the-fly Translation

```typescript
async function translateResponse(
  response: string,
  targetLanguage: string,
  translationService: (text: string, target: string) => Promise<string>
): Promise<string> {
  try {
    const translated = await translationService(response, targetLanguage)
    return translated
  } catch (error) {
    console.error('Translation failed:', error)
    return response // Return original if translation fails
  }
}
```

### Strategy 3: Accept with Warning

```typescript
function addLanguageWarning(
  response: string,
  detectedLanguage: LanguageDetection
): string {
  const languageNames = {
    en: 'English',
    vi: 'Vietnamese',
    zh: 'Chinese'
  }
  
  const warning = `\n\n[⚠️ Language Notice: This response is not in ${languageNames[detectedLanguage.language]} as expected. The AI model responded in a different language.]`
  
  return response + warning
}
```

## Edge Cases and Special Handling

### Mixed Language Input

```typescript
function handleMixedLanguage(text: string): LanguageDetection {
  // Detect dominant language
  const primaryDetection = detectInputLanguage(text)
  
  // Check for significant secondary language presence
  const secondaryLanguage = detectSecondaryLanguage(text, primaryDetection.language)
  
  if (secondaryLanguage && secondaryLanguage.confidence > 0.3) {
    // Mixed language detected
    return {
      ...primaryDetection,
      isMixed: true,
      secondaryLanguage: secondaryLanguage.language,
      recommendation: 'Use primary language for response'
    }
  }
  
  return primaryDetection
}

function detectSecondaryLanguage(
  text: string,
  primaryLanguage: string
): { language: string; confidence: number } | null {
  // Split text into segments and detect each
  const segments = text.split(/[.!?]+/).filter(s => s.trim().length > 10)
  
  const languageCounts: Record<string, number> = {}
  
  segments.forEach(segment => {
    const detected = detectInputLanguage(segment.trim())
    if (detected.language !== primaryLanguage) {
      languageCounts[detected.language] = (languageCounts[detected.language] || 0) + 1
    }
  })
  
  // Find most common secondary language
  const entries = Object.entries(languageCounts)
  if (entries.length === 0) return null
  
  const [language, count] = entries.sort((a, b) => b[1] - a[1])[0]
  const confidence = count / segments.length
  
  return { language, confidence }
}
```

### Code Snippets and Technical Content

```typescript
function handleCodeHeavyInput(text: string): LanguageDetection {
  // Calculate ratio of code to natural language
  const codeRatio = calculateCodeRatio(text)
  
  if (codeRatio > 0.5) {
    // Mostly code - extract natural language portions
    const naturalText = extractNaturalLanguage(text)
    
    if (naturalText.length < 20) {
      // Too little natural language, default to English
      return {
        language: 'en',
        confidence: 0.4,
        script: 'Latin',
        note: 'Code-heavy input, defaulting to English'
      }
    }
    
    return detectInputLanguage(naturalText)
  }
  
  return detectInputLanguage(text)
}

function calculateCodeRatio(text: string): number {
  const codeBlockMatches = text.match(/```[\s\S]*?```/g) || []
  const inlineCodeMatches = text.match(/`[^`]+`/g) || []
  
  const codeLength = [
    ...codeBlockMatches,
    ...inlineCodeMatches
  ].reduce((sum, match) => sum + match.length, 0)
  
  return codeLength / text.length
}

function extractNaturalLanguage(text: string): string {
  return text
    .replace(/```[\s\S]*?```/g, '')
    .replace(/`[^`]+`/g, '')
    .replace(/\b(function|const|let|var|if|else|for|while|return|import|export|class|def|print|console\.log)\b/gi, '')
    .trim()
}
```

### Short Input Handling

```typescript
function handleShortInput(text: string, context?: string): LanguageDetection {
  if (text.length < 10) {
    // Very short input - use context if available
    if (context && context.length > 50) {
      return detectInputLanguage(context)
    }
    
    // No context - use character-based heuristics
    return detectByCharacterHeuristics(text)
  }
  
  return detectInputLanguage(text)
}

function detectByCharacterHeuristics(text: string): LanguageDetection {
  // Check for Vietnamese diacritics
  const vietnameseChars = /[àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ]/i
  if (vietnameseChars.test(text)) {
    return { language: 'vi', confidence: 0.6, script: 'Latin' }
  }
  
  // Check for Chinese characters
  const chineseChars = /[\u4e00-\u9fff]/
  if (chineseChars.test(text)) {
    return { language: 'zh', confidence: 0.7, script: 'Han' }
  }
  
  // Default to English for Latin script
  return { language: 'en', confidence: 0.4, script: 'Latin' }
}
```

## Best Practices

### Detection Accuracy

1. **Minimum Text Length**: Require at least 30 characters for reliable detection
2. **Confidence Thresholds**: 
   - High confidence (>0.8): Trust detection
   - Medium confidence (0.5-0.8): Use with caution
   - Low confidence (<0.5): Use fallback or ask user
3. **Context Awareness**: Consider conversation history for short messages

### Performance Optimization

```typescript
// Cache detection results for repeated messages
const detectionCache = new Map<string, LanguageDetection>()

function cachedDetection(text: string): LanguageDetection {
  const hash = hashText(text)
  
  if (detectionCache.has(hash)) {
    return detectionCache.get(hash)!
  }
  
  const result = detectInputLanguage(text)
  detectionCache.set(hash, result)
  
  return result
}

// Batch detection for multiple messages
function batchDetect(messages: string[]): LanguageDetection[] {
  return messages.map(msg => cachedDetection(msg))
}
```

### Error Handling

```typescript
interface LanguageEnforcementError extends Error {
  type: 'detection_failed' | 'verification_failed' | 'retry_exceeded'
  originalText?: string
  detectedLanguage?: string
}

function handleDetectionError(error: unknown, text: string): LanguageDetection {
  if (error instanceof LanguageEnforcementError) {
    console.error(`Language enforcement error: ${error.type}`, error)
  }
  
  // Fallback to English with low confidence
  return {
    language: 'en',
    confidence: 0.3,
    script: 'Latin',
    note: 'Detection failed, using fallback'
  }
}
```

### Logging and Monitoring

```typescript
interface LanguageEnforcementLog {
  timestamp: Date
  inputLanguage: string
  responseLanguage: string
  matched: boolean
  confidence: number
  model: string
  retries: number
}

function logLanguageEnforcement(log: LanguageEnforcementLog): void {
  // Log to monitoring system
  console.log('[Language Enforcement]', JSON.stringify(log))
  
  // Track metrics
  trackMetric('language_enforcement.match_rate', log.matched ? 1 : 0)
  trackMetric('language_enforcement.confidence', log.confidence)
  trackMetric('language_enforcement.retries', log.retries)
}
```

## Implementation Patterns

### Complete Workflow Example

```typescript
class LanguageEnforcer {
  private detector: LanguageDetector
  private maxRetries: number = 2
  private strictMode: boolean = true
  
  constructor(config?: { maxRetries?: number; strictMode?: boolean }) {
    this.detector = new LanguageDetector()
    this.maxRetries = config?.maxRetries ?? 2
    this.strictMode = config?.strictMode ?? true
  }
  
  async enforceLanguage(
    userMessage: string,
    apiCall: (prompt: string) => Promise<string>,
    model: string = 'glm-4'
  ): Promise<{ response: string; language: string; retries: number }> {
    // Step 1: Detect input language
    const inputLanguage = this.detector.detect(userMessage)
    
    // Step 2: Build language-aware prompt
    const languagePrompt = this.buildLanguagePrompt(userMessage, inputLanguage)
    
    // Step 3: Call API with retry logic
    let response: string
    let retries = 0
    
    for (retries = 0; retries <= this.maxRetries; retries++) {
      response = await apiCall(languagePrompt)
      
      // Step 4: Verify response language
      const verification = this.verifyResponse(inputLanguage, response)
      
      if (verification.matches) {
        // Log success
        this.logEnforcement({
          timestamp: new Date(),
          inputLanguage: inputLanguage.language,
          responseLanguage: verification.responseLanguage,
          matched: true,
          confidence: verification.confidence,
          model,
          retries
        })
        
        return {
          response: response!,
          language: inputLanguage.language,
          retries
        }
      }
      
      // Build stronger prompt for retry
      if (retries < this.maxRetries) {
        languagePrompt = this.buildStrongerPrompt(
          userMessage,
          inputLanguage,
          retries + 1
        )
      }
    }
    
    // All retries failed - handle mismatch
    const finalResponse = this.handleMismatch(
      response!,
      inputLanguage
    )
    
    // Log failure
    this.logEnforcement({
      timestamp: new Date(),
      inputLanguage: inputLanguage.language,
      responseLanguage: this.detector.detect(response!).language,
      matched: false,
      confidence: 0,
      model,
      retries
    })
    
    return {
      response: finalResponse,
      language: inputLanguage.language,
      retries
    }
  }
  
  private buildLanguagePrompt(
    message: string,
    language: LanguageDetection
  ): string {
    const instructions = this.getLanguageInstructions(language.language)
    return `${instructions}\n\n${message}`
  }
  
  private buildStrongerPrompt(
    message: string,
    language: LanguageDetection,
    attempt: number
  ): string {
    const strictness = attempt === 1 ? 'Please' : 'You MUST'
    const instructions = this.getLanguageInstructions(language.language)
    
    return `${strictness} ${instructions.toLowerCase()} 
This is a strict requirement. Do not use any other language.

${message}`
  }
  
  private getLanguageInstructions(language: string): string {
    const instructions: Record<string, string> = {
      en: 'You must respond in English only.',
      vi: 'Bạn phải trả lời bằng tiếng Việt.',
      zh: '你必须用中文回答。'
    }
    return instructions[language] || 'Please respond in the same language as the user.'
  }
  
  private verifyResponse(
    inputLanguage: LanguageDetection,
    response: string
  ): { matches: boolean; responseLanguage: string; confidence: number } {
    const responseLanguage = this.detector.detect(response)
    
    return {
      matches: inputLanguage.language === responseLanguage.language,
      responseLanguage: responseLanguage.language,
      confidence: Math.min(inputLanguage.confidence, responseLanguage.confidence)
    }
  }
  
  private handleMismatch(
    response: string,
    inputLanguage: LanguageDetection
  ): string {
    if (this.strictMode) {
      return this.addLanguageWarning(response, inputLanguage)
    }
    return response
  }
  
  private addLanguageWarning(
    response: string,
    language: LanguageDetection
  ): string {
    const languageNames: Record<string, string> = {
      en: 'English',
      vi: 'Vietnamese',
      zh: 'Chinese'
    }
    
    return `${response}\n\n[⚠️ Language mismatch detected. Expected ${languageNames[language.language]} but received response in a different language.]`
  }
  
  private logEnforcement(log: LanguageEnforcementLog): void {
    console.log('[Language Enforcement]', JSON.stringify(log))
  }
}
```

### Integration with openclaw

```typescript
// Example integration with openclaw chat processing
async function processChatWithLanguageEnforcement(
  userMessage: string,
  model: string
): Promise<string> {
  const enforcer = new LanguageEnforcer({
    maxRetries: 2,
    strictMode: true
  })
  
  const result = await enforcer.enforceLanguage(
    userMessage,
    async (prompt) => {
      // Call openclaw API
      return await callOpenclawAPI(prompt, model)
    },
    model
  )
  
  return result.response
}
```

## Testing

### Unit Tests

```typescript
describe('LanguageEnforcer', () => {
  it('should detect Vietnamese language correctly', () => {
    const detector = new LanguageDetector()
    const result = detector.detect('Xin chào, bạn khỏe không?')
    
    expect(result.language).toBe('vi')
    expect(result.confidence).toBeGreaterThan(0.5)
  })
  
  it('should detect Chinese language correctly', () => {
    const detector = new LanguageDetector()
    const result = detector.detect('你好，你好吗？')
    
    expect(result.language).toBe('zh')
    expect(result.script).toBe('Han')
  })
  
  it('should detect English language correctly', () => {
    const detector = new LanguageDetector()
    const result = detector.detect('Hello, how are you?')
    
    expect(result.language).toBe('en')
  })
  
  it('should handle mixed language input', () => {
    const detector = new LanguageDetector()
    const result = detector.detect('Hello xin chào, how are you?')
    
    expect(result.isMixed).toBe(true)
    expect(result.language).toBeDefined()
  })
  
  it('should verify language match correctly', () => {
    const enforcer = new LanguageEnforcer()
    const inputLang = { language: 'en', confidence: 0.9, script: 'Latin' }
    const response = 'This is an English response.'
    
    const verification = enforcer['verifyResponse'](inputLang, response)
    
    expect(verification.matches).toBe(true)
  })
})
```

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Detection returns 'und' | Text too short or contains mostly code | Use context or character-based heuristics |
| Vietnamese detected as English | Missing diacritics in input | Add language instruction to prompt |
| Chinese detected as English | Text contains mostly ASCII | Check for Hanzi characters explicitly |
| Model ignores language instruction | Model not following instructions | Increase strictness, use retry logic |
| Performance degradation | Detection on every message | Implement caching for repeated messages |

### Debug Mode

```typescript
class DebugLanguageEnforcer extends LanguageEnforcer {
  enforceLanguage(
    userMessage: string,
    apiCall: (prompt: string) => Promise<string>,
    model: string = 'glm-4'
  ): Promise<{ response: string; language: string; retries: number; debug: any }> {
    console.log('[DEBUG] Input message:', userMessage)
    
    const inputLanguage = this.detector.detect(userMessage)
    console.log('[DEBUG] Detected language:', inputLanguage)
    
    const languagePrompt = this.buildLanguagePrompt(userMessage, inputLanguage)
    console.log('[DEBUG] Language prompt:', languagePrompt)
    
    return super.enforceLanguage(userMessage, apiCall, model).then(result => ({
      ...result,
      debug: {
        inputLanguage,
        languagePrompt
      }
    }))
  }
}
```
