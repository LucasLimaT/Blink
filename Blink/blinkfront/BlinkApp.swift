import SwiftUI

@main
struct BlinkApp: App {
    @StateObject private var communityStore = CommunityStore()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(communityStore)
                .preferredColorScheme(.light)
                .tint(BlinkTheme.orange)
        }
    }
}
