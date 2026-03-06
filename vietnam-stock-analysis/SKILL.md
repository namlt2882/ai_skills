---
name: vietnam-stock-analysis
description: Vietnamese stock analysis focused on bluechip coverage, market regime assessment, and technical indicators with calm, non-panic advisory language.
---

# Vietnamese Stock Analysis

Provide structured analysis of Vietnamese equities with emphasis on **bluechip coverage**, **market regime assessment**, and **technical indicator interpretation**. Responses must be **calm, non-panic**, and tailored to the user's **positions, horizon, risk tolerance, and experience level**.

## When to Use

Use this skill when the user asks for:

- Analysis of Vietnamese stocks (VN30, large-cap bluechips, sector leaders).
- Market regime assessment (risk-on/off, trend, volatility regime, liquidity conditions).
- Technical indicator interpretation (MA, RSI, MACD, volume/OBV, support/resistance).
- Portfolio-aware guidance for Vietnamese equity positions.
- You need to fetch prices or specific information about Vietnamese stocks/indices.

## Activation Criteria

Trigger this skill when user intent includes any of the following:

- Vietnamese equities or indices: "VN-Index", "VN30", "HNX", "UPCoM", "cổ phiếu", "chứng khoán Việt Nam".
- Bluechip focus: "bluechip", "VN30", "large-cap", "cổ phiếu vốn hóa lớn".
- Market regime questions: "xu hướng", "regime", "risk-on", "risk-off", "biến động", "thanh khoản".
- Technical indicators: "RSI", "MACD", "MA", "EMA", "SMA", "OBV", "volume", "hỗ trợ/kháng cự".

**Note**: For US financial market analysis including intermarket relationships, risk assets correlation, technical indicators, and macroeconomic factors, use the [`us-financial-market-analysis`](../us-financial-market-analysis/SKILL.md) skill instead.

If the request explicitly requires **news data**, you MUST trigger the [`pinchtab-web-automation`](../pinchtab-web-automation/SKILL.md) skill first and follow its workflow to gather sources before analysis.

If market/stock/index data is required, you MUST use PinchTab to fetch **official data from DStock VNDIRECT**:
- General market/index/sector overview: https://dstock.vndirect.com.vn/
- Specific ticker details (profile, shareholders, dividends, price data, etc.): https://dstock.vndirect.com.vn/tong-quan/<ticker>

## Required Analysis Sections

All outputs MUST include these sections in order:

1. **Bluechip Focus**
   - Emphasize VN30/large-cap leaders.
   - Highlight relative strength vs. sector peers.
   - Note liquidity and institutional flow signals if available.

2. **Market Regime**
   - Identify regime: trending up, trending down, or range-bound.
   - Discuss volatility state (compressed, expanding) and liquidity tone.
   - Mention macro sensitivity only if user asks; avoid macro speculation otherwise.

3. **Technical Indicators**
   - Provide neutral interpretation of MA/EMA, RSI, MACD, volume/OBV.
   - Use support/resistance levels when possible.
   - Avoid overly precise predictions; focus on scenarios and thresholds.

4. **Risk Assessment (Short-Term vs Mid-Term)**
   - Provide short-term (days–weeks) risk assessment per stock/position.
   - Provide mid-term (weeks–months) risk assessment per stock/position.
   - Clarify key risk drivers and invalidation levels for each horizon.

5. **What Action Should Be Done Now**
   - Provide clear, immediate next action(s) per stock/position.
   - Tie actions to the short/mid-term risk assessment.
   - Use calm, non-panic phrasing.
   - If recommending any stock, group recommended tickers by **industry/sector**; omit industries with no recommendations.
   - If recommending any stock, include **TP (take profit)** and **SL (stop loss)** levels with rationale.
   - Confirm compliance with **Vietnam stock exchange trading rules** (price bands, lot sizes, trading session constraints, and order types).
   - Pre-calculate and state whether shares will be at a **loss upon settlement (T+2/T+3)** based on the projected entry/exit path.

## Advisory Tone Requirements (Calm, Non-Panic)

- Use steady, reassuring language.
- Avoid alarmist phrasing (e.g., "crash", "collapse", "panic").
- Frame uncertainty explicitly and offer scenario-based guidance.
- **Advice must follow the prevailing market trend and regime.**
- **Explicitly avoid bottom-fishing at any cost.**
- **If no good opportunities exist, recommend staying out of the market.**
- **Any stock recommendation must include a clear rationale, explicit macro tailwinds/support, and valuation not too high (still suitable for speculative/trading).**
- Tailor advice to the user's profile:
  - **Conservative**: emphasize risk control and position sizing.
  - **Moderate**: emphasize balance and staged actions.
  - **Aggressive**: emphasize risk awareness and clear invalidation levels.
- If the user provides holdings, time horizon, or risk tolerance, reflect them directly in the guidance.

## Workflow Steps

1. **Parse user context**
   - Extract tickers, index references, time horizon, and risk profile.
   - If missing, infer a default (medium-term, moderate risk) and state assumptions.

2. **Check for news dependency**
   - If news/current events are required or requested, **activate** [`pinchtab-web-automation`](../pinchtab-web-automation/SKILL.md) and collect sources before analysis.
   - If not required, proceed with technical/regime analysis only.

3. **Gather market/stock data when needed**
     - When data is required, use PinchTab to fetch from DStock VNDIRECT:
       - Market/index/sector overview: https://dstock.vndirect.com.vn/
       - Ticker-specific details: https://dstock.vndirect.com.vn/tong-quan/<ticker>

