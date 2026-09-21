import SwiftUI

// MARK: - Design tokens
// Keeping spacing/radius values in one place means every screen uses the
// same rhythm, and a redesign later is a one-file change.

enum AppSpacing {
    static let xs: CGFloat = 4
    static let s: CGFloat = 8
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
}

enum AppRadius {
    static let chip: CGFloat = 12
    static let control: CGFloat = 20
    static let card: CGFloat = 32
}

// MARK: - Drink palette
// Products store a color *name* (a plain String) so they stay Codable.
// This maps that name back to a real SwiftUI Color for rendering.
extension Color {
    static func drink(named name: String) -> Color {
        switch name {
        case "caramel": Color(red: 0.78, green: 0.52, blue: 0.25)
        case "cocoa": Color(red: 0.45, green: 0.29, blue: 0.21)
        case "chai": Color(red: 0.80, green: 0.42, blue: 0.15)
        case "matcha": Color(red: 0.35, green: 0.55, blue: 0.33)
        case "berry": Color(red: 0.65, green: 0.22, blue: 0.45)
        case "coldbrew": Color(red: 0.25, green: 0.20, blue: 0.18)
        case "mango": Color(red: 0.95, green: 0.62, blue: 0.15)
        case "green": Color(red: 0.30, green: 0.65, blue: 0.40)
        case "strawberry": Color(red: 0.88, green: 0.30, blue: 0.38)
        default: .accentColor
        }
    }
}
