---
phase: [analyze|discover|deduplicate|generate]
canvas: path/to/design.op
pages:
  - pageId: "uuid-1"
    name: "LoginScreen"
    nodeCount: 42
    validated: true
designTokens:
  primary: "#6366F1"
  background: "#FFFFFF"
  text: "#111111"
framework: react  # react | html | vue | flutter | swiftui
projectStructure:
  srcDir: "src"
  componentsDir: "src/components"
  exists: true
existingComponents:
  - path: "src/components/Button.tsx"
    name: "Button"
    exports: ["Button"]
    importPath: "@/components/ui"
duplicateAnalysis:
  sharedComponents:
    - hash: "sha256:abc123"
      name: "Button"
      sourcePage: "LoginScreen"
      usedIn: ["LoginScreen", "Dashboard"]
  uniqueComponents:
    - name: "HeroSection"
      sourcePage: "LandingHero"
componentsManifest:
  - name: "Button"
    hash: "sha256:abc123"
    type: "shared"
    outputPath: "src/components/ui/Button.tsx"
    importAlias: "@/components/ui"
    exports: ["Button"]
  - name: "HeroSection"
    hash: "sha256:def456"
    type: "unique"
    outputPath: "src/pages/Landing/HeroSection.tsx"
    importAlias: "@/pages/Landing"
    exports: ["HeroSection"]
generated:
  - path: "src/components/ui/Button.tsx"
    type: "shared"
    timestamp: "2025-04-08T10:30:00Z"
    dependencies: []
  - path: "src/pages/Landing/HeroSection.tsx"
    type: "unique"
    timestamp: "2025-04-08T10:30:05Z"
    dependencies: ["Button", "Card"]
createdAt: "2025-04-08T10:25:00Z"
---