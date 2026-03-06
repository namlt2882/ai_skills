# MQL4 Error Handling

## Error Description Function

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

## Retry Logic for Transient Errors

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