# MQL5 Error Handling

## Trade Error Handling

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

## Retry Logic for Transient Errors

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