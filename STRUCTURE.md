# RentNow — Project Structure

RentNow is an iOS car rental app built with **SwiftUI** using a **Coordinator Pattern + MVVM** architecture. It supports English and Arabic (RTL), integrates Firebase for push notifications, and uses Google Maps for location features.

This document is a complete inventory of the source tree. For architectural conventions (model decoding rules, networking flow, naming conventions, localization keys, etc.) see `CLAUDE.md`.

## TL;DR

| Stat | Value |
|---|---|
| Total `.swift` files | **386** |
| Top-level folders under `RentNow/` | 5 (App, Core, Networking, Resourses, Shared) |
| Feature modules under `App/` | 7 (Auth, Main, Home, Orders, AddAd, Wallet, More) |
| Coordinator files | 13 |
| Shared subsystems | 11 (BaseViewModel, Combine, Foundation, Helper, Loader, Localization, Location, LoginRequiredView, SwiftUI, Utilities, Validation) |
| Localizations | English (`en.lproj`), Arabic (`ar.lproj`) |

---

## 1. Project Root — `/Users/apple/Desktop/rent-now/`

```
rent-now/
├── RentNow.xcodeproj/        # Xcode project
├── RentNow/                  # Source root (expanded below)
├── CLAUDE.md                 # Architectural conventions for AI assistants
├── STRUCTURE.md              # This file
├── .git/
├── .claude/
└── .specify/
```

---

## 2. `RentNow/` Source Root

```
RentNow/
├── App/            # Feature modules + Coordinator graph
├── Core/           # App entry (RentNowApp.swift) + Firebase config
├── Networking/     # Alamofire-based request/response infrastructure
├── Resourses/      # Assets, fonts, Google Maps JSON styles
└── Shared/         # Cross-cutting: BaseViewModel, components, localization, validation
```

---

## 3. `App/CoordinatorPattern/` — Navigation Backbone

The Coordinator layer owns navigation. Every coordinator extends `BaseCoordinator<Route>` and exposes a typed `Route` enum; navigation is driven by `NavigationStack(path:)`. See `CLAUDE.md` for the full coordinator contract.

```
App/CoordinatorPattern/
├── Coordinator/
│   ├── Coordinator.swift                 # BaseCoordinator<Route>, presentation modifiers
│   └── HashableExtensions.swift          # Hashable helpers for Route enums
├── AppCoordinator/
│   ├── AppCoordinator.swift              # Root: splash → intro → auth → main flow switch
│   └── SessionManager.swift              # Auth/session state, sessionExpired publisher
└── ChildsCoordinators/
    ├── AuthCoordinator/
    │   └── AuthCoordinator.swift         # Login / Register / OTP / forgot+reset password
    ├── SplachCoordinator/
    │   └── SplashCoordinator.swift       # Splash screen routing
    ├── TabBarCoordinator/
    │   └── TabBarCoordinator.swift       # 5-tab container + logout fan-out to AppCoordinator
    └── TabsCoordinatoors/
        ├── HomeCoordinator/
        │   └── HomeCoordinator.swift     # Home tab: categories, ad details, search, create order
        ├── OrdersCoordinator/
        │   └── OrdersCoordinator.swift   # Orders tab: list, details, create report
        ├── AddAdCoordinator/
        │   └── AddAdCoordinator.swift    # AddAd tab (gated by visitor mode)
        ├── WalletCoordinator/
        │   └── WalletCoordinator.swift   # Wallet tab: subscription, packages
        └── MoreCoordinator/
            ├── MoreCoordinator.swift           # More tab: profile, settings, ads, complaints, …
            └── MoreCoordinatorProtocol.swift   # Protocol surface for the More flows
```

---

## 4. Feature Modules — `App/`

All feature modules follow a **`View/` + `ViewModel/` + `Model/` + `Network/`** layout. Most screens have their UI broken into `…CustomViews/` subfolders (one folder per visual section, one file per `View` struct). ViewModels extend `BaseViewModel` (`Shared/BaseViewModel/`).

### 4.1 `App/Auth/` — Authentication (31 files)

Login, register, OTP verification, forgot/reset password. Login supports a "visitor" mode that skips auth and lands in the TabBar with restricted features.

```
Auth/
├── Login/
│   ├── LoginModel/
│   │   └── LoginValidation.swift
│   ├── LoginView/
│   │   ├── LoginView.swift
│   │   └── LoginCustomViews/
│   │       ├── ForgetPassButton/ForgetPasswordButton.swift
│   │       ├── HeaderView/LoginHeaderView.swift
│   │       ├── RegisterButton/RegisterButton.swift
│   │       └── VisitorButton/VisitorButton.swift
│   └── LoginViewModel/
│       └── LoginViewModel.swift
├── Register/
│   ├── RegisterModel/
│   │   ├── RegisterModel.swift
│   │   └── RegisterValidation.swift
│   ├── RegisterView/
│   │   ├── RegisterView.swift
│   │   └── RegisterCustomViews/
│   │       ├── HeaderView/RegisterHeaderView.swift
│   │       ├── LoginButton/LoginButton.swift
│   │       └── TermsButton/termsButton.swift
│   └── RegisterViewModel/
│       └── RegisterViewModel.swift
├── ActiveCode/                        # OTP verification flow
│   ├── Model/
│   │   ├── ActiveCodeValidation.swift
│   │   └── VerificationCodeModel.swift
│   ├── View/
│   │   ├── VerificationCodeView.swift
│   │   └── VerificationCustomViews/
│   │       ├── HeaderView/VerificationCodeHeaderView.swift
│   │       ├── OTPView/
│   │       │   ├── OTPView.swift
│   │       │   └── OTPTextField/OTPTextField.swift
│   │       └── ResendCode/ResendCodeButton.swift
│   └── ViewModel/
│       └── VerificationCodeViewModel.swift
├── ForgetPassword/
│   ├── ForgetPasswordModel/
│   │   └── ForgetPasswordValidation.swift
│   ├── ForgetPasswordView/
│   │   ├── ForgetPasswordView.swift
│   │   └── LoginCustomViews/
│   │       └── HeaderView/ForgetPasswordHeaderView.swift
│   └── ForgetPasswordViewModel/
│       └── ForgetPasswordViewModel.swift
├── ResetPassword/
│   ├── ResetPasswordModel/
│   │   └── ResetPasswordValidation.swift
│   ├── ResetPasswordView/
│   │   ├── ResetPasswordView.swift
│   │   └── ResetPasswordCustomViews/
│   │       └── HeaderView/ResetPasswordHeaderView.swift
│   └── ResetPasswordViewModel/
│       └── ResetPasswordViewModel.swift
└── Network/
    └── AuthEndpoint.swift
```

