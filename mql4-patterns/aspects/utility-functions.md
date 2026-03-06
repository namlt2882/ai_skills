# MQL4 Utility Functions

## Normalize Price

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

## Get Current Spread

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

## Check Trading Hours

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

## Standard EA Structure

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