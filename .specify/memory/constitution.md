<!--
SYNC IMPACT REPORT
==================
Version change: (blank template) → 1.0.0
Modified principles: N/A (initial fill)
Added sections: Core Principles (5), Technology Stack, Development Workflow, Governance
Removed sections: N/A
Templates requiring updates:
  ✅ .specify/memory/constitution.md (this file — written now)
  ✅ .specify/templates/plan-template.md (Constitution Check already uses generic gates — no change needed)
  ✅ .specify/templates/spec-template.md (requirements format unchanged — no change needed)
  ✅ .specify/templates/tasks-template.md (task categories unchanged — no change needed)
Follow-up TODOs: None — all placeholders resolved.
-->

# RentNow Constitution

## Core Principles

### I. Coordinator + MVVM Architecture

Every feature MUST be implemented using the Coordinator Pattern combined with MVVM.

- Navigation logic MUST live in a `Coordinator` class extending `BaseCoordinator<Route>`.
- Business/data logic MUST live in a `ViewModel` extending `BaseViewModel`.
- Views MUST be passive SwiftUI structs that consume a ViewModel and delegate navigation
  actions to a Coordinator via protocol.
- No view may directly instantiate another view or perform navigation imperatively.
- Each coordinator MUST define a typed `Route` enum and handle it inside `makeView(for:)`.

**Rationale**: Mixing navigation and business logic in views has historically caused untestable,
tightly-coupled screens. The coordinator pattern enforces a clean separation that scales across
the 5-tab structure and auth flows without creating circular dependencies.

### II. Component-First UI

Every screen view MUST decompose its UI into standalone component files.

- Each component MUST be a separate `struct` in its own file under
  `{Feature}View/{Feature}CustomViews/{SectionName}/`.
- Components accept data via `let` props and actions via closure props (`var onTap: () -> Void`).
- Components MUST NOT hold a reference to a Coordinator or ViewModel — only data and closures.
- Every component file MUST include a `#Preview` block with sample data.
- The main `{Feature}View.swift` composes components and wires coordinator actions as closures.

**Rationale**: Monolithic view files become unmaintainable past ~150 lines. Standalone components
are independently previewable, reusable across screens, and reduce merge conflicts on the team.

### III. Localization-First (NON-NEGOTIABLE)

Every user-visible string MUST be localized in both English and Arabic before a feature is
considered complete.

- Strings MUST be added to both `Shared/Localization/Strings/en.lproj/Localizable.strings`
  and `Shared/Localization/Strings/ar.lproj/Localizable.strings`.
- Localization keys MUST use the English text directly as the key
  (e.g. `"Personal Profile" = "Personal Profile";`). Dotted or underscore keys are forbidden.
- All strings in code MUST be accessed via the `.localized` extension on `String`.
- Hardcoded English strings in views are a build-blocking defect.

**Rationale**: RentNow targets both English and Arabic (RTL) markets. Retrofitting localization
after the fact is costly and error-prone. Making it a gate at feature completion ensures parity
is maintained from day one.

### IV. Safe API Decoding

All `Codable` model structs MUST use optional properties with `decodeIfPresent` and explicit
default values.

- Every model property MUST be declared `optional` (`?`).
- The custom `init(from decoder:)` MUST use `decodeIfPresent` for all keys.
- Default values MUST be provided: `?? ""` for `String`, `?? []` for arrays,
  `?? 0.0` / `?? 0` for numbers. Nested objects and `id` fields may remain truly optional.
- Nested model types MUST follow the same pattern recursively.
- Views and ViewModels MUST handle optionals at the call site with `?? ""` or `if let`.

**Rationale**: The backend API occasionally returns `null` or omits fields. Using
`decode(_:forKey:)` causes fatal crashes at runtime. `decodeIfPresent` with defaults makes the
app resilient to API changes without requiring a server deployment to fix a crash.

### V. Simplicity & Feature Module Structure

Features MUST follow the defined folder structure. Complexity beyond that structure requires
explicit justification.

- Feature folder: `App/{Feature}/` containing `{Feature}View/`, `{Feature}ViewModel/`,
  `{Feature}Model/`, `Network/`.
- One endpoint file per major feature area (e.g., `MoreEndpoint.swift` covers all More-tab
  APIs). Do NOT create one file per sub-endpoint.
- YAGNI applies: do not add abstractions, helpers, or configuration hooks for hypothetical
  future requirements.
- Three similar lines of code are preferable to a premature abstraction.
- `BaseViewModel` handles loading indicators, toasts, and unauthenticated responses — do not
  re-implement these concerns in individual ViewModels.

**Rationale**: Complexity debt accumulates fastest through over-engineering. The defined module
structure provides enough scaffolding for the 5-tab app without imposing unnecessary layers.

## Technology Stack

- **Language / Framework**: Swift 5.9+, SwiftUI
- **Minimum iOS**: iOS 15+
- **Navigation**: `NavigationStack(path:)` via Coordinator Pattern
- **Networking**: Alamofire via `NetworkExecuter`; base URL `https://dashboard.rentnow-app.com/API/`
- **Image Loading**: Kingfisher via `RemoteImageView(url:)`
- **Fonts**: ExpoArabic — `.expoSystemFont(size:weight:)` MUST be used; system fonts are forbidden
  in production views
- **Colors**: Asset-catalog colors accessed via extensions (`.mainColor`, `.secoundryMain`, etc.)
- **Storage**: `UserDefaults` property wrappers (`@ValueDefault`, `@ModelsDefault`)
- **Localization runtime switching**: `Language.setAppLanguage(lang:)`
- **Build**: Xcode 16, `PBXFileSystemSynchronizedRootGroup` — do NOT modify `project.pbxproj`
  manually when adding files

## Development Workflow

1. **New Feature**: Create `App/{Feature}/` folder, add Route to parent coordinator, create
   ViewModel + View + Endpoint + Localization strings.
2. **New Screen**: Follow Component-First UI principle — extract sections into
   `{Feature}CustomViews/` immediately, do not defer refactoring.
3. **API Integration**: Define endpoint in the feature's `Network/{Feature}Endpoint.swift`.
   Use `@MainActor` + `Task` in ViewModels; call `showIndicator()` / `hideIndicator()` around
   requests.
4. **Localization**: Add both `en` and `ar` entries before marking a task done. Use English text
   as the key verbatim.
5. **Session Expiry**: MUST be handled via `SessionManager.shared.handleSessionExpired()` —
   never clear auth state manually.
6. **Code Review Gate**: Each PR MUST verify all five Core Principles are satisfied before merge.

## Governance

This constitution supersedes all other informal practices. When conflicts arise between existing
code patterns and this document, the constitution takes precedence for new work; existing
violations SHOULD be remediated incrementally.

**Amendment procedure**:
1. Propose change in a PR with a rationale comment referencing the principle being amended.
2. Increment `CONSTITUTION_VERSION` according to semantic versioning:
   - MAJOR — principle removal or backward-incompatible redefinition
   - MINOR — new principle or material guidance expansion
   - PATCH — clarification, wording, typo fix
3. Update `LAST_AMENDED_DATE` to today's date (ISO 8601).
4. Propagate changes to dependent templates (plan, spec, tasks) in the same PR.

**Compliance review**: All PRs and spec reviews MUST include a "Constitution Check" gate
confirming no principle violations are introduced. Use `.specify/templates/plan-template.md`
Constitution Check section as the checklist.

**Runtime guidance**: See `CLAUDE.md` at the repository root for agent-specific coding
conventions, build commands, and detailed pattern examples.

**Version**: 1.0.0 | **Ratified**: 2026-03-24 | **Last Amended**: 2026-03-24
