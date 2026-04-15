# Sub-Skill Loader Validation Hook Specification

## OVERVIEW

This validation hook ensures required sub-skill files are loaded before workflow execution. Prevents runtime failures from missing dependencies.

## VALIDATION MATRIX

| Role | Required Sources | Type | Purpose |
|------|-----------------|------|---------|
| **ORCHESTRATOR** | `workflow.md` | File: `openpencil-loop/phases/orchestrator/workflow.md` | Orchestrator workflow (dispatch, baton-passing) |
| **SUBAGENT** | MCP `openpencil_get_design_prompt({ section: "schema" })` | MCP call | PenNode structure definition |
| | MCP `openpencil_get_design_prompt({ section: "layout" })` | MCP call | Auto-layout flexbox rules |
| | `role-definitions.md` | File: `openpencil-loop/knowledge/role-definitions.md` | Semantic roles (button, card, navbar, table) |
| | `design-system.md` | File: `openpencil-loop/phases/generation/design-system.md` | DESIGN.md token format |
| | MCP `openpencil_get_design_prompt({ section: "text" })` | MCP call | Typography rules (CJK, line height) |
| **REVIEWER** | MCP `openpencil_get_design_prompt({ section: "schema" })` | MCP call | Verify node structure compliance |
| **ANALYZER** | `design-system.md` | File: `openpencil-loop/phases/generation/design-system.md` | Extract tokens from source |
| | MCP `openpencil_get_design_prompt({ section: "schema" })` | MCP call | Detect component patterns |

## VALIDATION FUNCTION SIGNATURE

```typescript
interface McpSource {
  type: 'file' | 'mcp';
  /** For type='file': file path. For type='mcp': section name for openpencil_get_design_prompt */
  key: string;
}

interface ValidationConfig {
  /** Required sources — mix of file paths and MCP section names */
  requiredSources: McpSource[];
  role: 'ORCHESTRATOR' | 'SUBAGENT' | 'REVIEWER' | 'ANALYZER';
}

interface ValidationResult {
  status: 'success' | 'error';
  summary: string;
  missing?: string[];
  loadOrder?: string[];
  nextActions?: string;
}

/**
 * Validates that all required sub-skill sources are available before workflow execution.
 * Sources may be local files or MCP calls (openpencil_get_design_prompt).
 * 
 * @param config - Validation configuration with required sources and role
 * @returns ValidationResult with status and remediation instructions
 */
async function validateSubSkills(config: ValidationConfig): Promise<ValidationResult> {
  const { requiredSources, role } = config;
  
  const results = await Promise.all(
    requiredSources.map(async (src) => {
      if (src.type === 'file') {
        return filesystem.exists(src.key);
      }
      // MCP source — probe with a lightweight call
      try {
        await openpencil_get_design_prompt({ section: src.key });
        return true;
      } catch {
        return false;
      }
    })
  );
  
  const missing = requiredSources.filter((_, i) => !results[i]).map(s => s.key);
  
  if (missing.length > 0) {
    return {
      status: 'error',
      summary: `Required sub-skills not loaded for ${role}`,
      missing,
      nextActions: `Load missing sources before proceeding.\nMissing:\n${missing.map(k => `- ${k}`).join('\n')}`
    };
  }
  
  return {
    status: 'success',
    summary: 'All required sub-skills loaded',
    loadOrder: requiredSources.map(s => s.key)
  };
}
```

## REMEDIATION STEPS

When validation fails, follow these recovery steps:

### 1. Verify MCP Availability

```bash
# Check that the MCP server is reachable (section probe)
# The openpencil_get_design_prompt tool should respond without error
```

### 2. Load Missing MCP Sections

```typescript
// For MCP-based sources, call openpencil_get_design_prompt with the section name
const schemaResult = await openpencil_get_design_prompt({ section: 'schema' });
const layoutResult = await openpencil_get_design_prompt({ section: 'layout' });
const textResult   = await openpencil_get_design_prompt({ section: 'text' });

// For file-based sources (role-definitions, design-system), use filesystem
await filesystem.read_text_file({ path: 'openpencil-loop/knowledge/role-definitions.md' });
await filesystem.read_text_file({ path: 'openpencil-loop/phases/generation/design-system.md' });
```

### 3. Update Workflow Globals

If using a workflow framework, ensure globals are populated:

```typescript
workflow.globals.subSkills = {
  schema: await openpencil_get_design_prompt({ section: 'schema' }),
  layoutRules: await openpencil_get_design_prompt({ section: 'layout' }),
  roleDefinitions: await filesystem.read_text_file({ path: 'openpencil-loop/knowledge/role-definitions.md' })
};
```

### 4. Re-run Validation

```typescript
const result = await validateSubSkills({
  requiredSources: [
    { type: 'mcp', key: 'schema' },
    { type: 'mcp', key: 'layout' },
    { type: 'file', key: 'openpencil-loop/knowledge/role-definitions.md' }
  ],
  role: 'SUBAGENT'
});

if (result.status === 'error') {
  throw new Error(result.nextActions);
}
```

## SUBAGENT WORKFLOW INTEGRATION EXAMPLE

