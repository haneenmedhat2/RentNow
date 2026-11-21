---
name: implement-design
description: Translates Figma designs into production-ready SwiftUI code with 1:1 visual fidelity. Use when implementing UI from Figma files, when user mentions "implement design", provides Figma URLs, or asks to build components matching Figma specs.
allowed-tools: Read, Grep, Glob, Edit, Write, Bash
argument-hint: [figma-url-or-description]
---

# Implement Design from Figma

You are a senior iOS engineer translating a Figma design into production-ready SwiftUI code for the RentNow project. Follow this workflow precisely to achieve 1:1 visual fidelity.

## Workflow

### Step 1: Parse Figma Input

Extract `fileKey` and `nodeId` from the provided Figma URL.

- URL format: `https://figma.com/design/:fileKey/:fileName?node-id=:nodeId`
- Convert `node-id` format from `1-2` to `1:2` for API calls
- If no URL is provided, ask the user for a Figma URL or node reference

### Step 2: Fetch Design Context

Call `get_design_context(fileKey, nodeId)` to retrieve:
- Layout structure (frames, auto-layout, constraints)
- Typography (font family, size, weight, line height)
- Colors (fills, strokes, opacity)
- Spacing (padding, gaps, margins)
- Component hierarchy and naming

Map the design tokens to RentNow equivalents before writing any code.

### Step 3: Capture Visual Reference

Call `get_screenshot(fileKey, nodeId)` to get a visual screenshot of the design.

Use this as the ground truth for visual parity. Compare your implementation against this screenshot throughout the process.

### Step 4: Download Assets

If the design context includes downloadable assets (icons, images, illustrations):
- Download them using the provided URLs from the MCP response
- Save images to `RentNow/Resourses/Assets.xcassets/` with proper `.imageset` folders containing `Contents.json` and @1x/@2x/@3x variants
- **Do NOT** add new icon packages or dependencies — use downloaded assets or existing SF Symbols

### Step 5: Translate to SwiftUI with RentNow Conventions

Build the implementation following the project's architecture and patterns:

#### Architecture
- **Coordinator + MVVM** pattern
- ViewModels extend `BaseViewModel` (handles loading, toasts, network)
- Views wrap content in `BaseView(viewModel:showMainBackground:)` for loading/toast handling
- Navigation via coordinator protocols — pass actions as closures to components, not coordinator references

#### File Structure
```
App/{Feature}/
├── View/
│   ├── {Feature}View.swift
│   └── {Feature}CustomViews/
│       └── {SectionName}/
│           └── {Feature}{SectionName}View.swift
├── ViewModel/
│   └── {Feature}ViewModel.swift
├── Model/
│   └── {Feature}Model.swift
└── Network/
    └── {Feature}Endpoint.swift
```

#### Typography Mapping
Map Figma font sizes to RentNow `FontSize` constants:
- 10pt → `FontSize.altraSmall`
- 12pt → `FontSize.small`
- 14pt → `FontSize.normal`
- 16pt → `FontSize.large`

Use `.expoSystemFont(size:weight:)` for all text. Map Figma weights:
- Regular → `.regular`
- Medium → `.medium`
- SemiBold → `.semiBold`
- Bold → `.bold`

#### Color Mapping
Map Figma colors to existing project color extensions:
- Primary/brand color → `.mainColor`
- Secondary accent → `.secoundryMain`
- Dark text → `.secondaryDarkFont`
- Check `Shared/SwiftUI/Utilites/ColorExtension.swift` for all available colors
- If a color doesn't exist, add it to `Assets.xcassets` and create an extension

#### Components
Use existing shared components where they match the design:
- `MainButton` — Primary CTA buttons with gradient
- `OutlineButton` — Secondary/outline buttons
- `AppTextView` — Standard text inputs
- `PhoneTextView` — Phone number with country code
- `PasswordTextView` — Password with visibility toggle
- `AppPickerField` — Dropdown pickers
- `RemoteImageView(url:)` — Remote image loading (Kingfisher)
- `.glassyBackground(cornerRadius:)` — Glass morphism effect

#### Localization
- Use the **English text directly** as the localization key
- Access via `"English text here".localized`
- Add entries to BOTH files:
  - `Shared/Localization/Strings/en.lproj/Localizable.strings`
  - `Shared/Localization/Strings/ar.lproj/Localizable.strings`
- Ask the user for Arabic translations or note them as TODO

#### Component Pattern
Each extracted component should:
- Be a standalone `struct` conforming to `View`
- Accept data via `let` properties
- Accept actions via closure properties (`var onTap: () -> Void`)
- Include `#Preview` with sample data
- Be prefixed with the feature name

### Step 6: Achieve 1:1 Visual Parity

Pay close attention to:
- **Spacing**: Match exact padding, margins, and gaps from the design
- **Corner radius**: Match border radius values
- **Shadows**: Replicate shadow color, blur, offset
- **Opacity**: Match any transparency values
- **Alignment**: Respect leading/trailing/center alignment
- **RTL Support**: Ensure layout works for both LTR (English) and RTL (Arabic)

### Step 7: Validate Against Screenshot

After implementation:
1. Review each component against the Figma screenshot
2. Check spacing, colors, typography, and layout match
3. Verify all interactive elements have proper tap targets
4. Confirm localization keys are added to both string files
5. Ensure the view integrates with its coordinator for navigation

## Output Checklist

Before finishing, confirm:
- [ ] All SwiftUI views created following `{Feature}CustomViews/` structure
- [ ] ViewModel created extending `BaseViewModel` (if needed)
- [ ] Model created with optional properties and `init(from decoder:)` (if needed)
- [ ] Endpoint created (if API data is needed)
- [ ] All text strings added to en and ar localization files
- [ ] Assets downloaded and saved to `Assets.xcassets`
- [ ] Components use existing shared components where applicable
- [ ] `#Preview` added to all component views
- [ ] Visual output matches Figma screenshot
