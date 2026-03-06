#!/usr/bin/env python3
"""
Table Image Demo Script

This script demonstrates the table-image skill functionality by creating
table images from various data sources (DataFrame, CSV, JSON) and
demonstrating the 2-table limit feature.

Requirements:
    pip install pandas matplotlib seaborn pillow numpy

Usage:
    python demo_table_image.py
"""

import os
import json
import io
import base64
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image

# Configure matplotlib for better output
plt.rcParams['figure.dpi'] = 100
plt.rcParams['savefig.dpi'] = 150
plt.rcParams['font.size'] = 10

# Constants
MAX_TABLES_PER_IMAGE = 2
OUTPUT_DIR = os.path.join(os.path.dirname(__file__), 'demo_output')


# ============================================================================
# Core Functions from table-image/SKILL.md
# ============================================================================

def validate_table_count(tables: list) -> bool:
    """
    Validate that the number of tables does not exceed the maximum limit
    
    Args:
        tables: List of DataFrames or tables to validate
        
    Returns:
        True if valid
        
    Raises:
        ValueError: If more than MAX_TABLES_PER_IMAGE tables are provided
    """
    if len(tables) > MAX_TABLES_PER_IMAGE:
        raise ValueError(
            f"Maximum {MAX_TABLES_PER_IMAGE} tables per image allowed. "
            f"Found {len(tables)} tables. Please split into multiple images."
        )
    return True


def process_dataframe(df: pd.DataFrame, title: str = None, style: str = 'basic') -> bytes:
    """
    Process a pandas DataFrame into a table image
    
    Args:
        df: Pandas DataFrame to convert
        title: Optional title for the table
        style: Style to apply ('basic', 'professional', 'minimal', 'colorful')
        
    Returns:
        Image bytes in PNG format
    """
    # Define styles
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
    
    style_config = styles.get(style, styles['basic'])
    
    # Create figure
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
    table.set_fontsize(style_config['font_size'])
    table.scale(1.2, 1.5)
    
    # Apply alternating row colors
    for i in range(len(df)):
        for j in range(len(df.columns)):
            bg_color = style_config['row_even_bg'] if i % 2 == 0 else style_config['row_odd_bg']
            table[(i + 1, j)].set_facecolor(bg_color)
    
    # Style header
    for j in range(len(df.columns)):
        table[(0, j)].set_facecolor(style_config['header_bg'])
        table[(0, j)].set_text_props(weight='bold', color=style_config['header_fg'])
    
    if title:
        plt.title(title, fontsize=14, pad=20)
    
    # Save to bytes
    img_buffer = io.BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes


def process_csv(csv_string: str, title: str = None, style: str = 'basic') -> bytes:
    """
    Process CSV string into a table image
    
    Args:
        csv_string: CSV formatted string
        title: Optional title for the table
        style: Style to apply
        
    Returns:
        Image bytes in PNG format
    """
    df = pd.read_csv(io.StringIO(csv_string))
    return process_dataframe(df, title, style)


def process_json(json_string: str, title: str = None, style: str = 'basic') -> bytes:
    """
    Process JSON string into a table image
    
    Args:
        json_string: JSON formatted string (array of objects)
        title: Optional title for the table
        style: Style to apply
        
    Returns:
        Image bytes in PNG format
    """
    data = json.loads(json_string)
    df = pd.DataFrame(data)
    return process_dataframe(df, title, style)


def create_multi_table_image(tables: list, titles: list = None, style: str = 'basic') -> bytes:
    """
    Create an image with up to 2 tables displayed side by side
    
    Args:
        tables: List of DataFrames (max 2)
        titles: Optional list of titles for each table
        style: Style to apply to tables
        
    Returns:
        Image bytes in PNG format
        
    Raises:
        ValueError: If more than 2 tables are provided
    """
    # Validate table count
    validate_table_count(tables)
    
    if titles is None:
        titles = [f"Table {i+1}" for i in range(len(tables))]
    
    # Define styles
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
    
    style_config = styles.get(style, styles['basic'])
    
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
        table.set_fontsize(style_config['font_size'])
        table.scale(1.2, 1.5)
        
        # Apply alternating row colors
        for i in range(len(df)):
            for j in range(len(df.columns)):
                bg_color = style_config['row_even_bg'] if i % 2 == 0 else style_config['row_odd_bg']
                table[(i + 1, j)].set_facecolor(bg_color)
        
        # Style header
        for j in range(len(df.columns)):
            table[(0, j)].set_facecolor(style_config['header_bg'])
            table[(0, j)].set_text_props(weight='bold', color=style_config['header_fg'])
        
        # Add title
        ax.set_title(titles[idx], fontsize=14, pad=20, fontweight='bold')
    
    plt.tight_layout()
    
    # Save to bytes
    img_buffer = io.BytesIO()
    plt.savefig(img_buffer, format='png', bbox_inches='tight', dpi=150)
    img_buffer.seek(0)
    img_bytes = img_buffer.read()
    plt.close()
    
    return img_bytes


