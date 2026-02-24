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

## Core Principles

### 1. Defensive Programming

Always validate inputs and handle edge cases in trading environments.

```mql4
// Good: Validate parameters before use
bool OpenBuyOrder(double lotSize, double stopLoss, double takeProfit) {
    if(lotSize <= 0) {
        Print("Error: Invalid lot size: ", lotSize);
        return false;
    }
    
    if(stopLoss <= 0 || takeProfit <= 0) {
        Print("Error: Invalid SL/TP values");
        return false;
    }
    
    // Check margin before opening
    if(AccountFreeMarginCheck(Symbol(), OP_BUY, lotSize) <= 0) {
        Print("Error: Not enough margin");
        return false;
    }
    
    int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, takeProfit, "EA Buy", MagicNumber, 0, Blue);
    return ticket > 0;
}

// Bad: No validation
bool OpenBuyOrder(double lotSize, double stopLoss, double takeProfit) {
    int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, stopLoss, takeProfit);
    return ticket > 0;
}
```

// Good: Validate parameters before use
bool OpenSellOrder(double lotSize, double stopLoss, double takeProfit) {
    if(lotSize <= 0) {
        Print("Error: Invalid lot size: ", lotSize);
        return false;
    }
    
    if(stopLoss <= 0 || takeProfit <= 0) {
        Print("Error: Invalid SL/TP values");
        return false;
    }
    
    // Check margin before opening
    if(AccountFreeMarginCheck(Symbol(), OP_SELL, lotSize) <= 0) {
        Print("Error: Not enough margin");
        return false;
    }
    
    int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLoss, takeProfit, "EA Sell", MagicNumber, 0, Red);
    return ticket > 0;
}

// Bad: No validation
bool OpenSellOrder(double lotSize, double stopLoss, double takeProfit) {
    int ticket = OrderSend(Symbol(), OP_SELL, lotSize, Bid, 3, stopLoss, takeProfit);
    return ticket > 0;
}
```

### 2. Use Magic Numbers for Order Identification

Always use unique magic numbers to identify orders from different EAs.

```mql4
// Good: Unique magic number per EA
input int MagicNumber = 123456;

bool IsMyOrder(int ticket) {
    if(!OrderSelect(ticket, SELECT_BY_TICKET)) return false;
    return OrderMagicNumber() == MagicNumber;
}

// Bad: Hardcoded or no magic number
int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, 0, 0);
```

### 3. Always Check Return Values

MQL4 functions often return error codes; always check them.

```mql4
// Good: Check return values
int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, sl, tp, "EA", MagicNumber, 0, Blue);
if(ticket < 0) {
    int error = GetLastError();
    Print("OrderSend failed with error: ", error, " - ", ErrorDescription(error));
    return false;
}

// Good: Check OrderSelect
if(OrderSelect(ticket, SELECT_BY_TICKET)) {
    double profit = OrderProfit();
} else {
    Print("Failed to select order: ", GetLastError());
}

// Bad: Ignoring return values
OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, sl, tp);
OrderSelect(ticket, SELECT_BY_TICKET);
```

## Order Management Patterns

### Safe Order Closing

```mql4
bool CloseOrder(int ticket) {
    if(!OrderSelect(ticket, SELECT_BY_TICKET)) {
        Print("CloseOrder: Failed to select ticket ", ticket);
        return false;
    }
    
    double closePrice;
    if(OrderType() == OP_BUY) {
        closePrice = Bid;
    } else if(OrderType() == OP_SELL) {
        closePrice = Ask;
    } else {
        Print("CloseOrder: Invalid order type");
        return false;
    }
    
    bool result = OrderClose(ticket, OrderLots(), closePrice, 3, White);
    if(!result) {
        int error = GetLastError();
        Print("CloseOrder failed: ", error, " - ", ErrorDescription(error));
    }
    return result;
}
```

### Count Open Orders

```mql4
int CountOpenOrders(int orderType = -1) {
    int count = 0;
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
                if(orderType == -1 || OrderType() == orderType) {
                    count++;
                }
            }
        }
    }
    return count;
}