### 4.2 `App/Main/` — App Flow Screens (10 files)

Pre-tab-bar lifecycle: splash, onboarding intro, and the TabBar container itself.

```
Main/
├── Splash/
│   └── SplashView/
│       └── SplashView.swift
├── Intro/                             # First-launch onboarding pager
│   ├── IntroModel/
│   │   └── IntroPageModel.swift
│   ├── IntroView/
│   │   ├── IntroView.swift
│   │   └── IntroCustomViews/
│   │       ├── IntroHeaderView.swift
│   │       ├── IntroNavigationView.swift
│   │       └── IntroPageView.swift
│   ├── IntroViewModel/
│   │   └── IntroViewModel.swift
│   └── Network/
│       └── IntroEndpoint.swift
└── TabBar/
    ├── TabBarView.swift               # Native TabView(selection:) container
    └── TabItem.swift                  # 5 tab cases + localized titles + SF Symbols
```

### 4.3 `App/Home/` — Home Tab (70 files)

The largest tab. Hosts the home dashboard, category browsing & filtering, advertisement details, the entire create-order flow, search, ratings, airport pickup sheets, push notifications (FCM), provider profiles, and cancellation terms.

```
Home/
├── HomeView/
│   ├── Model/
│   │   └── HomeDetailsModel.swift
│   ├── HomeView/
│   │   ├── HomeView.swift
│   │   └── HomeCustomViews/
│   │       ├── CategoriesSection/HomeCategoriesSectionView.swift
│   │       ├── TopHeader/HomeTopHeaderView.swift
│   │       └── WelcomeSection/HomeWelcomeSectionView.swift
│   └── HomeViewModel/
│       └── HomeViewModel.swift
├── mainCateogryDetails/               # Category browse + filter
│   ├── Model/
│   │   ├── FilterDataModel.swift
│   │   └── MainCategoryDetailsModel.swift
│   ├── View/
│   │   ├── MainCategoryDetailsView.swift
│   │   └── CustomViews/
│   │       ├── CarCard/MainCategoryDetailsCarCardView.swift
│   │       ├── SearchBar/MainCategoryDetailsSearchBarView.swift
│   │       └── SubcategoryChips/MainCategoryDetailsSubcategoryChipsView.swift
│   ├── ViewModel/
│   │   └── MainCategoryDetailsViewModel.swift
│   └── Filter/
│       ├── FilterContainerView.swift
│       ├── FilterSheetView.swift
│       ├── FilterSheetViewModel.swift
│       ├── CustomViews/
│       │   ├── FilterCheckboxRowView.swift
│       │   ├── FilterPriceRangeView.swift
│       │   ├── FilterSectionHeaderView.swift
│       │   └── FilterSelectionRowView.swift
│       └── SelectionPicker/
│           └── FilterSelectionView.swift
├── advertisementDetails/              # Single ad detail screen
│   ├── Model/
│   │   └── AdvertisementDetailsModel.swift
│   ├── View/
│   │   ├── AdvertisementDetailsView.swift
│   │   └── CustomViews/
│   │       ├── AdvertisementDetailsBottomBarView.swift
│   │       ├── AdvertisementDetailsCarDetailsView.swift
│   │       ├── AdvertisementDetailsImageSliderView.swift
│   │       ├── AdvertisementDetailsLocationView.swift
│   │       ├── AdvertisementDetailsProviderView.swift
│   │       ├── AdvertisementDetailsRatingsView.swift
│   │       ├── AdvertisementDetailsSimilarAdsView.swift
│   │       └── AdvertisementDetailsTitleView.swift
│   └── ViewModel/
│       └── AdvertisementDetailsViewModel.swift
├── CreateOrder/                       # Booking form + pricing breakdown
│   ├── Model/
│   │   └── CreateOrderModel.swift
│   ├── View/
│   │   ├── CreateOrderView.swift
│   │   └── CreateOrderCustomViews/
│   │       ├── AdditionalFeaturesSection/CreateOrderAdditionalFeaturesSectionView.swift
│   │       ├── CarInfoCard/CreateOrderCarInfoCardView.swift
│   │       ├── DateRange/CreateOrderDateRangeView.swift
│   │       ├── DeliveryMethodSection/CreateOrderDeliveryMethodView.swift
│   │       ├── InfoSection/CreateOrderInfoSectionView.swift
│   │       ├── PaymentMethodSection/CreateOrderPaymentMethodView.swift
│   │       ├── PriceSummaryBar/CreateOrderPriceSummaryBarView.swift
│   │       ├── ReturnPickupMethodSection/CreateOrderReturnPickupMethodView.swift
│   │       └── TermsSection/CreateOrderTermsSectionView.swift
│   └── ViewModel/
│       └── CreateOrderViewModel.swift
├── AllRatings/
│   ├── Model/AllRatingsModel.swift
│   ├── Network/AllRatingsEndpoint.swift
│   ├── View/AllRatingsView.swift
│   └── ViewModel/AllRatingsViewModel.swift
├── AirportsSheet/                     # Delivery / return airport picker
│   ├── Model/AirportModel.swift
│   ├── AirportsSheetView/
│   │   ├── AirportsSheetView.swift
│   │   └── AirportsSheetCustomViews/
│   │       ├── AirportRadioButton/AirportRadioButtonView.swift
│   │       └── EmptyAirportsView/EmptyAirportsView.swift
│   └── AirportsSheetViewModel/
│       └── AirportsSheetViewModel.swift
├── Notifications/
│   ├── Model/NotificationModel.swift
│   ├── NotificationsView/
│   │   ├── NotificationsView.swift
│   │   └── NotificationsCustomViews/
│   │       ├── DeleteConfirmationAlert/DeleteConfirmationAlert.swift
│   │       └── NotificationCardView/NotificationCardView.swift
│   ├── NotificationsViewModel/
│   │   └── NotificationsViewModel.swift
│   └── FCM/                           # Firebase Cloud Messaging integration
│       ├── AppDelegateBridge.swift
│       ├── NotificationManager.swift
│       └── NotificationRouter.swift
├── Search/
│   ├── View/SearchView.swift
│   └── ViewModel/SearchViewModel.swift
├── ProviderProfile/
│   ├── Model/ProviderProfileModel.swift
│   ├── View/ProviderProfileView.swift
│   └── ViewModel/ProviderProfileViewModel.swift
├── CancellationTerms/
│   ├── Model/CancellationTermsModel.swift
│   ├── View/CancellationTermsView.swift
│   └── ViewModel/CancellationTermsViewModel.swift
└── Network/
    └── HomeEndpoint.swift
```

