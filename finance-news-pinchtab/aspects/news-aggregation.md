# News Aggregation Framework

## Overview

News aggregation handles the scraping and collection of finance-related news from Vietnamese and global sources using PinchTab. This module ensures parallel processing, relevance filtering, and proper timestamp handling for all collected articles.

## Source Whitelist

### Vietnamese Sources

| Source | URL | Section | Language |
|--------|-----|---------|----------|
| Vietstock | https://vietstock.vn/chung-khoan.htm | Chung khoan (Stocks) | Vietnamese |
| VnEconomy | https://vneconomy.vn/ | Finance & Economy | Vietnamese |
| VietnamNet | https://vietnamnet.vn/kinh-doanh | Kinh doanh (Business) | Vietnamese |
| CafeF | https://cafef.vn/ | Finance & Stocks | Vietnamese |
| Tinnhanhchungkhoan | https://tinnhanhchungkhoan.vn/ | Chứng khoán (Stocks) | Vietnamese |
| VietnamFinance | https://vietnamfinance.vn/ | Tài chính (Finance) | Vietnamese |
| EnterNews | https://enternews.vn/ | Kinh doanh (Business) | Vietnamese |
| TapChiTaiLieu | https://tapchitailieu.vn/ | Tài chính - Ngân hàng (Finance - Banking) | Vietnamese |
| BloombergVN | https://bloombergvn.com/ | Thị trường (Markets) | Vietnamese |
| TaiChinhDoanhNghiep | https://taichinhdoanhnghiep.net.vn/ | Tài chính Doanh nghiệp (Corporate Finance) | Vietnamese |

### Vietnamese Market Data Sources

| Source | URL | Section | Language |
|--------|-----|---------|----------|
| VNDIRECT DStock | https://dstock.vndirect.com.vn/ | Market Data & Research | Vietnamese |
| StockBook | https://stockbook.vn/ | Market Data & Analysis | Vietnamese |
| HOSE (Ho Chi Minh Stock Exchange) | https://www.hsx.vn | Market Data | Vietnamese |
| HNX (Hanoi Stock Exchange) | https://www.hnx.vn | Market Data | Vietnamese |

### Vietnamese Economic Data Sources

| Source | URL | Section | Language |
|--------|-----|---------|----------|
| GSO (General Statistics Office) | https://www.gso.gov.vn | Economic Statistics | Vietnamese |
| SBV (State Bank of Vietnam) | https://sbv.gov.vn | Monetary Policy | Vietnamese |
| MPI (Ministry of Planning and Investment) | https://www.mpi.gov.vn | Investment Data | Vietnamese |

### Vietnamese Regulatory Sources

| Source | URL | Section | Language |
|--------|-----|---------|----------|
| SSC (State Securities Commission) | https://www.ssc.gov.vn | Securities Regulations | Vietnamese |
| MOF (Ministry of Finance) | https://mof.gov.vn | Fiscal Policy & Regulations | Vietnamese |
| VSD (Vietnam Securities Depository) | https://vsd.vn | Securities Depository & Settlement | Vietnamese |
| VSE (Vietnam Stock Exchange) | https://vse.vn | Exchange Rules & Announcements | Vietnamese |
| ISA (Insurance Supervisory Authority) | https://isa.gov.vn | Insurance Regulations | Vietnamese |
| Vietnam Competition Authority | https://vietnamcompetition.gov.vn | Competition & Antitrust | Vietnamese |

### Global Sources

| Source | URL | Section | Language |
|--------|-----|---------|----------|
| Reuters | https://reuters.com/finance | Finance | English |
| Financial Times | https://ft.com/markets | Markets | English |
| Bloomberg | https://bloomberg.com/markets | Markets | English |
| Wall Street Journal | https://wsj.com/markets | Markets | English |
| CNBC | https://cnbc.com/markets | Markets | English |

**Note**: Reuters, Bloomberg, FT, CNBC, VietStock, and CafeF have RSS feeds available. When RSS feeds are successfully fetched, skip website crawling for these sources to avoid duplicates. Vietnamese regulatory sources (SSC, MOF, VSD, VSE, ISA, Competition Authority) also provide RSS feeds for official announcements.

## Parallel Scraping Implementation

### Server Configuration

Start exactly 4 PinchTab servers (max parallelism enforced):

```bash
pinchtab --port 9867
pinchtab --port 9868
pinchtab --port 9869
pinchtab --port 9870
```

### Instance Assignment

Assign each source to its own server/instance:

| Server Port | Source Assignment |
|-------------|-------------------|
| 9867 | Vietnamese sources (Vietstock, VnEconomy) |
| 9868 | Vietnamese sources (VietnamNet, CafeF) |
| 9869 | Vietnamese market data (DStock, StockBook, HOSE, HNX) |
| 9870 | Vietnamese economic data (GSO, SBV, MPI) + Global sources (WSJ - no RSS) |
| 9871 | Vietnamese regulatory sources (SSC, MOF, VSD, VSE, ISA, Competition Authority) |
| 9872 | Economic calendar / Social tracking |

