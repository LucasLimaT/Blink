import SwiftUI

@main
struct BlinkApp: App {
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .preferredColorScheme(.light)
        }
    }
}
