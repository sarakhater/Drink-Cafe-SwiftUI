import SwiftUI

/// The app's single source of truth.
///
/// `@Observable` gives SwiftUI per-property tracking: a view that reads only
/// `favoriteProducts` re-renders when favorites change, but not when the cart
/// changes. `@MainActor` keeps all reads/writes on the main thread, matching
/// how views consume the model.
@MainActor
@Observable
final class Store {

    // MARK: Catalog + search & filter

    let catalog: [Product] = Product.catalog

    var searchText: String = "" {
        didSet { recomputeVisibleProducts() }
    }

    var selectedCategory: DrinkCategory? = nil {
        didSet { recomputeVisibleProducts() }
    }

    /// Cached result of search + category filtering. We recompute this only
    /// when an input changes (in `didSet`) instead of filtering inline in a
    /// view's `body`, which would re-run the filter on every render.
    private(set) var visibleProducts: [Product] = []

    private func recomputeVisibleProducts() {
        var result = catalog
        if let selectedCategory {
            result = result.filter { $0.category == selectedCategory }
        }
        if !searchText.isEmpty {
            result = result.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        visibleProducts = result
    }

    // MARK: Cart

    private(set) var cartItems: [CartItem] = []

    var cartCount: Int {
        cartItems.reduce(0) { $0 + $1.quantity }
    }

    var cartTotal: Decimal {
        cartItems.reduce(0) { $0 + $1.lineTotal }
    }

    func addToCart(_ product: Product, size: ProductSize, quantity: Int) {
        // Same drink + same size → merge into the existing line.
        if let index = cartItems.firstIndex(where: {
            $0.productID == product.id && $0.size == size
        }) {
            cartItems[index].quantity += quantity
        } else {
            cartItems.append(CartItem(
                id: UUID(),
                productID: product.id,
                name: product.name,
                symbol: product.symbol,
                colorName: product.colorName,
                size: size,
                quantity: quantity,
                unitPrice: product.price(for: size)
            ))
        }
        saveCart()
    }

    func setQuantity(_ quantity: Int, for itemID: CartItem.ID) {
        guard let index = cartItems.firstIndex(where: { $0.id == itemID }) else { return }
        if quantity <= 0 {
            cartItems.remove(at: index)
        } else {
            cartItems[index].quantity = quantity
        }
        saveCart()
    }

    func removeCartItems(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
        saveCart()
    }

    // MARK: Favorites

    private(set) var favoriteIDs: Set<String> = []

    /// Cached so list views don't re-filter the catalog on every render.
    private(set) var favoriteProducts: [Product] = []

    func isFavorite(_ product: Product) -> Bool {
        favoriteIDs.contains(product.id)
    }

    func toggleFavorite(_ product: Product) {
        if favoriteIDs.contains(product.id) {
            favoriteIDs.remove(product.id)
        } else {
            favoriteIDs.insert(product.id)
        }
        recomputeFavoriteProducts()
        save(favoriteIDs, key: Keys.favorites)
    }

    private func recomputeFavoriteProducts() {
        favoriteProducts = catalog.filter { favoriteIDs.contains($0.id) }
    }

    // MARK: Orders

    private(set) var orders: [Order] = []

    /// Turns the current cart into an Order, saves it, and empties the cart.
    func placeOrder() -> Order? {
        guard !cartItems.isEmpty else { return nil }
        let order = Order(id: UUID(), date: .now, items: cartItems, total: cartTotal)
        orders.insert(order, at: 0) // newest first
        cartItems = []
        save(orders, key: Keys.orders)
        saveCart()
        return order
    }

    /// "Reorder" from history: puts the old order's items back into the cart.
    func reorder(_ order: Order) {
        for item in order.items {
            guard let product = catalog.first(where: { $0.id == item.productID }) else { continue }
            addToCart(product, size: item.size, quantity: item.quantity)
        }
    }

    // MARK: Persistence (UserDefaults + Codable JSON)

    private enum Keys {
        static let cart = "store.cart"
        static let favorites = "store.favorites"
        static let orders = "store.orders"
    }

    init() {
        cartItems = Self.load([CartItem].self, key: Keys.cart) ?? []
        favoriteIDs = Self.load(Set<String>.self, key: Keys.favorites) ?? []
        orders = Self.load([Order].self, key: Keys.orders) ?? []
        recomputeVisibleProducts()
        recomputeFavoriteProducts()
    }

    private func saveCart() {
        save(cartItems, key: Keys.cart)
    }

    private func save(_ value: some Encodable, key: String) {
        if let data = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private static func load<T: Decodable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
