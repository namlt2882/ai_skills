#!/bin/bash
# Create a new OpenPencil project with all required files and templates
# Usage: ./init-project.sh [project-name]

set -e

PROJECT_DIR="${1:-.op}"
DESIGN_NAME="${2:-landing-hero}"

echo "Creating OpenPencil project at: $PROJECT_DIR"

# Create directory structure
mkdir -p "$PROJECT_DIR/exports"
mkdir -p "$PROJECT_DIR/references"

# Create PROJECT.md
echo "Creating PROJECT.md..."
cat > "$PROJECT_DIR/PROJECT.md" << EOF
# Project: [Project Name]

## 1. Vision
[Describe the overall design direction and goals]

## 2. Design System Reference
See .op/DESIGN.md for full specifications.

Key tokens:
- Primary color: [color]
- Typography: [font stack]
- Spacing: [base unit]

## 3. Device Targets
- Desktop: 1200px width (auto height)
- Mobile: 375x812px

## 4. Screens (Sitemap)
- [ ] screen-name-1
- [ ] screen-name-2
- [ ] screen-name-3

## 5. Roadmap
1. [First design to build]
2. [Second design to build]
3. [Third design to build]

## 6. Ideas
- [Future design ideas]
- [Potential enhancements]
- [Nice-to-have screens]
EOF

# Create DESIGN.md
echo "Creating DESIGN.md..."
if [ -n "$SKILL_ROOT" ]; then
  SKILL_TEMPLATES="$SKILL_ROOT/templates"
elif [ -d "$(dirname "$0")/../templates" ]; then
  SKILL_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
  SKILL_TEMPLATES="$SKILL_ROOT/templates"
else
  SKILL_TEMPLATES=""
fi
if [ -f "$SKILL_TEMPLATES/DESIGN.md" ]; then
  cp "$SKILL_TEMPLATES/DESIGN.md" "$PROJECT_DIR/DESIGN.md"
else
  echo "DESIGN.md template not found at $SKILL_TEMPLATES, creating basic version"
  cat > "$PROJECT_DIR/DESIGN.md" << 'EOF'
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
EOF
fi

# Create metadata.json
echo "Creating metadata.json..."
TIMESTAMP=$(date -Iseconds)
cat > "$PROJECT_DIR/metadata.json" << EOF
{
  "project": "[Project Name]",
  "version": "1.0.0",
  "createdAt": "$TIMESTAMP",
  "designs": {}
}
EOF

# Create next-prompt.md
echo "Creating next-prompt.md..."
cat > "$PROJECT_DIR/next-prompt.md" << EOF
---
design: $DESIGN_NAME
device: desktop
---
Create a [design description].

**DESIGN SYSTEM:**
[Copy relevant sections from .op/DESIGN.md]

**Page Structure:**
1. [Section 1]
2. [Section 2]
3. [Section 3]
EOF

echo ""
echo "✓ Project initialized at: $PROJECT_DIR"
echo ""
echo "Files created:"
echo "  - $PROJECT_DIR/PROJECT.md"
echo "  - $PROJECT_DIR/DESIGN.md (template)"
echo "  - $PROJECT_DIR/metadata.json"
echo "  - $PROJECT_DIR/next-prompt.md"
echo "  - $PROJECT_DIR/exports/"
echo "  - $PROJECT_DIR/references/"
echo ""
echo "Next steps:"
echo "  1. Edit .op/DESIGN.md with your design system"
echo "  2. Update .op/next-prompt.md with your first design task"
echo "  3. Run: op start --desktop  # Start OpenPencil"
echo "  4. Run: op design:refine --root-id <id>  # After building design"