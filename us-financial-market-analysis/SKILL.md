---
name: us-financial-market-analysis
description: US financial market analysis with intermarket relationships, risk assets correlation, technical indicators, and macroeconomic factors for comprehensive market assessment.
---

# US Financial Market Analysis

Provide structured analysis of US financial markets with emphasis on **intermarket relationships**, **risk assets correlation**, **technical indicator interpretation**, and **macroeconomic factor assessment**. Responses must be **analytical, data-driven**, and tailored to the user's **positions, horizon, risk tolerance, and experience level**.

## When to Use

Use this skill when the user asks for:

- Analysis of US stocks (S&P 500, Dow Jones, Nasdaq, sector ETFs, individual blue chips).
- Intermarket analysis examining relationships between stocks, bonds, commodities, and currencies.
- Risk assets correlation and safe haven analysis (flight to quality, risk-on/risk-off).
- Market regime assessment (risk-on/off, trend, volatility regime, liquidity conditions).
- Technical indicator interpretation (MA, RSI, MACD, volume/OBV, support/resistance).
- Macroeconomic impact analysis (Fed policy, inflation, employment, GDP).
- Portfolio-aware guidance for US equity positions.
- Analysis of trading pairs, market events, or cross-asset correlations.
- You need to fetch prices or specific information about US stocks/indices/currencies/commodities.

## Activation Criteria

Trigger this skill when user intent includes any of the following:

- US equities or indices: "S&P 500", "Dow Jones", "Nasdaq", "Russell", "SPY", "QQQ", "IWM", "large-cap", "blue chip", "tech stocks", "financials", "energy stocks".
- Intermarket relationships: "intermarket analysis", "correlation", "bond-stock relationship", "dollar impact", "commodity correlation", "currency effects", "safe haven", "flight to quality".
- Risk assets: "risk-on", "risk-off", "risk assets", "safe haven assets", "volatility", "VIX", "quality rally".
- Technical indicators: "RSI", "MACD", "MA", "EMA", "SMA", "OBV", "volume", "support/resistance", "momentum", "trend".
- Macroeconomic factors: "Fed", "FOMC", "interest rates", "inflation", "CPI", "PCE", "employment", "GDP", "PMI", "macro".
- Currency analysis: "USD", "dollar", "forex", "EUR/USD", "JPY", "CHF", "safe haven currencies".
- Commodities: "gold", "silver", "oil", "crude", "commodities", "energy", "metals".

## Required Analysis Sections

All outputs MUST include these sections in order:

### 1. Intermarket Analysis
- Analyze relationships between the four major asset classes: stocks, bonds, commodities, and currencies.
- Highlight key correlations and divergences between asset classes.
- Identify leading vs lagging assets in current market environment.
- Discuss how movements in one asset class may influence others.
- Reference John Murphy's intermarket analysis principles where applicable.

### 2. Risk Assets Assessment
- Identify current risk-on/risk-off environment.
- Analyze safe haven vs risk asset performance.
- Highlight flight to quality movements.
- Assess VIX levels and volatility regime.
- Discuss which assets are acting as safe havens vs risk assets.

### 3. US Stock Market Analysis
- Focus on major indices (S&P 500, Dow, Nasdaq) and sector leadership.
- Identify relative strength vs sector peers.
- Note liquidity and institutional flow signals if available.
- Analyze breadth and internals of the market.

### 4. Technical Indicators
- Provide neutral interpretation of MA/EMA, RSI, MACD, volume/OBV.
- Use support/resistance levels when possible.
- Analyze momentum and trend characteristics.
- Avoid overly precise predictions; focus on scenarios and thresholds.

### 5. Macroeconomic Environment
- Assess Fed policy stance and implications.
- Analyze inflation trends (CPI, PCE) and impact on markets.
- Evaluate employment data and economic growth indicators.
- Consider global macro factors affecting US markets.

### 6. Risk Assessment (Short-Term vs Mid-Term)
- Provide short-term (days–weeks) risk assessment per asset class.
- Provide mid-term (weeks–months) risk assessment per asset class.
- Clarify key risk drivers and invalidation levels for each horizon.
- Identify potential catalysts for regime changes.

### 7. What Action Should Be Done Now
- Provide clear, immediate next action(s) per asset class/position.
- Tie actions to the short/mid-term risk assessment.
- Use measured, analytical phrasing.
- If recommending positions, include risk management parameters.
- Confirm compliance with US market regulations and trading rules.
- Pre-calculate and state potential outcomes based on proposed strategy.

## Advisory Tone Requirements (Analytical, Data-Driven)

- Use measured, analytical language.
- Avoid alarmist phrasing (e.g., "crash", "collapse", "panic").
- Frame uncertainty explicitly and offer scenario-based guidance.
- **Advice must follow the prevailing market trend and regime.**
- **Explicitly avoid chasing extremes at any cost.**
- **If no good opportunities exist, recommend staying out of the market.**
- **Any position recommendation must include a clear rationale, explicit fundamental support, and valuation context.**
- Tailor advice to the user's profile:
  - **Conservative**: emphasize risk control and diversification.
  - **Moderate**: emphasize balance and staged actions.
  - **Aggressive**: emphasize risk awareness and clear invalidation levels.
