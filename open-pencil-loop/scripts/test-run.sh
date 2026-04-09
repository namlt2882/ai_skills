#!/bin/bash
set -e

# Run OpenPencil test case generation
# Usage: ./test-run.sh <eval-id> <eval-name> <workdir>

EVAL_ID="$1"
EVAL_NAME="$2"
WORKDIR="$3"
MINIMAL="$4"

if [ -z "$EVAL_ID" ] || [ -z "$EVAL_NAME" ] || [ -z "$WORKDIR" ]; then
    echo "Usage: ./test-run.sh <eval-id> <eval-name> <workdir> [minimal]"
    exit 1
fi

OUTPUT_DIR="$WORKDIR/eval-$EVAL_ID/with_skill/outputs"
mkdir -p "$OUTPUT_DIR"

echo "Running eval-$EVAL_ID: $EVAL_NAME"

# Copy project init script
cp "$(dirname "$0")/init-project.sh" "$OUTPUT_DIR/"

# Run minimal or full setup
if [ "$MINIMAL" = "minimal" ]; then
    echo "Running minimal test: init .op directory"
    cd "$OUTPUT_DIR" && bash init-project.sh .op test-design
else
    echo "Running full test: init .op directory and generate first design"
    cd "$OUTPUT_DIR" && bash init-project.sh .op test-design
    # Additional steps for full test...
fi

echo "Test completed. Output: $OUTPUT_DIR"