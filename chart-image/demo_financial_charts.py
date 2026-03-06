#!/usr/bin/env python3
"""
Demonstration script for generating sample financial charts using the enhanced chart-image skill.
This script creates realistic financial data (OHLCV) and generates actual image files showing
candlestick charts, technical indicators, and other financial chart types.
"""

import os
import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
import matplotlib.dates as mdates
from io import BytesIO
import base64

def generate_realistic_financial_data(days=100, symbol="AAPL"):
    """
    Generate realistic financial data (OHLCV) for demonstration purposes.
    
    Args:
        days (int): Number of days of data to generate
        symbol (str): Symbol name for the generated data
    
    Returns:
        pd.DataFrame: DataFrame with OHLCV data
    """
    print(f"Generating {days} days of realistic financial data for {symbol}...")
    
    # Start date
    start_date = datetime.now() - timedelta(days=days)
    dates = pd.date_range(start=start_date, periods=days, freq='D')
    
    # Generate realistic price data using geometric Brownian motion
    initial_price = 150.0  # Starting price
    prices = [initial_price]
    
    for i in range(1, days):
        # Random walk with drift
        daily_return = np.random.normal(0.0005, 0.02)  # Small positive drift, 2% daily volatility
        new_price = prices[-1] * (1 + daily_return)
        prices.append(max(new_price, 1.0))  # Ensure price doesn't go below $1
    
    # Convert to numpy array for easier manipulation
    prices = np.array(prices)
    
    # Add some realistic volatility clustering (financial markets exhibit this)
    volatility_multiplier = np.random.lognormal(0, 0.5, days)  # Volatility clustering
    
    # Generate OHLC data
    opens = []
    highs = []
    lows = []
    closes = []
    volumes = []
    
    for i in range(days):
        close_price = prices[i]
        
        # Calculate daily volatility
        vol_mult = volatility_multiplier[i]
        daily_vol = 0.02 * vol_mult  # Base volatility scaled by multiplier
        
        # Generate open, high, low based on close
        if i == 0:
            open_price = close_price * (1 + np.random.normal(0, daily_vol/2))
        else:
            # Open is usually close of previous day plus small random movement
            open_price = closes[-1] * (1 + np.random.normal(0, daily_vol/4))
        
        # Calculate high and low based on open and close
        price_range = abs(close_price - open_price) + daily_vol * close_price
        high_price = max(open_price, close_price) + np.random.uniform(0, price_range * 0.5)
        low_price = min(open_price, close_price) - np.random.uniform(0, price_range * 0.5)
        
        # Ensure low is not below 0 and high is greater than both open and close
        low_price = max(low_price, close_price * 0.95)  # Ensure low is not too far below close
        high_price = max(high_price, max(open_price, close_price))
        low_price = min(low_price, min(open_price, close_price))
        
        # Generate volume (log-normal distribution is more realistic)
        avg_volume = 5000000  # Average 5M shares per day
        volume = int(np.random.lognormal(np.log(avg_volume), 0.5))
        
        opens.append(open_price)
        highs.append(high_price)
        lows.append(low_price)
        closes.append(close_price)
        volumes.append(volume)
    
    # Create DataFrame
    df = pd.DataFrame({
        'Date': dates,
        'Open': opens,
        'High': highs,
        'Low': lows,
        'Close': closes,
        'Volume': volumes
    })
    
    print(f"Generated {len(df)} days of financial data from {df['Date'].min()} to {df['Date'].max()}")
    return df

def _calculate_moving_average(data, window=20):
    """Calculate Simple Moving Average (SMA) for a given series."""
    return data.rolling(window=window).mean()

def _calculate_rsi(data, window=14):
    """Calculate Relative Strength Index (RSI)."""
    delta = data.diff()
    gain = (delta.where(delta > 0, 0)).rolling(window=window).mean()
    loss = (-delta.where(delta < 0, 0)).rolling(window=window).mean()
    rs = gain / loss
    rsi = 100 - (100 / (1 + rs))
    return rsi

def _calculate_macd(data, fast=12, slow=26, signal=9):
    """Calculate MACD (Moving Average Convergence Divergence)."""
    exp1 = data.ewm(span=fast).mean()
    exp2 = data.ewm(span=slow).mean()
    macd_line = exp1 - exp2
    signal_line = macd_line.ewm(span=signal).mean()
    histogram = macd_line - signal_line
    return macd_line, signal_line, histogram

def _create_candlestick_chart(df, title=None):
    """
    Create a candlestick chart from OHLC data.
    """
    print("Creating candlestick chart...")
    
    # Validate required columns
    required_cols = ['Open', 'High', 'Low', 'Close']
    if not all(col in df.columns for col in required_cols):
        raise ValueError("Candlestick chart requires 'Open', 'High', 'Low', 'Close' columns")
    
    # Use Date column if available, otherwise use index
    if 'Date' in df.columns:
        dates = df['Date']
    else:
        dates = df.index
    
    # Convert dates if they're not already datetime
    if not pd.api.types.is_datetime64_any_dtype(dates):
        dates = pd.to_datetime(dates)
    
    fig, ax = plt.subplots(figsize=(14, 8))
    
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
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes

