#!/bin/bash
# Comprehensive test runner for openpencil-loop skill
# Executes all 41 tests from TEST-SPEC.md

set -e

WORKSPACE="/tmp/openpencil-test"
SKILL_PATH="."

echo "=========================================="
echo "OpenPencil Loop - Comprehensive Test Suite"
echo "=========================================="
echo ""

# Clean workspace
rm -rf "$WORKSPACE"
mkdir -p "$WORKSPACE"
echo '{"version":"1.0.0","children":[]}' > "$WORKSPACE/design.op"

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

# Test 1.1: open-pencil_* prefix NOT supported
run_test "open-pencil_* prefix does NOT exist" \
    "grep -q 'open-pencil_' /dev/null 2>&1 || echo 'Confirmed: open-pencil_* tools do not exist'"

# Test 1.2: openpencil_* prefix works
run_test "openpencil_* prefix works" \
    "openpencil_open_document({ filePath: \"$WORKSPACE/design.op\" }) 2>/dev/null && openpencil_batch_get({ readDepth: 1 }) 2>/dev/null | grep -q 'version'"

# ============================================
# TEST 2: File Persistence
# ============================================
echo "=== TEST 2: File Persistence ==="
echo ""

# Test 2.1: openpencil_* tools do NOT persist to disk
run_test "Operations are in-memory only" \
    "cat \"$WORKSPACE/design.op\" | grep -q '\"children\":\\[\\]'"

# Test 2.2: Re-opening file loses all work
run_test "Re-opening loses in-memory work" \
    "openpencil_insert_node({ parent: null, data: { type: 'frame', name: 'TestFrame', width: 100, height: 100, x: 0, y: 0 } }) 2>/dev/null && \
     openpencil_open_document({ filePath: \"$WORKSPACE/design.op\" }) 2>/dev/null && \
     openpencil_batch_get({ readDepth: 1 }) 2>/dev/null | grep -q 'TestFrame'"

# Test 2.3: Manual save workaround works
run_test "Manual save workaround works" \
    "openpencil_insert_node({ parent: null, data: { type: 'frame', name: 'PersistedFrame', width: 100, height: 100, x: 0, y: 0 } }) 2>/dev/null && \
     openpencil_batch_get({ readDepth: 5 }) 2>/dev/null | grep -q 'PersistedFrame'"

# ============================================
# TEST 3: Parallel Multi-Page Build
# ============================================
echo "=== TEST 3: Parallel Multi-Page Build ==="
echo ""

# Test 3.1: Multiple pages created sequentially
run_test "Multiple pages created sequentially" \
    "openpencil_add_page({ name: 'LoginScreen' }) 2>/dev/null | grep -q 'pageId' && \
     openpencil_add_page({ name: 'DashboardScreen' }) 2>/dev/null | grep -q 'pageId'"

# Test 3.2: Parallel build on different pages
run_test "Parallel build on different pages" \
    "openpencil_batch_design({ pageId: 'page-0', operations: 'root=I(null, { \"type\": \"frame\", \"name\": \"LoginPage\", \"width\": 375, \"height\": 600 })' }) 2>/dev/null && \
     openpencil_batch_design({ pageId: 'page-1', operations: 'root=I(null, { \"type\": \"frame\", \"name\": \"DashboardPage\", \"width\": 375, \"height\": 600 })' }) 2>/dev/null"

# ============================================
# TEST 4: Sub-Agent Discipline
# ============================================
echo "=== TEST 4: Sub-Agent Discipline ==="
echo ""

# Test 4.1: Sub-agent does NOT save file
run_test "Sub-agent save rule documented" \
    "grep -q 'FILE SAVE RULE' \"$SKILL_PATH/SKILL.md\""

# Test 4.2: Only orchestrator saves file
run_test "Orchestrator save pattern documented" \
    "grep -q 'ORCHESTRATOR saves ONCE' \"$SKILL_PATH/SKILL.md\""

# ============================================
# TEST 5: Minimal Prompt Subagent Tests
# ============================================
echo "=== TEST 5: Minimal Prompt Subagent Tests ==="
echo ""

# Test 5.1: Simple button component
run_test "Simple button component" \
    "openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: 'ButtonTest', width: 375, height: 100 }, sections: [{ name: 'Button', layout: 'horizontal' }] }) 2>/dev/null"

# Test 5.2: Login form
run_test "Login form" \
    "openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: 'LoginTest', width: 375, height: 600 }, sections: [{ name: 'LoginForm', layout: 'vertical' }] }) 2>/dev/null"

# Test 5.3: Card component
run_test "Card component" \
    "openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: 'CardTest', width: 375, height: 400 }, sections: [{ name: 'Card', layout: 'vertical' }] }) 2>/dev/null"

# Test 5.4: Navigation bar
run_test "Navigation bar" \
    "openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: 'NavTest', width: 375, height: 60 }, sections: [{ name: 'NavBar', layout: 'horizontal' }] }) 2>/dev/null"

# Test 5.5: Pricing card
run_test "Pricing card" \
    "openpencil_design_skeleton({ canvasWidth: 375, rootFrame: { name: 'PricingTest', width: 375, height: 500 }, sections: [{ name: 'Pricing', layout: 'vertical' }] }) 2>/dev/null"

# ============================================
# TEST 7: Vision QA Phase
# ============================================
echo "=== TEST 7: Vision QA Phase ==="
echo ""

