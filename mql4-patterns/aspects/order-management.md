# MQL4 Order Management Patterns

## Safe Order Closing

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

## Count Open Orders

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

## Trailing Stop Implementation

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

## Break-Even Stop Implementation

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

## Partial Position Closing

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