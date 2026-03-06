# Data Deduplication Framework

## Overview

Data deduplication removes duplicate content across multiple sources (website articles, RSS feeds, social posts, and calendar events). This module normalizes URLs and titles, applies primary and secondary deduplication keys, and tracks cross-source duplicates to ensure unique content in the final output.

## Deduplication Scope

Apply deduplication across all source types:
- **Website articles**: Vietnamese and global news sources
- **RSS items**: Financial news and official data feeds
- **Social posts**: Twitter/X posts from monitored accounts
- **Calendar events**: Economic calendar entries

## URL Normalization

### Normalization Rules

Apply the following transformations to normalize URLs:

1. **Remove tracking parameters**:
   - `?utm_source=...`, `?utm_medium=...`, `?utm_campaign=...`
   - `?fbclid=...`, `?gclid=...`
   - `?ref=...`, `?source=...`

2. **Remove hash fragments**:
   - `#comments`, `#related`, `#share`

3. **Normalize protocol**:
   - Convert `http://` to `https://`

4. **Remove trailing slashes**:
   - `example.com/article/` → `example.com/article`

5. **Normalize www prefix**:
   - `www.example.com` → `example.com` (or vice versa, be consistent)

6. **Decode URL-encoded characters**:
   - `%20` → space, `%2F` → `/`

### URL Normalization Implementation

```javascript
const normalizeUrl = (url) => {
  try {
    const parsed = new URL(url);
    
    // Remove tracking parameters
    const trackingParams = ['utm_source', 'utm_medium', 'utm_campaign', 'fbclid', 'gclid', 'ref', 'source'];
    trackingParams.forEach(param => parsed.searchParams.delete(param));
    
    // Remove hash fragment
    parsed.hash = '';
    
    // Normalize protocol
    parsed.protocol = 'https:';
    
    // Remove www prefix
    parsed.hostname = parsed.hostname.replace(/^www\./, '');
    
    // Remove trailing slash from pathname
    parsed.pathname = parsed.pathname.replace(/\/$/, '');
    
    return parsed.toString();
  } catch (e) {
    return url; // Return original if parsing fails
  }
};
```

### Canonical URL Extraction

Extract canonical URL from article pages:
1. Check `<link rel="canonical">` tag
2. Check `og:url` meta tag
3. Use the page URL if no canonical found

```javascript
const extractCanonicalUrl = (page) => {
  // Priority 1: Canonical link
  const canonical = page.querySelector('link[rel="canonical"]');
  if (canonical) return canonical.href;
  
  // Priority 2: Open Graph URL
  const ogUrl = page.querySelector('meta[property="og:url"]');
  if (ogUrl) return ogUrl.content;
  
  // Fallback: Page URL
  return page.url;
};
```

## Deduplication Keys

### Primary Key: Canonical URL

The primary deduplication key is the normalized canonical URL:

```
dedupe_key_primary = normalize_url(canonical_url)
```

**When to use:**
- Same article from same source
- Same article accessed via different URLs (redirects, tracking parameters)
- RSS item linking to website article

### Secondary Key: Source + Title + Date

The secondary deduplication key combines source, normalized title, and publication date:

```
dedupe_key_secondary = source + normalize_title(title) + published_date
```

**When to use:**
- Cross-source duplicates (same article syndicated across sources)
- Articles without canonical URLs
- Social posts referencing articles

### Title Normalization

Apply the following transformations to normalize titles:

```javascript
const normalizeTitle = (title) => {
  return title
    .toLowerCase()
    .replace(/[^\w\s]/g, '')  // Remove punctuation
    .replace(/\s+/g, ' ')      // Normalize whitespace
    .trim()
    .substring(0, 100);        // Truncate to first 100 chars
};
```

## Cross-Source Deduplication

### RSS vs Website

**RSS Override Rule**: If an RSS feed is successfully fetched for a source, skip crawling that source's website.

