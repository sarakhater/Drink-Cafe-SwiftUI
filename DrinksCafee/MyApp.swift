import SwiftUI

@main struct MyApp: App {
    /// The single Store instance for the whole app. Created once here,
    /// injected into the environment so every screen can read it.
    @State private var store = Store()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
