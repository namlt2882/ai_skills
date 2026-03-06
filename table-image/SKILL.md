---
name: table-image
description: Converts tabular data to visual representations and images. Enables AI agents to generate tables from data and render them as images for better visualization in chat interfaces.
---

# Table to Image Visualization Skill

Systematizes the conversion of tabular data to visual representations and images for enhanced presentation in chat interfaces.

## When to Activate

- Converting structured data to visual tables
- Generating images from CSV, JSON, or other tabular formats
- Creating visual representations of datasets for better comprehension
- Rendering tables in chat interfaces that don't support rich formatting
- Sharing data insights through visual table representations

## Prerequisites

### Required Libraries
- `pandas` - For data manipulation and analysis
- `matplotlib` - For creating static, animated, and interactive visualizations
- `seaborn` - For statistical data visualization
- `plotly` - For interactive plots (optional)
- `pillow` - For image processing and manipulation
- `numpy` - For numerical computations

### System Requirements
- Python 3.7+ or Node.js environment
- Image rendering capabilities
- Font rendering support for table text

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. DATA INPUT                                          │
│     Accept tabular data (CSV, JSON, DataFrame, etc.)   │
│     Validate data structure and content                │
├─────────────────────────────────────────────────────────┤
│  2. TABLE DESIGN                                       │
│     Apply styling based on data type                   │
│     Select appropriate visualization method            │
├─────────────────────────────────────────────────────────┤
│  3. VISUALIZATION                                      │
│     Render table as image using matplotlib/seaborn     │
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

def process_dataframe(df: pd.DataFrame, title: str = None) -> bytes:
    """
    Process a pandas DataFrame into a table image
    """
    fig, ax = plt.subplots(figsize=(len(df.columns) * 2, len(df) * 0.5 + 1))
    ax.axis('tight')
    ax.axis('off')
    
    # Create table
    table = ax.table(cellText=df.values,
                    colLabels=df.columns,
                    cellLoc='center',
                    loc='center')
    
    # Style the table
    table.auto_set_font_size(False)
    table.set_fontsize(10)
    table.scale(1.2, 1.5)
    
    # Apply alternating row colors
    for i in range(len(df)):
        for j in range(len(df.columns)):
            if i % 2 == 0:
                table[(i + 1, j)].set_facecolor('#f5f5f5')
            else:
                table[(i + 1, j)].set_facecolor('white')
    
    # Style header
    for j in range(len(df.columns)):
        table[(0, j)].set_facecolor('#4CAF50')
        table[(0, j)].set_text_props(weight='bold', color='white')
    
    if title:
        plt.title(title, fontsize=14, pad=20)
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### CSV Data
```python
import pandas as pd

def process_csv(csv_string: str, title: str = None) -> bytes:
    """
    Process CSV string into a table image
    """
    import io
    df = pd.read_csv(io.StringIO(csv_string))
    return process_dataframe(df, title)
```

### JSON Data
```python
import json
import pandas as pd

def process_json(json_string: str, title: str = None) -> bytes:
    """
    Process JSON string into a table image
    """
    data = json.loads(json_string)
    df = pd.DataFrame(data)
    return process_dataframe(df, title)
```

## Styling Options

### Basic Table Styles
```python
def apply_style(table, style_type: str = 'basic'):
    """
    Apply predefined styles to the table
    """
    styles = {
        'basic': {
            'header_bg': '#4CAF50',
            'header_fg': 'white',
            'row_even_bg': '#f5f5f5',
            'row_odd_bg': 'white',
            'font_size': 10
        },
        'professional': {
            'header_bg': '#2196F3',
            'header_fg': 'white',
            'row_even_bg': '#f0f8ff',
            'row_odd_bg': 'white',
            'font_size': 11
        },
        'minimal': {
            'header_bg': '#333333',
            'header_fg': 'white',
            'row_even_bg': '#fafafa',
            'row_odd_bg': 'white',
            'font_size': 9
        },
        'colorful': {
            'header_bg': '#FF5722',
            'header_fg': 'white',
            'row_even_bg': '#FFF3E0',
            'row_odd_bg': '#FFE0B2',
            'font_size': 10
        }
    }
    
    style = styles.get(style_type, styles['basic'])
    
    # Apply header styling
    for j in range(len(df.columns)):
        table[(0, j)].set_facecolor(style['header_bg'])
        table[(0, j)].set_text_props(weight='bold', color=style['header_fg'])
    
    # Apply row styling
    for i in range(len(df)):
        bg_color = style['row_even_bg'] if i % 2 == 0 else style['row_odd_bg']
        for j in range(len(df.columns)):
            table[(i + 1, j)].set_facecolor(bg_color)
    
    # Apply font size
    table.auto_set_font_size(False)
    table.set_fontsize(style['font_size'])
    
    return table
```

