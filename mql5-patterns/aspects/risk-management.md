# MQL5 Risk Management

## Position Sizing with Risk Percentage

```mql5
class CRiskManager {
private:
    double m_accountRiskPercent;
    double m_maxRiskPercent;
    double m_dailyLossLimit;
    double m_dailyPL;
    
public:
    CRiskManager(double riskPercent = 1.0, double maxRisk = 5.0, double dailyLimit = 5.0)
        : m_accountRiskPercent(riskPercent), m_maxRiskPercent(maxRisk), 
          m_dailyLossLimit(dailyLimit), m_dailyPL(0) {}
    
    double CalculateLotSize(double stopLossPoints) {
        double accountBalance = AccountInfoDouble(ACCOUNT_BALANCE);
        double riskAmount = accountBalance * (m_accountRiskPercent / 100.0);
        
        double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
        double tickSize = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_SIZE);
        
        if(tickValue == 0 || tickSize == 0) return 0;
        
        double pointValue = tickValue * (_Point / tickSize);
        double lotSize = riskAmount / (stopLossPoints * pointValue);
        
        return NormalizeLots(lotSize);
    }
    
    bool CheckDailyLoss() {
        UpdateDailyPL();
        double maxLoss = AccountInfoDouble(ACCOUNT_BALANCE) * (m_dailyLossLimit / 100.0);
        
        if(m_dailyPL < -maxLoss) {
            Print("Daily loss limit reached: ", m_dailyPL);
            return false;
        }
        return true;
    }
    
    bool CheckMaxDrawdown() {
        double equity = AccountInfoDouble(ACCOUNT_EQUITY);
        double balance = AccountInfoDouble(ACCOUNT_BALANCE);
        double drawdown = ((balance - equity) / balance) * 100.0;
        
        if(drawdown > m_maxRiskPercent) {
            Print("Max drawdown reached: ", drawdown, "%");
            return false;
        }
        return true;
    }
    
private:
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
    
    void UpdateDailyPL() {
        m_dailyPL = 0;
        // Note: For Forex markets, consider making day start time configurable (e.g., 5 PM EST)
        datetime todayStart = TimeCurrent() - (TimeCurrent() % 86400);
        
        CDealInfo deal;
        for(int i = DealsTotal() - 1; i >= 0; i--) {
            if(deal.SelectByIndex(i)) {
                if(deal.Magic() == MagicNumber && deal.Symbol() == Symbol()) {  // MagicNumber is an input parameter
                    if(deal.Time() >= todayStart) {
                        m_dailyPL += deal.Profit() + deal.Swap() + deal.Commission();
                    }
                }
            }
        }
    }
};
```

## Comment-Based State Persistence

Store original values in position comments to track accurate risk and state across position modifications.

```mql5
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>
#include <Trade/AccountInfo.mqh>

// Global objects for position, symbol, and account info
CPositionInfo position;
CSymbolInfo symbolInfo;
CAccountInfo account;

// Define pip value for 5-digit brokers (adjust for your broker)
double pipValue = SymbolInfoDouble(Symbol(), SYMBOL_POINT) * 10;

// Encode zone information into comment
string EncodeZoneComment(double originalSL, double originalVolume) {
    return StringFormat("OSL:%.5f|OV:%.3f", originalSL, originalVolume);
}

// Parse value from comment
string ParseCommentValue(string comment, string key) {
    string search = key + ":";
    int pos = StringFind(comment, search);
    if(pos < 0) return "";
    
    int endPos = StringFind(comment, "|", pos);
    if(endPos < 0) endPos = StringLen(comment);
    
    return StringSubstr(comment, pos + StringLen(search), endPos - pos - StringLen(search));
}

// Get original stop loss from position comment
double GetOriginalStopLoss(ulong ticket) {
    if(!PositionSelectByTicket(ticket)) return 0;
    
    string comment = position.Comment();
    string oslStr = ParseCommentValue(comment, "OSL");
    
    if(oslStr != "")
        return StringToDouble(oslStr);
    
    return position.StopLoss(); // Fallback to current SL
}

// Get original volume from position comment
double GetOriginalVolume(ulong ticket) {
    if(!PositionSelectByTicket(ticket)) return 0;
    
    string comment = position.Comment();
    string ovStr = ParseCommentValue(comment, "OV");
    
    if(ovStr != "")
        return (double)StringToDouble(ovStr);
    
    return 0;
}

// Calculate actual risk based on ORIGINAL SL distance and CURRENT volume
double GetActualRiskPercent(ulong ticket) {
    if(!PositionSelectByTicket(ticket)) return 0;
    
    double openPrice = position.PriceOpen();
    string comment = position.Comment();
    string oslStr = ParseCommentValue(comment, "OSL");
    double originalSL = 0;
    
    if(oslStr != "")
        originalSL = StringToDouble(oslStr);
    else
        originalSL = position.StopLoss(); // Fallback
    
    if(originalSL == 0) return 0;
    
    double currentVolume = position.Volume();
    double slDistance = MathAbs(openPrice - originalSL);
    double slPips = slDistance / pipValue;
    
    double pointValue = symbolInfo.TickValue() * (pipValue / symbolInfo.TickSize());
    double riskAmount = currentVolume * slPips * pointValue;
    
    return (riskAmount / account.Equity()) * 100.0;
}
```

