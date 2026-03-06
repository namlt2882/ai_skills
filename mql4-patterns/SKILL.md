---
name: mql4-patterns
description: MQL4 patterns, best practices, and conventions for building robust, efficient, and maintainable MetaTrader 4 Expert Advisors and indicators.
---

# MQL4 Development Patterns

Idiomatic MQL4 patterns and best practices for building robust, efficient, and maintainable Expert Advisors (EAs), indicators, and scripts for MetaTrader 4.

## When to Activate

- Writing new MQL4 Expert Advisors
- Creating MQL4 indicators or scripts
- Reviewing MQL4 code
- Refactoring existing MQL4 code
- Optimizing MQL4 trading strategies

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

## Quick Reference: MQL4 Idioms

| Idiom | Description |
|-------|-------------|
| Always check return values | MQL4 functions return error codes; always validate |
| Use Magic Numbers | Identify your EA's orders uniquely |
| Normalize prices/lots | Always normalize to broker's precision |
| Defensive programming | Validate all inputs and handle errors |
| Count orders backwards | Iterate from OrdersTotal()-1 to 0 |
| Check IsTradeAllowed() | Verify trading is permitted before operations |
| Use RefreshRates() | Update prices before order operations |
| Handle requotes | Implement retry logic for transient errors |
| Use break-even stops | Lock in profits when price moves favorably |
| Consider partial closes | Take profits while maintaining position |
| Multi-timeframe analysis | Confirm signals across timeframes |

## Anti-Patterns to Avoid

See: [`aspects/core-principles.md`](aspects/core-principles.md) for defensive programming examples and [`aspects/error-handling.md`](aspects/error-handling.md) for proper error handling.

## Integrating Financial Analysis Concepts

When developing trading bots, it's important to incorporate financial analysis concepts from the [`us-financial-market-analysis`](../us-financial-market-analysis/SKILL.md) skill:

### Intermarket Analysis Integration
```mql4
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
```mql4
// Example: Using volatility measures to detect market regime
enum MARKET_REGIME {
    REGIME_RISK_ON,
    REGIME_RISK_OFF,
    REGIME_NEUTRAL
};

MARKET_REGIME DetectMarketRegime() {
    // Calculate volatility of the instrument
    double atr = iATR(Symbol(), Period(), 14, 0);
    double atrBuffer[50];
    for(int i = 0; i < 50; i++) {
        atrBuffer[i] = iATR(Symbol(), Period(), 14, i);
    }
    double avgAtr = 0;
    for(int i = 0; i < 50; i++) {
        avgAtr += atrBuffer[i];
    }
    avgAtr /= 50;

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
```mql4
// Example: Checking for major news events that might affect trading
bool ShouldPauseTrading(datetime currentTime) {
    // Check for major FOMC announcement times, etc.
    // This would require external economic calendar data
    int currentHour = TimeHour(currentTime);
    int currentMin = TimeMinute(currentTime);

    // Example: Avoid trading 30 mins before and after major news
    if((currentHour == 14 && currentMin >= 0 && currentMin <= 30) ||  // FOMC announcement time
       (currentHour == 8 && currentMin >= 25 && currentMin <= 55)) {  // Non-farm payrolls preparation
        return true;
    }
    return false;
}
```

**Remember**: MQL4 code runs in a trading environment where errors can cost real money. Always validate inputs, check return values, and implement proper risk management. Additionally, integrate broader financial market analysis concepts to enhance your trading strategies with market context awareness.
