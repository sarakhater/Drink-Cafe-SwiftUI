import SwiftUI

// MARK: - Category
// Drives the filter chips on the home screen.
enum DrinkCategory: String, CaseIterable, Codable, Identifiable {
    case hot, cold, smoothie

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .hot: "Hot"
        case .cold: "Cold"
        case .smoothie: "Smoothies"
        }
    }

    var symbol: String {
        switch self {
        case .hot: "flame.fill"
        case .cold: "snowflake"
        case .smoothie: "tornado"
        }
    }
}

// MARK: - Size
enum ProductSize: String, CaseIterable, Codable, Identifiable {
    case small, medium, large

    var id: String { rawValue }

    var title: LocalizedStringKey {
        switch self {
        case .small: "Small"
        case .medium: "Medium"
        case .large: "Large"
        }
    }

    /// Shown on the receipt, where we need a plain String.
    var label: String {
        switch self {
        case .small: "S"
        case .medium: "M"
        case .large: "L"
        }
    }

    /// Added on top of the product's base price.
    var extraCost: Decimal {
        switch self {
        case .small: 0
        case .medium: 0.75
        case .large: 1.50
        }
    }

    /// Relative icon scale for the size selector.
    var iconScale: CGFloat {
        switch self {
        case .small: 0.7
        case .medium: 0.85
        case .large: 1.0
        }
    }
}

// MARK: - Product
// A value type: the catalog never changes at runtime, so a struct is ideal.
// The `id` is a stable String (not a fresh UUID) so favorites saved to disk
// still match the catalog on the next launch.
struct Product: Identifiable, Hashable, Codable {
    let id: String
    let name: String
    let tagline: String
    let symbol: String
    let colorName: String
    let basePrice: Decimal
    let category: DrinkCategory

    var color: Color { .drink(named: colorName) }

    func price(for size: ProductSize) -> Decimal {
        basePrice + size.extraCost
    }
}

// MARK: - Catalog
extension Product {
    static let catalog: [Product] = [
        Product(id: "caramel-latte", name: "Caramel Latte", tagline: "Silky espresso with golden caramel.",
                symbol: "cup.and.saucer.fill", colorName: "caramel", basePrice: 4.50, category: .hot),
        Product(id: "hot-chocolate", name: "Hot Chocolate", tagline: "Rich cocoa topped with cream.",
                symbol: "mug.fill", colorName: "cocoa", basePrice: 3.75, category: .hot),
        Product(id: "chai-spice", name: "Chai Spice", tagline: "Warming spices, steamed milk.",
                symbol: "leaf.fill", colorName: "chai", basePrice: 4.25, category: .hot),
        Product(id: "iced-matcha", name: "Iced Matcha", tagline: "Stone-ground matcha over ice.",
                symbol: "snowflake", colorName: "matcha", basePrice: 4.75, category: .cold),
        Product(id: "berry-fizz", name: "Berry Fizz", tagline: "Sparkling mixed-berry cooler.",
                symbol: "takeoutbag.and.cup.and.straw.fill", colorName: "berry", basePrice: 4.00, category: .cold),
        Product(id: "cold-brew", name: "Cold Brew", tagline: "Slow-steeped for 18 hours.",
                symbol: "drop.fill", colorName: "coldbrew", basePrice: 4.25, category: .cold),
        Product(id: "mango-tango", name: "Mango Tango", tagline: "Sun-ripe mango, blended thick.",
                symbol: "sun.max.fill", colorName: "mango", basePrice: 5.50, category: .smoothie),
        Product(id: "green-machine", name: "Green Machine", tagline: "Spinach, apple, and a lime kick.",
                symbol: "bolt.fill", colorName: "green", basePrice: 5.25, category: .smoothie),
        Product(id: "strawberry-swirl", name: "Strawberry Swirl", tagline: "Strawberries and cream, swirled.",
                symbol: "heart.fill", colorName: "strawberry", basePrice: 5.50, category: .smoothie),
    ]
}
