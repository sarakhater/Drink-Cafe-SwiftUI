import Foundation

/// A completed purchase, stored in order history.
struct Order: Identifiable, Hashable, Codable {
    let id: UUID
    let date: Date
    let items: [CartItem]
    let total: Decimal

    /// Short human-friendly code shown on the receipt, e.g. "A1B2C3".
    var code: String {
        String(id.uuidString.prefix(6))
    }
}
