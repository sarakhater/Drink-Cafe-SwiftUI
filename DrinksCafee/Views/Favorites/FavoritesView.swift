import SwiftUI

/// Favorites tab: drinks the user has hearted, persisted between launches.
struct FavoritesView: View {
    @Environment(Store.self) private var store

    var body: some View {
        NavigationStack {
            Group {
                if store.favoriteProducts.isEmpty {
                    ContentUnavailableView(
                        "No favorites yet",
                        systemImage: "heart",
                        description: Text("Tap the heart on any drink to save it here.")
                    )
                } else {
                    List {
                        ForEach(store.favoriteProducts) { product in
                            NavigationLink(value: product) {
                                FavoriteRow(product: product)
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    store.toggleFavorite(product)
                                } label: {
                                    Label("Remove", systemImage: "heart.slash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorites")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

private struct FavoriteRow: View {
    let product: Product

    var body: some View {
        HStack(spacing: AppSpacing.m) {
            Image(systemName: product.symbol)
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(product.color.gradient, in: .circle)

            VStack(alignment: .leading, spacing: 2) {
                Text(product.name)
                    .font(.headline)
                Text(product.tagline)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(product.basePrice, format: .currency(code: "USD"))
                .font(.subheadline.weight(.semibold))
        }
        .padding(.vertical, AppSpacing.xs)
    }
}

#Preview {
    FavoritesView()
        .environment(Store())
}
