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

## Core Principles

### 1. Object-Oriented Design

MQL5 supports full OOP; use classes for better code organization.

```mql5
// Good: Use classes for encapsulation
class COrderManager {
private:
    ulong m_magicNumber;
    string m_symbol;
    
public:
    COrderManager(ulong magic, string symbol) 
        : m_magicNumber(magic), m_symbol(symbol) {}
    
    int CountOrders(ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY) {
        COrderInfo order;
        int count = 0;
        
        for(int i = OrdersTotal() - 1; i >= 0; i--) {
            if(order.SelectByIndex(i)) {
                if(order.Magic() == m_magicNumber && order.Symbol() == m_symbol) {
                    if(orderType == ORDER_TYPE_BUY || order.OrderType() == orderType) {
                        count++;
                    }
                }
            }
        }
        return count;
    }
};

// Usage
input ulong MagicNumber = 123456;  // Unique identifier for EA orders
COrderManager orderManager(MagicNumber, Symbol());
int buyCount = orderManager.CountOrders(ORDER_TYPE_BUY);
```

### 2. Use Standard Library Classes

MQL5 provides rich standard library; leverage it instead of reinventing.

```mql5
// Good: Use CArrayObj for dynamic arrays
#include <Arrays\ArrayObj.mqh>

class CTradeSignal : public CObject {
public:
    int signal;
    double strength;
};

CArrayObj signals;

// Add signals
CTradeSignal *sig = new CTradeSignal();
sig.signal = 1;
sig.strength = 0.8;
signals.Add(sig);

// Good: Use CTrade for order operations
#include <Trade/Trade.mqh>

input ulong MagicNumber = 123456;  // Unique identifier for EA orders
CTrade trade;
trade.SetExpertMagicNumber(MagicNumber);
trade.SetDeviationInPoints(3);

if(trade.Buy(lotSize, Symbol(), Ask, stopLoss, takeProfit, "EA Buy")) {
    Print("Buy order opened: ", trade.ResultOrder());
}

// Bad: Manual order handling without standard library
MqlTradeRequest request;
MqlTradeResult result;
ZeroMemory(request);
ZeroMemory(result);
// ... manual setup ...
OrderSend(request, result);
```

### 3. Always Check Return Values

MQL5 functions return bool or handles; always validate.

```mql5
// Good: Check trade result
CTrade trade;
if(!trade.Buy(lotSize, Symbol(), Ask, sl, tp, "Buy")) {
    Print("Buy failed: ", GetLastError());
    Print("Retcode: ", trade.ResultRetcode());
    Print("Retcode description: ", trade.ResultRetcodeDescription());
}

// Good: Check indicator handle
int maHandle = iMA(Symbol(), Period(), MA_Period, 0, MODE_SMA, PRICE_CLOSE);
if(maHandle == INVALID_HANDLE) {
    Print("Failed to create MA indicator handle");
    return INIT_FAILED;
}

// Good: Check CopyBuffer result
double maBuffer[];
ArraySetAsSeries(maBuffer, true);
if(CopyBuffer(maHandle, 0, 0, 3, maBuffer) < 0) {
    Print("Failed to copy MA buffer: ", GetLastError());
    return;
}
```

## Code Organization

### Standard EA Structure

