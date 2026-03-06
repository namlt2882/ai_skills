# Technical Indicators for News Context

## Overview

Technical indicators provide quantitative measures of market conditions that help contextualize news events. When analyzing financial news, understanding the technical backdrop helps assess whether news is likely to accelerate, reverse, or have limited impact on existing trends.

## Market Regime Classification

### Trend Regimes

| Regime | Characteristics | News Impact |
|--------|-----------------|-------------|
| **Bull Market** | Higher highs, higher lows | Positive news amplified |
| **Bear Market** | Lower highs, lower lows | Negative news amplified |
| **Sideways/Range** | Price between support/resistance | News may trigger breakout |

### Volatility Regimes

| Regime | Characteristics | News Impact |
|--------|-----------------|-------------|
| **Low Volatility** | Stable, tight ranges | News may cause larger moves |
| **High Volatility** | Wide swings, erratic | News impact less predictable |
| **Expanding** | Volatility increasing | Potential trend acceleration |
| **Contracting** | Volatility decreasing | Potential breakout setup |

### Momentum Regimes

| Regime | Characteristics | News Impact |
|--------|-----------------|-------------|
| **High Momentum** | Strong directional movement | News accelerates trend |
| **Low Momentum** | Weak movement, frequent reversals | News impact muted |
| **Diverging** | Price vs momentum disagreement | Potential reversal signal |

## Key Technical Indicators

### Moving Averages

#### Simple Moving Average (SMA)

| Period | Use Case | Signal |
|--------|----------|--------|
| 20-day | Short-term trend | Price above = bullish |
| 50-day | Intermediate trend | Price above = bullish |
| 200-day | Long-term trend | Price above = bullish |

**News Context:**
- News near key moving averages may determine trend continuation/reversal
- 50-day crossing 200-day (Golden Cross/Death Cross) is significant

#### Exponential Moving Average (EMA)

| Period | Use Case | Signal |
|--------|----------|--------|
| 12-day | Short-term momentum | Faster response to recent prices |
| 26-day | Intermediate momentum | Used with 12-day for MACD |
| 50-day | Trend following | More responsive than SMA |

**News Context:**
- EMA crossovers can signal momentum shifts
- News that contradicts EMA trend may be fade candidate

#### Moving Average Crossovers

| Signal | Description | Implication |
|--------|-------------|-------------|
| **Golden Cross** | 50-day crosses above 200-day | Bullish, major trend change |
| **Death Cross** | 50-day crosses below 200-day | Bearish, major trend change |
| **Price Cross** | Price crosses above/below MA | Short-term signal |

### Oscillators

#### Relative Strength Index (RSI)

| Level | Condition | Signal |
|-------|-----------|--------|
| > 70 | Overbought | Potential reversal lower |
| < 30 | Oversold | Potential reversal higher |
| 50 | Neutral | No clear signal |

**Divergence Analysis:**
- **Bullish divergence**: Price makes lower low, RSI makes higher low
- **Bearish divergence**: Price makes higher high, RSI makes lower high

**News Context:**
- Overbought + negative news = stronger reversal potential
- Oversold + positive news = stronger bounce potential
- Divergence + confirming news = high probability reversal

#### Moving Average Convergence Divergence (MACD)

| Component | Description | Signal |
|-----------|-------------|--------|
| **MACD Line** | 12 EMA - 26 EMA | Direction of momentum |
| **Signal Line** | 9-day EMA of MACD | Crossover trigger |
| **Histogram** | MACD - Signal | Momentum strength |

**Signals:**
- MACD crossing above signal line = Bullish
- MACD crossing below signal line = Bearish
- Histogram expanding = Momentum strengthening
- Histogram contracting = Momentum weakening

**News Context:**
- MACD crossover + confirming news = Trend continuation
- MACD divergence + contradicting news = Potential reversal

#### Stochastic Oscillator

| Level | Condition | Signal |
|-------|-----------|--------|
| > 80 | Overbought | Potential reversal |
| < 20 | Oversold | Potential bounce |
| %K crosses %D | Crossover | Direction change |