### Custom Styling
```python
def apply_custom_styling(table, styling_config: dict):
    """
    Apply custom styling based on configuration
    """
    # Apply custom colors
    if 'header_background' in styling_config:
        for j in range(len(df.columns)):
            table[(0, j)].set_facecolor(styling_config['header_background'])
    
    if 'header_foreground' in styling_config:
        for j in range(len(df.columns)):
            table[(0, j)].set_text_props(color=styling_config['header_foreground'])
    
    # Apply conditional formatting
    if 'conditional_formatting' in styling_config:
        conditions = styling_config['conditional_formatting']
        for condition in conditions:
            column_idx = df.columns.get_loc(condition['column'])
            for i, value in enumerate(df[condition['column']]):
                if eval(f"{value} {condition['operator']} {condition['threshold']}"):
                    table[(i + 1, column_idx)].set_facecolor(condition['color'])
    
    return table
```

## Advanced Table Features

### Heatmap Tables
```python
import seaborn as sns
import matplotlib.pyplot as plt
import numpy as np

def create_heatmap_table(data, annot=True, cmap='viridis', figsize=(10, 6)):
    """
    Create a heatmap-style table for numerical data
    """
    plt.figure(figsize=figsize)
    
    # Create heatmap
    sns.heatmap(data, 
                annot=annot, 
                fmt='.2f', 
                cmap=cmap,
                cbar_kws={'label': 'Value'})
    
    plt.title('Data Heatmap Table')
    
    # Save to bytes
    from io import BytesIO
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes
```

### Pivot Table Visualization
```python
def create_pivot_visualization(df, index, columns, values, aggfunc='mean'):
    """
    Create a visual representation of a pivot table
    """
    pivot_df = pd.pivot_table(df, 
                              index=index, 
                              columns=columns, 
                              values=values, 
                              aggfunc=aggfunc)
    
    return process_dataframe(pivot_df)
```

## Image Optimization

### Size Optimization
```python
from PIL import Image
import io

def optimize_image_size(img_bytes: bytes, max_width: int = 800, max_height: int = 600) -> bytes:
    """
    Optimize table image size for chat display
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
def convert_image_format(img_bytes: bytes, target_format: str = 'PNG') -> bytes:
    """
    Convert image to different format
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

def encode_for_chat(img_bytes: bytes) -> str:
    """
    Encode image bytes to base64 for chat systems
    """
    encoded = base64.b64encode(img_bytes).decode('utf-8')
    return f"data:image/png;base64,{encoded}"
```

### Complete Processing Pipeline
```python
def create_table_image(data, title=None, style='basic', optimize=True, max_width=800, max_height=600):
    """
    Complete pipeline to create a table image from various data sources
    """
    # Determine data type and process accordingly
    if isinstance(data, pd.DataFrame):
        img_bytes = process_dataframe(data, title)
    elif isinstance(data, str):
        # Assume it's CSV or JSON
        try:
            # Try JSON first
            import json
            parsed = json.loads(data)
            img_bytes = process_json(data, title)
        except json.JSONDecodeError:
            # If not JSON, assume CSV
            img_bytes = process_csv(data, title)
    else:
        raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
    
    # Apply styling
    # Note: Actual styling would be applied during the initial processing
    
    # Optimize image if requested
    if optimize:
        img_bytes = optimize_image_size(img_bytes, max_width, max_height)
    
    return img_bytes
```

## Error Handling

### Validation and Error Checking
```python
def validate_table_data(data):
    """
    Validate input data for table creation
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
    else:
        raise ValueError("Unsupported data type. Expected DataFrame, CSV string, or JSON string.")
    
    return True
```

## Usage Examples

### Basic Usage
```python
# Example 1: From DataFrame
df = pd.DataFrame({
    'Product': ['A', 'B', 'C', 'D'],
    'Sales': [100, 150, 200, 120],
    'Profit': [20, 30, 40, 25]
})

img_bytes = create_table_image(df, title="Sales Report")

# Example 2: From CSV string
csv_data = """Product,Sales,Profit
A,100,20
B,150,30
C,200,40
D,120,25"""

img_bytes = create_table_image(csv_data, title="Sales Report from CSV")

# Example 3: From JSON string
json_data = '''[
    {"Product": "A", "Sales": 100, "Profit": 20},
    {"Product": "B", "Sales": 150, "Profit": 30},
    {"Product": "C", "Sales": 200, "Profit": 40},
    {"Product": "D", "Sales": 120, "Profit": 25}
]'''

img_bytes = create_table_image(json_data, title="Sales Report from JSON")
```

## Best Practices

### Performance Optimization
1. **Pre-filter data** before visualization if dealing with large datasets
2. **Use appropriate figure sizes** to balance readability and file size
3. **Implement caching** for frequently generated tables
4. **Optimize for display size** rather than maximum resolution

### Accessibility
1. **Ensure sufficient contrast** between text and background
2. **Use colorblind-friendly palettes** for data visualization
3. **Provide alternative text descriptions** for complex tables
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
| **Large file size** | High-resolution output | Use optimize_image_size() function |
| **Poor readability** | Small font size or low contrast | Adjust styling parameters |
| **Parsing errors** | Invalid data format | Validate input format before processing |
| **Memory issues** | Large datasets | Implement data sampling or aggregation |
| **Missing fonts** | Font rendering issues | Ensure system has required fonts installed |

## Related Skills
- [`image-processing-chat`](../image-processing-chat/SKILL.md) — For image handling and chat integration
- [`data-viz`](../data-viz/SKILL.md) — For broader data visualization techniques
- [`coding-standards`](../coding-standards/SKILL.md) — For consistent implementation patterns