def save_image(img_bytes: bytes, filename: str) -> str:
    """
    Save image bytes to a file in the output directory
    
    Args:
        img_bytes: Image bytes to save
        filename: Name of the output file
        
    Returns:
        Full path to the saved file
    """
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    filepath = os.path.join(OUTPUT_DIR, filename)
    
    with open(filepath, 'wb') as f:
        f.write(img_bytes)
    
    return filepath


def encode_for_chat(img_bytes: bytes) -> str:
    """
    Encode image bytes to base64 for chat systems
    
    Args:
        img_bytes: Image bytes to encode
        
    Returns:
        Base64 encoded data URI string
    """
    encoded = base64.b64encode(img_bytes).decode('utf-8')
    return f"data:image/png;base64,{encoded}"


# ============================================================================
# Demo Functions
# ============================================================================

def demo_dataframe_table():
    """Demo: Create a table from a pandas DataFrame"""
    print("\n" + "="*60)
    print("Demo 1: Creating table from DataFrame")
    print("="*60)
    
    # Create sample DataFrame
    df = pd.DataFrame({
        'Product': ['Widget A', 'Widget B', 'Widget C', 'Widget D', 'Widget E'],
        'Sales': [1250, 1890, 2340, 980, 1560],
        'Profit': [250, 378, 468, 196, 312],
        'Margin (%)': [20.0, 20.0, 20.0, 20.0, 20.0]
    })
    
    print(f"\nDataFrame shape: {df.shape}")
    print(f"Columns: {list(df.columns)}")
    print("\nFirst few rows:")
    print(df.head())
    
    # Generate table image
    img_bytes = process_dataframe(df, title="Sales Report - Q1 2024", style='basic')
    
    # Save image
    filepath = save_image(img_bytes, 'demo_dataframe_table.png')
    print(f"\n✓ Table image saved to: {filepath}")
    
    # Show base64 preview (first 100 chars)
    encoded = encode_for_chat(img_bytes)
    print(f"✓ Base64 encoded (preview): {encoded[:100]}...")
    
    return filepath


def demo_csv_table():
    """Demo: Create a table from CSV string"""
    print("\n" + "="*60)
    print("Demo 2: Creating table from CSV string")
    print("="*60)
    
    # Sample CSV data
    csv_data = """Employee,Department,Salary,Years_Experience
John Smith,Engineering,95000,5
Jane Doe,Marketing,72000,3
Bob Johnson,Sales,68000,4
Alice Williams,Engineering,105000,7
Charlie Brown,Marketing,75000,4
Diana Prince,Sales,82000,6
Eve Davis,Engineering,88000,4
Frank Miller,HR,65000,3"""
    
    print("\nCSV Data:")
    print(csv_data)
    
    # Generate table image
    img_bytes = process_csv(csv_data, title="Employee Salary Report", style='professional')
    
    # Save image
    filepath = save_image(img_bytes, 'demo_csv_table.png')
    print(f"\n✓ Table image saved to: {filepath}")
    
    return filepath


def demo_json_table():
    """Demo: Create a table from JSON string"""
    print("\n" + "="*60)
    print("Demo 3: Creating table from JSON string")
    print("="*60)
    
    # Sample JSON data
    json_data = '''[
        {"City": "New York", "Population": 8419000, "Area_sq_mi": 302.6, "Density_per_sq_mi": 27832},
        {"City": "Los Angeles", "Population": 3976000, "Area_sq_mi": 468.7, "Density_per_sq_mi": 8484},
        {"City": "Chicago", "Population": 2716000, "Area_sq_mi": 227.3, "Density_per_sq_mi": 11949},
        {"City": "Houston", "Population": 2320000, "Area_sq_mi": 637.5, "Density_per_sq_mi": 3639},
        {"City": "Phoenix", "Population": 1680000, "Area_sq_mi": 517.6, "Density_per_sq_mi": 3246}
    ]'''
    
    print("\nJSON Data:")
    print(json_data)
    
    # Generate table image
    img_bytes = process_json(json_data, title="Major US Cities Statistics", style='colorful')
    
    # Save image
    filepath = save_image(img_bytes, 'demo_json_table.png')
    print(f"\n✓ Table image saved to: {filepath}")
    
    return filepath