**News Context:**
- More sensitive than RSI for short-term moves
- Useful for timing news-driven entries/exits

### Volume Indicators

#### On-Balance Volume (OBV)

| Pattern | Signal | Confirmation |
|---------|--------|--------------|
| Rising OBV | Accumulation | Bullish |
| Falling OBV | Distribution | Bearish |
| OBV divergence | Potential reversal | Watch for confirmation |

**News Context:**
- High volume on news = Strong conviction
- Low volume on news = Weak conviction, potential fade
- OBV divergence + news = Potential reversal signal

#### Volume Analysis

| Volume Pattern | Interpretation | News Context |
|----------------|----------------|--------------|
| High volume up | Strong buying | Confirms positive news |
| High volume down | Strong selling | Confirms negative news |
| Low volume up | Weak buying | Questionable rally |
| Low volume down | Weak selling | Potential reversal |

### Volatility Indicators

#### Average True Range (ATR)

| ATR State | Interpretation | News Impact |
|-----------|----------------|-------------|
| Rising | Volatility increasing | Larger price moves expected |
| Falling | Volatility decreasing | Smaller price moves expected |
| Extreme high | Potential exhaustion | News may reverse trend |
| Extreme low | Potential breakout | News may trigger move |

**Position Sizing:**
- Use ATR for stop-loss placement
- Adjust position size based on volatility

#### Bollinger Bands

| Band Position | Interpretation | Signal |
|---------------|----------------|--------|
| Price at upper band | Potentially overbought | Resistance |
| Price at lower band | Potentially oversold | Support |
| Band expansion | Volatility increasing | Trend acceleration |
| Band contraction | Volatility decreasing | Breakout imminent |

**News Context:**
- News at band extremes may signal reversal
- Band squeeze + news = Potential explosive move

## Support and Resistance

### Key Levels

| Level Type | Description | News Impact |
|------------|-------------|-------------|
| **Support** | Price floor where buying emerges | Negative news may break |
| **Resistance** | Price ceiling where selling emerges | Positive news may break |
| **Psychological** | Round numbers (100, 1000) | Self-fulfilling levels |
| **Prior highs/lows** | Previous turning points | Memory levels |

### Level Significance

| Factor | Weight | Notes |
|--------|--------|-------|
| Number of touches | High | More touches = stronger level |
| Volume at level | High | High volume = significant |
| Time since test | Medium | Recent tests more relevant |
| Timeframe | High | Higher timeframe = stronger |

**News Context:**
- News that breaks key levels is significant
- Failed breakouts on news = False signal
- News at support/resistance = Decision point

## Technical Analysis in News Summaries

### Trend Context

Include technical context in news analysis:

```json
{
  "technical_context": {
    "trend": "bullish",
    "trend_strength": "strong",
    "key_levels": {
      "support": 4200,
      "resistance": 4500
    },
    "current_position": "mid-range",
    "ma_status": "above 50-day and 200-day"
  }
}
```

### Indicator Summary

Provide indicator snapshot:

```json
{
  "indicators": {
    "rsi_14": 65,
    "rsi_signal": "neutral-leaning-overbought",
    "macd": "bullish_crossover",
    "macd_signal": "momentum_positive",
    "atr": 25,
    "volatility_regime": "normal",
    "volume_trend": "above_average"
  }
}
```

### News-Technical Alignment

Assess alignment between news and technicals:

```json
{
  "news_technical_alignment": {
    "news_sentiment": "positive",
    "technical_trend": "bullish",
    "alignment": "confirmed",
    "probability": "high",
    "expected_impact": "trend_acceleration"
  }
}
```

## Practical Application

### Pre-News Technical Assessment

Before major news events:

1. **Identify trend direction**
   - Check moving averages
   - Assess higher timeframe trend

2. **Locate key levels**
   - Support and resistance
   - Prior highs/lows

3. **Check indicator readings**
   - RSI overbought/oversold
   - MACD direction
   - Volume trend