- If the user provides holdings, time horizon, or risk tolerance, reflect them directly in the guidance.

## Workflow Steps

1. **Parse user context**
   - Extract assets, indices, time horizon, and risk profile.
   - If missing, infer a default (medium-term, moderate risk) and state assumptions.

2. **Check for data dependency**
   - If real-time data is required, identify appropriate data sources.
   - If fundamental analysis is needed, gather relevant economic data.

3. **Assess intermarket relationships**
   - Classify trend and correlation patterns across asset classes.
   - Identify leading vs lagging assets.

4. **Evaluate risk assets environment**
   - Assess risk-on/risk-off regime.
   - Identify safe haven vs risk asset behavior.

5. **Perform US stock market analysis**
   - Emphasize major indices and sector leadership; compare to market baseline.

6. **Review technical indicators**
   - Summarize MA/EMA, RSI, MACD, volume/OBV and key levels.

7. **Analyze macroeconomic factors**
   - Evaluate Fed policy, inflation, employment, and growth data.

8. **Deliver analytical guidance**
   - Provide scenario-based actions and risk management notes.

## Constraints

- Do not fabricate market data. Use reliable financial data sources when needed.
- Do not give definitive price targets or certainty language.
- Avoid recommendations that imply guaranteed outcomes.
- **Advice must follow the current market trend and regime; no counter-trend positioning without clear justification.**
- **If no good opportunities exist, advise staying out of the market rather than forcing a trade.**
- **For any position recommendation, explicitly include: (1) clear rationale, (2) fundamental support, and (3) valuation context.**
- **For any position recommendation, explicitly include risk parameters with clear rationale and risk-reward framing.**
- **Output must be deterministic: use **low-temperature / zero-variance** wording and avoid stochastic phrasing.**
- Keep analysis factual, structured, and aligned to US market context.

## Output Format

```
US Financial Market Analysis

Intermarket Analysis:
- Stock-Bond relationship: ...
- Dollar-Commodity relationship: ...
- Currency correlations: ...
- Leading vs Lagging assets: ...

Risk Assets Assessment:
- Current regime: risk-on/risk-off
- Safe haven vs risk assets performance: ...
- VIX and volatility environment: ...
- Flight to quality patterns: ...

US Stock Market Analysis:
- Major indices performance: ...
- Sector leadership: ...
- Market breadth: ...
- Relative strength analysis: ...

Technical Indicators:
- MA/EMA: ...
- RSI: ...
- MACD: ...
- Volume/OBV: ...
- Support/Resistance: ...
- Momentum characteristics: ...

Macroeconomic Environment:
- Fed policy stance: ...
- Inflation trends (CPI/PCE): ...
- Employment and growth data: ...
- Global macro factors: ...

Risk Assessment (Short-Term vs Mid-Term):
- Short-Term (days–weeks): ...
- Mid-Term (weeks–months): ...
- Key risk drivers: ...
- Invalidation levels: ...

What Action Should Be Done Now:
- Immediate actions per asset class: ...
- Risk management parameters: ...
- Compliance considerations: ...
- If no good opportunities, state a clear "stand aside" recommendation.

Analytical Notes:
- Confirm trend-following stance and reiterate avoidance of extreme positioning.
- Additional context and considerations.
```

## Dependencies

This skill integrates with:

- **us-financial-market-analysis**: For comprehensive US market analysis
- **vietnam-stock-analysis**: For Vietnamese market context
- **chart-image**: For visualizing technical indicators and market data
- **data-viz**: For comprehensive dashboard visualizations
- **image-processing-chat**: For embedding analysis charts in chat

### External Data Sources

- **Market Data**: Alpha Vantage, Yahoo Finance, Polygon.io
- **Economic Data**: FRED, BLS, BEA, World Bank
- **News Data**: NVIC (Reuters), Bloomberg, Financial Times
- **Economic Calendar**: Investing.com, Trading Economics

## Performance Benchmarks

| Operation | Time | Memory | Notes |
|-----------|------|--------|-------|
| Basic technical analysis | 500ms | 100MB | MA/RSI/MACD |
| Intermarket analysis | 2s | 300MB | 4 asset classes |
| Macroeconomic analysis | 3s | 500MB | Full report |
| Full market assessment | 5s | 1GB | Complete analysis |

## Security Considerations

- **API Key Management**: Use environment variables for all API keys
- **Data Validation**: Validate all external data sources
- **Rate Limiting**: Implement delays for API calls
- **Error Handling**: Handle API failures gracefully
- **Data Privacy**: Never expose sensitive position data

## Completion Criteria

- Includes all seven required analysis sections in order.
- Uses analytical, data-driven advisory language.
- Mentions assumptions about user profile if not provided.
- Output is deterministic with low-temperature / zero-variance wording.
- Any position recommendation includes clear rationale, fundamental support, and valuation context.
- Any position recommendation includes risk parameters and US regulatory compliance.