```mql5
//+------------------------------------------------------------------+
//|                                                    MyEA.mq5      |
//|                                    Your Name                     |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Your Name"
#property link      "https://yourwebsite.com"
#property version   "1.00"

#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/OrderInfo.mqh>

//--- Input parameters
input group "=== General Settings ==="
input ulong  MagicNumber      = 123456;
input double LotSize          = 0.1;
input int    MaxOrders        = 3;

input group "=== Risk Management ==="
input double RiskPercent      = 1.0;
input double MaxRiskPercent   = 5.0;
input double DailyLossLimit   = 5.0;
input int    StopLossPoints   = 50;
input int    TakeProfitPoints = 100;

input group "=== Strategy Settings ==="
input int    FastMA           = 10;
input int    SlowMA           = 20;
input int    RSI_Period       = 14;

input group "=== Trailing Stop ==="
input int    TrailStart       = 20;
input int    TrailStop        = 15;

//--- Global objects
CTrade *g_trade;
CPositionInfo *g_position;
COrderInfo *g_order;

//--- Global variables
datetime g_lastBarTime = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                     |
//+------------------------------------------------------------------+
int OnInit() {
    // Create trade objects
    g_trade = new CTrade();
    g_position = new CPositionInfo();
    g_order = new COrderInfo();
    
    // Configure trade
    g_trade->SetExpertMagicNumber(MagicNumber);  // MagicNumber is an input parameter
    g_trade->SetDeviationInPoints(10);
    // Set appropriate filling mode based on symbol
    long fillingMode = SymbolInfoInteger(Symbol(), SYMBOL_FILLING_MODE);
    if(fillingMode & SYMBOL_FILLING_FOK)
        g_trade->SetTypeFilling(ORDER_FILLING_FOK);
    else if(fillingMode & SYMBOL_FILLING_IOC)
        g_trade->SetTypeFilling(ORDER_FILLING_IOC);
    else
        g_trade->SetTypeFilling(ORDER_FILLING_RETURN);
    
    // Validate inputs
    if(LotSize <= 0) {
        Print("Error: Invalid lot size");
        return INIT_PARAMETERS_INCORRECT;
    }
    
    Print("EA initialized with MagicNumber: ", MagicNumber);  // MagicNumber is an input parameter
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                   |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
    // Clean up
    delete g_trade;
    delete g_position;
    delete g_order;
    
    Print("EA deinitialized. Reason: ", reason);
}

//+------------------------------------------------------------------+
//| Expert tick function                                               |
//+------------------------------------------------------------------+
void OnTick() {
    // New bar check
    datetime currentBarTime = iTime(Symbol(), Period(), 0);
    if(currentBarTime == g_lastBarTime) return;
    g_lastBarTime = currentBarTime;
    
    // Trading logic here
}

//+------------------------------------------------------------------+
//| Trade event handler                                                |
//+------------------------------------------------------------------+
void OnTrade() {
    // Handle trade events
}

//+------------------------------------------------------------------+
//| Timer event handler                                                |
//+------------------------------------------------------------------+
void OnTimer() {
    // Handle timer events
}

//+------------------------------------------------------------------+
//| Custom functions                                                   |
//+------------------------------------------------------------------+

// ... your helper functions here ...
```

## Order Management Patterns

### Using CTrade Class

```mql5
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/OrderInfo.mqh>

class CMyTradeManager {
private:
    CTrade m_trade;
    CPositionInfo m_position;
    COrderInfo m_order;
    ulong m_magic;
    
public:
    CMyTradeManager(ulong magic) {
        m_magic = magic;
        m_trade.SetExpertMagicNumber(magic);
        m_trade.SetDeviationInPoints(10);
        m_trade.SetTypeFilling(ORDER_FILLING_IOC);
    }
    
    bool OpenBuy(double lots, double sl, double tp) {
        if(!CheckMargin(lots)) return false;
        
        double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
        return m_trade.Buy(lots, Symbol(), ask, sl, tp, "EA Buy");
    }
    
    bool OpenSell(double lots, double sl, double tp) {
        if(!CheckMargin(lots)) return false;
        
        double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
        return m_trade.Sell(lots, Symbol(), bid, sl, tp, "EA Sell");
    }
    
    bool ClosePosition(ulong ticket) {
        if(m_position.SelectByTicket(ticket)) {
            return m_trade.PositionClose(ticket);
        }
        return false;
    }
    
    bool CloseAllPositions() {
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(m_position.SelectByIndex(i)) {
                if(m_position.Magic() == m_magic && m_position.Symbol() == Symbol()) {
                    m_trade.PositionClose(m_position.Ticket());
                }
            }
        }
        return true;
    }
    
private:
    bool CheckMargin(double lots) {
        double marginRequired;
        if(!OrderCalcMargin(ORDER_TYPE_BUY, Symbol(), lots, 
                           SymbolInfoDouble(Symbol(), SYMBOL_ASK), marginRequired)) {
            return false;
        }
        return marginRequired <= AccountInfoDouble(ACCOUNT_MARGIN_FREE);
    }
};
```

### Trailing Stop with CTrade

```mql5
class CTrailingStop {
private:
    CTrade m_trade;
    double m_trailStart;
    double m_trailStop;
    ulong m_magic;
    
public:
    CTrailingStop(ulong magic, double trailStart, double trailStop) 
        : m_magic(magic), m_trailStart(trailStart), m_trailStop(trailStop) {
        m_trade.SetExpertMagicNumber(magic);
    }
    
    void Update() {
        CPositionInfo position;
        
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(!position.SelectByIndex(i)) continue;
            if(position.Magic() != m_magic || position.Symbol() != Symbol()) continue;
            
            double openPrice = position.PriceOpen();
            double currentSL = position.StopLoss();
            double newSL;
            
            if(position.PositionType() == POSITION_TYPE_BUY) {
                double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                if(currentPrice - openPrice > m_trailStart * _Point) {
                    newSL = currentPrice - m_trailStop * _Point;
                    if(newSL > currentSL + _Point || currentSL == 0) {
                        m_trade.PositionModify(position.Ticket(), newSL, position.TakeProfit());
                    }
                }
            }
            else if(position.PositionType() == POSITION_TYPE_SELL) {
                double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
                if(openPrice - currentPrice > m_trailStart * _Point) {
                    newSL = currentPrice + m_trailStop * _Point;
                    if(newSL < currentSL - _Point || currentSL == 0) {
                        m_trade.PositionModify(position.Ticket(), newSL, position.TakeProfit());
                    }
                }
            }
        }
    }
};
```

