# Android Payment Updates

This document combines the payment updates from the current and previous sessions for Android implementation.

## Platform-specific payment method

Do not implement any Apple Pay UI or behavior on Android. Use **Google Pay** instead.

Google Pay must be the first payment option whenever it is available.

## Shared payment-method rules

### Display order

Show payment methods in this order:

1. Google Pay, when available
2. Mada or credit card
3. Tamara
4. Tabby

Use the method name returned by the API for Tamara and Tabby. Use these localized strings for cards:

| Language | Title | Subtitle |
| --- | --- | --- |
| Arabic | بطاقة مدى أو ائتمانية | مدى · فيزا · ماستركارد |
| English | Mada or credit card | Mada, Visa and Mastercard |

### Installment threshold

Do not show Tamara or Tabby when the payment amount is below `1,000 SAR`.

- This applies to wallet recharge and package subscriptions.
- At `1,000 SAR` or above, show only methods marked available by the eligibility API response.
- If the amount changes from at least 1,000 SAR to below 1,000 SAR, immediately hide Tamara and Tabby and reset the selection to card if either installment provider was selected.

### Availability and loading

- Prevent selection of an unavailable method.
- Show the API's unavailability reason, or the translated fallback: “This payment method is currently unavailable.”
- While eligibility is loading, disable payment-method cards and the confirmation button, and show “Updating payment options…”.
- On an eligibility failure, show the error and a Retry action.

### Localization and layout direction

- Respect the app layout direction: RTL for Arabic and LTR for English.
- Align payment text to the content start edge.
- Put the selection indicator at the start edge and the payment badge at the trailing edge. In Arabic, this places the indicator on the right and the badge on the left.
- Keep installment values such as `×4` in LTR direction, including in Arabic.

## Payment-method card design

Apply this design to the wallet recharge sheet and use the same payment-method content in the package subscription sheet:

- 12dp vertical gap between cards.
- Minimum height: 82dp; corner radius: 18dp.
- 14dp inner padding.
- 22dp circular selection indicator at the start edge.
- Bold title and secondary subtitle in the app's gray text color.
- A `66 × 46dp` trailing badge with a subtle gray background and 10dp corners.
- Unselected card: white background and `borderColor` border at 1dp.
- Selected card: `mainColor` at 5% opacity as background and a 2dp `mainColor` border.
- Tamara and Tabby: always use the `mainColor` 5% opacity background, selected or not. Use `borderColor` at 1dp while unselected.
- Card: use the tinted background only while selected.
- Google Pay: follow the Android checkout design system. It is first in the list and must use the same selection state, enablement rules, and RTL placement as the other methods.

### Payment badges

- Google Pay: Google Pay brand badge.
- Card: credit-card icon.
- Tamara and Tabby: installment-count badge from the API, such as `×4`. Use `×4` as a fallback only when the API does not provide an installment count.

### Provider subtitles

- Tamara: “قسّمها على دفعات” / “Split into installments”.
- Tabby: “ادفع لاحقًا أو قسّط” / “Pay later or split payments”.

## Wallet recharge

1. The user enters a recharge amount.
2. Do not show payment methods until the amount is valid and greater than zero.
3. Check installment eligibility whenever the amount changes.
4. Show payment cards according to the shared rules above.
5. Enable Confirm only when the amount is valid, no eligibility request is running, and an available method is selected.
6. Prevent repeated submission while checkout is starting.

## Package subscription payment sheet

- Use the same payment-method cards and the 1,000 SAR installment threshold.
- Keep the payment-method order: Google Pay, card, Tamara, Tabby.
- Localize the package name and price using the selected app language and localized currency label.
- Show a Details control when the package has a description, duration, discount, or free-delivery count. It expands and collapses the details within the sheet.
- When Tamara or Tabby is selected, show that provider's embedded installment widget below the selected card when installment data is available.
- CTA label: `Continue and pay {price} SAR` / `متابعة ودفع {السعر} ريال`.

## Order payment-method selection

- Use the unified checkout presentation for Google Pay, card, Tamara, and Tabby, following the display order above.
- Show an installment summary when available, including installment count, installment amount, and currency.
- When Tamara or Tabby is selected, show the embedded installment details below the selection.
- Preserve the existing checkout flow and eligibility validation; these updates only change presentation and state handling.

## Payment cancellation

When the user cancels payment with any provider:

- Close the checkout quietly.
- Do not show an error dialog, Toast, or Snackbar stating “Payment canceled” / “تم إلغاء عملية الدفع”.
- On the order details screen only, refresh order details after checkout closes in case the provider updated its status.
- Do not treat cancellation as success or failure, and do not optimistically update the wallet balance or subscription state.

## Acceptance checks

- A 100 SAR wallet recharge shows Google Pay, if available, and card only; Tamara and Tabby do not appear.
- A 1,000 SAR wallet recharge with eligible providers shows Google Pay, card, Tamara, then Tabby.
- Arabic: indicator on the right, badge on the left, and Arabic strings.
- English: indicator on the left, badge on the right, and English strings.
- Canceling card, Google Pay, Tamara, or Tabby checkout does not show a “Payment canceled” message.
