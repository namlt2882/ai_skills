# Language Enforcement Framework

## Overview

Language enforcement ensures that all output summaries and analysis match the user's input language. This module detects the user's language, injects language instructions into summarization prompts, and verifies that responses are in the correct language.

## Supported Languages

### Primary Languages

| Language | Code | Script | Characteristics |
|----------|------|--------|-----------------|
| English | en | Latin | ASCII-friendly, default for global sources |
| Vietnamese | vi | Latin with diacritics | á, à, ả, ã, ạ, ă, â, đ, ê, ô, ơ, ư |
| Chinese | zh | Hanzi | Simplified/Traditional characters |

### Language Detection Priority

1. **Explicit user specification**: User states language preference
2. **Input text analysis**: Detect from user message content
3. **Source language inference**: Infer from requested sources
4. **Default fallback**: English if unable to determine

## Language Detection Workflow

### Step 1: Extract User Message

Extract user message text from chat context:
- Remove code blocks, URLs, and technical terms
- Focus on natural language content
- Preserve diacritics and special characters

### Step 2: Preprocess Input

```javascript
// Preprocessing steps
const preprocessInput = (text) => {
  // Remove code blocks
  text = text.replace(/```[\s\S]*?```/g, '');
  // Remove URLs
  text = text.replace(/https?:\/\/\S+/g, '');
  // Remove technical terms (tickers, symbols)
  text = text.replace(/\$[A-Z]+/g, '');
  // Normalize whitespace
  text = text.trim();
  return text;
};
```

### Step 3: Detect Primary Language

**Vietnamese Detection Patterns:**
- Diacritics: ă, â, đ, ê, ô, ơ, ư and combined forms
- Vietnamese-specific words: "của", "và", "là", "cho", "này", "không"
- Tone marks: á, à, ả, ã, ạ on vowels

**Chinese Detection Patterns:**
- Hanzi character ranges: \u4e00-\u9fff (CJK Unified Ideographs)
- Common particles: 的, 是, 在, 有, 和, 了
- No Latin script dominance

**English Detection Patterns:**
- ASCII Latin script dominance
- English function words: "the", "is", "are", "and", "for"
- No Vietnamese diacritics or Chinese characters

### Step 4: Calculate Confidence Score

```javascript
const calculateConfidence = (text, detectedLang) => {
  const scores = {
    vi: calculateVietnameseScore(text),
    zh: calculateChineseScore(text),
    en: calculateEnglishScore(text)
  };
  
  const maxScore = Math.max(...Object.values(scores));
  const confidence = maxScore / text.length;
  
  return {
    language: detectedLang,
    confidence: confidence,
    scores: scores
  };
};
```

## Language Injection in Summarization

### System Prompt Injection

Add explicit language instruction to system prompt:

**For Vietnamese:**
```
QUAN TRỌNG: Bạn PHẢI trả lời bằng tiếng Việt. Tất cả tóm tắt, phân tích và nhận xét 
phải được viết bằng tiếng Việt. Không được sử dụng tiếng Anh hoặc tiếng Trung.
```

**For English:**
```
IMPORTANT: You MUST respond in English. All summaries, analysis, and commentary 
must be written in English. Do not use Vietnamese or Chinese.
```

**For Chinese:**
```
重要：您必须用中文回答。所有摘要、分析和评论必须用中文撰写。
请勿使用英语或越南语。
```

### User Message Context

Include language context in user message:

```json
{
  "language_context": {
    "detected_language": "vi",
    "confidence": 0.95,
    "instruction": "Tóm tắt tin tức tài chính sau bằng tiếng Việt"
  }
}
```

### Summarization Prompt Template

```markdown
## Language Requirement
- Detected user language: {detected_language}
- You MUST write all summaries in: {language_name}
- Financial terms should use {language_name} terminology

## Summary Task
Summarize the following financial news articles in {language_name}:
{articles}

## Output Requirements
1. All text must be in {language_name}
2. Use appropriate financial terminology for {language_name}
3. Maintain professional tone
4. Include key facts and market implications
```

## Language-Specific Terminology

### Vietnamese Financial Terms

