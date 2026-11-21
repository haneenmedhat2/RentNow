# CLAUDE.md

you senior ios engineer with 10 years experience

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.


## Project Overview

RentNow is an iOS car rental app built with SwiftUI using **Coordinator Pattern + MVVM** architecture. Supports English and Arabic (RTL).

## UI Design Workflow

When asked to implement a new screen:

### Step 1: Design in English
- Describe the UI layout and components
- Specify user interactions
- List all text elements

### Step 2: Implementation with Localization
- Create SwiftUI views following Coordinator + MVVM pattern
- Use existing shared components
- Add ALL text strings to both localization files:
  - `Shared/Localization/Strings/en.lproj/Localizable.strings`
  - `Shared/Localization/Strings/ar.lproj/Localizable.strings`
- Use format: `"screen_name.element" = "Text";`
- Access in code: `"screen_name.element".localized`

## Build Commands

```bash
# Build project via Xcode command line
xcodebuild -project RentNow.xcodeproj -scheme RentNow -configuration Debug build

# Open in Xcode
open RentNow.xcodeproj
```

## Architecture

### App Flow States
```
.splash → .intro (first time) → .auth → .main (TabBar)
                              ↓
                     .locationPicker (if no location)
```

- **`.splash`** - App launch screen
- **`.intro`** - Onboarding (first time only)
- **`.auth`** - Login/Register flow
- **`.locationPicker`** - User location selection (after registration)
- **`.main`** - TabBar with 5 tabs (Home, Orders, AddAd, Wallet, More)

### Coordinator Pattern (Navigation)
- **AppCoordinator** (`App/CoordinatorPattern/AppCoordinator/`) - Root coordinator managing app states
- **AuthCoordinator** - Handles login, register, verification, password reset flows
- **TabBarCoordinator** - Manages 5 tab child coordinators
- **Child Tab Coordinators** - HomeCoordinator, OrdersCoordinator, AddAdCoordinator, WalletCoordinator, MoreCoordinator
- Each coordinator extends `BaseCoordinator<Route>` with typed Route enums
- Uses `NavigationStack(path:)` for navigation, manages sheets/fullscreen/popups

### TabBar Structure
```
TabBarCoordinator
├── HomeCoordinator      → HomeView (tab_home)
├── OrdersCoordinator    → OrdersView (tab_orders)
├── AddAdCoordinator     → AddAdView (tab_add_ad)
├── WalletCoordinator    → WalletView (tab_wallet)
└── MoreCoordinator      → MoreView (tab_more)
```

**TabItem Enum** (`TabItem.swift`):
- Defines 5 tabs with localized titles and SF Symbol icons
- Icons: `house.fill`, `doc.text.fill`, `plus.circle.fill`, `briefcase.fill`, `ellipsis`

**Features:**
- Native SwiftUI `TabView(selection:)`
- Pop-to-root when same tab tapped twice
- Visitor mode check for AddAd tab
- Logout flow from MoreCoordinator → AppCoordinator

### MVVM Structure
- **Views** - SwiftUI views in feature folders
- **ViewModels** - Extend `BaseViewModel` (handles loading, toasts, network requests)
- **Models** - Codable structs in Model folders

### Model Pattern

All model structs should use **optional properties** with custom `init(from decoder:)` to provide default values. This ensures safe decoding from API responses.

**Example Model:**
```swift
struct MyModel: Codable {
    let id: Int?
    let name: String?
    let items: [Item]?
    let isActive: Bool?
    let rating: Double?
    let nestedObject: NestedModel?

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.items = try container.decodeIfPresent([Item].self, forKey: .items) ?? []
        self.isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive)
        self.rating = try container.decodeIfPresent(Double.self, forKey: .rating) ?? 0.0
        self.nestedObject = try container.decodeIfPresent(NestedModel.self, forKey: .nestedObject)
    }
}
```

**Guidelines:**
- All properties should be optional (`?`)
- Use `decodeIfPresent` for all properties
- Provide default values with `?? ""` for String, `?? []` for arrays, `?? 0.0` for numbers
- Keep `id` and nested objects without defaults (truly optional)
- Nested models should follow the same pattern
- When using in Views/ViewModels, handle optionals with `?? ""` or `if let`

### Feature Module Pattern
Each feature follows: `App/{Feature}/{FeatureName}View/`, `{FeatureName}ViewModel/`, `{FeatureName}Model/`, `Network/`