| Source | RSS Available | Action |
|--------|---------------|--------|
| Reuters | Yes | Skip website crawling |
| Bloomberg | Yes | Skip website crawling |
| Financial Times | Yes | Skip website crawling |
| CNBC | Yes | Skip website crawling |
| WSJ | No | Crawl website |

### RSS vs Social

Match RSS items to social posts:
1. Compare normalized titles
2. Check if social post links to RSS article URL
3. Use RSS item as primary source (more complete data)

### Website vs Social

Match website articles to social posts:
1. Compare normalized titles
2. Check if social post links to article URL
3. Use website article as primary source (full content)

### Calendar Cross-Source

Deduplicate calendar events across sources:
1. **Primary key**: `indicator + date + country`
2. **Secondary key**: `normalized_indicator_name + date`
3. Prefer Investing.com for comprehensive data
4. Prefer Trading Economics RSS for speed

## Deduplication Workflow

### Step 1: Collect All Items

Gather items from all sources:
- Website articles
- RSS items
- Social posts
- Calendar events

### Step 2: Normalize URLs and Titles

Apply normalization to all items:
```javascript
items.forEach(item => {
  item.normalized_url = normalizeUrl(item.canonical_url);
  item.normalized_title = normalizeTitle(item.title);
});
```

### Step 3: Build Deduplication Registry

Create registry of seen items:
```javascript
const dedupeRegistry = {
  primaryKeys: new Set(),    // Normalized URLs
  secondaryKeys: new Set(),  // Source + title + date
  items: []                  // Unique items
};
```

### Step 4: Process Items

For each item:
1. Check primary key (normalized URL)
2. If not found, check secondary key
3. If neither found, add to unique items
4. Track duplicate statistics

```javascript
const processItem = (item, registry) => {
  const primaryKey = item.normalized_url;
  const secondaryKey = `${item.source}:${item.normalized_title}:${item.published_date}`;
  
  // Check primary key
  if (registry.primaryKeys.has(primaryKey)) {
    return { duplicate: true, key: primaryKey, type: 'primary' };
  }
  
  // Check secondary key
  if (registry.secondaryKeys.has(secondaryKey)) {
    return { duplicate: true, key: secondaryKey, type: 'secondary' };
  }
  
  // Add to registry
  registry.primaryKeys.add(primaryKey);
  registry.secondaryKeys.add(secondaryKey);
  registry.items.push(item);
  
  return { duplicate: false };
};
```

### Step 5: Track Statistics

```javascript
const deduplicationStats = {
  total_items: 100,
  unique_items: 85,
  duplicates_removed: 15,
  duplicates_by_type: {
    primary: 10,
    secondary: 5
  },
  duplicates_by_source: {
    rss_vs_web: 8,
    social_vs_web: 4,
    cross_source: 3
  }
};
```

## Social-Specific Deduplication

### Social Post Primary Key

For social posts, use platform-specific identifier:
```
dedupe_key_social = source + post_id
```

Example: `@Reuters:1234567890123456789`

### Social Post Secondary Key

```
dedupe_key_social_secondary = source + normalized_content + published_at
```

### Cross-Reference with Articles

1. Extract URLs from social post content
2. Normalize extracted URLs
3. Match against article deduplication keys
4. If match found, link social post to article

```javascript
const linkSocialToArticle = (socialPost, articles) => {
  const postUrls = extractUrls(socialPost.content);
  
  for (const url of postUrls) {
    const normalizedUrl = normalizeUrl(url);
    const matchingArticle = articles.find(a => 
      a.normalized_url === normalizedUrl
    );
    
    if (matchingArticle) {
      return {
        linked: true,
        article: matchingArticle,
        social_post: socialPost
      };
    }
  }
  
  return { linked: false };
};
```

## Calendar Event Deduplication

### Deduplication Keys

**Primary Key:**
```
dedupe_key_calendar = indicator + date + country
```

**Secondary Key:**
```
dedupe_key_calendar_secondary = normalized_indicator + date
```

### Indicator Name Normalization

Normalize economic indicator names:

| Original | Normalized |
|----------|------------|
| Non-Farm Payrolls | nonfarm_payrolls |
| NFP | nonfarm_payrolls |
| Nonfarm Employment | nonfarm_payrolls |
| CPI | consumer_price_index |
| Consumer Price Index | consumer_price_index |
| GDP | gross_domestic_product |
| Gross Domestic Product | gross_domestic_product |

```javascript
const normalizeIndicatorName = (name) => {
  const mappings = {
    'non-farm payrolls': 'nonfarm_payrolls',
    'nfp': 'nonfarm_payrolls',
    'nonfarm employment': 'nonfarm_payrolls',
    'cpi': 'consumer_price_index',
    'consumer price index': 'consumer_price_index',
    'gdp': 'gross_domestic_product',
    'gross domestic product': 'gross_domestic_product'
  };
  
  const normalized = name.toLowerCase().trim();
  return mappings[normalized] || normalized.replace(/\s+/g, '_');
};
```

## Output Schema

### Deduplication Statistics

```json
{
  "deduplication": {
    "total_items": 100,
    "unique_items": 85,
    "duplicates_removed": 15,
    "duplicates_by_type": {
      "primary": 10,
      "secondary": 5
    },
    "duplicates_by_source": {
      "rss_vs_web": 8,
      "social_vs_web": 4,
      "cross_source": 3
    },
    "sources_skipped": ["reuters", "bloomberg", "ft", "cnbc"],
    "skip_reason": "RSS feed successfully fetched"
  }
}
```

### Duplicate Item Tracking

```json
{
  "duplicate_items": [
    {
      "original_source": "reuters-rss",
      "original_url": "https://reuters.com/article/...",
      "duplicate_source": "@Reuters",
      "duplicate_url": "https://twitter.com/Reuters/status/...",
      "match_type": "url_match"
    }
  ]
}
```

## Integration with Other Modules

### News Aggregation Integration

- Receive extracted articles from news aggregation
- Apply URL normalization before processing
- Return unique articles for summarization

### RSS Ingestion Integration

- RSS items processed first (higher priority)
- RSS URLs added to deduplication registry
- Website crawling skipped for RSS-covered sources

### Social Tracking Integration

- Social posts checked against article registry
- Social posts linked to matching articles
- Standalone social posts added to unique items

### Economic Calendar Integration

- Calendar events deduplicated across sources
- Indicator names normalized before comparison
- Calendar events kept separate from news items

## Performance Considerations

### Memory Efficiency

- Use Sets for deduplication keys (O(1) lookup)
- Limit registry size for long-running sessions
- Clear registry after each processing cycle

### Processing Order

Process sources in priority order:
1. RSS feeds (highest priority - official sources)
2. Website articles (secondary priority)
3. Social posts (link to existing articles when possible)
4. Calendar events (separate deduplication)

### Batch Processing

For large volumes:
- Process items in batches of 100-500
- Flush registry periodically
- Track statistics per batch

## Vietnamese Source Deduplication Logic

### Vietnamese URL Normalization

Additional normalization rules for Vietnamese domains:

1. **Vietnamese domain variants**:
   - Handle Vietnamese domain endings (.vn, .com.vn, .net.vn)
   - Normalize Vietnamese subdomains (tin, kinhdoanh, chungkhoan)

2. **Vietnamese content parameters**:
   - Remove Vietnamese tracking parameters (utm_source=vn, source=vn)
   - Handle Vietnamese language parameters (?lang=vi, ?lang=vn)

```javascript
const normalizeVietnameseUrl = (url) => {
  let normalized = normalizeUrl(url); // Apply standard normalization
  
  try {
    const parsed = new URL(normalized);
    
    // Handle Vietnamese domain variants
    parsed.hostname = parsed.hostname.replace(/\.com\.vn$/, '.vn');
    parsed.hostname = parsed.hostname.replace(/\.net\.vn$/, '.vn');
    
    // Remove Vietnamese-specific parameters
    const vietnameseParams = ['lang', 'utm_source_vn', 'source_vn', 'region'];
    vietnameseParams.forEach(param => parsed.searchParams.delete(param));
    
    return parsed.toString();
  } catch (e) {
    return normalized; // Return standard normalized if Vietnamese parsing fails
  }
};
```

