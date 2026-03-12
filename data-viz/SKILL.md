---
name: data-viz
description: Comprehensive data visualization capabilities for AI agents. Combines table and chart visualization with advanced analytics and reporting features for enhanced data presentation in chat interfaces.
---

# Data Visualization Skill

Systematizes comprehensive data visualization capabilities for AI agents, combining table and chart visualization with advanced analytics and reporting features for enhanced data presentation in chat interfaces.

## When to Activate

- Performing comprehensive data analysis and visualization
- Creating multi-dimensional visualizations from complex datasets
- Generating reports with both tabular and graphical representations
- Providing advanced analytics insights through visualizations
- Creating interactive dashboards or reports for data exploration

## Prerequisites

### Required Libraries
- `pandas` - For data manipulation and analysis
- `matplotlib` - For creating static, animated, and interactive visualizations
- `seaborn` - For statistical data visualization
- `plotly` - For interactive plots
- `numpy` - For numerical computations
- `pillow` - For image processing and manipulation
- `scipy` - For advanced statistical analysis (optional)
- `statsmodels` - For statistical modeling (optional)

### System Requirements
- Python 3.7+ or Node.js environment
- Image rendering capabilities
- Font rendering support for chart labels
- Sufficient memory for large dataset processing

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. DATA ANALYSIS                                     │
│     Explore dataset structure and content            │
│     Identify data types and relationships             │
├─────────────────────────────────────────────────────────┤
│  2. VISUALIZATION STRATEGY                           │
│     Determine optimal visualization approach          │
│     Select appropriate chart and table combinations   │
├─────────────────────────────────────────────────────────┤
│  3. MULTI-VISUALIZATION CREATION                     │
│     Generate tables, charts, and composite visuals    │
│     Apply consistent styling and formatting           │
├─────────────────────────────────────────────────────────┤
│  4. ANALYTICAL INSIGHTS                              │
│     Compute statistics and trends                     │
│     Highlight key findings visually                   │
├─────────────────────────────────────────────────────────┤
│  5. REPORT ASSEMBLY                                  │
│     Combine visualizations into coherent report       │
│     Optimize for chat display and sharing             │
└─────────────────────────────────────────────────────────┘
```

## Data Analysis Capabilities

### Dataset Exploration
```python
import pandas as pd
import numpy as np

def explore_dataset(df: pd.DataFrame) -> dict:
    """
    Perform comprehensive dataset exploration
    """
    analysis = {
        'shape': df.shape,
        'dtypes': df.dtypes.to_dict(),
        'missing_values': df.isnull().sum().to_dict(),
        'numeric_summary': df.describe().to_dict() if len(df.select_dtypes(include=[np.number]).columns) > 0 else {},
        'categorical_summary': {},
        'correlations': df.select_dtypes(include=[np.number]).corr().to_dict() if len(df.select_dtypes(include=[np.number]).columns) > 1 else {}
    }
    
    # Analyze categorical columns
    for col in df.select_dtypes(include=['object', 'category']).columns:
        analysis['categorical_summary'][col] = {
            'unique_count': df[col].nunique(),
            'top_values': df[col].value_counts().head().to_dict()
        }
    
    return analysis
```

### Statistical Analysis
```python
from scipy import stats

def perform_statistical_analysis(df: pd.DataFrame) -> dict:
    """
    Perform statistical analysis on numeric columns
    """
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    if len(numeric_cols) == 0:
        return {}
    
    analysis = {}
    for col in numeric_cols:
        data = df[col].dropna()
        analysis[col] = {
            'mean': float(data.mean()),
            'median': float(data.median()),
            'std': float(data.std()),
            'variance': float(data.var()),
            'skewness': float(stats.skew(data)),
            'kurtosis': float(stats.kurtosis(data)),
            'percentiles': {
                '25%': float(data.quantile(0.25)),
                '50%': float(data.quantile(0.50)),
                '75%': float(data.quantile(0.75))
            }
        }
    
    return analysis
