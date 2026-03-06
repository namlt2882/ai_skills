---
name: chart-image
description: Converts data to visual charts and graphs rendered as images. Enables AI agents to generate various chart types from datasets for enhanced data visualization in chat interfaces. Now includes TradingView-like financial chart capabilities with candlestick, OHLC, technical indicators, and professional styling.
---

# Chart to Image Visualization Skill

Systematizes the conversion of data to visual charts and graphs rendered as images for enhanced data presentation in chat interfaces. Now includes comprehensive TradingView-like financial charting capabilities with professional styling, technical indicators, and advanced visualization features.

## What's New: Financial Charting Capabilities

The enhanced chart-image skill now supports professional-grade financial data visualization with TradingView-like features:

- **Candlestick Charts** - Professional OHLC candlestick visualization with customizable colors
- **OHLC Bar Charts** - Traditional Open-High-Low-Close bar representation
- **Technical Indicators** - Moving Averages (MA), Relative Strength Index (RSI), MACD
- **Volume Profile Charts** - Multi-panel charts showing price action with volume
- **TradingView Styling** - Dark theme with professional color schemes
- **Multi-Panel Layouts** - Combine price action with indicators in unified displays
- **Financial Data Support** - Native support for OHLCV data structures

## When to Activate

### General Data Visualization
- Converting numerical data to visual charts (bar, line, pie, scatter, etc.)
- Generating images from datasets for better comprehension
- Creating visual representations of trends, comparisons, and distributions
- Sharing data insights through visual chart representations
- Rendering charts in chat interfaces that don't support rich visualization

### Financial Charting
- Visualizing stock price data with candlestick or OHLC charts
- Displaying technical indicators (MA, RSI, MACD) alongside price action
- Creating volume profile charts for trading analysis
- Generating TradingView-styled charts with professional appearance
- Analyzing market data with multi-panel technical analysis
- Creating financial reports with embedded chart visualizations

## Prerequisites

### Required Libraries
- `matplotlib` - For creating static, animated, and interactive visualizations
- `seaborn` - For statistical data visualization
- `plotly` - For interactive plots (optional)
- `pandas` - For data manipulation and analysis
- `numpy` - For numerical computations
- `pillow` - For image processing and manipulation

### System Requirements
- Python 3.7+ or Node.js environment
- Image rendering capabilities
- Font rendering support for chart labels

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. DATA INPUT                                          │
│     Accept numerical data (CSV, JSON, DataFrame, etc.) │
│     Validate data structure and content                │
│     Detect financial data patterns (OHLCV)             │
├─────────────────────────────────────────────────────────┤
│  2. CHART TYPE SELECTION                               │
│     Determine appropriate chart type based on data     │
│     Auto-detect financial data for specialized charts  │
│     Apply best practices for data visualization        │
├─────────────────────────────────────────────────────────┤
│  3. VISUALIZATION                                      │
│     Render chart as image using matplotlib/seaborn     │
│     Apply TradingView styling for financial charts     │
│     Add technical indicators as requested              │
│     Apply formatting, colors, and layout               │
├─────────────────────────────────────────────────────────┤
│  4. IMAGE OPTIMIZATION                                 │
│     Resize for optimal display                         │
│     Optimize for file size and quality                 │
│     Apply professional color schemes                   │
├─────────────────────────────────────────────────────────┤
│  5. OUTPUT GENERATION                                  │
│     Save as PNG, JPEG, or SVG                          │
│     Return image data for chat integration             │
│     Support base64 encoding for web applications       │
└─────────────────────────────────────────────────────────┘
```

## Data Input Formats

### Pandas DataFrame
```python
import pandas as pd
import matplotlib.pyplot as plt

def process_dataframe(df: pd.DataFrame, chart_type: str = 'auto', title: str = None) -> bytes:
    """
    Process a pandas DataFrame into a chart image
    
    Parameters:
    - df: pandas DataFrame containing the data
    - chart_type: Type of chart to create ('auto', 'line', 'bar', 'pie', 'scatter', 
                  'histogram', 'heatmap', 'candlestick', 'ohlc', 'technical', 'volume', 'tradingview')
    - title: Optional title for the chart
    
    Returns:
    - bytes: Image data in PNG format
    """
    # Auto-detect chart type if not specified
    if chart_type == 'auto':
        chart_type = _detect_chart_type(df)
    
    # Create the appropriate chart
    if chart_type == 'line':
        return _create_line_chart(df, title)
    elif chart_type == 'bar':
        return _create_bar_chart(df, title)
    elif chart_type == 'pie':
        return _create_pie_chart(df, title)
    elif chart_type == 'scatter':
        return _create_scatter_plot(df, title)
    elif chart_type == 'histogram':
        return _create_histogram(df, title)
    elif chart_type == 'heatmap':
        return _create_heatmap(df, title)
    elif chart_type == 'candlestick':
        return _create_candlestick_chart(df, title)
    elif chart_type == 'ohlc':
        return _create_ohlc_chart(df, title)
    elif chart_type == 'technical':
        return _create_technical_indicators_chart(df, indicators=['MA', 'RSI'], title=title)
    elif chart_type == 'volume':
        return _create_volume_profile_chart(df, title)
    elif chart_type == 'tradingview':
        return _create_tradingview_styled_chart(df, chart_type='candlestick', title=title)
    else:
        raise ValueError(f"Unsupported chart type: {chart_type}")
```

### CSV Data
```python
def process_csv(csv_string: str, chart_type: str = 'auto', title: str = None) -> bytes:
    """
    Process CSV string into a chart image
    
    Parameters:
    - csv_string: CSV formatted string
    - chart_type: Type of chart to create
    - title: Optional title for the chart
    
    Returns:
    - bytes: Image data in PNG format
    """
    import io
    df = pd.read_csv(io.StringIO(csv_string))
    return process_dataframe(df, chart_type, title)
```

### JSON Data
```python
def process_json(json_string: str, chart_type: str = 'auto', title: str = None) -> bytes:
    """
    Process JSON string into a chart image
    
    Parameters:
    - json_string: JSON formatted string
    - chart_type: Type of chart to create
    - title: Optional title for the chart
    
    Returns:
    - bytes: Image data in PNG format
    """
    import json
    data = json.loads(json_string)
    df = pd.DataFrame(data)
    return process_dataframe(df, chart_type, title)
