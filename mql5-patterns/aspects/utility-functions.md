# MQL5 Utility Functions

## Normalize Values

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

## Spread and Market Info

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

## Trading Hours Check

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

## Standard EA Structure

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