### File Structure
```
RentNow/App/
├── CoordinatorPattern/
│   ├── AppCoordinator/
│   │   ├── AppCoordinator.swift
│   │   └── SessionManager.swift
│   ├── Coordinator/
│   │   └── Coordinator.swift (BaseCoordinator)
│   └── ChildsCoordinators/
│       ├── AuthCoordinator/
│       ├── TabBarCoordinator/
│       │   ├── TabItem.swift
│       │   ├── TabBarCoordinator.swift
│       │   └── TabBarView.swift
│       └── TabsCoordinatoors/
│           ├── HomeCoordinator/
│           ├── OrdersCoordinator/
│           ├── AddAdCoordinator/
│           ├── WalletCoordinator/
│           └── MoreCoordinator/
├── Auth/
│   ├── Login/
│   ├── Register/
│   ├── ForgetPassword/
│   ├── ActiveCode/
│   └── ResetPassword/
└── TabBar/
    └── Home/
        ├── HomeCoordinator/
        ├── HomeView/
        └── HomeViewModel/
```

## Networking

**Base URL**: `https://dashboard.rentnow-app.com/API/`

### Request Flow
```
ViewModel.callApi() → Endpoint → NetworkExecuter (Alamofire) → ResponseHandler → BaseResponse<T>
```

### Key Types
- **Endpoint<T>** - Defines path, method, body, headers, uploads
- **BaseResponse<T>** - Wraps response with `key` (ServerResponseKey), `message`, `data`
- **ServerResponseKey** - `.success`, `.fail`, `.unauthenticated`, `.blocked`, `.needActive`, `.exception`

### Creating Endpoints
```swift
static func myEndpoint(param: String) -> Endpoint<BaseResponse<MyModel>> {
    return .init(
        method: .post,
        path: "My/Endpoint",
        body: ["param": param]
    )
}
```

### Making Requests in ViewModel
```swift
@MainActor func callApi() {
    Task {
        showIndicator()
        let endpoint = MyEndpoint.fetch()
        do {
            let data = try await request(endpoint)
            // handle data
        } catch {
            showError(error.localizedDescription)
        }
        hideIndicator()
    }
}
```

## Localization

- Files: `Shared/Localization/Strings/{en,ar}.lproj/Localizable.strings`
- Usage: `"key".localized`
- **Key style**: Use the **English text directly** as the localization key (e.g. `"Personal Profile"`, `"Contact Us"`, `"You can upload up to %d photos"`). Do NOT use dotted keys like `"image_picker.subtitle_photos"` or underscore keys like `"Personal_Profile_More_Title"`
- Always add both English and Arabic translations
- Use `Language.setAppLanguage(lang:)` for runtime switching

## Shared Components

### Form Inputs (`Shared/SwiftUI/TextView/`)
- **PhoneTextView** - Phone with country code picker, `isRequired` parameter
- **PasswordTextView** - Password with visibility toggle, `isRequired` parameter
- **AppPickerField** - Generic dropdown, requires `GeneralPickerModel` conformance
- **AppTextView** - Standard text input

### Buttons
- **MainButton** - Primary CTA with gradient
- **OutlineButton** - Secondary variant

### Validation
- Feature validators in Model folders (e.g., `LoginValidation.swift`)
- `GeneralValidationService` for reusable validation (phone, email, password)

## UserDefaults Storage

Property wrapper-based (`Shared/Foundation/UserDefaults.swift`):
- `UserDefaults.isLogin`, `UserDefaults.accessToken`, `UserDefaults.user`
- Use `@ValueDefault` for primitives, `@ModelsDefault` for Codable types

## Styling

- **Custom Font**: ExpoArabic - use `.expoSystemFont(size:weight:)`
- **Colors**: Defined in Assets.xcassets, accessed via extensions (`.mainColor`, `.splashColor`)
- **FontSize**: Constants class for consistent sizing

## Session Management

- `SessionManager.shared.handleSessionExpired()` clears auth and triggers logout
- BaseViewModel auto-handles `.unauthenticated` responses
- AppCoordinator observes `sessionExpired` publisher

## Adding New Features

1. Create folder: `App/{Feature}/`
2. Add Route to parent coordinator or create new coordinator
3. Create ViewModel extending BaseViewModel
4. Create View consuming ViewModel
5. Add Endpoint in `Network/` folder
6. Add validation in `Model/` folder
7. Add localized strings to both .strings files