```typescript
// At start of SUBAGENT workflow, in the P0 pre-flight checklist
async function subagentWorkflow() {
  const subagentValidation = await validateSubSkills({
    requiredSources: [
      { type: 'mcp', key: 'schema' },
      { type: 'mcp', key: 'layout' },
      { type: 'file', key: 'openpencil-loop/knowledge/role-definitions.md' },
      { type: 'file', key: 'openpencil-loop/phases/generation/design-system.md' },
      { type: 'mcp', key: 'text' }
    ],
    role: 'SUBAGENT'
  });

  if (subagentValidation.status === 'error') {
    // Halt workflow execution
    return {
      status: 'blocked',
      reason: 'Sub-skill validation failed',
      missing: subagentValidation.missing,
      remediation: subagentValidation.nextActions
    };
  }

  // Safe to proceed - all files loaded
  await generateDesignSystem();
  await createLayoutSkeleton();
  // ... rest of workflow
}
```

## VALIDATION GATES

| Gate | Trigger | Action on Fail |
|------|---------|----------------|
| **P0 Pre-flight** | Agent starts workflow | Block execution, return error |
| **P1 StateSync** | After file I/O operations | Warn, continue with fallback |
| **P2 ResourceCheck** | Before MCP tool calls | Re-validate, retry once |

## INTEGRATION CHECKLIST

- [ ] Add `validateSubSkills()` call at workflow start (P0 pre-flight)
- [ ] Include role-specific required files in validation config
- [ ] Log missing files to diagnostic channel
- [ ] Return early with error if validation fails
- [ ] Only proceed if `status === 'success'`
- [ ] Update workflow globals after successful validation

## ERROR SCENARIOS

| Scenario | Error Status | Recovery |
|----------|--------------|----------|
| File doesn't exist in repo | `status: 'error'` | Load file from parent directory |
| Path incorrect in repo | `status: 'error'` | Verify path in SKILL.md matrix |
| Agent proceeds without validation | `status: 'error'` (late) | Add P0 gate, block execution |

## DRAFT IMPLEMENTATION

See `.sisyphus/drafts/openpencil-loop-harness-review.md` lines 444-463 for draft implementation pattern.

### Draft Code Template

```javascript
// At start of SUBAGENT workflow
const requiredSources = [
  { type: 'mcp', key: 'schema' },
  { type: 'mcp', key: 'layout' },
  { type: 'file', key: 'openpencil-loop/knowledge/role-definitions.md' },
  { type: 'file', key: 'openpencil-loop/phases/generation/design-system.md' },
  { type: 'mcp', key: 'text' }
];

const results = await Promise.all(
  requiredSources.map(async (src) => {
    if (src.type === 'file') return filesystem.exists(src.key);
    try { await openpencil_get_design_prompt({ section: src.key }); return true; }
    catch { return false; }
  })
);

if (results.includes(false)) {
  return {
    status: "error",
    summary: "Required sub-skills not loaded",
    missing: requiredSources.filter((_, i) => !results[i]).map(s => s.key),
    next_actions: "Load missing MCP sections or files before proceeding"
  };
}
```

## VALIDATION CONFIGURATION

### SUBAGENT Role

```typescript
{
  role: 'SUBAGENT',
  requiredSources: [
    { type: 'mcp', key: 'schema' },
    { type: 'mcp', key: 'layout' },
    { type: 'file', key: 'openpencil-loop/knowledge/role-definitions.md' },
    { type: 'file', key: 'openpencil-loop/phases/generation/design-system.md' },
    { type: 'mcp', key: 'text' }
  ]
}
```

### REVIEWER Role

```typescript
{
  role: 'REVIEWER',
  requiredSources: [
    { type: 'mcp', key: 'schema' }
  ]
}
```

### ANALYZER Role

```typescript
{
  role: 'ANALYZER',
  requiredSources: [
    { type: 'file', key: 'openpencil-loop/phases/generation/design-system.md' },
    { type: 'mcp', key: 'schema' }
  ]
}
```

### ORCHESTRATOR Role

```typescript
{
  role: 'ORCHESTRATOR',
  requiredSources: [
    { type: 'file', key: 'openpencil-loop/phases/orchestrator/workflow.md' }
  ]
}
```

## DAILY VALIDATION SCRIPT

```bash
#!/bin/bash
# openpencil-loop/phases/validation/validate-all.sh

# Run validation for each role
echo "=== SUBAGENT Validation ==="
npx validate-subskills --role SUBAGENT --mcp-sections schema layout text --files role-definitions.md design-system.md

echo "=== REVIEWER Validation ==="
npx validate-subskills --role REVIEWER --mcp-sections schema

echo "=== ANALYZER Validation ==="
npx validate-subskills --role ANALYZER --mcp-sections schema --files design-system.md

echo "=== ORCHESTRATOR Validation ==="
npx validate-subskills --role ORCHESTRATOR --files workflow.md
```

## KNOWN ISSUES

| Issue | Status | Workaround |
|-------|--------|------------|
| Validation runs after agent starts | `open` | Move to workflow P0 entry point |
| No automatic reload if file added | `open` | Re-run validation manually |
| Path varies per repo structure | `open` | Use SKILL.md as source of truth |

## VERSION HISTORY

| Version | Date | Changes |
|---------|------|---------|
| 0.1.0 | 2026-04-10 | Initial specification |