### Position Counting

```mql5
input ulong MagicNumber = 123456;  // Unique identifier for EA orders

int CountPositions(ENUM_POSITION_TYPE posType = POSITION_TYPE_BUY) {
    CPositionInfo position;
    int count = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            if(position.Magic() == MagicNumber && position.Symbol() == Symbol()) {
                if(posType == POSITION_TYPE_BUY || position.PositionType() == posType) {
                    count++;
                }
            }
        }
    }
    return count;
}

int CountAllPositions() {
    CPositionInfo position;
    int count = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            if(position.Magic() == MagicNumber && position.Symbol() == Symbol()) {
                count++;
            }
        }
    }
    return count;
}
```

## Risk Management

### Position Sizing with Risk Percentage

```mql5
class CRiskManager {
private:
    double m_accountRiskPercent;
    double m_maxRiskPercent;
    double m_dailyLossLimit;
    double m_dailyPL;
    
public:
    CRiskManager(double riskPercent = 1.0, double maxRisk = 5.0, double dailyLimit = 5.0)
        : m_accountRiskPercent(riskPercent), m_maxRiskPercent(maxRisk), 
          m_dailyLossLimit(dailyLimit), m_dailyPL(0) {}
    
    double CalculateLotSize(double stopLossPoints) {
        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        double riskAmount = accountBalance * (m_accountRiskPercent / 100.0);
        
        double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
        double tickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
        
        if(tickValue == 0 || tickSize == 0) return 0;
        
        double pointValue = tickValue * (_Point / tickSize);
        double lotSize = riskAmount / (stopLossPoints * pointValue);
        
        return NormalizeLots(lotSize);
    }
    
    bool CheckDailyLoss() {
        UpdateDailyPL();
        double maxLoss = AccountInfoDouble(ACCOUNT_BALANCE) * (m_dailyLossLimit / 100.0);
        
        if(m_dailyPL < -maxLoss) {
            Print("Daily loss limit reached: ", m_dailyPL);
            return false;
        }
        return true;
    }
    
    bool CheckMaxDrawdown() {
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double drawdown = ((balance - equity) / balance) * 100.0;
        
        if(drawdown > m_maxRiskPercent) {
            Print("Max drawdown reached: ", drawdown, "%");
            return false;
        }
        return true;
    }
    
private:
    double NormalizeLots(double lots) {
        double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
        double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
        double maxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
        
        lots = MathFloor(lots / lotStep) * lotStep;
        
        if(lots < minLot) lots = minLot;
        if(lots > maxLot) lots = maxLot;
        
        // Use symbol-specific digits for lot precision
        int lotDigits = (int)MathCeil(-MathLog10(lotStep));
        return NormalizeDouble(lots, lotDigits);
    }
    
    void UpdateDailyPL() {
        m_dailyPL = 0;
        // Note: For Forex markets, consider making day start time configurable (e.g., 5 PM EST)
        datetime todayStart = TimeCurrent() - (TimeCurrent() % 86400);
        
        CDealInfo deal;
        for(int i = DealsTotal() - 1; i >= 0; i--) {
            if(deal.SelectByIndex(i)) {
                if(deal.Magic() == MagicNumber && deal.Symbol() == Symbol()) {  // MagicNumber is an input parameter
                    if(deal.Time() >= todayStart) {
                        m_dailyPL += deal.Profit() + deal.Swap() + deal.Commission();
                    }
                }
            }
        }
    }
};
```

### Comment-Based State Persistence

Store original values in position comments to track accurate risk and state across position modifications.