```

## Chart Types

### Standard Charts

#### Line Charts
```python
def _create_line_chart(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a line chart from DataFrame
    """
    plt.figure(figsize=(10, 6))
    
    # Plot each numeric column as a line
    for col in df.select_dtypes(include=['number']).columns:
        plt.plot(df.index if not df.index.name else df.index, df[col], marker='o', label=col)
    
    plt.title(title or 'Line Chart')
    plt.xlabel('Index')
    plt.ylabel('Values')
    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

#### Bar Charts
```python
def _create_bar_chart(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a bar chart from DataFrame
    """
    plt.figure(figsize=(10, 6))
    
    # If there's only one row, create a horizontal bar chart
    if len(df) == 1:
        df.iloc[0].plot(kind='barh')
    else:
        # Plot each numeric column as a bar
        df.select_dtypes(include=['number']).plot(kind='bar', ax=plt.gca())
    
    plt.title(title or 'Bar Chart')
    plt.xlabel('Categories')
    plt.ylabel('Values')
    plt.xticks(rotation=45)
    plt.legend()
    plt.tight_layout()
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

#### Pie Charts
```python
def _create_pie_chart(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a pie chart from DataFrame
    """
    plt.figure(figsize=(8, 8))
    
    # Use the first numeric column for the pie chart
    numeric_cols = df.select_dtypes(include=['number']).columns
    if len(numeric_cols) == 0:
        raise ValueError("DataFrame must contain at least one numeric column for pie chart")
    
    # If there's only one row, use all numeric columns
    if len(df) == 1:
        values = df[numeric_cols].iloc[0]
        labels = numeric_cols
    else:
        # Use the first numeric column, assuming index contains labels
        values = df[numeric_cols[0]]
        labels = df.index.astype(str)
    
    plt.pie(values, labels=labels, autopct='%1.1f%%', startangle=90)
    plt.title(title or 'Pie Chart')
    plt.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

#### Scatter Plots
```python
def _create_scatter_plot(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a scatter plot from DataFrame
    """
    numeric_cols = df.select_dtypes(include=['number']).columns
    if len(numeric_cols) < 2:
        raise ValueError("DataFrame must contain at least two numeric columns for scatter plot")
    
    plt.figure(figsize=(10, 6))
    
    # Use the first two numeric columns for x and y axes
    x_col, y_col = numeric_cols[0], numeric_cols[1]
    plt.scatter(df[x_col], df[y_col])
    
    plt.title(title or f'{y_col} vs {x_col}')
    plt.xlabel(x_col)
    plt.ylabel(y_col)
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

#### Histograms
```python
def _create_histogram(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a histogram from DataFrame
    """
    numeric_cols = df.select_dtypes(include=['number']).columns
    if len(numeric_cols) == 0:
        raise ValueError("DataFrame must contain at least one numeric column for histogram")
    
    plt.figure(figsize=(10, 6))
    
    # Create histogram for the first numeric column
    plt.hist(df[numeric_cols[0]], bins=20, edgecolor='black')
    
    plt.title(title or f'Histogram of {numeric_cols[0]}')
    plt.xlabel(numeric_cols[0])
    plt.ylabel('Frequency')
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

#### Heatmaps
```python
def _create_heatmap(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a heatmap from DataFrame
    """
    import seaborn as sns
    
    plt.figure(figsize=(10, 8))
    
    # Create heatmap of correlations
    correlation_matrix = df.select_dtypes(include=['number']).corr()
    sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', center=0,
                square=True, fmt='.2f')
    
    plt.title(title or 'Correlation Heatmap')
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Financial Charts

#### Candlestick Charts
```python
def _create_candlestick_chart(df: pd.DataFrame, title: str = None) -> bytes:
   """
   Create a candlestick chart from OHLC data
   
   Expected columns:
   - Date (optional): Timestamp for each data point
   - Open: Opening price
   - High: Highest price during the period
   - Low: Lowest price during the period
   - Close: Closing price
   - Volume (optional): Trading volume
   
   Parameters:
   - df: pandas DataFrame with OHLC data
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Visual Features:
   - Green candles (#26a69a) for bullish periods (Close >= Open)
   - Red candles (#ef5350) for bearish periods (Close < Open)
   - High-low lines (wicks) showing price range
   - Professional TradingView-style appearance
   """
   import matplotlib.pyplot as plt
   import matplotlib.dates as mdates
   from matplotlib.patches import Rectangle
   
   # Validate required columns
   required_cols = ['Open', 'High', 'Low', 'Close']
   if not all(col in df.columns for col in required_cols):
       raise ValueError("Candlestick chart requires 'Open', 'High', 'Low', 'Close' columns")
   
   # Use index as date if no date column exists
   if 'Date' in df.columns:
       dates = df['Date']
   else:
       dates = df.index
   
   # Convert dates if they're not already datetime
   if not pd.api.types.is_datetime64_any_dtype(dates):
       dates = pd.to_datetime(dates)
   
   fig, ax = plt.subplots(figsize=(12, 8))
   
   # Define colors for up and down candles (TradingView colors)
   up_color = '#26a69a'  # Green for bullish
   down_color = '#ef5350'  # Red for bearish
   
   # Draw candlesticks
   for i in range(len(df)):
       date = mdates.date2num(dates.iloc[i])
       open_price = df['Open'].iloc[i]
       high_price = df['High'].iloc[i]
       low_price = df['Low'].iloc[i]
       close_price = df['Close'].iloc[i]
       
       # Determine if up or down candle
       color = up_color if close_price >= open_price else down_color
       
       # Draw high-low line (wick)
       ax.plot([date, date], [low_price, high_price], color=color, linewidth=1)
       
       # Draw open-close rectangle (body)
       height = abs(close_price - open_price)
       bottom = min(open_price, close_price)
       
       # Make the candle body slightly wider for visibility
       width = 0.6
       rect = Rectangle((date - width/2, bottom), width, height,
                       facecolor=color, edgecolor=color, alpha=0.8)
       ax.add_patch(rect)
   
   # Format x-axis to show dates nicely
   ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
   ax.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
   plt.xticks(rotation=45)
   
   plt.title(title or 'Candlestick Chart', fontsize=14, fontweight='bold')
   plt.xlabel('Date')
   plt.ylabel('Price')
   plt.grid(True, linestyle='--', alpha=0.6)
   plt.tight_layout()
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   return img_bytes
```

#### OHLC Bar Charts
```python
def _create_ohlc_chart(df: pd.DataFrame, title: str = None) -> bytes:
   """
   Create an OHLC (Open-High-Low-Close) bar chart
   
   Expected columns:
   - Date (optional): Timestamp for each data point
   - Open: Opening price
   - High: Highest price during the period
   - Low: Lowest price during the period
   - Close: Closing price
   - Volume (optional): Trading volume
   
   Parameters:
   - df: pandas DataFrame with OHLC data
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Visual Features:
   - Green bars (#26a69a) for bullish periods (Close >= Open)
   - Red bars (#ef5350) for bearish periods (Close < Open)
   - Vertical line showing high-low range
   - Horizontal ticks for open (left) and close (right)
   - Traditional financial chart appearance
   """
   import matplotlib.pyplot as plt
   import matplotlib.dates as mdates
   
   # Validate required columns
   required_cols = ['Open', 'High', 'Low', 'Close']
   if not all(col in df.columns for col in required_cols):
       raise ValueError("OHLC chart requires 'Open', 'High', 'Low', 'Close' columns")
   
   # Use index as date if no date column exists
   if 'Date' in df.columns:
       dates = df['Date']
   else:
       dates = df.index
   
   # Convert dates if they're not already datetime
   if not pd.api.types.is_datetime64_any_dtype(dates):
       dates = pd.to_datetime(dates)
   
   fig, ax = plt.subplots(figsize=(12, 8))
   
   # Define colors for up and down bars (TradingView colors)
   up_color = '#26a69a'  # Green for bullish
   down_color = '#ef5350'  # Red for bearish
   
   # Draw OHLC bars
   for i in range(len(df)):
       date = mdates.date2num(dates.iloc[i])
       open_price = df['Open'].iloc[i]
       high_price = df['High'].iloc[i]
       low_price = df['Low'].iloc[i]
       close_price = df['Close'].iloc[i]
       
       # Determine if up or down bar
       color = up_color if close_price >= open_price else down_color
       
       # Draw high-low vertical line
       ax.plot([date, date], [low_price, high_price], color=color, linewidth=1)
       
       # Draw open horizontal line to the left
       ax.plot([date - 0.2, date], [open_price, open_price], color=color, linewidth=1)
       
       # Draw close horizontal line to the right
       ax.plot([date, date + 0.2], [close_price, close_price], color=color, linewidth=1)
   
   # Format x-axis to show dates nicely
   ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
   ax.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
   plt.xticks(rotation=45)
   
   plt.title(title or 'OHLC Chart', fontsize=14, fontweight='bold')
   plt.xlabel('Date')
   plt.ylabel('Price')
   plt.grid(True, linestyle='--', alpha=0.6)
   plt.tight_layout()
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   return img_bytes
```

## Technical Indicators

### Moving Average (MA)
```python
def _calculate_moving_average(data: pd.Series, window: int = 20) -> pd.Series:
   """
   Calculate Simple Moving Average (SMA) for a given series
   
   Parameters:
   - data: pandas Series of price data (typically Close prices)
   - window: Number of periods for the moving average (default: 20)
   
   Returns:
   - pd.Series: Moving average values
   
   Common Periods:
   - MA(20): Short-term trend (approx. 1 month of daily data)
   - MA(50): Medium-term trend (approx. 2.5 months of daily data)
   - MA(200): Long-term trend (approx. 10 months of daily data)
   
   Usage:
   - Identify trend direction (price above MA = bullish)
   - Find support/resistance levels
   - Generate crossover signals (MA crossovers)
   """
   return data.rolling(window=window).mean()
```

### Relative Strength Index (RSI)
```python
def _calculate_rsi(data: pd.Series, window: int = 14) -> pd.Series:
   """
   Calculate Relative Strength Index (RSI)
   
   Parameters:
   - data: pandas Series of price data (typically Close prices)
   - window: Number of periods for RSI calculation (default: 14)
   
   Returns:
   - pd.Series: RSI values (0-100 range)
   
   Interpretation:
   - RSI > 70: Overbought condition (potential sell signal)
   - RSI < 30: Oversold condition (potential buy signal)
   - RSI = 50: Neutral territory
   - Divergence with price indicates potential reversal
   
   Formula:
   RSI = 100 - (100 / (1 + RS))
   Where RS = Average Gain / Average Loss over the window period
   """
   delta = data.diff()
   gain = (delta.where(delta > 0, 0)).rolling(window=window).mean()
   loss = (-delta.where(delta < 0, 0)).rolling(window=window).mean()
   rs = gain / loss
   rsi = 100 - (100 / (1 + rs))
   return rsi
```

### MACD (Moving Average Convergence Divergence)
```python
def _calculate_macd(data: pd.Series, fast: int = 12, slow: int = 26, signal: int = 9) -> tuple:
   """
   Calculate MACD (Moving Average Convergence Divergence)
   
   Parameters:
   - data: pandas Series of price data (typically Close prices)
   - fast: Fast EMA period (default: 12)
   - slow: Slow EMA period (default: 26)
   - signal: Signal line EMA period (default: 9)
   
   Returns:
   - tuple: (macd_line, signal_line, histogram)
   
   Components:
   - MACD Line: Fast EMA - Slow EMA
   - Signal Line: EMA of MACD Line
   - Histogram: MACD Line - Signal Line
   
   Interpretation:
   - MACD above Signal = Bullish momentum
   - MACD below Signal = Bearish momentum
   - Crossover above = Buy signal
   - Crossover below = Sell signal
   - Histogram shows momentum strength
   
   Formula:
   MACD = EMA(12) - EMA(26)
   Signal = EMA(MACD, 9)
   Histogram = MACD - Signal
   """
   exp1 = data.ewm(span=fast).mean()
   exp2 = data.ewm(span=slow).mean()
   macd_line = exp1 - exp2
   signal_line = macd_line.ewm(span=signal).mean()
   histogram = macd_line - signal_line
   return macd_line, signal_line, histogram
```

### Technical Indicators Chart
```python
def _create_technical_indicators_chart(df: pd.DataFrame, indicators: list = ['MA'], title: str = None) -> bytes:
   """
   Create a chart with technical indicators
   
   Expected columns:
   - Date (optional): Timestamp for each data point
   - Close: Closing price (required)
   - Volume (optional): Trading volume
   
   Parameters:
   - df: pandas DataFrame with price data
   - indicators: List of indicators to include ['MA', 'MA20', 'MA50', 'MA200', 'RSI', 'MACD']
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Layout Options:
   - Single panel: Price with MA indicators
   - Two panels: Price with MA + RSI or MACD
   - Three panels: Price with MA + RSI + MACD
   
   Supported Indicators:
   - MA: Default 20-period moving average
   - MA20: 20-period moving average
   - MA50: 50-period moving average
   - MA200: 200-period moving average
   - RSI: Relative Strength Index (14-period)
   - MACD: Moving Average Convergence Divergence
   """
   import matplotlib.pyplot as plt
   import matplotlib.dates as mdates
   
   # Validate required columns
   if 'Close' not in df.columns:
       raise ValueError("Technical indicators chart requires 'Close' column")
   
   # Use index as date if no date column exists
   if 'Date' in df.columns:
       dates = df['Date']
   else:
       dates = df.index
   
   # Convert dates if they're not already datetime
   if not pd.api.types.is_datetime64_any_dtype(dates):
       dates = pd.to_datetime(dates)
   
   # Determine how many subplots we need
   has_rsi = 'RSI' in indicators
   has_macd = 'MACD' in indicators
   
   if has_rsi and has_macd:
       fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(12, 12),
                                          gridspec_kw={'height_ratios': [3, 1, 1]})
   elif has_rsi or has_macd:
       fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 10),
                                     gridspec_kw={'height_ratios': [3, 1]})
   else:
       fig, ax1 = plt.subplots(1, 1, figsize=(12, 8))
       ax2 = None  # Placeholder for later use
   
   # Plot price data on top subplot
   ax1.plot(dates, df['Close'], label='Close Price', color='#1f77b4', linewidth=1.5)
   
   # Add technical indicators to price chart
   if 'MA' in indicators or 'MA20' in indicators:
       ma20 = _calculate_moving_average(df['Close'], 20)
       ax1.plot(dates, ma20, label='MA(20)', color='#ff7f0e', linewidth=1)
   
   if 'MA50' in indicators:
       ma50 = _calculate_moving_average(df['Close'], 50)
       ax1.plot(dates, ma50, label='MA(50)', color='#2ca02c', linewidth=1)
   
   if 'MA200' in indicators:
       ma200 = _calculate_moving_average(df['Close'], 200)
       ax1.plot(dates, ma200, label='MA(200)', color='#d62728', linewidth=1)
   
   ax1.set_title(title or 'Price Chart with Technical Indicators', fontsize=14, fontweight='bold')
   ax1.set_ylabel('Price')
   ax1.legend(loc='upper left')
   ax1.grid(True, linestyle='--', alpha=0.6)
   
   # Plot RSI on bottom subplot if requested
   if has_rsi:
       rsi = _calculate_rsi(df['Close'])
       if has_macd:
           # If we have 3 subplots, ax2 is RSI
           ax2.plot(dates, rsi, label='RSI', color='#9467bd', linewidth=1)
           ax2.axhline(y=70, color='r', linestyle='--', alpha=0.7, label='Overbought (70)')
           ax2.axhline(y=30, color='g', linestyle='--', alpha=0.7, label='Oversold (30)')
           ax2.set_ylabel('RSI')
           ax2.set_ylim(0, 100)
           ax2.legend(loc='upper left')
           ax2.grid(True, linestyle='--', alpha=0.6)
           
           # Plot MACD on third subplot
           macd_line, signal_line, histogram = _calculate_macd(df['Close'])
           ax3.plot(dates, macd_line, label='MACD', color='#e377c2', linewidth=1)
           ax3.plot(dates, signal_line, label='Signal', color='#17becf', linewidth=1)
           ax3.bar(dates, histogram, label='Histogram', alpha=0.6, color='#aec7e8')
           ax3.set_ylabel('MACD')
           ax3.legend(loc='upper left')
           ax3.grid(True, linestyle='--', alpha=0.6)
       else:
           # If we have 2 subplots, ax2 is RSI
           ax2.plot(dates, rsi, label='RSI', color='#9467bd', linewidth=1)
           ax2.axhline(y=70, color='r', linestyle='--', alpha=0.7, label='Overbought (70)')
           ax2.axhline(y=30, color='g', linestyle='--', alpha=0.7, label='Oversold (30)')
           ax2.set_ylabel('RSI')
           ax2.set_ylim(0, 100)
           ax2.legend(loc='upper left')
           ax2.grid(True, linestyle='--', alpha=0.6)
   elif has_macd:
       # If we have 2 subplots and only MACD
       macd_line, signal_line, histogram = _calculate_macd(df['Close'])
       ax2.plot(dates, macd_line, label='MACD', color='#e377c2', linewidth=1)
       ax2.plot(dates, signal_line, label='Signal', color='#17becf', linewidth=1)
       ax2.bar(dates, histogram, label='Histogram', alpha=0.6, color='#aec7e8')
       ax2.set_ylabel('MACD')
       ax2.legend(loc='upper left')
       ax2.grid(True, linestyle='--', alpha=0.6)
   else:
       # If no RSI or MACD, just show volume if available
       if ax2 is not None and 'Volume' in df.columns:
           ax2.bar(dates, df['Volume'], alpha=0.6, label='Volume', color='#1f77b4')
           ax2.set_ylabel('Volume')
           ax2.legend(loc='upper left')
   
   # Format x-axis to show dates nicely
   if has_rsi and has_macd:
       for ax in [ax1, ax2, ax3]:
           ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
           ax.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
           ax.tick_params(axis='x', rotation=45)
   elif has_rsi or has_macd:
       for ax in [ax1, ax2]:
           ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
           ax.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
           ax.tick_params(axis='x', rotation=45)
   else:
       if ax2 is not None:
           ax1.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
           ax1.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
           ax1.tick_params(axis='x', rotation=45)
   
   plt.tight_layout()
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   return img_bytes
```

## Advanced Chart Features

### Volume Profile Charts
```python
def _create_volume_profile_chart(df: pd.DataFrame, title: str = None) -> bytes:
   """
   Create a volume profile chart showing trading volume at different price levels
   
   Expected columns:
   - Date (optional): Timestamp for each data point
   - Close: Closing price
   - Volume: Trading volume
   
   Parameters:
   - df: pandas DataFrame with price and volume data
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Layout:
   - Top panel: Price chart with moving averages
   - Bottom panel: Volume bars
   
   Features:
   - Displays price action with MA(20) and MA(50)
   - Shows volume bars for each period
   - Helps identify volume-price relationships
   - Useful for detecting breakouts and reversals
   """
   import matplotlib.pyplot as plt
   import matplotlib.dates as mdates
   import numpy as np
   
   # Validate required columns
   required_cols = ['Close', 'Volume']
   if not all(col in df.columns for col in required_cols):
       raise ValueError("Volume profile chart requires 'Close' and 'Volume' columns")
   
   # Use index as date if no date column exists
   if 'Date' in df.columns:
       dates = df['Date']
   else:
       dates = df.index
   
   # Convert dates if they're not already datetime
   if not pd.api.types.is_datetime64_any_dtype(dates):
       dates = pd.to_datetime(dates)
   
   fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(12, 10),
                                  gridspec_kw={'height_ratios': [3, 1]})
   
   # Plot price data on top subplot
   ax1.plot(dates, df['Close'], label='Close Price', color='#1f77b4', linewidth=1.5)
   
   # Add moving averages
   ma20 = df['Close'].rolling(window=20).mean()
   ma50 = df['Close'].rolling(window=50).mean()
   ax1.plot(dates, ma20, label='MA(20)', color='#ff7f0e', linewidth=1)
   ax1.plot(dates, ma50, label='MA(50)', color='#2ca02c', linewidth=1)
   
   ax1.set_title(title or 'Price Chart with Volume Profile', fontsize=14, fontweight='bold')
   ax1.set_ylabel('Price')
   ax1.legend(loc='upper left')
   ax1.grid(True, linestyle='--', alpha=0.6)
   
   # Plot volume bars on bottom subplot
   ax2.bar(dates, df['Volume'], alpha=0.6, label='Volume', color='#1f77b4')
   ax2.set_ylabel('Volume')
   ax2.set_xlabel('Date')
   ax2.legend(loc='upper left')
   ax2.grid(True, linestyle='--', alpha=0.6)
   
   # Format x-axis to show dates nicely
   for ax in [ax1, ax2]:
       ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
       ax.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
       ax.tick_params(axis='x', rotation=45)
   
   plt.tight_layout()
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   return img_bytes
```

### Multi-Series Charts
```python
def create_multi_series_chart(df: pd.DataFrame, series_column: str, value_columns: list, title: str = None) -> bytes:
   """
   Create a chart with multiple series based on a categorical column
   
   Parameters:
   - df: pandas DataFrame with data
   - series_column: Column name containing series identifiers
   - value_columns: List of column names to plot for each series
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Use Cases:
   - Compare multiple stocks or assets
   - Track performance across categories
   - Display grouped time series data
   """
   plt.figure(figsize=(12, 6))
   
   # Group by the series column and plot each value column
   grouped = df.groupby(series_column)
   
   for col in value_columns:
       for name, group in grouped:
           plt.plot(group.index, group[col], label=f'{name} - {col}', marker='o')
   
   plt.title(title or 'Multi-Series Chart')
   plt.xlabel('Index')
   plt.ylabel('Values')
   plt.legend()
   plt.grid(True, linestyle='--', alpha=0.6)
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   return img_bytes
```

### Time Series Charts
```python
def create_time_series_chart(df: pd.DataFrame, date_column: str, value_column: str, title: str = None) -> bytes:
   """
   Create a time series chart
   
   Parameters:
   - df: pandas DataFrame with time series data
   - date_column: Column name containing dates
   - value_column: Column name containing values to plot
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Features:
   - Automatic date formatting
   - Sorted chronological display
   - Grid lines for readability
   """
   # Ensure date column is datetime
   df[date_column] = pd.to_datetime(df[date_column])
   
   plt.figure(figsize=(12, 6))
   
   # Sort by date
   df_sorted = df.sort_values(date_column)
   
   plt.plot(df_sorted[date_column], df_sorted[value_column], marker='o')
   
   plt.title(title or f'Time Series: {value_column}')
   plt.xlabel('Date')
   plt.ylabel(value_column)
   plt.xticks(rotation=45)
   plt.grid(True, linestyle='--', alpha=0.6)
   plt.tight_layout()
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   return img_bytes
```

## Chart Type Detection

### Automatic Chart Type Selection
```python
def _detect_chart_type(df: pd.DataFrame) -> str:
   """
   Automatically detect the most appropriate chart type based on data characteristics
   
   Parameters:
   - df: pandas DataFrame with data
   
   Returns:
   - str: Recommended chart type
   
   Detection Logic:
   1. Check for OHLCV data → candlestick
   2. Check for Close price with sufficient data → technical
   3. Single numeric column, few rows → bar
   4. Single numeric column, many rows → line
   5. Two or more numeric columns → scatter
   6. One numeric + one categorical (≤10 categories) → bar
   7. Default → bar
   """
   numeric_cols = df.select_dtypes(include=['number']).columns
   categorical_cols = df.select_dtypes(include=['object', 'category']).columns
   
   # Check for financial data patterns (OHLCV)
   required_ohlcv = ['Open', 'High', 'Low', 'Close']
   has_ohlcv = all(col in df.columns for col in required_ohlcv)
   
   if has_ohlcv:
       # If OHLC data is present, suggest candlestick chart
       return 'candlestick'
   
   # Check for technical analysis data
   if 'Close' in df.columns and len(df) >= 20:
       # If Close price is present with sufficient data points, suggest technical indicators chart
       return 'technical'
   
   # If only one numeric column and few rows, suggest bar chart
   if len(numeric_cols) == 1 and len(df) <= 10:
       return 'bar'
   
   # If only one numeric column with many rows, suggest line chart
   if len(numeric_cols) == 1 and len(df) > 10:
       return 'line'
   
   # If two numeric columns, suggest scatter plot
   if len(numeric_cols) >= 2:
       return 'scatter'
   
   # If one numeric column and one categorical with few categories, suggest bar
   if len(numeric_cols) == 1 and len(categorical_cols) >= 1:
       if df[categorical_cols[0]].nunique() <= 10:
           return 'bar'
       else:
           return 'line'
   
   # Default to bar chart
   return 'bar'
