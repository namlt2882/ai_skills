# Finance News PinchTab - Refactored Architecture Documentation

## Table of Contents
- [Overview](#overview)
- [Architecture Overview](#architecture-overview)
- [Knowledge File Structure](#knowledge-file-structure)
- [Module Dependencies and Relationships](#module-dependencies-and-relationships)
- [Using the Modular Structure](#using-the-modular-structure)
- [Migration Guide](#migration-guide)
- [Best Practices](#best-practices)
- [Appendix: Knowledge File Details](#appendix-knowledge-file-details)

## Overview

The Finance News PinchTab skill has been refactored into a modular architecture to enhance maintainability, scalability, and extensibility. This refactored structure separates concerns into distinct aspects and documentation modules, each focusing on specific functional areas of the financial news aggregation and analysis process.

### Vietnamese Market Coverage

This skill provides comprehensive coverage of Vietnamese financial markets, including:

- **Vietnamese News Sources**: Major Vietnamese financial news websites (Vietstock, CafeF, VnEconomy, VietnamNet, Tinnhanhchungkhoan, VietnamFinance, EnterNews, TapChiTaiLieu, BloombergVN, TaiChinhDoanhNghiep)
- **Vietnamese Market Data**: Official exchange data from HOSE, HNX, UPCoM, and professional platforms like VNDIRECT DStock and StockBook
- **Vietnamese Economic Data**: Official statistics from GSO, SBV, MPI, MOLISA, MOIT, MARD, MOC, and MOT
- **Vietnamese Regulatory Sources**: Securities regulations from SSC, MOF, VSD, VSE, ISA, and Vietnam Competition Authority
- **Vietnamese Language Support**: Full Vietnamese language detection, enforcement, and terminology for financial analysis
- **Vietnamese Market Analysis**: Technical indicators, risk assessment, and market regime analysis specifically adapted for Vietnamese markets

### Key Improvements in the Refactored Architecture

- **Modular Design**: Separated functionality into focused modules
- **Clear Separation of Concerns**: Each module handles specific aspects of the process
- **Enhanced Maintainability**: Changes to one module don't affect others
- **Improved Extensibility**: Easy to add new features without disrupting existing functionality
- **Better Documentation**: Each module has dedicated documentation

## Architecture Overview

The refactored architecture consists of three main layers:

```
┌─────────────────────────────────────────────────────────────┐
│                    Output Layer                             │
├─────────────────────────────────────────────────────────────┤
│  Final Output Generation (JSON Schema)                      │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                 Processing Layer                            │
├─────────────────────────────────────────────────────────────┤
│  [aspects/]          │  [docs/]           │  [references/] │
│  • credibility-      │  • intermarket-    │  • data-      │
│    verification      │    analysis        │    sources    │
│  • data-             │  • macroeconomic-  │               │
│    deduplication     │    factors         │               │
│  • economic-         │  • risk-assets-    │               │
│    calendar          │    analysis        │               │
│  • language-         │  • technical-      │               │
│    enforcement       │    indicators      │               │
│  • news-             │                    │               │
│    aggregation       │                    │               │
│  • rss-              │                    │               │
│    ingestion         │                    │               │
│  • social-           │                    │               │
│    tracking          │                    │               │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                Data Collection Layer                        │
├─────────────────────────────────────────────────────────────┤
│  • PinchTab Servers (Parallel Processing)                   │
│  • RSS Feed Ingestion (curl)                              │
│  • Social Media Scraping                                  │
│  • Economic Calendar Scraping                             │
└─────────────────────────────────────────────────────────────┘
```

### Core Architecture Components

1. **Aspects Layer** (`aspects/`): Handles specific functional concerns
2. **Documentation Layer** (`docs/`): Provides analytical frameworks
3. **References Layer** (`references/`): Contains static reference data
4. **Processing Pipeline**: Sequential execution of modules
5. **Output Generation**: Consolidates processed data into final format

## Knowledge File Structure

### Aspects Directory (`aspects/`)

The aspects directory contains modules that handle specific functional concerns:

#### 1. Credibility Verification ([`credibility-verification.md`](aspects/credibility-verification.md))
- Validates content authenticity and reliability
- Applies critical-thinking rules to detect fake news and parody
- Classifies items into credibility categories

#### 2. Data Deduplication ([`data-deduplication.md`](aspects/data-deduplication.md))
- Removes duplicate content across multiple sources
- Normalizes URLs and titles
- Tracks cross-source duplicates

#### 3. Economic Calendar ([`economic-calendar.md`](aspects/economic-calendar.md))
- Handles economic event collection from multiple sources
- Scrapes Investing.com via PinchTab
- Ingests Trading Economics RSS feeds

#### 4. Language Enforcement ([`language-enforcement.md`](aspects/language-enforcement.md))
- Detects user input language
- Enforces output language matching
- Verifies response language consistency

#### 5. News Aggregation ([`news-aggregation.md`](aspects/news-aggregation.md))
- Manages scraping of Vietnamese and global news sources
- Handles parallel processing and relevance filtering
- Processes timestamps and validates recency

#### 6. RSS Ingestion ([`rss-ingestion.md`](aspects/rss-ingestion.md))
- Fetches and parses RSS feeds from official sources
- Handles parallel fetching and XML/JSON parsing
- Implements RSS override rules

#### 7. Social Tracking ([`social-tracking.md`](aspects/social-tracking.md))
- Monitors Twitter/X accounts for breaking news
- Applies rumor detection heuristics
- Tracks engagement metrics

### Documentation Directory (`docs/`)

The documentation directory contains analytical frameworks:

#### 1. Intermarket Analysis ([`intermarket-analysis.md`](docs/intermarket-analysis.md))
- Examines correlations between asset classes
- Provides cross-asset implications for news
- Identifies leading vs lagging markets

#### 2. Macroeconomic Factors ([`macroeconomic-factors.md`](docs/macroeconomic-factors.md))
- Analyzes broad economic forces driving markets
- Provides context for economic data releases
- Assesses policy implications

#### 3. Risk Assets Analysis ([`risk-assets-analysis.md`](docs/risk-assets-analysis.md))
- Examines risk-on/risk-off dynamics
- Identifies flight-to-quality phenomena
- Classifies assets by risk profile

#### 4. Technical Indicators ([`technical-indicators.md`](docs/technical-indicators.md))
- Provides quantitative market condition measures
- Offers trend and momentum analysis
- Assesses news-technical alignment

### References Directory (`references/`)

#### 1. Data Sources ([`data-sources.md`](references/data-sources.md))
- Comprehensive reference of all data sources
- Categorized by type, region, and access method
- Includes reliability and verification requirements

## Module Dependencies and Relationships

### Processing Flow Dependencies

```
Input Sources → [RSS Ingestion] ──┐
                                   │
Input Sources → [News Aggregation] ├──→ [Data Deduplication] ──→ [Credibility Verification] ──→ [Output]
                                   │
Input Sources → [Social Tracking] ──┤
                                   │
Input Sources → [Economic Calendar] ──→ [Language Enforcement]
```

### Detailed Dependency Map

#### 1. RSS Ingestion Dependencies
- **Depends on**: None (entry point)
- **Provides to**: Data Deduplication, Credibility Verification
- **Integration**: Fetches official data feeds, sets up deduplication registry

#### 2. News Aggregation Dependencies
- **Depends on**: RSS Ingestion (to check for RSS availability)
- **Provides to**: Data Deduplication, Credibility Verification
- **Integration**: Skips website crawling if RSS is available for the same source

#### 3. Social Tracking Dependencies
- **Depends on**: None (entry point)
- **Provides to**: Data Deduplication, Credibility Verification
- **Integration**: Links social posts to matching articles via URL extraction

#### 4. Economic Calendar Dependencies
- **Depends on**: None (entry point)
- **Provides to**: Data Deduplication (for cross-source event deduplication)
- **Integration**: Calendar events are processed separately from news items

#### 5. Data Deduplication Dependencies
- **Depends on**: RSS Ingestion, News Aggregation, Social Tracking, Economic Calendar
- **Provides to**: Credibility Verification
- **Integration**: Processes all collected items through deduplication before credibility checks

#### 6. Credibility Verification Dependencies
- **Depends on**: Data Deduplication
- **Provides to**: Language Enforcement
- **Integration**: Applies verification rules to unique items only

#### 7. Language Enforcement Dependencies
- **Depends on**: Credibility Verification
- **Provides to**: Output Generation
- **Integration**: Ensures all summaries match user input language

### Cross-Module Interactions

#### Intermarket Analysis Integration
- **Used by**: Output Generation
- **Integration**: Provides cross-asset implications for news items
- **Dependencies**: All processing modules contribute data for analysis

#### Technical Indicators Integration
- **Used by**: Output Generation
- **Integration**: Adds technical context to news summaries
- **Dependencies**: Market data from processed items

#### Risk Assets Analysis Integration
- **Used by**: Output Generation
- **Integration**: Provides risk sentiment context
- **Dependencies**: All processed items contribute to risk assessment

#### Macroeconomic Factors Integration
- **Used by**: Output Generation
- **Integration**: Adds macroeconomic context to news
- **Dependencies**: Economic calendar and news items

## Using the Modular Structure

### Getting Started

1. **Understand the Architecture**: Familiarize yourself with the three-layer structure
2. **Identify Your Use Case**: Determine which modules are relevant to your needs
3. **Follow the Processing Flow**: Understand the sequential nature of the pipeline
4. **Configure Parameters**: Set up module-specific configurations

### Configuration Guidelines

#### Parallel Processing Setup
```bash
# Start exactly 4 PinchTab servers (max parallelism)
pinchtab --port 9867
pinchtab --port 9868
pinchtab --port 9869
pinchtab --port 9870
```

#### Module-Specific Configurations

Each module has its own configuration parameters:

- **RSS Ingestion**: Timeout settings, retry counts, feed URLs
- **News Aggregation**: Source whitelists, recency filters, relevance thresholds
- **Social Tracking**: Account lists, engagement thresholds, verification requirements
- **Economic Calendar**: Time windows, impact thresholds, source priorities

### Customization Options

#### Adding New Data Sources
1. Update [`data-sources.md`](references/data-sources.md) with source information
2. Modify News Aggregation or RSS Ingestion as appropriate
3. Update credibility verification for new source types
4. Add to deduplication rules if needed

#### Modifying Processing Logic
1. Identify the relevant aspect module
2. Update the processing rules within that module
3. Ensure dependencies are maintained
4. Test the impact on downstream modules

#### Extending Analytical Capabilities
1. Add new documentation modules in `docs/`
2. Update output generation to incorporate new analysis
3. Connect to processing modules as needed

### Operational Guidelines

#### Execution Sequence
1. Initialize all PinchTab servers
2. Execute all data collection modules in parallel
3. Process collected data through the pipeline
4. Generate final output with integrated analysis

#### Error Handling
- Each module implements its own error handling
- Failed modules should not halt the entire pipeline
- Results should indicate which modules succeeded/failed
- Logging should capture module-specific errors

#### Performance Optimization
- Monitor module execution times
- Optimize slow-performing modules
- Adjust parallel processing parameters
- Tune deduplication and verification thresholds

## Migration Guide

### From Old to New Structure

#### 1. Pre-Migration Assessment

**Old Structure Characteristics:**
- Monolithic implementation
- Tightly coupled components
- Limited modularity
- Difficult to maintain and extend

**New Structure Benefits:**
- Modular design with clear separation of concerns
- Independent components that can be developed separately
- Enhanced maintainability and extensibility
- Improved testability

#### 2. Migration Steps

##### Step 1: Backup Current Implementation
```bash
# Create backup of current implementation
cp -r finance-news-pinchtab finance-news-pinchtab-backup
```

##### Step 2: Understand the New Architecture
- Review the new modular structure
- Understand module dependencies and relationships
- Identify which old components map to new modules

##### Step 3: Migrate Data Collection Logic
- Move RSS ingestion logic to [`rss-ingestion.md`](aspects/rss-ingestion.md)
- Transfer news aggregation logic to [`news-aggregation.md`](aspects/news-aggregation.md)
- Relocate social tracking to [`social-tracking.md`](aspects/social-tracking.md)
- Move economic calendar handling to [`economic-calendar.md`](aspects/economic-calendar.md)

##### Step 4: Migrate Processing Logic
- Extract credibility verification to [`credibility-verification.md`](aspects/credibility-verification.md)
- Separate deduplication logic to [`data-deduplication.md`](aspects/data-deduplication.md)
- Isolate language enforcement to [`language-enforcement.md`](aspects/language-enforcement.md)

##### Step 5: Migrate Analytical Frameworks
- Move intermarket analysis to [`intermarket-analysis.md`](docs/intermarket-analysis.md)
- Transfer macroeconomic analysis to [`macroeconomic-factors.md`](docs/macroeconomic-factors.md)
- Relocate risk assets analysis to [`risk-assets-analysis.md`](docs/risk-assets-analysis.md)
- Move technical indicators to [`technical-indicators.md`](docs/technical-indicators.md)

##### Step 6: Update Output Generation
- Modify output schema to accommodate modular inputs
- Integrate analysis from documentation modules
- Ensure backward compatibility where needed

#### 3. Testing the Migration

##### Functional Testing
- Verify each module works independently
- Test the complete processing pipeline
- Validate output format and content
- Confirm all data sources still work

##### Performance Testing
- Measure execution time for each module
- Compare performance with old implementation
- Optimize slow modules if necessary

##### Integration Testing
- Test module dependencies and data flow
- Verify error handling across modules
- Confirm that failures in one module don't break others

#### 4. Post-Migration Validation

##### Data Integrity
- Compare output from old vs new implementation
- Verify all data sources are still accessible
- Confirm deduplication and credibility checks work correctly

##### Feature Completeness
- Ensure all old features are preserved
- Verify new modular features work as expected
- Test edge cases and error conditions

## Best Practices

### Development Best Practices

#### Module Development
- Keep modules focused on single responsibilities
- Maintain clear interfaces between modules
- Document module inputs, outputs, and dependencies
- Implement comprehensive error handling within each module

#### Code Quality
- Follow consistent naming conventions
- Write clear, descriptive comments
- Implement logging for debugging and monitoring
- Use configuration files for module parameters

#### Testing
- Write unit tests for each module
- Test module interfaces and data contracts
- Implement integration tests for the complete pipeline
- Test error conditions and recovery scenarios

### Maintenance Best Practices

#### Documentation
- Keep module documentation up to date
- Document changes to interfaces and dependencies
- Maintain clear examples and use cases
- Update the README when significant changes occur

#### Version Control
- Use feature branches for module development
- Implement code review for all changes
- Maintain clear commit messages
- Tag releases appropriately

#### Monitoring
- Implement health checks for each module
- Monitor execution times and resource usage
- Track error rates and failure patterns
- Set up alerts for critical failures

### Extension Best Practices

#### Adding New Modules
- Follow the existing module pattern
- Define clear interfaces and dependencies
- Implement appropriate error handling
- Update documentation and examples

#### Modifying Existing Modules
- Assess impact on dependent modules
- Maintain backward compatibility when possible
- Update tests and documentation
- Plan for gradual rollout if needed

#### Performance Optimization
- Profile modules to identify bottlenecks
- Optimize critical paths in the pipeline
- Consider caching for expensive operations
- Monitor resource usage and scale appropriately

### Security Best Practices

#### Data Handling
- Validate all external data inputs
- Sanitize data before processing
- Implement appropriate access controls
- Protect sensitive configuration data

#### External Connections
- Validate SSL certificates for external connections
- Implement appropriate timeouts and retries
- Monitor for suspicious external behavior
- Keep dependencies up to date

## Appendix: Knowledge File Details

### Aspects Module Details

#### Credibility Verification ([`credibility-verification.md`](aspects/credibility-verification.md))
- **Purpose**: Ensures content authenticity and reliability
- **Scope**: All collected items (website articles, RSS feeds, social posts)
- **Key Features**: Red flag detection, credibility scoring, corroboration requirements
- **Output**: Credibility classification and verification notes

#### Data Deduplication ([`data-deduplication.md`](aspects/data-deduplication.md))
- **Purpose**: Removes duplicate content across sources
- **Scope**: All collected items from all sources
- **Key Features**: URL normalization, primary/secondary deduplication keys, cross-source matching
- **Output**: Unique items with deduplication statistics

#### Economic Calendar ([`economic-calendar.md`](aspects/economic-calendar.md))
- **Purpose**: Collects and processes economic events
- **Scope**: Investing.com and Trading Economics sources
- **Key Features**: Event categorization, time range filtering, cross-source deduplication
- **Output**: Structured calendar events with impact assessment

#### Language Enforcement ([`language-enforcement.md`](aspects/language-enforcement.md))
- **Purpose**: Ensures output language matches user input
- **Scope**: All generated summaries and analysis
- **Key Features**: Language detection, injection in prompts, response verification
- **Output**: Language-appropriate summaries with verification metadata

#### News Aggregation ([`news-aggregation.md`](aspects/news-aggregation.md))
- **Purpose**: Scrapes news from Vietnamese and global sources
- **Scope**: Whitelisted news websites
- **Key Features**: Parallel processing, relevance filtering, timestamp validation
- **Output**: Collected news articles with metadata

#### RSS Ingestion ([`rss-ingestion.md`](aspects/rss-ingestion.md))
- **Purpose**: Fetches and processes RSS feeds
- **Scope**: Official data sources and news outlets
- **Key Features**: Parallel fetching, XML/JSON parsing, RSS override rules
- **Output**: RSS items with credibility classification

#### Social Tracking ([`social-tracking.md`](aspects/social-tracking.md))
- **Purpose**: Monitors social media for breaking news
- **Scope**: Selected Twitter/X accounts
- **Key Features**: Rumor detection, engagement tracking, verification protocols
- **Output**: Social posts with credibility and verification status

### Documentation Module Details

#### Intermarket Analysis ([`intermarket-analysis.md`](docs/intermarket-analysis.md))
- **Purpose**: Analyzes cross-asset relationships
- **Application**: Contextualizes news impact across asset classes
- **Key Concepts**: Stock-bond relationships, commodity-currency links, risk rotation
- **Output**: Cross-asset implications for news items

#### Macroeconomic Factors ([`macroeconomic-factors.md`](docs/macroeconomic-factors.md))
- **Purpose**: Provides economic context for news
- **Application**: Frames news within broader economic trends
- **Key Concepts**: GDP, employment, inflation, central bank policy
- **Output**: Macroeconomic context and policy implications

#### Risk Assets Analysis ([`risk-assets-analysis.md`](docs/risk-assets-analysis.md))
- **Purpose**: Analyzes risk sentiment and asset behavior
- **Application**: Identifies risk-on/risk-off dynamics
- **Key Concepts**: Risk vs safe haven assets, flight to quality, volatility regimes
- **Output**: Risk sentiment assessment and asset classification

#### Technical Indicators ([`technical-indicators.md`](docs/technical-indicators.md))
- **Purpose**: Provides quantitative market analysis
- **Application**: Adds technical context to news events
- **Key Concepts**: Trends, momentum, support/resistance, volatility
- **Output**: Technical context and alignment assessment

### References Module Details

#### Data Sources ([`data-sources.md`](references/data-sources.md))
- **Purpose**: Comprehensive reference of all data sources
- **Content**: URLs, access methods, reliability ratings, update schedules
- **Maintenance**: Regular updates to reflect source changes
- **Usage**: Guides data collection and validation efforts