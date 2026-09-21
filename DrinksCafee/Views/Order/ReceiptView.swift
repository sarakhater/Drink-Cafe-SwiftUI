import SwiftUI

/// The paper receipt. Used in two modes:
/// - `.confirmation`: shown as a sheet right after checkout.
/// - `.history`: pushed from the Orders tab, with a "Reorder" button.
struct ReceiptView: View {
    enum Mode {
        case confirmation
        case history
    }

    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss

    let order: Order
    let mode: Mode

    @State private var didReorder = false

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                receiptPaper
                    .padding(AppSpacing.l)
            }
        }
        .navigationTitle("Receipt")
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            actionButton
        }
    }

    private var receiptPaper: some View {
        VStack(spacing: AppSpacing.m) {
            Image(systemName: "cup.and.saucer.fill")
                .font(.title)
                .padding(.top, AppSpacing.s)

            Text("DRINK DASH")
                .font(.system(.title3, design: .monospaced, weight: .bold))
                .kerning(3)

            Text("Order #\(order.code)")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(order.date, format: .dateTime.day().month().year().hour().minute())
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)

            divider

            ForEach(order.items) { item in
                HStack(alignment: .top) {
                    Text("\(item.quantity)× \(item.name) (\(item.size.label))")
                    Spacer()
                    Text(item.lineTotal, format: .currency(code: "USD"))
                }
                .font(.system(.subheadline, design: .monospaced))
            }

            divider

            HStack {
                Text("TOTAL")
                Spacer()
                Text(order.total, format: .currency(code: "USD"))
            }
            .font(.system(.headline, design: .monospaced))

            Text("* Thank you! *")
                .font(.system(.caption, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.top, AppSpacing.s)
        }
        .padding(AppSpacing.xl)
        .padding(.vertical, AppSpacing.m)
        .background {
            ReceiptShape()
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.15), radius: 12, y: 6)
        }
    }

    private var divider: some View {
        DashedLine()
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [4]))
            .frame(height: 1)
            .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private var actionButton: some View {
        switch mode {
        case .confirmation:
            Button {
                dismiss()
            } label: {
                Label("Place Another Order", systemImage: "arrow.uturn.left")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.s)
            }
            .buttonStyle(.glassProminent)
            .padding(AppSpacing.l)

        case .history:
            Button {
                store.reorder(order)
                withAnimation(.bouncy) {
                    didReorder = true
                }
            } label: {
                Label(
                    didReorder ? "Added to Cart" : "Reorder",
                    systemImage: didReorder ? "checkmark" : "cart.badge.plus"
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppSpacing.s)
            }
            .buttonStyle(.glassProminent)
            .tint(didReorder ? .green : .accentColor)
            .disabled(didReorder)
            .padding(AppSpacing.l)
        }
    }
}
