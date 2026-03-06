---
name: chart-image
description: Converts data to visual charts and graphs rendered as images. Enables AI agents to generate various chart types from datasets for enhanced data visualization in chat interfaces.
---

# Chart to Image Visualization Skill

Systematizes the conversion of data to visual charts and graphs rendered as images for enhanced data presentation in chat interfaces.

## When to Activate

- Converting numerical data to visual charts (bar, line, pie, scatter, etc.)
- Generating images from datasets for better comprehension
- Creating visual representations of trends, comparisons, and distributions
- Sharing data insights through visual chart representations
- Rendering charts in chat interfaces that don't support rich visualization

## Prerequisites

### Required Libraries
- `matplotlib` - For creating static, animated, and interactive visualizations
- `seaborn` - For statistical data visualization
- `plotly` - For interactive plots (optional)
- `pandas` - For data manipulation and analysis
- `numpy` - For numerical computations
- `pillow` - For image processing and manipulation

### System Requirements
- Python 3.7+ or Node.js environment
- Image rendering capabilities
- Font rendering support for chart labels

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. DATA INPUT                                          │
│     Accept numerical data (CSV, JSON, DataFrame, etc.) │
│     Validate data structure and content                │
├─────────────────────────────────────────────────────────┤
│  2. CHART TYPE SELECTION                               │
│     Determine appropriate chart type based on data     │
│     Apply best practices for data visualization        │
├─────────────────────────────────────────────────────────┤
│  3. VISUALIZATION                                      │
│     Render chart as image using matplotlib/seaborn     │
│     Apply formatting, colors, and layout               │
├─────────────────────────────────────────────────────────┤
│  4. IMAGE OPTIMIZATION                                 │
│     Resize for optimal display                         │
│     Optimize for file size and quality                 │
├─────────────────────────────────────────────────────────┤
│  5. OUTPUT GENERATION                                  │
│     Save as PNG, JPEG, or SVG                          │
│     Return image data for chat integration             │
└─────────────────────────────────────────────────────────┘
```

## Data Input Formats

### Pandas DataFrame
```python
import pandas as pd
import matplotlib.pyplot as plt

def process_dataframe(df: pd.DataFrame, chart_type: str = 'auto', title: str = None) -> bytes:
    """
    Process a pandas DataFrame into a chart image
    """
    # Auto-detect chart type if not specified
    if chart_type == 'auto':
        chart_type = _detect_chart_type(df)
    
    # Create the appropriate chart
    if chart_type == 'line':
        return _create_line_chart(df, title)
    elif chart_type == 'bar':
        return _create_bar_chart(df, title)
    elif chart_type == 'pie':
        return _create_pie_chart(df, title)
    elif chart_type == 'scatter':
        return _create_scatter_plot(df, title)
    elif chart_type == 'histogram':
        return _create_histogram(df, title)
    elif chart_type == 'heatmap':
        return _create_heatmap(df, title)
    else:
        raise ValueError(f"Unsupported chart type: {chart_type}")
```

### CSV Data
```python
def process_csv(csv_string: str, chart_type: str = 'auto', title: str = None) -> bytes:
    """
    Process CSV string into a chart image
    """
    import io
    df = pd.read_csv(io.StringIO(csv_string))
    return process_dataframe(df, chart_type, title)
```

### JSON Data
```python
def process_json(json_string: str, chart_type: str = 'auto', title: str = None) -> bytes:
    """
    Process JSON string into a chart image
    """
    import json
    data = json.loads(json_string)
    df = pd.DataFrame(data)
    return process_dataframe(df, chart_type, title)
