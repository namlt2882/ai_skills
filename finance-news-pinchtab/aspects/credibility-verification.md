# Credibility Verification Framework

## Overview

Credibility verification ensures content authenticity and reliability by applying critical-thinking rules to detect fake news, parody, and unreliable sources. This module classifies all items (website articles, RSS feeds, and social posts) into credibility categories with appropriate handling protocols.

## Verification Scope

Apply credibility verification to:
- **Website articles**: All scraped content from Vietnamese and global sources
- **RSS items**: All items from RSS feeds (though most are pre-classified as credible)
- **Social posts**: All posts from monitored Twitter/X accounts

## Red Flag Indicators

### Source Credibility Issues

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Unknown domain | Domain not in trusted sources list | High |
| Domain mimicry | Domain mimics legitimate sources with slight variations (e.g., `reuters-news.com` instead of `reuters.com`) | Critical |
| No editorial policy | Missing "About Us" or editorial policy page | Medium |
| Excessive ads/clickbait | Poor formatting, excessive advertising, clickbait headlines | Medium |
| Recent domain registration | Domain created recently (< 6 months) | Medium |
| WHOIS privacy | Hidden domain ownership information | Low |

### Content Warning Signs

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Sensationalist headlines | Excessive punctuation (!!!, ???, ALL CAPS) | High |
| No attribution | Claims without sources or anonymous "sources say" | High |
| Missing byline | No author information provided | Medium |
| No publication date | Missing or suspiciously old publication date | High |
| Poor grammar/spelling | Errors inconsistent with professional journalism | Medium |
| Emotional manipulation | Content designed to provoke strong emotional reactions | Medium |
| Absolute claims | Claims using "always", "never", "everyone", "no one" | Low |

### Parody Indicators

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Explicit satire labels | "Satire", "Parody", "Humor", "Opinion" labels | Critical |
| Known satire domains | `theonion.com`, `babylonbee.com`, `clickhole.com` | Critical |
| Absurd claims | Impossible or ridiculous claims presented as fact | Critical |
| Inconsistent tone | Mixing serious finance with humor | High |
| Exaggerated statistics | Numbers that are clearly fabricated or impossible | High |

### Social-Specific Red Flags

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Blue check with low followers | Verified account with <10K followers or recent creation | High |
| Unverified claims | Posts without linking to sources | Medium |
| Excessive emojis | Formatting inconsistent with professional accounts | Low |
| Parody bio | Account bio indicates parody, satire, or personal opinion | Critical |
| "Not financial advice" | Disclaimer indicating non-professional content | Medium |
| Handle/name mismatch | Impersonation attempt (different display name vs handle) | Critical |

## Credibility Indicators

### Source Credibility

| Indicator | Description | Weight |
|-----------|-------------|--------|
| Trusted domain | Domain matches trusted sources list | +3 |
| Verified social account | Account with established presence (>100K followers) | +2 |
| Clear editorial standards | Published corrections policy and editorial guidelines | +1 |
| Professional design | Clean, professional website design | +1 |

### Content Quality

| Indicator | Description | Weight |
|-----------|-------------|--------|
| Named author | Article has byline with author name | +1 |
| Multiple sources | Article cites or quotes multiple sources | +2 |
| Data/statistics | References official data or statistics | +2 |
| Balanced presentation | Multiple viewpoints presented | +1 |
| Clear timestamp | Publication date and time clearly displayed | +1 |
| Primary sources | Links to official statements or documents | +2 |

## Classification Categories

### 1. Credible

**Criteria:**
- Source is trusted (in whitelist)
- Content shows professional journalism standards
- No red flags present
- Multiple credibility indicators

**Action:** Process normally, include in output.

**Examples:**
- Article from reuters.com with named author, cited sources, clear timestamp
- Post from @Reuters with link to full article, professional tone
- RSS item from BLS with official employment data

**Output:**
```json
{
  "credibility": "credible",
  "credibility_score": 95,
  "verification_notes": "Trusted source with professional standards"
}
```

### 2. Uncertain

**Criteria:**
- Some credibility indicators present
- Some red flags also present
- Source is unknown but content appears plausible
- Cannot definitively classify as credible or fake

**Action:** 
- Mark with `credibility: "uncertain"`
- Require corroboration from exactly 2 credible sources
- Include in output with warning

**Examples:**
- Article from unknown domain but with named author and cited sources
- Social post from unverified account referencing official statements
- Content with minor red flags but otherwise professional presentation

**Output:**
```json
{
  "credibility": "uncertain",
  "credibility_score": 50,
  "corroboration_required": true,
  "corroboration_sources_needed": 2,
  "verification_notes": "Unknown source, requires corroboration"
}
```

### 3. Parody/Fake

