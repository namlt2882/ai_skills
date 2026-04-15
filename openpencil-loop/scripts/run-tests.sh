#!/bin/bash
# Test runner for openpencil-loop skill
# This script runs the basic integration tests from TEST-SPEC.md

set -e

WORKSPACE="./openpencil-loop-workspace"
SKILL_PATH="."

echo "=========================================="
echo "OpenPencil Loop - Basic Integration Tests"
echo "=========================================="
echo ""

# Clean workspace
rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE/iteration-1"

# Test 1: Initialize new project
echo ""
echo "=== Test 1: Initialize New Project ==="
mkdir -p "$WORKSPACE/iteration-1/eval-0-with_skill/outputs"
cd "$WORKSPACE/iteration-1/eval-0-with_skill/outputs"
cp "$SKILL_PATH/scripts/init-project.sh" .
SKILL_ROOT="$SKILL_PATH" bash init-project.sh .op landing-hero

# Test 2: Continue existing loop
echo ""
echo "=== Test 2: Continue Existing Loop ==="
mkdir -p "$WORKSPACE/iteration-1/eval-1-with_skill/outputs"
cd "$WORKSPACE/iteration-1/eval-1-with_skill/outputs"
cp "$SKILL_PATH/scripts/init-project.sh" .
SKILL_ROOT="$SKILL_PATH" bash init-project.sh .op pricing-cards
echo "Updated .op/next-prompt.md with next task" > .op/next-prompt.md

# Test 3: Multi-page mobile loop
echo ""
echo "=== Test 3: Multi-page Mobile Loop ==="
mkdir -p "$WORKSPACE/iteration-1/eval-2-with_skill/outputs"
cd "$WORKSPACE/iteration-1/eval-2-with_skill/outputs"
cp "$SKILL_PATH/scripts/init-project.sh" .
SKILL_ROOT="$SKILL_PATH" bash init-project.sh .op login-screen --device mobile
echo "Updated .op/next-prompt.md with dashboard task" > .op/next-prompt.md

echo ""
echo "=== All Tests Completed ==="
echo "Workspace: $WORKSPACE/iteration-1"
echo ""
ls -la "$WORKSPACE/iteration-1"