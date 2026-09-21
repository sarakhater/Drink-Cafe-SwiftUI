import Foundation

/// One line in the cart: a product + chosen size + quantity.
/// We snapshot the fields we display (name, symbol, color, price) instead of
/// storing just a product reference — so a saved order still renders
/// correctly even if the catalog changes in a future app version.
struct CartItem: Identifiable, Hashable, Codable {
    let id: UUID
    let productID: String
    let name: String
    let symbol: String
    let colorName: String
    let size: ProductSize
    var quantity: Int
    let unitPrice: Decimal

    var lineTotal: Decimal {
        unitPrice * Decimal(quantity)
    }
}