### 4.4 `App/Orders/` — Orders Tab (24 files)

User's bookings: list, full details (including odometer capture, extra-km payment sheet, rating sheet), and incident reporting.

```
Orders/
├── OrdersList/
│   ├── Model/OrderModel.swift
│   ├── View/
│   │   ├── OrdersView.swift
│   │   └── OrdersCustomViews/
│   │       ├── EmptyState/OrdersEmptyStateView.swift
│   │       ├── FilterTabs/OrdersFilterTabsView.swift
│   │       └── OrderCard/OrdersCardView.swift
│   └── ViewModel/OrdersViewModel.swift
├── OrderDetails/
│   ├── Model/OrderDetailsModel.swift
│   ├── View/
│   │   ├── OrderDetailsView.swift
│   │   └── CustomViews/
│   │       ├── OrderDetailsCarInfoView.swift
│   │       ├── OrderDetailsDeliveryView.swift
│   │       ├── OrderDetailsExtraKMView.swift
│   │       ├── OrderDetailsInfoView.swift
│   │       ├── OrderDetailsOdometerView.swift
│   │       ├── OrderDetailsOrderCardView.swift
│   │       ├── OrderDetailsPaymentView.swift
│   │       ├── OrderDetailsPricingSummaryView.swift
│   │       ├── ExtraKMPayment/OrderDetailsExtraKMPaymentSheetView.swift
│   │       ├── OdometerCapture/CameraHostView.swift
│   │       ├── RatingCard/OrderDetailsRatingCardView.swift
│   │       └── RatingSheet/OrderDetailsRatingSheetView.swift
│   └── ViewModel/OrderDetailsViewModel.swift
├── CreateReport/
│   ├── View/CreateReportView.swift
│   └── ViewModel/CreateReportViewModel.swift
└── Network/
    └── OrdersEndpoint.swift
```

### 4.5 `App/AddAd/` — AddAd Tab (5 files)

Single-screen flow for listing a new car ad. Gated behind a visitor check on tab tap.

```
AddAd/
├── Model/
│   ├── AddAdFormDataModel.swift
│   └── CreateAdResponse.swift
├── View/
│   └── AddAdView.swift
├── ViewModel/
│   └── AddAdViewModel.swift
└── Network/
    └── AddAdEndpoint.swift
```

### 4.6 `App/Wallet/` — Wallet Tab (11 files)

Subscription state, cancel-subscription flow, and the packages catalog.

```
Wallet/
├── Wallet/
│   ├── Model/WalletModel.swift
│   ├── View/
│   │   ├── WalletView.swift
│   │   └── WalletCustomViews/
│   │       ├── Buttons/WalletButtonStyles.swift
│   │       ├── CancelConfirmation/CancelSubscriptionConfirmationView.swift
│   │       ├── NoSubscription/WalletNoSubscriptionView.swift
│   │       └── SubscriptionCard/WalletSubscriptionCardView.swift
│   └── ViewModel/WalletViewModel.swift
├── PackagesListView/
│   ├── View/
│   │   ├── PackagesListView.swift
│   │   └── PackagesListCustomViews/
│   │       └── PackageCard/PackagesListCardView.swift
│   └── ViewModel/PackagesListViewModel.swift
└── Network/
    └── WalletEndpoint.swift
```

### 4.7 `App/More/` — More Tab (99 files, largest module)

Everything outside the four primary tabs: account, ads management, customer orders (as a provider), financials, complaints, reports, contact, info pages, settings (change password / change phone OTP flow), and logout confirmation.

