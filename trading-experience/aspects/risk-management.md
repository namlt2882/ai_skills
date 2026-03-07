# Risk Management Aspect

This aspect covers all elements related to managing risk in trading activities.

## Core Risk Management Elements
- Position sizing strategies
- Stop loss methodologies
- Portfolio diversification
- Correlation analysis
- Drawdown management
- Leverage controls

## Stop Loss Evaluation Framework

### Stop Loss Placement Methods

#### Technical-Based Stop Losses
- **Support/Resistance Stops**: Place stops just below key support (long) or above resistance (short)
  - Identify major swing highs/lows
  - Consider previous session highs/lows
  - Use pivot points as reference levels
  - Account for market structure breaks
  
- **Trendline Stops**: Place stops beyond trendlines that define the trade setup
  - Draw trendlines connecting swing points
  - Allow some buffer for trendline penetration
  - Use multiple timeframes for confirmation
  - Adjust stops as trendlines evolve

- **Pattern-Based Stops**: Place stops beyond chart pattern boundaries
  - Head and shoulders: below neckline (long) or above neckline (short)
  - Double top/bottom: beyond the pattern's extreme
  - Triangles: beyond the triangle's boundary
  - Flags/pennants: beyond the flag/pennant boundary

#### Volatility-Based Stop Losses
- **ATR Stops**: Use Average True Range multiples to set stop distance
  - 1x ATR for tight stops in trending markets
  - 2x ATR for normal market conditions
  - 3x ATR for high volatility or breakout trades
  - Adjust ATR period based on trading timeframe (e.g., 14-period for daily, 20-period for hourly)

- **Standard Deviation Stops**: Place stops based on statistical volatility
  - Use Bollinger Bands as reference (2 standard deviations)
  - Place stops beyond the bands for breakout trades
  - Use within bands for mean reversion trades
  - Adjust standard deviation multiplier based on confidence level

- **Range-Based Stops**: Calculate stops based on recent price range
  - Use recent high-low range as reference
  - Place stops beyond recent range extremes
  - Consider average range over multiple periods
  - Adjust for expanding or contracting ranges

#### Time-Based Stop Losses
- **Fixed Time Stops**: Exit trade if it doesn't work within predetermined timeframe
  - Intraday: Exit if no movement within 1-2 hours
  - Swing: Exit if no progress within 3-5 days
  - Position: Exit if no trend development within 1-2 weeks
  - Adjust based on market conditions and trade type

- **Session-Based Stops**: Exit before market closes or opens
  - Close positions before weekend gaps
  - Exit before major economic releases
  - Close before market session changes
  - Consider overnight risk for swing trades

### Stop Loss Evaluation Checklist

#### Before Placing Stop Loss
- [ ] Identify logical stop location based on technical analysis
- [ ] Calculate stop distance in price and percentage terms
- [ ] Verify stop distance aligns with risk/reward requirements
- [ ] Check if stop is too tight (likely to be hit by noise)
- [ ] Confirm stop is not too wide (excessive risk)
- [ ] Consider market volatility and adjust accordingly
- [ ] Account for spread and slippage in stop placement
- [ ] Evaluate stop placement relative to key market levels
- [ ] Ensure stop is placed where trade thesis is invalidated

#### After Placing Stop Loss
- [ ] Monitor price action relative to stop level
- [ ] Watch for stop hunting or manipulation
- [ ] Be prepared for gap risk (price jumping over stop)
- [ ] Have contingency plan if stop is hit
- [ ] Track stop hit rate for strategy evaluation
- [ ] Analyze if stops are being placed optimally

### Stop Loss Adjustment Strategies

#### Profit-Protecting Adjustments
- **Breakeven Stop**: Move stop to entry price after reaching 1R profit
  - Protects against losses while allowing upside
  - Reduces psychological pressure
  - Only move when trade has room to breathe
  - Consider leaving small buffer above breakeven

- **Trailing Stop**: Move stop as price moves in favor
  - ATR-based trail: trail by 1-2x ATR
  - Percentage trail: trail by fixed percentage (e.g., 3-5%)
  - Swing high/low trail: use recent swing points
  - Time-based trail: tighten stop as time passes

- **Partial Profit Taking**: Take some profits and tighten stop on remainder
  - Take 25-50% profit at first target
  - Move remaining position stop to breakeven or first target
  - Allows participation in further upside
  - Reduces risk while maintaining exposure

#### Risk-Reducing Adjustments
- **Tighten Stops**: Reduce stop distance as trade progresses favorably
  - Move stop closer as price approaches target
  - Tighten stops when momentum weakens
  - Reduce risk in choppy market conditions
  - Protect profits when signs of reversal appear

- **Never Widen Stops**: Never move stop further from entry to accommodate loss
  - Widening stops increases risk beyond original plan
  - Indicates emotional attachment to losing trade
  - Violates risk management discipline
  - Leads to larger losses when stop is eventually hit