4. **Assess volatility regime**
   - ATR level
   - Bollinger Band width

### Post-News Technical Analysis

After news release:

1. **Check price reaction at key levels**
   - Did support/resistance hold?
   - Was there a breakout?

2. **Monitor volume**
   - High volume = conviction
   - Low volume = skepticism

3. **Watch for divergences**
   - Price vs indicators
   - Internal market divergences

4. **Update trend assessment**
   - Has trend changed?
   - Is momentum accelerating?

### Technical Triggers for News Alerts

Generate alerts when technical conditions align with news:

```json
{
  "technical_alert": {
    "type": "breakout_imminent",
    "indicator": "bollinger_squeeze",
    "news_catalyst": "earnings_release",
    "probability": "high",
    "direction": "unknown",
    "recommended_action": "prepare_for_breakout"
  }
}
```

## Integration with News Analysis

### News Classification by Technical Impact

| News Type | Technical Impact | Key Indicators |
|-----------|------------------|----------------|
| Earnings | High | Volume, gap, trend |
| Economic data | Medium-High | Support/resistance, trend |
| Fed decisions | High | All indicators |
| M&A news | High | Volume, gap |
| Sector news | Medium | Sector ETF technicals |

### Technical Context Tags

Tag news with technical context:

```json
{
  "technical_tags": {
    "trend_alignment": "aligned",
    "key_level_proximity": "near_resistance",
    "indicator_signals": ["rsi_overbought", "macd_bullish"],
    "volume_confirmation": "high",
    "volatility_state": "contracting"
  }
}
```

## Monitoring Checklist

### Daily Technical Check

- [ ] Major index trend (above/below 50-day, 200-day)
- [ ] RSI levels for key instruments
- [ ] MACD direction
- [ ] Volume vs average
- [ ] Key support/resistance levels

### Pre-Event Technical Assessment

- [ ] Trend direction and strength
- [ ] Proximity to key levels
- [ ] Indicator readings (RSI, MACD)
- [ ] Volatility regime
- [ ] Volume patterns

### Post-Event Technical Review

- [ ] Price reaction at levels
- [ ] Volume confirmation
- [ ] Indicator changes
- [ ] Trend status update

## Vietnamese Market Technical Adaptations

### Vietnamese Market Regime Classification

#### Vietnamese Index Trend Regimes

| Regime | Characteristics | News Impact |
|--------|-----------------|-------------|
| **VN-Index Bull Market** | Higher highs, higher lows | Positive news amplified |
| **VN-Index Bear Market** | Lower highs, lower lows | Negative news amplified |
| **VN-Index Sideways** | Range-bound, support/resistance | News may trigger breakout |
| **HNX-Index Bull/Bear** | Similar patterns to VN-Index | Regional market impact |
| **UPCoM Trending** | Smaller cap, higher volatility | Sector-specific news impact |

**Vietnamese Market Specifics:**
- Vietnamese markets often follow global trends with local nuances
- FDI flows significantly impact technical patterns
- SBV (State Bank of Vietnam) policy decisions can override technical levels
- Vietnamese market has morning (9:00-11:30) and afternoon (13:00-15:00) sessions
- Price bands (±7% for HOSE/HNX, ±15% for UPCoM) limit daily moves
- Foreign ownership limits (FOL) create supply-demand imbalances at key levels
- Vietnamese bluechips (VN30) show different technical behavior than mid/small caps

### Vietnamese Market Technical Indicators

#### Moving Averages for Vietnamese Markets

**Standard Vietnamese Market Periods:**

| Period | Use Case | Signal |
|--------|----------|--------|
| 20-day | Short-term Vietnamese trend | Price above = bullish |
| 50-day | Intermediate Vietnamese trend | Price above = bullish |
| 100-day | Long-term Vietnamese trend | Price above = bullish |
| 200-day | Very long-term Vietnamese trend | Price above = bullish |

**News Context for Vietnamese Markets:**
- News near key moving averages may determine trend continuation/reversal
- 50-day crossing 200-day is significant for Vietnamese indices
- Vietnamese market sessions (morning/afternoon) may affect MA behavior

