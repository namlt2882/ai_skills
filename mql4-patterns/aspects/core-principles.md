# MQL4 Core Principles

## 1. Defensive Programming
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

## 2. Use Magic Numbers for Order Identification
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

## 3. Always Check Return Values
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