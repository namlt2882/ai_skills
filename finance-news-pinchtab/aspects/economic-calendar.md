# Economic Calendar Framework

## Overview

Economic calendar handling collects and processes upcoming economic events from multiple sources. This module scrapes Investing.com via PinchTab and ingests Trading Economics RSS feeds to provide comprehensive coverage of market-moving economic events.

## Data Sources

### Investing.com Economic Calendar (PinchTab Scraping)

**Important**: Investing.com does **not** provide RSS feeds for economic calendar data. Must be scraped using PinchTab.

| Source | URL | Method | Description |
|--------|-----|--------|-------------|
| Investing.com | https://investing.com/economic-calendar | PinchTab scraping | Comprehensive economic calendar with global events, impact ratings, and actual/forecast/previous values |

### Trading Economics Economic Calendar (RSS)

| Source | RSS URL | Description |
|--------|---------|-------------|
| Trading Economics Calendar | https://tradingeconomics.com/calendar.rss | Economic calendar events with indicators and forecasts |

### Vietnamese Economic Calendar Sources

| Source | URL | Method | Description |
|--------|-----|--------|-------------|
| GSO (General Statistics Office) | https://www.gso.gov.vn | RSS + PinchTab scraping | Vietnamese economic data releases (GDP, CPI, employment, trade) |
| SBV (State Bank of Vietnam) | https://sbv.gov.vn | RSS + PinchTab scraping | Monetary policy decisions, interest rate announcements, exchange rates |
| MPI (Ministry of Planning and Investment) | https://www.mpi.gov.vn | RSS + PinchTab scraping | FDI data, investment statistics, economic development indicators |
| Ministry of Labor (MOLISA) | https://molisa.gov.vn | RSS + PinchTab scraping | Employment statistics, labor market data, wage information |
| Ministry of Industry and Trade (MOIT) | https://moit.gov.vn | RSS + PinchTab scraping | Trade data, industrial production, exports/imports, retail sales |
| Ministry of Agriculture and Rural Development (MARD) | https://mard.gov.vn | RSS + PinchTab scraping | Agricultural production, food prices, rural development data |
| Ministry of Construction (MOC) | https://moc.gov.vn | RSS + PinchTab scraping | Construction sector data, real estate market indicators |
| Ministry of Transport (MOT) | https://mt.gov.vn | RSS + PinchTab scraping | Transport sector data, logistics indicators |
| DStock VNDIRECT | https://dstock.vndirect.com.vn | PinchTab scraping | Vietnamese economic calendar with market-specific events |

## Investing.com Calendar Scraping Workflow

### Step 1: Navigate to Calendar Page

```bash
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://investing.com/economic-calendar"}'
```

### Step 2: Extract Calendar Events

Use `snapshot` and `text` to extract event rows:

```bash
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/snapshot"
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/text"
```

### Step 3: Parse Event Data

Extract from each calendar row:
- `date`: Event date
- `time`: Event time
- `country`: Country/region code (US, EU, UK, CN, JP, etc.)
- `indicator`: Economic indicator name
- `actual`: Actual value (if released)
- `forecast`: Forecast/consensus value
- `previous`: Previous period value
- `impact`: Impact level (low, medium, high)

### Step 4: Identify Impact Level

Parse visual indicators for impact level:
- **High impact**: Typically marked with red/orange indicators or 3 stars
- **Medium impact**: Typically marked with yellow/orange indicators or 2 stars
- **Low impact**: Typically marked with gray/green indicators or 1 star

### Step 5: Apply Relevance Filtering

Focus on events within the next 7 days with appropriate impact levels.

## Trading Economics Calendar RSS Ingestion

### Step 1: Fetch Calendar RSS Feed

```bash
curl -s --max-time 30 --retry 3 "https://tradingeconomics.com/calendar.rss"
curl -s --max-time 30 --retry 3 "https://www.gso.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://sbv.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://www.mpi.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://molisa.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://moit.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://mard.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://moc.gov.vn/rss"
curl -s --max-time 30 --retry 3 "https://mt.gov.vn/rss"
```

### Step 2: Parse Calendar Items

Extract from RSS items:
- Event date and time
- Country/region
- Indicator name
- Actual, forecast, and previous values
- Impact level from item metadata

### Step 3: Apply Relevance Filtering

Same criteria as Investing.com calendar:
- Focus on high-impact events for major economies
- Include medium-impact events for US, EU, UK, China, Japan
- Include all Vietnamese economic data releases (GDP, CPI, employment, trade, FDI)
- Include SBV monetary policy announcements and interest rate decisions
- Include MOLISA employment and labor market data releases
- Include MOIT trade data, industrial production, and retail sales releases
- Include MARD agricultural production and food price data
- Include MOC construction sector and real estate data
- Include MOT transport sector and logistics data