| English | Vietnamese |
|---------|------------|
| Stock market | Thị trường chứng khoán |
| Interest rate | Lãi suất |
| Exchange rate | Tỷ giá |
| Inflation | Lạm phát |
| GDP | Tổng sản phẩm quốc nội |
| Bond | Trái phiếu |
| Central bank | Ngân hàng trung ương |
| Monetary policy | Chính sách tiền tệ |
| Fiscal policy | Chính sách tài khóa |
| Dividend | Cổ tức |
| Earnings | Lợi nhuận |
| Revenue | Doanh thu |
| Market cap | Vốn hóa thị trường |
| Bull market | Thị trường tăng |
| Bear market | Thị trường giảm |
| Volatility | Biến động |
| Liquidity | Thanh khoản |

### Chinese Financial Terms

| English | Chinese (Simplified) |
|---------|---------------------|
| Stock market | 股市 |
| Interest rate | 利率 |
| Exchange rate | 汇率 |
| Inflation | 通货膨胀 |
| GDP | 国内生产总值 |
| Bond | 债券 |
| Central bank | 中央银行 |
| Monetary policy | 货币政策 |
| Fiscal policy | 财政政策 |
| Dividend | 股息 |
| Earnings | 收益 |
| Revenue | 收入 |
| Market cap | 市值 |
| Bull market | 牛市 |
| Bear market | 熊市 |
| Volatility | 波动性 |
| Liquidity | 流动性 |

## Response Verification

### Step 1: Detect Response Language

Apply the same detection algorithms to the model's response:
- Check for Vietnamese diacritics and patterns
- Check for Chinese characters
- Check for English patterns

### Step 2: Compare with Input Language

```javascript
const verifyLanguage = (response, expectedLang) => {
  const detectedLang = detectLanguage(response);
  
  if (detectedLang === expectedLang) {
    return { match: true, action: 'accept' };
  }
  
  return {
    match: false,
    detected: detectedLang,
    expected: expectedLang,
    action: 'mismatch'
  };
};
```

### Step 3: Handle Mismatches

| Mismatch Type | Action | Priority |
|---------------|--------|----------|
| Complete mismatch | Retry with stronger prompt | High |
| Partial mismatch | Translate key sections | Medium |
| Minor issues | Accept with warning | Low |

## Mismatch Handling Strategies

### Strategy 1: Retry with Stronger Prompt

```markdown
CRITICAL LANGUAGE REQUIREMENT:
Your previous response was in {wrong_language}, but the user asked in {correct_language}.
You MUST rewrite your entire response in {correct_language}.
DO NOT use {wrong_language} under any circumstances.

Rewrite your response in {correct_language}:
```

### Strategy 2: Translate On-the-Fly

Use translation API or model to convert response:

```javascript
const translateResponse = async (text, targetLang) => {
  // Use translation model or API
  const translated = await translate(text, { to: targetLang });
  return translated;
};
```

### Strategy 3: Accept with Warning

For minor issues or when translation is not available:

```json
{
  "warning": "Response may contain mixed languages",
  "original_language": "en",
  "detected_language": "en",
  "target_language": "vi",
  "action": "accepted_with_warning"
}
```

## Output Schema

### Language Detection Output

```json
{
  "language_detection": {
    "detected_language": "vi",
    "confidence": 0.95,
    "method": "diacritics_pattern",
    "source_text_sample": "Phân tích thị trường chứng khoán Việt Nam"
  }
}
```

### Language Verification Output

```json
{
  "language_verification": {
    "input_language": "vi",
    "response_language": "vi",
    "match": true,
    "action": "accept"
  }
}
```

### Mismatch Output

```json
{
  "language_verification": {
    "input_language": "vi",
    "response_language": "en",
    "match": false,
    "action": "retry",
    "retry_count": 1,
    "max_retries": 2
  }
}
```

## Integration with Other Modules

### News Aggregation Integration

- Detect user language before summarization
- Apply language to all article summaries
- Ensure consistent language across all outputs

### RSS Ingestion Integration

- RSS items may be in source language (English)
- Translate summaries to user language if needed
- Preserve original titles with translations

### Social Tracking Integration

- Social posts may be in various languages
- Translate key claims to user language
- Note original language in output

