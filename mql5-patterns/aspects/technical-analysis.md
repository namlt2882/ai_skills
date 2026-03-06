# MQL5 Technical Analysis Patterns

## Indicator Handles and Buffer Management

```mql5
class CIndicators {
private:
    int m_maFastHandle;
    int m_maSlowHandle;
    int m_rsiHandle;
    
public:
    CIndicators() : m_maFastHandle(INVALID_HANDLE), 
                    m_maSlowHandle(INVALID_HANDLE),
                    m_rsiHandle(INVALID_HANDLE) {}
    
    ~CIndicators() {
        ReleaseHandles();
    }
    
    bool Initialize(int fastPeriod, int slowPeriod, int rsiPeriod) {
        m_maFastHandle = iMA(Symbol(), Period(), fastPeriod, 0, MODE_SMA, PRICE_CLOSE);
        m_maSlowHandle = iMA(Symbol(), Period(), slowPeriod, 0, MODE_SMA, PRICE_CLOSE);
        m_rsiHandle = iRSI(Symbol(), Period(), rsiPeriod, PRICE_CLOSE);
        
        if(m_maFastHandle == INVALID_HANDLE || 
           m_maSlowHandle == INVALID_HANDLE || 
           m_rsiHandle == INVALID_HANDLE) {
            Print("Failed to create indicator handles");
            return false;
        }
        
        return true;
    }
    
    int GetMASignal() const {
        double maFast[2], maSlow[2];
        
        if(CopyBuffer(m_maFastHandle, 0, 0, 2, maFast) < 2) return 0;
        if(CopyBuffer(m_maSlowHandle, 0, 0, 2, maSlow) < 2) return 0;
        
        // Bullish crossover
        if(maFast[1] <= maSlow[1] && maFast[0] > maSlow[0]) {
            return 1;
        }
        
        // Bearish crossover
        if(maFast[1] >= maSlow[1] && maFast[0] < maSlow[0]) {
            return -1;
        }
        
        return 0;
    }
    
    double GetRSI(int shift = 0) const {
        double rsi[1];
        if(CopyBuffer(m_rsiHandle, 0, shift, 1, rsi) < 1) return 50;
        return rsi[0];
    }
    
private:
    void ReleaseHandles() {
        if(m_maFastHandle != INVALID_HANDLE) {
            IndicatorRelease(m_maFastHandle);
            m_maFastHandle = INVALID_HANDLE;
        }
        if(m_maSlowHandle != INVALID_HANDLE) {
            IndicatorRelease(m_maSlowHandle);
            m_maSlowHandle = INVALID_HANDLE;
        }
        if(m_rsiHandle != INVALID_HANDLE) {
            IndicatorRelease(m_rsiHandle);
            m_rsiHandle = INVALID_HANDLE;
        }
    }
};
```

## Custom Indicator Class

```mql5
class CCustomIndicator {
private:
    int m_handle;
    string m_name;
    
public:
    CCustomIndicator(string name) : m_name(name), m_handle(INVALID_HANDLE) {}
    
    bool Create(int param1, int param2) {
        m_handle = iCustom(Symbol(), Period(), m_name, param1, param2);
        return m_handle != INVALID_HANDLE;
    }
    
    double GetValue(int bufferIndex, int shift) {
        double buffer[1];
        if(CopyBuffer(m_handle, bufferIndex, shift, 1, buffer) < 1) {
            return 0;
        }
        return buffer[0];
    }
    
    bool IsReady() {
        return BarsCalculated(m_handle) > 0;
    }
    
    ~CCustomIndicator() {
        if(m_handle != INVALID_HANDLE) {
            IndicatorRelease(m_handle);
        }
    }
};