**Criteria:**
- Clear parody indicators present
- Multiple critical red flags
- Content is demonstrably false or satirical
- Domain is known satire site

**Action:** 
- Discard immediately
- Do not include in output
- Log reason for exclusion

**Examples:**
- Article from theonion.com or similar satire sites
- Post explicitly labeled as satire or parody
- Content with absurd claims inconsistent with reality
- Domain mimicking legitimate source with slight variations

**Output (logged separately):**
```json
{
  "excluded_items": [
    {
      "source": "example.com",
      "title": "...",
      "canonical_url": "https://...",
      "exclusion_reason": "parody",
      "explanation": "Domain is known satire site"
    }
  ]
}
```

## Verification Workflow

### Step 1: Source Check

1. Check if domain is in trusted sources list
2. Check for domain mimicry (similar but not exact match)
3. Check for known satire/parody domains
4. Check domain age and WHOIS information if available

### Step 2: Content Analysis

1. Check for explicit satire/parody labels
2. Analyze headline for sensationalism
3. Check for author byline
4. Verify publication timestamp
5. Look for cited sources and attribution
6. Assess overall content quality

### Step 3: Social-Specific Checks (if applicable)

1. Verify account verification status
2. Check follower count and account age
3. Analyze account bio for parody indicators
4. Check for handle/name mismatches
5. Assess post formatting and tone

### Step 4: Calculate Credibility Score

```
credibility_score = base_score + credibility_indicators - red_flags

Where:
- base_score = 50 (neutral starting point)
- credibility_indicators = sum of positive indicator weights
- red_flags = sum of negative indicator weights
```

### Step 5: Classify and Act

| Score Range | Classification | Action |
|-------------|----------------|--------|
| 80-100 | Credible | Include in output |
| 40-79 | Uncertain | Require corroboration |
| 0-39 | Parody/Fake | Discard, log reason |

## Corroboration Requirements

### For Uncertain Website Articles

Find exactly 2 credible sources reporting the same information:
- Same core facts and claims
- Similar details and context
- Published within reasonable timeframe

### For Uncertain Social Posts

Verify against exactly 2 credible sources:
- Official statements or press releases
- Articles from trusted news sources
- Official company/government announcements

### Corroboration Tracking

```json
{
  "credibility": "uncertain",
  "corroboration_status": "pending|verified|failed",
  "corroboration_sources": ["reuters", "ft"],
  "corroboration_timestamp": "2026-03-04T09:30:00Z"
}
```

### Failed Corroboration

If corroboration fails:
- Keep item marked as uncertain
- Note lack of verification in summary
- Reduce priority in output
- Flag for manual review if high-impact

## Trusted Sources List

### Vietnamese Sources (Automatically Credible)

| Source | Domain | Credibility |
|--------|--------|-------------|
| Vietstock | vietstock.vn | Credible |
| VnEconomy | vneconomy.vn | Credible |
| VietnamNet | vietnamnet.vn | Credible |
| CafeF | cafef.vn | Credible |

### Global Sources (Automatically Credible)

| Source | Domain | Credibility |
|--------|--------|-------------|
| Reuters | reuters.com | Credible |
| Financial Times | ft.com | Credible |
| Bloomberg | bloomberg.com | Credible |
| Wall Street Journal | wsj.com | Credible |
| CNBC | cnbc.com | Credible |

### Official Data Sources (Automatically Credible)

| Source | Domain | Credibility |
|--------|--------|-------------|
| BLS | bls.gov | Credible |
| BEA | bea.gov | Credible |
| Eurostat | ec.europa.eu/eurostat | Credible |
| ONS | ons.gov.uk | Credible |
| IMF | imf.org | Credible |
| World Bank | worldbank.org | Credible |
| BIS | bis.org | Credible |

### Known Satire/Parody Domains (Automatically Fake)

| Domain | Classification |
|--------|----------------|
| theonion.com | Parody |
| babylonbee.com | Parody |
| clickhole.com | Parody |
| thehardtimes.net | Parody |
| reduxx.org | Parody |

## Output Schema Updates

### Credibility Fields

```json
{
  "credibility": "credible|uncertain",
  "credibility_score": 85,
  "corroboration_sources": ["reuters", "ft"],
  "verification_notes": "Trusted source with professional standards"
}
```

### Exclusion Fields

```json
{
  "excluded_items": [
    {
      "source": "example.com",
      "source_type": "website",
      "title": "...",
      "canonical_url": "https://...",
      "exclusion_reason": "parody|fake|duplicate|unrelated",
      "explanation": "Domain is known satire site"
    }
  ]
}
```

## Integration with Other Modules

- **News Aggregation**: Apply verification after extraction
- **RSS Ingestion**: Pre-classify RSS items as credible
- **Social Tracking**: Apply social-specific verification rules
- **Output Generation**: Include credibility scores in final output