### Vietnamese Title Normalization

Apply Vietnamese-specific transformations to normalize titles:

```javascript
const normalizeVietnameseTitle = (title) => {
  // Standard normalization
  let normalized = normalizeTitle(title);
  
  // Vietnamese-specific transformations
  return normalized
    .toLowerCase()
    .replace(/[^\w\s\u0103\u00E2\u00EA\u00F4\u01A1\u01B0]/g, '')  // Remove punctuation, keep Vietnamese diacritics
    .replace(/\s+/g, ' ')      // Normalize whitespace
    .trim()
    .substring(0, 100);        // Truncate to first 100 chars
};
```

### Vietnamese Cross-Source Deduplication

**Vietnamese RSS vs Website**:

Currently, Vietnamese sources typically don't provide RSS feeds, so website crawling is the primary method.

**Vietnamese Website vs Social**:

Match Vietnamese articles to social posts:
1. Compare normalized Vietnamese titles
2. Check if Vietnamese social post links to article URL
3. Use Vietnamese website article as primary source (full content)

**Vietnamese Multi-Domain Deduplication**:

Some Vietnamese publishers use multiple domains:
- vietstock.vn and vietstock.com.vn (same publisher)
- cafef.vn and cafebiz.vn (same publisher group)

```javascript
const vietnameseDomainMappings = {
  'vietstock.com.vn': 'vietstock.vn',
  'cafebiz.vn': 'cafef.vn',
  'enternews.com.vn': 'enternews.vn'
};

const mapVietnameseDomains = (domain) => {
  return vietnameseDomainMappings[domain] || domain;
};
```

### Vietnamese Deduplication Workflow

For Vietnamese sources, apply these additional steps:

1. **Domain mapping**: Map Vietnamese domain variants to primary domains
2. **Vietnamese content normalization**: Apply Vietnamese-specific text processing
3. **Cross-domain matching**: Check for content syndication across Vietnamese domains
4. **Local language verification**: Ensure Vietnamese content is properly matched

```javascript
const processVietnameseItem = (item, registry) => {
  // Apply Vietnamese domain mapping
  const mappedDomain = mapVietnameseDomains(new URL(item.canonical_url).hostname);
  const mappedUrl = item.canonical_url.replace(new URL(item.canonical_url).hostname, mappedDomain);
  
  // Normalize Vietnamese URL and title
  const normalizedUrl = normalizeVietnameseUrl(mappedUrl);
  const normalizedTitle = normalizeVietnameseTitle(item.title);
  
  // Check primary key (normalized URL)
  if (registry.primaryKeys.has(normalizedUrl)) {
    return { duplicate: true, key: normalizedUrl, type: 'primary' };
  }
  
  // Check secondary key
  const secondaryKey = `${item.source}:${normalizedTitle}:${item.published_date}`;
  if (registry.secondaryKeys.has(secondaryKey)) {
    return { duplicate: true, key: secondaryKey, type: 'secondary' };
  }
  
  // Add to registry
  registry.primaryKeys.add(normalizedUrl);
  registry.secondaryKeys.add(secondaryKey);
  registry.items.push(item);
  
  return { duplicate: false };
};
```

### Vietnamese RSS Feed Deduplication

**Vietnamese RSS Sources:**