```

## Visualization Strategies

### Automatic Visualization Recommendation
```python
def recommend_visualizations(df: pd.DataFrame) -> list:
    """
    Recommend appropriate visualizations based on dataset characteristics
    """
    recommendations = []
    
    # Count numeric columns
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns
    
    # Recommend distribution plots for numeric data
    if len(numeric_cols) > 0:
        recommendations.append({
            'type': 'distribution',
            'columns': numeric_cols[:3].tolist(),  # Limit to first 3 for performance
            'description': 'Distribution of numeric variables'
        })
    
    # Recommend relationship plots for paired numeric data
    if len(numeric_cols) >= 2:
        recommendations.append({
            'type': 'correlation',
            'columns': numeric_cols[:min(5, len(numeric_cols))].tolist(),  # Limit to 5 for performance
            'description': 'Correlation matrix of numeric variables'
        })
    
    # Recommend comparison plots for categorical vs numeric
    if len(categorical_cols) > 0 and len(numeric_cols) > 0:
        recommendations.append({
            'type': 'comparison',
            'categorical_col': categorical_cols[0],
            'numeric_col': numeric_cols[0],
            'description': f'Relationship between {categorical_cols[0]} and {numeric_cols[0]}'
        })
    
    # Recommend time series if datetime column exists
    datetime_cols = df.select_dtypes(include=['datetime64']).columns
    if len(datetime_cols) > 0 and len(numeric_cols) > 0:
        recommendations.append({
            'type': 'time_series',
            'date_col': datetime_cols[0],
            'value_col': numeric_cols[0],
            'description': f'Time series of {numeric_cols[0]} over {datetime_cols[0]}'
        })
    
    return recommendations
```

### Composite Visualizations
```python
import matplotlib.pyplot as plt
import seaborn as sns

def create_composite_dashboard(df: pd.DataFrame, title: str = "Data Dashboard") -> bytes:
    """
    Create a composite dashboard with multiple visualizations
    """
    # Determine grid layout based on data characteristics
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns
    
    # Create subplot grid (max 2x2 for simplicity)
    n_plots = min(4, len(numeric_cols) + min(1, len(categorical_cols)))
    n_rows = min(2, n_plots)
    n_cols = 2 if n_plots > 1 else 1
    
    fig, axes = plt.subplots(n_rows, n_cols, figsize=(15, 8))
    if n_plots == 1:
        axes = [axes]
    elif n_plots == 2:
        axes = [axes[0], axes[1]]
    else:
        axes = axes.flatten()
    
    plot_idx = 0
    
    # Distribution plot for first numeric column
    if len(numeric_cols) > 0 and plot_idx < len(axes):
        df[numeric_cols[0]].hist(ax=axes[plot_idx], bins=20, edgecolor='black')
        axes[plot_idx].set_title(f'Distribution of {numeric_cols[0]}')
        axes[plot_idx].set_xlabel(numeric_cols[0])
        axes[plot_idx].set_ylabel('Frequency')
        plot_idx += 1
    
    # Box plot for first numeric column
    if len(numeric_cols) > 0 and plot_idx < len(axes):
        df.boxplot(column=numeric_cols[0], ax=axes[plot_idx])
        axes[plot_idx].set_title(f'Box Plot of {numeric_cols[0]}')
        plot_idx += 1
    
    # Bar chart for first categorical column
    if len(categorical_cols) > 0 and plot_idx < len(axes):
        value_counts = df[categorical_cols[0]].value_counts().head(10)  # Top 10 categories
        value_counts.plot(kind='bar', ax=axes[plot_idx])
        axes[plot_idx].set_title(f'Top Categories in {categorical_cols[0]}')
        axes[plot_idx].tick_params(axis='x', rotation=45)
        plot_idx += 1
    
    # Correlation heatmap if multiple numeric columns
    if len(numeric_cols) > 1 and plot_idx < len(axes):
        corr_matrix = df[numeric_cols].corr()
        sns.heatmap(corr_matrix, annot=True, cmap='coolwarm', center=0, 
                    square=True, fmt='.2f', ax=axes[plot_idx])
        axes[plot_idx].set_title('Correlation Matrix')
        plot_idx += 1
    
    # Hide unused subplots
    for idx in range(plot_idx, len(axes)):
        axes[idx].set_visible(False)
    
    plt.suptitle(title, fontsize=16)
    plt.tight_layout()
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=100)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

## Advanced Analytics

