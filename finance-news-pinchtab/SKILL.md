# Finance News Summarizer (PinchTab)

Summarize and analyze finance data by scraping trusted Vietnamese and global business news sources using PinchTab, supplemented with **RSS feed ingestion via curl** for official economic data releases and **economic calendar data**. This skill enforces **parallel crawling**, **deduplication**, **selective subpage verification** (only when a news item is likely relevant to finance), **social rumor tracking** from major news outlets, and **economic calendar monitoring** from Investing.com and Trading Economics.

## When to Use

**Trigger Detection**: This skill is automatically triggered when your request contains finance-related keywords. See the [Trigger Keywords](#trigger-keywords) section for the complete list of Vietnamese and English keywords that activate this skill.

Use this skill when:

- You need finance-focused summaries and analysis from:
  - **Vietnamese sources**: https://vietstock.vn/chung-khoan.htm, https://vneconomy.vn/, https://vietnamnet.vn/kinh-doanh, https://cafef.vn/
  - **Global sources**: https://reuters.com/finance, https://ft.com/markets, https://bloomberg.com/markets, https://wsj.com/markets, https://cnbc.com/markets
  - **RSS feeds**: Official economic data releases from BLS, BEA, Eurostat, ONS, IMF, World Bank, BIS, Trading Economics (includes economic calendar)
  - **Economic calendars**: https://investing.com/economic-calendar (scraped via PinchTab), Trading Economics calendar via RSS
- You want to track social rumors from major news outlets on Twitter/X.
- You want to avoid duplicates across sources.
- You only open article detail pages when the item is likely finance-related.
- You need to monitor upcoming economic events and data releases.

**Note**: For comprehensive US financial market analysis including intermarket relationships, risk assets correlation, technical indicators, and macroeconomic factors, use the [`us-financial-market-analysis`](../us-financial-market-analysis/SKILL.md) skill instead.

## Trigger Keywords

This skill is triggered when the user's request contains finance-related keywords in Vietnamese or English. The presence of these keywords indicates the need for finance news summarization and analysis.

### Vietnamese Trigger Keywords

**Macroeconomic Indicators:**
- GDP, CPI, PPI, PMI, VN-Index, HNX-Index
- lạm phát, lãi suất, tỷ giá, hối đoái
- tăng trưởng kinh tế, kinh tế vĩ mô
- thâm hụt thương mại, cán cân thanh toán

**Financial Markets:**
- chứng khoán, cổ phiếu, trái phiếu, tiền tệ
- thị trường tài chính, thị trường chứng khoán
- ngân hàng, tín dụng, nợ xấu
- đầu tư, cổ phần, cổ tức, lợi nhuận
- M&A, IPO, sáp nhập, mua lại

**Economic Events:**
- lịch kinh tế, lịch sự kiện kinh tế
- quyết định lãi suất, họp FOMC, họp ECB
- dữ liệu việc làm, phi nông nghiệp (NFP)
- báo cáo tài chính, báo cáo lợi nhuận

**Business & Corporate:**
- doanh nghiệp, công ty, tập đoàn
- doanh thu, lợi nhuận, tài sản, nợ
- cổ đông, cổ phần, niêm yết
- ngân hàng đầu tư, quỹ đầu tư

**Policy & Regulation:**
- chính sách tiền tệ, chính sách tài khóa
- Ngân hàng Nhà nước, Fed, ECB
- quy định, luật pháp, tài chính
- thuế, ngân sách, chi tiêu công

### English Trigger Keywords

**Macroeconomic Indicators:**
- GDP, CPI, PPI, PMI, inflation, deflation
- interest rate, exchange rate, FX, forex
- economic growth, macroeconomics
- trade deficit, balance of payments
- unemployment, employment, NFP, ADP

**Financial Markets:**
- stock market, equity, bond, currency
- financial market, capital market
- banking, credit, non-performing loans (NPL)
- investment, share, dividend, profit
- M&A, IPO, merger, acquisition
- S&P 500, Dow Jones, Nasdaq, FTSE

**Economic Events:**
- economic calendar, economic events
- rate decision, FOMC meeting, ECB meeting
- jobs data, non-farm payrolls
- earnings report, financial results

**Business & Corporate:**
- company, corporation, enterprise
- revenue, profit, assets, debt
- shareholder, equity, listing
- investment bank, hedge fund, mutual fund

**Policy & Regulation:**
- monetary policy, fiscal policy
- central bank, Federal Reserve, ECB
- regulation, financial regulation
- tax, budget, government spending

### Keyword Matching Rules

- **Case-insensitive**: Keywords match regardless of capitalization
- **Partial matching**: Substrings within larger phrases also trigger (e.g., "tỷ giá USD" matches "tỷ giá")
- **Multi-language support**: Keywords in either Vietnamese or English trigger the skill
- **Context awareness**: Keywords should appear in a finance-related context (not just random mentions)

## Scope-Limiting Strategy

To avoid unbounded crawling and maintain focus on finance-relevant content:

1. **Predefined source whitelist** - Only crawl from the explicitly listed Vietnamese and global sources. Do not expand to other domains unless explicitly requested.

2. **Time-bounded collection** - Limit collection to the most recent 24-48 hours of content. Older items are only relevant if referenced in current coverage.

3. **Relevance gating** - Apply strict relevance heuristics before opening detail pages. Skip lifestyle, sports, entertainment, and general non-finance content.

4. **Depth limit** - Only navigate one level deep: list page → article detail page. Do not follow related article links or comment sections.

5. **Google search as discovery fallback** - When broader internet search is needed (e.g., to verify uncertain claims, find corroboration sources, or discover emerging finance topics), use Google via PinchTab as a pre-filter before opening sources. This prevents unbounded crawling while enabling targeted discovery.

## Multi-Step Todo List

When executing this skill, follow this sequential workflow:

0. **[ ] Detect user language**
   - Extract user message text from chat context
   - Clean and preprocess input (remove code blocks, URLs, technical terms)
   - Detect primary language (Vietnamese, English, Chinese)
   - Calculate confidence score
   - Store detected language for use in summarization

1. **[ ] Initialize parallel PinchTab instances**
   - Start multiple PinchTab servers on different ports
   - Configure profiles for each source type (Vietnamese, global, social, economic-calendar)

2. **[ ] Ingest RSS feeds**
    - Fetch RSS feeds from official economic data sources using `curl`
    - Parse RSS XML/JSON format and extract items with titles, links, descriptions, and publication dates
    - **Validate and normalize timestamps**: Extract `published_at`, parse to UTC, apply recency filtering (48 hours max, 72 hours for official data)
    - Skip items without valid timestamps or exceeding max age
    - Apply relevance filtering to RSS items
    - Store RSS items for deduplication and analysis
    - Track which sources have successfully fetched RSS feeds (Reuters, Bloomberg, FT, CNBC, Trading Economics calendar)

3. **[ ] Scrape economic calendar from Investing.com**
   - Navigate to https://investing.com/economic-calendar using PinchTab
   - Extract upcoming economic events with dates, times, countries, indicators, actual/forecast/previous values
   - Apply relevance filtering (focus on high-impact events)
   - Store calendar events for analysis
   - **Note**: Investing.com does not provide RSS feeds for economic calendar - must be scraped via PinchTab

4. **[ ] Scrape Vietnamese news sources**
    - Navigate to each Vietnamese source's finance section
    - Extract list items with timestamps
    - **Validate and normalize timestamps**: Extract `published_at`, parse to UTC (assume Asia/Ho_Chi_Minh timezone), apply 48-hour max age
    - Skip items without valid timestamps or exceeding max age
    - Perform relevance checks
    - Fetch detail pages for relevant items only

5. **[ ] Scrape global news sources**
    - **Skip website crawling for sources with successful RSS feeds** (Reuters, Bloomberg, FT, CNBC)
    - For remaining global sources, navigate to finance/markets section
    - Extract list items with timestamps
    - **Validate and normalize timestamps**: Extract `published_at`, parse to UTC (use source's local timezone), apply 48-hour max age
    - Skip items without valid timestamps or exceeding max age
    - Perform relevance checks
    - Fetch detail pages for relevant items only

6. **[ ] Track social media rumors**
    - Monitor specified Twitter/X accounts for finance-related posts
    - Extract post content, timestamps, and engagement metrics
    - **Validate and normalize timestamps**: Extract `published_at`, parse to UTC, apply 24-hour max age
    - Skip posts without valid timestamps or exceeding max age
    - Apply relevance heuristics for rumor detection

7. **[ ] Perform Google search discovery (when needed)**
    - Use PinchTab to navigate to google.com
    - Search for specific finance topics, company names, or market events
    - Pre-filter results using search snippets before opening sources
    - **Validate timestamps**: Check publication dates in search results, apply 48-hour max age
    - Skip results without valid timestamps or exceeding max age
    - Only open sources that appear relevant and credible
    - Apply deduplication and credibility checks to discovered items

8. **[ ] Apply credibility verification**
   - Apply fake news/parody detection rules to all items
   - Classify items as credible, uncertain, or parody/fake
   - Discard parody/fake items, mark uncertain items for corroboration

9. **[ ] Apply deduplication**
   - Normalize URLs and titles across all sources (including RSS and calendar)
   - Remove duplicates using primary and secondary keys
   - Track cross-source duplicates (RSS vs. web vs. social vs. calendar)

10. **[ ] Generate summaries and analysis**
     - Apply language enforcement: Use detected user language for all summaries
     - Add explicit language instruction to summarization prompts
     - Summarize each relevant article, RSS item, social post, and calendar event
     - Extract key facts, entities, and sentiment
     - Assess market impact and identify themes
     - Highlight upcoming high-impact economic events
     - Verify summary language matches user input language
     - Handle language mismatches (retry with stronger prompt or translate)

11. **[ ] Compile final output**
    - Aggregate all items into the JSON schema
    - Generate market themes, risk flags, and sector trends
    - Include economic calendar summary with upcoming events
    - Verify completion criteria are met

## Core Requirements

1. **Parallel scraping**
   - Run separate PinchTab servers on multiple ports and process sources in parallel.
   - Use a concurrency gate to limit per-source in-flight requests (avoid bans).

2. **RSS feed ingestion**
   - Fetch RSS feeds from official economic data sources in parallel using `curl`.
   - Parse RSS XML/JSON format and extract items with metadata.
   - Apply relevance filtering to RSS items before processing.
   - RSS items are treated as high-priority sources (official data releases).
   - Trading Economics RSS includes economic calendar items.

3. **Economic calendar scraping**
   - Scrape Investing.com economic calendar using PinchTab (no RSS available).
   - Extract upcoming economic events with dates, times, countries, indicators, and values.
   - Focus on high-impact events (interest rate decisions, GDP releases, employment data, inflation reports).
   - Trading Economics calendar can be ingested via RSS feed.

3. **Avoid duplicated news details**
   - Normalize URLs, then dedupe by `canonical_url`.
   - Secondary dedupe: `source + title_normalized + published_date`.
   - Cross-source deduplication: RSS items may duplicate web articles.
   - Do **not** re-fetch detail pages for known items.
   - **RSS overrides website crawling**: If an RSS feed is successfully fetched for a source, skip crawling that source's website to avoid duplicates. This applies to Reuters, Bloomberg, FT, and CNBC.

4. **Selective subpage verification**
   - Only open the article detail page **if the item is likely finance-related**.
   - Use a quick relevance check from list snippet text and category labels.
   - Ignore "noise" items: unrelated lifestyle, sports, entertainment, general non-finance.
   - If uncertain, open detail page and re-classify using full text.
   - RSS items with official data releases are always considered relevant.

5. **Fake news & parody detection**
   - Apply critical-thinking rules to all items (both website and social).
   - RSS feeds from official sources are automatically classified as credible.
   - Classify items as credible, uncertain, or parody/fake.
   - Discard parody/fake items immediately with logged exclusion reason.
   - Mark uncertain items and require corroboration from additional sources.

6. **Social rumor tracking**
   - Monitor Twitter/X accounts for breaking finance news and rumors.
   - Apply relevance heuristics to identify potentially market-moving posts.
   - Track engagement metrics (likes, retweets, replies) as rumor intensity indicators.
   - Apply credibility verification to social posts (same rules as website articles).

## Output Schema (JSON)

```json
{
  "run_timestamp": "2026-03-04T09:34:00+07:00",
  "sources": {
    "vietnamese": ["vietstock", "vneconomy", "vietnamnet-kinh-doanh", "cafef"],
    "global": ["reuters", "ft", "bloomberg", "wsj", "cnbc"],
    "social": ["@Reuters", "@FT", "@AP", "@BBCWorld", "@BBCBreaking"],
    "rss": ["reuters-rss", "bloomberg-rss", "ft-rss", "cnbc-rss", "bls", "bea", "eurostat", "ons", "imf", "worldbank", "bis", "tradingeconomics-calendar"],
    "economic_calendar": ["investing-com", "tradingeconomics-rss"]
  },
  "items": [
    {
      "source": "vietstock|reuters|@Reuters|bls|bea|eurostat|ons|imf|worldbank|bis|tradingeconomics|investing-com-calendar",
      "source_type": "website|social|rss|calendar",
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
      "credibility": "credible|uncertain",
      "corroboration_sources": ["source1", "source2"],
      "social_metrics": {
        "likes": 0,
        "retweets": 0,
        "replies": 0,
        "rumor_intensity": "low|medium|high"
      }
    }
  ],
  "excluded_items": [
    {
      "source": "example.com|@ExampleAccount",
      "source_type": "website|social",
      "title": "...",
      "canonical_url": "https://...",
      "exclusion_reason": "parody|fake|duplicate|unrelated",
      "explanation": "..."
    }
  ],
  "economic_calendar": {
    "upcoming_events": [
      {
        "date": "2026-03-04",
        "time": "14:00",
        "country": "US",
        "indicator": "Non-Farm Payrolls",
        "actual": null,
        "forecast": "200K",
        "previous": "175K",
        "impact": "high",
        "source": "investing-com|tradingeconomics-rss"
      }
    ],
    "high_impact_events": ["Non-Farm Payrolls", "FOMC Rate Decision", "CPI Release"],
    "total_events": 25
  },
  "analysis": {
    "market_themes": ["..."],
    "risk_flags": ["..."],
    "sector_trends": [{"sector":"...","trend":"..."}],
    "rumor_alerts": ["..."],
    "upcoming_calendar_risks": ["..."]
  },
  "deduplication": {
    "total_items": 100,
    "unique_items": 85,
    "duplicates_removed": 15
  }
}
```

## Relevance Heuristics (List Page)

Treat as **likely finance-related** if list snippet contains:

- Finance signals: "lãi suất", "tỷ giá", "chứng khoán", "VN-Index", "trái phiếu", "ngân hàng", "tín dụng", "GDP", "CPI", "lạm phát", "FDI", "doanh nghiệp", "lợi nhuận", "doanh thu", "M&A", "IPO", "nợ xấu", "interest rate", "inflation", "stock market", "bond", "banking", "credit", "earnings", "revenue", "merger", "acquisition", "IPO", "default".
- Known finance categories/tags (if present): "Tài chính", "Ngân hàng", "Chứng khoán", "Kinh tế vĩ mô", "Doanh nghiệp", "Đầu tư", "Finance", "Banking", "Markets", "Economy", "Business", "Investing".

Treat as **noise** if list snippet or category contains:

- Lifestyle, sports, entertainment, travel, health, education, culture.

If uncertain → open detail page and re-classify using full text.

## Time Validation & Normalization

### Time Capture Requirements

**All items MUST capture `published_at` timestamp** in ISO 8601 format with timezone offset:

- **RSS feeds**: Extract `<pubDate>` or `<published>` element from RSS XML
- **Website articles**: Extract from article meta tags (`<meta property="article:published_time">`, `<time>` element, or article header)
- **Social posts**: Extract from post timestamp (Twitter/X `created_at`, similar for other platforms)
- **Economic calendar events**: Extract event date/time from calendar data

### Timezone Normalization

**All timestamps MUST be normalized to UTC** before processing:

1. Parse source timestamp with its original timezone
2. Convert to UTC using standard timezone conversion
3. Store in ISO 8601 format with `+00:00` or `Z` suffix
4. For items without explicit timezone, assume source's local timezone:
   - Vietnamese sources: Asia/Ho_Chi_Minh (UTC+7)
   - US sources: America/New_York (UTC-5/-4) or America/Chicago (UTC-6/-5)
   - European sources: Europe/London (UTC+0/+1) or Europe/Paris (UTC+1/+2)
   - Global sources: Use UTC if timezone cannot be determined

### Recency Filtering

**Apply strict recency checks to all sources**:

| Source Type | Max Age | Notes |
|-------------|---------|-------|
| RSS feeds (news) | 48 hours | Older items are stale |
| RSS feeds (official data) | 72 hours | Official data releases may be referenced longer |
| Website articles | 48 hours | Older articles are stale |
| Social posts | 24 hours | Social content has short relevance window |
| Economic calendar events | 7 days | Include upcoming events within 7 days |
| Google search results | 48 hours | Only recent search results |

### Stale Item Handling

**Skip items that exceed max age**:

1. Calculate age: `current_utc_time - published_at_utc`
2. If age > max_age for source type, skip item
3. Log skipped items with reason: `"stale: published_at exceeds max age"`
4. Exception: Items explicitly referenced in current coverage (e.g., background context for breaking news)

### Time Validation Rules

**Validate timestamps before processing**:

1. **Timestamp must be present**: Items without `published_at` are invalid
2. **Timestamp must be parseable**: Must be valid ISO 8601 or recognizable date format
3. **Timestamp must be in the past**: Future timestamps are invalid (except calendar events)
4. **Timestamp must be reasonable**: Reject obviously invalid dates (e.g., 1970, 2099)

### Source-Specific Time Checks

#### RSS Feeds

- Extract `<pubDate>` or `<published>` from RSS XML
- Parse RFC 2822 or ISO 8601 formats
- Normalize to UTC
- Apply 48-hour max age (72 hours for official data sources)
- Skip items without valid publication date

#### Website Scraping

- Extract from article meta tags in priority order:
  1. `<meta property="article:published_time">`
  2. `<meta name="date">`
  3. `<time datetime="...">` element
  4. Article header date text
- Parse and normalize to UTC
- Apply 48-hour max age
- Skip items without valid publication date

#### Social Posts

- Extract from post timestamp (Twitter/X `created_at`, etc.)
- Parse platform-specific timestamp format
- Normalize to UTC
- Apply 24-hour max age
- Skip posts without valid timestamp

#### Economic Calendar

- Extract event date and time from calendar data
- Parse and normalize to UTC
- Include events within next 7 days
- Past events are skipped (unless referenced in current coverage)

### Time Validation in Workflow

**Integrate time validation into the multi-step workflow**:

1. **RSS ingestion**: Validate timestamps immediately after parsing
2. **Website scraping**: Validate timestamps during list page extraction
3. **Social tracking**: Validate timestamps when extracting posts
4. **Calendar scraping**: Validate timestamps when extracting events
5. **Deduplication**: Use normalized UTC timestamps for secondary dedupe key
6. **Output**: Include `published_at` in ISO 8601 UTC format for all items

### Time Validation Failure Handling

| Failure Type | Action | Logging |
|--------------|--------|---------|
| Missing timestamp | Skip item | `"missing_published_at: no timestamp found"` |
| Unparseable timestamp | Skip item | `"invalid_timestamp: cannot parse timestamp"` |
| Future timestamp | Skip item | `"future_timestamp: timestamp is in the future"` |
| Stale item | Skip item | `"stale: published_at exceeds max age"` |
| Invalid date | Skip item | `"invalid_date: timestamp is not a valid date"` |

## Fake News & Parody Detection

### Critical-Thinking Rules

Apply these verification rules to **both website articles and social posts** before processing:

#### Red Flags (Indicates Potential Fake/Parody)

- **Source credibility issues**:
  - Unknown or unverified domain (not in trusted sources list)
  - Domain mimics legitimate sources with slight variations (e.g., `reuters-news.com` instead of `reuters.com`)
  - No "About Us" or editorial policy page
  - Excessive ads or clickbait formatting

- **Content warning signs**:
  - Sensationalist headlines with excessive punctuation (!!!, ???, ALL CAPS)
  - Claims without attribution or anonymous "sources say"
  - No byline or author information
  - Publication date missing or suspiciously old
  - Grammar, spelling, or formatting errors inconsistent with professional journalism

- **Parody indicators**:
  - Explicit satire labels: "Satire", "Parody", "Humor", "Opinion"
  - Domain names indicating satire: `theonion.com`, `babylonbee.com`, `clickhole.com`
  - Absurd or impossible claims presented as fact
  - Inconsistent tone mixing serious finance with humor

- **Social-specific red flags**:
  - Account with blue check mark but low follower count or recent creation
  - Post contains unverified claims without linking to sources
  - Excessive use of emojis or formatting inconsistent with professional accounts
  - Account bio indicates parody, satire, or personal opinion

#### Credibility Indicators (Supports Legitimacy)

- **Source credibility**:
  - Domain matches trusted sources list (Vietnamese: vietstock.vn, vneconomy.vn, vietnamnet.vn, cafef.vn; Global: reuters.com, ft.com, bloomberg.com, wsj.com, cnbc.com)
  - Verified social accounts with established presence
  - Clear editorial standards and corrections policy

- **Content quality**:
  - Named author with byline
  - Multiple sources cited or quoted
  - Data, statistics, or official statements referenced
  - Balanced presentation with multiple viewpoints
  - Clear publication timestamp

### Verification & Classification

Classify each item into one of three categories:

#### 1. Credible

**Criteria**: Source is trusted, content shows professional journalism standards, no red flags present.

**Action**: Process normally, include in output.

**Examples**:
- Article from reuters.com with named author, cited sources, clear timestamp
- Post from @Reuters with link to full article, professional tone

#### 2. Uncertain

**Criteria**: Some credibility indicators present but also some red flags, or source is unknown but content appears plausible.

**Action**: Mark with `credibility: "uncertain"`, require corroboration from exactly 2 credible sources before treating as verified.

**Examples**:
- Article from unknown domain but with named author and cited sources
- Social post from unverified account but referencing official statements
- Content with minor red flags but otherwise professional presentation

#### 3. Parody/Fake

**Criteria**: Clear parody indicators, multiple red flags, or content is demonstrably false/satirical.

**Action**: Discard immediately, do not include in output. Log reason for exclusion.

**Examples**:
- Article from theonion.com or similar satire sites
- Post explicitly labeled as satire or parody
- Content with absurd claims inconsistent with reality
- Domain mimicking legitimate source with slight variations

### Handling Rules

| Classification | Action | Output Inclusion |
|----------------|--------|------------------|
| Credible | Process normally | Yes |
| Uncertain | Mark `credibility: "uncertain"`, require corroboration from exactly 2 credible sources | Yes (with warning) |
| Parody/Fake | Discard, log reason | No |

### Corroboration Requirements for Uncertain Items

- **For website articles**: Find exactly 2 credible sources reporting the same information with similar details.
- **For social posts**: Verify against exactly 2 credible sources (official statements, press releases, or articles from trusted sources).
- **If corroboration fails**: Keep item marked as uncertain but note lack of verification in summary.

### Output Schema Updates

Add `credibility` field to each item:

```json
{
  "credibility": "credible|uncertain",
  "corroboration_sources": ["source1", "source2"],
  "exclusion_reason": "parody|fake|duplicate|unrelated"
}
```

- `credibility`: Required for all included items (default: "credible")
- `corroboration_sources`: List of sources that corroborated uncertain items
- `exclusion_reason`: Only for discarded items (logged separately)

## Social Rumor Tracking

### Target Accounts

Monitor the following Twitter/X accounts for finance-related rumors and breaking news:

- **@Reuters** - Global breaking news and financial updates
- **@FT** (Financial Times) - Market analysis and business news
- **@AP** (Associated Press) - Breaking news with economic impact
- **@BBCWorld** - International news with financial implications
- **@BBCBreaking** - Urgent breaking news affecting markets

### Rumor Detection Heuristics

Treat as **potential rumor** if post contains:

- Breaking news keywords: "BREAKING", "URGENT", "JUST IN", "DEVELOPING"
- Market-moving terms: "rate decision", "earnings surprise", "merger talks", "acquisition", "bankruptcy", "default", "sanctions", "regulation"
- Uncertainty indicators: "reportedly", "sources say", "rumored", "speculation", "may", "could"
- High engagement: >1000 likes or >500 retweets within 1 hour

### Social Deduplication Rules

1. **Normalize social post identifiers**:
   - Primary key: `source + post_id` (Twitter/X tweet ID)
   - Secondary key: `source + normalized_content + published_at`

2. **Cross-source deduplication**:
   - Match social posts to website articles by comparing normalized titles and content
   - If a social post references an article URL, use the article's canonical_url for deduplication

3. **Skip processing** if either key already exists.

## Google Search via PinchTab

When broader internet search is needed (e.g., to verify uncertain claims, find corroboration sources, or discover emerging finance topics), use Google as a pre-filter before opening sources:

### When to Use Google Search

- **Corroboration for uncertain items**: When an item is marked as "uncertain" and requires verification from additional sources.
- **Emerging topic discovery**: When tracking breaking news or market events that may not yet appear in predefined sources.
- **Cross-reference verification**: When validating claims across multiple sources beyond the whitelist.
- **Historical context**: When researching background information for current events.

### Google Search Workflow

1. **Navigate to Google**:
   ```bash
   curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
     -d '{"url":"https://www.google.com"}'
   ```

2. **Execute search query**:
   - Use specific, targeted queries with finance keywords
   - Include company names, tickers, or specific events
   - Add time filters (e.g., "past 24 hours") for recent content
   - Example: `"Vietnam interest rate decision site:reuters.com OR site:bloomberg.com"`

3. **Pre-filter using search snippets**:
   - Use `snapshot` and `text` to extract search results
   - Analyze snippets for relevance before opening any links
   - Check source domain credibility (prefer trusted domains)
   - Look for publication dates to ensure recency

4. **Selective source opening**:
   - Only open sources that pass pre-filtering
   - Prioritize trusted domains (reuters.com, ft.com, bloomberg.com, wsj.com, cnbc.com)
   - Limit to top 5-10 most relevant results per query
   - Apply the same relevance heuristics used for predefined sources

5. **Apply deduplication and credibility checks**:
   - Normalize URLs from Google results
   - Check against existing deduplication keys
   - Apply fake news/parody detection rules
   - Classify as credible/uncertain/parody/fake

### Search Query Best Practices

- **Be specific**: Use exact phrases in quotes for precise results
- **Filter by domain**: Use `site:` operator to target trusted sources
- **Time-bound**: Use date filters or include time keywords
- **Finance-focused**: Include finance terms like "stock", "market", "earnings", "IPO", "merger"
- **Vietnamese context**: Include Vietnamese terms when searching for local content

### Integration with Existing Workflow

- Google search results are treated as additional sources alongside Vietnamese, global, and social sources
- Deduplication applies across all sources including Google-discovered items
- Credibility verification is mandatory for all Google-discovered content
- Google search is optional—only use when predefined sources are insufficient

## PinchTab Parallel Flow

1. Start exactly 4 servers (max parallelism enforced):

```bash
pinchtab --port 9867
pinchtab --port 9868
pinchtab --port 9869
pinchtab --port 9870
```

2. Assign each source to its own server/instance. Process in parallel with a small per-source concurrency (1–2 tabs). Maximum of 4 parallel instances allowed.

3. For each source:
    - Navigate to the main finance section page or social profile.
    - Use `snapshot` and `text` to extract list items or posts.
    - **Extract and validate timestamps**: Capture `published_at` from each item/post
    - **Normalize to UTC**: Convert timestamps to UTC timezone
    - **Apply recency filtering**: Skip items exceeding max age (48h for web, 24h for social)
    - Perform relevance check on list items/posts.
    - Apply credibility verification (see Fake News & Parody Detection section).
    - Only open detail pages for likely relevant and credible/uncertain items.

## Economic Calendar Sources

### Investing.com Economic Calendar (PinchTab Scraping)

**Important**: Investing.com does **not** provide RSS feeds for economic calendar data. Must be scraped using PinchTab.

| Source | URL | Method | Description |
|--------|-----|--------|-------------|
| Investing.com | https://investing.com/economic-calendar | PinchTab scraping | Comprehensive economic calendar with global events, impact ratings, and actual/forecast/previous values |

### Investing.com Calendar Scraping Workflow

1. **Navigate to calendar page**:
   ```bash
   curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
     -d '{"url":"https://investing.com/economic-calendar"}'
   ```

2. **Extract calendar events**:
   - Use `snapshot` and `text` to extract event rows
   - Parse date, time, country, indicator, actual, forecast, previous values
   - Identify impact level (low, medium, high) from visual indicators

3. **Apply relevance filtering**:
   - Focus on high-impact events (interest rate decisions, GDP, employment, inflation)
   - Include medium-impact events for major economies (US, EU, UK, China, Japan)
   - Filter by time range (next 24-48 hours for immediate relevance)

4. **Store calendar events**:
   - Add to `economic_calendar.upcoming_events` in output schema
   - Track source as `investing-com-calendar`
   - Mark high-impact events for special attention in analysis

### Trading Economics Economic Calendar (RSS)

**Note**: Trading Economics provides RSS feeds for economic calendar data.

| Source | RSS URL | Description |
|--------|---------|-------------|
| Trading Economics Calendar | https://tradingeconomics.com/calendar.rss | Economic calendar events with indicators and forecasts |

### Trading Economics Calendar RSS Ingestion

1. **Fetch calendar RSS feed**:
   ```bash
   curl -s --max-time 30 --retry 3 "https://tradingeconomics.com/calendar.rss"
   ```

2. **Parse calendar items**:
   - Extract event date, time, country, indicator, actual, forecast, previous values
   - Parse impact level from item metadata

3. **Apply relevance filtering**:
   - Same criteria as Investing.com calendar
   - Focus on high-impact events for major economies

4. **Store calendar events**:
   - Add to `economic_calendar.upcoming_events` in output schema
   - Track source as `tradingeconomics-rss`
   - Deduplicate against Investing.com events (same indicator + date + country)

### Calendar Event Relevance Rules

**High-impact events** (always include):
- Central bank rate decisions (FOMC, ECB, BOE, BOJ, etc.)
- Employment reports (US Non-Farm Payrolls, ADP, unemployment rate)
- Inflation data (CPI, PPI, core measures)
- GDP releases (advance, preliminary, final)
- PMI reports (manufacturing, services)
- Retail sales
- Trade balance
- Consumer confidence

**Medium-impact events** (include for major economies):
- Housing data (building permits, housing starts)
- Industrial production
- Durable goods orders
- Wholesale inventories
- Business confidence surveys

**Low-impact events** (optional):
- Minor economic indicators
- Secondary data releases
- Regional economic reports

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

### RSS Ingestion Workflow

1. **Fetch RSS feeds in parallel using curl**:
   - Use `curl` to fetch all RSS feeds simultaneously
   - Implement timeout and retry logic for failed requests
   - Parse RSS XML/JSON format to extract items

   ```bash
   # Example: Fetch a single RSS feed
   curl -s --max-time 30 --retry 3 "https://www.bls.gov/rss/releases.xml"
   
   # Example: Fetch multiple feeds in parallel (using background jobs)
   curl -s --max-time 30 --retry 3 "https://www.bls.gov/rss/releases.xml" > bls.xml &
   curl -s --max-time 30 --retry 3 "https://www.bea.gov/rss/rss.xml" > bea.xml &
   curl -s --max-time 30 --retry 3 "https://ec.europa.eu/eurostat/en/web/rss" > eurostat.xml &
   wait
   ```

2. **Extract RSS item metadata**:
    - Title, link (canonical URL), description, publication date
    - **Validate and normalize `published_at`**: Parse to UTC, apply recency filtering
    - Source identifier (feed name)
    - Categories/tags (if available)

3. **Apply relevance filtering to RSS items**:
   - Official economic data releases (BLS, BEA, Eurostat, ONS, IMF, World Bank, BIS) are always relevant
   - Financial news RSS items (Reuters, Bloomberg, FT, CNBC) use the same relevance heuristics as web scraping
   - Trading Economics calendar RSS items use calendar event relevance rules (see Economic Calendar Sources section)

4. **Store RSS items for processing**:
   - Add to the items pool with `source_type: "rss"`
   - Mark official data releases as `credibility: "credible"` automatically
   - Apply deduplication rules against web, social, and calendar sources

### RSS Relevance Heuristics

For financial news RSS feeds (Reuters, Bloomberg, FT, CNBC), apply the same relevance heuristics as web scraping:

**Finance signals**: "interest rate", "inflation", "stock market", "bond", "banking", "credit", "earnings", "revenue", "merger", "acquisition", "IPO", "default", "GDP", "CPI", "FX", "rates", "lãi suất", "tỷ giá", "chứng khoán", "VN-Index", "trái phiếu", "ngân hàng", "tín dụng", "FDI", "doanh nghiệp", "lợi nhuận", "doanh thu", "M&A", "nợ xấu"

**Official data releases** (BLS, BEA, Eurostat, ONS, IMF, World Bank, BIS) are always considered relevant as they contain authoritative economic indicators.

**Trading Economics calendar RSS items** follow the calendar event relevance rules defined in the Economic Calendar Sources section.

## Deduplication Rules

1. Normalize URL:
   - Strip URL fragments and tracking params (`utm_*`, `fbclid`, `gclid`).
   - Convert to lowercase host.

2. Dedupe keys:
   - Primary: `canonical_url` (for websites and RSS) or `source + post_id` (for social) or `source + indicator + date + country` (for calendar events)
   - Secondary: `source + normalized_title + published_date` (for websites and RSS) or `source + normalized_content + published_at` (for social) or `source + indicator + date` (for calendar events)

3. Cross-source matching:
   - Compare normalized titles across Vietnamese, global, RSS, social, and calendar sources
   - Match articles referenced in social posts to their canonical URLs
   - RSS items may duplicate web articles - use canonical URL for matching
   - Calendar events from Investing.com and Trading Economics RSS may duplicate - dedupe by indicator + date + country

4. Skip detail fetch if either key already exists.

5. **RSS override rule**: If an RSS feed is successfully fetched for a source (Reuters, Bloomberg, FT, CNBC), skip crawling that source's website entirely. RSS items are treated as the primary source for these domains to avoid duplicate processing.

## Detail Page Extraction

- Capture full title, publish time, and body.
- **Validate and normalize `published_at`**: Parse to UTC, confirm within max age
- Re-run relevance check with full text.
- Apply credibility verification (see Fake News & Parody Detection section).
- If **not related** or **parody/fake**, discard item and log exclusion reason.
- If related and credible/uncertain, summarize and extract entities.
- For uncertain items, attempt corroboration from exactly 2 credible sources.

## Summarization & Analysis Guidelines

- Summaries must be concise (2–4 sentences).
- Extract key facts: numbers, dates, rates, percentages, and named entities.
- Sentiment: evaluate tone toward markets/economy.
- Market impact: assess probable effect on markets (low/medium/high).
- Credibility: classify as "credible" or "uncertain" based on verification rules.
- For uncertain items: note lack of corroboration in summary.
- For social posts: assess rumor credibility and potential market impact.

## Language Enforcement for Output Summaries

All summaries and analysis output MUST match the language of the user's chat input. This ensures consistent communication and user experience.

### Language Detection

Before generating any summaries, detect the user's input language from their chat message:

1. **Extract user message text** from the chat context
2. **Clean and preprocess** the input (remove code blocks, URLs, technical terms)
3. **Detect primary language** using language detection patterns:
   - **Vietnamese (vi)**: Check for Vietnamese diacritics (à, á, ạ, ả, ã, â, ầ, ấ, ậ, ẩ, ẫ, ă, ằ, ắ, ặ, ẳ, ẵ, đ) and common Vietnamese words (tôi, bạn, cảm ơn, được, không, có, v.v.)
   - **English (en)**: Default for Latin script without Vietnamese diacritics
   - **Chinese (zh)**: Check for Hanzi characters ([\u4e00-\u9fff])
4. **Calculate confidence score** based on text length and detection certainty

### Language Injection in Summarization

When generating summaries and analysis, enforce the detected language:

1. **Add explicit language instruction** to the summarization prompt:
   - Vietnamese: "Bạn PHẢI viết tóm tắt bằng TIẾNG VIỆT. Không được sử dụng ngôn ngữ nào khác."
   - English: "You must write summaries in English only."
   - Chinese: "你必须用中文写摘要。"

2. **Include language context** in the summarization request:
   - Prefix the prompt with language indicator: `[TIẾNG VIỆT]`, `[English]`, or `[中文]`

3. **Set language-specific parameters** for AI models when available

### Response Verification

After generating summaries, verify the language matches the user's input:

1. **Detect summary language** using the same detection patterns
2. **Compare with input language**:
   - Match: Language codes are identical (en=en, vi=vi, zh=zh)
   - Mismatch: Different language codes detected
3. **Calculate match confidence** based on detection certainty
4. **Handle mismatches**:
   - **Retry with stronger prompt**: Re-generate summary with explicit language enforcement
   - **Translate on-the-fly**: Translate the summary to the target language
   - **Accept with warning**: Include a language warning if retry fails

### Language-Specific Summary Guidelines

#### Vietnamese Summaries

- Use Vietnamese diacritics correctly (tone marks: à, á, ạ, ả, ã, etc.)
- Use Vietnamese financial terminology:
  - "lãi suất" (interest rate), "tỷ giá" (exchange rate), "chứng khoán" (stock market)
  - "VN-Index", "trái phiếu" (bonds), "ngân hàng" (banking), "tín dụng" (credit)
  - "lạm phát" (inflation), "GDP", "FDI", "doanh nghiệp" (enterprise), "lợi nhuận" (profit)
- Maintain Vietnamese grammatical structure and sentence patterns

#### English Summaries

- Use standard English financial terminology
- Maintain professional business writing style
- Use proper capitalization and punctuation

#### Chinese Summaries

- Use Simplified Chinese characters by default
- Use Chinese financial terminology:
  - "利率" (interest rate), "汇率" (exchange rate), "股票市场" (stock market)
  - "债券" (bonds), "银行" (banking), "信贷" (credit)
  - "通货膨胀" (inflation), "GDP", "企业" (enterprise), "利润" (profit)

### Language Enforcement in Workflow

Integrate language enforcement into the summarization workflow:

1. **Detect user language** at the start of the task (before any scraping)
2. **Store detected language** in the output schema under `analysis.language`
3. **Apply language instruction** when generating each summary
4. **Verify summary language** after generation
5. **Handle mismatches** using retry or translation strategies
6. **Include language metadata** in final output

### Output Schema Extension

Add language metadata to the output schema:

```json
{
  "analysis": {
    "language": {
      "detected": "vi|en|zh",
      "language_name": "Vietnamese|English|Chinese",
      "confidence": 0.95,
      "verified": true
    },
    "market_themes": ["..."],
    "risk_flags": ["..."],
    "sector_trends": [{"sector":"...","trend":"..."}],
    "rumor_alerts": ["..."],
    "upcoming_calendar_risks": ["..."]
  }
}
```

## Minimal HTTP API Examples

```bash
INSTANCE_ID=$(curl -s -X POST http://localhost:9867/instances -d '{"profile":"vietstock"}' | jq -r '.id')
TAB_ID=$(curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs" | jq -r '.id')
curl -s -X POST "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://vietstock.vn/chung-khoan.htm"}'
curl -s "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/snapshot?filter=interactive"
curl -s "http://localhost:9867/instances/$INSTANCE_ID/tabs/$TAB_ID/text"
```

## Error Handling

- Retry navigation or snapshot up to 3 times with jittered backoff.
- If the list page fails, skip source and continue others.
- If a detail page fails, keep the list item but mark `summary` as empty and `market_impact` as `low`.
- If social API rate limit is hit, implement exponential backoff and retry.

## Completion Criteria

- **Language enforcement requirements**:
  - User language detected from chat context with confidence score
  - All summaries generated in the detected user language
  - Summary language verified against user input language
  - Language metadata included in output schema (`analysis.language`)
  - Language mismatches handled (retried or translated) with logged reason

- At least one finance-related item from each Vietnamese source **or** a logged reason for absence.
- At least one finance-related item from each global source **or** a logged reason for absence.
  - **Note**: For Reuters, Bloomberg, FT, and CNBC, successful RSS feed ingestion satisfies this requirement—website crawling is skipped if RSS is available.
- At least one relevant post from each social account **or** a logged reason for absence.
- RSS feeds successfully fetched and parsed using `curl` **or** a logged reason for failure.
- At least one relevant item from each RSS feed **or** a logged reason for absence.
- Economic calendar data successfully collected:
  - Investing.com calendar scraped via PinchTab **or** a logged reason for failure.
  - Trading Economics calendar RSS fetched via `curl` **or** a logged reason for failure.
  - At least one high-impact economic event included in output **or** a logged reason for absence.
- **Time validation requirements**:
  - All items MUST have valid `published_at` timestamp in ISO 8601 UTC format
  - All timestamps MUST be normalized to UTC before processing
  - Items without valid timestamps MUST be skipped with logged reason
  - Items exceeding max age MUST be skipped with logged reason:
    - RSS news items: 48 hours
    - RSS official data: 72 hours
    - Website articles: 48 hours
    - Social posts: 24 hours
    - Economic calendar events: 7 days (upcoming only)
    - Google search results: 48 hours
- No duplicates across Vietnamese, global, RSS, social, and calendar sources.
- Only relevant detail pages fetched.
- All items classified by credibility (credible/uncertain/parody/fake).
- RSS items from official sources (BLS, BEA, Eurostat, ONS, IMF, World Bank, BIS) automatically classified as credible.
- Parody/fake items excluded with logged reasons.
- Uncertain items marked and corroboration attempted from exactly 2 credible sources.
- Deduplication statistics included in output.
- Rumor alerts generated for high-impact social posts.
- Economic calendar summary included in output with upcoming high-impact events.
- Calendar events deduplicated between Investing.com and Trading Economics RSS.
- Time validation statistics included in output (total items, valid timestamps, skipped due to missing/invalid/stale timestamps).