4. **Assess market regime**
   - Classify trend + volatility + liquidity posture.

5. **Perform bluechip-focused analysis**
   - Emphasize VN30/large-cap stocks; compare to sector/market baseline.

6. **Review technical indicators**
   - Summarize MA/EMA, RSI, MACD, volume/OBV and key levels.

7. **Deliver calm advisory guidance**
   - Provide scenario-based actions and risk management notes.

## Knowledge Base References

This skill incorporates specialized knowledge from the following modular components:

### Core Analysis Aspects
- **[Bluechip Focus](./aspects/bluechip-focus.md)**: Detailed framework for analyzing Vietnamese bluechip stocks, particularly those in the VN30 index and other large-cap leaders
- **[Market Regime Assessment](./aspects/market-regime.md)**: Framework for assessing current market regime in Vietnamese equities, focusing on trend identification, volatility patterns, and liquidity conditions
- **[Technical Analysis](./aspects/technical-analysis.md)**: Systematic approach to interpreting technical indicators and patterns specifically for Vietnamese equities
- **[Risk Assessment](./aspects/risk-assessment.md)**: Framework for evaluating and quantifying risks in Vietnamese equities across different time horizons
- **[Trading Recommendations](./aspects/trading-recommendations.md)**: Guidelines for generating actionable trading recommendations incorporating technical, fundamental, and risk considerations
- **[Regulatory Compliance](./aspects/regulatory-compliance.md)**: Requirements to ensure all trading recommendations and analysis comply with Vietnamese securities regulations

### Supporting Documentation
- **[Company Analysis Framework](./docs/company-analysis.md)**: Comprehensive approach to analyzing Vietnamese companies with focus on bluechip stocks
- **[Market Overview](./docs/market-overview.md)**: Understanding of Vietnamese stock market structure, participants, and operational characteristics
- **[Technical Indicators Guide](./docs/technical-indicators-vn.md)**: Technical indicators specifically adapted for Vietnamese market characteristics
- **[Data Sources Reference](./references/data-sources-vn.md)**: Reliable data sources for Vietnamese financial markets including official exchanges and research resources

## Constraints

- Do not fabricate news or corporate events. If news is needed, use PinchTab via the required skill.
- Do not fabricate market/stock/index data. Use PinchTab to fetch DStock VNDIRECT data from:
   - https://dstock.vndirect.com.vn/ for general market/index/sector information.
   - https://dstock.vndirect.com.vn/tong-quan/<ticker> for ticker-specific details (profile, shareholders, dividends, price data, etc.).
- Do not give definitive price targets or certainty language.
- Avoid recommendations that imply guaranteed outcomes.
- **Advice must follow the current market trend and regime; no counter-trend bottom-fishing.**
- **If no good opportunities exist, advise staying out of the market rather than forcing a trade.**
- **For any stock recommendation, explicitly include: (1) clear rationale, (2) macro tailwinds/support, and (3) valuation not too high (still suitable for speculative/trading).**
- **For any stock recommendation, explicitly include TP (take profit) and SL (stop loss) with clear rationale and risk-reward framing.**
- **For any stock recommendation, group recommended tickers by industry/sector and omit industries with no recommendations.**
- **All recommendations must comply with Vietnam stock exchange trading rules (price bands, lot sizes, trading sessions, order types).**
- **Pre-calculate and state whether the position would be at a loss upon settlement (T+2/T+3) given the proposed entry/exit path.**
- Output must be deterministic: use **low-temperature / zero-variance** wording and avoid stochastic phrasing.
- Keep analysis factual, structured, and aligned to Vietnamese market context.

## Output Format

```
Vietnamese Stock Analysis

Bluechip Focus:
- ...

Market Regime:
- ...

Technical Indicators:
- MA/EMA: ...
- RSI: ...
- MACD: ...
- Volume/OBV: ...
- Support/Resistance: ...

Risk Assessment (Short-Term vs Mid-Term):
- Short-Term (days–weeks): ...
- Mid-Term (weeks–months): ...

What Action Should Be Done Now:
- ...
- If recommending any stock, format recommendations grouped by **Industry/Sector**:
  - Industry/Sector Name:
    - TICKER: rationale, macro tailwinds/support, valuation not too high; TP/SL; compliance with trading rules; settlement loss check (T+2/T+3)
  - (Omit any industries with no recommendations.)
- Provide TP (take profit) and SL (stop loss) levels with rationale.
- State compliance with Vietnam exchange trading rules (price bands, lot sizes, trading sessions, order types).
- Pre-calculate whether shares would be at a loss upon settlement (T+2/T+3).
- If no good opportunities, state a clear "stand aside" recommendation.

Calm Advisory Notes:
- ...
- Confirm trend-following stance and reiterate avoidance of bottom-fishing.
```

## Completion Criteria

- Includes all five required analysis sections in order.
- Uses calm, non-panic advisory language.
- Mentions assumptions about user profile if not provided.
- Triggers PinchTab skill when news data is required.
- Output is deterministic with low-temperature / zero-variance wording.
- Any stock recommendation includes clear rationale, macro tailwinds/support, and valuation not too high (speculative/trading suitable).
- Any stock recommendation includes TP/SL, Vietnam trading-rule compliance, and settlement loss pre-calculation (T+2/T+3).