```mql5
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/AccountInfo.mqh>

// Global objects for position, symbol, and account info
CPositionInfo position;
CSymbolInfo symbolInfo;
CAccountInfo account;

// Define pip value for 5-digit brokers (adjust for your broker)
double pipValue = SymbolInfoDouble(Symbol(), SYMBOL_POINT) * 10;

// Encode zone information into comment
string EncodeZoneComment(double originalSL, double originalVolume) {
    return StringFormat("OSL:%.5f|OV:%.3f", originalSL, originalVolume);
}

// Parse value from comment
string ParseCommentValue(string comment, string key) {
    string search = key + ":";
    int pos = StringFind(comment, search);
    if(pos < 0) return "";
    
    int endPos = StringFind(comment, "|", pos);
    if(endPos < 0) endPos = StringLen(comment);
    
    return StringSubstr(comment, pos + StringLen(search), endPos - pos - StringLen(search));
}

// Get original stop loss from position comment
double GetOriginalStopLoss(ulong ticket) {
    if(!PositionSelectByTicket(ticket)) return 0;
    
    string comment = position.Comment();
    string oslStr = ParseCommentValue(comment, "OSL");
    
    if(oslStr != "")
        return StringToDouble(oslStr);
    
    return position.StopLoss(); // Fallback to current SL
}

// Get original volume from position comment
double GetOriginalVolume(ulong ticket) {
    if(!PositionSelectByTicket(ticket)) return 0;
    
    string comment = position.Comment();
    string ovStr = ParseCommentValue(comment, "OV");
    
    if(ovStr != "")
        return (double)StringToDouble(ovStr);
    
    return 0;
}

// Calculate actual risk based on ORIGINAL SL distance and CURRENT volume
double GetActualRiskPercent(ulong ticket) {
    if(!PositionSelectByTicket(ticket)) return 0;
    
    double openPrice = position.PriceOpen();
    string comment = position.Comment();
    string oslStr = ParseCommentValue(comment, "OSL");
    double originalSL = 0;
    
    if(oslStr != "")
        originalSL = StringToDouble(oslStr);
    else
        originalSL = position.StopLoss(); // Fallback
    
    if(originalSL == 0) return 0;
    
    double currentVolume = position.Volume();
    double slDistance = MathAbs(openPrice - originalSL);
    double slPips = slDistance / pipValue;
    
    double pointValue = symbolInfo.TickValue() * (pipValue / symbolInfo.TickSize());
    double riskAmount = currentVolume * slPips * pointValue;
    
    return (riskAmount / account.Equity()) * 100.0;
}
```

### Advanced DCA (Dollar Cost Averaging) System

Comprehensive DCA implementation with basket management, composite R:R calculation, and trend-aware triggers.

```mql5
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>

// Global objects for DCA operations
CPositionInfo position;
CTrade trade;
CSymbolInfo symbolInfo;

// Input parameters (define these as input parameters in your EA)
input string TradingSymbol = "";  // Leave empty to use current chart symbol
input ulong MagicNumber = 123456;  // Unique identifier for EA orders
input double TPExtensionTrigger = 70.0;  // TP extension trigger percentage
input double TPExtensionPercent = 50.0;  // TP extension percentage

// Get average entry price for all DCA positions on a side
double GetAverageEntryPrice(bool isBuy) {
    double totalVolume = 0;
    double weightedPrice = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                double vol = position.Volume();
                totalVolume += vol;
                weightedPrice += position.PriceOpen() * vol;
            }
        }
    }
    
    return (totalVolume > 0) ? weightedPrice / totalVolume : 0;
}

// Get original SL for all DCA positions on a side
double GetOriginalSLForSide(bool isBuy) {
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                return GetOriginalStopLoss(position.Ticket());
            }
        }
    }
    return 0;
}

// Calculate composite R:R for DCA basket
double GetDcaCompositeRR(bool isBuy) {
    double avgEntry = GetAverageEntryPrice(isBuy);
    double avgTP = 0;
    double sl = GetOriginalSLForSide(isBuy);
    int dcaCount = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                double tp = position.TakeProfit();
                if(tp > 0) {
                    avgTP += tp;
                    dcaCount++;
                }
            }
        }
    }
    
    if(dcaCount == 0 || sl == 0) return 0;
    avgTP /= dcaCount;
    
    double slDistance = MathAbs(avgEntry - sl);
    double tpDistance = MathAbs(avgTP - avgEntry);
    
    return (slDistance > 0) ? tpDistance / slDistance : 0;
}

// Sum all DCA risks for a side
double SumAllDcaRisks(bool isBuy) {
    double totalRisk = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                totalRisk += GetActualRiskPercent(position.Ticket());
            }
        }
    }
    
    return totalRisk;
}

// TP extension for DCA basket
void CheckDcaTPExtension(bool isBuy) {
    double avgEntry = GetAverageEntryPrice(isBuy);
    double avgTP = 0;
    double sl = GetOriginalSLForSide(isBuy);
    int dcaCount = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                double tp = position.TakeProfit();
                if(tp > 0) {
                    avgTP += tp;
                    dcaCount++;
                }
            }
        }
    }
    
    if(dcaCount == 0) return;
    avgTP /= dcaCount;
    
    double curPrice = isBuy ? symbolInfo.Bid() : symbolInfo.Ask();
    double tpDistance = MathAbs(avgTP - avgEntry);
    double currentProgress = isBuy ? (curPrice - avgEntry) : (avgEntry - curPrice);
    
    if(tpDistance == 0) return;
    double progressPercent = (currentProgress / tpDistance) * 100.0;
    
    if(progressPercent >= TPExtensionTrigger) {
        double extensionAmount = tpDistance * (TPExtensionPercent / 100.0);
        double newTP = isBuy ? avgTP + extensionAmount : avgTP - extensionAmount;
        
        // Set new TP for every DCA ticket
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(position.SelectByIndex(i)) {
                string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
                if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
                   ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                    (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                    trade.PositionModify(position.Ticket(), position.StopLoss(), newTP);
                }
            }
        }
    }
}
```

