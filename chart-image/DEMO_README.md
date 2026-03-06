# Financial Charts Demonstration

This directory contains a demonstration script that generates sample financial charts using the enhanced chart-image skill. The script creates realistic financial data (OHLCV) and generates actual image files showing candlestick charts, technical indicators, and other financial chart types.

## Overview

The demonstration script (`demo_financial_charts.py`) showcases the following capabilities:

1. **Realistic Financial Data Generation** - Generates synthetic OHLCV data using geometric Brownian motion with volatility clustering
2. **Candlestick Charts** - Professional OHLC candlestick visualization with TradingView-style colors
3. **OHLC Bar Charts** - Traditional Open-High-Low-Close bar representation
4. **Technical Indicators** - Moving Averages (MA), Relative Strength Index (RSI), MACD
5. **Volume Profile Charts** - Multi-panel charts showing price action with volume

## Installation

### Prerequisites

- Python 3.7 or higher
- Required Python packages (see requirements.txt)

### Install Dependencies

```bash
pip3 install -r requirements.txt
```

The required packages are:
- pandas >= 1.3.0
- numpy >= 1.21.0
- matplotlib >= 3.4.0

## Usage

### Running the Demo

```bash
python3 demo_financial_charts.py
```

### What the Script Does

1. **Generates Realistic Financial Data**
   - Creates 100 days of synthetic OHLCV data
   - Uses geometric Brownian motion for price simulation
   - Includes volatility clustering for realistic market behavior
   - Generates realistic trading volumes using log-normal distribution

2. **Creates Multiple Chart Types**
   - Candlestick chart
   - OHLC bar chart
   - Technical indicators with Moving Averages (MA20, MA50)
   - Technical indicators with RSI
   - Technical indicators with MACD
   - Comprehensive technical analysis (MA, RSI, MACD combined)
   - Volume profile chart

3. **Saves Images to Output Directory**
   - All charts are saved as PNG files
   - High resolution (150 DPI) for professional quality
   - Organized in the `demo_output/` directory

## Generated Charts

The demo script generates the following chart images:

### 1. `candlestick_chart.png`
- **Type**: Candlestick chart
- **Features**: Green candles for bullish periods, red candles for bearish periods
- **Use Case**: Price action analysis, trend identification

### 2. `ohlc_chart.png`
- **Type**: OHLC (Open-High-Low-Close) bar chart
- **Features**: Vertical lines for high-low range, horizontal ticks for open/close
- **Use Case**: Traditional financial analysis

### 3. `tech_ma_chart.png`
- **Type**: Technical indicators with Moving Averages
- **Features**: Price line with MA(20) and MA(50) overlays
- **Use Case**: Trend following, support/resistance identification

### 4. `tech_rsi_chart.png`
- **Type**: Technical indicators with RSI
- **Features**: Price line with MA, plus RSI panel with overbought/oversold levels
- **Use Case**: Momentum analysis, reversal detection

### 5. `tech_macd_chart.png`
- **Type**: Technical indicators with MACD
- **Features**: Price line with MA, plus MACD panel with signal line and histogram
- **Use Case**: Trend momentum, crossover signals

### 6. `tech_full_chart.png`
- **Type**: Comprehensive technical analysis
- **Features**: Price with MA20/MA50, RSI panel, and MACD panel
- **Use Case**: Complete technical analysis overview

### 7. `volume_profile_chart.png`
- **Type**: Volume profile chart
- **Features**: Price line with MA20/MA50, plus volume bars panel
- **Use Case**: Volume-price relationship analysis, breakout detection

## Technical Indicators Explained

### Moving Average (MA)
- **Calculation**: Simple Moving Average over specified period
- **Common Periods**: 
  - MA(20): Short-term trend (~1 month of daily data)
  - MA(50): Medium-term trend (~2.5 months)
  - MA(200): Long-term trend (~10 months)
- **Interpretation**: 
  - Price above MA = Bullish trend
  - Price below MA = Bearish trend
  - Crossovers = Buy/Sell signals