// Usage
int buyOrders = CountOpenOrders(OP_BUY);
int allOrders = CountOpenOrders();
```

### Trailing Stop Implementation

```mql4
void ManageTrailingStop() {
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol()) continue;
            
            double newSL;
            
            if(OrderType() == OP_BUY) {
                if(Bid - OrderOpenPrice() > TrailingStart * Point) {
                    newSL = Bid - TrailingStop * Point;
                    if(newSL > OrderStopLoss() + Point) {
                        bool result = OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0, Blue);
                        if(!result) {
                            Print("TrailingStop modify failed: ", GetLastError());
                        }
                    }
                }
            }
            else if(OrderType() == OP_SELL) {
                if(OrderOpenPrice() - Ask > TrailingStart * Point) {
                    newSL = Ask + TrailingStop * Point;
                    if(newSL < OrderStopLoss() - Point || OrderStopLoss() == 0) {
                        bool result = OrderModify(OrderTicket(), OrderOpenPrice(), newSL, OrderTakeProfit(), 0, Red);
                        if(!result) {
                            Print("TrailingStop modify failed: ", GetLastError());
                        }
                    }
                }
            }
        }
    }
}
```

### Break-Even Stop Implementation

```mql4
input double BreakEvenPoints = 20;

void ManageBreakEven() {
    for(int i = OrdersTotal() - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
            if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol()) continue;
            
            double breakEvenPrice = OrderOpenPrice();
            double currentSL = OrderStopLoss();
            
            if(OrderType() == OP_BUY) {
                if(Bid >= breakEvenPrice + BreakEvenPoints * Point) {
                    if(currentSL < breakEvenPrice || currentSL == 0) {
                        bool result = OrderModify(OrderTicket(), OrderOpenPrice(), breakEvenPrice, OrderTakeProfit(), 0, Blue);
                        if(!result) {
                            Print("BreakEven modify failed: ", GetLastError());
                        }
                    }
                }
            }
            else if(OrderType() == OP_SELL) {
                if(Ask <= breakEvenPrice - BreakEvenPoints * Point) {
                    if(currentSL > breakEvenPrice || currentSL == 0) {
                        bool result = OrderModify(OrderTicket(), OrderOpenPrice(), breakEvenPrice, OrderTakeProfit(), 0, Red);
                        if(!result) {
                            Print("BreakEven modify failed: ", GetLastError());
                        }
                    }
                }
            }
        }
    }
}
```

### Partial Position Closing

```mql4
bool PartialClose(int ticket, double closePercent) {
    if(!OrderSelect(ticket, SELECT_BY_TICKET)) {
        Print("PartialClose: Failed to select ticket ", ticket);
        return false;
    }
    
    if(closePercent <= 0 || closePercent >= 100) {
        Print("PartialClose: Invalid close percent: ", closePercent);
        return false;
    }
    
    double closeLots = NormalizeLots(OrderLots() * closePercent / 100.0);
    if(closeLots <= 0 || closeLots >= OrderLots()) {
        Print("PartialClose: Invalid close lots: ", closeLots);
        return false;
    }
    
    double closePrice;
    if(OrderType() == OP_BUY) {
        closePrice = Bid;
    } else if(OrderType() == OP_SELL) {
        closePrice = Ask;
    } else {
        Print("PartialClose: Invalid order type");
        return false;
    }
    
    bool result = OrderClose(ticket, closeLots, closePrice, 3, White);
    if(!result) {
        Print("PartialClose failed: ", GetLastError());
    }
    return result;
}
```

## Risk Management

### Position Sizing Based on Risk

```mql4
double CalculateLotSize(double riskPercent, double stopLossPoints) {
    double accountBalance = AccountBalance();
    double riskAmount = accountBalance * (riskPercent / 100.0);
    double tickValue = MarketInfo(Symbol(), MODE_TICKVALUE);
    
    if(tickValue == 0) return 0;
    
    double lotSize = riskAmount / (stopLossPoints * tickValue);
    
    // Normalize to broker's lot step
    double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
    lotSize = MathFloor(lotSize / lotStep) * lotStep;
    
    // Check min/max lots
    double minLot = MarketInfo(Symbol(), MODE_MINLOT);
    double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
    
    if(lotSize < minLot) lotSize = minLot;
    if(lotSize > maxLot) lotSize = maxLot;
    
    return NormalizeDouble(lotSize, 2);
}
```

### Daily Loss Limit

```mql4
input double MaxDailyLossPercent = 5.0;

bool CheckDailyLossLimit() {
    double dailyPL = 0;
    double todayStart = TimeCurrent() - (TimeCurrent() % 86400);
    
    for(int i = OrdersHistoryTotal() - 1; i >= 0; i--) {
        if(OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) {
            if(OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol()) {
                if(OrderCloseTime() >= todayStart) {
                    dailyPL += OrderProfit() + OrderSwap() + OrderCommission();
                }
            }
        }
    }
    
    double maxLoss = AccountBalance() * (MaxDailyLossPercent / 100.0);
    
    if(dailyPL < -maxLoss) {
        Print("Daily loss limit reached: ", dailyPL);
        return false;
    }
    
    return true;
}
```

## Technical Analysis Patterns

### Moving Average Crossover

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

### RSI Overbought/Oversold

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

### Support and Resistance Detection

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

### Multi-Timeframe Analysis

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
```