### Step 4: Store Calendar Events

Add to `economic_calendar.upcoming_events` in output schema with source tracking as `tradingeconomics-rss`, `gso-rss`, `sbv-rss`, `mpi-rss`, `molisa-rss`, `moit-rss`, `mard-rss`, `moc-rss`, `mot-rss`.

## Event Categorization

### High-Impact Events (Always Include)

| Event Type | Examples | Market Impact |
|------------|----------|---------------|
| Central Bank Decisions | FOMC Rate Decision, ECB Rate Decision, BOE Rate Decision | Very High |
| Employment Data | Non-Farm Payrolls, Unemployment Rate, ADP Employment | Very High |
| Inflation Data | CPI, Core CPI, PPI, PCE Price Index | Very High |
| GDP Releases | GDP Advance, GDP Preliminary, GDP Final | High |
| PMI Reports | Manufacturing PMI, Services PMI, Composite PMI | High |
| Retail Sales | Retail Sales, Retail Sales ex-Auto | High |
| Trade Data | Trade Balance, Import/Export Prices | Medium-High |
| Consumer Confidence | Consumer Confidence, Consumer Sentiment | Medium |

### Vietnamese Economic Events (Always Include)

| Event Type | Examples | Market Impact |
|------------|----------|---------------|
| Vietnamese GDP | Quarterly GDP Growth Rate | High |
| Vietnamese CPI | Consumer Price Index | High |
| Vietnamese Employment | Employment Statistics, Labor Force Data | Medium-High |
| Vietnamese Trade | Trade Balance, Export/Import Data | Medium-High |
| Vietnamese FDI | Foreign Direct Investment Data | Medium |
| SBV Rate Decisions | SBV Interest Rate Decisions | Very High |
| SBV Exchange Rate | USD/VND Reference Rate | Medium-High |
| Vietnamese Industrial Production | Industrial Production Index | Medium |
| Vietnamese Retail Sales | Retail Sales Data | Medium |
| Vietnamese Agricultural Production | Agricultural Production Index | Medium |
| Vietnamese Construction Data | Construction Sector Indicators | Medium |
| Vietnamese Transport Data | Transport Sector Indicators | Low-Medium |
| Vietnamese Wage Data | Average Wage, Minimum Wage | Medium |

### Medium-Impact Events (Include for Major Economies)

| Event Type | Examples | Countries |
|------------|----------|-----------|
| Housing Data | Building Permits, Housing Starts, Existing Home Sales | US, UK, EU |
| Industrial Production | Industrial Production, Capacity Utilization | US, EU, CN, JP, VN |
| Durable Goods | Durable Goods Orders, Durable Goods ex-Transport | US |
| Business Surveys | Business Confidence, ZEW Survey | US, EU, UK |
| Wage Data | Average Hourly Earnings, Wage Growth | US, UK |

### Vietnamese Medium-Impact Events

| Event Type | Examples | Notes |
|------------|----------|-------|
| Vietnamese Manufacturing PMI | Manufacturing PMI | Key sector indicator |
| Vietnamese Services PMI | Services PMI | Service sector health |
| Vietnamese Retail Sales | Retail Sales Data | Consumer spending |
| Vietnamese Credit Growth | Bank Credit Growth | Financial sector health |
| Vietnamese Budget Balance | Government Budget | Fiscal position |

### Low-Impact Events (Optional)

| Event Type | Examples | Notes |
|------------|----------|-------|
| Minor Indicators | Wholesale Inventories, Business Inventories | Limited market impact |
| Regional Data | State-level employment, Regional PMI | Supplemental context |
| Revised Data | Minor revisions to prior releases | Historical context only |

## Time Range Filtering

### Upcoming Events Window

| Time Range | Priority | Action |
|------------|----------|--------|
| Next 24 hours | Critical | Always include, highlight in output |
| Next 48 hours | High | Include all high/medium impact events |
| Next 7 days | Standard | Include high-impact events only |
| Beyond 7 days | Low | Optional, for planning purposes |

### Past Events Handling

- Skip past events (unless referenced in current coverage)
- Include recently released data if actual value differs significantly from forecast
- Flag "surprise" releases where actual vs forecast divergence > 10%

## Cross-Source Deduplication

### Deduplication Keys

**Primary Key:**
- `indicator + date + country`