```
More/
├── MoreView/
│   ├── MoreView/
│   │   ├── MoreView.swift
│   │   └── MoreCustomViews/
│   │       ├── LogoutButton/MoreLogoutButtonView.swift
│   │       ├── MenuItem/MoreMenuItemView.swift
│   │       ├── SubscriptionBanner/MoreSubscriptionBannerView.swift
│   │       └── TopHeader/MoreTopHeaderView.swift
│   └── MoreViewModel/MoreViewModel.swift
├── MyAds/
│   ├── MyAdsListView/
│   │   ├── Model/MyAdsModel.swift
│   │   ├── View/
│   │   │   ├── MyAdsView.swift
│   │   │   └── MyAdsCustomViews/
│   │   │       ├── AdCard/MyAdsCardView.swift
│   │   │       └── FilterTabs/MyAdsFilterTabsView.swift
│   │   └── ViewModel/MyAdsViewModel.swift
│   ├── MyAdsDetailsView/
│   │   ├── Model/MyAdDetailsModel.swift
│   │   ├── View/
│   │   │   ├── MyAdDetailsView.swift
│   │   │   ├── AdDetails/
│   │   │   │   ├── MyAdDetailsKilometerView.swift
│   │   │   │   └── MyAdDetailsOtherDetailsView.swift
│   │   │   └── CustomViews/
│   │   │       ├── AdStatusToggle/MyAdDetailsStatusToggleView.swift
│   │   │       ├── AdditionalServices/MyAdDetailsAdditionalServicesView.swift
│   │   │       ├── DeleteSheet/MyAdDetailsDeleteSheetView.swift
│   │   │       ├── ImageOverlayButtons/MyAdDetailsImageOverlayButtonsView.swift
│   │   │       ├── RejectionReason/MyAdDetailsRejectionReasonView.swift
│   │   │       └── TitleSection/MyAdDetailsTitleSectionView.swift
│   │   └── ViewModel/MyAdDetailsViewModel.swift
│   └── EditAd/
│       ├── Model/EditAdResponseData.swift
│       ├── View/EditAdView.swift
│       └── ViewModel/EditAdViewModel.swift
├── EditProfile/
│   ├── Model/
│   │   ├── EditProfileModel.swift
│   │   └── UpdateProfileResponse.swift
│   ├── View/
│   │   ├── EditProfileView.swift
│   │   └── CustomViews/EditProfileImageView.swift
│   └── ViewModel/EditProfileViewModel.swift
├── Settings/
│   ├── SettingsView/
│   │   ├── View/
│   │   │   ├── SettingsView.swift
│   │   │   └── CustomViews/
│   │   │       ├── SettingsDeleteAccountRow.swift
│   │   │       ├── SettingsMenuItemView.swift
│   │   │       └── SettingsNotificationRow.swift
│   │   └── ViewModel/SettingsViewModel.swift
│   ├── ChangePassword/
│   │   └── ChangePasswordView/
│   │       ├── View/ChangePasswordView.swift
│   │       └── ViewModel/ChangePasswordViewModel.swift
│   └── ChangePhone/                   # 3-step flow: password → number → OTP code
│       ├── ChangePhonePasswordView/
│       │   ├── View/ChangePhonePasswordView.swift
│       │   └── ViewModel/ChangePhonePasswordViewModel.swift
│       ├── ChangePhoneNumberView/
│       │   ├── View/ChangePhoneNumberView.swift
│       │   └── ViewModel/ChangePhoneNumberViewModel.swift
│       └── ChangePhoneCodeView/
│           ├── View/ChangePhoneCodeView.swift
│           └── ViewModel/ChangePhoneCodeViewModel.swift
├── MyRatings/
│   ├── Model/MyRatingsModel.swift
│   ├── View/
│   │   ├── MyRatingsView.swift
│   │   └── MyRatingsCustomViews/MyRatingItemCardView.swift
│   └── ViewModel/MyRatingsViewModel.swift
├── PersonalProfile/
│   ├── Model/ProfileInfoModel.swift
│   ├── View/
│   │   ├── PersonalProfileView.swift
│   │   └── CustomViews/PersonalProfileCardView.swift
│   └── ViewModel/PersonalProfileViewModel.swift
├── FinancialTransactions/             # Wallet-side: bank accounts, settlements
│   ├── Model/FinancialTransactionsModel.swift
│   ├── Network/FinancialEndpoint.swift
│   ├── BankAccountForm/
│   │   ├── View/BankAccountFormView.swift
│   │   └── ViewModel/BankAccountFormViewModel.swift
│   ├── FinancialTransactionsList/
│   │   ├── View/
│   │   │   ├── FinancialTransactionsView.swift
│   │   │   └── FinancialCustomViews/
│   │   │       ├── FilterTabs/FinancialFilterTabsView.swift
│   │   │       ├── OrderCard/FinancialOrderCardView.swift
│   │   │       ├── SettlementCard/FinancialSettlementCardView.swift
│   │   │       └── SummaryCard/FinancialSummaryCardView.swift
│   │   └── ViewModel/FinancialTransactionsViewModel.swift
│   └── SettlementDetails/
│       ├── View/
│       │   ├── SettlementDetailsView.swift
│       │   └── SettlementDetailsCustomViews/
│       │       └── StatusBanner/SettlementStatusBannerView.swift
│       └── ViewModel/SettlementDetailsViewModel.swift
├── CustomerOrders/                    # Orders from the provider's perspective
│   ├── CustomerOrdersListView/
│   │   ├── Model/CustomerOrdersModel.swift
│   │   ├── View/
│   │   │   ├── CustomerOrdersView.swift
│   │   │   └── CustomerOrdersCustomViews/
│   │   │       ├── FilterTabs/CustomerOrdersFilterTabsView.swift
│   │   │       └── OrderCard/CustomerOrderCardView.swift
│   │   └── ViewModel/CustomerOrdersViewModel.swift
│   └── CustomerOrderDetailsView/
│       ├── View/
│       │   ├── CustomerOrderDetailsView.swift
│       │   └── CustomViews/UserCardView.swift
│       └── ViewModel/CustomerOrderDetailsViewModel.swift
├── Complaints/
│   ├── ComplaintsList/
│   │   ├── Model/ComplaintsModel.swift
│   │   ├── View/
│   │   │   ├── ComplaintsView.swift
│   │   │   └── ComplaintsCustomViews/ComplaintCard/ComplaintCardView.swift
│   │   └── ViewModel/ComplaintsViewModel.swift
│   ├── ComplaintDetails/
│   │   ├── Model/ComplaintDetailModel.swift
│   │   ├── View/
│   │   │   ├── ComplaintDetailView.swift
│   │   │   └── ComplaintDetailCustomViews/
│   │   │       ├── ContentCard/ComplaintDetailContentCardView.swift
│   │   │       └── InfoCard/ComplaintDetailInfoCardView.swift
│   │   └── ViewModel/ComplaintDetailViewModel.swift
│   └── CreateComplaints/
│       ├── View/CreateComplaintView.swift
│       └── ViewModel/CreateComplaintViewModel.swift
├── Reports/
│   ├── ReportsList/
│   │   ├── Model/ReportModel.swift
│   │   ├── View/
│   │   │   ├── ReportsView.swift
│   │   │   └── ReportsCustomViews/ReportCard/ReportCardView.swift
│   │   └── ViewModel/ReportsViewModel.swift
│   └── ReportDetails/
│       ├── View/
│       │   ├── ReportDetailView.swift
│       │   └── ReportDetailCustomViews/
│       │       ├── ContentCard/ReportDetailContentCardView.swift
│       │       └── InfoCard/ReportDetailInfoCardView.swift
│       └── ViewModel/ReportDetailViewModel.swift
├── ContactUs/
│   ├── Model/ContactUsModel.swift
│   ├── View/ContactUsView.swift
│   └── ViewModel/ContactUsViewModel.swift
├── InfoContent/                       # Generic CMS-driven info page (terms, about, …)
│   ├── Model/InfoContentModel.swift
│   ├── View/InfoContentView.swift
│   └── ViewModel/InfoContentViewModel.swift
├── LogoutConfirmationView/
│   └── LogoutConfirmationView.swift
└── NetWork/
    └── MoreEndpoint.swift
```

