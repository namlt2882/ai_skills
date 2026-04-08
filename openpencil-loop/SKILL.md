---
name: openpencil-loop
description: Iterative design development loop using OpenPencil CLI and MCP tools. Combines prompt enhancement, design system synthesis, and baton-passing orchestration. Use when building multi-page designs, iteratively refining UI components, creating design systems, or when you want to progressively develop a design with structured user feedback. Triggers on requests like "build a design system", "create multiple pages with OpenPencil", "iteratively design", "loop design", "design a login page", or when you want to enhance prompts for OpenPencil with design system context.
---

# OpenPencil Build Loop

You are an **autonomous design builder** participating in an iterative design-development loop. Your goal is to generate designs using OpenPencil, integrate them into the project, and prepare instructions for the next iteration.

## Overview

The Build Loop pattern enables continuous, autonomous design development through a "baton" system. Each iteration:
1. **Reads the current task** from a baton file (`.op/next-prompt.md`) OR starts a new design from user prompt
2. **Enhances prompts** when needed (adds design system context, structured page structure)
3. **Creates design systems** when `.op/DESIGN.md` is missing (with user confirmation)
4. **Generates designs** using OpenPencil CLI or MCP tools
5. **Exports code** (React, Vue, SwiftUI, etc.) — optional
6. **Integrates** the design into the project structure — optional
7. **Writes the next task** to the baton file for the next iteration

## When to Use This Skill

Activate when you need ANY of these capabilities:
- **Design a new page** — Transform vague ideas into structured OpenPencil prompts with design system context
- **Continue existing project** — Pick up from `.op/next-prompt.md` baton file
- **Create design system** — Generate `.op/DESIGN.md` with user confirmation for colors, typography, components
- **Enhance prompts** — Add design system tokens, structure, and visual descriptions to vague user requests
- **Codify user decisions** — Store user preferences in DESIGN.md for consistency across iterations
- **Export code** — Generate React/Vue/SwiftUI components from OpenPencil designs

## Prerequisites

**Required:**
- OpenPencil CLI installed (`npm install -g @zseven-w/openpencil`)
- A running OpenPencil instance (desktop app or web server)

**Optional:**
- A `.op/DESIGN.md` file with design system specifications
- OpenPencil MCP Server — enables direct manipulation via MCP tools
- Design reference images in `.op/references/`

## Task Management

This skill uses **task orchestration** to avoid context dilution. Spawn subagents for each independent task:

| Task | Category | Skills | Background | When to Use |
|------|----------|--------|------------|-------------|
| **Prompt Enhancement** | `writing` | `enhance-prompt` | `true` | User input is vague or needs structure |
| **DESIGN.md Creation** | `ultrabrain` | `taste-design` | `true` | DESIGN.md missing and user confirms |
| **DESIGN.md Read** | `explore` | none | `true` | Check for existing DESIGN.md |
| **Design Generation** | `ultrabrain` | `openpencil-design` | `true` | Actual OpenPencil design building |
| **Code Export** | `unspecified-high` | none | `true` | User requests code export |
| **Project Documentation** | `ultrabrain` | none | `true` | Updating PROJECT.md |

**Parallel subagent execution avoids context dilution:**
```typescript
// Fire these simultaneously — continue working while they run
task(category="explore", load_skills=[], run_in_background=true, description="Check DESIGN.md", prompt="...")
task(category="writing", load_skills=["enhance-prompt"], run_in_background=true, description="Enhance prompt", prompt="...")

// Collect results when system notifies completion
```

## Decision Workflow

### Critical Decisions (Always Ask User)
These require explicit user confirmation before proceeding:

| Decision | What to Ask |
|----------|-------------|
| **Design System** | "No DESIGN.md found. Create one with default values or customize?" |
| **Colors** | "Color palette: Primary (accent), Background, Text roles?" |
| **Typography** | "Font families for headings, body? (e.g., Space Grotesk + Inter)" |
| **Spacing/Shadow** | "Spacing approach (8px grid)? Shadow depth (subtle/medium/elevated)?" |
| **Components** | "Button shape, card roundness, input style preferences?" |
| **Export Format** | "Export to code? (React/Vue/SwiftUI/Flutter/etc.)" |

### Medium Decisions (Offer Guidance, Allow Override)
These provide defaults with user override:

| Decision | Default | What to Offer |
|----------|---------|---------------|
| **Layout** | Vertical | "Vertical or horizontal layout?" |
| **Color Palette** | Zinc/Slate base | "Warm or cool gray base? Saturated accent?" |
| **Responsive** | Mobile-first | "Mobile-first or desktop-first strategy?" |
| **Density** | Balanced (5/10) | "Gallery airy (low) or cockpit dense (high)?" |

### Automatic Decisions (No Confirmation Needed)
These use sensible defaults:

| Decision | Default Value |
|----------|---------------|
| **Prompt enhancement** | Add structure, visual descriptions |
| **Component styling** | Apply semantic roles with smart defaults |
| **Project structure** | Section-based with sitemap tracking |
| **Export location** | `src/components/` or `lib/widgets/` |

## The Baton System

The `.op/next-prompt.md` file acts as a relay baton between iterations:

```markdown
---
design: landing-hero
device: desktop
---
Create a hero section with a bold headline, supporting subtext, and two CTA buttons.

**DESIGN SYSTEM:**
[Copy relevant section from .op/DESIGN.md]

**Page Structure:**
1. Navbar with logo and navigation links
2. Hero with centered text and CTAs
3. Subtle background gradient
```

**Critical rules:**
- The `design` field in YAML frontmatter determines the output filename
- The `device` field sets dimensions (desktop: 1200x0, mobile: 375x812)
- The prompt content must include relevant design system context
- You MUST update this file before completing your work to continue the loop

## Execution Protocol

### Step 1: Read the Baton or Start Fresh

**If baton exists** (`.op/next-prompt.md`):
- Parse frontmatter for `design` name and `device` type
- Use prompt content as the design specification
- Skip to Step 3

**If no baton** (new project):
- Continue to Step 2

### Step 2: Prompt Enhancement (If Starting Fresh)

When user provides a new design request (not from baton):

**Spawn subagents in parallel to avoid context dilution:**
```typescript
// Check for DESIGN.md existence
task(category="explore", load_skills=[], run_in_background=true, description="Check DESIGN.md", prompt="Check if .op/DESIGN.md exists. Return file content if found, or 'NOT FOUND' if missing.")

// Enhance the user prompt
task(category="writing", load_skills=["enhance-prompt"], run_in_background=true, description="Enhance prompt", prompt="Enhance this design prompt with structured page sections and visual descriptions. Original input: [user input here]")
```

**After both complete, analyze results:**
- If DESIGN.md exists: Extract tokens and enhance prompt with design system
- If missing: Ask user confirmation before creating (via `question` tool)

**Original user input:**
> "make me a login page"

**Enhanced prompt:**
```markdown
A clean, trustworthy login page with centered form and subtle branding.

**DESIGN SYSTEM (REQUIRED):**
- Platform: Web, Desktop-first
- Theme: Light, minimal, professional
- Background: Clean White (#ffffff)
- Primary Accent: Deep Blue (#2563eb) for submit button
- Text Primary: Near Black (#111827) for headings
- Buttons: Subtly rounded (8px), full-width on form
- Cards: Gently rounded (12px), soft shadow elevation

**Page Structure:**
1. **Header:** Minimal logo, centered
2. **Login Card:** Centered form with email, password fields
3. **Submit Button:** Primary blue "Sign In" button
4. **Footer:** "Don't have an account? Sign up" link
```

### Step 3: Design Generation

**Spawn subagent with openpencil-design skill for actual design building:**

```typescript
task(
  category="ultrabrain",
  load_skills=["openpencil-design"],
  run_in_background=true,
  description="Generate OpenPencil design",
  prompt="Generate design using OpenPencil CLI or MCP tools based on enhanced prompt. Always finish with op design:refine --root-id <id> to resolve icons."
)
```

**Once the subagent completes**, analyze results and continue with export/project updates if needed.

### Step 4: Persist Design Metadata (Optional)

Save the generated design info to `.op/metadata.json`:

```json
{
  "designs": {
    "landing-hero": {
      "id": "node-abc123",
      "source": "local://canvas",
      "width": 1200,
      "height": 2450,
      "device": "desktop",
      "createdAt": "2026-04-08T10:30:00Z",
      "exports": {
        "react": "src/components/landing-hero.tsx",
        "html": "public/landing-hero.html"
      }
    }
  }
}
```

