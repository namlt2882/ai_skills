# MQL4 Event Handling Patterns

## Proper OnTick Implementation

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

## OnTimer for Periodic Tasks

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