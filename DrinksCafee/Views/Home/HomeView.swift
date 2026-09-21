import SwiftUI

/// Home screen: search bar + category chips + swipeable drink carousel.
/// The background gradient animates to match the drink currently in view.
struct HomeView: View {
    @Environment(Store.self) private var store
    @State private var selectedProductID: String?

    /// The drink currently centered in the carousel (drives the background).
    private var currentProduct: Product? {
        store.visibleProducts.first { $0.id == selectedProductID }
            ?? store.visibleProducts.first
    }

    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack(spacing: AppSpacing.m) {
                    SearchBar()
                    CategoryChips()
                    carousel
                }
                .padding(.top, AppSpacing.s)
            }
            .navigationTitle("Drink Dash")
            .navigationDestination(for: Product.self) { product in
                ProductDetailView(product: product)
            }
        }
        .onAppear {
            if selectedProductID == nil {
                selectedProductID = store.visibleProducts.first?.id
            }
        }
    }

    private var background: some View {
        let color = currentProduct?.color ?? .accentColor
        return LinearGradient(
            colors: [color.opacity(0.75), color.opacity(0.25), Color(.systemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .animation(.smooth(duration: 0.7), value: currentProduct?.id)
    }

    @ViewBuilder
    private var carousel: some View {
        if store.visibleProducts.isEmpty {
            Spacer()
            ContentUnavailableView.search(text: store.searchText)
            Spacer()
        } else {
            TabView(selection: $selectedProductID) {
                ForEach(store.visibleProducts) { product in
                    DrinkCardView(product: product)
                        .tag(product.id as String?)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - Search bar

private struct SearchBar: View {
    @Environment(Store.self) private var store

    var body: some View {
        // @Bindable lets us make a two-way $binding into an @Observable model.
        @Bindable var store = store
        HStack(spacing: AppSpacing.s) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Search drinks", text: $store.searchText)
                .autocorrectionDisabled()
            if !store.searchText.isEmpty {
                Button {
                    store.searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, AppSpacing.m)
        .padding(.vertical, 10)
        .glassEffect(in: .rect(cornerRadius: AppRadius.control))
        .padding(.horizontal, AppSpacing.l)
    }
}

// MARK: - Category filter chips

private struct CategoryChips: View {
    @Environment(Store.self) private var store

    var body: some View {
        // GlassEffectContainer renders sibling glass shapes together,
        // letting them blend/morph and improving performance.
        GlassEffectContainer(spacing: AppSpacing.s) {
            HStack(spacing: AppSpacing.s) {
                ForEach(DrinkCategory.allCases) { category in
                    let isSelected = store.selectedCategory == category
                    Button {
                        withAnimation(.smooth) {
                            store.selectedCategory = isSelected ? nil : category
                        }
                    } label: {
                        Label(category.title, systemImage: category.symbol)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, AppSpacing.m)
                            .padding(.vertical, AppSpacing.s)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(
                        isSelected
                            ? .regular.tint(category.color.opacity(0.6)).interactive()
                            : .regular.interactive()
                    )
                }
            }
        }
    }
}

extension DrinkCategory {
    var color: Color {
        switch self {
        case .hot: .orange
        case .cold: .blue
        case .smoothie: .pink
        }
    }
}

// MARK: - Drink card

private struct DrinkCardView: View {
    let product: Product

    var body: some View {
        NavigationLink(value: product) {
            VStack(spacing: AppSpacing.m) {
                Image(systemName: product.symbol)
                    .font(.system(size: 90))
                    .foregroundStyle(.white)
                    .frame(width: 180, height: 180)
                    .background(product.color.gradient, in: .circle)
                    .shadow(color: product.color.opacity(0.5), radius: 20, y: 10)

                Text(product.name)
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))

                Text(product.tagline)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Text(product.basePrice, format: .currency(code: "USD"))
                    .font(.headline)
                    .padding(.horizontal, AppSpacing.m)
                    .padding(.vertical, AppSpacing.xs)
                    .background(product.color.opacity(0.25), in: .capsule)
            }
            .padding(AppSpacing.xl)
            .frame(maxWidth: .infinity)
            .glassEffect(in: .rect(cornerRadius: AppRadius.card))
            .padding(.horizontal, AppSpacing.l)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .environment(Store())
}