```

## Styling Options

### Predefined Chart Styles
```python
def apply_style(chart_type: str, style_name: str = 'default'):
   """
   Apply predefined styles to charts
   
   Parameters:
   - chart_type: Type of chart being created
   - style_name: Name of the style to apply
   
   Available Styles:
   - default: Standard matplotlib styling
   - professional: Clean, business-appropriate colors
   - minimal: Minimalist grayscale design
   - colorful: Vibrant color palette
   - dark: Dark theme for low-light environments
   """
   styles = {
       'default': {
           'palette': 'tab10',
           'grid': True,
           'background': 'white'
       },
       'professional': {
           'palette': 'Set2',
           'grid': True,
           'background': 'white'
       },
       'minimal': {
           'palette': 'Greys',
           'grid': False,
           'background': 'white'
       },
       'colorful': {
           'palette': 'Set1',
           'grid': True,
           'background': 'white'
       },
       'dark': {
           'palette': 'Dark2',
           'grid': True,
           'background': 'black'
       }
   }
   
   style = styles.get(style_name, styles['default'])
   
   # Apply matplotlib style
   plt.style.use('default')
   if style['background'] == 'black':
       plt.style.use('dark_background')
   
   return style
```

### Seaborn Themes
```python
def apply_seaborn_theme(theme: str = 'whitegrid'):
   """
   Apply seaborn themes to charts
   
   Parameters:
   - theme: Seaborn theme name
   
   Available Themes:
   - white: Clean white background
   - dark: Dark background
   - whitegrid: White with grid lines
   - darkgrid: Dark with grid lines
   - ticks: Minimal with axis ticks
   """
   import seaborn as sns
   
   themes = ['white', 'dark', 'whitegrid', 'darkgrid', 'ticks']
   if theme in themes:
       sns.set_style(theme)
   else:
       sns.set_style('whitegrid')
