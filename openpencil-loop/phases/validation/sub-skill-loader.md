# Sub-Skill Loader Validation Hook Specification

## OVERVIEW

This validation hook ensures required sub-skill files are loaded before workflow execution. Prevents runtime failures from missing dependencies.

## VALIDATION MATRIX

| Role | Required Files | Full Path | Purpose |
|------|----------------|-----------|---------|
| **ORCHESTRATOR** | `orchestrator.ts` template | `openpencil-loop/workflows/orchestrator/dispatch.ts` | Dispatch automation templates |
| | `assignment-policy.md` | `openpencil-loop/knowledge/assignment-policy.md` | Agent assignment rules |
| | `workflow-gates.md` | `openpencil-loop/workflows/gates/workflow-gates.md` | Pre-flight check definitions |
| **SUBAGENT** | `schema.md` | `openpencil-loop/phases/generation/schema.md` | PenNode structure definition |
| | `layout-rules.md` | `openpencil-loop/phases/generation/layout-rules.md` | Auto-layout flexbox rules |
| | `role-definitions.md` | `openpencil-loop/knowledge/role-definitions.md` | Semantic roles (button, card, navbar, table) |
| | `design-system.md` | `openpencil-loop/phases/generation/design-system.md` | DESIGN.md token format |
| | `text-rules.md` | `openpencil-loop/phases/generation/text-rules.md` | Typography rules (CJK, line height) |
| **REVIEWER** | `schema.md` | `openpencil-loop/phases/generation/schema.md` | Verify node structure compliance |
| **ANALYZER** | `design-system.md` | `openpencil-loop/phases/generation/design-system.md` | Extract tokens from source |
| | `schema.md` | `openpencil-loop/phases/generation/schema.md` | Detect component patterns |

## VALIDATION FUNCTION SIGNATURE

```typescript
interface ValidationConfig {
  requiredFiles: string[];
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
 * Validates that all required sub-skill files are loaded before workflow execution.
 * 
 * @param config - Validation configuration with required files and role
 * @returns ValidationResult with status and remediation instructions
 */
async function validateSubSkills(config: ValidationConfig): Promise<ValidationResult> {
  const { requiredFiles, role } = config;
  
  // Check each file exists
  const loaded = await Promise.all(
    requiredFiles.map(f => filesystem.exists(f))
  );
  
  const missing = requiredFiles.filter((_, i) => !loaded[i]);
  
  if (missing.length > 0) {
    return {
      status: 'error',
      summary: `Required sub-skills not loaded for ${role}`,
      missing,
      nextActions: `Load missing files before proceeding.\nMissing:\n${missing.map(f => `- ${f}`).join('\n')}`
    };
  }
  
  return {
    status: 'success',
    summary: 'All required sub-skills loaded',
    loadOrder: requiredFiles
  };
}
```

## REMEDIATION STEPS

When validation fails, follow these recovery steps:

### 1. Verify File Existence

```bash
# Check if file exists in the repo
ls -la openpencil-loop/phases/generation/schema.md
```

### 2. Load Missing Files

```typescript
// For each missing file, load it explicitly
await filesystem.read_text_file({ path: 'openpencil-loop/phases/generation/schema.md' });
```

### 3. Update Workflow Globals

If using a workflow framework, ensure globals are populated:

```typescript
workflow.globals.subSkills = {
  schema: await loadFile('openpencil-loop/phases/generation/schema.md'),
  layoutRules: await loadFile('openpencil-loop/phases/generation/layout-rules.md'),
  roleDefinitions: await loadFile('openpencil-loop/knowledge/role-definitions.md')
};
```

### 4. Re-run Validation

```typescript
const result = await validateSubSkills({
  requiredFiles: ['openpencil-loop/phases/generation/schema.md'],
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
    requiredFiles: [
      'openpencil-loop/phases/generation/schema.md',
      'openpencil-loop/phases/generation/layout-rules.md',
      'openpencil-loop/knowledge/role-definitions.md',
      'openpencil-loop/phases/generation/design-system.md',
      'openpencil-loop/phases/generation/text-rules.md'
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
const requiredFiles = [
  'openpencil-loop/phases/generation/schema.md',
  'openpencil-loop/phases/generation/layout-rules.md',
  'openpencil-loop/knowledge/role-definitions.md',
  'openpencil-loop/phases/generation/design-system.md'
];

const loaded = await Promise.all(
  requiredFiles.map(f => filesystem.exists(f))
);

if (loaded.includes(false)) {
  return {
    status: "error",
    summary: "Required sub-skills not loaded",
    missing: requiredFiles.filter((_, i) => !loaded[i]),
    next_actions: "Read missing files before proceeding"
  };
}
```

## VALIDATION CONFIGURATION

### SUBAGENT Role

```typescript
{
  role: 'SUBAGENT',
  requiredFiles: [
    'openpencil-loop/phases/generation/schema.md',
    'openpencil-loop/phases/generation/layout-rules.md',
    'openpencil-loop/knowledge/role-definitions.md',
    'openpencil-loop/phases/generation/design-system.md',
    'openpencil-loop/phases/generation/text-rules.md'
  ]
}
```

### REVIEWER Role

```typescript
{
  role: 'REVIEWER',
  requiredFiles: [
    'openpencil-loop/phases/generation/schema.md'
  ]
}
```

### ANALYZER Role

```typescript
{
  role: 'ANALYZER',
  requiredFiles: [
    'openpencil-loop/phases/generation/design-system.md',
    'openpencil-loop/phases/generation/schema.md'
  ]
}
```

### ORCHESTRATOR Role

```typescript
{
  role: 'ORCHESTRATOR',
  requiredFiles: [
    'openpencil-loop/workflows/orchestrator/dispatch.ts',
    'openpencil-loop/knowledge/assignment-policy.md',
    'openpencil-loop/workflows/gates/workflow-gates.md'
  ]
}
```

## DAILY VALIDATION SCRIPT

```bash
#!/bin/bash
# openpencil-loop/phases/validation/validate-all.sh

# Run validation for each role
echo "=== SUBAGENT Validation ==="
npx validate-subskills --role SUBAGENT --files schema.md layout-rules.md role-definitions.md design-system.md text-rules.md

echo "=== REVIEWER Validation ==="
npx validate-subskills --role REVIEWER --files schema.md

echo "=== ANALYZER Validation ==="
npx validate-subskills --role ANALYZER --files design-system.md schema.md

echo "=== ORCHESTRATOR Validation ==="
npx validate-subskills --role ORCHESTRATOR --files dispatch.ts assignment-policy.md workflow-gates.md
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