## Vietnamese Source Credibility Guidelines

### Vietnamese Trusted Sources (Automatically Credible)

| Source | Domain | Credibility | Notes |
|--------|--------|-------------|-------|
| Vietstock | vietstock.vn | Credible | Official exchange data partner |
| VnEconomy | vneconomy.vn | Credible | Government-affiliated publication |
| VietnamNet | vietnamnet.vn | Credible | Mainstream media outlet |
| CafeF | cafef.vn | Credible | Financial focus with professional standards |
| Tinnhanhchungkhoan | tinnhanhchungkhoan.vn | Credible | Stock market focused |
| VietnamFinance | vietnamfinance.vn | Credible | Finance sector focus |
| EnterNews | enternews.vn | Credible | Business news focus |
| TapChiTaiLieu | tapchitailieu.vn | Credible | Academic/professional publication |
| BloombergVN | bloombergvn.com | Credible | International brand adaptation |
| TaiChinhDoanhNghiep | taichinhdoanhnghiep.net.vn | Credible | Corporate finance focus |

### Vietnamese Source Red Flags

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Unofficial Vietnamese domains | Domains mimicking trusted sources (e.g., `vietstock-news.vn`) | Critical |
| No Vietnamese editorial standards | Poor Vietnamese grammar, formatting, or professionalism | Medium |
| Anonymous Vietnamese sources | Vietnamese articles without author attribution | High |
| Sensational Vietnamese headlines | Excessive Vietnamese punctuation or emotional manipulation | High |
| Unverified Vietnamese claims | Vietnamese claims without supporting evidence | Medium |

### Vietnamese Content Quality Indicators

| Indicator | Description | Weight |
|-----------|-------------|--------|
| Vietnamese author byline | Article has Vietnamese author name | +1 |
| Vietnamese sources cited | Vietnamese article cites multiple Vietnamese sources | +2 |
| Vietnamese official data | References Vietnamese government or official statistics | +2 |
| Vietnamese professional formatting | Clean Vietnamese website design and layout | +1 |
| Vietnamese balanced presentation | Multiple Vietnamese viewpoints presented | +1 |

## Manual Review Queue

Items requiring manual review:
- Uncertain items with high market impact
- Items with conflicting credibility signals
- Novel sources not in trusted or parody lists
- Items with borderline credibility scores (35-45)

### Vietnamese Official Sources (Automatically Credible)

| Source | Domain | Credibility | Notes |
|--------|--------|-------------|-------|
| GSO (General Statistics Office) | gso.gov.vn | Credible | Official Vietnamese statistics |
| SBV (State Bank of Vietnam) | sbv.gov.vn | Credible | Central bank monetary policy |
| MPI (Ministry of Planning and Investment) | mpi.gov.vn | Credible | Investment and FDI data |
| MOLISA (Ministry of Labor) | molisa.gov.vn | Credible | Employment and labor data |
| MOIT (Ministry of Industry and Trade) | moit.gov.vn | Credible | Trade and industry data |
| MARD (Ministry of Agriculture) | mard.gov.vn | Credible | Agricultural data |
| MOC (Ministry of Construction) | moc.gov.vn | Credible | Construction sector data |
| MOT (Ministry of Transport) | mt.gov.vn | Credible | Transport sector data |
| SSC (State Securities Commission) | ssc.gov.vn | Credible | Securities regulations |
| MOF (Ministry of Finance) | mof.gov.vn | Credible | Fiscal policy and regulations |
| VSD (Vietnam Securities Depository) | vsd.vn | Credible | Securities depository data |
| VSE (Vietnam Stock Exchange) | vse.vn | Credible | Exchange rules and data |
| ISA (Insurance Supervisory Authority) | isa.gov.vn | Credible | Insurance regulations |
| Vietnam Competition Authority | vietnamcompetition.gov.vn | Credible | Competition enforcement |

### Vietnamese Regulatory Source Verification

**Vietnamese Regulatory Source Credibility Indicators:**

| Indicator | Description | Weight |
|-----------|-------------|--------|
| Official .gov.vn domain | Government-registered domain | +3 |
| Ministry/agency affiliation | Clear government affiliation | +2 |
| Official announcement format | Proper government announcement format | +1 |
| Publication date and reference | Clear publication metadata | +1 |
| Authorized spokesperson | Named official spokesperson | +2 |

**Vietnamese Regulatory Red Flags:**

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Unofficial Vietnamese government domains | Domains mimicking government sites | Critical |
| Anonymous Vietnamese regulatory announcements | No official attribution | High |
| Inconsistent Vietnamese regulatory format | Non-standard government format | Medium |
| Vietnamese regulatory claims without reference | Unsubstantiated regulatory claims | High |
| Vietnamese regulatory timing anomalies | Unusual announcement timing | Medium |

