# MQL4 Risk Management

## Position Sizing Based on Risk

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

## Daily Loss Limit

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