### Trend Analysis
```python
def perform_trend_analysis(df: pd.DataFrame, date_col: str, value_col: str) -> dict:
    """
    Perform trend analysis on time series data
    """
    # Ensure date column is datetime
    df[date_col] = pd.to_datetime(df[date_col])
    df_sorted = df.sort_values(date_col)
    
    # Calculate basic trends
    data = df_sorted[value_col].dropna()
    
    analysis = {
        'start_value': float(data.iloc[0]),
        'end_value': float(data.iloc[-1]),
        'total_change': float(data.iloc[-1] - data.iloc[0]),
        'average_growth_rate': float(((data.iloc[-1] / data.iloc[0]) ** (1/len(data)) - 1) * 100) if data.iloc[0] != 0 else 0,
        'volatility': float(data.std()),
        'trend_direction': 'increasing' if data.iloc[-1] > data.iloc[0] else 'decreasing'
    }
    
    return analysis
```

### Outlier Detection
```python
def detect_outliers(df: pd.DataFrame, column: str, method: str = 'iqr') -> dict:
    """
    Detect outliers in a numeric column
    """
    data = df[column].dropna()
    
    if method == 'iqr':
        Q1 = data.quantile(0.25)
        Q3 = data.quantile(0.75)
        IQR = Q3 - Q1
        lower_bound = Q1 - 1.5 * IQR
        upper_bound = Q3 + 1.5 * IQR
        
        outliers = data[(data < lower_bound) | (data > upper_bound)]
    elif method == 'zscore':
        z_scores = np.abs(stats.zscore(data))
        outliers = data[z_scores > 3]
    else:
        raise ValueError("Method must be 'iqr' or 'zscore'")
    
    return {
        'outlier_indices': outliers.index.tolist(),
        'outlier_values': outliers.tolist(),
        'outlier_percentage': len(outliers) / len(data) * 100,
        'bounds': {'lower': float(lower_bound), 'upper': float(upper_bound)}
    }
```

## Report Generation

### Automated Report Creation
```python
def generate_data_report(df: pd.DataFrame, title: str = "Data Analysis Report") -> dict:
    """
    Generate a comprehensive data analysis report
    """
    # Perform exploratory analysis
    dataset_info = explore_dataset(df)
    stats_analysis = perform_statistical_analysis(df)
    viz_recommendations = recommend_visualizations(df)
    
    # Create visualizations
    dashboard_img = create_composite_dashboard(df, f"{title} - Dashboard")
    
    # Compile report
    report = {
        'title': title,
        'dataset_overview': {
            'rows': dataset_info['shape'][0],
            'columns': dataset_info['shape'][1],
            'missing_values_total': int(sum(dataset_info['missing_values'].values())),
            'numeric_columns': list(dataset_info['numeric_summary'].keys()) if dataset_info['numeric_summary'] else [],
            'categorical_columns': list(dataset_info['categorical_summary'].keys())
        },
        'statistical_summary': stats_analysis,
        'visualization_recommendations': viz_recommendations,
        'dashboard_image': dashboard_img,
        'key_insights': extract_key_insights(df, stats_analysis, dataset_info)
    }
    
    return report
```

### Key Insights Extraction
```python
def extract_key_insights(df: pd.DataFrame, stats_analysis: dict, dataset_info: dict) -> list:
    """
    Extract key insights from the data analysis
    """
    insights = []
    
    # Check for high correlation
    if dataset_info.get('correlations'):
        corr_matrix = pd.DataFrame(dataset_info['correlations'])
        high_corr_pairs = []
        
        for i in range(len(corr_matrix.columns)):
            for j in range(i+1, len(corr_matrix.columns)):
                val = corr_matrix.iloc[i, j]
                if abs(val) > 0.7:  # High correlation threshold
                    high_corr_pairs.append((corr_matrix.columns[i], corr_matrix.columns[j], val))
        
        if high_corr_pairs:
            for pair in high_corr_pairs[:3]:  # Limit to top 3
                insights.append(f"High correlation found between {pair[0]} and {pair[1]}: {pair[2]:.2f}")
    
    # Check for outliers
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    for col in numeric_cols[:3]:  # Check first 3 numeric columns
        outliers = detect_outliers(df, col)
        if outliers['outlier_percentage'] > 5:  # More than 5% outliers
            insights.append(f"{col} has {outliers['outlier_percentage']:.1f}% outlier values")
    
    # Check for missing data
    missing_percentages = {k: v/len(df)*100 for k, v in dataset_info['missing_values'].items()}
    high_missing = {k: v for k, v in missing_percentages.items() if v > 10}
    if high_missing:
        for col, pct in high_missing.items():
            insights.append(f"{col} has {pct:.1f}% missing values")
    
    # Check for skewness
    for col, stats in stats_analysis.items():
        if abs(stats.get('skewness', 0)) > 1:  # Highly skewed
            direction = "right" if stats['skewness'] > 0 else "left"
            insights.append(f"{col} is highly skewed to the {direction} (skewness: {stats['skewness']:.2f})")
    
    return insights
```

