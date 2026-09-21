import SwiftUI

/// Root of the app: four tabs. The tab bar automatically gets the
/// Liquid Glass treatment on iOS 26 — no extra styling needed.
struct ContentView: View {
    @Environment(Store.self) private var store

    var body: some View {
        TabView {
            Tab("Menu", systemImage: "cup.and.saucer.fill") {
                HomeView()
            }
            Tab("Favorites", systemImage: "heart.fill") {
                FavoritesView()
            }
            Tab("Cart", systemImage: "cart.fill") {
                CartView()
            }
            .badge(store.cartCount)

            Tab("Orders", systemImage: "receipt") {
                OrderHistoryView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(Store())
}
