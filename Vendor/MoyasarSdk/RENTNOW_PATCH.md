# RentNow Moyasar SDK patch

This local package is based on Moyasar iOS SDK v3.0.4 (revision bc9d806c5ba22e26f935943373c6d6a8663c7be8), under its original MIT license.

RentNow adds an optional `onPaymentStarted` callback to the credit card view and view model. It runs immediately before the SDK submits a valid card payment to Moyasar so the app can persist an uncertain attempt without treating an unopened or unsubmitted form as a payment. Returning false cancels submission if checkout has already closed. No card data is passed to the callback. Reapply and verify this patch when updating the SDK.

The 3DS web view loads each authentication URL only once, displays a loading indicator with a 45-second navigation timeout, reports navigation failures, and ignores normal cancelled navigations. The timeout applies only while a page is loading, not while the customer is completing a loaded challenge. These changes keep authentication stable across SwiftUI updates and allow the app to verify ambiguous results with its backend. The app owns the card view model for the duration of checkout.

Debug builds log navigation milestones and a sanitized callback status, without logging authentication URLs or card details.
