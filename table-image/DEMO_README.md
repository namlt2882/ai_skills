# Table Image Demo

This directory contains a demo script that verifies the Python code examples from `table-image/SKILL.md` can actually generate table images.

## Installation

1. Install the required dependencies:

```bash
pip install -r requirements.txt
```

Or install manually:

```bash
pip install pandas matplotlib seaborn pillow numpy
```

## Running the Demo

Execute the demo script:

```bash
python demo_table_image.py
```

## What the Demo Does

The demo script tests the following functions from `SKILL.md`:

### 1. `process_dataframe()` - DataFrame to Table Image
- Creates a table from a pandas DataFrame
- Demonstrates the "basic" styling option
- Saves output to: `demo_output/demo_dataframe_table.png`

### 2. `process_csv()` - CSV String to Table Image
- Parses a CSV string and converts to a table
- Demonstrates the "professional" styling option
- Saves output to: `demo_output/demo_csv_table.png`

### 3. `process_json()` - JSON String to Table Image
- Parses a JSON string (array of objects) and converts to a table
- Demonstrates the "colorful" styling option
- Saves output to: `demo_output/demo_json_table.png`

### 4. `create_multi_table_image()` - Multiple Tables Side by Side
- Creates an image with 2 tables displayed side by side
- Demonstrates the 2-table limit feature
- Saves output to: `demo_output/demo_multi_table.png`

### 5. `validate_table_count()` - Table Count Validation
- Tests that attempting to create an image with 3+ tables raises a `ValueError`
- Confirms that 2 tables work correctly
- Saves output to: `demo_output/demo_validation_2tables.png`

### 6. Styling Options Demo
- Generates the same table with 4 different styles:
  - `basic` - Green header, gray alternating rows
  - `professional` - Blue header, light blue alternating rows
  - `minimal` - Dark gray header, subtle alternating rows
  - `colorful` - Orange header, warm alternating rows
- Saves outputs to: `demo_output/demo_style_*.png`

## Output Files

All generated images are saved to the `demo_output/` directory:

- `demo_dataframe_table.png` - Table from DataFrame
- `demo_csv_table.png` - Table from CSV string
- `demo_json_table.png` - Table from JSON string
- `demo_multi_table.png` - Two tables side by side
- `demo_validation_2tables.png` - Validation test result
- `demo_style_basic.png` - Basic style example
- `demo_style_professional.png` - Professional style example
- `demo_style_minimal.png` - Minimal style example
- `demo_style_colorful.png` - Colorful style example

## Key Features Demonstrated

1. **Multiple Data Sources**: DataFrame, CSV, JSON
2. **Styling Options**: 4 predefined styles (basic, professional, minimal, colorful)
3. **2-Table Limit**: Maximum 2 tables per image with validation
4. **Base64 Encoding**: For chat system integration
5. **Error Handling**: Graceful handling of invalid inputs

## Troubleshooting

### "ModuleNotFoundError: No module named 'pandas'"
Install the required dependencies:
```bash
pip install -r requirements.txt
```

### "ValueError: Maximum 2 tables per image allowed"
This is expected behavior when trying to create an image with more than 2 tables. The demo includes a test that intentionally triggers this error to demonstrate the validation.

### Images not appearing in demo_output/
Make sure you have write permissions for the `table-image/` directory. The script will create the `demo_output/` subdirectory automatically.

## License

This demo script is provided as-is for testing and verification purposes.
