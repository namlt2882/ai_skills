# RSS Feed Ingestion Framework

## Overview

RSS feed ingestion handles the fetching and parsing of RSS feeds from official economic data sources and financial news outlets. This module uses `curl` for parallel fetching and processes XML/JSON formats to extract structured news items with metadata.

## RSS Feed Sources

### Financial News RSS Feeds

| Source | RSS URL | Description |
|--------|---------|-------------|
| Reuters | https://www.reutersagency.com/feed/?best-topics=business-finance&post_type=best | Global business and finance news |
| Bloomberg | https://feeds.bloomberg.com/markets/news.rss | Market news and analysis |
| Financial Times | https://www.ft.com/rss/world/us/companies | Business and company news |
| CNBC | https://www.cnbc.com/id/10000664/device/rss/rss.html | Markets and investing news |

### Official Economic Data RSS Feeds

| Source | RSS URL | Description |
|--------|---------|-------------|
| BLS (Bureau of Labor Statistics) | https://www.bls.gov/rss/releases.xml | US labor statistics releases |
| BEA (Bureau of Economic Analysis) | https://www.bea.gov/rss/rss.xml | US economic accounts releases |
| Eurostat | https://ec.europa.eu/eurostat/en/web/rss | European Union statistics |
| ONS (Office for National Statistics) | https://www.ons.gov.uk/releasecalendar/rss | UK official statistics releases |
| IMF (International Monetary Fund) | https://www.imf.org/en/rss | IMF news and reports |
| World Bank | https://www.worldbank.org/en/rss | World Bank news and data |
| BIS (Bank for International Settlements) | https://www.bis.org/rss.htm | Central bank and financial stability |
| Trading Economics Calendar | https://tradingeconomics.com/calendar.rss | Economic calendar events and forecasts |

### Vietnamese Economic Data RSS Feeds

| Source | RSS URL | Description |
|--------|---------|-------------|
| GSO (General Statistics Office of Vietnam) | https://www.gso.gov.vn/rss | Vietnamese economic statistics (GDP, CPI, employment, trade) |
| SBV (State Bank of Vietnam) | https://sbv.gov.vn/rss | Monetary policy, interest rates, exchange rates |
| MPI (Ministry of Planning and Investment) | https://www.mpi.gov.vn/rss | FDI data, investment statistics, economic development |
| Ministry of Labor (MOLISA) | https://molisa.gov.vn/rss | Employment statistics, labor market data, wage information |
| Ministry of Industry and Trade (MOIT) | https://moit.gov.vn/rss | Trade data, industrial production, exports/imports, retail sales |
| Ministry of Agriculture and Rural Development (MARD) | https://mard.gov.vn/rss | Agricultural production, food prices, rural development data |
| Ministry of Construction (MOC) | https://moc.gov.vn/rss | Construction sector data, real estate market indicators |
| Ministry of Transport (MOT) | https://mt.gov.vn/rss | Transport sector data, logistics indicators |

### Vietnamese Financial News RSS Feeds

| Source | RSS URL | Description |
|--------|---------|-------------|
| VietStock | https://vietstock.vn/rss | Vietnamese stock market news and analysis |
| CafeF | https://cafef.vn/rss | Vietnamese financial news and market data |
| VnEconomy | https://vneconomy.vn/rss | Vietnamese economic and business news |

## RSS Ingestion Workflow

### Step 1: Fetch RSS Feeds in Parallel

Use `curl` to fetch all RSS feeds simultaneously:

