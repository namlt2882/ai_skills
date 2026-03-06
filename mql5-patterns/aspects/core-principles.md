# MQL5 Core Principles

## 1. Object-Oriented Design
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

## 2. Use Standard Library Classes
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

## 3. Always Check Return Values
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