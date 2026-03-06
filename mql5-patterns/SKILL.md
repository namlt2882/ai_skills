---
name: mql5-patterns
description: MQL5 patterns, best practices, and conventions for building robust, efficient, and maintainable MetaTrader 5 Expert Advisors and indicators.
---

# MQL5 Development Patterns

Idiomatic MQL5 patterns and best practices for building robust, efficient, and maintainable Expert Advisors (EAs), indicators, and scripts for MetaTrader 5.

## When to Activate

- Writing new MQL5 Expert Advisors
- Creating MQL5 indicators or scripts
- Reviewing MQL5 code
- Refactoring existing MQL5 code
- Optimizing MQL5 trading strategies

**Note**: For comprehensive US financial market analysis including intermarket relationships, risk assets correlation, technical indicators, and macroeconomic factors, also consult the [`us-financial-market-analysis`](../us-financial-market-analysis/SKILL.md) skill to understand market context for your trading strategies.

## Core Principles

See: [`aspects/core-principles.md`](aspects/core-principles.md)

## Order Management Patterns

See: [`aspects/order-management.md`](aspects/order-management.md)

## Risk Management

See: [`aspects/risk-management.md`](aspects/risk-management.md)

## Technical Analysis Patterns

See: [`aspects/technical-analysis.md`](aspects/technical-analysis.md)

## Event Handling Patterns

See: [`aspects/event-handling.md`](aspects/event-handling.md)

## Error Handling

See: [`aspects/error-handling.md`](aspects/error-handling.md)

## Utility Functions

See: [`aspects/utility-functions.md`](aspects/utility-functions.md)

## Quick Reference: MQL5 Idioms

| Idiom | Description |
|-------|-------------|
| Use OOP classes | Leverage MQL5's object-oriented features |
| Use Standard Library | CTrade, CPositionInfo, COrderInfo, etc. |
| Check return values | Always validate function returns |
| Use indicator handles | Create handles in OnInit, release in OnDeinit |
| ArraySetAsSeries | Set arrays as series for proper indexing |
| Use CopyBuffer | Copy indicator data to arrays |
| Check trade retcodes | Handle TRADE_RETCODE_* values |
| Use ENUM types | Leverage MQL5 enumerations for clarity |

## Anti-Patterns to Avoid

See: [`aspects/core-principles.md`](aspects/core-principles.md) for defensive programming examples and [`aspects/error-handling.md`](aspects/error-handling.md) for proper error handling.

## MQL4 vs MQL5 Key Differences

| Feature | MQL4 | MQL5 |
|---------|------|------|
| Order Management | OrderSend/OrderSelect | CTrade class, OrderSend with MqlTradeRequest |
| Position Tracking | OrdersTotal() loop | PositionsTotal() with CPositionInfo |
| Indicators | iMA() returns values directly | iMA() returns handle, use CopyBuffer() |
| Arrays | Default indexing | ArraySetAsSeries() for time-series |
| OOP | Limited | Full support with classes, inheritance |
| Events | OnTick, OnTimer, OnDeinit | Plus OnTrade, OnTradeTransaction, OnChartEvent |
| Error Handling | GetLastError() | ResultRetcode() with detailed codes |

## Integrating Financial Analysis Concepts

When developing trading bots, it's important to incorporate financial analysis concepts from the [`us-financial-market-analysis`](../us-financial-market-analysis/SKILL.md) skill:

### Intermarket Analysis Integration
```mql5
// Example: Checking correlation between different markets before entering trades
bool CheckIntermarketConditions() {
    // Check if bond market is declining (potentially bearish for stocks)
    double bondMaFast = iMA("US100Y_T", PERIOD_H1, 10, 0, MODE_SMA, PRICE_CLOSE, 0);
    double bondMaSlow = iMA("US100Y_T", PERIOD_H1, 20, 0, MODE_SMA, PRICE_CLOSE, 0);
    
    // If bonds are in downtrend, be more cautious with stock long positions
    if(bondMaFast < bondMaSlow) {
        Print("Bond market in downtrend - consider reducing long equity exposure");
        return false; // Signal to be more conservative
    }
    return true;
}
```

### Risk-On/Risk-Off Regime Detection
```mql5
// Example: Using VIX equivalent or volatility measures to detect market regime
enum MARKET_REGIME {
    REGIME_RISK_ON,
    REGIME_RISK_OFF,
    REGIME_NEUTRAL
};

MARKET_REGIME DetectMarketRegime() {
    // Calculate volatility of the instrument
    double atr = iATR(Symbol(), Period(), 14, 0);
    double avgAtr = iMAOnArray(atrBuffer, 0, 50, 0, MODE_SMA, 0);
    
    if(atr > avgAtr * 1.5) {
        return REGIME_RISK_OFF;  // High volatility regime
    } else if(atr < avgAtr * 0.7) {
        return REGIME_RISK_ON;   // Low volatility regime
    }
    return REGIME_NEUTRAL;
}
```

### Technical Analysis Best Practices
When implementing technical indicators in your EA, consider the broader market context:
- Combine your internal technical signals with broader market technical analysis
- Use multiple timeframe analysis to confirm signals
- Consider market regime when interpreting technical signals (some indicators work better in trending vs ranging markets)

### Macroeconomic Awareness
```mql5
// Example: Checking for major news events that might affect trading
bool ShouldPauseTrading(datetime currentTime) {
    // Check for major FOMC announcement times, etc.
    // This would require external economic calendar data
    MqlDateTime dt;
    TimeToStruct(currentTime, dt);
    
    // Example: Avoid trading 30 mins before and after major news
    if((dt.hour == 14 && dt.min >= 0 && dt.min <= 30) ||  // FOMC announcement time
       (dt.hour == 8 && dt.min >= 25 && dt.min <= 55)) {  // Non-farm payrolls preparation
        return true;
    }
    return false;
}
```

**Remember**: MQL5 is more powerful and object-oriented than MQL4. Leverage the standard library classes, use proper OOP design, and always handle errors gracefully. The transition from MQL4 requires understanding the new event-driven architecture and handle-based indicator system. Additionally, integrate broader financial market analysis concepts to enhance your trading strategies with market context awareness.

## Additional Resources

For a comprehensive overview of Expert Advisors and indicators available on the MQL5 Market, including detailed analysis of various trading strategies, implementation methods, and pros/cons of different approaches, see: [`knowledge-document-mql5-eas-indicators.md`](knowledge-document-mql5-eas-indicators.md)