| Source | RSS URL | Deduplication Priority |
|--------|---------|----------------------|
| VietStock | https://vietstock.vn/rss | High |
| CafeF | https://cafef.vn/rss | High |
| GSO | https://www.gso.gov.vn/rss | Very High (official) |
| SBV | https://sbv.gov.vn/rss | Very High (official) |
| MPI | https://www.mpi.gov.vn/rss | Very High (official) |
| MOLISA | https://molisa.gov.vn/rss | Very High (official) |
| MOIT | https://moit.gov.vn/rss | Very High (official) |
| MARD | https://mard.gov.vn/rss | Very High (official) |
| MOC | https://moc.gov.vn/rss | Very High (official) |
| MOT | https://mt.gov.vn/rss | Very High (official) |
| SSC | https://www.ssc.gov.vn/rss | Very High (official) |
| MOF | https://mof.gov.vn/rss | Very High (official) |
| VSD | https://vsd.vn/rss | Very High (official) |
| VSE | https://vse.vn/rss | Very High (official) |
| ISA | https://isa.gov.vn/rss | Very High (official) |
| Vietnam Competition Authority | https://vietnamcompetition.gov.vn/rss | Very High (official) |

**Vietnamese RSS Override Rule:**

If a Vietnamese RSS feed is successfully fetched for a source, skip crawling that source's website.

| Source | RSS Available | Action |
|--------|---------------|--------|
| VietStock | Yes | Skip website crawling |
| CafeF | Yes | Skip website crawling |
| GSO | Yes | Skip website crawling |
| SBV | Yes | Skip website crawling |
| MPI | Yes | Skip website crawling |
| MOLISA | Yes | Skip website crawling |
| MOIT | Yes | Skip website crawling |
| MARD | Yes | Skip website crawling |
| MOC | Yes | Skip website crawling |
| MOT | Yes | Skip website crawling |
| SSC | Yes | Skip website crawling |
| MOF | Yes | Skip website crawling |
| VSD | Yes | Skip website crawling |
| VSE | Yes | Skip website crawling |
| ISA | Yes | Skip website crawling |
| Vietnam Competition Authority | Yes | Skip website crawling |
| VnEconomy | No | Crawl website |
| VietnamNet | No | Crawl website |
| Tinnhanhchungkhoan | No | Crawl website |
| VietnamFinance | No | Crawl website |
| EnterNews | No | Crawl website |
| TapChiTaiLieu | No | Crawl website |
| BloombergVN | No | Crawl website |
| TaiChinhDoanhNghiep | No | Crawl website |

### Vietnamese Calendar Event Deduplication

**Vietnamese Economic Calendar Sources:**

| Source | URL | Access Method | Priority |
|--------|-----|---------------|----------|
| DStock VNDIRECT | https://dstock.vndirect.com.vn | PinchTab scraping | High |
| GSO | https://www.gso.gov.vn | RSS + PinchTab scraping | Very High (official) |
| SBV | https://sbv.gov.vn | RSS + PinchTab scraping | Very High (official) |
| MPI | https://www.mpi.gov.vn | RSS + PinchTab scraping | Very High (official) |
| MOLISA | https://molisa.gov.vn | RSS + PinchTab scraping | Very High (official) |
| MOIT | https://moit.gov.vn | RSS + PinchTab scraping | Very High (official) |
| MARD | https://mard.gov.vn | RSS + PinchTab scraping | Very High (official) |
| MOC | https://moc.gov.vn | RSS + PinchTab scraping | Very High (official) |
| MOT | https://mt.gov.vn | RSS + PinchTab scraping | Very High (official) |

**Vietnamese Calendar Event Deduplication Keys:**

**Primary Key:**
```
dedupe_key_vietnamese_calendar = indicator + date + country
```

**Secondary Key:**
```
dedupe_key_vietnamese_calendar_secondary = normalized_indicator + date
```

**Vietnamese Indicator Name Normalization:**

| Original | Normalized |
|----------|------------|
| VN-Index | vn_index |
| VN30 | vn30 |
| HNX-Index | hnx_index |
| UPCoM | upcom |
| GDP Vietnam | gdp_vietnam |
| CPI Vietnam | cpi_vietnam |
| SBV Interest Rate | sbv_interest_rate |
| FDI Vietnam | fdi_vietnam |
| Vietnamese Export | vietnamese_export |
| Vietnamese Import | vietnamese_import |