### Concurrency Control

- Process sources in parallel with a small per-source concurrency (1-2 tabs)
- Maximum of 4 parallel instances allowed
- Implement a concurrency gate to limit per-source in-flight requests (avoid bans)

## Scraping Workflow

### Step 1: Navigate to Source

```bash
# Vietnamese news sources
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://vietstock.vn/chung-khoan.htm"}'

# Vietnamese market data sources
curl -s -X POST "http://localhost:9869/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://dstock.vndirect.com.vn/"}'

# Vietnamese economic data sources
curl -s -X POST "http://localhost:9870/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://www.gso.gov.vn/"}'

# Vietnamese regulatory sources
curl -s -X POST "http://localhost:9871/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://www.ssc.gov.vn/"}'
```

### Step 2: Extract List Items

Use `snapshot` and `text` to extract list items:

```bash
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/snapshot"
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/text"
```

### Step 3: Extract and Validate Timestamps

**Critical**: All items MUST capture `published_at` timestamp.

Extract from article meta tags in priority order:
1. `<meta property="article:published_time">`
2. `<meta name="date">`
3. `<time datetime="...">` element
4. Article header date text

### Step 4: Normalize Timestamps to UTC

For items without explicit timezone, assume source's local timezone:
- Vietnamese sources: Asia/Ho_Chi_Minh (UTC+7)
- Vietnamese official data (GSO, SBV, MPI): Asia/Ho_Chi_Minh (UTC+7)
- Vietnamese market data (DStock, HOSE, HNX): Asia/Ho_Chi_Minh (UTC+7)
- US sources: America/New_York (UTC-5/-4)
- European sources: Europe/London (UTC+0/+1)
- Global sources: Use UTC if timezone cannot be determined

### Step 5: Apply Recency Filtering

| Source Type | Max Age | Notes |
|-------------|---------|-------|
| Website articles | 48 hours | Older articles are stale |
| RSS feeds (news) | 48 hours | Older items are stale |
| RSS feeds (official data) | 72 hours | Official data releases may be referenced longer |
| Vietnamese market data | 24 hours | Market data is time-sensitive |
| Vietnamese economic data | 72 hours | Official Vietnamese data releases may be referenced longer |
| Vietnamese regulatory announcements | 168 hours (7 days) | Regulatory changes have longer-term impact |

**Skip items that exceed max age**:
1. Calculate age: `current_utc_time - published_at_utc`
2. If age > max_age for source type, skip item
3. Log skipped items with reason: `"stale: published_at exceeds max age"`

## Relevance Heuristics

### List Page Filtering

Treat as **likely finance-related** if list snippet contains:

**Vietnamese Keywords:**
- "lãi suất", "tỷ giá", "chứng khoán", "VN-Index", "trái phiếu"
- "ngân hàng", "tín dụng", "GDP", "CPI", "lạm phát", "FDI"
- "doanh nghiệp", "lợi nhuận", "doanh thu", "M&A", "IPO", "nợ xấu"
- "bluechip", "penny stock", "margin", "phái sinh", "UPCoM", "HNX"
- "đại hội cổ đông", "công bố kết quả kinh doanh", "điều hành tiền tệ"
- "kim ngạch xuất nhập khẩu", "dự trữ ngoại hối", "chào bán cổ phần"
- "VN30", "HOSE", "HNX", "UPCoM", "DStock", "VNDIRECT"
- "Ngân hàng Nhà nước", "SBV", "GSO", "MPI", "vốn đầu tư trực tiếp nước ngoài"

**Vietnamese Regulatory Keywords:**
- "Ủy ban Chứng khoán Nhà nước", "SSC", "Bộ Tài chính", "MOF"
- "Trung tâm Lưu ký Chứng khoán Việt Nam", "VSD", "Sở Giao dịch Chứng khoán Việt Nam", "VSE"
- "quy định", "thông tư", "nghị định", "quyết định", "văn bản pháp luật"
- "giấy phép", "cấp phép", "thu hồi giấy phép", "đình chỉ hoạt động"
- "kiểm toán", "thanh tra", "kiểm tra", "xử phạt", "vi phạm"
- "niêm yết", "hủy niêm yết", "đăng ký giao dịch", "cổ phiếu quỹ"
- "tỷ lệ sở hữu nước ngoài", "FOL", "room ngoại", "hạn mức sở hữu"
- "biên độ dao động", "trần/sàn giá", "giá tham chiếu", "điều chỉnh giá"
- "thanh khoản", "giao dịch đặc biệt", "cảnh báo rủi ro", "đình chỉ giao dịch"
- "bảo hiểm", "giám sát bảo hiểm", "ISA", "cạnh tranh", "antitrust"