### Economic Calendar Integration

- Calendar events are typically in English
- Translate event names and descriptions
- Provide localized event context

## Best Practices

### Do's

1. **Always detect language first** before generating summaries
2. **Use explicit language instructions** in prompts
3. **Verify response language** before returning to user
4. **Provide translations** for technical financial terms
5. **Maintain consistency** across all output sections

### Don'ts

1. **Don't assume English** as default without detection
2. **Don't mix languages** in a single response
3. **Don't skip verification** even for high-confidence detections
4. **Don't ignore user preferences** if explicitly stated
5. **Don't translate proper nouns** (company names, tickers)

## Error Handling

| Error Type | Action | Fallback |
|------------|--------|----------|
| Detection failure | Default to English | Log warning |
| Translation failure | Return original with note | Accept mismatch |
| Multiple languages detected | Use dominant language | Ask user for preference |
| Low confidence detection | Default to English | Request clarification |

## Vietnamese Language Support

### Vietnamese Language Detection

**Vietnamese Detection Patterns:**

| Pattern Type | Description | Examples |
|--------------|-------------|----------|
| **Vietnamese Diacritics** | Characters with tone marks | á, à, ả, ã, ạ, ă, â, đ, ê, ô, ơ, ư |
| **Vietnamese Vowels** | Vietnamese-specific vowel combinations | ă, â, ê, ô, ơ, ư |
| **Vietnamese Tone Marks** | Six tone marks on vowels | á (acute), à (grave), ả (hook), ã (tilde), ạ (dot), ă (breve) |
| **Vietnamese Function Words** | Common Vietnamese words | của, và, là, cho, này, không, có, được, với, từ |
| **Vietnamese Grammar** | Vietnamese sentence structure | Subject-Verb-Object, no articles |

**Vietnamese Detection Algorithm:**

```javascript
const detectVietnamese = (text) => {
  // Check for Vietnamese diacritics
  const vietnameseDiacritics = /[ăâđêôơư]/i;
  const vietnameseToneMarks = /[áàảãạấầẩẫậắằẳẵặéèẻẽẹếềểễệíìỉĩịóòỏõọốồổỗộớờởỡợúùủũụứừửữựýỳỷỹỵ]/i;
  
  // Check for Vietnamese function words
  const vietnameseFunctionWords = /\b(của|và|là|cho|này|không|có|được|với|từ|trên|trong|cho|nhưng|vì|nên)\b/i;
  
  // Calculate scores
  const diacriticScore = (text.match(vietnameseDiacritics) || []).length;
  const toneMarkScore = (text.match(vietnameseToneMarks) || []).length;
  const functionWordScore = (text.match(vietnameseFunctionWords) || []).length;
  
  // Calculate confidence
  const totalScore = diacriticScore + toneMarkScore + (functionWordScore * 2);
  const confidence = Math.min(totalScore / (text.length / 10), 1);
  
  return {
    language: 'vi',
    confidence: confidence,
    scores: {
      diacritics: diacriticScore,
      toneMarks: toneMarkScore,
      functionWords: functionWordScore
    }
  };
};
```

### Vietnamese Language Injection

**Vietnamese System Prompt Injection:**

```markdown
QUAN TRỌNG: Bạn PHẢI trả lời bằng tiếng Việt. Tất cả tóm tắt, phân tích và nhận xét
phải được viết bằng tiếng Việt. Không được sử dụng tiếng Anh hoặc tiếng Trung.

Yêu cầu ngôn ngữ:
- Tất cả nội dung phải bằng tiếng Việt
- Sử dụng thuật ngữ tài chính tiếng Việt phù hợp
- Giữ giọng văn chuyên nghiệp
- Bao gồm các thông tin chính và tác động thị trường
```

**Vietnamese User Message Context:**

```json
{
  "language_context": {
    "detected_language": "vi",
    "confidence": 0.95,
    "instruction": "Tóm tắt tin tức tài chính sau bằng tiếng Việt",
    "vietnamese_language_verified": true
  }
}
```

**Vietnamese Summarization Prompt Template:**

