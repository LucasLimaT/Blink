import SwiftUI

struct BancadaView: View {
    @Binding var xp: Int
    @Binding var inventory: [InventoryItem]
    @Binding var projects: [ProjectItem]
    @Binding var posts: [Post]
    @Binding var selectedTab: Int

    let inventoryColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var saved: [SavedItem] {
        let savedPosts = posts.filter {
            $0.saved
        }.map { post in
            SavedItem(
                id: post.id,
                title: post.title,
                author: "\(post.author) · \(post.category.label)"
            )
        }

        return savedPosts + [FrontendMocks.savedExtra]
    }

    var body: some View {
        VStack(spacing: 0) {
            StatusStrip(xp: xp)
            header

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    sectionTitle(
                        text: "COMPONENTES ESCANEADOS",
                        showsScanButton: true
                    )

                    if inventory.isEmpty {
                        emptyInventory
                            .padding(.bottom, 28)
                    } else {
                        LazyVGrid(columns: inventoryColumns, spacing: 10) {
                            ForEach(inventory) { item in
                                inventoryCard(item: item)
                            }
                        }
                        .padding(.bottom, 28)
                    }

                    sectionTitle(text: "PROJETOS EM ANDAMENTO")

                    VStack(spacing: 10) {
                        ForEach(projects) { project in
                            Button {
                                advanceProject(project: project)
                            } label: {
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text(project.name)
                                            .font(.system(size: 15, weight: .bold))
                                        Spacer()
                                        Text("\(project.progress)%")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.blinkOrange)
                                    }

                                    ThinProgressBar(value: project.progress)

                                    Text(project.nextStep)
                                        .font(.system(size: 13))
                                        .foregroundColor(.blinkCharcoal.opacity(0.70))
                                }
                                .padding(16)
                                .background(Color.blinkSurface)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 1)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 28)

                    sectionTitle(text: "SALVOS DA COMUNIDADE")

                    ForEach(saved) { item in
                        HStack(spacing: 12) {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.blinkCharcoal)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: 13, weight: .bold))
                                Text(item.author)
                                    .font(.system(size: 11))
                                    .foregroundColor(.blinkCharcoal.opacity(0.45))
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.blinkCharcoal.opacity(0.35))
                        }
                        .padding(.vertical, 14)

                        Divider()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
    }

    private func inventoryCard(item: InventoryItem) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blinkSand)
                    .frame(width: 34, height: 34)
                Image(systemName: "waveform.path")
                    .font(.system(size: 14))
                    .foregroundColor(.blinkCharcoal)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.system(size: 13, weight: .bold))
                Text("\(item.quantity) UN")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
            }

            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(Color.blinkSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(radius: 1)
    }

    private var emptyInventory: some View {
        VStack(spacing: 10) {
            Image(systemName: "camera")
                .font(.system(size: 22))
                .foregroundColor(.blinkOrange)

            Text("Nenhum componente escaneado")
                .font(.system(size: 14, weight: .bold))

            Text("Use a câmera para reconhecer o primeiro componente da sua bancada.")
                .font(.system(size: 12))
                .foregroundColor(.blinkCharcoal.opacity(0.45))
                .multilineTextAlignment(.center)

            Button("Escanear componente") {
                selectedTab = 2
            }
            .font(.system(size: 12, weight: .bold))
            .foregroundColor(.blinkOrange)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.blinkSand)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var header: some View {
        VStack(spacing: 0) {
            Divider()

            VStack(alignment: .leading, spacing: 2) {
                Text("Bancada")
                    .font(.system(size: 22, weight: .heavy))
                Text("Seus componentes e projetos em andamento")
                    .font(.system(size: 13))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Divider()
        }
    }

    private func sectionTitle(
        text: String,
        showsScanButton: Bool = false
    ) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blinkCharcoal.opacity(0.45))
            Spacer()

            if showsScanButton {
                Button("Escanear") {
                    selectedTab = 2
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.blinkOrange)
            }
        }
        .padding(.bottom, 12)
    }

    private func advanceProject(project: ProjectItem) {
        guard let index = projects.firstIndex(where: {
            $0.id == project.id
        }) else {
            return
        }

        if projects[index].progress < 100 {
            projects[index].progress += 10
        }

        if projects[index].progress > 100 {
            projects[index].progress = 100
        }

        if projects[index].progress == 100 {
            projects[index].nextStep = "Projeto concluído."
        }
    }
}
