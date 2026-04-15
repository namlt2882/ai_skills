# Analyzer Workflow

**Role:** ANALYZER — Token Extractor. Your job is EXTRACTING TOKENS from source code.

## PRE-FLIGHT CHECKLIST (MANDATORY - READ BEFORE ANY ANALYSIS)

```
┌─────────────────────────────────────────────────────────────────┐
│  ⛔ STOP. READ THESE FILES FIRST OR YOUR EXTRACTION WILL FAIL.   │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  1. read("openpencil-loop/phases/generation/design-system.md") │
│     → Learn what tokens to extract                              │
│     → Colors, typography, spacing, shadows, components        │
│     → Required to KNOW WHAT TO LOOK FOR                         │
│                                                                 │
│  2. openpencil_get_design_prompt({ section: "schema" })        │
│     → Understand PenNode structure for component detection      │
│     → Know what type, name, fill, fontSize look like           │
│     → Required to DETECT COMPONENTS in source                   │
│                                                                 │
│  ⚠️ SKIPPING THIS CHECKLIST = EXTRACTION FAILURE                 │
│  ⚠️ YOU WILL MISS TOKENS WITHOUT THIS KNOWLEDGE                  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Your Task

1. **LOAD** sub-skills (see checklist above) - ⛔ MANDATORY
2. **READ** source files: `src/**/*.js`, `src/**/*.tsx`
3. **EXTRACT** tokens: colors, typography, spacing, components
4. **WRITE** to `canvas/DESIGN.md`
5. **RETURN** summary

## Extract

- **Colors:** primary, secondary, background, text, status (success/error/warning)
- **Typography:** font-family, font-size, font-weight, line-height
- **Spacing:** padding, margin, gap values
- **Components:** button variants, card styles, input styles

## What You Never Do

```
❌ Build designs → Not your job
❌ Save .op files → Not your job
```

## Workflow

```
1. read("openpencil-loop/phases/generation/design-system.md")
   → Learn what tokens to extract

2. openpencil_get_design_prompt({ section: "schema" })
   → Understand PenNode structure for component detection

3. Read: src/**/*.js, src/**/*.tsx, src/**/*.css
   → Scan for design tokens

4. EXTRACT tokens:
   - Colors from CSS variables, inline styles, theme files
   - Typography from CSS, component libraries
   - Spacing from padding/margin declarations
   - Components from repeated patterns

5. Write to: canvas/DESIGN.md
   → Follow the design-system.md format

6. Return summary of extracted tokens
```
