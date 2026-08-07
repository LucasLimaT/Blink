import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var xp = 1_240
    @State private var modules = AppStore.modules
    @State private var inventory = AppStore.inventory
    @State private var projects = AppStore.projects
    @State private var posts = AppStore.posts
    @State private var messages: [BlinkChatMessage] = []

    var body: some View {
        TabView(selection: $selectedTab) {
            TrilhaView(modules: $modules, xp: $xp)
                .tabItem {
                    Label("Trilha", systemImage: "map")
                }
                .tag(0)

            BancadaView(
                xp: $xp,
                inventory: $inventory,
                projects: $projects,
                posts: $posts,
                selectedTab: $selectedTab
            )
            .tabItem {
                Label("Bancada", systemImage: "tray.full")
            }
            .tag(1)

            DiagnosticoView(
                inventory: $inventory,
                selectedTab: $selectedTab
            )
            .tabItem {
                Label("Câmera", systemImage: "camera")
            }
            .tag(2)

            FalaFioView(posts: $posts, selectedTab: $selectedTab)
                .tabItem {
                    Label("FalaFio", systemImage: "person.3")
                }
                .tag(3)

            BlinkChatView(messages: $messages)
                .tabItem {
                    Label("Blink", systemImage: "bubble.left")
                }
                .tag(4)
        }
        .tint(.blinkOrange)
    }
}

#Preview {
    TabBarView()
}
