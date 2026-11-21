#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/rentnow-payment-tests.XXXXXX")
trap 'rm -rf "$test_dir"' EXIT
xcrun swiftc -module-cache-path "$test_dir/module-cache" \
    RentNow/Shared/Payment/Models/*.swift \
    RentNow/Shared/Payment/Checkout/PaymentSession.swift \
    RentNow/Shared/Payment/Checkout/MoyasarPaymentPreference.swift \
    RentNow/Shared/Payment/Checkout/MoyasarAttemptStore.swift \
    RentNow/App/Home/CreateOrder/Model/CreateOrderModel.swift \
    RentNow/App/Home/CreateOrder/Model/OrderBookingRequest.swift \
    RentNow/App/Home/CreateOrder/Model/BookingDateFormatter.swift \
    RentNow/App/Orders/OrderDetails/Model/OrderDetailsModel.swift \
    RentNow/App/Wallet/Wallet/Model/WalletModel.swift \
    RentNow/Networking/BaseResponse/BaseResponse.swift \
    RentNow/Networking/BaseResponse/ServerResponseKey.swift \
    Tests/PaymentsContractTests.swift \
    -o "$test_dir/payment-contract-tests"
"$test_dir/payment-contract-tests"
