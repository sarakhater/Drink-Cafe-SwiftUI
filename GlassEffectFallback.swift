import SwiftUI

// MARK: - Glass Effect Fallback for iOS < 26
// This provides backwards-compatible implementations of the glassEffect
// and GlassEffectContainer APIs using standard SwiftUI materials and styling.

struct GlassEffectStyle {
    var tintColor: Color?
    var isInteractive: Bool = false
    
    static let regular = GlassEffectStyle()
    
    func tint(_ color: Color) -> GlassEffectStyle {
        var copy = self
        copy.tintColor = color
        return copy
    }
    
    func interactive() -> GlassEffectStyle {
        var copy = self
        copy.isInteractive = true
        return copy
    }
}

// MARK: - Glass Effect Container (Fallback)
struct GlassEffectContainer<Content: View>: View {
    let spacing: CGFloat?
    @ViewBuilder let content: () -> Content
    
    init(spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
    
    var body: some View {
        content()
    }
}

// MARK: - Glass Effect Modifier (Fallback)
extension View {
    func glassEffect(_ style: GlassEffectStyle = .regular) -> some View {
        self.modifier(GlassEffectModifier(style: style))
    }
    
    func glassEffect<S: Shape>(in shape: S) -> some View {
        self
            .background(.ultraThinMaterial, in: shape)
            .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

private struct GlassEffectModifier: ViewModifier {
    let style: GlassEffectStyle
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        if let tintColor = style.tintColor {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(tintColor.opacity(0.15))
                        }
                    }
            }
            .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}