---

## 5. `Core/` — App Entry (1 swift file)

```
Core/
├── RentNowApp.swift              # @main App, root WindowGroup → AppCoordinator
└── GoogleService-Info.plist      # Firebase configuration
```

---

## 6. `Networking/` — Request/Response Layer (17 files)

Generic, endpoint-driven Alamofire wrapper. Flow: `ViewModel.request(endpoint)` → `Endpoint<T>` → `NetworkExecuter` → `ResponseHandler` → `BaseResponse<T>`. `BaseViewModel` auto-handles `.unauthenticated` via `SessionManager`.

```
Networking/
├── BaseResponse/
│   ├── BaseResponse.swift              # Wraps { key, message, data }
│   └── ServerResponseKey.swift         # .success / .fail / .unauthenticated / .blocked / .needActive / .exception
├── HandelRequest/
│   ├── Endpoint.swift                  # Endpoint<T> generic
│   ├── RequestEncoding.swift
│   ├── RequestHeader.swift
│   ├── Requestable.swift
│   ├── Typealias.swift
│   └── UploadData.swift                # Multipart upload helper
├── HandleResponse/
│   ├── DefaultNetworkExecuter.swift    # Alamofire-backed executor
│   ├── NetworkExecuter.swift           # Protocol
│   ├── ResponseDecoder.swift
│   ├── ResponseError.swift
│   └── ResponseHandler.swift
├── EmptyResponse.swift                 # Decodable placeholder for empty payloads
├── NetworkConstants.swift              # Base URL, timeouts
├── Reachability.swift                  # Network availability monitoring
└── UserModel.swift                     # Authenticated user payload
```

Base URL: `https://dashboard.rentnow-app.com/API/`

---

## 7. `Resourses/` — Assets, Fonts, Maps (4 swift files)

```
Resourses/
├── Fonts/
│   ├── Files/                          # .ttf / .otf font binaries (ExpoArabic family)
│   ├── ExpoArabicFont.swift            # Font name enum
│   ├── UIFonts.swift                   # Font size constants
│   └── UIKit+UIFont.swift              # UIFont factory + .expoSystemFont(...) extension
├── JSON/
│   └── GoogleMapsStyles/
│       └── GoogleMapsStylesNames.swift # Style asset name enum
└── Assets.xcassets/                    # Image, color, app icon sets (incl. .mainColor, .splashColor)
```

Localization `.strings` files live under `Shared/Localization/Strings/{en,ar}.lproj/Localizable.strings`.

---

## 8. `Shared/` — Cross-Cutting (101 files)

Reusable infrastructure: the BaseViewModel, networking sugar, form/input components, loaders, toasts, media viewer, location picker, validation, and localization.

