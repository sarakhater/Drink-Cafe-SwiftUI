# ☕️ Drinks Cafe - iOS App

A beautiful, modern iOS drink ordering app built with SwiftUI featuring glass morphism design, real-time cart management, and persistent order history.

![iOS](https://img.shields.io/badge/iOS-18.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-5.0-green.svg)

## 📱 Features

### Core Functionality
- ☕️ **9 Delicious Drinks** - Hot, cold, and smoothie options
- 🔍 **Smart Search** - Real-time filtering with instant results
- 🎨 **Category Filters** - Quick filtering by drink type
- 📸 **Real Product Images** - High-quality photos loaded asynchronously
- 🛒 **Smart Shopping Cart** - Auto-merges duplicate items
- ❤️ **Favorites System** - Save and access favorite drinks
- 📦 **Order History** - View all past orders with receipts
- 🔄 **One-Tap Reorder** - Add entire past orders to cart instantly

### Design Highlights
- 🎨 **Glass Morphism UI** - Modern blurred glass effects
- 🌈 **Dynamic Backgrounds** - Animated gradients matching drink colors
- ✨ **Smooth Animations** - Bouncy, fluid transitions throughout
- 🌓 **Dark Mode Support** - Fully optimized for light and dark themes
- 📱 **Responsive Layout** - Adapts to all iPhone sizes

## 📸 Screenshots

<p float="left">
  <img src="screenshots/home.png" width="250" />
  <img src="screenshots/detail.png" width="250" /> 
  <img src="screenshots/cart.png" width="250" />
</p>

---

### 🏠 Home Screen
<img src="screenshots/home.png" width="300" alt="Home Screen">

**Features:**
- Swipeable drink carousel with smooth page transitions
- Real-time search functionality
- Category filter chips (Hot, Cold, Smoothie)
- Dynamic gradient background adapting to selected drink
- High-quality product images from Unsplash

---

### 🍹 Product Detail
<img src="screenshots/detail.png" width="300" alt="Product Detail">

**Features:**
- Choose from 3 sizes (Small, Medium, Large) with live price updates
- Adjustable quantity with intuitive +/- buttons
- Real-time total calculation
- Favorite toggle to save drinks
- Smooth bouncy animations

---

### 🛒 Shopping Cart
<img src="screenshots/cart.png" width="300" alt="Shopping Cart">

**Features:**
- Smart item merging (same product + size combines automatically)
- Quantity adjustment controls
- Swipe-to-delete gestures
- Live total with animated number transitions
- One-tap checkout button with glass effect

---

## 🏗️ Architecture

### Design Pattern
**MVVM + Single Store (Redux-inspired)**
- Centralized state management with @Observable
- SwiftUI environment injection for shared state
- Value types (structs) for immutable data models
- Reactive UI updates automatically

### Tech Stack
- **SwiftUI** - Declarative UI framework
- **Swift 6.0** - Latest Swift features
- **@Observable** - Modern state observation (iOS 17+)
- **AsyncImage** - Network image loading
- **UserDefaults** - Data persistence with Codable
- **SF Symbols** - Native Apple iconography

## 🚀 Getting Started

### Requirements
- Xcode 15.0 or later
- iOS 18.0+ deployment target
- Swift 6.0
- macOS Sonoma or later

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/DrinksCafee.git
cd DrinksCafee
```

2. **Open in Xcode**
```bash
open DrinksCafee.xcodeproj
```

3. **Build and Run**
- Select iPhone 15 or later simulator
- Press `⌘ + R` or click Run button
- App will launch with 9 sample drinks

## 📊 Project Structure

```
DrinksCafee/
├── App/
│   ├── MyApp.swift              # App entry point
│   └── ContentView.swift        # Root tab view (4 tabs)
├── Views/
│   ├── HomeView.swift           # Product catalog with carousel
│   ├── ProductDetailView.swift  # Size/quantity selection
│   ├── CartView.swift           # Shopping cart
│   ├── FavoritesView.swift      # Saved favorites
│   ├── OrderHistoryView.swift   # Past orders
│   └── ReceiptView.swift        # Order confirmation
├── Models/
│   ├── Product.swift            # Product model + catalog
│   ├── CartItem.swift           # Cart line items
│   └── Order.swift              # Completed orders
├── Store/
│   └── Store.swift              # Single source of truth
└── Design/
    ├── DesignSystem.swift       # Colors, spacing, radius
    └── GlassEffectFallback.swift # Custom glass effects
```

## 🎯 Key Features Explained

### Smart Cart System
```swift
// Automatically merges items with same product + size
func addToCart(_ product: Product, size: ProductSize, quantity: Int) {
    if let index = cartItems.firstIndex(where: {
        $0.productID == product.id && $0.size == size
    }) {
        cartItems[index].quantity += quantity  // Merge quantities!
    } else {
        cartItems.append(newItem)  // Add new line item
    }
}
```

### Data Persistence
```swift
// Automatically saves to UserDefaults as JSON
private func save<T: Encodable>(_ value: T, key: String) {
    if let data = try? JSONEncoder().encode(value) {
        UserDefaults.standard.set(data, forKey: key)
    }
}
```

### Async Image Loading
```swift
AsyncImage(url: URL(string: product.imageURL)) { phase in
    switch phase {
    case .success(let image):
        image.resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
    case .failure:
        Image(systemName: product.symbol)  // SF Symbol fallback
    }
}
```

## 🎨 Customization

### Add New Drinks

Edit `Product.swift`:
```swift
Product(
    id: "your-drink-id",
    name: "Your Drink Name",
    tagline: "Short description here",
    symbol: "cup.and.saucer.fill",
    colorName: "custom-color",
    basePrice: 4.50,
    category: .hot,
    imageURL: "https://images.unsplash.com/photo-..."
)
```

### Customize Colors

Edit `DesignSystem.swift`:
```swift
extension Color {
    static func drink(named name: String) -> Color {
        switch name {
        case "custom-color": Color(red: 0.5, green: 0.3, blue: 0.7)
        default: .accentColor
        }
    }
}
```

## 📚 What You'll Learn

This project demonstrates:
- ✅ Modern SwiftUI best practices
- ✅ State management with @Observable
- ✅ Navigation patterns (NavigationStack)
- ✅ List operations (swipe actions, deletion)
- ✅ Custom view modifiers
- ✅ Async image loading with AsyncImage
- ✅ Data persistence (Codable + UserDefaults)
- ✅ Smooth animations and transitions
- ✅ Glass morphism design patterns
- ✅ Search and filtering implementation

## 🔮 Future Enhancements

- [ ] User authentication & cloud accounts
- [ ] iCloud/Firebase sync across devices
- [ ] Apple Pay integration
- [ ] Push notifications for order status
- [ ] Loyalty rewards program
- [ ] Custom drink builder
- [ ] iPad optimization
- [ ] Apple Watch companion app

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- **Unsplash** - Free high-quality drink photography
- **Apple** - SwiftUI framework and SF Symbols
- **iOS Community** - Inspiration and best practices

---

⭐️ **If you like this project, please give it a star on GitHub!**

Made with ❤️ and ☕️ using SwiftUI