## Event Handling Patterns

### Proper OnTick Implementation

```mql4
// Good: Check for new bar and handle errors
datetime lastBarTime = 0;

void OnTick() {
    // Only process on new bar
    datetime currentBarTime = iTime(Symbol(), Period(), 0);
    if(currentBarTime == lastBarTime) return;
    lastBarTime = currentBarTime;
    
    // Check trading conditions
    if(!IsTradeAllowed()) {
        Print("Trading not allowed");
        return;
    }
    
    if(!CheckDailyLossLimit()) return;
    
    // Get signal
    int signal = GetSignal();
    
    // Execute based on signal
    if(signal == 1 && CountOpenOrders(OP_BUY) == 0) {
        OpenBuyOrder(CalculateLotSize(1.0, 50), 0, 0);
    }
    else if(signal == -1 && CountOpenOrders(OP_SELL) == 0) {
        OpenSellOrder(CalculateLotSize(1.0, 50), 0, 0);
    }
    
    // Manage existing orders
    ManageTrailingStop();
    ManageBreakEven();
}
```

### OnTimer for Periodic Tasks

```mql4
input int TimerInterval = 60; // seconds

int OnInit() {
    EventSetTimer(TimerInterval);
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
    EventKillTimer();
}

void OnTimer() {
    // Perform periodic tasks like checking news, updating indicators, etc.
    CheckNewsEvents();
    UpdateDashboard();
}
```

## Error Handling

### Error Description Function

```mql4
string ErrorDescription(int error) {
    switch(error) {
        case 0:   return "No error";
        case 1:   return "No error, but result unknown";
        case 2:   return "Common error";
        case 3:   return "Invalid trade parameters";
        case 4:   return "Trade server busy";
        case 5:   return "Old version of terminal";
        case 6:   return "No connection with trade server";
        case 7:   return "Not enough rights";
        case 8:   return "Too frequent requests";
        case 9:   return "Malfunctional trade operation";
        case 64:  return "Account disabled";
        case 65:  return "Invalid account";
        case 128: return "Trade timeout";
        case 129: return "Invalid price";
        case 130: return "Invalid stops";
        case 131: return "Invalid volume";
        case 132: return "Market is closed";
        case 133: return "Trade is disabled";
        case 134: return "Not enough money";
        case 135: return "Price changed";
        case 136: return "No prices";
        case 137: return "Broker is busy";
        case 138: return "Requotes";
        case 139: return "Order is locked";
        case 140: return "Long positions only allowed";
        case 141: return "Too many requests";
        case 142: return "Too many requests";
        case 143: return "Trade is disabled";
        case 144: return "Market is closed";
        case 145: return "Modification denied";
        case 146: return "Trade context busy";
        case 147: return "Expirations are denied";
        case 148: return "Too many orders";
        case 149: return "Hedge is prohibited";
        case 150: return "Prohibited by FIFO rule";
        default:  return "Unknown error";
    }
}
```

### Retry Logic for Transient Errors

```mql4
bool OrderSendWithRetry(string symbol, int cmd, double volume, double price, int slippage,
                        double stoploss, double takeprofit, string comment, int magic,
                        datetime expiration, color arrow_color, int maxRetries = 3) {
    for(int attempt = 0; attempt < maxRetries; attempt++) {
        RefreshRates();
        
        int ticket = OrderSend(symbol, cmd, volume, price, slippage, stoploss, 
                               takeprofit, comment, magic, expiration, arrow_color);
        
        if(ticket > 0) return true;
        
        int error = GetLastError();
        Print("OrderSend attempt ", attempt + 1, " failed: ", error, " - ", ErrorDescription(error));
        
        // Don't retry on permanent errors
        if(error == 134 || error == 149 || error == 150) {
            return false;
        }
        
        Sleep(1000); // Wait before retry
    }
    
    return false;
}
```

## Utility Functions

### Normalize Price

