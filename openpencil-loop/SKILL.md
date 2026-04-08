---
name: openpencil-loop
description: Iterative design development loop using OpenPencil CLI and MCP tools. Use when building multi-page designs, iteratively refining UI components, or when you want to progressively develop a design system. Triggers on requests like "build a design system", "create multiple pages with OpenPencil", "iteratively design", "loop design", or when the user wants to develop designs incrementally with a baton-passing pattern.
---

# OpenPencil Build Loop

You are an **autonomous design builder** participating in an iterative design-development loop. Your goal is to generate designs using OpenPencil, integrate them into the project, and prepare instructions for the next iteration.

## Overview

The Build Loop pattern enables continuous, autonomous design development through a "baton" system. Each iteration:
1. Reads the current task from a baton file (`.op/next-prompt.md`)
2. Generates design using OpenPencil CLI or MCP tools
3. Integrates the design into the project structure
4. Writes the next task to the baton file for the next iteration

## Prerequisites

**Required:**
- OpenPencil CLI installed (`npm install -g @zseven-w/openpencil`)
- A running OpenPencil instance (desktop app or web server)
- A `.op/DESIGN.md` file with design system specifications

**Optional:**
- OpenPencil MCP Server — enables direct manipulation via MCP tools
- Design reference images in `.op/references/`

## OpenPencil CLI Reference

Before generating designs, ensure you have the OpenPencil CLI installed:
```bash
npm install -g @zseven-w/openpencil
```

Start OpenPencil:
```bash
op start --desktop    # Launch desktop app
op start --web        # Launch web server
```

Key commands:
- `op insert '<json>' [--parent P]` - Insert node with --parent to build tree
- `op design '<dsl>'` - Batch design DSL for simple structures
- `op design:refine --root-id <id>` - Validate + auto-fix (resolves icons)
- `op export <png|svg|react|html|vue>` - Export assets
- `op get [--depth N]` - Get document tree

Global flags: `--file <path>`, `--page <id>`, `--pretty`

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

### Step 1: Read the Baton

Parse `.op/next-prompt.md` to extract:
- **Design name** from the `design` frontmatter field
- **Device type** from the `device` frontmatter (default: `desktop`)
- **Prompt content** from the markdown body

### Step 2: Consult Context Files

Before generating, read these files:

| File | Purpose |
|------|---------|
| `.op/DESIGN.md` | Design system, component specs, visual language |
| `.op/PROJECT.md` | Project vision, design roadmap, existing screens |
| `.op/metadata.json` | Existing design IDs, exports, relationships |

**Important checks:**
- Section 4 (Screens) in `.op/PROJECT.md` — Do NOT recreate designs that already exist
- Section 5 (Roadmap) — Pick tasks from here if backlog exists
- Section 6 (Ideas) — Use for new designs if roadmap is empty

### Step 3: Generate with OpenPencil

Choose the appropriate generation method based on complexity:

**Method A: `op insert` (Recommended for complex designs)**

The most reliable way to build designs. Use `--parent` to specify parent nodes. Capture the returned nodeId to reference later. **Always finish with `design:refine`** to resolve icons and validate layout.

```bash
#!/bin/bash
set -e
ID() { python3 -c "import sys,json; print(json.load(sys.stdin)['nodeId'])"; }

# Determine dimensions from device
if [ "$DEVICE" = "mobile" ]; then
  WIDTH=375
  HEIGHT=812
else
  WIDTH=1200
  HEIGHT=0  # Auto-expand for desktop
fi

# Create root frame, capture its ID
ROOT=$(op insert "{\"type\":\"frame\",\"name\":\"$DESIGN_NAME\",\"width\":$WIDTH,\"height\":$HEIGHT,\"layout\":\"vertical\",\"fill\":[{\"type\":\"solid\",\"color\":\"#FFFFFF\"}]}" | ID)

# Insert children using --parent
op insert --parent "$ROOT" '{"type":"frame","role":"navbar","width":"fill_container","height":72,...}'

# Always finish with design:refine to resolve icons
op design:refine --root-id "$ROOT"
```

**Method B: Batch Design DSL (For simpler structures)**

One operation per line. Bind results with `name=` for later reference. Best for simple, flat structures.

> **Limitation:** The DSL parser cannot handle deeply nested JSON. Keep each `I()` call to a **single level of nesting**. For complex nodes with children, use separate `I()` calls or `op insert --parent`.

```bash
op design '
root=I(null, {"type":"frame","name":"Landing","width":1200,"layout":"vertical"})
nav=I(root, {"type":"frame","role":"navbar","height":72})
hero=I(root, {"type":"frame","role":"hero"})
'
```

| Op | Syntax | Action |
|----|--------|--------|
| `I` | `name=I(parent, { node })` | Insert |
| `U` | `U(ref, { updates })` | Update |
| `C` | `name=C(source, parent, { overrides })` | Copy |
| `R` | `name=R(ref, { node })` | Replace |
| `M` | `M(ref, parent, index?)` | Move |
| `D` | `D(ref)` | Delete |

**DSL safe pattern** — always insert parent and children separately:

```bash
op design '
btn=I(form, {"type":"rectangle","role":"button","width":"fill_container","height":50})
I(btn, {"type":"text","content":"Submit","fontSize":16})
'
```

**Method C: MCP Tools (If OpenPencil MCP is available)**

Use the layered workflow:
1. `design_skeleton` — Create section structure
2. `design_content` — Populate each section with `postProcess: true`
3. `design_refine` — Validate and auto-fix (resolves icons)

