import SwiftUI

/// The cart tab: line items with quantity controls, a running total,
/// and a checkout button that produces a receipt.
struct CartView: View {
    @Environment(Store.self) private var store

    /// When set, the receipt sheet is presented (sheet(item:) needs
    /// an Identifiable value — Order already is one).
    @State private var placedOrder: Order?

    var body: some View {
        NavigationStack {
            Group {
                if store.cartItems.isEmpty {
                    ContentUnavailableView(
                        "Your cart is empty",
                        systemImage: "cart",
                        description: Text("Add a drink from the menu to get started.")
                    )
                } else {
                    cartList
                }
            }
            .navigationTitle("Cart")
        }
        .sheet(item: $placedOrder) { order in
            ReceiptView(order: order, mode: .confirmation)
        }
    }

    private var cartList: some View {
        List {
            Section {
                ForEach(store.cartItems) { item in
                    CartRow(item: item)
                }
                .onDelete { offsets in
                    store.removeCartItems(at: offsets)
                }
            }

            Section {
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(store.cartTotal, format: .currency(code: "USD"))
                        .font(.headline)
                        .contentTransition(.numericText())
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                placedOrder = store.placeOrder()
            } label: {
                Label("Place Order", systemImage: "checkmark.circle.fill")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppSpacing.s)
            }
            .buttonStyle(.glassProminent)
            .padding(AppSpacing.l)
        }
    }
}

// MARK: - Cart row

private struct CartRow: View {
    @Environment(Store.self) private var store
    let item: CartItem

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Image(systemName: item.symbol)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(Color.drink(named: item.colorName).gradient, in: .circle)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                Text("\(item.size.rawValue.capitalized) · \(item.unitPrice, format: .currency(code: "USD"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: AppSpacing.xs) {
                Text(item.lineTotal, format: .currency(code: "USD"))
                    .font(.subheadline.weight(.semibold))
                    .contentTransition(.numericText())

                HStack(spacing: AppSpacing.s) {
                    Button {
                        store.setQuantity(item.quantity - 1, for: item.id)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                    }
                    Text("\(item.quantity)")
                        .monospacedDigit()
                        .frame(minWidth: 20)
                    Button {
                        store.setQuantity(item.quantity + 1, for: item.id)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                }
                // .borderless keeps each button independently tappable
                // inside a List row (otherwise the whole row absorbs taps).
                .buttonStyle(.borderless)
                .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    CartView()
        .environment(Store())
}