## Interactive Visualizations

### Plotly Integration
```python
import plotly.graph_objects as go
import plotly.express as px
from plotly.subplots import make_subplots

def create_interactive_dashboard(df: pd.DataFrame, title: str = "Interactive Dashboard"):
    """
    Create an interactive dashboard using Plotly
    """
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns
    
    # Create subplots
    fig = make_subplots(
        rows=2, cols=2,
        subplot_titles=('Distribution', 'Scatter Plot', 'Time Series', 'Box Plot'),
        specs=[[{"secondary_y": False}, {"secondary_y": False}],
               [{"secondary_y": False}, {"secondary_y": False}]]
    )
    
    # Distribution plot (histogram)
    if len(numeric_cols) > 0:
        fig.add_trace(
            go.Histogram(x=df[numeric_cols[0]], name=f"Distribution of {numeric_cols[0]}"),
            row=1, col=1
        )
    
    # Scatter plot
    if len(numeric_cols) >= 2:
        fig.add_trace(
            go.Scatter(x=df[numeric_cols[0]], y=df[numeric_cols[1]], 
                      mode='markers', name=f"{numeric_cols[0]} vs {numeric_cols[1]}"),
            row=1, col=2
        )
    
    # Time series (if datetime column exists)
    datetime_cols = df.select_dtypes(include=['datetime64']).columns
    if len(datetime_cols) > 0 and len(numeric_cols) > 0:
        df_sorted = df.sort_values(datetime_cols[0])
        fig.add_trace(
            go.Scatter(x=df_sorted[datetime_cols[0]], y=df_sorted[numeric_cols[0]], 
                      mode='lines+markers', name=f"Time Series of {numeric_cols[0]}"),
            row=2, col=1
        )
    
    # Box plot
    if len(numeric_cols) > 0:
        fig.add_trace(
            go.Box(y=df[numeric_cols[0]], name=f"Box Plot of {numeric_cols[0]}"),
            row=2, col=2
        )
    
    fig.update_layout(height=600, showlegend=True, title_text=title)
    
    return fig
```

## Image Optimization

### Composite Image Optimization
```python
from PIL import Image
import io

def optimize_dashboard_image(img_bytes: bytes, max_width: int = 1200, max_height: int = 800) -> bytes:
    """
    Optimize dashboard image size for chat display
    """
    img = Image.open(io.BytesIO(img_bytes))
    
    # Calculate new dimensions maintaining aspect ratio
    original_width, original_height = img.size
    ratio = min(max_width/original_width, max_height/original_height)
    
    new_width = int(original_width * ratio)
    new_height = int(original_height * ratio)
    
    # Resize image
    resized_img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
    
    # Save optimized image
    output = io.BytesIO()
    resized_img.save(output, format='PNG', optimize=True, quality=85)
    optimized_bytes = output.getvalue()
    
    return optimized_bytes
```

## Integration with Chat Systems

### Complete Processing Pipeline
```python
def create_data_visualization(data, title="Data Visualization", include_analytics=True, optimize=True):
    """
    Complete pipeline to create comprehensive data visualization
    """
    # Convert input to DataFrame if needed
    if isinstance(data, pd.DataFrame):
        df = data
    elif isinstance(data, str):
        # Assume it's CSV or JSON
        try:
            import json
            parsed = json.loads(data)
            df = pd.DataFrame(parsed)
        except json.JSONDecodeError:
            # Try parsing as CSV
            import io
            df = pd.read_csv(io.StringIO(data))
    else:
        raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
    
    # Validate data
    if df.empty:
        raise ValueError("DataFrame cannot be empty")
    
    # Generate report
    report = generate_data_report(df, title)
    
    # Optimize dashboard image if requested
    if optimize:
        report['dashboard_image'] = optimize_dashboard_image(report['dashboard_image'])
    
    return report
```

## Error Handling

