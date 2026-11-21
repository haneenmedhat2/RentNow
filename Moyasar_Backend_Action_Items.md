# مشكلة بقاء دفع الاشتراك عبر Moyasar بحالة Pending

## ملخص المشكلة

الدفع عبر Moyasar SDK يرجع من خطوة 3DS بحالة `paid`، لكن طلب التأكيد `POST /API/Payment/Confirm` يرجع:

- `status: Initiated`
- `paymentStatus: Pending`

واستعلامات `GET /API/Payment/Status/127` تستمر بإرجاع `Pending`.

## بيانات العملية للمراجعة

- `transactionId`: `127`
- `subscriptionRequestId`: `138`
- معرّف الدفع المرسل إلى `Payment/Confirm`: نفس `moyasarPaymentAttemptId` الراجع من `Packages/Subscribe`
- `traceId` لطلب التأكيد: `400067b5-0004-b800-b63f-84710c7967bb`
- المبلغ: `100 SAR`

## المطلوب من فريق الباك إند

1. مراجعة سجل طلب `Payment/Confirm` للعملية أعلاه ومعرفة سبب بقاء حالتها `Initiated / Pending`.
2. التأكد من أن السيرفر يستخدم مفتاح Moyasar السري **التجريبي** المطابق لمفتاح `pk_test` المستخدم في التطبيق، ومن أن المفتاحين تابعان لنفس حساب Moyasar.
3. التحقق من أن `Payment/Confirm` يستعلم من Moyasar عن الدفع باستخدام معرّف الدفع الصحيح، ويتحقق من المعرّف والمبلغ والعملة والبيئة قبل تأكيد العملية.
4. إذا أكد Moyasar أن الدفع ناجح، تحديث المعاملة والاشتراك إلى `Paid`، والتأكد من أن `GET /API/Payment/Status/127` يعيد الحالة المحدّثة.
5. التأكد من أن Moyasar webhook يتحقق من الطلب ويحدّث المعاملات المعلّقة، حتى لو أُغلق التطبيق قبل وصول طلب التأكيد.