```mql4
double NormalizePrice(double price) {
    int digits = (int)MarketInfo(Symbol(), MODE_DIGITS);
    return NormalizeDouble(price, digits);
}

double NormalizeLots(double lots) {
    double lotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
    double minLot = MarketInfo(Symbol(), MODE_MINLOT);
    double maxLot = MarketInfo(Symbol(), MODE_MAXLOT);
    
    // Round to lot step
    lots = MathFloor(lots / lotStep) * lotStep;
    
    // Clamp to min/max
    if(lots < minLot) lots = minLot;
    if(lots > maxLot) lots = maxLot;
    
    return NormalizeDouble(lots, 2);
}
```

### Get Current Spread

```mql4
double GetSpread() {
    double spread = MarketInfo(Symbol(), MODE_SPREAD);
    return spread * Point;
}

double GetSpreadInPips() {
    double spread = MarketInfo(Symbol(), MODE_SPREAD);
    int digits = (int)MarketInfo(Symbol(), MODE_DIGITS);
    
    if(digits == 3 || digits == 5) {
        return spread / 10.0;
    }
    return spread;
}
```

### Check Trading Hours

```mql4
input string TradingHours = "08:00-20:00";

bool IsTradingTime() {
    int startHour, startMin, endHour, endMin;
    
    if(StringFind(TradingHours, "-") < 0) return true;
    
    string startTime = StringSubstr(TradingHours, 0, StringFind(TradingHours, "-"));
    string endTime = StringSubstr(TradingHours, StringFind(TradingHours, "-") + 1);
    
    startHour = StringToInteger(StringSubstr(startTime, 0, 2));
    startMin = StringToInteger(StringSubstr(startTime, 3, 2));
    endHour = StringToInteger(StringSubstr(endTime, 0, 2));
    endMin = StringToInteger(StringSubstr(endTime, 3, 2));
    
    datetime currentTime = TimeCurrent();
    int currentHour = TimeHour(currentTime);
    int currentMin = TimeMinute(currentTime);
    
    int currentMinutes = currentHour * 60 + currentMin;
    int startMinutes = startHour * 60 + startMin;
    int endMinutes = endHour * 60 + endMin;
    
    if(startMinutes <= endMinutes) {
        return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
        // Overnight trading
        return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
}
```

## Code Organization

### Standard EA Structure

```mql4
//+------------------------------------------------------------------+
//|                                                    MyEA.mq4      |
//|                                    Your Name                     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Your Name"
#property link      "https://yourwebsite.com"
#property version   "1.00"
#property strict

//--- Input parameters
input group "=== General Settings ==="
input int    MagicNumber      = 123456;
input double LotSize          = 0.1;
input int    MaxOrders         = 3;

input group "=== Risk Management ==="
input double RiskPercent      = 1.0;
input double StopLossPoints   = 50;
input double TakeProfitPoints = 100;

input group "=== Strategy Settings ==="
input int    FastMA           = 10;
input int    SlowMA           = 20;

//--- Global variables
datetime lastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit() {
    Print("EA initialized with MagicNumber: ", MagicNumber);
    
    // Validate inputs
    if(LotSize <= 0) {
        Print("Error: Invalid lot size");
        return INIT_PARAMETERS_INCORRECT;
    }
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    Print("EA deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick() {
    // New bar check
    datetime currentBarTime = iTime(Symbol(), Period(), 0);
    if(currentBarTime == lastBarTime) return;
    lastBarTime = currentBarTime;
    
    // Trading logic here
}

//+------------------------------------------------------------------+
//| Custom functions                                                   |
//+------------------------------------------------------------------+

// ... your helper functions here ...
```

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

```mql4
// Bad: Not checking return values
OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, sl, tp);

// Bad: Hardcoded magic numbers
int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, sl, tp, "", 0, 0, 0);

// Bad: Not normalizing prices
double sl = Ask - 50; // Should be Ask - 50 * Point

// Bad: Counting orders forward (can skip orders)
for(int i = 0; i < OrdersTotal(); i++) { ... }

// Bad: Using global variables for state without reset
int orderCount; // Should be recalculated each tick

// Bad: Ignoring spread
double sl = Ask - 50 * Point; // Should account for spread

// Bad: Not checking OrderModify return value
OrderModify(ticket, openPrice, newSL, tp, 0, Blue);

// Bad: Using hardcoded stop loss points
double sl = Ask - 50 * Point; // Should be calculated dynamically

// Good: Always check and handle errors
int ticket = OrderSend(Symbol(), OP_BUY, lotSize, Ask, 3, sl, tp, "", MagicNumber, 0, Blue);
if(ticket < 0) {
    Print("Error: ", GetLastError());
}
```

**Remember**: MQL4 code runs in a trading environment where errors can cost real money. Always validate inputs, check return values, and implement proper risk management.