### Step 5: Export Assets (Optional)

**Only run if user explicitly wants code export.** Ask: "Export to code format? (React/Vue/SwiftUI/etc.)"

The `op` CLI supports multiple code export formats. Generated files go to the project's code directory:

```bash
# Export to React (TypeScript)
op export react --out "src/components/${DESIGN_NAME}.tsx"

# Export to Vue
op export vue --out "src/components/${DESIGN_NAME}.vue"

# Export to HTML + CSS
op export html --out "public/${DESIGN_NAME}.html"
op export css --out "public/styles/${DESIGN_NAME}.css"

# Export to mobile frameworks
op export flutter --out "lib/widgets/${DESIGN_NAME}.dart"
op export swiftui --out "Sources/${DESIGN_NAME}.swift"
op export compose --out "app/src/main/java/com/example/${DESIGN_NAME}.kt"
```

**Flag reference:**
- `--out <path>` — Output file path (required)
- `--file <path>` — OpenPencil project file (default: current document)
- `--page <id>` — Page ID for multi-page documents

**For PNG/SVG images**, save manually from OpenPencil app or screenshots.

### Step 6: Update Project Documentation (Optional)

**Only update if working on project with PROJECT.md.** Skip for exploratory/single-screen work.

Modify `.op/PROJECT.md`:
- Add the new design to Section 4 (Screens) with `[x]`
- Remove consumed ideas from Section 6 (Ideas)
- Update Section 5 (Roadmap) if you completed a backlog item

### Step 7: Prepare the Next Baton (Critical if in loop)

**You MUST update `.op/next-prompt.md` before completing IF you want to continue the loop.**

If user wants to build multiple screens progressively, this step is CRITICAL.
If user wants just one-off design (no loop), this step is optional.

1. **Decide the next design**: 
   - Check `.op/PROJECT.md` Section 5 (Roadmap) for pending items
   - If empty, pick from Section 6 (Ideas)
   - Or invent something new that fits the project vision
2. **Write the baton** with proper YAML frontmatter:

```markdown
---
design: pricing-cards
device: desktop
---
Create a pricing section with three tiers: Free, Pro, Enterprise.

**DESIGN SYSTEM:**
[Copy the relevant design system block from .op/DESIGN.md]

**Page Structure:**
1. Section header with title
2. Three pricing cards in a row
3. Feature lists per tier
4. CTA buttons
```

## File Structure Reference

```
project/
├── .op/
│   ├── metadata.json      # Design IDs and export paths
│   ├── DESIGN.md          # Design system specification
│   ├── PROJECT.md         # Project vision and roadmap
│   ├── next-prompt.md     # The baton — current task
│   ├── exports/           # Generated code (optional)
│   └── references/        # Reference images, inspiration
└── src/                   # Code exports (optional)
    └── components/
        └── {Design}.tsx
```

### `.op/PROJECT.md` Schema

```markdown
# Project: [Name]

## 1. Vision
[Overall design direction and goals]

## 2. Design System Reference
Link to `.op/DESIGN.md` and key tokens

## 3. Device Targets
- Desktop: 1200px width
- Mobile: 375px width

## 4. Screens (Sitemap)
- [x] landing-hero
- [x] landing-features
- [ ] pricing-cards
- [ ] about-team

## 5. Roadmap
1. Pricing section with three tiers
2. Team/about page with photos
3. Contact form with validation UI

## 6. Ideas
- Testimonial carousel
- FAQ accordion
- Newsletter signup modal
```

### `.op/DESIGN.md` Schema

```markdown
# Design System

## 1. Typography
- Display: Space Grotesk, 40-56px, 700
- Heading: Space Grotesk, 28-36px, 700
- Body: Inter, 15-18px, 400

## 2. Colors
- Primary: #6366F1 (Indigo)
- Background: #FFFFFF
- Text: #111111
- Muted: #6B7280

## 3. Spacing
- Section padding: 80px
- Component gap: 16-24px
- Grid gap: 24px

## 4. Components
- Button: padding [12,24], radius 8, centered
- Card: padding 24, radius 12, gap 12
- Navbar: height 72, horizontal, space_between

## 5. Design Notes for Generation
When generating designs, always:
- Use semantic roles (role: "button", role: "card")
- Include icon names (e.g., name: "ZapIcon")
- Run `op design:refine` after building
- Set textGrowth: "fixed-width" for body text
```