**Secondary Key:**
- `normalized_indicator_name + date`

### Deduplication Process

1. Collect events from Investing.com, Trading Economics, GSO, SBV, MPI, MOLISA, MOIT, MARD, MOC, and MOT
2. Normalize indicator names (e.g., "Non-Farm Payrolls" = "NFP" = "Nonfarm Employment")
3. Match events by primary key
4. For duplicates, prefer:
   - Investing.com for comprehensive data (includes more detail)
   - Trading Economics for speed (RSS is faster than scraping)
   - GSO/SBV/MPI/MOLISA/MOIT/MARD/MOC/MOT for Vietnamese-specific events (primary source)
5. Track source attribution for each event

## Output Schema

### Economic Calendar Output

```json
{
  "economic_calendar": {
    "upcoming_events": [
      {
        "date": "2026-03-04",
        "time": "14:00",
        "timezone": "UTC",
        "country": "US",
        "indicator": "Non-Farm Payrolls",
        "actual": null,
        "forecast": "200K",
        "previous": "175K",
        "impact": "high",
        "source": "investing-com|tradingeconomics-rss|gso-rss|sbv-rss|mpi-rss|molisa-rss|moit-rss|mard-rss|moc-rss|mot-rss|dstock",
        "notes": "Key labor market indicator"
      }
    ],
    "high_impact_events": [
      {
        "date": "2026-03-04",
        "indicator": "Non-Farm Payrolls",
        "country": "US",
        "time_until": "2 hours"
      }
    ],
    "total_events": 25,
    "events_by_country": {
      "US": 8,
      "EU": 5,
      "UK": 4,
      "CN": 3,
      "JP": 3,
      "VN": 5,
      "Other": 2
    },
    "events_by_impact": {
      "high": 10,
      "medium": 8,
      "low": 7
    }
  }
}
```

### Calendar Event Schema

```json
{
  "date": "2026-03-04",
  "time": "14:00",
  "timezone": "UTC",
  "country": "US",
  "country_name": "United States",
  "indicator": "Non-Farm Payrolls",
  "indicator_code": "NFP",
  "actual": null,
  "forecast": "200K",
  "previous": "175K",
  "unit": "K",
  "impact": "high",
  "source": "investing-com",
  "event_url": "https://investing.com/economic-calendar/...",
  "notes": "Key labor market indicator for Fed policy"
}
```

## Market Impact Assessment

### Pre-Event Analysis

For upcoming high-impact events, provide:

1. **Consensus expectations**: What the market is pricing in
2. **Range of estimates**: High/low forecast range
3. **Potential scenarios**: Bull/bear case outcomes
4. **Market positioning**: How markets are positioned ahead of the event

### Post-Event Analysis

For recently released data:

1. **Surprise factor**: Actual vs forecast divergence
2. **Market reaction**: Initial price movements
3. **Implications**: What it means for policy/markets
4. **Related events**: Upcoming events that may be affected

## Integration with Other Modules

### News Aggregation Integration

- Cross-reference calendar events with news coverage
- Flag news items related to upcoming economic events
- Provide context for market-moving news

### RSS Ingestion Integration

- Trading Economics RSS provides calendar events
- Coordinate with RSS ingestion for deduplication
- Use RSS for faster calendar updates

### Output Integration

Include calendar summary in final output:

```json
{
  "analysis": {
    "upcoming_calendar_risks": [
      "US Non-Farm Payrolls (Mar 4, 14:00 UTC) - High impact",
      "FOMC Rate Decision (Mar 5, 18:00 UTC) - Very high impact"
    ],
    "recent_surprises": [
      "US CPI came in at 0.4% vs 0.3% forecast - Higher than expected"
    ]
  }
}
```

## Error Handling

| Error Type | Action | Retry |
|------------|--------|-------|
| Investing.com timeout | Retry request | Up to 3 times |
| RSS fetch failure | Use Investing.com only | Retry RSS later |
| Invalid event data | Skip event, log warning | No retry |
| Missing impact level | Default to medium | No retry |

## Monitoring and Alerts

### Calendar Alert Triggers

- High-impact event within 1 hour
- Actual value significantly different from forecast (>10%)
- Multiple high-impact events on same day
- Central bank decision upcoming

### Alert Output

```json
{
  "calendar_alert": {
    "type": "upcoming_high_impact",
    "event": "US Non-Farm Payrolls",
    "time": "2026-03-04T14:00:00Z",
    "time_until": "30 minutes",
    "impact": "high",
    "forecast": "200K",
    "previous": "175K"
  }
}