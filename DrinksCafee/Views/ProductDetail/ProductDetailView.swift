import SwiftUI

/// Detail screen: pick a size and quantity, favorite the drink,
/// and add it to the cart.
struct ProductDetailView: View {
    @Environment(Store.self) private var store
    @Environment(\.dismiss) private var dismiss

    let product: Product

    @State private var selectedSize: ProductSize = .medium
    @State private var quantity = 1

    private var total: Decimal {
        product.price(for: selectedSize) * Decimal(quantity)
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [product.color.opacity(0.7), product.color.opacity(0.2), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: AppSpacing.xl) {
                    hero
                    sizeSelector
                    quantitySelector
                }
                .padding(AppSpacing.l)
            }
        }
        .navigationTitle(product.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation(.bouncy) {
                        store.toggleFavorite(product)
                    }
                } label: {
                    Image(systemName: store.isFavorite(product) ? "heart.fill" : "heart")
                }
                .tint(store.isFavorite(product) ? .red : .primary)
            }
        }
        .safeAreaInset(edge: .bottom) {
            addToCartButton
        }
    }

    private var hero: some View {
        VStack(spacing: AppSpacing.m) {
            Image(systemName: product.symbol)
                .font(.system(size: 80))
                .foregroundStyle(.white)
                .frame(width: 160, height: 160)
                .background(product.color.gradient, in: .circle)
                .shadow(color: product.color.opacity(0.5), radius: 20, y: 10)

            Text(product.tagline)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var sizeSelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            Text("Size")
                .font(.headline)

            GlassEffectContainer(spacing: AppSpacing.s) {
                HStack(spacing: AppSpacing.s) {
                    ForEach(ProductSize.allCases) { size in
                        Button {
                            withAnimation(.bouncy) {
                                selectedSize = size
                            }
                        } label: {
                            VStack(spacing: AppSpacing.xs) {
                                Image(systemName: product.symbol)
                                    .font(.system(size: 28))
                                    .scaleEffect(size.iconScale)
                                    .frame(height: 32)
                                Text(size.title)
                                    .font(.subheadline.weight(.medium))
                                Text(product.price(for: size), format: .currency(code: "USD"))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppSpacing.m)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(
                            selectedSize == size
                                ? .regular.tint(product.color.opacity(0.6)).interactive()
                                : .regular.interactive(),
                            in: .rect(cornerRadius: AppRadius.control)
                        )
                    }
                }
            }
        }
    }

    private var quantitySelector: some View {
        VStack(alignment: .leading, spacing: AppSpacing.s) {
            Text("Quantity")
                .font(.headline)

            GlassEffectContainer(spacing: AppSpacing.m) {
                HStack(spacing: AppSpacing.m) {
                    Button {
                        withAnimation(.bouncy) {
                            quantity = max(1, quantity - 1)
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3.weight(.semibold))
                            .frame(width: 52, height: 52)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())

                    Text("\(quantity)")
                        .font(.title.weight(.bold))
                        .monospacedDigit()
                        .frame(minWidth: 60)
                        .contentTransition(.numericText())

                    Button {
                        withAnimation(.bouncy) {
                            quantity += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3.weight(.semibold))
                            .frame(width: 52, height: 52)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive())
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var addToCartButton: some View {
        Button {
            store.addToCart(product, size: selectedSize, quantity: quantity)
            dismiss()
        } label: {
            Label(
                "Add to Cart · \(total, format: .currency(code: "USD"))",
                systemImage: "cart.badge.plus"
            )
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppSpacing.s)
        }
        .buttonStyle(.glassProminent)
        .tint(product.color)
        .padding(AppSpacing.l)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.catalog[0])
    }
    .environment(Store())
}