**Always** run `op design:refine --root-id <id>` at the end to resolve icon names into actual SVG paths. Without this step, icons will exist in the tree but not render visually.

### Step 4: Persist Design Metadata

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
        "html": "public/landing-hero.html",
        "css": "public/styles/landing-hero.css"
      }
    }
  }
}
```

**Note:** `op export` only generates code (React, HTML, Vue, etc.), not image assets. PNG/SVG captures must be done manually from OpenPencil app.

### Step 5: Export Assets

**Note:** The `op` CLI only supports code export formats. For PNG/SVG, use the OpenPencil app's export feature or export from scraped documents.

```bash
# Export React component
op export react --out "src/components/${DESIGN_NAME}.tsx"

# Export Vue component
op export vue --out "src/components/${DESIGN_NAME}.vue"

# Export HTML
op export html --out "public/${DESIGN_NAME}.html"

# Export Flutter widget
op export flutter --out "lib/widgets/${DESIGN_NAME}.dart"

# Export SwiftUI view
op export swiftui --out "Sources/${DESIGN_NAME}.swift"

# Export CSS
op export css --out "public/styles/${DESIGN_NAME}.css"
```

**For PNG/SVG images**, save manually from OpenPencil app or use browser developer tools to capture screenshots.

### Step 6: Update Project Documentation

Modify `.op/PROJECT.md`:
- Add the new design to Section 4 (Screens) with `[x]`
- Remove consumed ideas from Section 6 (Ideas)
- Update Section 5 (Roadmap) if you completed a backlog item

### Step 7: Prepare the Next Baton (Critical)

**You MUST update `.op/next-prompt.md` before completing.** This keeps the loop alive.

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
│   ├── references/        # Reference images, inspiration
│   │   └── inspiration-*.png
│   └── exports/           # Generated assets
│       ├── {design}.png
│       └── {design}.svg
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

- ❌ Forgetting to update `.op/next-prompt.md` (breaks the loop)
- ❌ Recreating a design that already exists in the sitemap
- ❌ Not including design system context from `.op/DESIGN.md`
- ❌ Forgetting to run `op design:refine --root-id <id>` after building
- ❌ Not persisting `.op/metadata.json` after creating new designs
- ❌ Setting x/y on children inside layout containers
- ❌ Using `fill_container` inside `fit_content` parent
- ❌ Expecting `op export png` — PNG/SVG must be captured manually from OpenPencil app
- ❌ Using `--output` instead of `--out` for export command

## Design System Integration

This skill works best with a well-defined `.op/DESIGN.md`:

1. **First time setup**: Create `.op/DESIGN.md` with typography, colors, spacing, and component specs
2. **Every iteration**: Copy relevant sections into your baton prompt
3. **Consistency**: All generated designs will share the same visual language

## Example: Full Iteration

**Starting baton (`.op/next-prompt.md`):**

```markdown
---
design: landing-hero
device: desktop
---
Create a hero section for a SaaS product.

**DESIGN SYSTEM:**
- Typography: Space Grotesk for headings, Inter for body
- Colors: Primary #6366F1, Background #FFFFFF
- Spacing: Section padding 80px

**Structure:**
1. Navbar with logo, nav links, CTA button
2. Hero with large heading, subtext, two CTAs
3. Subtle gradient background
```

**Execution:**

```bash
# Determine dimensions from device
if [ "$DEVICE" = "mobile" ]; then
  WIDTH=375
  HEIGHT=812
else
  WIDTH=1200
  HEIGHT=0
fi

# Generate design with op insert (recommended)
ID() { python3 -c "import sys,json; print(json.load(sys.stdin)['nodeId'])"; }
ROOT=$(op insert "{\"type\":\"frame\",\"name\":\"Landing\",\"width\":$WIDTH,\"height\":$HEIGHT,\"layout\":\"vertical\",\"fill\":[{\"type\":\"solid\",\"color\":\"#FFFFFF\"}]}" | ID)

# Build navbar
NAV=$(op insert --parent "$ROOT" '{"type":"frame","role":"navbar","width":"fill_container","height":72}' | ID)
op insert --parent "$NAV" '{"type":"text","content":"Brand","fontSize":20,"fontWeight":700}'

# Build hero
HERO=$(op insert --parent "$ROOT" '{"type":"frame","role":"hero","width":"fill_container","height":"fit_content"}' | ID)
op insert --parent "$HERO" '{"type":"text","role":"heading","content":"Ship faster","fontSize":56}'

# Export React component
op export react --out "src/components/${DESIGN_NAME}.tsx"

# Export Vue component
op export vue --out "src/components/${DESIGN_NAME}.vue"

# Export CSS
op export css --out "public/styles/${DESIGN_NAME}.css"

# Update metadata
# ... update .op/metadata.json

# Prepare next baton
# ... write to .op/next-prompt.md with next design task
```

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

### Set up `op` CLI documentation
**Required**: `op start --desktop` or `op start --web` before using CLI

**Query**: Use `op get` to inspect current document structure

**Common pattern**: Build with `op insert --parent`, finish with `op design:refine --root-id <id>`

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
op export <png|svg|react|html|vue>   # Export assets
op page list|add|remove|rename       # Page operations
op vars / op vars:set '<json>'       # Variables
op themes / op themes:set '<json>'   # Themes
op design:skeleton '<json>'          # Create section structure
op design:content <id> '<json>'      # Populate section content
op design:refine --root-id <id>      # Validate + auto-fix (resolves icons)
```

Global flags: `--file <path>`, `--page <id>`, `--pretty`. Inputs: inline string, `@filepath`, or `-` (stdin).