import SwiftUI

/// A rectangle with zigzag "torn paper" top and bottom edges,
/// like a paper receipt from a register.
struct ReceiptShape: Shape {
    var toothWidth: CGFloat = 16
    var toothHeight: CGFloat = 8

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let teethCount = max(1, Int(rect.width / toothWidth))
        let tw = rect.width / CGFloat(teethCount)

        // Top edge: zigzag left → right.
        path.move(to: CGPoint(x: rect.minX, y: rect.minY + toothHeight))
        for i in 0..<teethCount {
            let x = rect.minX + CGFloat(i) * tw
            path.addLine(to: CGPoint(x: x + tw / 2, y: rect.minY))
            path.addLine(to: CGPoint(x: x + tw, y: rect.minY + toothHeight))
        }

        // Right edge down.
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - toothHeight))

        // Bottom edge: zigzag right → left.
        for i in 0..<teethCount {
            let x = rect.maxX - CGFloat(i) * tw
            path.addLine(to: CGPoint(x: x - tw / 2, y: rect.maxY))
            path.addLine(to: CGPoint(x: x - tw, y: rect.maxY - toothHeight))
        }

        path.closeSubpath()
        return path
    }
}

/// A thin dashed divider used inside the receipt.
struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

#Preview {
    ReceiptShape()
        .fill(.white)
        .frame(width: 300, height: 400)
        .shadow(radius: 8)
        .padding()
        .background(.gray)
}