#### Oscillators for Vietnamese Markets

**Relative Strength Index (RSI) Adaptations:**

| Level | Vietnamese Market Condition | Signal |
|-------|-----------------------------|--------|
| > 70 | Vietnamese market overbought | Potential reversal lower |
| < 30 | Vietnamese market oversold | Potential reversal higher |
| 50 | Vietnamese market neutral | No clear signal |

**Vietnamese Market Divergence Analysis:**
- **Bullish divergence**: VN-Index makes lower low, RSI makes higher low
- **Bearish divergence**: VN-Index makes higher high, RSI makes lower high

**News Context for Vietnamese Markets:**
- Overbought + negative news = stronger reversal potential in Vietnamese market
- Oversold + positive news = stronger bounce potential in Vietnamese market
- Divergence + confirming news = high probability reversal in Vietnamese market

### Vietnamese Market Volume Indicators

**On-Balance Volume (OBV) for Vietnamese Markets:**

| Pattern | Vietnamese Market Signal | Confirmation |
|---------|--------------------------|--------------|
| Rising OBV | Vietnamese accumulation | Bullish |
| Falling OBV | Vietnamese distribution | Bearish |
| OBV divergence | Vietnamese potential reversal | Watch for confirmation |

**Vietnamese Market Volume Analysis:**

| Volume Pattern | Vietnamese Market Interpretation | News Context |
|----------------|----------------------------------|--------------|
| High volume up | Strong Vietnamese buying | Confirms positive news |
| High volume down | Strong Vietnamese selling | Confirms negative news |
| Low volume up | Weak Vietnamese buying | Questionable rally |
| Low volume down | Weak Vietnamese selling | Potential reversal |

**Vietnamese Market Specifics:**
- Vietnamese market has morning and afternoon sessions affecting volume patterns
- FDI flows create distinct volume signatures in Vietnamese markets
- Local retail investor behavior differs from institutional patterns

### Vietnamese Market Support and Resistance

**Key Vietnamese Market Levels:**

| Level Type | Description | News Impact |
|------------|-------------|-------------|
| VN-Index psychological levels | 1000, 1100, 1200, etc. | Self-fulfilling levels |
| Vietnamese market session highs/lows | Morning/afternoon session levels | Memory levels |
| FDI entry/exit levels | Historical foreign investor levels | Significant levels |

**Vietnamese Market Level Significance:**

| Factor | Weight | Notes |
|--------|--------|-------|
| Number of touches | High | More touches = stronger level |
| Volume at level | High | High volume = significant |
| Time since test | Medium | Recent tests more relevant |
| FDI involvement | High | Foreign investor activity |

**News Context for Vietnamese Markets:**
- News that breaks key Vietnamese levels is significant
- Failed breakouts on news = False signal in Vietnamese market
- News at support/resistance = Decision point for Vietnamese market

### Vietnamese Market Technical Analysis in News Context

**Vietnamese Market Trend Context:**

```json
{
  "vietnamese_technical_context": {
    "vietnamese_trend": "bullish",
    "vietnamese_trend_strength": "strong",
    "vietnamese_key_levels": {
      "support": 1100,
      "resistance": 1200
    },
    "vietnamese_current_position": "mid-range",
    "vietnamese_ma_status": "above 50-day and 200-day"
  }
}
```

### Vietnamese Market Volatility Patterns

#### Vietnamese ATR Adaptations

| ATR Level | Vietnamese Market Condition | Signal |
|-----------|-----------------------------|--------|
| Low ATR (< 15) | Vietnamese market compressed | Potential breakout setup |
| Normal ATR (15-30) | Vietnamese market normal | Standard trading conditions |
| High ATR (> 30) | Vietnamese market volatile | Larger moves expected |
| Extreme ATR (> 50) | Vietnamese market panic | Potential reversal |

**Vietnamese Volatility News Context:**
- SBV policy announcements cause volatility spikes
- FDI flow announcements impact Vietnamese market volatility
- Regulatory changes (SSC, MOF) create volatility events
- Vietnamese market volatility often follows regional patterns with lag