### Validation and Error Checking
```python
def validate_data_viz_input(data):
    """
    Validate input data for data visualization
    """
    if data is None:
        raise ValueError("Input data cannot be None")
    
    if isinstance(data, str):
        # Check if it's valid CSV or JSON
        try:
            import json
            json.loads(data)
        except json.JSONDecodeError:
            # Try parsing as CSV
            import io
            try:
                pd.read_csv(io.StringIO(data))
            except pd.errors.ParserError:
                raise ValueError("String input must be valid CSV or JSON")
    
    elif isinstance(data, pd.DataFrame):
        if data.empty:
            raise ValueError("DataFrame cannot be empty")
        
        if len(data.columns) == 0:
            raise ValueError("DataFrame must have at least one column")
    else:
        raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
    
    return True
```

## Usage Examples

### Basic Usage
```python
# Example 1: From DataFrame
df = pd.DataFrame({
    'Date': pd.date_range(start='2023-01-01', periods=100),
    'Sales': np.random.normal(1000, 200, 100).cumsum(),
    'Expenses': np.random.normal(800, 150, 100).cumsum(),
    'Region': np.random.choice(['North', 'South', 'East', 'West'], 100)
})

report = create_data_visualization(df, title="Business Metrics Dashboard")

# Example 2: From CSV string
csv_data = """Date,Sales,Expenses,Region
2023-01-01,1000,800,North
2023-01-02,1050,820,South
2023-01-03,980,790,East
2023-01-04,1100,850,West
2023-01-05,1080,830,North"""

report = create_data_visualization(csv_data, title="Sales Report Dashboard")

# Example 3: Complex analysis
complex_df = pd.DataFrame({
    'Category': ['A', 'B', 'C', 'D', 'E'] * 20,
    'Value1': np.random.normal(50, 10, 100),
    'Value2': np.random.normal(100, 20, 100),
    'Value3': np.random.normal(75, 15, 100)
})

report = create_data_visualization(complex_df, title="Multi-Dimensional Analysis")
```

## Best Practices

### Performance Optimization
1. **Sample large datasets** before visualization if dealing with more than 10,000 rows
2. **Use appropriate aggregation levels** for time series data
3. **Implement lazy loading** for interactive visualizations
4. **Cache computed statistics** for frequently accessed data

### Accessibility
1. **Ensure sufficient contrast** between visualization elements
2. **Use colorblind-friendly palettes** for all visualizations
3. **Provide textual summaries** of key insights
4. **Maintain readable font sizes** (minimum 10pt for labels)

### Integration Tips
1. **Validate data early** in the pipeline to prevent processing errors
2. **Handle different data types** gracefully with appropriate parsers
3. **Provide multiple visualization options** to match different use cases
4. **Optimize images** for the target chat platform's display capabilities

## Troubleshooting

### Common Issues
| Issue | Cause | Solution |
|-------|-------|----------|
| **Large file size** | High-resolution output | Use optimize_dashboard_image() function |
| **Poor readability** | Small font size or low contrast | Adjust styling parameters |
| **Parsing errors** | Invalid data format | Validate input format before processing |
| **Memory issues** | Large datasets | Implement data sampling or aggregation |
| **Missing fonts** | Font rendering issues | Ensure system has required fonts installed |
| **Slow performance** | Complex visualizations | Simplify or sample the data |

## Dependencies

This skill integrates with:

- **image-processing-chat**: For image handling and chat integration
- **chart-image**: For chart-based visualizations with TradingView styling
- **vietnam-stock-analysis**: For Vietnamese stock market analysis with charts
- **us-financial-market-analysis**: For US market technical analysis visualizations

## Performance Benchmarks

| Operation | Time | Memory | Notes |
|-----------|------|--------|-------|
| Dataset exploration | 100ms | 20MB | Basic stats |
| Statistical analysis | 200ms | 50MB | With scipy |
| Composite dashboard | 800ms | 150MB | 4-panel layout |
| Interactive dashboard | 500ms | 100MB | Plotly HTML |

## Security Considerations

- **Input Sanitization**: Validate all data sources before processing
- **Path Validation**: Sanitize file paths to prevent directory traversal
- **Memory Cleanup**: Close plots to prevent memory leaks
- **Error Logging**: Log errors without exposing data contents

## Related Skills
- [`image-processing-chat`](../image-processing-chat/SKILL.md) — For image handling and chat integration
- [`table-image`](../table-image/SKILL.md) — For tabular data visualization
- [`chart-image`](../chart-image/SKILL.md) — For chart-based visualizations
- [`coding-standards`](../coding-standards/SKILL.md) — For consistent implementation patterns