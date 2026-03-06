# Social Media Tracking Framework

## Overview

Social media tracking monitors Twitter/X accounts for finance-related rumors and breaking news. This module extracts posts from major news outlets, applies rumor detection heuristics, and tracks engagement metrics as indicators of market-moving potential.

## Target Accounts

### Primary News Accounts

Monitor the following Twitter/X accounts for finance-related rumors and breaking news:

| Account | Handle | Focus Area | Verification |
|---------|--------|------------|--------------|
| Reuters | @Reuters | Global breaking news and financial updates | Verified |
| Financial Times | @FT | Market analysis and business news | Verified |
| Associated Press | @AP | Breaking news with economic impact | Verified |
| BBC World | @BBCWorld | International news with financial implications | Verified |
| BBC Breaking | @BBCBreaking | Urgent breaking news affecting markets | Verified |

### Account Credibility Tiers

| Tier | Accounts | Credibility | Notes |
|------|----------|-------------|-------|
| Tier 1 | @Reuters, @FT, @AP | Highest | Professional news organizations with editorial standards |
| Tier 2 | @BBCWorld, @BBCBreaking | High | Public broadcaster with verification protocols |
| Tier 3 | Other verified accounts | Medium | Requires corroboration from Tier 1-2 sources |

## Social Tracking Workflow

### Step 1: Navigate to Social Profile

Use PinchTab to navigate to Twitter/X profiles:

```bash
curl -s -X POST "http://localhost:9870/instances/$INSTANCE_ID/tabs/$TAB_ID/navigate" \
  -d '{"url":"https://twitter.com/Reuters"}'
```

### Step 2: Extract Posts

Use `snapshot` and `text` to extract posts:

```bash
curl -s -X POST "http://localhost:9870/instances/$INSTANCE_ID/tabs/$TAB_ID/snapshot"
curl -s -X POST "http://localhost:9870/instances/$INSTANCE_ID/tabs/$TAB_ID/text"
```

### Step 3: Extract Post Data

From each post, extract:
- `post_id`: Unique tweet ID
- `author`: Account handle
- `content`: Post text
- `published_at`: Post timestamp
- `likes`: Like count
- `retweets`: Retweet count
- `replies`: Reply count
- `links`: Any URLs in the post
- `hashtags`: Hashtags used

### Step 4: Validate and Normalize Timestamps

**Extract from post timestamp (Twitter/X `created_at`):**
- Parse platform-specific timestamp format
- Normalize to UTC timezone
- Apply 24-hour max age for social posts

**Timestamp Validation:**
1. Timestamp must be present - skip posts without timestamp
2. Timestamp must be parseable - skip posts with invalid formats
3. Timestamp must be in the past - skip future timestamps
4. Apply 24-hour max age - skip posts older than 24 hours

### Step 5: Apply Relevance Heuristics

**Treat as potential rumor if post contains:**

**Breaking News Keywords:**
- "BREAKING", "URGENT", "JUST IN", "DEVELOPING"
- "Exclusive", "SCOOP"

**Market-Moving Terms:**
- "rate decision", "earnings surprise", "merger talks"
- "acquisition", "bankruptcy", "default"
- "sanctions", "regulation", "investigation"
- "CEO", "resign", "stepping down"
- "layoffs", "job cuts", "restructuring"

**Uncertainty Indicators:**
- "reportedly", "sources say", "rumored"
- "speculation", "may", "could"
- "according to sources", "people familiar with"

### Step 6: Track Engagement Metrics

Calculate engagement metrics as rumor intensity indicators:

```json
{
  "social_metrics": {
    "likes": 1500,
    "retweets": 800,
    "replies": 250,
    "engagement_rate": 0.025,
    "rumor_intensity": "high"
  }
}
```

**Rumor Intensity Classification:**

| Metric | Low | Medium | High |
|--------|-----|--------|------|
| Likes | <500 | 500-1000 | >1000 |
| Retweets | <200 | 200-500 | >500 |
| Replies | <100 | 100-300 | >300 |
| Time to 1000 likes | >1 hour | 30min-1 hour | <30 min |

## Rumor Detection Heuristics

### High-Priority Rumor Indicators

Posts matching these criteria require immediate attention:

1. **Breaking news from Tier 1 accounts** with market-moving keywords
2. **High engagement** (>1000 likes or >500 retweets within 1 hour)
3. **Multiple uncertainty indicators** combined with specific company/asset mentions
4. **Links to official sources** (SEC filings, press releases, official statements)

### Medium-Priority Rumor Indicators

Posts matching these criteria require verification:

1. **Breaking news from Tier 2 accounts** with market-moving keywords
2. **Moderate engagement** (500-1000 likes within 1 hour)
3. **Single uncertainty indicator** with specific company/asset mentions
4. **Links to news articles** (not primary sources)

### Low-Priority Rumor Indicators

Posts matching these criteria are informational:

1. **General market commentary** without specific actionable information
2. **Low engagement** (<500 likes within 1 hour)
3. **Retweets or quotes** of already-processed content
4. **Opinion or analysis** rather than breaking news

## Social-Specific Credibility Rules

### Red Flags for Social Posts

- Account with blue check mark but low follower count or recent creation
- Post contains unverified claims without linking to sources
- Excessive use of emojis or formatting inconsistent with professional accounts
- Account bio indicates parody, satire, or personal opinion
- Post contains "Not financial advice" or similar disclaimers
- Mismatch between account name and handle (impersonation attempt)

### Credibility Indicators for Social Posts

- Verified account with established presence (>100K followers)
- Post links to official source or full article
- Professional tone consistent with account's typical content
- Multiple credible accounts posting similar information
- Official account badge or government/institution verification

## Cross-Reference Verification Protocols

### Verification Workflow

1. **Identify claim**: Extract the core claim from the social post
2. **Search for corroboration**: Check if 2 credible sources report the same information
3. **Check official sources**: Look for press releases, SEC filings, or official statements
4. **Timeline analysis**: Verify the social post is not simply echoing older news
5. **Source chain**: Trace the origin of the information

### Corroboration Requirements

| Claim Type | Required Corroboration |
|------------|------------------------|
| Breaking news | 2 credible news sources OR 1 official source |
| Earnings/financial data | Official press release or SEC filing |
| M&A/Rumors | 2 credible sources OR official confirmation |
| Regulatory action | Official government/regulatory source |
| Personnel changes | Company press release OR 2 credible sources |

### Verification Status

```json
{
  "verification_status": "verified|unverified|disputed",
  "corroboration_sources": ["reuters", "ft"],
  "official_source": "https://sec.gov/...",
  "verification_timestamp": "2026-03-04T09:30:00Z"
}
```

## Social Deduplication Rules

### Primary Deduplication Key

- `source + post_id` (Twitter/X tweet ID)

### Secondary Deduplication Key

- `source + normalized_content + published_at`

### Cross-Source Deduplication

1. **Match social posts to website articles**:
   - Compare normalized titles and content
   - If social post references article URL, use article's canonical_url

2. **Match social posts to RSS items**:
   - Compare normalized titles
   - Check for shared URLs

3. **Skip processing** if either key already exists in the deduplication registry

## Output Schema for Social Posts

```json
{
  "source": "@Reuters|@FT|@AP|@BBCWorld|@BBCBreaking",
  "source_type": "social",
  "title": "Post content (truncated if necessary)",
  "canonical_url": "https://twitter.com/Reuters/status/123456789",
  "published_at": "2026-03-04T08:40:00Z",
  "summary": "Post content or extracted claim",
  "key_facts": ["...", "..."],
  "entities": {
    "companies": ["..."],
    "tickers": ["..."],
    "macro": ["inflation", "GDP", "FX", "rates"]
  },
  "sentiment": "positive|neutral|negative",
  "market_impact": "low|medium|high",
  "topics": ["banking", "stocks", "mergers", "regulation"],
  "is_related": true,
  "credibility": "credible|uncertain",
  "verification_status": "verified|unverified|disputed",
  "corroboration_sources": ["source1", "source2"],
  "social_metrics": {
    "likes": 1500,
    "retweets": 800,
    "replies": 250,
    "rumor_intensity": "high"
  }
}
```

## Integration with Other Modules

- **Credibility Verification**: Apply fake news detection rules to all social posts
- **Data Deduplication**: Pass all posts through deduplication
- **Language Enforcement**: Use detected language for summaries
- **News Aggregation**: Cross-reference with website articles for verification

## Monitoring Schedule

### Real-Time Monitoring

For breaking news and high-impact events:
- Check target accounts every 15-30 minutes
- Flag posts with high engagement for immediate processing
- Alert on posts matching high-priority rumor indicators

### Periodic Monitoring

For general news and market updates:
- Check target accounts every 1-2 hours
- Process posts matching medium-priority rumor indicators
- Aggregate lower-priority content for batch processing

## Error Handling

| Error Type | Action | Retry |
|------------|--------|-------|
| Rate limit | Wait and retry | Exponential backoff |
| Account suspended | Log error, skip account | No retry |
| Login required | Skip platform, log warning | No retry |
| Network timeout | Retry request | Up to 3 times |
| Invalid response | Log error, skip post | No retry |