```bash
# Fetch multiple RSS feeds in parallel
curl -s --max-time 30 --retry 3 "https://www.reutersagency.com/feed/?best-topics=business-finance&post_type=best" -o reuters.xml &
curl -s --max-time 30 --retry 3 "https://feeds.bloomberg.com/markets/news.rss" -o bloomberg.xml &
curl -s --max-time 30 --retry 3 "https://www.ft.com/rss/world/us/companies" -o ft.xml &
curl -s --max-time 30 --retry 3 "https://www.cnbc.com/id/10000664/device/rss/rss.html" -o cnbc.xml &
curl -s --max-time 30 --retry 3 "https://www.bls.gov/rss/releases.xml" -o bls.xml &
curl -s --max-time 30 --retry 3 "https://www.bea.gov/rss/rss.xml" -o bea.xml &
curl -s --max-time 30 --retry 3 "https://www.gso.gov.vn/rss" -o gso.xml &
curl -s --max-time 30 --retry 3 "https://sbv.gov.vn/rss" -o sbv.xml &
curl -s --max-time 30 --retry 3 "https://www.mpi.gov.vn/rss" -o mpi.xml &
curl -s --max-time 30 --retry 3 "https://molisa.gov.vn/rss" -o molisa.xml &
curl -s --max-time 30 --retry 3 "https://moit.gov.vn/rss" -o moet.xml &
curl -s --max-time 30 --retry 3 "https://mard.gov.vn/rss" -o mard.xml &
curl -s --max-time 30 --retry 3 "https://moc.gov.vn/rss" -o moc.xml &
curl -s --max-time 30 --retry 3 "https://mt.gov.vn/rss" -o mot.xml &
curl -s --max-time 30 --retry 3 "https://vietstock.vn/rss" -o vietstock.xml &
curl -s --max-time 30 --retry 3 "https://cafef.vn/rss" -o cafef.xml &
wait
```

### Step 2: Parse RSS XML/JSON Format

Extract items with titles, links, descriptions, and publication dates:

```bash
# Example: Parse RSS XML using xmllint or similar tool
xmllint --xpath "//item" reuters.xml
```

**Required Fields from RSS Items:**
- `<title>` - Article title
- `<link>` - Article URL
- `<description>` - Article summary/description
- `<pubDate>` or `<published>` - Publication timestamp
- `<guid>` - Unique identifier (optional)
- `<category>` - Category tags (optional)

### Step 3: Validate and Normalize Timestamps

**Extract `<pubDate>` or `<published>` from RSS XML:**
- Parse RFC 2822 format (e.g., "Mon, 04 Mar 2026 08:40:00 +0000")
- Parse ISO 8601 format (e.g., "2026-03-04T08:40:00Z")
- Normalize to UTC timezone

**Timestamp Validation Rules:**
1. Timestamp must be present - skip items without publication date
2. Timestamp must be parseable - skip items with invalid formats
3. Timestamp must be in the past - skip future timestamps
4. Timestamp must be reasonable - reject obviously invalid dates (e.g., 1970, 2099)

### Step 4: Apply Recency Filtering

| Source Type | Max Age | Notes |
|-------------|---------|-------|
| RSS feeds (news) | 48 hours | Older items are stale |
| RSS feeds (official data) | 72 hours | Official data releases may be referenced longer |

**Skip items that exceed max age:**
1. Calculate age: `current_utc_time - published_at_utc`
2. If age > max_age for source type, skip item
3. Log skipped items with reason: `"stale: published_at exceeds max age"`

### Step 5: Apply Relevance Filtering

**Treat as relevant if RSS item contains:**

**Vietnamese Keywords:**
- "lãi suất", "tỷ giá", "chứng khoán", "VN-Index", "trái phiếu"
- "ngân hàng", "tín dụng", "GDP", "CPI", "lạm phát"
- "doanh nghiệp", "lợi nhuận", "M&A", "IPO"

**English Keywords:**
- "interest rate", "inflation", "stock market", "bond", "banking"
- "credit", "earnings", "revenue", "merger", "acquisition", "IPO"
- "GDP", "CPI", "PPI", "PMI", "employment", "unemployment"

**Official data releases are always considered relevant:**
- BLS employment data
- BEA GDP releases
- Eurostat economic indicators
- IMF reports
- World Bank data
- BIS publications
- GSO Vietnamese economic data (GDP, CPI, employment, trade)
- SBV monetary policy announcements
- MPI FDI and investment data

### Step 6: Store RSS Items for Deduplication

Track which sources have successfully fetched RSS feeds:

```json
{
  "rss_fetch_status": {
    "reuters": "success",
    "bloomberg": "success",
    "ft": "success",
    "cnbc": "success",
    "bls": "success",
    "bea": "success",
    "eurostat": "success",
    "ons": "success",
    "imf": "success",
    "worldbank": "success",
    "bis": "success",
    "tradingeconomics-calendar": "success",
    "gso": "success",
    "sbv": "success",
    "mpi": "success",
    "molisa": "success",
    "moit": "success",
    "mard": "success",
    "moc": "success",
    "mot": "success",
    "vietstock": "success",
    "cafef": "success"
  }
}
```

