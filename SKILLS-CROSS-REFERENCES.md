# AI Skills Cross-Reference Map

This document maps all skills in the ai_skills repository and their dependencies.

## Skill Categories

### 📊 Charting & Visualization

| Skill | Purpose | Key Dependencies |
|-------|---------|------------------|
| **chart-image** | Chart generation with TradingView styling | image-processing-chat, data-viz |
| **data-viz** | Comprehensive data visualization dashboards | chart-image, image-processing-chat |
| **image-processing-chat** | Image handling for chat AI interactions | (none - foundational) |

### 📈 Market Analysis

| Skill | Purpose | Key Dependencies |
|-------|---------|------------------|
| **us-financial-market-analysis** | US market analysis with intermarket relationships | chart-image, data-viz, vietnam-stock-analysis |
| **vietnam-stock-analysis** | Vietnamese stock market analysis | chart-image, data-viz, us-financial-market-analysis |

### 💱 Trading Code

| Skill | Purpose | Key Dependencies |
|-------|---------|------------------|
| **mql5-patterns** | MQL5 Expert Advisor patterns | us-financial-market-analysis, vietnam-stock-analysis |
| **mql4-patterns** | MQL4 Expert Advisor patterns | us-financial-market-analysis, vietnam-stock-analysis |

### 📰 News & Data

| Skill | Purpose | Key Dependencies |
|-------|---------|------------------|
| **finance-news-pinchtab** | Finance news aggregation with PinchTab | (none - foundational) |

## Full Dependency Matrix

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              CHAIN OF DEPENDENCIES                      │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  image-processing-chat                                                  │
│       │                                                                    │
│       ├─► chart-image ──────┐                                            │
│       │         │           │                                            │
│       │         ├─► data-viz ──┤                                         │
│       │                        │                                         │
│       │                        ├─► us-financial-market-analysis         │
│       │                        │         │                                │
│       │                        │         ├─► vietnam-stock-analysis     │
│       │                        │         │                                │
│       │                        │         ├─► mql5-patterns              │
│       │                        │         │                                │
│       │                        │         └─► mql4-patterns              │
│       │                                                                   │
│       └─► vietnam-stock-analysis                                        │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          DATA FLOW LAYERS                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Layer 1: Raw Data (finance-news-pinchtab)                             │
│  - News scraping                                                        │
│  - Economic calendar                                                     │
│  - Social media tracking                                                 │
│                                                                         │
│  Layer 2: Analysis Engine (us-financial-market-analysis,               │
│                          vietnam-stock-analysis)                        │
│  - Technical analysis                                                    │
│  - Market regime detection                                              │
│  - Risk assessment                                                       │
│                                                                         │
│  Layer 3: Visualization (chart-image, data-viz)                        │
│  - Chart generation                                                      │
│  - Dashboard creation                                                    │
│  - Image optimization                                                    │
│                                                                         │
│  Layer 4: Trading Code (mql5-patterns, mql4-patterns)                  │
│  - EA implementations                                                    │
│  - Indicator development                                                 │
│  - Strategy optimization                                                 │
│                                                                         │
│  Layer 5: Chat Integration (image-processing-chat)                     │
│  - Image rendering                                                       │
│  - Multi-model fallback                                                  │
│  - Performance optimization                                              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Skill Usage Recommendations

### For US Market Analysis
1. Use `us-financial-market-analysis` for comprehensive analysis
2. Use `chart-image` to generate TradingView-style charts
3. Use `data-viz` for dashboard-style visualizations
4. Use `image-processing-chat` to embed in chat interfaces

### For Vietnamese Market Analysis
1. Use `vietnam-stock-analysis` for comprehensive analysis
2. Use `chart-image` with VN30 data
3. Use `finance-news-pinchtab` for news data
4. Use `image-processing-chat` for chat integration

### For Trading Bot Development
1. Use `mql5-patterns` (MQL5) or `mql4-patterns` (MQL4)
2. Integrate with `us-financial-market-analysis` for market context
3. Use `vietnam-stock-analysis` for Vietnamese market patterns
4. Use `chart-image` for backtesting visualization

### For News Analysis
1. Use `finance-news-pinchtab` for news aggregation
2. Use `us-financial-market-analysis` for market impact assessment
3. Use `vietnam-stock-analysis` for Vietnamese market impact
4. Use `chart-image` to visualize news impact on price action

## External API Dependencies