### Stop Loss Decision Matrix

| Market Condition | Trade Type | Recommended Stop Method | Stop Distance |
|------------------|------------|------------------------|---------------|
| Trending, low volatility | Trend following | Technical + ATR | 1.5-2x ATR |
| Trending, high volatility | Trend following | Technical + ATR | 2-3x ATR |
| Range-bound | Mean reversion | Range-based | Beyond recent range |
| Breakout | Momentum | Volatility-based | 2-3x ATR or 2 SD |
| Reversal | Counter-trend | Technical tight | 1-1.5x ATR |
| News-driven | Event trading | Time-based | Before news event |
| Low liquidity | Any type | Wider stops | 2-3x normal |

## Position Sizing Strategies

### Fixed Fractional Sizing
- **Percentage of Capital**: Risk fixed percentage per trade (1-2% recommended)
  - Calculate position size: (Capital × Risk%) / (Entry - Stop)
  - Adjust based on account size and risk tolerance
  - Consistent risk across all trades
  - Simple and easy to implement

### Volatility-Adjusted Sizing
- **ATR-Based Sizing**: Adjust size based on market volatility
  - Smaller positions in high volatility (larger stops)
  - Larger positions in low volatility (tighter stops)
  - Maintain consistent dollar risk across conditions
  - Formula: (Capital × Risk%) / (ATR × Multiplier)

### Confidence-Based Sizing
- **Tiered Sizing**: Size based on trade confidence level
  - High confidence: 2-3% risk
  - Medium confidence: 1-2% risk
  - Low confidence: 0.5-1% risk or skip trade
  - Requires objective confidence assessment

### Kelly Criterion Sizing
- **Optimal Sizing**: Calculate mathematically optimal position size
  - Formula: f = (bp - q) / b
  - Where: b = win/loss ratio, p = win probability, q = loss probability
  - Use fractional Kelly (e.g., 25-50% of full Kelly) for safety
  - Requires accurate win rate and risk/reward data

## Risk Assessment Framework

### Volatility-Based Risk Measures
- **ATR (Average True Range)**: Measure of price volatility
- **Historical Volatility**: Statistical measure of past price movements
- **Implied Volatility**: Market's expectation of future volatility
- **Volatility Regimes**: Identify periods of low vs. high volatility

### Value at Risk (VaR) Calculations
- **Historical VaR**: Based on historical return distributions
- **Parametric VaR**: Assumes normal distribution of returns
- **Monte Carlo VaR**: Simulates thousands of potential scenarios
- **Confidence Levels**: Typically 95% or 99% confidence

### Expected Shortfall Metrics
- **Conditional VaR**: Average loss beyond VaR threshold
- **Expected Tail Loss**: Focuses on extreme loss scenarios
- **Stress Loss**: Loss under extreme market conditions
- **Worst-Case Scenario**: Maximum potential loss

### Scenario Analysis
- **Best Case**: Optimistic but realistic outcome
- **Base Case**: Most likely outcome
- **Worst Case**: Pessimistic but realistic outcome
- **Catastrophic Case**: Extreme but possible outcome

### Stress Testing Procedures
- **Historical Stress**: Test against past market crises
- **Hypothetical Stress**: Test against potential future scenarios
- **Correlation Breakdown**: Test when correlations change
- **Liquidity Crisis**: Test when liquidity disappears

## Portfolio Risk Management

### Diversification Strategies
- **Asset Class Diversification**: Spread across stocks, bonds, commodities, currencies
- **Sector Diversification**: Avoid concentration in single sector
- **Geographic Diversification**: Spread across different countries/regions
- **Timeframe Diversification**: Mix of short, medium, and long-term trades

### Correlation Analysis
- **Correlation Matrix**: Track correlations between positions
- **Dynamic Correlations**: Monitor how correlations change over time
- **Correlation Breakdown**: Plan for when correlations converge to 1
- **Hedging Strategies**: Use negatively correlated assets for protection

### Drawdown Management
- **Maximum Drawdown Limit**: Stop trading if drawdown exceeds threshold
- **Reduced Position Sizing**: Decrease size during drawdowns
- **Trading Pause**: Take break after significant losses
- **Strategy Review**: Re-evaluate approach after extended drawdown

### Leverage Controls
- **Conservative Leverage**: Use minimal leverage (1-2x for beginners)
- **Margin Requirements**: Maintain buffer above minimum requirements
- **Leverage Adjustment**: Reduce leverage during high volatility
- **Overnight Risk**: Consider reducing or eliminating overnight leverage

## Connection Points
- Integrates with Market Analysis for position sizing based on signal strength
- Works with Trading Psychology to prevent emotional decision-making
- Coordinates with Execution Methods for optimal entry/exit timing
- Feeds into Performance Metrics for risk-adjusted returns calculation
- Links to Profit/Loss Decisions for stop loss placement and adjustment
