# MQL4 Technical Analysis Patterns

## Moving Average Crossover

```mql4
input int FastMA_Period = 10;
input int SlowMA_Period = 20;
input ENUM_MA_METHOD MA_Method = MODE_SMA;

int GetSignal() {
    double fastMA_Current = iMA(Symbol(), Period(), FastMA_Period, 0, MA_Method, PRICE_CLOSE, 0);
    double fastMA_Previous = iMA(Symbol(), Period(), FastMA_Period, 0, MA_Method, PRICE_CLOSE, 1);
    double slowMA_Current = iMA(Symbol(), Period(), SlowMA_Period, 0, MA_Method, PRICE_CLOSE, 0);
    double slowMA_Previous = iMA(Symbol(), Period(), SlowMA_Period, 0, MA_Method, PRICE_CLOSE, 1);
    
    // Bullish crossover
    if(fastMA_Previous <= slowMA_Previous && fastMA_Current > slowMA_Current) {
        return 1; // Buy signal
    }
    
    // Bearish crossover
    if(fastMA_Previous >= slowMA_Previous && fastMA_Current < slowMA_Current) {
        return -1; // Sell signal
    }
    
    return 0; // No signal
}
```

## RSI Overbought/Oversold

```mql4
input int RSI_Period = 14;
input int RSI_Overbought = 70;
input int RSI_Oversold = 30;

int GetRSISignal() {
    double rsiCurrent = iRSI(Symbol(), Period(), RSI_Period, PRICE_CLOSE, 0);
    double rsiPrevious = iRSI(Symbol(), Period(), RSI_Period, PRICE_CLOSE, 1);
    
    // Oversold to neutral - potential buy
    if(rsiPrevious < RSI_Oversold && rsiCurrent >= RSI_Oversold) {
        return 1;
    }
    
    // Overbought to neutral - potential sell
    if(rsiPrevious > RSI_Overbought && rsiCurrent <= RSI_Overbought) {
        return -1;
    }
    
    return 0;
}
```

## Support and Resistance Detection

```mql4
double FindSupport(int lookbackBars = 50) {
    double support = 0;
    int supportCount = 0;
    
    for(int i = 1; i <= lookbackBars; i++) {
        double low = iLow(Symbol(), Period(), i);
        double prevLow = iLow(Symbol(), Period(), i - 1);
        double nextLow = iLow(Symbol(), Period(), i + 1);
        
        // Local minimum
        if(low < prevLow && low < nextLow) {
            support += low;
            supportCount++;
        }
    }
    
    return supportCount > 0 ? support / supportCount : 0;
}

double FindResistance(int lookbackBars = 50) {
    double resistance = 0;
    int resistanceCount = 0;
    
    for(int i = 1; i <= lookbackBars; i++) {
        double high = iHigh(Symbol(), Period(), i);
        double prevHigh = iHigh(Symbol(), Period(), i - 1);
        double nextHigh = iHigh(Symbol(), Period(), i + 1);
        
        // Local maximum
        if(high > prevHigh && high > nextHigh) {
            resistance += high;
            resistanceCount++;
        }
    }
    
    return resistanceCount > 0 ? resistance / resistanceCount : 0;
}
```

## Multi-Timeframe Analysis

```mql4
int GetSignalOnTimeframe(ENUM_TIMEFRAMES tf) {
    double fastMA_Current = iMA(Symbol(), tf, FastMA_Period, 0, MA_Method, PRICE_CLOSE, 0);
    double fastMA_Previous = iMA(Symbol(), tf, FastMA_Period, 0, MA_Method, PRICE_CLOSE, 1);
    double slowMA_Current = iMA(Symbol(), tf, SlowMA_Period, 0, MA_Method, PRICE_CLOSE, 0);
    double slowMA_Previous = iMA(Symbol(), tf, SlowMA_Period, 0, MA_Method, PRICE_CLOSE, 1);
    
    // Bullish crossover
    if(fastMA_Previous <= slowMA_Previous && fastMA_Current > slowMA_Current) {
        return 1;
    }
    
    // Bearish crossover
    if(fastMA_Previous >= slowMA_Previous && fastMA_Current < slowMA_Current) {
        return -1;
    }
    
    return 0;
}

int GetMultiTimeframeSignal() {
    int h4Signal = GetSignalOnTimeframe(PERIOD_H4);
    int h1Signal = GetSignalOnTimeframe(PERIOD_H1);
    int m15Signal = GetSignalOnTimeframe(PERIOD_M15);
    
    // Only trade if all timeframes agree
    if(h4Signal == h1Signal && h1Signal == m15Signal) {
        return h4Signal;
    }
    return 0;
}