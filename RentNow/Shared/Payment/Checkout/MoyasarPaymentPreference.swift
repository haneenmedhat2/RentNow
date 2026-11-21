import Foundation

/// The backend stores both Moyasar choices as method 1; keep the chosen UI route per user and order.
enum MoyasarPaymentPreference {
    private static func key(orderId: Int, userId: String?) -> String {
        "moyasar.method.\(userId ?? "unknown").\(orderId)"
    }

    static func get(orderId: Int, userId: String?, defaults: UserDefaults = .standard) -> MoyasarPaymentMethod {
        defaults.string(forKey: key(orderId: orderId, userId: userId))
            .flatMap(MoyasarPaymentMethod.init(rawValue:)) ?? .card
    }

    static func set(_ method: MoyasarPaymentMethod, orderId: Int, userId: String?, defaults: UserDefaults = .standard) {
        defaults.set(method.rawValue, forKey: key(orderId: orderId, userId: userId))
    }
}
