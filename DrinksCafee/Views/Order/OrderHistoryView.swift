import SwiftUI

/// Orders tab: past orders saved locally, newest first.
/// Tapping one shows its receipt with a "Reorder" button.
struct OrderHistoryView: View {
    @Environment(Store.self) private var store

    var body: some View {
        NavigationStack {
            Group {
                if store.orders.isEmpty {
                    ContentUnavailableView(
                        "No orders yet",
                        systemImage: "receipt",
                        description: Text("Your receipts will appear here after checkout.")
                    )
                } else {
                    List {
                        ForEach(store.orders) { order in
                            NavigationLink(value: order) {
                                OrderRow(order: order)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Orders")
            .navigationDestination(for: Order.self) { order in
                ReceiptView(order: order, mode: .history)
            }
        }
    }
}

private struct OrderRow: View {
    let order: Order

    private var itemCount: Int {
        order.items.reduce(0) { $0 + $1.quantity }
    }

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Image(systemName: "receipt")
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Color.accentColor.gradient, in: .circle)

            VStack(alignment: .leading, spacing: 2) {
                Text(order.date, format: .dateTime.day().month().hour().minute())
                    .font(.headline)
                Text("^[\(itemCount) drink](inflect: true) · #\(order.code)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(order.total, format: .currency(code: "USD"))
                .font(.subheadline.weight(.semibold))
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    OrderHistoryView()
        .environment(Store())
}