## Technical Analysis Patterns

### Indicator Handles and Buffer Management

```mql5
class CIndicators {
private:
    int m_maFastHandle;
    int m_maSlowHandle;
    int m_rsiHandle;
    
public:
    CIndicators() : m_maFastHandle(INVALID_HANDLE), 
                    m_maSlowHandle(INVALID_HANDLE),
                    m_rsiHandle(INVALID_HANDLE) {}
    
    ~CIndicators() {
        ReleaseHandles();
    }
    
    bool Initialize(int fastPeriod, int slowPeriod, int rsiPeriod) {
        m_maFastHandle = iMA(Symbol(), Period(), fastPeriod, 0, MODE_SMA, PRICE_CLOSE);
        m_maSlowHandle = iMA(Symbol(), Period(), slowPeriod, 0, MODE_SMA, PRICE_CLOSE);
        m_rsiHandle = iRSI(Symbol(), Period(), rsiPeriod, PRICE_CLOSE);
        
        if(m_maFastHandle == INVALID_HANDLE || 
           m_maSlowHandle == INVALID_HANDLE || 
           m_rsiHandle == INVALID_HANDLE) {
            Print("Failed to create indicator handles");
            return false;
        }
        
        return true;
    }
    
    int GetMASignal() const {
        double maFast[2], maSlow[2];
        
        if(CopyBuffer(m_maFastHandle, 0, 0, 2, maFast) < 2) return 0;
        if(CopyBuffer(m_maSlowHandle, 0, 0, 2, maSlow) < 2) return 0;
        
        // Bullish crossover
        if(maFast[1] <= maSlow[1] && maFast[0] > maSlow[0]) {
            return 1;
        }
        
        // Bearish crossover
        if(maFast[1] >= maSlow[1] && maFast[0] < maSlow[0]) {
            return -1;
        }
        
        return 0;
    }
    
    double GetRSI(int shift = 0) const {
        double rsi[1];
        if(CopyBuffer(m_rsiHandle, 0, shift, 1, rsi) < 1) return 50;
        return rsi[0];
    }
    
private:
    void ReleaseHandles() {
        if(m_maFastHandle != INVALID_HANDLE) {
            IndicatorRelease(m_maFastHandle);
            m_maFastHandle = INVALID_HANDLE;
        }
        if(m_maSlowHandle != INVALID_HANDLE) {
            IndicatorRelease(m_maSlowHandle);
            m_maSlowHandle = INVALID_HANDLE;
        }
        if(m_rsiHandle != INVALID_HANDLE) {
            IndicatorRelease(m_rsiHandle);
            m_rsiHandle = INVALID_HANDLE;
        }
    }
};
```

### Custom Indicator Class

```mql5
class CCustomIndicator {
private:
    int m_handle;
    string m_name;
    
public:
    CCustomIndicator(string name) : m_name(name), m_handle(INVALID_HANDLE) {}
    
    bool Create(int param1, int param2) {
        m_handle = iCustom(Symbol(), Period(), m_name, param1, param2);
        return m_handle != INVALID_HANDLE;
    }
    
    double GetValue(int bufferIndex, int shift) {
        double buffer[1];
        if(CopyBuffer(m_handle, bufferIndex, shift, 1, buffer) < 1) {
            return 0;
        }
        return buffer[0];
    }
    
    bool IsReady() {
        return BarsCalculated(m_handle) > 0;
    }
    
    ~CCustomIndicator() {
        if(m_handle != INVALID_HANDLE) {
            IndicatorRelease(m_handle);
        }
    }
};
```

