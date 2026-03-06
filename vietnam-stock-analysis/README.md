# Vietnamese Stock Analysis Skill - Refactored Architecture

## Overview

This repository contains the refactored Vietnamese Stock Analysis skill, which provides structured analysis of Vietnamese equities with emphasis on bluechip coverage, market regime assessment, and technical indicators. The skill has been restructured into a modular architecture following best practices for maintainability and extensibility.

## Architecture Overview

The refactored skill follows a modular architecture with the following structure:

```
vietnam-stock-analysis/
├── SKILL.md                    # Main skill file with workflow and integration
├── aspects/                    # Core analysis modules
│   ├── bluechip-focus.md       # Bluechip stock analysis framework
│   ├── market-regime.md        # Market regime assessment
│   ├── technical-analysis.md   # Technical indicator analysis
│   ├── risk-assessment.md      # Risk evaluation framework
│   ├── trading-recommendations.md # Trading recommendation guidelines
│   └── regulatory-compliance.md # Vietnamese securities regulations
├── docs/                       # Supporting documentation
│   ├── company-analysis.md     # Company analysis framework
│   ├── market-overview.md      # Vietnamese market overview
│   └── technical-indicators-vn.md # Vietnamese-specific technical indicators
└── references/                 # Reference materials
    └── data-sources-vn.md      # Vietnamese financial data sources
```

## Knowledge File Contributions

### Core Analysis Aspects

#### 1. Bluechip Focus ([`aspects/bluechip-focus.md`](aspects/bluechip-focus.md))
- Provides detailed framework for analyzing Vietnamese bluechip stocks, particularly those in the VN30 index
- Focuses on large-cap identification, fundamental strength assessment, and liquidity characteristics
- Includes daily, weekly, and monthly monitoring frameworks
- Integrates with market regime analysis for trend alignment

#### 2. Market Regime Assessment ([`aspects/market-regime.md`](aspects/market-regime.md))
- Framework for identifying current market conditions in Vietnamese equities
- Assesses trend classification, volatility patterns, and liquidity conditions
- Incorporates Vietnamese market specifics like exchange-specific regimes and regulatory influences
- Coordinates with technical analysis for signal validation

#### 3. Technical Analysis ([`aspects/technical-analysis.md`](aspects/technical-analysis.md))
- Systematic approach to interpreting technical indicators for Vietnamese equities
- Adapts traditional indicators for Vietnamese market characteristics like price band restrictions
- Includes multi-timeframe analysis and Vietnamese-specific chart pattern recognition
- Integrates with risk assessment for position sizing decisions

#### 4. Risk Assessment ([`aspects/risk-assessment.md`](aspects/risk-assessment.md))
- Framework for evaluating and quantifying risks across different time horizons
- Covers market, country-specific, sector-specific, and company-specific risks
- Includes Vietnamese market-specific risks like regulatory environment and settlement risks
- Feeds into trading recommendations for position sizing

#### 5. Trading Recommendations ([`aspects/trading-recommendations.md`](aspects/trading-recommendations.md))
- Guidelines for generating actionable trading recommendations
- Incorporates technical, fundamental, and risk considerations
- Addresses Vietnamese market specifics like price limits and settlement periods
- Includes sector-based recommendations and risk management integration

#### 6. Regulatory Compliance ([`aspects/regulatory-compliance.md`](aspects/regulatory-compliance.md))
- Requirements to ensure all analysis complies with Vietnamese securities regulations
- Covers exchange-specific rules, foreign investment regulations, and margin trading rules
- Includes disclosure and reporting requirements
- Ensures recommendations consider regulatory constraints

### Supporting Documentation

#### 1. Company Analysis ([`docs/company-analysis.md`](docs/company-analysis.md))
- Comprehensive approach to analyzing Vietnamese companies with focus on bluechip stocks
- Includes fundamental analysis components, management quality assessment, and industry analysis
- Addresses Vietnamese market specifics like local business environment and cultural factors
- Integrates with technical analysis and market regime assessment

#### 2. Market Overview ([`docs/market-overview.md`](docs/market-overview.md))
- Understanding of Vietnamese stock market structure, participants, and operational characteristics
- Covers main exchanges (HOSE, HNX, UPCoM), trading infrastructure, and market participants
- Includes market characteristics, key indices, and economic context
- Provides context for all other analysis components

#### 3. Technical Indicators Guide ([`docs/technical-indicators-vn.md`](docs/technical-indicators-vn.md))
- Technical indicators specifically adapted for Vietnamese market characteristics
- Addresses market-specific considerations like price limit effects and liquidity characteristics
- Includes indicator adaptations and Vietnamese market-specific strategies
- Integrates with fundamental analysis and risk assessment