### Relative Strength Index (RSI)
- **Calculation**: Momentum oscillator based on average gains/losses
- **Range**: 0-100
- **Key Levels**:
  - RSI > 70: Overbought (potential sell signal)
  - RSI < 30: Oversold (potential buy signal)
  - RSI = 50: Neutral territory
- **Use Case**: Identifying overbought/oversold conditions

### MACD (Moving Average Convergence Divergence)
- **Components**:
  - MACD Line: EMA(12) - EMA(26)
  - Signal Line: EMA of MACD Line (period 9)
  - Histogram: MACD Line - Signal Line
- **Interpretation**:
  - MACD above Signal = Bullish momentum
  - MACD below Signal = Bearish momentum
  - Crossover above = Buy signal
  - Crossover below = Sell signal
- **Use Case**: Trend following, momentum analysis

## Chart Styling

### TradingView Style Colors
- **Bullish (Up)**: `#26a69a` (Green)
- **Bearish (Down)**: `#ef5350` (Red)
- **Background**: `#131722` (Dark)
- **Grid**: `#2a2e39` (Subtle dark gray)
- **Text**: `#d1d4dc` (Light gray)

### Default Chart Colors
- **Price Line**: `#1f77b4` (Blue)
- **MA(20)**: `#ff7f0e` (Orange)
- **MA(50)**: `#2ca02c` (Green)
- **MA(200)**: `#d62728` (Red)
- **RSI**: `#9467bd` (Purple)
- **MACD**: `#e377c2` (Pink)
- **Signal**: `#17becf` (Cyan)

## Output Directory Structure

```
chart-image/
├── demo_financial_charts.py
├── requirements.txt
├── DEMO_README.md
└── demo_output/
    ├── candlestick_chart.png
    ├── ohlc_chart.png
    ├── tech_ma_chart.png
    ├── tech_rsi_chart.png
    ├── tech_macd_chart.png
    ├── tech_full_chart.png
    └── volume_profile_chart.png
```

## Customization

### Modifying Data Generation

You can customize the generated financial data by modifying the parameters in the `generate_realistic_financial_data()` function:

```python
# Generate 200 days of data instead of 100
df = generate_realistic_financial_data(days=200, symbol="GOOGL")
```

### Adding Custom Indicators

To add custom technical indicators, create a new calculation function:

```python
def _calculate_bollinger_bands(data, window=20, num_std=2):
    """Calculate Bollinger Bands."""
    ma = data.rolling(window=window).mean()
    std = data.rolling(window=window).std()
    upper_band = ma + (std * num_std)
    lower_band = ma - (std * num_std)
    return ma, upper_band, lower_band
```

### Changing Chart Colors

Modify the color constants in the chart creation functions:

```python
# Custom colors
up_color = '#00ff00'  # Bright green
down_color = '#ff0000'  # Bright red
```

## Sample Output Statistics

When you run the demo script, it will display statistics about the generated data:

```
Generated data statistics:
  - Date range: 2025-11-27 to 2026-03-06
  - Total days: 100
  - Price range: $136.43 - $181.89
  - Average volume: 5,210,247 shares
```

## Integration with Chart-Image Skill

This demonstration script implements the core functionality described in the `chart-image/SKILL.md` file. The functions can be integrated into the chart-image skill for:

1. **AI Chat Integration** - Generate charts dynamically based on user queries
2. **Financial Analysis** - Create technical analysis charts for trading
3. **Data Visualization** - Convert financial data to visual representations
4. **Report Generation** - Embed charts in financial reports

## Troubleshooting

### ModuleNotFoundError: No module named 'pandas'
- **Solution**: Install required dependencies: `pip3 install -r requirements.txt`

### Images not saving
- **Solution**: Ensure the `demo_output/` directory has write permissions

### Charts appear blank
- **Solution**: Check that matplotlib backend is properly configured for your system

## License

This demonstration script is part of the chart-image skill and follows the same license terms.

## Contributing

To contribute to this demonstration script:

1. Add new chart types to the script
2. Implement additional technical indicators
3. Improve data generation algorithms
4. Enhance styling options
5. Add more customization parameters

## See Also

- `chart-image/SKILL.md` - Main skill documentation
- `chart-image/__tests__/` - Test files for chart functionality
- `chart-image/requirements.txt` - Python package dependencies