## Event Handling Patterns

### Proper OnTick Implementation

```mql5
// Global objects
CMyTradeManager *g_tradeManager;
CIndicators *g_indicators;
CRiskManager *g_riskManager;
CTrailingStop *g_trailingStop;

datetime g_lastBarTime = 0;

int OnInit() {
    // Initialize objects
    g_tradeManager = new CMyTradeManager(MagicNumber);  // MagicNumber is an input parameter
    g_indicators = new CIndicators();
    g_riskManager = new CRiskManager(RiskPercent, MaxRiskPercent, DailyLossLimit);
    g_trailingStop = new CTrailingStop(MagicNumber, TrailStart, TrailStop);  // MagicNumber is an input parameter
    
    // Initialize indicators
    if(!g_indicators->Initialize(FastMA, SlowMA, RSI_Period)) {
        return INIT_FAILED;
    }
    
    // Wait for indicators to calculate
    int attempts = 0;
    while(BarsCalculated(g_indicators.m_maFastHandle) < FastMA && attempts < 10) {
        Sleep(100);
        attempts++;
    }
    if(BarsCalculated(g_indicators.m_maFastHandle) < FastMA) {
        Print("Indicators not ready after timeout");
        return INIT_FAILED;
    }
    
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
    // Clean up
    delete g_tradeManager;
    delete g_indicators;
    delete g_riskManager;
    delete g_trailingStop;
}

void OnTick() {
    // New bar check
    datetime currentBarTime = iTime(Symbol(), Period(), 0);
    if(currentBarTime == g_lastBarTime) {
        // Still update trailing stop on every tick
        g_trailingStop->Update();
        return;
    }
    g_lastBarTime = currentBarTime;
    
    // Check trading conditions
    if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED)) {
        Print("Trading not allowed by terminal");
        return;
    }
    
    if(!MQLInfoInteger(MQL_TRADE_ALLOWED)) {
        Print("Trading not allowed for this EA");
        return;
    }
    
    // Check risk limits
    if(!g_riskManager->CheckDailyLoss()) return;
    if(!g_riskManager->CheckMaxDrawdown()) return;
    
    // Check trading hours
    if(!IsTradingTime()) return;
    
    // Get signal
    int signal = g_indicators->GetMASignal();
    double rsi = g_indicators->GetRSI();
    
    // Execute based on signal
    if(signal == 1 && rsi < 70 && CountPositions(POSITION_TYPE_BUY) == 0) {  // MagicNumber is an input parameter
        double sl = SymbolInfoDouble(Symbol(), SYMBOL_ASK) - StopLossPoints * _Point;
        double tp = SymbolInfoDouble(Symbol(), SYMBOL_ASK) + TakeProfitPoints * _Point;
        double lots = g_riskManager->CalculateLotSize(StopLossPoints);
        g_tradeManager->OpenBuy(lots, sl, tp);
    }
    else if(signal == -1 && rsi > 30 && CountPositions(POSITION_TYPE_SELL) == 0) {
        double sl = SymbolInfoDouble(Symbol(), SYMBOL_BID) + StopLossPoints * _Point;
        double tp = SymbolInfoDouble(Symbol(), SYMBOL_BID) - TakeProfitPoints * _Point;
        double lots = g_riskManager->CalculateLotSize(StopLossPoints);
        g_tradeManager->OpenSell(lots, sl, tp);
    }
    
    // Update trailing stop
    g_trailingStop->Update();
}
```

### OnTimer for Periodic Tasks

```mql5
input int TimerInterval = 60; // seconds

int OnInit() {
    EventSetTimer(TimerInterval);
    return INIT_SUCCEEDED;
}

void OnDeinit(const int reason) {
    EventKillTimer();
}

void OnTimer() {
    // Perform periodic tasks
    CheckNewsEvents();
    UpdateDashboard();
    SendStatusNotification();
}
```

### OnTrade for Trade Event Handling

```mql5
void OnTrade() {
    // Check for new positions
    static int lastPositionsCount = 0;
    int currentPositionsCount = PositionsTotal();
    
    if(currentPositionsCount > lastPositionsCount) {
        Print("New position opened");
        OnPositionOpened();
    }
    else if(currentPositionsCount < lastPositionsCount) {
        Print("Position closed");
        OnPositionClosed();
    }
    
    lastPositionsCount = currentPositionsCount;
}

void OnPositionOpened() {
    // Handle new position logic
    SendNotification("New position opened on " + Symbol());
}

void OnPositionClosed() {
    // Handle position close logic
    double profit = GetLastClosedProfit();  // MagicNumber is an input parameter
    Print("Last position profit: ", profit);
}
```