def _create_ohlc_chart(df, title=None):
    """
    Create an OHLC (Open-High-Low-Close) bar chart.
    """
    print("Creating OHLC chart...")
    
    # Validate required columns
    required_cols = ['Open', 'High', 'Low', 'Close']
    if not all(col in df.columns for col in required_cols):
        raise ValueError("OHLC chart requires 'Open', 'High', 'Low', 'Close' columns")
    
    # Use Date column if available, otherwise use index
    if 'Date' in df.columns:
        dates = df['Date']
    else:
        dates = df.index
    
    # Convert dates if they're not already datetime
    if not pd.api.types.is_datetime64_any_dtype(dates):
        dates = pd.to_datetime(dates)
    
    fig, ax = plt.subplots(figsize=(14, 8))
    
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
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes

def _create_technical_indicators_chart(df, indicators=['MA'], title=None):
    """
    Create a chart with technical indicators.
    """
    print(f"Creating technical indicators chart with indicators: {indicators}...")
    
    # Validate required columns
    if 'Close' not in df.columns:
        raise ValueError("Technical indicators chart requires 'Close' column")
    
    # Use Date column if available, otherwise use index
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
        fig, (ax1, ax2, ax3) = plt.subplots(3, 1, figsize=(14, 14),
                                           gridspec_kw={'height_ratios': [3, 1, 1]})
    elif has_rsi or has_macd:
        fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 12),
                                      gridspec_kw={'height_ratios': [3, 1]})
    else:
        fig, ax1 = plt.subplots(1, 1, figsize=(14, 8))
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
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes

def _create_volume_profile_chart(df, title=None):
    """
    Create a volume profile chart showing trading volume at different price levels.
    """
    print("Creating volume profile chart...")
    
    # Validate required columns
    required_cols = ['Close', 'Volume']
    if not all(col in df.columns for col in required_cols):
        raise ValueError("Volume profile chart requires 'Close' and 'Volume' columns")
    
    # Use Date column if available, otherwise use index
    if 'Date' in df.columns:
        dates = df['Date']
    else:
        dates = df.index
    
    # Convert dates if they're not already datetime
    if not pd.api.types.is_datetime64_any_dtype(dates):
        dates = pd.to_datetime(dates)
    
    fig, (ax1, ax2) = plt.subplots(2, 1, figsize=(14, 10),
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
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes

def save_image_to_file(img_bytes, filename):
    """Save image bytes to a file."""
    with open(filename, 'wb') as f:
        f.write(img_bytes)
    print(f"Saved image to {filename}")

def main():
    """Main function to demonstrate the financial chart generation."""
    print("Starting financial chart demonstration...")
    
    # Create output directory if it doesn't exist
    output_dir = "demo_output"
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate realistic financial data
    df = generate_realistic_financial_data(days=100, symbol="AAPL")
    
    # 1. Create candlestick chart
    print("\n1. Creating candlestick chart...")
    candlestick_img = _create_candlestick_chart(df, title="AAPL - Candlestick Chart")
    save_image_to_file(candlestick_img, os.path.join(output_dir, "candlestick_chart.png"))
    
    # 2. Create OHLC chart
    print("\n2. Creating OHLC chart...")
    ohlc_img = _create_ohlc_chart(df, title="AAPL - OHLC Chart")
    save_image_to_file(ohlc_img, os.path.join(output_dir, "ohlc_chart.png"))
    
    # 3. Create technical indicators chart with MA
    print("\n3. Creating technical indicators chart with Moving Averages...")
    tech_ma_img = _create_technical_indicators_chart(df, indicators=['MA20', 'MA50'], title="AAPL - Price with Moving Averages")
    save_image_to_file(tech_ma_img, os.path.join(output_dir, "tech_ma_chart.png"))
    
    # 4. Create technical indicators chart with RSI
    print("\n4. Creating technical indicators chart with RSI...")
    tech_rsi_img = _create_technical_indicators_chart(df, indicators=['MA', 'RSI'], title="AAPL - Price with RSI")
    save_image_to_file(tech_rsi_img, os.path.join(output_dir, "tech_rsi_chart.png"))
    
    # 5. Create technical indicators chart with MACD
    print("\n5. Creating technical indicators chart with MACD...")
    tech_macd_img = _create_technical_indicators_chart(df, indicators=['MA', 'MACD'], title="AAPL - Price with MACD")
    save_image_to_file(tech_macd_img, os.path.join(output_dir, "tech_macd_chart.png"))
    
    # 6. Create comprehensive technical analysis chart
    print("\n6. Creating comprehensive technical analysis chart...")
    tech_full_img = _create_technical_indicators_chart(df, indicators=['MA20', 'MA50', 'RSI', 'MACD'], title="AAPL - Comprehensive Technical Analysis")
    save_image_to_file(tech_full_img, os.path.join(output_dir, "tech_full_chart.png"))
    
    # 7. Create volume profile chart
    print("\n7. Creating volume profile chart...")
    volume_img = _create_volume_profile_chart(df, title="AAPL - Volume Profile Chart")
    save_image_to_file(volume_img, os.path.join(output_dir, "volume_profile_chart.png"))
    
    print(f"\nAll charts have been generated and saved to the '{output_dir}' directory!")
    print(f"Generated {len(os.listdir(output_dir))} chart images:")
    for file in sorted(os.listdir(output_dir)):
        print(f"  - {file}")
    
    # Show basic statistics about the generated data
    print(f"\nGenerated data statistics:")
    print(f"  - Date range: {df['Date'].min().strftime('%Y-%m-%d')} to {df['Date'].max().strftime('%Y-%m-%d')}")
    print(f"  - Total days: {len(df)}")
    print(f"  - Price range: ${df['Low'].min():.2f} - ${df['High'].max():.2f}")
    print(f"  - Average volume: {df['Volume'].mean():,.0f} shares")
    
    print("\nDemonstration completed successfully!")

if __name__ == "__main__":
    main()