```
Shared/
├── BaseViewModel/
│   └── BaseViewModel.swift             # @MainActor base; handles loading, toasts, request(), session expiry
├── Combine/
│   └── Publisher.swift                 # Combine sugar
├── Foundation/                         # Swift stdlib extensions
│   ├── Array.swift
│   ├── CGFloat.swift
│   ├── Collection.swift
│   ├── Double.swift
│   ├── NSNotificationNames.swift
│   ├── String.swift                    # .localized accessor
│   └── UserDefaults.swift              # @ValueDefault / @ModelsDefault property wrappers
├── Helper/
│   ├── AppHelper.swift
│   └── ImagePicker/
│       ├── ImagePicker.swift
│       ├── UIWindow.swift
│       └── Localization/
│           └── ImagePicker+Localization.swift
├── Loader/                             # Full-screen loading indicators
│   ├── LoaderManager.swift
│   ├── AnimateGifImage.swift
│   ├── Indicator/
│   │   └── AppIndicator.swift
│   └── LoaderView/
│       ├── LoaderView.swift
│       └── LottieView.swift
├── Localization/
│   ├── Language.swift                  # setAppLanguage(lang:), current language state
│   ├── Extensions+Bundle.swift         # Runtime locale swap
│   ├── Extensions+UICollectionView.swift
│   ├── Localizable+Storyboard.swift
│   └── Strings/
│       ├── en.lproj/Localizable.strings
│       └── ar.lproj/Localizable.strings
├── Location/                           # Google Maps + LocationManager wrapper
│   ├── LocationHelper.swift
│   └── LocationView/
│       ├── MapSettings/
│       │   ├── GoogleMapsRepresentable.swift
│       │   └── LocationManager.swift
│       ├── View/
│       │   ├── LocationPickerView.swift
│       │   └── LocationCustomView/
│       │       └── LocationBottomSheetView.swift
│       └── ViewModel/
│           └── LocationPickerViewModel .swift
├── LoginRequiredView/                  # Visitor-mode gating prompts
│   ├── LoginRequiredView.swift
│   ├── LoginRequiredAlertView.swift
│   └── LoginRequiredPopupView.swift
├── SwiftUI/                            # The bulk of shared UI (66 files)
│   ├── EmptyPlaceholderView.swift
│   ├── ImageSliderView.swift
│   ├── LinearGradient+Extensions.swift
│   ├── ProfileImagePickerView.swift
│   ├── RangeSliderView.swift
│   ├── RemoteImageView.swift
│   ├── View+SafeArea.swift
│   ├── Alart(Toast)/                   # In-app toasts + no-internet alert
│   │   ├── ToastEnum.swift
│   │   ├── ToastManager.swift
│   │   ├── ToastView.swift
│   │   └── NoInternetAlert/
│   │       ├── NoInternetAlertManager.swift
│   │       └── NoInternetAlertView.swift
│   ├── Components/                     # Misc one-off shared views
│   │   ├── GifImageView.swift
│   │   ├── LottieSwiftUIView.swift
│   │   ├── NafathVerificationPopupView.swift
│   │   ├── SafariWebView.swift
│   │   ├── SuccessPopupView.swift
│   │   └── SuccessView.swift
│   ├── GlassyBackground/
│   │   └── GlassyBackgroundModifier.swift   # .glassyBackground(cornerRadius:) modifier
│   ├── GlassyButton/
│   │   └── GlassyButton.swift
│   ├── MainButton/
│   │   └── MainButton.swift                  # Primary CTA (gradient)
│   ├── OutlineButton/
│   │   └── OutlineButton.swift               # Secondary CTA
│   ├── MainViewShared/
│   │   ├── AppGradientView.swift             # MainGradientView background
│   │   ├── BaseView.swift                    # Wraps screens w/ loading + toast handling
│   │   └── navButton.swift
│   ├── RatingCard/
│   │   └── RatingCardView.swift
│   ├── SharedViews/                          # Image / video galleries + viewer
│   │   ├── ImageGalleryView.swift
│   │   ├── SingleImageView.swift
│   │   ├── VideoPlayerView.swift
│   │   └── MediaViewer/
│   │       ├── LoadingOverlayView.swift
│   │       ├── MediaViewerManager.swift
│   │       └── MediaViewerModifier.swift
│   ├── TextView/                             # Form input library (the design-system inputs)
│   │   ├── FixedTextField.swift
│   │   ├── FixedSecureField.swift
│   │   ├── AppTextView/
│   │   │   └── AppTextView.swift             # Standard text input
│   │   ├── AppTextViewEditor/
│   │   │   └── AppTextEditor.swift           # Multi-line editor
│   │   ├── PasswordTextView/
│   │   │   └── PasswordTextView.swift        # Password w/ visibility toggle
│   │   ├── EmailTextView/
│   │   │   └── EmailTextView.swift
│   │   ├── PhoneTextView/
│   │   │   ├── PhoneTextView/PhoneTextView.swift
│   │   │   └── CountryCodePickerView/
│   │   │       ├── CountryCodePickerView.swift
│   │   │       ├── CountryFlagImageView/CountryFlagView.swift
│   │   │       └── CountryModel/CountryModel.swift
│   │   ├── PickerTextView/                   # Generic dropdown (GeneralPickerModel)
│   │   │   ├── AppPickerField.swift
│   │   │   ├── PickerModel.swift
│   │   │   └── PickerSheetView.swift
│   │   ├── AppLocationTextView/
│   │   │   ├── AppLocationModel.swift
│   │   │   └── AppLocationTextView.swift
│   │   ├── AppDatePickerField/
│   │   │   └── AppDatePickerField.swift      # Date / time picker (mode: .date / .time)
│   │   ├── AppDocumentPickerField/
│   │   │   └── AppDocumentPickerField.swift
│   │   ├── AppSegmentedControl/
│   │   │   ├── AppSegmentedControl.swift
│   │   │   ├── Model/SegmentOption.swift
│   │   │   └── SegmentButton/
│   │   │       ├── RadioButton.swift
│   │   │       └── SegmentButton.swift
│   │   └── AppImagePickerView/               # Camera + PHPicker + QuickLook
│   │       ├── Model/MediaModel.swift
│   │       ├── QuickLookCoordinator/QuickLookView.swift
│   │       └── View/
│   │           ├── AppImagePickerView.swift
│   │           └── SupViews/
│   │               ├── NativeCameraView/NativeCameraView.swift
│   │               └── PHPickerView/PHPickerView.swift
│   └── Utilites/                             # Small helpers (note: folder name spelled "Utilites")
│       ├── " GlobalFunctions.swift"          # Note: leading space in filename
│       ├── ColorExtension.swift              # .mainColor, .text, .grayTextColor, …
│       ├── HeightReader.swift
│       ├── Image.swift
│       ├── NonOptional.swift
│       ├── SuccessMessageManager.swift
│       ├── SuccessMessageView.swift
│       └── pushNavgation.swift
├── Utilities/                                # (separate from SwiftUI/Utilites)
│   ├── MapHelper.swift
│   └── View+MapHelper.swift
└── Validation/
    └── GerenralValidation/
        ├── GeneralValidationService.swift    # Email / phone / password validators
        └── GerenralValidationError.swift
```

