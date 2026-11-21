# Backend Requirements: Moyasar iOS SDK

Update the Moyasar payment flow to support the iOS SDK for order payments, extra kilometers, wallet top-ups, and package subscriptions.

## 1. Start an SDK payment

Extend the existing payment endpoints to accept a checkout type identifying the iOS SDK flow. For that flow:

- Create a pending RentNow transaction and a payment attempt linked to the authenticated user and payment target.
- Calculate and save the final amount and currency on the server.
- Generate and save a unique UUID for the attempt as `moyasarPaymentAttemptId`.
- Return the existing `amount` in SAR, `currency`, `transactionId`, and the new `moyasarPaymentAttemptId`. The iOS app converts `amount` to halalas for the SDK using accurate decimal arithmetic.
- Avoid creating a separate payable hosted invoice for the same SDK attempt. Keep the existing hosted checkout flow compatible with current clients.

Example response data (proposed field names):

```json
{
  "transactionId": "111",
  "provider": "moyasar",
  "paymentStatus": "Pending",
  "amount": 584.85,
  "currency": "SAR",
  "moyasarPaymentAttemptId": "c1d4141d-620d-4ac1-83a0-f20a468819e2"
}
```

The app will pass `moyasarPaymentAttemptId` to the SDK's `givenID` parameter. Confirm that the selected SDK version returns it as the Moyasar payment ID before relying on this mapping.

## 2. Confirm and reconcile the payment

Provide an authenticated endpoint, or extend an existing one, to accept `transactionId` and the `moyasarPaymentId` returned by the SDK. The backend must:

- Verify that the transaction belongs to the user and that the payment ID matches the saved attempt. Do not rely on client-supplied status or metadata as proof of payment.
- Fetch the payment from Moyasar using the backend secret key and verify its status, amount, currency, and environment against the saved transaction.
- Mark the transaction as paid and apply its effect only after verification. Treat authorization-only payments according to the capture policy.
- Prevent a payment from being applied to multiple transactions, and make confirmation and fulfillment safe to repeat or run concurrently.
- Process Moyasar payment webhooks, validating `secret_token`, and reconcile pending attempts even if the app closes before sending the result. Keep uncertain results pending or under review.
- Manage retries and any existing hosted invoice links so that the same obligation is not charged twice.

## 3. Return payment status

Ensure the existing status endpoints return the verified status for SDK payments, including pending and review states:

- `GET /API/Payment/GetStatus/{transactionId}` — orders and extra kilometers.
- `GET /API/Payment/Status/{transactionId}` — wallet top-ups and packages.

Keep updating transaction status independently of the app polling these endpoints.

## Endpoints to update

- `POST /API/Order/PayOrder/{orderId}`
- `POST /API/Order/PayExceededKilometers/{orderId}`
- `POST /API/More/ChargeWallet`
- `POST /API/Packages/Subscribe`