## Advanced DCA (Dollar Cost Averaging) System

Comprehensive DCA implementation with basket management, composite R:R calculation, and trend-aware triggers.

```mql5
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/SymbolInfo.mqh>

// Global objects for DCA operations
CPositionInfo position;
CTrade trade;
CSymbolInfo symbolInfo;

// Input parameters (define these as input parameters in your EA)
input string TradingSymbol = "";  // Leave empty to use current chart symbol
input ulong MagicNumber = 123456;  // Unique identifier for EA orders
input double TPExtensionTrigger = 70.0;  // TP extension trigger percentage
input double TPExtensionPercent = 50.0;  // TP extension percentage

// Get average entry price for all DCA positions on a side
double GetAverageEntryPrice(bool isBuy) {
    double totalVolume = 0;
    double weightedPrice = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                double vol = position.Volume();
                totalVolume += vol;
                weightedPrice += position.PriceOpen() * vol;
            }
        }
    }
    
    return (totalVolume > 0) ? weightedPrice / totalVolume : 0;
}

// Get original SL for all DCA positions on a side
double GetOriginalSLForSide(bool isBuy) {
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                return GetOriginalStopLoss(position.Ticket());
            }
        }
    }
    return 0;
}

// Calculate composite R:R for DCA basket
double GetDcaCompositeRR(bool isBuy) {
    double avgEntry = GetAverageEntryPrice(isBuy);
    double avgTP = 0;
    double sl = GetOriginalSLForSide(isBuy);
    int dcaCount = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                double tp = position.TakeProfit();
                if(tp > 0) {
                    avgTP += tp;
                    dcaCount++;
                }
            }
        }
    }
    
    if(dcaCount == 0 || sl == 0) return 0;
    avgTP /= dcaCount;
    
    double slDistance = MathAbs(avgEntry - sl);
    double tpDistance = MathAbs(avgTP - avgEntry);
    
    return (slDistance > 0) ? tpDistance / slDistance : 0;
}

// Sum all DCA risks for a side
double SumAllDcaRisks(bool isBuy) {
    double totalRisk = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                totalRisk += GetActualRiskPercent(position.Ticket());
            }
        }
    }
    
    return totalRisk;
}

// TP extension for DCA basket
void CheckDcaTPExtension(bool isBuy) {
    double avgEntry = GetAverageEntryPrice(isBuy);
    double avgTP = 0;
    double sl = GetOriginalSLForSide(isBuy);
    int dcaCount = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
            if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
               ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                double tp = position.TakeProfit();
                if(tp > 0) {
                    avgTP += tp;
                    dcaCount++;
                }
            }
        }
    }
    
    if(dcaCount == 0) return;
    avgTP /= dcaCount;
    
    double curPrice = isBuy ? symbolInfo.Bid() : symbolInfo.Ask();
    double tpDistance = MathAbs(avgTP - avgEntry);
    double currentProgress = isBuy ? (curPrice - avgEntry) : (avgEntry - curPrice);
    
    if(tpDistance == 0) return;
    double progressPercent = (currentProgress / tpDistance) * 100.0;
    
    if(progressPercent >= TPExtensionTrigger) {
        double extensionAmount = tpDistance * (TPExtensionPercent / 100.0);
        double newTP = isBuy ? avgTP + extensionAmount : avgTP - extensionAmount;
        
        // Set new TP for every DCA ticket
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(position.SelectByIndex(i)) {
                string symbol = (TradingSymbol == "") ? Symbol() : TradingSymbol;
                if(position.Symbol() == symbol && position.Magic() == MagicNumber &&
                   ((isBuy && position.PositionType() == POSITION_TYPE_BUY) ||
                    (!isBuy && position.PositionType() == POSITION_TYPE_SELL))) {
                    trade.PositionModify(position.Ticket(), position.StopLoss(), newTP);
                }
            }
        }
    }
}