import Tabby

enum TabbyConfiguration {
    static let publicKey = "pk_test_01a0e303-2ae3-cb8d-20dd-7637f843ec64"
    static let merchantCode = "rentnow"

    static var language: Lang { Language.isRTL() ? .ar : .en }

    static func setup() {
        TabbySDK.shared.setup(withApiKey: publicKey)
    }
}
