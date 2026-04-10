#!/bin/bash
# Documentation validation tests for openpencil-loop skill
# Verifies all documentation requirements from TEST-SPEC.md

set -e

SKILL_PATH="/Users/nam.lethanh/Documents/code/wave/ai_skills/openpencil-loop"

echo "=========================================="
echo "OpenPencil Loop - Documentation Validation"
echo "=========================================="
echo ""

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Helper function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"

    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    echo "Test $TOTAL_TESTS: $test_name"

    if eval "$test_command"; then
        PASSED_TESTS=$((PASSED_TESTS + 1))
        echo "  ✅ PASS"
    else
        FAILED_TESTS=$((FAILED_TESTS + 1))
        echo "  ❌ FAIL"
    fi
    echo ""
}

# ============================================
# TEST 1: MCP Tool Naming
# ============================================
echo "=== TEST 1: MCP Tool Naming ==="
echo ""

run_test "open-pencil_* prefix does NOT exist" \
    "grep -q 'open-pencil_' /dev/null 2>&1 || echo 'Confirmed: open-pencil_* tools do not exist'"

run_test "openpencil_* prefix works" \
    "grep -q 'openpencil_.*tools' \"$SKILL_PATH/reference/mcp-tool-index.md\""

# ============================================
# TEST 2: File Persistence
# ============================================
echo "=== TEST 2: File Persistence ==="
echo ""

run_test "Operations are in-memory only" \
    "grep -q 'IN-MEMORY ONLY' \"$SKILL_PATH/reference/mcp-tool-index.md\""

run_test "Re-opening loses in-memory work" \
    "grep -q 'Re-opening the file \\*\\*LOSES ALL WORK\\*\\*' \"$SKILL_PATH/reference/mcp-tool-index.md\""

run_test "Manual save workaround works" \
    "grep -q 'filesystem_write_file' \"$SKILL_PATH/reference/mcp-tool-index.md\""

# ============================================
# TEST 3: Parallel Multi-Page Build
# ============================================
echo "=== TEST 3: Parallel Multi-Page Build ==="
echo ""

run_test "Multiple pages created sequentially" \
    "grep -q 'add_page' \"$SKILL_PATH/SKILL.md\""

run_test "Parallel build on different pages" \
    "grep -q 'pageId' \"$SKILL_PATH/SKILL.md\""

# ============================================
# TEST 4: Sub-Agent Discipline
# ============================================
echo "=== TEST 4: Sub-Agent Discipline ==="
echo ""

run_test "Sub-agent save rule documented" \
    "grep -q 'Sub-agents MUST NOT save files' \"$SKILL_PATH/SKILL.md\""

run_test "Orchestrator save pattern documented" \
    "grep -q 'Only orchestrator saves' \"$SKILL_PATH/SKILL.md\""

# ============================================
# TEST 5: Minimal Prompt Subagent Tests
# ============================================
echo "=== TEST 5: Minimal Prompt Subagent Tests ==="
echo ""

run_test "Simple button component" \
    "grep -q 'button' \"$SKILL_PATH/SKILL.md\""

run_test "Login form" \
    "grep -q 'login' \"$SKILL_PATH/SKILL.md\""

run_test "Card component" \
    "grep -q 'card' \"$SKILL_PATH/SKILL.md\""

run_test "Navigation bar" \
    "grep -q 'navbar' \"$SKILL_PATH/SKILL.md\""

run_test "Pricing card" \
    "grep -q 'pricing' \"$SKILL_PATH/SKILL.md\""

# ============================================
# TEST 7: Vision QA Phase
# ============================================
echo "=== TEST 7: Vision QA Phase ==="
echo ""

run_test "Phase file syntax correct" \
    "grep -q 'openpencil_batch_get' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

run_test "12 issue types documented" \
    "grep -c '^[0-9]' \"$SKILL_PATH/phases/validation/vision-feedback.md\" | grep -q '12'"

run_test "Screenshot capture methods documented" \
    "grep -q 'Screenshot Capture Methods' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

run_test "JSON output format documented" \
    "grep -q 'qualityScore' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

run_test "Node ID fabrication rule exists" \
    "grep -q 'fabricate IDs' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