```

### TradingView Style Theme
```python
def apply_tradingview_style():
   """
   Apply TradingView-like styling to charts with dark background and professional colors
   
   Features:
   - Dark background (#131722) matching TradingView
   - Professional color scheme for financial data
   - Subtle grid lines
   - Light gray text for readability
   - TradingView's signature green/red colors for price action
   
   Color Palette:
   - Green (bullish): #26a69a
   - Red (bearish): #ef5350
   - Blue: #42a5f5
   - Yellow: #ffca28
   - Purple: #ab47bc
   """
   import matplotlib.pyplot as plt
   
   # Set the style parameters for TradingView-like appearance
   plt.rcParams.update({
       'figure.facecolor': '#131722',  # Dark background
       'axes.facecolor': '#131722',   # Dark background for axes
       'savefig.facecolor': '#131722', # Dark background for saved figures
       'axes.edgecolor': '#2a2e39',    # Dark border color
       'axes.labelcolor': '#d1d4dc',   # Light gray text
       'xtick.color': '#d1d4dc',       # Light gray x-tick labels
       'ytick.color': '#d1d4dc',       # Light gray y-tick labels
       'grid.color': '#2a2e39',        # Dark grid lines
       'grid.alpha': 0.3,              # Grid transparency
       'text.color': '#d1d4dc',        # Light gray text
       'axes.prop_cycle': plt.cycler(color=['#26a69a', '#ef5350', '#42a5f5', '#ffca28', '#ab47bc']),  # Professional colors
   })
   
   # Apply the style to the current plot
   plt.style.use('default')

def reset_default_style():
   """
   Reset to default matplotlib style
   
   Use this after applying TradingView style to restore default settings
   """
   import matplotlib.pyplot as plt
   plt.rcdefaults()