---

## 9. Conventions Cheatsheet

A condensed reminder; the source of truth is `CLAUDE.md`.

- **Per-feature layout** — `Feature/View/`, `Feature/ViewModel/`, `Feature/Model/`, `Feature/Network/`. UI sections of a screen go into a `…CustomViews/` subfolder, one file per `View` struct, prefixed with the feature name.
- **Coordinator** — extends `BaseCoordinator<Route>`. Each tab has its own coordinator under `App/CoordinatorPattern/ChildsCoordinators/TabsCoordinatoors/`. Navigation uses `NavigationStack(path: bindingPath)`.
- **ViewModel** — extends `BaseViewModel` (`@MainActor`); use `request(endpoint)` for networking, `showIndicator()` / `hideIndicator()` for loading, `showError(_)` for toasts.
- **Model decoding** — all properties optional, custom `init(from decoder:)` using `decodeIfPresent` with safe defaults (`?? ""`, `?? []`, `?? 0.0`). See `CLAUDE.md` for the full pattern.
- **Localization** — keys are the **English text itself** (e.g. `"Personal Profile"`, not `"personal_profile.title"`). Access with `"…".localized`. Add both `en.lproj` and `ar.lproj` strings.
- **Styling** — Custom font via `.expoSystemFont(size:weight:)`; colors via extensions (`.mainColor`, `.text`, `.grayTextColor`, …); shared backgrounds via `.glassyBackground(cornerRadius:)`; primary CTA via `MainButton`, secondary via `OutlineButton`.
- **Session** — `BaseViewModel` auto-handles `.unauthenticated`; `AppCoordinator` observes `SessionManager.shared.sessionExpired` to force logout.

## Shared payment code

`RentNow/Shared/Payment/` is organized by responsibility:

- `Models/`: backend response models. `PayOrderData.swift` includes the nested Tabby and Tamara payloads; `OrderPaymentOption.swift` describes booking payment choices. `OrderPaymentStatusData.swift` maps `Payment/Status`, while `PaymentStatusData.swift` maps `Payment/GetStatus`. These endpoints have different response contracts. `PaymentInitiationData.swift` serves wallet, package, and extra-kilometer payments. Provider and transaction-ID decoding helpers are also here.
- `Checkout/`: shared `PaymentSession.swift` and `BaseCoordinator+Payment.swift`. The coordinator chooses the provider's checkout screen and returns its result.
- `Network/PaymentEndpoint.swift`: payment status API requests.
- `Tabby/`: SDK configuration and installment widget. `Checkout/TabbyCheckoutView.swift`, `TabbyCheckoutViewModel.swift`, and `TabbyCheckoutWebView.swift` own the Tabby screen, event-driven backend verification, and JavaScript bridge. There is no background polling.
- `Moyasar/Checkout/`: `MoyasarCheckoutView.swift`, `MoyasarCheckoutViewModel.swift`, and `MoyasarCheckoutWebView.swift` own the hosted payment screen, status polling, and return-home navigation. These files contain no Tabby handling.
- `Tamara/Checkout/`: `TamaraCheckoutView.swift` presents the official SDK through `TamaraSDKCheckoutView.swift`; `TamaraCheckoutViewModel.swift` verifies the backend payment status. Tamara does not use the app's Moyasar or Tabby web views.

## Tamara order payments

- Selecting an available Tamara option in `CreateOrderView` displays `TamaraInstallmentView` with the confirmed summary total. It embeds Tamara's official sandbox summary widget using the sandbox public key from the integration kit, with Arabic/English matching the app. The web view fits the widget's rendered height; tapping it opens the official mobile payment-plan information page in a Safari sheet. `TamaraWidgetConfiguration` owns the public key and sandbox widget URLs; switch both to production together after approval.
- Swift Package Manager pins the official `https://github.com/Tamara-Technology/ios-sdk.git` package to `1.0.19` (`TamaraSDK`). The backend creates the session, so the app does not configure Tamara API credentials or create a second session.
- `PayOrder` provider `tamara` opens checkout only when the payment is pending/unpaid and `tamara.isEligible` is true. Backend refusal text is shown as received. Invalid or incomplete checkout URLs/IDs are rejected before presentation.
- `PaymentSession` retains the transaction ID, RentNow order ID, and full Tamara payload (including Tamara order/checkout IDs). The SDK's `TamaraSDKCheckout` receives `checkoutUrl`, `successUrl`, `failureUrl`, and `cancelUrl` unchanged. Its required `notification` argument is empty because this SDK controller does not use it; webhooks are server-only.
- SDK success triggers up to 20 status checks, three seconds apart; failure, cancel, or the Close button triggers one. No status requests run while entering payment details. Duplicate SDK callbacks are ignored. Every response must match the transaction, provider, and RentNow order; only backend `Paid` shows success. `NeedsReview` displays the server message and refreshes the order. Unconfirmed payments remain pending.
- This integration covers order payments. The wallet top-up screen still uses its existing Moyasar-only flow; extra kilometers and packages also remain on Moyasar.
- Validate end to end with a backend-created Tamara sandbox session: success/capture, cancellation, rejection, expiry, duplicate callbacks, slow capture, status API failure, and `NeedsReview`.