### Vietnamese Content Quality Assessment

**Vietnamese Editorial Standards:**

| Standard | Description | Assessment |
|----------|-------------|------------|
| Vietnamese author attribution | Named Vietnamese author or journalist | Required |
| Vietnamese editorial review | Evidence of editorial oversight | Preferred |
| Vietnamese source citations | References to Vietnamese official sources | Preferred |
| Vietnamese publication date | Clear Vietnamese date format (dd/mm/yyyy) | Required |
| Vietnamese corrections policy | Published corrections and updates | Preferred |

**Vietnamese Content Red Flags:**

| Red Flag | Description | Severity |
|----------|-------------|----------|
| Poor Vietnamese grammar | Inconsistent with professional Vietnamese journalism | Medium |
| Vietnamese sensationalism | Excessive Vietnamese emotional language | High |
| Anonymous Vietnamese sources | Vietnamese claims without attribution | High |
| Vietnamese clickbait headlines | Misleading Vietnamese headlines | High |
| Vietnamese factual inconsistencies | Contradictory Vietnamese information | Critical |

### Vietnamese Source Corroboration Requirements

**For Uncertain Vietnamese Website Articles:**

Find exactly 2 credible Vietnamese sources reporting the same information:
- Same core Vietnamese facts and claims
- Similar Vietnamese details and context
- Published within reasonable timeframe
- From different Vietnamese publishers

**For Uncertain Vietnamese Social Posts:**

Verify against exactly 2 credible Vietnamese sources:
- Official Vietnamese statements or press releases
- Articles from trusted Vietnamese news sources
- Official Vietnamese company/government announcements

**Vietnamese Corroboration Tracking:**

```json
{
  "vietnamese_corroboration": {
    "credibility": "uncertain",
    "corroboration_status": "pending|verified|failed",
    "corroboration_sources": ["vietstock", "cafef"],
    "corroboration_timestamp": "2026-03-04T09:30:00Z",
    "vietnamese_language_verified": true
  }
}
```

### Vietnamese Source Classification Examples

**Credible Vietnamese Source Example:**

```json
{
  "credibility": "credible",
  "credibility_score": 95,
  "verification_notes": "Trusted Vietnamese source with professional standards",
  "vietnamese_source": {
    "domain": "vietstock.vn",
    "type": "financial_news",
    "language": "vietnamese",
    "official_data_partner": true
  }
}
```

**Uncertain Vietnamese Source Example:**

```json
{
  "credibility": "uncertain",
  "credibility_score": 50,
  "corroboration_required": true,
  "corroboration_sources_needed": 2,
  "verification_notes": "Unknown Vietnamese source, requires corroboration",
  "vietnamese_source": {
    "domain": "unknown-vietnamese-site.vn",
    "type": "financial_news",
    "language": "vietnamese",
    "official_data_partner": false
  }
}
```

**Parody Vietnamese Source Example:**

```json
{
  "excluded_items": [
    {
      "source": "vietnamese-parody.vn",
      "source_type": "website",
      "title": "...",
      "canonical_url": "https://...",
      "exclusion_reason": "parody",
      "explanation": "Vietnamese domain is known satire site",
      "vietnamese_language": true
    }
  ]
}
```

### Vietnamese Source Verification Workflow

**Step 1: Vietnamese Domain Check**

1. Check if Vietnamese domain is in trusted Vietnamese sources list
2. Check for Vietnamese domain mimicry (similar but not exact match)
3. Check for known Vietnamese satire/parody domains
4. Check Vietnamese domain age and WHOIS information if available

**Step 2: Vietnamese Content Analysis**

1. Check for explicit Vietnamese satire/parody labels
2. Analyze Vietnamese headline for sensationalism
3. Check for Vietnamese author byline
4. Verify Vietnamese publication timestamp
5. Look for Vietnamese cited sources and attribution
6. Assess overall Vietnamese content quality

**Step 3: Vietnamese Regulatory Verification (if applicable)**

1. Verify Vietnamese regulatory source authenticity
2. Check Vietnamese government domain (.gov.vn)
3. Validate Vietnamese official announcement format
4. Confirm Vietnamese authorized spokesperson
5. Cross-reference with Vietnamese official sources

**Step 4: Calculate Vietnamese Credibility Score**

```
vietnamese_credibility_score = base_score + vietnamese_credibility_indicators - vietnamese_red_flags
```

Where:
- base_score = 50 (neutral starting point)
- vietnamese_credibility_indicators = sum of positive Vietnamese indicator weights
- vietnamese_red_flags = sum of negative Vietnamese indicator weights