#### 4. Data Sources Reference ([`references/data-sources-vn.md`](references/data-sources-vn.md))
- Reliable data sources for Vietnamese financial markets including official exchanges and research resources
- Covers official exchange sources, primary data providers, and economic data sources
- Includes international data sources with Vietnam coverage and research houses
- Provides data quality considerations and best practices

## Relationships and Dependencies

### Hierarchical Structure
```
Main SKILL.md
├── Core Aspects (interconnected)
│   ├── Bluechip Focus ↔ Market Regime
│   ├── Technical Analysis ↔ Risk Assessment
│   ├── Trading Recommendations ← All other aspects
│   └── Regulatory Compliance ⊥ All aspects
├── Supporting Docs (referenced by aspects)
│   ├── Company Analysis → Bluechip Focus
│   ├── Market Overview → All aspects
│   ├── Technical Indicators → Technical Analysis
│   └── Data Sources → All aspects
└── External Dependencies
    ├── PinchTab for data fetching
    └── DStock VNDIRECT for official data
```

### Cross-Aspect Dependencies

1. **Bluechip Focus ↔ Market Regime**
   - Bluechip analysis aligns with identified market regime
   - Market regime assessment considers bluechip leadership patterns
   - Both inform risk assessment parameters

2. **Technical Analysis ↔ Risk Assessment**
   - Technical indicators serve as early warning signals for risk changes
   - Risk assessment modifies technical indicator parameters based on volatility
   - Both feed into trading recommendations

3. **All Aspects → Trading Recommendations**
   - Trading recommendations integrate insights from all other aspects
   - Position sizing based on risk assessment
   - Entry/exit timing informed by technical analysis
   - Market context provided by regime assessment
   - Fundamental backing from bluechip analysis

4. **Regulatory Compliance ⊥ All Aspects**
   - Applies to all other components without direct dependencies
   - Ensures all recommendations comply with Vietnamese regulations
   - Affects trading recommendation parameters

### Data Flow

1. **Input Sources**: DStock VNDIRECT, official exchanges, economic data
2. **Processing**: Each aspect analyzes specific dimensions of the data
3. **Integration**: Aspects share information through the main SKILL.md
4. **Output**: Unified analysis incorporating all aspect insights

## Using the Modular Structure

### For Analysis Tasks

1. **Start with the Main SKILL.md**
   - Review activation criteria and workflow steps
   - Understand the required analysis sections
   - Follow the output format requirements

2. **Access Relevant Aspects**
   - For bluechip analysis, reference [`aspects/bluechip-focus.md`](aspects/bluechip-focus.md)
   - For market regime assessment, reference [`aspects/market-regime.md`](aspects/market-regime.md)
   - For technical analysis, reference [`aspects/technical-analysis.md`](aspects/technical-analysis.md)
   - For risk assessment, reference [`aspects/risk-assessment.md`](aspects/risk-assessment.md)
   - For recommendations, reference [`aspects/trading-recommendations.md`](aspects/trading-recommendations.md)
   - For compliance, reference [`aspects/regulatory-compliance.md`](aspects/regulatory-compliance.md)

3. **Consult Supporting Documentation**
   - For company analysis details, reference [`docs/company-analysis.md`](docs/company-analysis.md)
   - For market context, reference [`docs/market-overview.md`](docs/market-overview.md)
   - For technical indicator specifics, reference [`docs/technical-indicators-vn.md`](docs/technical-indicators-vn.md)
   - For data sources, reference [`references/data-sources-vn.md`](references/data-sources-vn.md)

### For Skill Maintenance

1. **Update Specific Aspects**
   - Modify only the relevant aspect file for targeted changes
   - Maintain consistency with interconnected aspects
   - Update cross-references as needed

2. **Add New Capabilities**
   - Create new aspect files in the `aspects/` directory
   - Update the main SKILL.md to reference new aspects
   - Document relationships with existing aspects

3. **Ensure Consistency**
   - Maintain consistent terminology across all files
   - Update related aspects when making changes
   - Verify that the main workflow integrates new aspects properly

## Migration Guide: Old to New Structure

### Before Refactoring (Monolithic Structure)
- Single `SKILL.md` file contained all analysis methodologies
- Mixed concerns with technical, fundamental, and regulatory content combined
- Difficult to update specific analysis components without affecting others
- Limited modularity and reusability