## Tabby payments

- `Shared/Payment/Tabby/` contains the RentNow test public-key configuration and SDK installment widget. Checkout URL validation and order/transaction matching live in `Checkout/PaymentSession.swift`. The secret key stays on the backend.
- The app links Tabby SDK 1.7.10, matching Allem-Student. SDK initialization occurs in `RentNowApp`; booking and order details show widgets using the server total. Payment options come from the backend.
- RentNow's `Order/PayOrder/{id}` already creates the Tabby session. The coordinator opens `data.tabby.webUrl` in `TabbyCheckoutView`, which handles the same `tabbyMobileSDK` messages as the SDK. It does **not** call `TabbySDK.configure(forPayment:)` or present `TabbyCheckout`: those APIs create/use a separate SDK-owned session and cannot accept RentNow's existing session.
- Tabby checkout checks `Payment/Status/{transactionId}` after checkout events, verifying the transaction, provider, and order identifiers. It does not poll while the customer enters payment details. Authorization triggers at most five verification checks; cancellation, expiry, rejection, or closing triggers one. Only backend `paymentStatus: Paid` completes payment successfully. Authorization alone remains pending until verified. Other shared payments retain `Payment/GetStatus/{transactionId}`.
- To adopt the exact Allem-Student session-creation flow later, the backend must accept and associate the SDK-created Tabby payment/session IDs with its order transaction before checkout. Do not create an unrelated second payment in the app.
- Run `bash Tests/run-payment-contract-tests.sh` for payment decoding, checkout URL/state validation, and transaction/order matching. A real sandbox checkout is still required to verify merchant configuration, redirects, webhooks, and final payment status.

## Wallet installment charging

- `AmountPaymentOptionsViewModel` checks `Payment/CheckInstallmentEligibility` for the entered SAR amount. Omitting `paymentMethod` requests all enabled installment providers. The recharge sheet reuses the payment-option rows, displays backend installment values and refusal messages, and only offers available methods. Amount edits invalidate old options; canceled or superseded responses cannot restore them. Moyasar remains the default option.
- `MyWalletViewModel.chargeWallet` checks the chosen installment provider again immediately before `More/ChargeWallet`, sending `amount` and `paymentMethod` (1 Moyasar, 2 Tamara, 4 Tabby). A refusal, missing option, or failed eligibility request stops charging. Provider outages that the backend reports as available are allowed through for the server's final check. Duplicate submissions are blocked while charging/checkout is active.
- `ChargeWallet` reuses `PayOrderData` because its provider payloads match `PayOrder`. `PaymentSession` supports wallet sessions without a rental order ID and keeps the transaction ID and provider payload. Existing checkout screens route Moyasar, Tabby, and Tamara separately.
- Wallet checkouts verify `Payment/Status/{transactionId}` (including Moyasar), match transaction/provider and wallet target where supplied, and only return success for `paymentStatus == Paid`. Pending or review results do not show a successful recharge or optimistically increase the balance. Successful payment reloads the backend wallet balance. Booking eligibility still uses `OrderPaymentSummary`.


## Package installment payments

- Package selection opens `PackagePaymentSheetView`, which reuses `AmountPaymentOptionsViewModel` and the payment-option rows with the fixed server package price.
- `PackagesListViewModel` checks the selected installment provider with that price immediately before `Packages/Subscribe`. Refusals display the server message and prevent subscription requests; duplicate submissions are blocked.
- Subscribe sends `packageId` and `paymentMethod`. `SubscribeResponse` retains subscription-specific fields and decodes the shared Tabby/Tamara payload as `payment: PayOrderData`. No checkout is routed through Moyasar for a Tabby/Tamara selection.
- Package sessions use `Payment/Status` for all providers, matching transaction/provider and the package target where returned. A subscription request ID alone is never treated as payment success. Only `Paid` shows subscription success and triggers `GetMyActiveSubscription` through the wallet coordinator. Pending/review states stay unconfirmed.

### Moyasar native checkout configuration

- The app requests `checkout=sdk` for Moyasar order, extra-kilometer, wallet, and package payments. The backend's attempt UUID is passed as the SDK `givenID`; only the backend's Confirm/Status responses determine fulfillment.
- `MoyasarConfiguration` uses the test publishable key for all builds. The backend must use the corresponding test environment and account. Switching to live requires an explicit configuration change before release. Never put a Moyasar secret key in the app.
- To enable Apple Pay, set the merchant ID in `MoyasarConfiguration`, add the corresponding Apple Pay entitlement/capability and provisioning, and configure the processing certificate in the Moyasar and Apple developer accounts. Apple Pay must be tested on a physical device.
- Card and Apple Pay attempts are retained locally immediately before submission, until the backend reports a terminal status. Reopening a retained attempt checks its status instead of submitting it again. Older markers remain conservative because they do not distinguish an opened form from a submitted payment. Verification times out to a pending result after approximately one minute.
- `Vendor/MoyasarSdk` contains Moyasar iOS SDK v3.0.4 with documented submission and 3DS navigation patches; reapply and verify them when upgrading the SDK. The native checkout owns the card view model and gives the 3DS web view a bounded height.
