import SwiftUI

struct MainTabView: View {
    enum Tab: CaseIterable {
        case home, trail, camera, community, blink

        var title: String {
            switch self {
            case .home: return "Início"
            case .trail: return "Trilha"
            case .camera: return "Analisar"
            case .community: return "Fórum"
            case .blink: return "Blink"
            }
        }

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .trail: return "map.fill"
            case .camera: return "camera.viewfinder"
            case .community: return "person.3.fill"
            case .blink: return "bubble.left.and.bubble.right.fill"
            }
        }
    }

    @State private var selectedTab: Tab = .home

    var body: some View {
        ZStack {
            BlinkTheme.surface.ignoresSafeArea()

            content
                .id(selectedTab)
                .transition(.opacity)
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.easeOut(duration: 0.18), value: selectedTab)
    }

    @ViewBuilder
    private var content: some View {
        switch selectedTab {
        case .home:
            HomeView(openTrail: { selectedTab = .trail })
        case .trail:
            LearningTrailView()
        case .camera:
            ScannerView()
        case .community:
            CommunityView()
        case .blink:
            BlinkChatView()
        }
    }
}

private struct CustomTabBar: View {
    @Binding var selectedTab: MainTabView.Tab

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(BlinkTheme.orange.opacity(0.24))
                    .frame(height: 1)
            }
            .shadow(color: BlinkTheme.ink.opacity(0.12), radius: 18, y: -5)

            HStack(alignment: .top, spacing: 0) {
                tabButton(.home)
                tabButton(.trail)
                Color.clear.frame(maxWidth: .infinity, minHeight: 62)
                tabButton(.community)
                tabButton(.blink)
            }
            .padding(.horizontal, 8)
            .padding(.top, 10)

            cameraButton
                .offset(y: -28)
        }
        .frame(height: 76)
        .background(.ultraThinMaterial)
        .ignoresSafeArea(edges: .bottom)
    }

    private func tabButton(_ tab: MainTabView.Tab) -> some View {
        Button {
            select(tab)
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .font(.system(size: 19, weight: .bold))
                Text(tab.title)
                    .font(.system(size: 10, weight: .bold))
            }
            .foregroundStyle(selectedTab == tab ? BlinkTheme.orange : BlinkTheme.muted)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selectedTab == tab ? .isSelected : [])
    }

    private var cameraButton: some View {
        Button {
            select(.camera)
        } label: {
            VStack(spacing: 5) {
                ZStack {
                    Circle()
                        .fill(BlinkTheme.orangeDark)
                        .frame(width: 70, height: 70)
                        .offset(y: 5)

                    Circle()
                        .fill(BlinkTheme.orange)
                        .frame(width: 70, height: 70)
                        .overlay {
                            Circle().stroke(.white, lineWidth: 5)
                        }
                        .shadow(color: BlinkTheme.orange.opacity(0.42), radius: 14, y: 7)

                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 27, weight: .black))
                        .foregroundStyle(.white)
                }

                Text("Analisar")
                    .font(.system(size: 10, weight: .black))
                    .foregroundStyle(selectedTab == .camera ? BlinkTheme.orange : BlinkTheme.ink)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Analisar componentes")
        .accessibilityAddTraits(selectedTab == .camera ? .isSelected : [])
    }

    private func select(_ tab: MainTabView.Tab) {
        withAnimation(.spring(response: 0.34, dampingFraction: 0.78)) {
            selectedTab = tab
        }
    }
}
