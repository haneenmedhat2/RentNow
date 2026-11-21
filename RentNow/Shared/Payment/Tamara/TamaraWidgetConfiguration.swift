import Foundation

enum TamaraWidgetConfiguration {
    enum Style: String {
        case promo = "2"
        case checkout = "6"
    }

    // Sandbox public key from RentNow's Tamara integration kit. No API/notification tokens.
    static let publicKey = "7c471daf-f22b-4bb5-a44c-068c28a0440b"

    static func installmentURL(amount: Double, language: String, style: Style = .promo) -> URL? {
        guard amount.isFinite, amount > 0 else { return nil }
        var components = URLComponents(string: "https://cdn-sandbox.tamara.co/widget-v2/tamara-widget.html")!
        components.queryItems = [
            URLQueryItem(name: "lang", value: language == "ar" ? "ar" : "en"),
            URLQueryItem(name: "country", value: "SA"),
            URLQueryItem(name: "public_key", value: publicKey),
            URLQueryItem(name: "amount", value: String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), amount)),
            URLQueryItem(name: "inline_type", value: style.rawValue)
        ]
        return components.url
    }
    static func inlineHTML(amount: Double, language: String, style: Style = .promo) -> String {
        let lang = language == "ar" ? "ar" : "en"
        let total = String(format: "%.2f", locale: Locale(identifier: "en_US_POSIX"), amount)
        let attributes = style == .promo ? "inline-variant=\"text\"" : "config='{\"showExtraContent\":\"full\"}'"
        return """
        <!doctype html><html lang="\(lang)" dir="\(lang == "ar" ? "rtl" : "ltr")">
        <head><meta name="viewport" content="width=device-width, initial-scale=1">
        <style>html,body { margin:0; padding:0; background:transparent; }</style>
        <script>
        window.tamaraWidgetConfig = {
            lang: "\(lang)", country: "SA", publicKey: "\(publicKey)",
            style: { fontSize: "16px", badgeRatio: "0.58" },
            // Let the native glassy card and screen gradient show through the widget.
            css: `
                :host, .tamara-summary-widget__container {
                    background: transparent !important;
                }
            `
        };
        </script>
        <script defer src="https://cdn-sandbox.tamara.co/widget-v2/tamara-widget.js"></script>
        </head><body><tamara-widget type="tamara-summary" amount="\(total)" inline-type="\(style.rawValue)" \(attributes)></tamara-widget></body></html>
        """
    }
}