def _create_tradingview_styled_chart(df: pd.DataFrame, chart_type: str = 'line', title: str = None) -> bytes:
   """
   Create a chart with TradingView-like styling
   
   Parameters:
   - df: pandas DataFrame with data
   - chart_type: Type of chart ('line', 'candlestick')
   - title: Optional title for the chart
   
   Returns:
   - bytes: Image data in PNG format
   
   Features:
   - Dark background matching TradingView
   - Professional color scheme
   - Automatic date formatting
   - TradingView-style candlestick colors
   """
   import matplotlib.pyplot as plt
   import matplotlib.dates as mdates
   
   # Apply TradingView style
   apply_tradingview_style()
   
   # Use index as date if no date column exists
   if 'Date' in df.columns:
       dates = df['Date']
   else:
       dates = df.index
   
   # Convert dates if they're not already datetime
   if not pd.api.types.is_datetime64_any_dtype(dates):
       dates = pd.to_datetime(dates)
   
   fig, ax = plt.subplots(figsize=(12, 8))
   
   # Plot based on chart type
   if chart_type == 'candlestick':
       # Validate required columns for candlestick
       required_cols = ['Open', 'High', 'Low', 'Close']
       if not all(col in df.columns for col in required_cols):
           chart_type = 'line'  # Fallback to line chart
       else:
           # Draw candlesticks with TradingView colors
           from matplotlib.patches import Rectangle
           
           for i in range(len(df)):
               date = mdates.date2num(dates.iloc[i])
               open_price = df['Open'].iloc[i]
               high_price = df['High'].iloc[i]
               low_price = df['Low'].iloc[i]
               close_price = df['Close'].iloc[i]
               
               # Determine if up or down candle (using TradingView colors)
               color = '#26a69a' if close_price >= open_price else '#ef5350'  # Green/red
               
               # Draw high-low line
               ax.plot([date, date], [low_price, high_price], color=color, linewidth=1)
               
               # Draw open-close rectangle
               height = abs(close_price - open_price)
               bottom = min(open_price, close_price)
               
               # Make the candle body slightly wider for visibility
               width = 0.6
               rect = Rectangle((date - width/2, bottom), width, height,
                               facecolor=color, edgecolor=color, alpha=0.8)
               ax.add_patch(rect)
   else:
       # Default to plotting the first numeric column
       numeric_cols = df.select_dtypes(include=['number']).columns
       if len(numeric_cols) > 0:
           ax.plot(dates, df[numeric_cols[0]], color='#26a69a', linewidth=1.5)
   
   ax.set_title(title or 'TradingView Styled Chart', fontsize=14, fontweight='bold', color='#d1d4dc')
   ax.set_xlabel('Date', color='#d1d4dc')
   ax.set_ylabel('Price', color='#d1d4dc')
   ax.grid(True, linestyle='--', alpha=0.3)
   
   # Format x-axis to show dates nicely
   ax.xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m-%d'))
   ax.xaxis.set_major_locator(mdates.DayLocator(interval=max(1, len(df)//10)))
   plt.xticks(rotation=45)
   
   plt.tight_layout()
   
   # Save to bytes
   from io import BytesIO
   img_buffer = BytesIO()
   plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
   img_buffer.seek(0)
   img_bytes = img_buffer.read()
   plt.close()
   
   # Reset to default style
   reset_default_style()
   
   return img_bytes
```

## Image Optimization

### Size Optimization
```python
from PIL import Image
import io

def optimize_chart_size(img_bytes: bytes, max_width: int = 800, max_height: int = 600) -> bytes:
   """
   Optimize chart image size for chat display
   
   Parameters:
   - img_bytes: Image data in bytes
   - max_width: Maximum width in pixels (default: 800)
   - max_height: Maximum height in pixels (default: 600)
   
   Returns:
   - bytes: Optimized image data
   
   Features:
   - Maintains aspect ratio
   - High-quality resampling (LANCZOS)
   - PNG optimization
   """
   img = Image.open(io.BytesIO(img_bytes))
   
   # Calculate new dimensions maintaining aspect ratio
   original_width, original_height = img.size
   ratio = min(max_width/original_width, max_height/original_height)
   
   new_width = int(original_width * ratio)
   new_height = int(original_height * ratio)
   
   # Resize image
   resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
   
   # Save optimized image
   output = io.BytesIO()
   resized_img.save(output, format='PNG', optimize=True, quality=85)
   optimized_bytes = output.getvalue()
   
   return optimized_bytes
```

### Format Conversion
```python
def convert_chart_format(img_bytes: bytes, target_format: str = 'PNG') -> bytes:
   """
   Convert chart image to different format
   
   Parameters:
   - img_bytes: Image data in bytes
   - target_format: Target format ('PNG', 'JPEG', 'SVG', 'WEBP')
   
   Returns:
   - bytes: Converted image data
   
   Supported Formats:
   - PNG: Lossless compression, supports transparency
   - JPEG: Lossy compression, smaller file size
   - SVG: Vector format, scalable
   - WEBP: Modern format with good compression
   """
   img = Image.open(io.BytesIO(img_bytes))
   
   output = io.BytesIO()
   img.save(output, format=target_format, optimize=True)
   converted_bytes = output.getvalue()
   
   return converted_bytes
```

## Integration with Chat Systems

### Base64 Encoding for Chat
```python
import base64

def encode_chart_for_chat(img_bytes: bytes) -> str:
   """
   Encode chart image bytes to base64 for chat systems
   
   Parameters:
   - img_bytes: Image data in bytes
   
   Returns:
   - str: Base64 encoded data URI
   
   Usage:
   - Embed images in HTML emails
   - Display in chat applications
   - Store in databases as text
   - Transfer over text-based protocols
   """
   encoded = base64.b64encode(img_bytes).decode('utf-8')
   return f"data:image/png;base64,{encoded}"
```

### Complete Processing Pipeline
```python
def create_chart_image(data, chart_type='auto', title=None, style='default', optimize=True, max_width=800, max_height=600):
   """
   Complete pipeline to create a chart image from various data sources
   
   Parameters:
   - data: Input data (DataFrame, CSV string, or JSON string)
   - chart_type: Type of chart to create
   - title: Optional title for the chart
   - style: Chart style ('default', 'professional', 'minimal', 'colorful', 'dark', 'tradingview')
   - optimize: Whether to optimize image size (default: True)
   - max_width: Maximum width for optimization (default: 800)
   - max_height: Maximum height for optimization (default: 600)
   
   Returns:
   - bytes: Chart image data
   
   Workflow:
   1. Detect data type and parse accordingly
   2. Validate data structure
   3. Apply styling if specified
   4. Generate chart
   5. Optimize if requested
   """
   # Determine data type and process accordingly
   if isinstance(data, pd.DataFrame):
       img_bytes = process_dataframe(data, chart_type, title)
   elif isinstance(data, str):
       # Assume it's CSV or JSON
       try:
           # Try JSON first
           import json
           parsed = json.loads(data)
           img_bytes = process_json(data, chart_type, title)
       except json.JSONDecodeError:
           # If not JSON, assume CSV
           import io
           try:
               pd.read_csv(io.StringIO(data))
               img_bytes = process_csv(data, chart_type, title)
           except pd.errors.ParserError:
               raise ValueError("String input must be valid CSV or JSON")
   else:
       raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
   
   # Apply styling
   if style == 'tradingview':
       apply_tradingview_style()
   else:
       apply_style(chart_type, style)
   
   # Optimize image if requested
   if optimize:
       img_bytes = optimize_chart_size(img_bytes, max_width, max_height)
   
   return img_bytes
```

## Error Handling

### Validation and Error Checking
```python
def validate_chart_data(data):
   """
   Validate input data for chart creation
   
   Parameters:
   - data: Input data to validate
   
   Returns:
   - bool: True if data is valid
   
   Raises:
   - ValueError: If data is invalid
   
   Validation Checks:
   - Data is not None
   - String data is valid CSV or JSON
   - DataFrame is not empty
   - DataFrame contains at least one numeric column
   """
   if data is None:
       raise ValueError("Input data cannot be None")
   
   if isinstance(data, str):
       # Check if it's valid CSV or JSON
       try:
           import json
           json.loads(data)
       except json.JSONDecodeError:
           # Try parsing as CSV
           import io
           try:
               pd.read_csv(io.StringIO(data))
           except pd.errors.ParserError:
               raise ValueError("String input must be valid CSV or JSON")
   
   elif isinstance(data, pd.DataFrame):
       if data.empty:
           raise ValueError("DataFrame cannot be empty")
       
       # Check if there's at least one numeric column for charting
       if len(data.select_dtypes(include=['number']).columns) == 0:
           raise ValueError("DataFrame must contain at least one numeric column for charting")
   else:
       raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
   
   return True
```

## Usage Examples

### Basic Usage Examples

#### Example 1: From DataFrame
```python
import pandas as pd

# Create sample data
df = pd.DataFrame({
    'Month': ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
    'Sales': [100, 150, 200, 120, 180],
    'Profit': [20, 30, 40, 25, 35]
})

# Create a line chart
img_bytes = create_chart_image(df, chart_type='line', title="Monthly Sales Trend")

# Create a bar chart
img_bytes = create_chart_image(df, chart_type='bar', title="Monthly Sales")

# Create a pie chart
img_bytes = create_chart_image(df, chart_type='pie', title="Sales Distribution")
```

#### Example 2: From CSV String
```python
csv_data = """Month,Sales,Profit
Jan,100,20
Feb,150,30
Mar,200,40
Apr,120,25
May,180,35"""

img_bytes = create_chart_image(csv_data, chart_type='line', title="Sales Trend from CSV")
```

#### Example 3: From JSON String
```python
json_data = '''[
    {"Month": "Jan", "Sales": 100, "Profit": 20},
    {"Month": "Feb", "Sales": 150, "Profit": 30},
    {"Month": "Mar", "Sales": 200, "Profit": 40},
    {"Month": "Apr", "Sales": 120, "Profit": 25},
    {"Month": "May", "Sales": 180, "Profit": 35}
]'''

img_bytes = create_chart_image(json_data, chart_type='bar', title="Sales from JSON")
```

### Financial Chart Examples

#### Example 4: Basic Candlestick Chart
```python
import pandas as pd

# Create sample financial data
financial_df = pd.DataFrame({
   'Date': pd.date_range(start='2023-01-01', periods=30),
   'Open': [100, 102, 101, 98, 105] * 6,
   'High': [105, 107, 103, 102, 108] * 6,
   'Low': [97, 100, 96, 95, 103] * 6,
   'Close': [103, 99, 102, 101, 106] * 6,
   'Volume': [1000, 1200, 800, 1500, 2000] * 6
})

# Create a candlestick chart
img_bytes = create_chart_image(
   financial_df, 
   chart_type='candlestick', 
   title="Stock Price Candlestick Chart"
)
```

#### Example 5: OHLC Chart
```python
# Create an OHLC chart
img_bytes = create_chart_image(
   financial_df, 
   chart_type='ohlc', 
   title="Stock Price OHLC Chart"
)
```

#### Example 6: Technical Indicators with MA
```python
# Create a technical indicators chart with moving averages
img_bytes = create_chart_image(
   financial_df, 
   chart_type='technical', 
   title="Price with Moving Averages"
)
```

#### Example 7: Technical Indicators with RSI
```python
# Create a technical indicators chart with RSI
img_bytes = create_chart_image(
   financial_df, 
   chart_type='technical', 
   indicators=['MA', 'RSI'],
   title="Price with MA and RSI"
)
```

#### Example 8: Technical Indicators with MACD
```python
# Create a technical indicators chart with MACD
img_bytes = create_chart_image(
   financial_df, 
   chart_type='technical', 
   indicators=['MA', 'MACD'],
   title="Price with MA and MACD"
)
```

#### Example 9: Full Technical Analysis
```python
# Create a comprehensive technical analysis chart
img_bytes = create_chart_image(
   financial_df, 
   chart_type='technical', 
   indicators=['MA', 'RSI', 'MACD'],
   title="Complete Technical Analysis"
)
```

#### Example 10: Volume Profile Chart
```python
# Create a volume profile chart
img_bytes = create_chart_image(
   financial_df, 
   chart_type='volume', 
   title="Volume Profile Chart"
)
```

#### Example 11: TradingView-Style Candlestick
```python
# Create a TradingView-styled candlestick chart
img_bytes = create_chart_image(
   financial_df, 
   chart_type='tradingview', 
   title="TradingView Style Chart"
)
```

#### Example 12: Multiple Moving Averages
```python
# Create chart with multiple moving averages
img_bytes = create_chart_image(
   financial_df, 
   chart_type='technical', 
   indicators=['MA20', 'MA50', 'MA200'],
   title="Price with Multiple Moving Averages"
)
```

### Advanced Usage Examples

#### Example 13: Custom Technical Indicators
```python
# Create custom technical analysis
img_bytes = _create_technical_indicators_chart(
   financial_df,
   indicators=['MA20', 'MA50', 'RSI'],
   title="Custom Technical Analysis"
)
```

#### Example 14: Optimized for Chat
```python
# Create optimized chart for chat display
img_bytes = create_chart_image(
   financial_df,
   chart_type='candlestick',
   title="Optimized Chart",
   optimize=True,
   max_width=600,
   max_height=400
)
```

#### Example 15: Base64 Encoded for Web
```python
# Create and encode chart for web display
img_bytes = create_chart_image(
   financial_df,
   chart_type='tradingview',
   title="Web Chart"
)
base64_data = encode_chart_for_chat(img_bytes)
# Use base64_data in HTML: <img src="{base64_data}" />
```

### Real-World Scenarios

#### Example 16: Stock Market Analysis
```python
# Analyze stock market data
stock_data = pd.DataFrame({
   'Date': pd.date_range(start='2023-01-01', periods=90),
   'Open': np.random.normal(100, 5, 90),
   'High': np.random.normal(105, 5, 90),
   'Low': np.random.normal(95, 5, 90),
   'Close': np.random.normal(100, 5, 90),
   'Volume': np.random.randint(1000000, 5000000, 90)
})

# Ensure High >= Open, Close and Low <= Open, Close
stock_data['High'] = stock_data[['Open', 'Close']].max(axis=1) + np.random.uniform(0, 5, 90)
stock_data['Low'] = stock_data[['Open', 'Close']].min(axis=1) - np.random.uniform(0, 5, 90)

img_bytes = create_chart_image(
   stock_data,
   chart_type='technical',
   indicators=['MA20', 'MA50', 'RSI', 'MACD'],
   title="Stock Market Technical Analysis"
)
```

#### Example 17: Cryptocurrency Price Chart
```python
# Visualize cryptocurrency prices
crypto_df = pd.DataFrame({
   'Date': pd.date_range(start='2023-01-01', periods=60),
   'Open': np.random.normal(30000, 2000, 60),
   'High': np.random.normal(32000, 2000, 60),
   'Low': np.random.normal(28000, 2000, 60),
   'Close': np.random.normal(30000, 2000, 60),
   'Volume': np.random.randint(100000000, 500000000, 60)
})

# Ensure proper OHLC relationships
crypto_df['High'] = crypto_df[['Open', 'Close']].max(axis=1) + np.random.uniform(0, 1000, 60)
crypto_df['Low'] = crypto_df[['Open', 'Close']].min(axis=1) - np.random.uniform(0, 1000, 60)

img_bytes = create_chart_image(
   crypto_df,
   chart_type='candlestick',
   style='tradingview',
   title="Cryptocurrency Price Chart"
)
```

#### Example 18: Multi-Asset Comparison
```python
# Compare multiple assets
assets_df = pd.DataFrame({
   'Date': pd.date_range(start='2023-01-01', periods=30),
   'Stock_A': np.random.normal(100, 10, 30),
   'Stock_B': np.random.normal(150, 15, 30),
   'Stock_C': np.random.normal(200, 20, 30)
})

img_bytes = create_chart_image(
   assets_df,
   chart_type='line',
   title="Multi-Asset Performance Comparison"
)
```

## Parameter Specifications

### Financial Data Parameters

#### OHLCV Data Structure
```python
# Required columns for financial charts
financial_data_columns = {
   'Date': {          # Optional - timestamp
       'type': 'datetime64[ns]',
       'required': False,
       'description': 'Timestamp for each data point',
       'default': 'Index'
   },
   'Open': {          # Required
       'type': 'float64',
       'required': True,
       'description': 'Opening price for the period',
       'range': 'positive numbers'
   },
   'High': {          # Required
       'type': 'float64',
       'required': True,
       'description': 'Highest price during the period',
       'constraint': 'High >= Open, Close'
   },
   'Low': {           # Required
       'type': 'float64',
       'required': True,
       'description': 'Lowest price during the period',
       'constraint': 'Low <= Open, Close'
   },
   'Close': {         # Required
       'type': 'float64',
       'required': True,
       'description': 'Closing price for the period',
       'range': 'positive numbers'
   },
   'Volume': {        # Optional
       'type': 'int64',
       'required': False,
       'description': 'Trading volume for the period',
       'range': 'non-negative integers'
   }
}
```

#### Chart Type Parameters
```python
chart_type_parameters = {
   'candlestick': {
       'required_columns': ['Open', 'High', 'Low', 'Close'],
       'optional_columns': ['Date', 'Volume'],
       'best_for': 'Price action analysis, trend identification',
       'min_data_points': 10
   },
   'ohlc': {
       'required_columns': ['Open', 'High', 'Low', 'Close'],
       'optional_columns': ['Date', 'Volume'],
       'best_for': 'Traditional financial analysis',
       'min_data_points': 10
   },
   'technical': {
       'required_columns': ['Close'],
       'optional_columns': ['Date', 'Volume', 'Open', 'High', 'Low'],
       'best_for': 'Technical analysis with indicators',
       'min_data_points': 20,
       'supported_indicators': ['MA', 'MA20', 'MA50', 'MA200', 'RSI', 'MACD']
   },
   'volume': {
       'required_columns': ['Close', 'Volume'],
       'optional_columns': ['Date', 'Open', 'High', 'Low'],
       'best_for': 'Volume-price analysis',
       'min_data_points': 10
   },
   'tradingview': {
       'required_columns': ['Open', 'High', 'Low', 'Close'],
       'optional_columns': ['Date', 'Volume'],
       'best_for': 'Professional financial presentation',
       'min_data_points': 10
   }
}
```

#### Technical Indicator Parameters
```python
indicator_parameters = {
   'MA': {
       'full_name': 'Moving Average',
       'default_window': 20,
       'required_data': 'Close price',
       'calculation': 'Simple Moving Average (SMA)',
       'common_windows': [5, 10, 20, 50, 100, 200],
       'interpretation': {
           'above': 'Bullish trend',
           'below': 'Bearish trend',
           'crossover_up': 'Buy signal',
           'crossover_down': 'Sell signal'
       }
   },
   'RSI': {
       'full_name': 'Relative Strength Index',
       'default_window': 14,
       'required_data': 'Close price',
       'calculation': 'Momentum oscillator',
       'range': '0-100',
       'key_levels': {
           'overbought': 70,
           'oversold': 30,
           'neutral': 50
       },
       'interpretation': {
           '> 70': 'Overbought, potential reversal',
           '< 30': 'Oversold, potential reversal',
           'divergence': 'Trend reversal signal'
       }
   },
   'MACD': {
       'full_name': 'Moving Average Convergence Divergence',
       'default_parameters': {'fast': 12, 'slow': 26, 'signal': 9},
       'required_data': 'Close price',
       'calculation': 'Trend-following momentum indicator',
       'components': ['MACD Line', 'Signal Line', 'Histogram'],
       'interpretation': {
           'macd_above_signal': 'Bullish momentum',
           'macd_below_signal': 'Bearish momentum',
           'crossover_up': 'Buy signal',
           'crossover_down': 'Sell signal',
           'histogram_positive': 'Increasing bullish momentum',
           'histogram_negative': 'Increasing bearish momentum'
       }
   }
}
```

#### Styling Parameters
```python
styling_parameters = {
   'tradingview': {
       'background': '#131722',
       'grid_color': '#2a2e39',
       'grid_alpha': 0.3,
       'text_color': '#d1d4dc',
       'bullish_color': '#26a69a',
       'bearish_color': '#ef5350',
       'accent_colors': ['#42a5f5', '#ffca28', '#ab47bc']
   },
   'default': {
       'background': 'white',
       'grid_color': 'gray',
       'grid_alpha': 0.6,
       'text_color': 'black',
       'palette': 'tab10'
   },
   'professional': {
       'background': 'white',
       'grid_color': 'lightgray',
       'grid_alpha': 0.5,
       'text_color': 'black',
       'palette': 'Set2'
   },
   'dark': {
       'background': 'black',
       'grid_color': 'gray',
       'grid_alpha': 0.3,
       'text_color': 'white',
       'palette': 'Dark2'
   }
}
```

#### Output Parameters
```python
output_parameters = {
   'format': {
       'supported': ['PNG', 'JPEG', 'SVG', 'WEBP'],
       'default': 'PNG',
       'recommendations': {
           'web_display': 'PNG or WEBP',
           'print': 'PNG or JPEG',
           'vector': 'SVG'
       }
   },
   'resolution': {
       'default_dpi': 150,
       'high_quality': 300,
       'web_optimized': 72,
       'recommendation': '150 DPI for most use cases'
   },
   'dimensions': {
       'default_width': 800,
       'default_height': 600,
       'max_width': 1920,
       'max_height': 1080,
       'aspect_ratio': 'maintained during optimization'
   },
   'optimization': {
       'enabled': True,
       'max_width': 800,
       'max_height': 600,
       'quality': 85,
       'method': 'LANCZOS resampling'
   }
}
```

## Integration Guidelines

### Financial Application Integration

#### 1. Data Preparation
```python
def prepare_financial_data(raw_data, time_period='daily'):
   """
   Prepare raw financial data for charting
   
   Parameters:
   - raw_data: Raw financial data (dict, list, or DataFrame)
   - time_period: Time aggregation ('daily', 'weekly', 'monthly')
   
   Returns:
   - pd.DataFrame: Prepared data with OHLCV columns
   
   Steps:
   1. Convert to DataFrame
   2. Ensure proper column names
   3. Validate OHLC relationships
   4. Handle missing values
   5. Aggregate if needed
   """
   import numpy as np
   
   # Convert to DataFrame
   df = pd.DataFrame(raw_data)
   
   # Standardize column names
   column_mapping = {
       'timestamp': 'Date',
       'datetime': 'Date',
       'time': 'Date',
       'open': 'Open',
       'high': 'High',
       'low': 'Low',
       'close': 'Close',
       'vol': 'Volume',
       'volume': 'Volume'
   }
   df = df.rename(columns=column_mapping)
   
   # Ensure Date is datetime
   if 'Date' in df.columns:
       df['Date'] = pd.to_datetime(df['Date'])
   
   # Validate OHLC relationships
   if all(col in df.columns for col in ['Open', 'High', 'Low', 'Close']):
       # Ensure High >= Open, Close and Low <= Open, Close
       df['High'] = df[['Open', 'Close']].max(axis=1).combine_max(df['High'])
       df['Low'] = df[['Open', 'Close']].min(axis=1).combine_min(df['Low'])
   
   # Handle missing values
   df = df.fillna(method='ffill').fillna(method='bfill')
   
   # Aggregate if needed
   if time_period != 'daily':
       df = df.set_index('Date')
       agg_dict = {
           'Open': 'first',
           'High': 'max',
           'Low': 'min',
           'Close': 'last',
           'Volume': 'sum'
       }
       df = df.resample(time_period).agg(agg_dict).dropna()
       df = df.reset_index()
   
   return df
```

#### 2. Chart Generation Service```python
class ChartGenerationService:
   """
   Service class for generating charts in financial applications
   
   Features:
   - Caching for frequently generated charts
   - Error handling and logging
   - Configuration management
   - Multiple output formats
   """
   
   def __init__(self, cache_enabled=True, cache_ttl=3600):
       self.cache_enabled = cache_enabled
       self.cache_ttl = cache_ttl
       self.chart_cache = {}
   
   def generate_chart(self, data, chart_type, **kwargs):
       """
       Generate a chart with caching support
       
       Parameters:
       - data: Input data
       - chart_type: Type of chart
       - **kwargs: Additional parameters
       
       Returns:
       - bytes: Chart image data
       """
       # Generate cache key
       cache_key = self._generate_cache_key(data, chart_type, kwargs)
       
       # Check cache
       if self.cache_enabled and cache_key in self.chart_cache:
           cached_data, timestamp = self.chart_cache[cache_key]
           if time.time() - timestamp < self.cache_ttl:
               return cached_data
       
       # Generate chart
       img_bytes = create_chart_image(data, chart_type, **kwargs)
       
       # Cache result
       if self.cache_enabled:
           self.chart_cache[cache_key] = (img_bytes, time.time())
       
       return img_bytes
   
   def _generate_cache_key(self, data, chart_type, kwargs):
       """Generate a unique cache key"""
       import hashlib
       key_str = f"{str(data)}_{chart_type}_{str(sorted(kwargs.items()))}"
       return hashlib.md5(key_str.encode()).hexdigest()
```

#### 3. API Integration
```python
from fastapi import FastAPI, HTTPException
from fastapi.responses import Response

app = FastAPI()

@app.post("/api/chart")
async def generate_chart_endpoint(
   data: dict,
   chart_type: str = 'auto',
   title: str = None,
   style: str = 'default'
):
   """
   REST API endpoint for chart generation
   
   Request Body:
   - data: Chart data (object or array)
   - chart_type: Type of chart
   - title: Chart title
   - style: Chart style
   
   Returns:
   - Image file
   """
   try:
       # Convert data to DataFrame
       df = pd.DataFrame(data)
       
       # Generate chart
       img_bytes = create_chart_image(df, chart_type, title, style)
       
       # Return image
       return Response(content=img_bytes, media_type="image/png")
   
   except Exception as e:
       raise HTTPException(status_code=400, detail=str(e))

@app.post("/api/financial-chart")
async def generate_financial_chart(
   data: dict,
   chart_type: str = 'candlestick',
   indicators: list = [],
   style: str = 'tradingview'
):
   """
   REST API endpoint for financial chart generation
   
   Request Body:
   - data: OHLCV data
   - chart_type: Type of financial chart
   - indicators: List of technical indicators
   - style: Chart style
   
   Returns:
   - Image file
   """
   try:
       # Prepare data
       df = prepare_financial_data(data)
       
       # Generate chart
       if chart_type == 'technical':
           img_bytes = _create_technical_indicators_chart(df, indicators)
       elif chart_type == 'tradingview':
           img_bytes = _create_tradingview_styled_chart(df, 'candlestick')
       else:
           img_bytes = create_chart_image(df, chart_type, style=style)
       
       # Return image
       return Response(content=img_bytes, media_type="image/png")
   
   except Exception as e:
       raise HTTPException(status_code=400, detail=str(e))
```

#### 4. Chatbot Integration
```python
class ChatbotChartIntegration:
   """
   Integration helper for chatbot applications
   
   Features:
   - Natural language chart type detection
   - Automatic data formatting
   - Base64 encoding for chat platforms
   - Error handling and user feedback
   """
   
   def __init__(self):
       self.chart_keywords = {
           'candlestick': ['candle', 'candlestick', 'ohlc', 'price action'],
           'line': ['line', 'trend', 'over time'],
           'bar': ['bar', 'comparison', 'compare'],
           'technical': ['technical', 'indicators', 'analysis', 'ma', 'rsi', 'macd'],
           'volume': ['volume', 'trading volume']
       }
   
   def detect_chart_type(self, message: str) -> str:
       """
       Detect chart type from natural language message
       
       Parameters:
       - message: User message
       
       Returns:
       - str: Detected chart type
       """
       message_lower = message.lower()
       
       for chart_type, keywords in self.chart_keywords.items():
           if any(keyword in message_lower for keyword in keywords):
               return chart_type
       
       return 'auto'
   
   def generate_chart_for_chat(self, data, message: str) -> dict:
       """
       Generate chart for chatbot response
       
       Parameters:
       - data: Chart data
       - message: User message for context
       
       Returns:
       - dict: Response with base64 encoded image
       """
       try:
           # Detect chart type
           chart_type = self.detect_chart_type(message)
           
           # Generate chart
           img_bytes = create_chart_image(data, chart_type)
           
           # Encode for chat
           base64_data = encode_chart_for_chat(img_bytes)
           
           return {
               'success': True,
               'image': base64_data,
               'chart_type': chart_type
           }
       
       except Exception as e:
           return {
               'success': False,
               'error': str(e)
           }
```

### Web Application Integration

#### 1. React Component
```javascript
import React, { useState } from 'react';

const ChartImage = ({ data, chartType, title, style }) => {
   const [imageUrl, setImageUrl] = useState(null);
   const [loading, setLoading] = useState(false);
   const [error, setError] = useState(null);

   const generateChart = async () => {
       setLoading(true);
       setError(null);

       try {
           const response = await fetch('/api/chart', {
               method: 'POST',
               headers: {
                   'Content-Type': 'application/json',
               },
               body: JSON.stringify({
                   data,
                   chart_type: chartType,
                   title,
                   style
               })
           });

           if (!response.ok) {
               throw new Error('Failed to generate chart');
           }

           const blob = await response.blob();
           const url = URL.createObjectURL(blob);
           setImageUrl(url);
       } catch (err) {
           setError(err.message);
       } finally {
           setLoading(false);
       }
   };

   React.useEffect(() => {
       generateChart();
   }, [data, chartType, title, style]);

   if (loading) {
       return <div className="chart-loading">Generating chart...</div>;
   }

   if (error) {
       return <div className="chart-error">Error: {error}</div>;
   }

   return (
       <div className="chart-container">
           {imageUrl && <img src={imageUrl} alt={title || 'Chart'} />}
       </div>
   );
};

export default ChartImage;
```

#### 2. Python Flask Integration
```python
from flask import Flask, request, jsonify, send_file
import io

app = Flask(__name__)

@app.route('/chart', methods=['POST'])
def generate_chart():
   """
   Flask endpoint for chart generation
   """
   try:
       # Get request data
       data = request.json.get('data')
       chart_type = request.json.get('chart_type', 'auto')
       title = request.json.get('title')
       style = request.json.get('style', 'default')
       
       # Generate chart
       img_bytes = create_chart_image(data, chart_type, title, style)
       
       # Return image
       return send_file(
           io.BytesIO(img_bytes),
           mimetype='image/png',
           as_attachment=False,
           download_name='chart.png'
       )
   
   except Exception as e:
       return jsonify({'error': str(e)}), 400

if __name__ == '__main__':
   app.run(debug=True)
```

### Database Integration

#### 1. Storing Charts in Database
```python
import sqlite3
from datetime import datetime

class ChartStorage:
   """
   Store and retrieve charts from database
   """
   
   def __init__(self, db_path='charts.db'):
       self.db_path = db_path
       self._init_db()
   
   def _init_db(self):
       """Initialize database schema"""
       conn = sqlite3.connect(self.db_path)
       cursor = conn.cursor()
       
       cursor.execute('''
           CREATE TABLE IF NOT EXISTS charts (
               id INTEGER PRIMARY KEY AUTOINCREMENT,
               data_hash TEXT NOT NULL,
               chart_type TEXT NOT NULL,
               image_data BLOB NOT NULL,
               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
           )
       ''')
       
       conn.commit()
       conn.close()
   
   def save_chart(self, data, chart_type, img_bytes):
       """
       Save chart to database
       
       Parameters:
       - data: Input data
       - chart_type: Chart type
       - img_bytes: Image data
       
       Returns:
       - int: Chart ID
       """
       import hashlib
       
       # Generate data hash
       data_hash = hashlib.md5(str(data).encode()).hexdigest()
       
       # Save to database
       conn = sqlite3.connect(self.db_path)
       cursor = conn.cursor()
       
       cursor.execute('''
           INSERT INTO charts (data_hash, chart_type, image_data)
           VALUES (?, ?, ?)
       ''', (data_hash, chart_type, img_bytes))
       
       chart_id = cursor.lastrowid
       conn.commit()
       conn.close()
       
       return chart_id
   
   def get_chart(self, chart_id):
       """
       Retrieve chart from database
       
       Parameters:
       - chart_id: Chart ID
       
       Returns:
       - bytes: Image data
       """
       conn = sqlite3.connect(self.db_path)
       cursor = conn.cursor()
       
       cursor.execute('''
           SELECT image_data FROM charts WHERE id = ?
       ''', (chart_id,))
       
       result = cursor.fetchone()
       conn.close()
       
       if result:
           return result[0]
       else:
           return None
```

## Comparison: Old vs New Capabilities

### Feature Comparison Table

| Feature | Before Enhancement | After Enhancement |
|---------|-------------------|-------------------|
| **Chart Types** | Line, Bar, Pie, Scatter, Histogram, Heatmap | + Candlestick, OHLC, Technical, Volume, TradingView |
| **Financial Data** | Basic line charts for prices | Full OHLCV support with specialized charts |
| **Technical Indicators** | None | MA, RSI, MACD with multi-panel layouts |
| **Styling** | Default matplotlib styles | + TradingView dark theme, professional color schemes |
| **Auto-Detection** | Basic numeric/categorical detection | + OHLCV pattern recognition, financial data detection |
| **Multi-Panel Charts** | Single panel only | + Multi-panel layouts for technical analysis |
| **Volume Support** | None | + Volume profile charts, volume bars |
| **Professional Appearance** | Basic charts | + TradingView-like styling, candlestick colors |
| **Data Validation** | Basic validation | + OHLC relationship validation, financial data checks |
| **Integration Ready** | Basic functions | + Service classes, API endpoints, chatbot helpers |

### Capability Expansion

#### Before: Basic Data Visualization
```python
# Old way - limited financial support
df = pd.DataFrame({
   'Date': pd.date_range('2023-01-01', periods=30),
   'Close': np.random.normal(100, 10, 30)
})

# Only line charts available
img = create_chart_image(df, chart_type='line', title="Price Chart")
```

#### After: Professional Financial Charting
```python
# New way - comprehensive financial support
financial_df = pd.DataFrame({
   'Date': pd.date_range('2023-01-01', periods=30),
   'Open': np.random.normal(100, 10, 30),
   'High': np.random.normal(105, 10, 30),
   'Low': np.random.normal(95, 10, 30),
   'Close': np.random.normal(100, 10, 30),
   'Volume': np.random.randint(1000000, 5000000, 30)
})

# Multiple professional chart types
img_candlestick = create_chart_image(financial_df, chart_type='candlestick')
img_technical = create_chart_image(financial_df, chart_type='technical', indicators=['MA', 'RSI', 'MACD'])
img_tradingview = create_chart_image(financial_df, chart_type='tradingview', style='tradingview')
```

### Use Case Expansion

#### Before: General Data Visualization
- Business reports with basic charts
- Scientific data visualization
- Simple trend analysis
- Basic comparisons

#### After: Financial Applications
- Stock market analysis
- Cryptocurrency tracking
- Technical analysis reports
- Trading dashboards
- Financial news integration
- Investment research
- Portfolio visualization
- Market sentiment analysis

## Best Practices

### Performance Optimization

#### 1. Data Aggregation
```python
def aggregate_financial_data(df, period='daily'):
   """
   Aggregate high-frequency data for better performance
   
   Parameters:
   - df: High-frequency OHLCV data
   - period: Aggregation period ('1min', '5min', '1H', '1D', '1W')
   
   Returns:
   - pd.DataFrame: Aggregated data
   """
   df = df.set_index('Date')
   
   agg_dict = {
       'Open': 'first',
       'High': 'max',
       'Low': 'min',
       'Close': 'last',
       'Volume': 'sum'
   }
   
   return df.resample(period).agg(agg_dict).dropna().reset_index()
```

#### 2. Caching Strategy
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def cached_chart_generation(data_hash, chart_type, **kwargs):
   """
   Cached chart generation for frequently requested charts
   
   Parameters:
   - data_hash: Hash of input data
   - chart_type: Type of chart
   - **kwargs: Additional parameters
   
   Returns:
   - bytes: Chart image data
   """
   # Generate chart
   img_bytes = create_chart_image(data_hash, chart_type, **kwargs)
   return img_bytes
```

#### 3. Lazy Loading
```python
class LazyChartGenerator:
   """
   Lazy chart generation for large datasets
   """
   
   def __init__(self, data):
       self.data = data
       self._chart_cache = {}
   
   def get_chart(self, chart_type, **kwargs):
       """
       Get chart, generating only when first requested
       """
       cache_key = (chart_type, tuple(sorted(kwargs.items())))
       
       if cache_key not in self._chart_cache:
           self._chart_cache[cache_key] = create_chart_image(
               self.data, chart_type, **kwargs
           )
       
       return self._chart_cache[cache_key]
```

### Accessibility

#### 1. Colorblind-Friendly Palettes
```python
colorblind_palettes = {
   'viridis': ['#440154', '#31688e', '#35b779', '#fde725'],
   'plasma': ['#0d0887', '#6a00a8', '#b12a90', '#e16462', '#fca636'],
   'cividis': ['#00204d', '#5e3c99', '#f0f921']
}

def apply_colorblind_palette(palette_name='viridis'):
   """
   Apply colorblind-friendly palette to charts
   """
   colors = colorblind_palettes.get(palette_name, colorblind_palettes['viridis'])
   plt.rcParams['axes.prop_cycle'] = plt.cycler(color=colors)
```

#### 2. High Contrast Mode
```python
def apply_high_contrast():
   """
   Apply high contrast styling for accessibility
   """
   plt.rcParams.update({
       'axes.facecolor': 'white',
       'figure.facecolor': 'white',
       'axes.edgecolor': 'black',
       'axes.labelcolor': 'black',
       'xtick.color': 'black',
       'ytick.color': 'black',
       'text.color': 'black',
       'grid.color': 'gray',
       'grid.alpha': 0.5
   })
```

#### 3. Alternative Text Generation
```python
def generate_chart_alt_text(df, chart_type, title):
   """
   Generate descriptive alternative text for charts
   
   Parameters:
   - df: Chart data
   - chart_type: Type of chart
   - title: Chart title
   
   Returns:
   - str: Descriptive alt text
   """
   if chart_type == 'candlestick':
       return f"{title}: Candlestick chart showing {len(df)} trading periods. " \
              f"Price range from {df['Low'].min():.2f} to {df['High'].max():.2f}. " \
              f"Latest close: {df['Close'].iloc[-1]:.2f}."
   
   elif chart_type == 'technical':
       return f"{title}: Technical analysis chart with price and indicators. " \
              f"Showing {len(df)} data points with moving averages and momentum indicators."
   
   else:
       return f"{title}: {chart_type} chart displaying {len(df)} data points."
```

### Financial Charting Best Practices

#### 1. Data Quality
```python
def validate_ohlcv_data(df):
   """
   Validate OHLCV data quality
   
   Parameters:
   - df: OHLCV DataFrame
   
   Returns:
   - dict: Validation results
   """
   issues = []
   
   # Check for required columns
   required_cols = ['Open', 'High', 'Low', 'Close']
   missing_cols = [col for col in required_cols if col not in df.columns]
   if missing_cols:
       issues.append(f"Missing required columns: {missing_cols}")
   
   # Check OHLC relationships
   if all(col in df.columns for col in required_cols):
       invalid_high = df[df['High'] < df[['Open', 'Close']].max(axis=1)]
       if len(invalid_high) > 0:
           issues.append(f"{len(invalid_high)} rows have High < max(Open, Close)")
       
       invalid_low = df[df['Low'] > df[['Open', 'Close']].min(axis=1)]
       if len(invalid_low) > 0:
           issues.append(f"{len(invalid_low)} rows have Low > min(Open, Close)")
   
   # Check for negative values
   numeric_cols = df.select_dtypes(include=['number']).columns
   for col in numeric_cols:
       if (df[col] < 0).any():
           issues.append(f"Column {col} contains negative values")
   
   # Check for missing values
   missing_values = df.isnull().sum()
   if missing_values.any():
       issues.append(f"Missing values: {missing_values[missing_values > 0].to_dict()}")
   
   return {
       'valid': len(issues) == 0,
       'issues': issues
   }
```

#### 2. Appropriate Chart Selection
```python
def recommend_chart_type(df, analysis_type='general'):
   """
   Recommend appropriate chart type based on data and analysis type
   
   Parameters:
   - df: DataFrame with data
   - analysis_type: Type of analysis ('general', 'trend', 'momentum', 'volume')
   
   Returns:
   - str: Recommended chart type
   """
   # Check for OHLCV data
   has_ohlcv = all(col in df.columns for col in ['Open', 'High', 'Low', 'Close'])
   
   if not has_ohlcv:
       # Non-financial data
       return _detect_chart_type(df)
   
   # Financial data recommendations
   if analysis_type == 'trend':
       return 'candlestick'  # Best for trend analysis
   elif analysis_type == 'momentum':
       return 'technical'  # Best with RSI/MACD
   elif analysis_type == 'volume':
       return 'volume'  # Best for volume analysis
   elif len(df) < 20:
       return 'candlestick'  # Simple chart for short periods
   else:
       return 'technical'  # Comprehensive analysis for longer periods
```

#### 3. Indicator Selection
```python
def recommend_indicators(df, timeframe='daily'):
   """
   Recommend appropriate technical indicators based on timeframe
   
   Parameters:
   - df: DataFrame with price data
   - timeframe: Timeframe of data ('intraday', 'daily', 'weekly', 'monthly')
   
   Returns:
   - list: Recommended indicators
   """
   indicators = []
   
   # Always include basic MA
   indicators.append('MA20')
   
   if timeframe == 'intraday':
       # Short-term indicators
       indicators.extend(['MA5', 'MA10'])
   elif timeframe == 'daily':
       # Medium-term indicators
       indicators.extend(['MA50', 'RSI'])
   elif timeframe in ['weekly', 'monthly']:
       # Long-term indicators
       indicators.extend(['MA50', 'MA200', 'MACD'])
   
   return indicators
```

#### 4. Timeframe Considerations
```python
def optimize_chart_for_timeframe(df, timeframe):
   """
   Optimize chart parameters for different timeframes
   
   Parameters:
   - df: DataFrame with data
   - timeframe: Timeframe of data
   
   Returns:
   - dict: Optimized parameters
   """
   params = {
       'figsize': (12, 8),
       'dpi': 150,
       'show_volume': True
   }
   
   if timeframe == 'intraday':
       params['figsize'] = (14, 8)
       params['show_volume'] = True
   elif timeframe == 'daily':
       params['figsize'] = (12, 8)
       params['show_volume'] = True
   elif timeframe == 'weekly':
       params['figsize'] = (12, 6)
       params['show_volume'] = False
   elif timeframe == 'monthly':
       params['figsize'] = (10, 6)
       params['show_volume'] = False
   
   return params
```

### Security Considerations

#### 1. Input Validation
```python
def sanitize_chart_input(data, max_size=10000):
   """
   Sanitize and validate chart input data
   
   Parameters:
   - data: Input data
   - max_size: Maximum allowed data size
   
   Returns:
   - sanitized data
   
   Raises:
   - ValueError: If data is invalid or too large
   """
   if isinstance(data, pd.DataFrame):
       if len(data) > max_size:
           raise ValueError(f"Data too large: {len(data)} rows (max: {max_size})")
       
       # Remove potentially malicious columns
       safe_columns = [col for col in data.columns if str(col).isalnum() or str(col) in ['Date', 'Time']]
       return data[safe_columns]
   
   elif isinstance(data, (list, dict)):
       if len(data) > max_size:
           raise ValueError(f"Data too large: {len(data)} items (max: {max_size})")
       return data
   
   else:
       raise ValueError("Invalid data type")
```

#### 2. Resource Limits
```python
import resource

def set_resource_limits():
   """
   Set resource limits for chart generation
   """
   # Limit memory usage to 500MB
   resource.setrlimit(resource.RLIMIT_AS, (500 * 1024 * 1024, 500 * 1024 * 1024))
   
   # Limit CPU time to 30 seconds
   resource.setrlimit(resource.RLIMIT_CPU, (30, 30))
```

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| **Large file size** | High-resolution output | Use `optimize_chart_size()` function with appropriate dimensions |
| **Poor readability** | Small font size or low contrast | Adjust styling parameters or use high contrast mode |
| **Parsing errors** | Invalid data format | Validate input format before processing with `validate_chart_data()` |
| **Memory issues** | Large datasets | Implement data sampling or aggregation before charting |
| **Missing fonts** | Font rendering issues | Ensure system has required fonts installed or use default fonts |
| **Chart type mismatch** | Inappropriate chart for data | Use automatic detection or explicit chart type specification |
| **OHLC validation errors** | Invalid OHLC relationships | Use `validate_ohlcv_data()` to identify and fix data issues |
| **Technical indicator errors** | Insufficient data points | Ensure minimum data requirements (20+ for RSI/MACD) |
| **Style not applying** | Style reset or conflict | Reset style before applying new one with `reset_default_style()` |
| **Date formatting issues** | Incorrect date format | Convert dates to datetime with `pd.to_datetime()` before charting |

### Debug Mode
```python
def debug_chart_generation(data, chart_type, **kwargs):
   """
   Debug mode for troubleshooting chart generation
   
   Parameters:
   - data: Input data
   - chart_type: Chart type
   - **kwargs: Additional parameters
   
   Returns:
   - dict: Debug information
   """
   debug_info = {
       'data_type': type(data).__name__,
       'data_shape': None,
       'data_columns': None,
       'chart_type': chart_type,
       'kwargs': kwargs,
       'validation': None,
       'generation_time': None,
       'image_size': None,
       'errors': []
   }
   
   try:
       # Data validation
       if isinstance(data, pd.DataFrame):
           debug_info['data_shape'] = data.shape
           debug_info['data_columns'] = list(data.columns)
           debug_info['validation'] = validate_chart_data(data)
       
       # Time generation
       import time
       start_time = time.time()
       
       # Generate chart
       img_bytes = create_chart_image(data, chart_type, **kwargs)
       
       end_time = time.time()
       debug_info['generation_time'] = end_time - start_time
       debug_info['image_size'] = len(img_bytes)
   
   except Exception as e:
       debug_info['errors'].append(str(e))
       import traceback
       debug_info['traceback'] = traceback.format_exc()
   
   return debug_info
```

## Related Skills
- [`image-processing-chat`](../image-processing-chat/SKILL.md) — For image handling and chat integration
- [`table-image`](../table-image/SKILL.md) — For tabular data visualization
- [`data-viz`](../data-viz/SKILL.md) — For broader data visualization techniques
- [`coding-standards`](../coding-standards/SKILL.md) — For consistent implementation patterns
- [`us-financial-market-analysis`](../us-financial-market-analysis/SKILL.md) — For US financial market analysis
- [`vietnam-stock-analysis`](../vietnam-stock-analysis/SKILL.md) — For Vietnamese stock market analysis