```markdown
## Yêu cầu ngôn ngữ
- Ngôn ngữ được phát hiện: {detected_language}
- Bạn PHẢI viết tất cả tóm tắt bằng: {language_name}
- Thuật ngữ tài chính nên sử dụng thuật ngữ {language_name}

## Nhiệm vụ tóm tắt
Tóm tắt các bài báo tin tức tài chính sau bằng {language_name}:
{articles}

## Yêu cầu đầu ra
1. Tất cả văn bản phải bằng {language_name}
2. Sử dụng thuật ngữ tài chính phù hợp cho {language_name}
3. Giữ giọng văn chuyên nghiệp
4. Bao gồm các thông tin chính và tác động thị trường
```

### Vietnamese Language Verification

**Vietnamese Response Verification:**

```javascript
const verifyVietnamese = (response) => {
  // Check for Vietnamese diacritics
  const vietnameseDiacritics = /[ăâđêôơư]/i;
  const vietnameseToneMarks = /[áàảãạấầẩẫậắằẳẵặéèẻẽẹếềểễệíìỉĩịóòỏõọốồổỗộớờởỡợúùủũụứừửữựýỳỷỹỵ]/i;
  
  // Check for Vietnamese function words
  const vietnameseFunctionWords = /\b(của|và|là|cho|này|không|có|được|với|từ|trên|trong|cho|nhưng|vì|nên)\b/i;
  
  // Calculate scores
  const diacriticScore = (response.match(vietnameseDiacritics) || []).length;
  const toneMarkScore = (response.match(vietnameseToneMarks) || []).length;
  const functionWordScore = (response.match(vietnameseFunctionWords) || []).length;
  
  // Calculate confidence
  const totalScore = diacriticScore + toneMarkScore + (functionWordScore * 2);
  const confidence = Math.min(totalScore / (response.length / 10), 1);
  
  return {
    language: 'vi',
    confidence: confidence,
    match: confidence > 0.7,
    scores: {
      diacritics: diacriticScore,
      toneMarks: toneMarkScore,
      functionWords: functionWordScore
    }
  };
};
```

**Vietnamese Language Verification Output:**

```json
{
  "vietnamese_language_verification": {
    "input_language": "vi",
    "response_language": "vi",
    "match": true,
    "confidence": 0.95,
    "vietnamese_diacritics_detected": true,
    "vietnamese_tone_marks_detected": true,
    "vietnamese_function_words_detected": true,
    "action": "accept"
  }
}
```

**Vietnamese Mismatch Output:**

```json
{
  "vietnamese_language_verification": {
    "input_language": "vi",
    "response_language": "en",
    "match": false,
    "confidence": 0.15,
    "vietnamese_diacritics_detected": false,
    "vietnamese_tone_marks_detected": false,
    "vietnamese_function_words_detected": false,
    "action": "retry",
    "retry_count": 1,
    "max_retries": 2
  }
}
```

### Vietnamese Language-Specific Terminology

**Vietnamese Financial Terms (Extended):**

| English | Vietnamese | Context |
|---------|------------|---------|
| Stock market | Thị trường chứng khoán | General market |
| VN-Index | Chỉ số VN-Index | Main Vietnamese index |
| VN30 | Chỉ số VN30 | Vietnamese bluechip index |
| HNX-Index | Chỉ số HNX-Index | Hanoi exchange index |
| UPCoM | Chỉ số UPCoM | Unlisted public company market |
| Interest rate | Lãi suất | Monetary policy |
| Exchange rate | Tỷ giá | Currency markets |
| Inflation | Lạm phát | Economic indicator |
| GDP | Tổng sản phẩm quốc nội | Economic output |
| Bond | Trái phiếu | Fixed income |
| Central bank | Ngân hàng trung ương | SBV |
| Monetary policy | Chính sách tiền tệ | SBV policy |
| Fiscal policy | Chính sách tài khóa | Government policy |
| Dividend | Cổ tức | Corporate action |
| Earnings | Lợi nhuận | Corporate results |
| Revenue | Doanh thu | Corporate income |
| Market cap | Vốn hóa thị trường | Market valuation |
| Bull market | Thị trường tăng | Uptrend |
| Bear market | Thị trường giảm | Downtrend |
| Volatility | Biến động | Price movement |
| Liquidity | Thanh khoản | Trading volume |
| Foreign investor | Nhà đầu tư nước ngoài | FDI/FII |
| Foreign ownership limit | Giới hạn sở hữu nước ngoài | FOL |
| Margin trading | Giao dịch ký quỹ | Leverage trading |
| Price band | Biên độ giá | Daily limit |
| Bluechip | Cổ phiếu vốn hóa lớn | Large-cap stocks |
| Midcap | Cổ phiếu vốn hóa trung bình | Mid-cap stocks |
| Smallcap | Cổ phiếu vốn hóa nhỏ | Small-cap stocks |
| Support | Mức hỗ trợ | Technical level |
| Resistance | Mức kháng cự | Technical level |
| Breakout | Phá vỡ | Price movement |
| Correction | Điều chỉnh | Price movement |
| Consolidation | Tích lũy | Price pattern |
| Trend | Xu hướng | Direction |
| Momentum | Động lượng | Indicator |
| Volume | Khối lượng | Trading activity |

