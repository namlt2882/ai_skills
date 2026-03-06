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

## Limitations

### Maximum Tables Per Image
- **Constraint**: Maximum 2 tables per image
- **Rationale**: To improve visibility and readability of tabular data in chat interfaces
- **Handling More Tables**: When you need to display more than 2 tables, split them into multiple images and present them sequentially in the chat

### Table Count Validation
```python
def validate_table_count(tables: list) -> bool:
    """
    Validate that the number of tables does not exceed the maximum limit
    """
    MAX_TABLES_PER_IMAGE = 2
    
    if len(tables) > MAX_TABLES_PER_IMAGE:
        raise ValueError(
            f"Maximum {MAX_TABLES_PER_IMAGE} tables per image allowed. "
            f"Found {len(tables)} tables. Please split into multiple images."
        )
    
    return True
```

## Workflow

```
┌─────────────────────────────────────────────────────────┐
│  1. DATA INPUT                                          │
│     Accept tabular data (CSV, JSON, DataFrame, etc.)   │
│     Validate data structure and content                │
├─────────────────────────────────────────────────────────┤
│  2. TABLE COUNT VALIDATION                              │
│     Check number of tables (max 2 per image)           │
│     Split into multiple images if needed               │
├─────────────────────────────────────────────────────────┤
│  3. TABLE DESIGN                                       │
│     Apply styling based on data type                   │
│     Select appropriate visualization method            │
├─────────────────────────────────────────────────────────┤
│  4. VISUALIZATION                                      │
│     Render table as image using matplotlib/seaborn     │
│     Apply formatting, colors, and layout               │
├─────────────────────────────────────────────────────────┤
│  5. IMAGE OPTIMIZATION                                 │
│     Resize for optimal display                         │
│     Optimize for file size and quality                 │
├─────────────────────────────────────────────────────────┤
│  6. OUTPUT GENERATION                                  │
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

### Multi-Table Visualization (Max 2 Tables Per Image)
```python
import matplotlib.pyplot as plt
import pandas as pd
from io import BytesIO

def create_multi_table_image(tables: list, titles: list = None, style='basic') -> bytes:
    """
    Create an image with up to 2 tables displayed side by side
    
    Args:
        tables: List of DataFrames (max 2)
        titles: Optional list of titles for each table
        style: Style to apply to tables
        
    Returns:
        Image bytes
    """
    MAX_TABLES_PER_IMAGE = 2
    
    if len(tables) > MAX_TABLES_PER_IMAGE:
        raise ValueError(
            f"Maximum {MAX_TABLES_PER_IMAGE} tables per image allowed. "
            f"Found {len(tables)} tables. Please split into multiple images."
        )
    
    if titles is None:
        titles = [f"Table {i+1}" for i in range(len(tables))]
    
    # Create figure with subplots for side-by-side display
    fig, axes = plt.subplots(1, len(tables), figsize=(12, 6))
    if len(tables) == 1:
        axes = [axes]  # Make it iterable for single table
    
    for idx, (df, ax) in enumerate(zip(tables, axes)):
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
        
        # Add title
        ax.set_title(titles[idx], fontsize=14, pad=20, fontweight='bold')
    
    plt.tight_layout()
    
    # Save to bytes
    img_buffer = BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes


# Example usage:
# df1 = pd.DataFrame({'Product': ['A', 'B'], 'Sales': [100, 150]})
# df2 = pd.DataFrame({'Product': ['C', 'D'], 'Sales': [200, 120]})
# img_bytes = create_multi_table_image([df1, df2], titles=['Q1 Sales', 'Q2 Sales'])
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

### Table Management
1. **Maximum 2 tables per image** to ensure optimal visibility and readability
2. **Split large datasets** into multiple images when more than 2 tables are needed
3. **Group related tables** together when splitting into multiple images
4. **Provide clear labels** for each table when displaying multiple tables in one image

## Troubleshooting

### Common Issues
| Issue | Cause | Solution |
|-------|-------|----------|
| **Large file size** | High-resolution output | Use optimize_image_size() function |
| **Poor readability** | Small font size or low contrast | Adjust styling parameters |
| **Parsing errors** | Invalid data format | Validate input format before processing |
| **Memory issues** | Large datasets | Implement data sampling or aggregation |
| **Missing fonts** | Font rendering issues | Ensure system has required fonts installed |
| **Too many tables error** | Attempting to render more than 2 tables per image | Split tables into multiple images using split_multiple_tables() function |

### Handling Multiple Tables
```python
def split_multiple_tables(tables: list, title_prefix: str = "Table") -> list:
    """
    Split multiple tables into batches of maximum 2 tables per image
    
    Args:
        tables: List of DataFrames or data to be rendered
        title_prefix: Prefix for image titles
        
    Returns:
        List of tuples: [(tables_batch_1, title_1), (tables_batch_2, title_2), ...]
    """
    MAX_TABLES_PER_IMAGE = 2
    batches = []
    
    for i in range(0, len(tables), MAX_TABLES_PER_IMAGE):
        batch = tables[i:i + MAX_TABLES_PER_IMAGE]
        batch_num = (i // MAX_TABLES_PER_IMAGE) + 1
        title = f"{title_prefix} {batch_num}-{batch_num + len(batch) - 1}" if len(batch) > 1 else f"{title_prefix} {batch_num}"
        batches.append((batch, title))
    
    return batches


# Example usage:
# tables = [df1, df2, df3, df4, df5]
# batches = split_multiple_tables(tables, title_prefix="Sales Data")
# for batch, title in batches:
#     # Render each batch as a separate image
#     img_bytes = create_multi_table_image(batch, title=title)
```

## Related Skills
- [`image-processing-chat`](../image-processing-chat/SKILL.md) — For image handling and chat integration
- [`data-viz`](../data-viz/SKILL.md) — For broader data visualization techniques
- [`coding-standards`](../coding-standards/SKILL.md) — For consistent implementation patterns