**English Keywords:**
- "interest rate", "inflation", "stock market", "bond", "banking"
- "credit", "earnings", "revenue", "merger", "acquisition", "IPO", "default"
- "bluechip", "penny stock", "margin", "derivatives", "UPCoM", "HNX"
- "VN30", "HOSE", "HNX", "UPCoM", "Vietnam stock market", "Vietnamese equities"
- "State Bank of Vietnam", "SBV", "GSO", "MPI", "FDI Vietnam"

**Vietnamese Regulatory Keywords (English):**
- "State Securities Commission", "SSC", "Ministry of Finance", "MOF"
- "Vietnam Securities Depository", "VSD", "Vietnam Stock Exchange", "VSE"
- "regulation", "circular", "decree", "decision", "legal document"
- "license", "licensing", "license revocation", "suspension"
- "audit", "inspection", "examination", "penalty", "violation"
- "listing", "delisting", "trading registration", "treasury shares"
- "foreign ownership limit", "FOL", "foreign room", "ownership cap"
- "price band", "ceiling/floor price", "reference price", "price adjustment"
- "liquidity", "special trading", "risk warning", "trading suspension"
- "insurance", "insurance supervision", "ISA", "competition", "antitrust"

**Category Labels:**
- "Tài chính", "Ngân hàng", "Chứng khoán", "Kinh tế vĩ mô"
- "Finance", "Banking", "Markets", "Economy", "Business", "Investing"
- "Doanh nghiệp", "Quản trị rủi ro", "Phân tích tài chính", "Kiểm toán"
- "Thị trường chứng khoán", "Dữ liệu thị trường", "Kinh tế Việt Nam"
- "Market Data", "Vietnam Economy", "Vietnamese Stock Market"
- "Quy định", "Thông tư", "Nghị định", "Văn bản pháp luật"
- "Regulation", "Circular", "Decree", "Legal Document"
- "Cảnh báo rủi ro", "Đình chỉ giao dịch", "Hủy niêm yết"
- "Risk Warning", "Trading Suspension", "Delisting"

### Noise Filtering

Treat as **noise** if list snippet or category contains:
- Lifestyle, sports, entertainment, travel
- Health, education, culture
- General non-finance content

### Uncertainty Handling

If uncertain → open detail page and re-classify using full text.

## Detail Page Extraction

### When to Open Detail Pages

Only open the article detail page **if the item is likely finance-related**:
1. Perform quick relevance check from list snippet text
2. Check category labels if available
3. Skip noise items (lifestyle, sports, entertainment)
4. If uncertain, open detail page and re-classify

### Depth Limit

- Only navigate one level deep: list page → article detail page
- Do NOT follow related article links
- Do NOT follow comment sections

### Extraction Fields

From each detail page, extract:
- `title`: Article headline
- `canonical_url`: Canonical URL from `<link rel="canonical">`
- `published_at`: Publication timestamp (ISO 8601 with timezone)
- `author`: Byline if available
- `content`: Full article text
- `summary`: Meta description or first paragraph
- `entities`: Companies, tickers, macro terms mentioned

## Time Validation Failure Handling

| Failure Type | Action | Logging |
|--------------|--------|---------|
| Missing timestamp | Skip item | `"missing_published_at: no timestamp found"` |
| Unparseable timestamp | Skip item | `"invalid_timestamp: cannot parse timestamp"` |
| Future timestamp | Skip item | `"future_timestamp: timestamp is in the future"` |
| Stale item | Skip item | `"stale: published_at exceeds max age"` |
| Invalid date | Skip item | `"invalid_date: timestamp is not a valid date"` |

## RSS Override Rules

**RSS overrides website crawling**: If an RSS feed is successfully fetched for a source, skip crawling that source's website to avoid duplicates. This applies to:
- Reuters
- Bloomberg
- Financial Times
- CNBC
- VietStock
- CafeF
- Vietnamese regulatory sources (SSC, MOF, VSD, VSE, ISA, Competition Authority)

## Output Integration

Each scraped article should produce:

```json
{
  "source": "vietstock|vneconomy|vietnamnet-kinh-doanh|cafef|wsj|ssc|mof|vsd|vse|isa|competition",
  "source_type": "website",
  "title": "...",
  "canonical_url": "https://...",
  "published_at": "2026-03-04T08:40:00+07:00",
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
  "credibility": "credible|uncertain"
}
```

## Integration with Other Modules

- **RSS Ingestion**: Check RSS availability before website scraping
- **Data Deduplication**: Pass all items through deduplication after extraction
- **Credibility Verification**: Apply fake news detection rules to all items
- **Language Enforcement**: Use detected language for summaries
- **Regulatory Monitoring**: Vietnamese regulatory sources (SSC, MOF, VSD, VSE, ISA, Competition Authority) are automatically classified as credible and monitored for market-impacting announcements