## Adding New Tab Screen

1. Create Route enum in coordinator (e.g., `HomeRoute`)
2. Add route case and create view in `makeView(for:)`
3. Create ViewModel extending `BaseViewModel`
4. Create View with `BaseView` wrapper for loading/toast handling
5. Use coordinator protocol for navigation actions

**Example Tab Coordinator:**
```swift
enum HomeRoute: Hashable {
    case home
    case carDetails(carId: Int)
}

@MainActor
final class HomeCoordinator: BaseCoordinator<HomeRoute>, HomeCoordinatorProtocol {
    @ViewBuilder
    func buildHomeFlow() -> some View {
        NavigationStack(path: bindingPath) {
            makeView(for: .home)
                .navigationDestination(for: HomeRoute.self) { route in
                    self.makeView(for: route)
                }
        }
        .withCoordinatorPresentation(self)
    }
}
```

## View Components Architecture

When building screen views, extract UI sections into separate component files for reusability and maintainability.

### Folder Structure
```
{Feature}View/
├── {Feature}View.swift              # Main view (composes components)
└── {Feature}CustomViews/            # Component folder
    ├── {SectionName}/
    │   └── {Feature}{SectionName}View.swift
    └── {AnotherSection}/
        └── {Feature}{AnotherSection}View.swift
```

**Example - HomeView:**
```
HomeView/
├── HomeView.swift
└── HomeCustomViews/
    ├── TopHeader/
    │   └── HomeTopHeaderView.swift
    ├── WelcomeSection/
    │   └── HomeWelcomeSectionView.swift
    ├── BannerSlider/
    │   └── HomeBannerSliderView.swift
    └── CategoriesSection/
        └── HomeCategoriesSectionView.swift
```

### Component Pattern

Each component should:
- Be a standalone `struct` conforming to `View`
- Accept data via `let` properties (props)
- Accept actions via closure properties (`var onTap: () -> Void`)
- Include `#Preview` for development

**Example Component:**
```swift
import SwiftUI
import UIKit

struct HomeTopHeaderView: View {
    // Data props
    let userAddress: String

    // Action closures
    var onLocationTap: () -> Void

    var body: some View {
        HStack {
            Button {
                onLocationTap()
            } label: {
                HStack(spacing: 6) {
                    Text(userAddress)
                        .expoSystemFont(size: FontSize.small, weight: .medium)
                    Image(systemName: "location.fill")
                        .foregroundColor(.mainColor)
                }
                .glassyBackground()
            }

            Spacer()

            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
        }
    }
}

#Preview {
    HomeTopHeaderView(userAddress: "الرياض", onLocationTap: {})
}
```

### Main View Composition

The main view composes components and passes data/actions:
```swift
struct HomeView: View {
    let coordinator: HomeCoordinatorProtocol
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        BaseView(viewModel: viewModel, showMainBackground: true) {
            VStack(spacing: 0) {
                HomeTopHeaderView(
                    userAddress: viewModel.userAddress,
                    onLocationTap: { coordinator.showLocationPicker() }
                )
                .padding(.horizontal, 16)

                HomeWelcomeSectionView(
                    userName: viewModel.userName,
                    userImage: viewModel.userImage,
                    onSearchTap: { coordinator.showSearch() },
                    onNotificationTap: { coordinator.showNotifications() }
                )
                .padding(.horizontal, 16)

                // More components...
            }
        }
    }
}
```

### Component Guidelines

1. **Naming**: Prefix with feature name (`Home`, `Login`, etc.)
2. **Props**: Use `let` for data, `var` for closures
3. **Actions**: Pass coordinator actions as closures, not coordinator reference
4. **Styling**: Use project styles (`.expoSystemFont`, `.mainColor`, `FontSize`)
5. **Localization**: Use `"key".localized` for all text
6. **Preview**: Always include `#Preview` with sample data

## User Flows

### Login Flow
```
LoginView → (success) → handleNextFlow() → TabBar
         → (needsActivation) → VerificationCodeView → LocationPicker → TabBar
```

### Visitor Flow
```
LoginView → "Login as visitor" → isVisitor = true → handleNextFlow() → TabBar
```

### Logout Flow
```
MoreCoordinator → LogoutConfirmation → onLogout() → TabBarCoordinator.logout()
→ AppCoordinator.showAuth()
```


