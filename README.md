# AI Skills Repository

A collection of AI agent skills for financial analysis, market data processing, visualization, and trading system development.

## Overview

This repository contains modular skills for building AI-powered financial analysis applications. Each skill is designed to be:
- **Self-contained** with clear activation criteria
- **Well-documented** with detailed examples
- **Performant** with benchmarks and optimization strategies
- **Secure** with proper error handling and data validation

## Available Skills

### Charting & Visualization

| Skill | Description | Dependencies |
|-------|-------------|--------------|
| **chart-image** | TradingView-style chart generation | image-processing-chat, data-viz |
| **data-viz** | Comprehensive data visualization dashboards | chart-image, image-processing-chat |
| **image-processing-chat** | Image handling for chat AI interactions | (none - foundational) |

### Market Analysis

| Skill | Description | Dependencies |
|-------|-------------|--------------|
| **us-financial-market-analysis** | US market analysis with intermarket relationships | chart-image, data-viz, vietnam-stock-analysis |
| **vietnam-stock-analysis** | Vietnamese stock market analysis | chart-image, data-viz, us-financial-market-analysis |

### Trading Code

| Skill | Description | Dependencies |
|-------|-------------|--------------|
| **mql5-patterns** | MQL5 Expert Advisor patterns | us-financial-market-analysis, vietnam-stock-analysis |
| **mql4-patterns** | MQL4 Expert Advisor patterns | us-financial-market-analysis, vietnam-stock-analysis |

### News & Data

| Skill | Description | Dependencies |
|-------|-------------|--------------|
| **finance-news-pinchtab** | Finance news aggregation with PinchTab | chart-image, data-viz |

## Quick Start

### For US Market Analysis
```bash
# Use us-financial-market-analysis for comprehensive US market analysis
# Depends on: chart-image, data-viz, vietnam-stock-analysis
```

### For Vietnamese Market Analysis
```bash
# Use vietnam-stock-analysis for Vietnamese stock market
# Depends on: chart-image, data-viz, us-financial-market-analysis
```

### For News Aggregation
```bash
# Use finance-news-pinchtab for financial news scraping
# Depends on: chart-image, data-viz
```

### For Trading Bot Development
```bash
# Use mql5-patterns (MQL5) or mql4-patterns (MQL4)
# Depends on: us-financial-market-analysis, vietnam-stock-analysis
```

## Architecture

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        SKILL ARCHITECTURE                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Layer 1: Data Collection (finance-news-pinchtab)                      │
│  Layer 2: Analysis Engine (us-financial-market-analysis,               │
│                          vietnam-stock-analysis)                        │
│  Layer 3: Visualization (chart-image, data-viz)                        │
│  Layer 4: Trading Code (mql5-patterns, mql4-patterns)                  │
│  Layer 5: Chat Integration (image-processing-chat)                     │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## Cross-References

For detailed skill dependencies and integration guidance, see:
- [SKILLS-CROSS-REFERENCES.md](./SKILLS-CROSS-REFERENCES.md) - Full dependency matrix and usage map

## External API Dependencies

| Skill | APIs Used | Authentication |
|-------|-----------|----------------|
| image-processing-chat | OpenAI, Zhipu AI, Anthropic, Google | API keys |
| us-financial-market-analysis | Alpha Vantage, Yahoo Finance, FRED, BLS | API keys |
| vietnam-stock-analysis | DStock VNDIRECT (PinchTab) | Web scraping |
| finance-news-pinchtab | PinchTab, Investing.com, RSS feeds | Web scraping |

## Security

All skills include:
- Input validation and sanitization
- Error handling and logging
- Rate limiting guidance
- API key management best practices
- Data privacy considerations

## Performance

Benchmarks are included in each skill's documentation:

| Skill | Typical Latency | Memory Usage |
|-------|----------------|--------------|
| image-processing-chat | 1.5-5s | 300-800MB |
| chart-image | 150ms-1.2s | 30-150MB |
| data-viz | 100ms-2s | 20-500MB |
| us-financial-market-analysis | 500ms-10s | 100MB-1GB |
| vietnam-stock-analysis | 500ms-5s | 100MB-500MB |
| finance-news-pinchtab | 10s-60s | 200MB-1.5GB |

## Development

### Adding New Skills

1. Create new skill in `/path/to/skill/SKILL.md`
2. Add activation criteria and workflow
3. Include dependencies section
4. Add performance benchmarks
5. Include security considerations

### Running Skills

Each skill is a standalone file that can be:
- Imported into your AI application
- Used as reference for implementation
- Modified for specific use cases

## Documentation

Each skill includes:
- Detailed activation criteria
- Workflow diagrams
- Usage examples
- Error handling guidance
- Performance benchmarks
- Security best practices

## Contributing

1. Follow existing skill structure
2. Include security best practices
3. Add performance benchmarks
4. Document dependencies clearly
5. Test with real data

## License

This repository contains proprietary information for internal use.