### Vietnamese Language Mismatch Handling

**Vietnamese Retry Strategy:**

```markdown
QUAN TRỌNG: Câu trả lời trước của bạn bằng tiếng Anh, nhưng người dùng yêu cầu bằng tiếng Việt.
Bạn PHẢI viết lại toàn bộ câu trả lời bằng tiếng Việt.
KHÔNG được sử dụng tiếng Anh trong bất kỳ trường hợp nào.

Viết lại câu trả lời của bạn bằng tiếng Việt:
```

**Vietnamese Translation Strategy:**

```javascript
const translateToVietnamese = async (text) => {
  // Use translation model or API
  const translated = await translate(text, { to: 'vi' });
  
  // Verify Vietnamese diacritics and tone marks
  const verified = verifyVietnamese(translated);
  
  if (!verified.match) {
    // Retry with stronger Vietnamese instruction
    return await translateWithVietnameseInstruction(text);
  }
  
  return translated;
};
```

**Vietnamese Accept with Warning:**

```json
{
  "warning": "Câu trả lời có thể chứa ngôn ngữ hỗn hợp",
  "original_language": "en",
  "detected_language": "en",
  "target_language": "vi",
  "action": "accepted_with_warning",
  "vietnamese_language_support": "partial"
}
```

### Vietnamese Language Best Practices

**Vietnamese Language Do's:**

1. **Luôn phát hiện ngôn ngữ tiếng Việt trước** khi tạo tóm tắt
2. **Sử dụng hướng dẫn ngôn ngữ tiếng Việt rõ ràng** trong lời nhắc
3. **Xác minh ngôn ngữ tiếng Việt** trước khi trả về cho người dùng
4. **Cung cấp bản dịch** cho các thuật ngữ tài chính kỹ thuật
5. **Duy trì tính nhất quán** trên tất cả các phần đầu ra
6. **Giữ nguyên các dấu câu tiếng Việt** và dấu thanh
7. **Sử dụng thuật ngữ tài chính tiếng Việt chuẩn**

**Vietnamese Language Don'ts:**

1. **Không giả định tiếng Anh** làm mặc định mà không phát hiện
2. **Không trộn lẫn ngôn ngữ** trong một câu trả lời
3. **Không bỏ qua xác minh** ngay cả khi phát hiện độ tin cậy cao
4. **Không bỏ qua sở thích của người dùng** nếu được nêu rõ
5. **Không dịch danh từ riêng** (tên công ty, mã chứng khoán)
6. **Không bỏ qua dấu câu tiếng Việt** và dấu thanh
7. **Không sử dụng tiếng Anh** khi người dùng yêu cầu tiếng Việt

### Vietnamese Language Error Handling

| Error Type | Action | Fallback |
|------------|--------|----------|
| Vietnamese detection failure | Default to English | Log warning |
| Vietnamese translation failure | Return original with note | Accept mismatch |
| Vietnamese multiple languages detected | Use dominant language | Ask user for preference |
| Vietnamese low confidence detection | Default to English | Request clarification |
| Vietnamese diacritics missing | Retry with diacritics instruction | Accept with warning |
| Vietnamese tone marks missing | Retry with tone marks instruction | Accept with warning |