```

## Chart Types

### Line Charts
```python
def _create_line_chart(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a line chart from DataFrame
    """
    plt.figure(figsize=(10, 6))
    
    # Plot each numeric column as a line
    for col in df.select_dtypes(include=['number']).columns:
        plt.plot(df.index if not df.index.name else df.index, df[col], marker='o', label=col)
    
    plt.title(title or 'Line Chart')
    plt.xlabel('Index')
    plt.ylabel('Values')
    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Bar Charts
```python
def _create_bar_chart(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a bar chart from DataFrame
    """
    plt.figure(figsize=(10, 6))
    
    # If there's only one row, create a horizontal bar chart
    if len(df) == 1:
        df.iloc[0].plot(kind='barh')
    else:
        # Plot each numeric column as a bar
        df.select_dtypes(include=['number']).plot(kind='bar', ax=plt.gca())
    
    plt.title(title or 'Bar Chart')
    plt.xlabel('Categories')
    plt.ylabel('Values')
    plt.xticks(rotation=45)
    plt.legend()
    plt.tight_layout()
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Pie Charts
```python
def _create_pie_chart(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a pie chart from DataFrame
    """
    plt.figure(figsize=(8, 8))
    
    # Use the first numeric column for the pie chart
    numeric_cols = df.select_dtypes(include=['number']).columns
    if len(numeric_cols) == 0:
        raise ValueError("DataFrame must contain at least one numeric column for pie chart")
    
    # If there's only one row, use all numeric columns
    if len(df) == 1:
        values = df[numeric_cols].iloc[0]
        labels = numeric_cols
    else:
        # Use the first numeric column, assuming index contains labels
        values = df[numeric_cols[0]]
        labels = df.index.astype(str)
    
    plt.pie(values, labels=labels, autopct='%1.1f%%', startangle=90)
    plt.title(title or 'Pie Chart')
    plt.axis('equal')  # Equal aspect ratio ensures that pie is drawn as a circle
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Scatter Plots
```python
def _create_scatter_plot(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a scatter plot from DataFrame
    """
    numeric_cols = df.select_dtypes(include=['number']).columns
    if len(numeric_cols) < 2:
        raise ValueError("DataFrame must contain at least two numeric columns for scatter plot")
    
    plt.figure(figsize=(10, 6))
    
    # Use the first two numeric columns for x and y axes
    x_col, y_col = numeric_cols[0], numeric_cols[1]
    plt.scatter(df[x_col], df[y_col])
    
    plt.title(title or f'{y_col} vs {x_col}')
    plt.xlabel(x_col)
    plt.ylabel(y_col)
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Histograms
```python
def _create_histogram(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a histogram from DataFrame
    """
    numeric_cols = df.select_dtypes(include=['number']).columns
    if len(numeric_cols) == 0:
        raise ValueError("DataFrame must contain at least one numeric column for histogram")
    
    plt.figure(figsize=(10, 6))
    
    # Create histogram for the first numeric column
    plt.hist(df[numeric_cols[0]], bins=20, edgecolor='black')
    
    plt.title(title or f'Histogram of {numeric_cols[0]}')
    plt.xlabel(numeric_cols[0])
    plt.ylabel('Frequency')
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Heatmaps
```python
def _create_heatmap(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Create a heatmap from DataFrame
    """
    import seaborn as sns
    
    plt.figure(figsize=(10, 8))
    
    # Create heatmap of correlations
    correlation_matrix = df.select_dtypes(include=['number']).corr()
    sns.heatmap(correlation_matrix, annot=True, cmap='coolwarm', center=0,
                square=True, fmt='.2f')
    
    plt.title(title or 'Correlation Heatmap')
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

## Chart Type Detection

### Automatic Chart Type Selection
```python
def _detect_chart_type(df: pd.DataFrame) -> str:
    """
    Automatically detect the most appropriate chart type based on data characteristics
    """
    numeric_cols = df.select_dtypes(include=['number']).columns
    categorical_cols = df.select_dtypes(include=['object', 'category']).columns
    
    # If only one numeric column and few rows, suggest bar chart
    if len(numeric_cols) == 1 and len(df) <= 10:
        return 'bar'
    
    # If only one numeric column with many rows, suggest line chart
    if len(numeric_cols) == 1 and len(df) > 10:
        return 'line'
    
    # If two numeric columns, suggest scatter plot
    if len(numeric_cols) >= 2:
        return 'scatter'
    
    # If one numeric column and one categorical with few categories, suggest bar
    if len(numeric_cols) == 1 and len(categorical_cols) >= 1:
        if df[categorical_cols[0]].nunique() <= 10:
            return 'bar'
        else:
            return 'line'
    
    # Default to bar chart
    return 'bar'
```

## Styling Options

### Predefined Chart Styles
```python
def apply_style(chart_type: str, style_name: str = 'default'):
    """
    Apply predefined styles to charts
    """
    styles = {
        'default': {
            'palette': 'tab10',
            'grid': True,
            'background': 'white'
        },
        'professional': {
            'palette': 'Set2',
            'grid': True,
            'background': 'white'
        },
        'minimal': {
            'palette': 'Greys',
            'grid': False,
            'background': 'white'
        },
        'colorful': {
            'palette': 'Set1',
            'grid': True,
            'background': 'white'
        },
        'dark': {
            'palette': 'Dark2',
            'grid': True,
            'background': 'black'
        }
    }
    
    style = styles.get(style_name, styles['default'])
    
    # Apply matplotlib style
    plt.style.use('default')
    if style['background'] == 'black':
        plt.style.use('dark_background')
    
    return style
```

### Seaborn Themes
```python
def apply_seaborn_theme(theme: str = 'whitegrid'):
    """
    Apply seaborn themes to charts
    """
    import seaborn as sns
    
    themes = ['white', 'dark', 'whitegrid', 'darkgrid', 'ticks']
    if theme in themes:
        sns.set_style(theme)
    else:
        sns.set_style('whitegrid')
```

## Advanced Chart Features

### Multi-Series Charts
```python
def create_multi_series_chart(df: pd.DataFrame, series_column: str, value_columns: list, title: str = None) -> bytes:
    """
    Create a chart with multiple series based on a categorical column
    """
    plt.figure(figsize=(12, 6))
    
    # Group by the series column and plot each value column
    grouped = df.groupby(series_column)
    
    for col in value_columns:
        for name, group in grouped:
            plt.plot(group.index, group[col], label=f'{name} - {col}', marker='o')
    
    plt.title(title or 'Multi-Series Chart')
    plt.xlabel('Index')
    plt.ylabel('Values')
    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.6)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Time Series Charts
```python
def create_time_series_chart(df: pd.DataFrame, date_column: str, value_column: str, title: str = None) -> bytes:
    """
    Create a time series chart
    """
    # Ensure date column is datetime
    df[date_column] = pd.to_datetime(df[date_column])
    
    plt.figure(figsize=(12, 6))
    
    # Sort by date
    df_sorted = df.sort_values(date_column)
    
    plt.plot(df_sorted[date_column], df_sorted[value_column], marker='o')
    
    plt.title(title or f'Time Series: {value_column}')
    plt.xlabel('Date')
    plt.ylabel(value_column)
    plt.xticks(rotation=45)
    plt.grid(True, linestyle='--', alpha=0.6)
    plt.tight_layout()
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

## Image Optimization

### Size Optimization
```python
from PIL import Image
import io

def optimize_chart_size(img_bytes: bytes, max_width: int = 800, max_height: int = 600) -> bytes:
    """
    Optimize chart image size for chat display
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

### Format Conversion
```python
def convert_chart_format(img_bytes: bytes, target_format: str = 'PNG') -> bytes:
    """
    Convert chart image to different format
    """
    img = Image.open(io.BytesIO(img_bytes))
    
    output = io.BytesIO()
    img.save(output, format=target_format, optimize=True)
    converted_bytes = output.getvalue()
    
    return converted_bytes
```

## Integration with Chat Systems

### Base64 Encoding for Chat
```python
import base64

def encode_chart_for_chat(img_bytes: bytes) -> str:
    """
    Encode chart image bytes to base64 for chat systems
    """
    encoded = base64.b64encode(img_bytes).decode('utf-8')
    return f"data:image/png;base64,{encoded}"
```

### Complete Processing Pipeline
```python
def create_chart_image(data, chart_type='auto', title=None, style='default', optimize=True, max_width=800, max_height=600):
    """
    Complete pipeline to create a chart image from various data sources
    """
    # Determine data type and process accordingly
    if isinstance(data, pd.DataFrame):
        img_bytes = process_dataframe(data, chart_type, title)
    elif isinstance(data, str):
        # Assume it's CSV or JSON
        try:
            # Try JSON first
            import json
            parsed = json.loads(data)
            img_bytes = process_json(data, chart_type, title)
        except json.JSONDecodeError:
            # If not JSON, assume CSV
            import io
            try:
                pd.read_csv(io.StringIO(data))
                img_bytes = process_csv(data, chart_type, title)
            except pd.errors.ParserError:
                raise ValueError("String input must be valid CSV or JSON")
    else:
        raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
    
    # Apply styling
    # Note: Actual styling would be applied during the initial processing
    
    # Optimize image if requested
    if optimize:
        img_bytes = optimize_chart_size(img_bytes, max_width, max_height)
    
    return img_bytes
```

## Error Handling

### Validation and Error Checking
```python
def validate_chart_data(data):
    """
    Validate input data for chart creation
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
        
        # Check if there's at least one numeric column for charting
        if len(data.select_dtypes(include=['number']).columns) == 0:
            raise ValueError("DataFrame must contain at least one numeric column for charting")
    else:
        raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
    
    return True
```

## Usage Examples

### Basic Usage
```python
# Example 1: From DataFrame
df = pd.DataFrame({
    'Month': ['Jan', 'Feb', 'Mar', 'Apr', 'May'],
    'Sales': [100, 150, 200, 120, 180],
    'Profit': [20, 30, 40, 25, 35]
})

# Create a line chart
img_bytes = create_chart_image(df, chart_type='line', title="Monthly Sales Trend")

# Create a bar chart
img_bytes = create_chart_image(df, chart_type='bar', title="Monthly Sales")

# Example 2: From CSV string
csv_data = """Month,Sales,Profit
Jan,100,20
Feb,150,30
Mar,200,40
Apr,120,25
May,180,35"""

img_bytes = create_chart_image(csv_data, chart_type='line', title="Sales Trend from CSV")

# Example 3: From JSON string
json_data = '''[
    {"Month": "Jan", "Sales": 100, "Profit": 20},
    {"Month": "Feb", "Sales": 150, "Profit": 30},
    {"Month": "Mar", "Sales": 200, "Profit": 40},
    {"Month": "Apr", "Sales": 120, "Profit": 25},
    {"Month": "May", "Sales": 180, "Profit": 35}
]'''

img_bytes = create_chart_image(json_data, chart_type='bar', title="Sales from JSON")
```

## Best Practices

### Performance Optimization
1. **Pre-aggregate data** before visualization if dealing with large datasets
2. **Use appropriate figure sizes** to balance readability and file size
3. **Implement caching** for frequently generated charts
4. **Optimize for display size** rather than maximum resolution

### Accessibility
1. **Ensure sufficient contrast** between chart elements
2. **Use colorblind-friendly palettes** for data visualization
3. **Provide alternative text descriptions** for complex charts
4. **Maintain readable font sizes** (minimum 10pt)

### Integration Tips
1. **Validate data early** in the pipeline to prevent processing errors
2. **Handle different data types** gracefully with appropriate parsers
3. **Provide styling options** to match different use cases
4. **Optimize images** for the target chat platform's display capabilities

## Troubleshooting

### Common Issues
| Issue | Cause | Solution |
|-------|-------|----------|
| **Large file size** | High-resolution output | Use optimize_chart_size() function |
| **Poor readability** | Small font size or low contrast | Adjust styling parameters |
| **Parsing errors** | Invalid data format | Validate input format before processing |
| **Memory issues** | Large datasets | Implement data sampling or aggregation |
| **Missing fonts** | Font rendering issues | Ensure system has required fonts installed |
| **Chart type mismatch** | Inappropriate chart for data | Use automatic detection or explicit type |

## Related Skills
- [`image-processing-chat`](../image-processing-chat/SKILL.md) — For image handling and chat integration
- [`table-image`](../table-image/SKILL.md) — For tabular data visualization
- [`data-viz`](../data-viz/SKILL.md) — For broader data visualization techniques
- [`coding-standards`](../coding-standards/SKILL.md) — For consistent implementation patterns