## Error Handling

### Trade Error Handling

```mql5
class CErrorHandler {
public:
    static string GetTradeErrorDescription(uint retcode) {
        switch(retcode) {
            case TRADE_RETCODE_REQUOTE: return "Requote";
            case TRADE_RETCODE_REJECT: return "Request rejected";
            case TRADE_RETCODE_CANCEL: return "Request canceled by trader";
            case TRADE_RETCODE_PLACED: return "Order placed";
            case TRADE_RETCODE_DONE: return "Request executed";
            case TRADE_RETCODE_DONE_PARTIAL: return "Request partially executed";
            case TRADE_RETCODE_ERROR: return "Error processing request";
            case TRADE_RETCODE_TIMEOUT: return "Request timeout";
            case TRADE_RETCODE_INVALID: return "Invalid request";
            case TRADE_RETCODE_INVALID_VOLUME: return "Invalid volume";
            case TRADE_RETCODE_INVALID_PRICE: return "Invalid price";
            case TRADE_RETCODE_INVALID_STOPS: return "Invalid stops";
            case TRADE_RETCODE_INVALID_TRADE_VOLUME: return "Invalid trade volume";
            case TRADE_RETCODE_MARKET_CLOSED: return "Market closed";
            case TRADE_RETCODE_NO_MONEY: return "Not enough money";
            case TRADE_RETCODE_PRICE_CHANGED: return "Price changed";
            case TRADE_RETCODE_NO_PRICES: return "No prices";
            case TRADE_RETCODE_INVALID_EXPIRATION: return "Invalid expiration";
            case TRADE_RETCODE_ORDER_STATE: return "Order state changed";
            case TRADE_RETCODE_TOO_MANY_REQUESTS: return "Too many requests";
            case TRADE_RETCODE_NO_CHANGES: return "No changes";
            case TRADE_RETCODE_AUTOTRADE_DISABLE: return "Autotrading disabled";
            case TRADE_RETCODE_CLIENT_DISABLE: return "Client disabled";
            default: return "Unknown error";
        }
    }
    
    static void LogTradeError(CTrade &trade) {
        Print("Trade failed!");
        Print("Retcode: ", trade.ResultRetcode());
        Print("Description: ", GetTradeErrorDescription(trade.ResultRetcode()));
        Print("Request volume: ", trade.RequestVolume());
        Print("Request price: ", trade.RequestPrice());
        Print("Request SL: ", trade.RequestSL());
        Print("Request TP: ", trade.RequestTP());
    }
};
```

### Retry Logic for Transient Errors

```mql5
bool TradeBuyWithRetry(CTrade &trade, double lots, string symbol, double sl, double tp, string comment, int maxRetries = 3) {
    for(int attempt = 0; attempt < maxRetries; attempt++) {
        MqlTick tick;
        SymbolInfoTick(symbol, tick);
        if(trade.Buy(lots, symbol, tick.ask, sl, tp, comment)) return true;
        
        uint retcode = trade.ResultRetcode();
        Print("Trade attempt ", attempt + 1, " failed. Retcode: ", retcode);
        
        // Don't retry on permanent errors
        if(retcode == TRADE_RETCODE_NO_MONEY ||
           retcode == TRADE_RETCODE_INVALID_VOLUME ||
           retcode == TRADE_RETCODE_MARKET_CLOSED ||
           retcode == TRADE_RETCODE_AUTOTRADE_DISABLE) {
            return false;
        }
        
        Sleep(100);
    }
    return false;
}

bool TradeSellWithRetry(CTrade &trade, double lots, string symbol, double sl, double tp, string comment, int maxRetries = 3) {
    for(int attempt = 0; attempt < maxRetries; attempt++) {
        MqlTick tick;
        SymbolInfoTick(symbol, tick);
        if(trade.Sell(lots, symbol, tick.bid, sl, tp, comment)) return true;
        
        uint retcode = trade.ResultRetcode();
        Print("Trade attempt ", attempt + 1, " failed. Retcode: ", retcode);
        
        if(retcode == TRADE_RETCODE_NO_MONEY ||
           retcode == TRADE_RETCODE_INVALID_VOLUME ||
           retcode == TRADE_RETCODE_MARKET_CLOSED ||
           retcode == TRADE_RETCODE_AUTOTRADE_DISABLE) {
            return false;
        }
        
        Sleep(100);
    }
    return false;
}
```