def demo_multi_table():
    """Demo: Create image with 2 tables side by side"""
    print("\n" + "="*60)
    print("Demo 4: Creating multi-table image (2 tables)")
    print("="*60)
    
    # Create two DataFrames
    df1 = pd.DataFrame({
        'Quarter': ['Q1', 'Q2', 'Q3', 'Q4'],
        'Revenue': [120000, 145000, 168000, 192000],
        'Growth (%)': [12.5, 20.8, 15.9, 14.3]
    })
    
    df2 = pd.DataFrame({
        'Quarter': ['Q1', 'Q2', 'Q3', 'Q4'],
        'Expenses': [95000, 108000, 125000, 140000],
        'Margin (%)': [20.8, 25.5, 25.6, 27.1]
    })
    
    print("\nTable 1 - Revenue Data:")
    print(df1)
    print("\nTable 2 - Expenses Data:")
    print(df2)
    
    # Generate multi-table image
    img_bytes = create_multi_table_image(
        [df1, df2],
        titles=['Revenue Report 2024', 'Expenses Report 2024'],
        style='basic'
    )
    
    # Save image
    filepath = save_image(img_bytes, 'demo_multi_table.png')
    print(f"\n✓ Multi-table image saved to: {filepath}")
    
    return filepath


def demo_table_limit_validation():
    """Demo: Demonstrate the 2-table limit validation"""
    print("\n" + "="*60)
    print("Demo 5: Testing 2-table limit validation")
    print("="*60)
    
    # Create three DataFrames
    df1 = pd.DataFrame({'A': [1, 2], 'B': [3, 4]})
    df2 = pd.DataFrame({'C': [5, 6], 'D': [7, 8]})
    df3 = pd.DataFrame({'E': [9, 10], 'F': [11, 12]})
    
    print("\nAttempting to create image with 3 tables...")
    print(f"Table count: {len([df1, df2, df3])}")
    print(f"Maximum allowed: {MAX_TABLES_PER_IMAGE}")
    
    try:
        img_bytes = create_multi_table_image([df1, df2, df3])
        print("\n✗ UNEXPECTED: Should have raised ValueError!")
    except ValueError as e:
        print(f"\n✓ Expected error caught: {e}")
    
    # Show that 2 tables work
    print("\nCreating image with 2 tables (should succeed)...")
    img_bytes = create_multi_table_image([df1, df2], titles=['Table 1', 'Table 2'])
    filepath = save_image(img_bytes, 'demo_validation_2tables.png')
    print(f"✓ 2-table image saved to: {filepath}")
    
    return filepath


def demo_styling_options():
    """Demo: Show different styling options"""
    print("\n" + "="*60)
    print("Demo 6: Demonstrating different styling options")
    print("="*60)
    
    # Create sample DataFrame
    df = pd.DataFrame({
        'Metric': ['Users', 'Sessions', 'Page Views', 'Bounce Rate', 'Avg Duration'],
        'Value': [15420, 42890, 125600, '42.3%', '3m 45s'],
        'Change': ['+12.5%', '+8.2%', '+15.7%', '-3.1%', '+5.4%']
    })
    
    styles = ['basic', 'professional', 'minimal', 'colorful']
    
    for style in styles:
        print(f"\n  Generating table with '{style}' style...")
        img_bytes = process_dataframe(df, title=f"Analytics Dashboard - {style.title()} Style", style=style)
        filepath = save_image(img_bytes, f'demo_style_{style}.png')
        print(f"  ✓ Saved to: {filepath}")


# ============================================================================
# Main Execution
# ============================================================================

def main():
    """Main function to run all demos"""
    print("\n" + "="*60)
    print("TABLE IMAGE DEMO SCRIPT")
    print("="*60)
    print(f"\nOutput directory: {OUTPUT_DIR}")
    print(f"Max tables per image: {MAX_TABLES_PER_IMAGE}")
    
    try:
        # Run all demos
        demo_dataframe_table()
        demo_csv_table()
        demo_json_table()
        demo_multi_table()
        demo_table_limit_validation()
        demo_styling_options()
        
        # Summary
        print("\n" + "="*60)
        print("DEMO COMPLETE")
        print("="*60)
        print(f"\nAll images saved to: {OUTPUT_DIR}/")
        
        # List generated files
        if os.path.exists(OUTPUT_DIR):
            files = sorted([f for f in os.listdir(OUTPUT_DIR) if f.endswith('.png')])
            print(f"\nGenerated {len(files)} image files:")
            for f in files:
                print(f"  - {f}")
        
        print("\n✓ All demos completed successfully!")
        
    except Exception as e:
        print(f"\n✗ Error during demo execution: {e}")
        import traceback
        traceback.print_exc()
        return 1
    
    return 0


if __name__ == '__main__':
    exit(main())
