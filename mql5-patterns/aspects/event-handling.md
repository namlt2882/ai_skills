# MQL5 Event Handling Patterns

## Proper OnTick Implementation

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

## OnTimer for Periodic Tasks

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

## OnTrade for Trade Event Handling

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