| Skill | APIs Used | Authentication Method |
|-------|-----------|----------------------|
| us-financial-market-analysis | Alpha Vantage, Yahoo Finance, FRED, BLS | API keys |
| vietnam-stock-analysis | DStock VNDIRECT (PinchTab) | Web scraping |
| image-processing-chat | OpenAI, Zhipu AI, Anthropic, Google | API keys |
| mql5-patterns | MT5 Platform | Local installation |
| mql4-patterns | MT4 Platform | Local installation |
| finance-news-pinchtab | PinchTab, Investing.com, RSS feeds | Web scraping |

## Data Flow Examples

### Example 1: US Stock Analysis
```
User Request → us-financial-market-analysis
    │
    ├─► Finance Data (Alpha Vantage, FRED)
    │
    ├─► chart-image (generate candlestick + indicators)
    │
    ├─► image-processing-chat (embed in chat)
    │
    └─► Output: Analysis + Charts
```

### Example 2: Vietnamese Stock with News
```
User Request → vietnam-stock-analysis
    │
    ├─► finance-news-pinchtab (collect news)
    │
    ├─► Technical Analysis (DStock VNDIRECT)
    │
    ├─► chart-image (VN30 chart)
    │
    ├─► image-processing-chat (embed)
    │
    └─► Output: News Impact + Charts + Recommendations
```

### Example 3: Trading Bot Development
```
User Request → mql5-patterns
    │
    ├─► us-financial-market-analysis (market context)
    │
    ├─► vietnam-stock-analysis (Vietnamese patterns)
    │
    ├─► chart-image (strategy visualization)
    │
    └─► Output: MQL5 EA Code with Market Context
```

## Version Compatibility Matrix

| Feature | iamge-processing-chat | chart-image | data-viz | us-financial-market-analysis | vietnam-stock-analysis | mql5-patterns | mql4-patterns |
|---------|----------------------|-------------|----------|----------------------------|-----------------------|---------------|---------------|
| Python 3.7+ | ✓ | ✓ | ✓ | - | - | - | - |
| MT4/MQ4 | - | - | - | - | - | - | ✓ |
| MT5/MQ5 | - | - | - | - | - | ✓ | - |
| PinchTab | - | - | - | - | ✓ | - | - |
| OpenAI API | ✓ | - | - | - | - | - | - |

## Migration Path

### From MQL4 to MQL5
1. Use `mql4-patterns` current implementation
2. Review `mql5-patterns` differences section
3. Use `us-financial-market-analysis` for updated market context
4. Test with `chart-image` for visual comparison

### From Manual to Automated Analysis
1. Use `finance-news-pinchtab` for news aggregation
2. Use `us-financial-market-analysis` for analysis engine
3. Use `chart-image` for automated chart generation
4. Use `image-processing-chat` for chat integration

## Performance Optimization Guide

| Operation | Recommended Skill | Performance Note |
|-----------|------------------|-----------------|
| Quick chart generation | chart-image | Use PNG format, optimize=True |
| Complex dashboard | data-viz | Limit to 4 plots max |
| Full market analysis | us-financial-market-analysis | Allow 5-10s runtime |
| News aggregation | finance-news-pinchtab | Allow 10-30s runtime |
| Trading code generation | mql5-patterns/mql4-patterns | Add 1-2s for context |
| Image embedding | image-processing-chat | Use GPT-4o-mini for speed |

## Troubleshooting Matrix

| Problem | Root Cause | Solution |
|---------|-----------|----------|
| Charts not rendering | Missing image-processing-chat | Integrate with image-processing-chat skill |
| News missing from analysis | Not triggering finance-news-pinchtab | Add news trigger keywords |
| Slow performance | Complex visualization | Simplify charts, use smaller data |
| Data not updating | API rate limiting | Implement backoff, use caching |

## API Key Management

| Skill | Environment Variables |
|-------|----------------------|
| image-processing-chat | `OPENAI_API_KEY`, `ZHIPU_API_KEY`, `ANTHROPIC_API_KEY`, `GOOGLE_API_KEY` |
| us-financial-market-analysis | `ALPHA_VANTAGE_API_KEY`, `FRED_API_KEY` |
| vietnam-stock-analysis | None (uses PinchTab web scraping) |
| finance-news-pinchtab | None (uses PinchTab web scraping) |

## Conclusion

This cross-reference map helps you:
1. Understand skill dependencies
2. Choose the right skill for your use case
3. Design proper data flow
4. Optimize performance
5. Troubleshoot integration issues

For detailed skill documentation, see individual SKILL.md files.