### After Refactoring (Modular Structure)
- Separated concerns into specialized aspect files
- Clear boundaries between different analysis dimensions
- Easy to update individual components
- Enhanced maintainability and extensibility

### Migration Steps Completed

1. **Phase 1: Knowledge File Creation**
   - Extracted bluechip focus content to [`aspects/bluechip-focus.md`](aspects/bluechip-focus.md)
   - Created market regime assessment in [`aspects/market-regime.md`](aspects/market-regime.md)
   - Developed technical analysis framework in [`aspects/technical-analysis.md`](aspects/technical-analysis.md)
   - Established risk assessment in [`aspects/risk-assessment.md`](aspects/risk-assessment.md)
   - Created trading recommendations in [`aspects/trading-recommendations.md`](aspects/trading-recommendations.md)
   - Added regulatory compliance in [`aspects/regulatory-compliance.md`](aspects/regulatory-compliance.md)

2. **Phase 2: Main Skill Update**
   - Updated main [`SKILL.md`](SKILL.md) to reference specialized knowledge files
   - Maintained all existing functionality through references
   - Preserved activation criteria and constraints
   - Added clear integration points between aspects

3. **Phase 3: Supporting Documentation**
   - Created company analysis framework in [`docs/company-analysis.md`](docs/company-analysis.md)
   - Developed market overview in [`docs/market-overview.md`](docs/market-overview.md)
   - Added Vietnamese-specific technical indicators in [`docs/technical-indicators-vn.md`](docs/technical-indicators-vn.md)
   - Established data sources reference in [`references/data-sources-vn.md`](references/data-sources-vn.md)

4. **Phase 4: Validation**
   - Verified all functionality remains intact
   - Confirmed all analysis sections are properly covered
   - Ensured advisory tone requirements are maintained
   - Validated compliance with Vietnam market rules

### Key Changes for Users

- **Enhanced Precision**: Each aspect provides detailed, focused guidance
- **Improved Maintainability**: Individual components can be updated independently
- **Better Organization**: Logical grouping of related analysis methodologies
- **Clearer Integration**: Explicit references between related concepts
- **Expanded Coverage**: Additional detail in specialized areas

## Best Practices for Maintenance and Extension

### Updating Existing Aspects

1. **Maintain Consistency**
   - Follow the established format and terminology
   - Ensure updates align with interconnected aspects
   - Update cross-references when making changes

2. **Document Changes**
   - Add version information when significant changes are made
   - Update related aspects that may be affected
   - Maintain backward compatibility where possible

3. **Test Integration**
   - Verify that changes don't break connections with other aspects
   - Ensure the main SKILL.md still properly integrates the updated aspect
   - Test end-to-end functionality after updates

### Adding New Capabilities

1. **Identify the Right Location**
   - New technical methodologies → `aspects/technical-analysis.md`
   - New risk factors → `aspects/risk-assessment.md`
   - New regulatory requirements → `aspects/regulatory-compliance.md`
   - New market insights → appropriate aspect file

2. **Consider Creating New Aspects**
   - If new capability is substantial and independent
   - When it addresses a distinct analysis dimension
   - If it would clutter existing aspects

3. **Establish Relationships**
   - Document how new capabilities connect to existing aspects
   - Add appropriate cross-references
   - Update the main SKILL.md if needed

### Quality Assurance

1. **Content Standards**
   - Use Vietnamese market-specific examples and context
   - Maintain consistency with official data sources
   - Follow the calm, non-panic advisory tone requirements
   - Include practical implementation guidance

2. **Cross-Reference Integrity**
   - Verify all internal links remain valid
   - Update references when file locations change
   - Maintain clear and helpful cross-links between related concepts

3. **Performance Considerations**
   - Keep individual files manageable in size
   - Optimize for quick reference and comprehension
   - Balance comprehensiveness with usability

### Collaboration Guidelines

1. **Version Control**
   - Use descriptive commit messages explaining the changes
   - Update related files when making cross-cutting changes
   - Maintain changelog information for significant updates

2. **Review Process**
   - Have changes reviewed by domain experts
   - Verify that updates maintain analytical rigor
   - Ensure compliance with Vietnamese securities regulations

3. **Documentation Standards**
   - Keep examples relevant to Vietnamese market conditions
   - Provide clear explanations for complex concepts
   - Include practical applications and use cases

## Conclusion

The refactored Vietnamese Stock Analysis skill provides a robust, modular foundation for analyzing Vietnamese equities. The architecture enables focused development of specific analysis capabilities while maintaining integration across all aspects. This structure supports both current functionality and future enhancements while ensuring compliance with Vietnamese market regulations and best practices.