#### Vietnamese Bollinger Band Adaptations

| Band Position | Vietnamese Market Interpretation | Signal |
|---------------|----------------------------------|--------|
| Price at upper band | Vietnamese market potentially overbought | Resistance near price band |
| Price at lower band | Vietnamese market potentially oversold | Support near price band |
| Band expansion | Vietnamese volatility increasing | Trend acceleration |
| Band contraction | Vietnamese volatility decreasing | Breakout imminent |

**Vietnamese Price Band Considerations:**
- HOSE/HNX ±7% daily limit caps price moves
- UPCoM ±15% daily limit allows larger moves
- Price band hits often trigger technical reversals
- Band squeezes before Vietnamese regulatory announcements

### Vietnamese Market Session Analysis

#### Vietnamese Trading Session Patterns

| Session | Time (ICT) | Characteristics | Volume Pattern |
|---------|------------|-----------------|----------------|
| Morning Session | 09:00-11:30 | Higher volatility, news-driven | Higher volume |
| Afternoon Session | 13:00-15:00 | Trend continuation, institutional | Moderate volume |
| Pre-Open | 08:30-09:00 | Order accumulation | Low volume |
| Pre-Close | 14:30-15:00 | Window dressing | Spike in volume |

**Vietnamese Session-Specific Technical Signals:**
- Morning session breakouts often continue into afternoon
- Afternoon session reversals less common than morning
- Vietnamese institutional activity concentrated in afternoon
- Foreign investor flows visible in afternoon session volume

### Vietnamese Market Technical Summary

```json
{
  "vietnamese_technical_summary": {
    "market_regime": "bullish",
    "vn_index_trend": "uptrend",
    "hnx_index_trend": "uptrend",
    "upcom_trend": "sideways",
    "volatility_regime": "normal",
    "session_analysis": {
      "morning_session": "bullish_breakout",
      "afternoon_session": "trend_continuation",
      "volume_pattern": "above_average"
    },
    "key_levels": {
      "vn_index_support": 1100,
      "vn_index_resistance": 1200,
      "price_band_status": "not_at_limit"
    },
    "foreign_investor_flow": "net_buying",
    "regulatory_risk": "low"
  }
}
```

### Vietnamese News-Technical Alignment

**Vietnamese Market News Impact Assessment:**

| News Type | Vietnamese Technical Impact | Key Indicators |
|-----------|---------------------------|----------------|
| SBV rate decision | High impact on Vietnamese indices | VN-Index, VND, banking stocks |
| SSC regulatory change | Medium-High impact on Vietnamese sectors | Affected sector indices |
| FDI announcement | High impact on Vietnamese bluechips | VN30, foreign ownership stocks |
| MOF fiscal policy | Medium impact on Vietnamese bonds | Government bond yields |
| Vietnamese corporate earnings | Sector-specific impact | Individual stock technicals |
| Regional market news | Lagged impact on Vietnamese market | VN-Index follows regional trend |

**Vietnamese Technical Alert Generation:**

```json
{
  "vietnamese_technical_alert": {
    "type": "vietnamese_regime_change",
    "indicator": "vn_index_breakout",
    "news_catalyst": "sbv_rate_cut",
    "probability": "high",
    "direction": "bullish",
    "affected_indices": ["VN-Index", "VN30", "HNX-Index"],
    "affected_sectors": ["banking", "real_estate", "construction"],
    "recommended_action": "monitor_vn30_bluechips"
  }
}
```

**Vietnamese Market Indicator Summary:**

```json
{
  "vietnamese_indicators": {
    "vietnamese_rsi_14": 65,
    "vietnamese_rsi_signal": "neutral-leaning-overbought",
    "vietnamese_macd": "bullish_crossover",
    "vietnamese_macd_signal": "momentum_positive",
    "vietnamese_atr": 25,
    "vietnamese_volatility_regime": "normal",
    "vietnamese_volume_trend": "above_average"
  }
}
```