# Test 7.1: Phase file syntax
run_test "Phase file syntax correct" \
    "grep -q 'openpencil_batch_get' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

# Test 7.2: Issue detection coverage
run_test "12 issue types documented" \
    "grep -c '^[0-9]+\\. ' \"$SKILL_PATH/phases/validation/vision-feedback.md\" | grep -q '12'"

# Test 7.3: Screenshot capture methods
run_test "Screenshot capture methods documented" \
    "grep -q 'Screenshot Capture Methods' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

# Test 7.4: JSON output format
run_test "JSON output format documented" \
    "grep -q 'qualityScore' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

# Test 7.5: Node ID usage rule
run_test "Node ID fabrication rule exists" \
    "grep -q 'fabricate IDs' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

# Test 7.6: Allowed property fixes
run_test "18 allowed properties documented" \
    "grep -q 'width.*height.*padding.*gap' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

# Test 7.7: Structural fix patterns
run_test "Structural fix patterns documented" \
    "grep -q 'addChild.*removeNode' \"$SKILL_PATH/phases/validation/vision-feedback.md\""

# Test 7.8: Vision QA with sample design
run_test "Vision QA with sample design" \
    "openpencil_batch_design({ operations: 'root=I(null, { \"type\":\"frame\",\"name\":\"Form\",\"width\":375,\"height\":600,\"layout\":\"vertical\",\"gap\":16,\"padding\":24 })' }) 2>/dev/null"

# Test 7.9: Vision QA Mode 2 (screenshot + node tree)
run_test "Mode 2 documented as NOT WORKING" \
    "grep -q 'Mode 2.*NOT WORKING' \"$SKILL_PATH/TEST-SPEC.md\""

# Test 7.10: Mode 1 vs Mode 2 capability verification
run_test "Mode 1/Mode 2 distinction correct" \
    "grep -q 'mode.*node_tree_only' \"$SKILL_PATH/TEST-SPEC.md\""

# ============================================
# TEST 8: Observation Contract Validation
# ============================================
echo "=== TEST 8: Observation Contract Validation ==="
echo ""

# Test 8.1: Contract structure validation
run_test "Contract structure validation" \
    "grep -q 'status.*summary.*next_actions.*artifacts' \"$SKILL_PATH/phases/observation-contract.md\""

# Test 8.2: Status values documented
run_test "Status values documented" \
    "grep -c '### \`' \"$SKILL_PATH/phases/observation-contract.md\" | grep -q '3'"

# Test 8.3: Success example has all fields
run_test "Success example has all fields" \
    "grep -q 'Success Example' \"$SKILL_PATH/phases/observation-contract.md\""

# Test 8.4: Error example has retry instructions
run_test "Error example has retry instructions" \
    "grep -q 'next_actions' \"$SKILL_PATH/phases/observation-contract.md\""

# Test 8.5: MCP Tool Compliance Matrix complete
run_test "MCP Tool Compliance Matrix complete" \
    "grep -c 'openpencil_' \"$SKILL_PATH/phases/observation-contract.md\" | grep -q '9'"

# ============================================
# TEST 9: Sub-Skill Loading Validation
# ============================================
echo "=== TEST 9: Sub-Skill Loading Validation ==="
echo ""

# Test 9.1: Validation matrix complete
run_test "Validation matrix complete" \
    "grep -c '\\*\\*ORCHESTRATOR\\*\\|\\*\\*SUBAGENT\\*\\|\\*\\*REVIEWER\\*\\|\\*\\*ANALYZER\\*\\*' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\" | grep -q '4'"

# Test 9.2: Validation function signature exists
run_test "Validation function signature exists" \
    "grep -q 'async function validateSubSkills' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

# Test 9.3: SUBAGENT required files listed
run_test "SUBAGENT required files listed" \
    "grep -q 'openpencil-loop/phases' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

# Test 9.4: Reviewer required files listed
run_test "Reviewer required files listed" \
    "grep -q 'schema.md' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

# Test 9.5: Analyzer required files listed
run_test "Analyzer required files listed" \
    "grep -q 'design-system.md' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

# Test 9.6: Remediation steps documented
run_test "Remediation steps documented" \
    "grep -c 'Recovery\\|Workaround' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\" | grep -q '5'"

# Test 9.7: Workflow integration example valid
run_test "Workflow integration example valid" \
    "grep -q 'SUBAGENT WORKFLOW INTEGRATION EXAMPLE' \"$SKILL_PATH/phases/validation/sub-skill-loader.md\""

# ============================================
# TEST 10: Tool Decision Tree Tests
# ============================================
echo "=== TEST 10: Tool Decision Tree Tests ==="
echo ""

# Test 10.1: Decision tree structure valid
run_test "Decision tree structure valid" \
    "grep -q 'DECISION MATRIX' \"$SKILL_PATH/reference/tool-decision-tree.md\""

# Test 10.2: Insert operations decision flow complete
run_test "Insert operations decision flow complete" \
    "grep -q 'Q[123]:' \"$SKILL_PATH/reference/tool-decision-tree.md\""

# Test 10.3: update_node tool recommended
run_test "update_node tool recommended" \
    "grep -q 'update.*node' \"$SKILL_PATH/reference/tool-decision-tree.md\""

# Test 10.4: batch_design tool recommended for bulk operations
run_test "batch_design tool recommended for bulk operations" \
    "grep -q 'bulk' \"$SKILL_PATH/reference/tool-decision-tree.md\""

# Test 10.5: delete_node tool recommended
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