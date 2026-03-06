# MQL5 Order Management Patterns

## Using CTrade Class

```mql5
#include <Trade/Trade.mqh>
#include <Trade/PositionInfo.mqh>
#include <Trade/OrderInfo.mqh>

class CMyTradeManager {
private:
    CTrade m_trade;
    CPositionInfo m_position;
    COrderInfo m_order;
    ulong m_magic;
    
public:
    CMyTradeManager(ulong magic) {
        m_magic = magic;
        m_trade.SetExpertMagicNumber(magic);
        m_trade.SetDeviationInPoints(10);
        m_trade.SetTypeFilling(ORDER_FILLING_IOC);
    }
    
    bool OpenBuy(double lots, double sl, double tp) {
        if(!CheckMargin(lots)) return false;
        
        double ask = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
        return m_trade.Buy(lots, Symbol(), ask, sl, tp, "EA Buy");
    }
    
    bool OpenSell(double lots, double sl, double tp) {
        if(!CheckMargin(lots)) return false;
        
        double bid = SymbolInfoDouble(Symbol(), SYMBOL_BID);
        return m_trade.Sell(lots, Symbol(), bid, sl, tp, "EA Sell");
    }
    
    bool ClosePosition(ulong ticket) {
        if(m_position.SelectByTicket(ticket)) {
            return m_trade.PositionClose(ticket);
        }
        return false;
    }
    
    bool CloseAllPositions() {
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(m_position.SelectByIndex(i)) {
                if(m_position.Magic() == m_magic && m_position.Symbol() == Symbol()) {
                    m_trade.PositionClose(m_position.Ticket());
                }
            }
        }
        return true;
    }
    
private:
    bool CheckMargin(double lots) {
        double marginRequired;
        if(!OrderCalcMargin(ORDER_TYPE_BUY, Symbol(), lots, 
                           SymbolInfoDouble(Symbol(), SYMBOL_ASK), marginRequired)) {
            return false;
        }
        return marginRequired <= AccountInfoDouble(ACCOUNT_MARGIN_FREE);
    }
};
```

## Trailing Stop with CTrade

```mql5
class CTrailingStop {
private:
    CTrade m_trade;
    double m_trailStart;
    double m_trailStop;
    ulong m_magic;
    
public:
    CTrailingStop(ulong magic, double trailStart, double trailStop) 
        : m_magic(magic), m_trailStart(trailStart), m_trailStop(trailStop) {
        m_trade.SetExpertMagicNumber(magic);
    }
    
    void Update() {
        CPositionInfo position;
        
        for(int i = PositionsTotal() - 1; i >= 0; i--) {
            if(!position.SelectByIndex(i)) continue;
            if(position.Magic() != m_magic || position.Symbol() != Symbol()) continue;
            
            double openPrice = position.PriceOpen();
            double currentSL = position.StopLoss();
            double newSL;
            
            if(position.PositionType() == POSITION_TYPE_BUY) {
                double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_BID);
                if(currentPrice - openPrice > m_trailStart * _Point) {
                    newSL = currentPrice - m_trailStop * _Point;
                    if(newSL > currentSL + _Point || currentSL == 0) {
                        m_trade.PositionModify(position.Ticket(), newSL, position.TakeProfit());
                    }
                }
            }
            else if(position.PositionType() == POSITION_TYPE_SELL) {
                double currentPrice = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
                if(openPrice - currentPrice > m_trailStart * _Point) {
                    newSL = currentPrice + m_trailStop * _Point;
                    if(newSL < currentSL - _Point || currentSL == 0) {
                        m_trade.PositionModify(position.Ticket(), newSL, position.TakeProfit());
                    }
                }
            }
        }
    }
};
```

## Position Counting

```mql5
input ulong MagicNumber = 123456;  // Unique identifier for EA orders

int CountPositions(ENUM_POSITION_TYPE posType = POSITION_TYPE_BUY) {
    CPositionInfo position;
    int count = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            if(position.Magic() == MagicNumber && position.Symbol() == Symbol()) {
                if(posType == POSITION_TYPE_BUY || position.PositionType() == posType) {
                    count++;
                }
            }
        }
    }
    return count;
}

int CountAllPositions() {
    CPositionInfo position;
    int count = 0;
    
    for(int i = PositionsTotal() - 1; i >= 0; i--) {
        if(position.SelectByIndex(i)) {
            if(position.Magic() == MagicNumber && position.Symbol() == Symbol()) {
                count++;
            }
        }
    }
    return count;
}