```javascript
const normalizeVietnameseIndicator = (name) => {
  const mappings = {
    'vn-index': 'vn_index',
    'vn30': 'vn30',
    'hnx-index': 'hnx_index',
    'upcom': 'upcom',
    'gdp vietnam': 'gdp_vietnam',
    'cpi vietnam': 'cpi_vietnam',
    'sbv interest rate': 'sbv_interest_rate',
    'fdi vietnam': 'fdi_vietnam',
    'vietnamese export': 'vietnamese_export',
    'vietnamese import': 'vietnamese_import'
  };
  
  const normalized = name.toLowerCase().trim();
  return mappings[normalized] || normalized.replace(/\s+/g, '_');
};
```

### Vietnamese Social Media Deduplication

**Vietnamese Social Media Sources:**

| Platform | Account Type | Deduplication Method |
|----------|--------------|----------------------|
| Twitter/X | Vietnamese financial news accounts | Post ID + URL extraction |
| Facebook | Vietnamese official pages | Post ID + URL extraction |
| LinkedIn | Vietnamese company pages | Post ID + URL extraction |

**Vietnamese Social Post Primary Key:**

```
dedupe_key_vietnamese_social = source + post_id
```

**Vietnamese Social Post Secondary Key:**

```
dedupe_key_vietnamese_social_secondary = source + normalized_vietnamese_content + published_at
```

**Vietnamese Social Content Normalization:**

```javascript
const normalizeVietnameseSocialContent = (content) => {
  // Standard normalization
  let normalized = normalizeTitle(content);
  
  // Vietnamese-specific transformations
  return normalized
    .toLowerCase()
    .replace(/[^\w\s\u0103\u00E2\u00EA\u00F4\u01A1\u01B0]/g, '')  // Remove punctuation, keep Vietnamese diacritics
    .replace(/\s+/g, ' ')      // Normalize whitespace
    .trim()
    .substring(0, 100);        // Truncate to first 100 chars
};
```

### Vietnamese Cross-Source Deduplication Statistics

**Vietnamese Deduplication Output Schema:**

```json
{
  "vietnamese_deduplication": {
    "total_vietnamese_items": 100,
    "unique_vietnamese_items": 85,
    "vietnamese_duplicates_removed": 15,
    "vietnamese_duplicates_by_type": {
      "primary": 10,
      "secondary": 5
    },
    "vietnamese_duplicates_by_source": {
      "vietnamese_rss_vs_web": 8,
      "vietnamese_social_vs_web": 4,
      "vietnamese_cross_source": 3
    },
    "vietnamese_sources_skipped": ["vietstock", "cafef", "gso", "sbv", "mpi", "molisa", "moit", "mard", "moc", "mot", "ssc", "mof", "vsd", "vse", "isa", "vietnamcompetition"],
    "skip_reason": "Vietnamese RSS feed successfully fetched"
  }
}
```

**Vietnamese Duplicate Item Tracking:**

```json
{
  "vietnamese_duplicate_items": [
    {
      "original_source": "vietstock-rss",
      "original_url": "https://vietstock.vn/article/...",
      "duplicate_source": "vietstock-website",
      "duplicate_url": "https://vietstock.vn/article/...",
      "match_type": "url_match",
      "vietnamese_language": true
    }
  ]
}
```

### Vietnamese Deduplication Best Practices

1. **Prioritize Vietnamese official sources**: GSO, SBV, MPI, MOLISA, MOIT, MARD, MOC, MOT, SSC, MOF, VSD, VSE, ISA, Vietnam Competition Authority
2. **Use Vietnamese RSS feeds when available**: Skip website crawling for sources with RSS
3. **Apply Vietnamese domain mapping**: Handle Vietnamese domain variants (.vn, .com.vn, .net.vn)
4. **Normalize Vietnamese text**: Preserve Vietnamese diacritics while normalizing
5. **Track Vietnamese-specific duplicates**: Monitor Vietnamese cross-source duplication patterns
6. **Maintain Vietnamese deduplication statistics**: Track Vietnamese-specific deduplication metrics