## Orchestration Options

The loop can be driven by different orchestration layers:

| Method | How it works |
|--------|--------------|
| **CI/CD** | GitHub Actions triggers on `.op/next-prompt.md` changes |
| **Human-in-loop** | Designer reviews each iteration before continuing |
| **Agent chains** | One agent dispatches to another for continuous building |
| **Manual** | Developer runs the agent repeatedly with the same repo |

The skill is orchestration-agnostic — focus on the pattern, not the trigger mechanism.

## Common Pitfalls

- Forgetting to update `.op/next-prompt.md` (breaks the loop)
- Recreating a design that already exists in the sitemap
- Not including design system context from `.op/DESIGN.md`
- Forgetting to run `op design:refine --root-id <id>` after building
- Not persisting `.op/metadata.json` after creating new designs
- Setting x/y on children inside layout containers
- Using `fill_container` inside `fit_content` parent
- Expecting `op export png` — PNG/SVG must be captured manually from OpenPencil app
- Using `--output` instead of `--out` for export command

## Design System Integration

This skill works best with a well-defined `.op/DESIGN.md`:

1. **First time setup**: Create `.op/DESIGN.md` with typography, colors, spacing, and component specs
2. **Every iteration**: Copy relevant sections into your baton prompt
3. **Consistency**: All generated designs will share the same visual language

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Generation fails | Check that the prompt includes design system context |
| Inconsistent styles | Ensure `.op/DESIGN.md` is referenced in baton |
| Loop stalls | Verify `.op/next-prompt.md` was updated with valid frontmatter |
| Icons not visible | Run `op design:refine --root-id <id>` to resolve icon names |
| Layout issues | Check siblings use same width strategy |
| DSL parser fails | Use `op insert --parent` instead of inline children |
| PNG/SVG not found | Export command only supports code formats — capture images manually from OpenPencil app |
| Export errors | Use `--out` flag, not `--output`, and valid formats: react, html, vue, flutter, swiftui, css |

## Common OpenPencil Patterns

### Set up `op` CLI

```bash
op start --desktop    # Launch desktop app
op start --web        # Launch web server
op get                # Verify connection
```

### Pattern 1: Build with op insert (Recommended)

```bash
ID() { python3 -c "import sys,json; print(json.load(sys.stdin)['nodeId'])"; }
ROOT=$(op insert '{"type":"frame","name":"Page","width":1200,"layout":"vertical"}' | ID)
op insert --parent "$ROOT" '{"type":"frame","role":"navbar","height":72}'
op design:refine --root-id "$ROOT"
```

### Pattern 2: DSL for flat structures

```
root=I(null, {"type":"frame","name":"Landing","width":1200,"layout":"vertical"})
nav=I(root, {"type":"frame","role":"navbar","height":72})
I(nav, {"type":"text","content":"Brand","fontSize":20})
```

### Pattern 3: MCP layered workflow

1. `design_skeleton` — Create section structure
2. `design_content` — Populate sections (set `postProcess: true`)
3. `design_refine` — Validate and auto-fix

## OpenPencil CLI Quick Reference

```bash
op start [--desktop|--web]           # Launch app
op design '<dsl>'                    # Batch design (inline, @file, or stdin)
op insert '<json>' [--parent P]     # Insert node (--index N, --post-process)
op update <id> '<json>'              # Update node
op delete <id>                       # Delete node
op move <id> <parent> [index]        # Move node
op copy <id> <parent>                # Deep-copy node
op replace <id> '<json>'             # Replace node
op get [--depth N] [--pretty]        # Get document tree
op export <react|html|vue|flutter|swiftui|compose|css> --out <file>   # Export code
op page list|add|remove|rename       # Page operations
op vars / op vars:set '<json>'       # Design variables
op themes / op themes:set '<json>'   # Design themes
op design:skeleton '<json>'          # Create section structure
op design:content <id> '<json>'      # Populate section content
op design:refine --root-id <id>      # Validate + auto-fix (resolves icons)
```

Global flags: `--file <path>`, `--page <id>`, `--pretty`. Inputs: inline string, `@filepath`, or `-` (stdin).

**Code export only** — PNG/SVG images must be captured manually from OpenPencil app.