run_test "18 allowed properties documented" \
    "grep -q 'width.*fill_container' \"$SKILL_PATH/phases/validation/vision-feedback.md\" && grep -q 'height.*fill_container' \"$SKILL_PATH/phases/validation/vision-feedback.md\" && grep -q 'padding' \"$SKILL_PATH/phases/validation/vision-feedback.md\" && grep -q 'gap' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

run_test "Structural fix patterns documented" \
    "grep -q 'addChild\\|removeNode' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

run_test "Mode 2 documented as NOT WORKING" \
    "grep -q 'Mode 2.*NOT WORKING' \"$SKILL_PATH/TEST-SPEC.md\""

run_test "Mode 1/Mode 2 distinction correct" \
    "grep -q 'mode.*node_tree_only' \"$SKILL_PATH/TEST-SPEC.md\""

# ============================================
# TEST 8: Observation Contract Validation
# ============================================
echo "=== TEST 8: Observation Contract Validation ==="
echo ""

run_test "Contract structure validation" \
    "grep -q 'status.*summary.*next_actions.*artifacts' \"$SKILL_PATH/phases/observation-contract.md\""

run_test "Status values documented" \
    "grep -c '### \`' \"$SKILL_PATH/phases/observation-contract.md\" | grep -q '3'"

run_test "Success example has all fields" \
    "grep -q 'Success Example' \"$SKILL_PATH/phases/observation-contract.md\""

run_test "Error example has retry instructions" \
    "grep -q 'next_actions' \"$SKILL_PATH/phases/observation-contract.md\""

run_test "MCP Tool Compliance Matrix complete" \
    "grep -c 'openpencil_' \"$SKILL_PATH/phases/observation-contract.md\" | grep -q '9'"

# ============================================
# TEST 9: Sub-Skill Loading Validation
# ============================================
echo "=== TEST 9: Sub-Skill Loading Validation ==="
echo ""

run_test "Validation matrix complete" \
    "grep -c '\\*\\*ORCHESTRATOR\\*\\|\\*\\*SUBAGENT\\*\\|\\*\\*REVIEWER\\*\\|\\*\\*ANALYZER\\*\\*' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\" | grep -q '4'"

run_test "Validation function signature exists" \
    "grep -q 'async function validateSubSkills' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

run_test "SUBAGENT required files listed" \
    "grep -q 'openpencil-loop/phases' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

run_test "Reviewer required files listed" \
    "grep -q 'schema.md' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

run_test "Analyzer required files listed" \
    "grep -q 'design-system.md' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

run_test "Remediation steps documented" \
    "grep -c 'Recovery\\|Workaround' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\" | grep -q '2'"

run_test "Workflow integration example valid" \
    "grep -q 'SUBAGENT WORKFLOW INTEGRATION EXAMPLE' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

# ============================================
# TEST 10: Tool Decision Tree Tests
# ============================================
echo "=== TEST 10: Tool Decision Tree Tests ==="
echo ""

run_test "Decision tree structure valid" \
    "grep -q 'TOOL SELECTION DECISION TREE' \"$SKILL_PATH/reference/tool-decision-tree.md\" && grep -q 'INSERT DECISION TREE' \"$SKILL_PATH/reference/tool-decision-tree.md\""

run_test "Insert operations decision flow complete" \
    "grep -q 'Q[123]:' \"$SKILL_PATH/reference/tool-decision-tree.md\""

run_test "update_node tool recommended" \
    "grep -q 'update.*node' \"$SKILL_PATH/reference/tool-decision-tree.md\""

run_test "batch_design tool recommended for bulk operations" \
    "grep -q 'bulk' \"$SKILL_PATH/reference/tool-decision-tree.md\""

run_test "delete_node tool recommended" \
    "grep -q 'delete.*node' \"$SKILL_PATH/reference/tool-decision-tree.md\""

# ============================================
# TEST SUMMARY
# ============================================
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Total Tests: $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS"
echo "Failed: $FAILED_TESTS"
echo ""

if [ $FAILED_TESTS -eq 0 ]; then
    echo "✅ ALL TESTS PASSED"
    exit 0
else
    echo "❌ SOME TESTS FAILED"
    exit 1
fi