## RSS Override Rules

**RSS overrides website crawling**: If an RSS feed is successfully fetched for a source, skip crawling that source's website to avoid duplicates.

**Sources with RSS Override:**
- Reuters → Skip https://reuters.com/finance scraping
- Bloomberg → Skip https://bloomberg.com/markets scraping
- Financial Times → Skip https://ft.com/markets scraping
- CNBC → Skip https://cnbc.com/markets scraping

**Implementation:**
```json
{
  "skip_website_crawling": ["reuters", "bloomberg", "ft", "cnbc"],
  "reason": "RSS feed successfully fetched"
}
```

## RSS Item Output Schema

Each RSS item should produce:

```json
{
  "source": "reuters-rss|bloomberg-rss|ft-rss|cnbc-rss|bls|bea|eurostat|ons|imf|worldbank|bis|tradingeconomics|gso|sbv|mpi|molisa|moit|mard|moc|mot|vietstock-rss|cafef-rss",
  "source_type": "rss",
  "title": "...",
  "canonical_url": "https://...",
  "published_at": "2026-03-04T08:40:00Z",
  "summary": "...",
  "key_facts": ["...", "..."],
  "entities": {
    "companies": ["..."],
    "tickers": ["..."],
    "macro": ["inflation", "GDP", "FX", "rates"]
  },
  "sentiment": "positive|neutral|negative",
  "market_impact": "low|medium|high",
  "topics": ["banking", "stocks", "real-estate", "energy"],
  "is_related": true,
  "credibility": "credible"
}
```

## Credibility Classification

**RSS feeds from official sources are automatically classified as credible:**

| Source Type | Credibility | Notes |
|-------------|-------------|-------|
| Financial news RSS (Reuters, Bloomberg, FT, CNBC) | Credible | Professional journalism standards |
| Official data RSS (BLS, BEA, Eurostat, ONS) | Credible | Government/official sources |
| International organization RSS (IMF, World Bank, BIS) | Credible | Official institutional sources |
| Trading Economics Calendar | Credible | Aggregated official data |
| Vietnamese official data RSS (GSO, SBV, MPI, MOLISA, MOIT, MARD, MOC, MOT) | Credible | Vietnamese government sources |
| Vietnamese financial news RSS (VietStock, CafeF) | Medium-High | Local financial media |

## Error Handling

### Fetch Failures

| Error Type | Action | Retry |
|------------|--------|-------|
| Timeout | Log error, skip feed | Retry up to 3 times |
| HTTP 4xx | Log error, skip feed | No retry |
| HTTP 5xx | Log error, skip feed | Retry up to 3 times |
| Invalid XML | Log error, skip feed | No retry |
| Empty feed | Log warning, continue | No retry |

### Retry Configuration

```bash
# Retry configuration
MAX_RETRIES=3
TIMEOUT=30
RETRY_DELAY=5
```

## Integration with Other Modules

- **News Aggregation**: RSS override prevents duplicate website crawling
- **Data Deduplication**: Pass all RSS items through deduplication
- **Credibility Verification**: RSS items are pre-classified as credible
- **Language Enforcement**: Use detected language for summaries
- **Economic Calendar**: Trading Economics RSS provides calendar events

## RSS Feed Monitoring

### Health Check

Monitor RSS feed availability and freshness:

```json
{
  "rss_health": {
    "reuters": {
      "status": "healthy",
      "last_fetch": "2026-03-04T09:00:00Z",
      "items_count": 25,
      "latest_item_age": "2 hours"
    },
    "bls": {
      "status": "healthy",
      "last_fetch": "2026-03-04T09:00:00Z",
      "items_count": 5,
      "latest_item_age": "6 hours"
    }
  }
}
```

### Stale Feed Detection

Flag feeds that haven't been updated in over 48 hours:

```json
{
  "stale_feeds": ["example-feed"],
  "reason": "No new items in 48+ hours"
}