## Utility Functions

### Normalize Values

```mql5
double NormalizePrice(double price) {
    int digits = (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
    return NormalizeDouble(price, digits);
}

double NormalizeLots(double lots) {
    double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
    double minLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MIN);
    double maxLot = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_MAX);
    
    lots = MathFloor(lots / lotStep) * lotStep;
    
    if(lots < minLot) lots = minLot;
    if(lots > maxLot) lots = maxLot;
    
    // Use symbol-specific digits for lot precision
    int lotDigits = (int)MathCeil(-MathLog10(lotStep));
    return NormalizeDouble(lots, lotDigits);
}

double NormalizePoints(double points) {
    return points * _Point;
}
```

### Spread and Market Info

```mql5
double GetSpread() {
    long spread = SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
    return spread * _Point;
}

double GetSpreadInPips() {
    long spread = SymbolInfoInteger(Symbol(), SYMBOL_SPREAD);
    int digits = (int)SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
    
    if(digits == 3 || digits == 5) {
        return spread / 10.0;
    }
    return spread;
}

bool IsMarketOpen() {
    MqlDateTime timeStruct;
    TimeToStruct(TimeCurrent(), timeStruct);
    
    // Check weekend
    // Note: Weekend check may not apply to crypto markets; consider making this configurable
    if(timeStruct.day_of_week == 0 || timeStruct.day_of_week == 6) {
        return false;
    }
    
    // Check trading session
    long sessionStart = SymbolInfoInteger(Symbol(), SYMBOL_SESSION_START);
    long sessionEnd = SymbolInfoInteger(Symbol(), SYMBOL_SESSION_END);
    long currentTime = timeStruct.hour * 3600 + timeStruct.min * 60 + timeStruct.sec;
    
    return currentTime >= sessionStart && currentTime <= sessionEnd;
}
```

### Trading Hours Check

```mql5
input string TradingHours = "08:00-20:00";

bool IsTradingTime() {
    int startHour, startMin, endHour, endMin;
    
    if(StringFind(TradingHours, "-") < 0) return true;
    
    string startTime = StringSubstr(TradingHours, 0, StringFind(TradingHours, "-"));
    string endTime = StringSubstr(TradingHours, StringFind(TradingHours, "-") + 1);
    
    startHour = (int)StringToInteger(StringSubstr(startTime, 0, 2));
    startMin = (int)StringToInteger(StringSubstr(startTime, 3, 2));
    endHour = (int)StringToInteger(StringSubstr(endTime, 0, 2));
    endMin = (int)StringToInteger(StringSubstr(endTime, 3, 2));
    
    MqlDateTime timeStruct;
    TimeToStruct(TimeCurrent(), timeStruct);
    
    int currentMinutes = timeStruct.hour * 60 + timeStruct.min;
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

```mql5
// Bad: Not checking return values
g_trade->Buy(lotSize, Symbol(), Ask, sl, tp);

// Bad: Not using standard library
MqlTradeRequest request;
MqlTradeResult result;
// Manual setup...

// Bad: Not releasing indicator handles
int handle = iMA(Symbol(), Period(), 10, 0, MODE_SMA, PRICE_CLOSE);
// Never released

// Bad: Not setting arrays as series
double buffer[];
CopyBuffer(handle, 0, 0, 10, buffer);
// buffer[0] is oldest, not newest

// Good: Always check and handle errors
if(!g_trade->Buy(lotSize, Symbol(), Ask, sl, tp, "Buy")) {
    Print("Buy failed: ", g_trade->ResultRetcode());  // MagicNumber is an input parameter
}

// Good: Use standard library
input ulong MagicNumber = 123456;  // Unique identifier for EA orders
CTrade trade;
trade.SetExpertMagicNumber(MagicNumber);
trade.Buy(lotSize, Symbol(), Ask, sl, tp, "Buy");

// Good: Release handles in destructor or OnDeinit
~CMyClass() {
    if(m_handle != INVALID_HANDLE) {
        IndicatorRelease(m_handle);
    }
}

// Good: Set arrays as series
double buffer[];
ArraySetAsSeries(buffer, true);
CopyBuffer(handle, 0, 0, 10, buffer);
// buffer[0] is now newest
```

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

**Remember**: MQL5 is more powerful and object-oriented than MQL4. Leverage the standard library classes, use proper OOP design, and always handle errors gracefully. The transition from MQL4 requires understanding the new event-driven architecture and handle-based indicator system.
