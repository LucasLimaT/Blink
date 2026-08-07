import SwiftUI

struct DiagnosticoView: View {
    @Binding var inventory: [InventoryItem]
    @Binding var selectedTab: Int

    @StateObject private var camera = CameraManager()
    @State private var projectSuggestion: ProjectSuggestion?
    @State private var isFindingSuggestion = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.blinkCharcoal.ignoresSafeArea()

            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    CameraPreview(session: camera.session)

                    statusLabel
                        .padding(.bottom, 18)

                    VStack {
                        topBar
                        Spacer()
                    }
                }
                .clipped()

                resultSheet
            }
        }
        .onAppear {
            camera.start()
        }
        .onDisappear {
            camera.stop()
        }
        .task(id: camera.currentDetection?.id) {
            guard let detection = camera.currentDetection else {
                isFindingSuggestion = false
                projectSuggestion = nil
                return
            }

            isFindingSuggestion = true
            projectSuggestion = MockData.projectSuggestion(
                components: [detection.component.name]
            )
            isFindingSuggestion = false
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                closeCamera()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.blinkCharcoal.opacity(0.6))
                        .frame(width: 38, height: 38)
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
            }

            Spacer()

            Text("DIAGNÓSTICO")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.blinkCharcoal.opacity(0.6))
                .clipShape(Capsule())

            Spacer()
            Color.clear.frame(width: 38, height: 38)
        }
        .padding(18)
    }

    private var statusLabel: some View {
        HStack(spacing: 6) {
            if camera.currentDetection == nil {
                Image(systemName: "viewfinder")
                    .font(.system(size: 11, weight: .bold))
            }

            Text(camera.currentDetection?.component.name ?? camera.statusMessage)
                .font(.system(size: 10, weight: .bold))

            if let detection = camera.currentDetection {
                Text("\(detection.confidence)%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            camera.currentDetection == nil
                ? Color.blinkCharcoal.opacity(0.7)
                : Color.blinkBlue
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var resultSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .fill(Color.blinkCharcoal.opacity(0.15))
                .frame(width: 36, height: 4)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 16)

            Text("RECONHECIDO NA BANCADA")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blinkCharcoal.opacity(0.45))
                .padding(.bottom, 10)

            if let detection = camera.currentDetection {
                Text(detection.component.name)
                    .font(.system(size: 13, weight: .semibold))
                    .padding(.horizontal, 13)
                    .padding(.vertical, 7)
                    .background(Color.blinkSand)
                    .clipShape(Capsule())
            } else {
                Text("Aponte a câmera para um componente")
                    .font(.system(size: 14))
                    .foregroundColor(.blinkCharcoal.opacity(0.45))
            }

            if isFindingSuggestion {
                ProgressView()
                    .padding(.top, 14)
            } else if let projectSuggestion {
                ProjectSuggestionCard(project: projectSuggestion)
                    .padding(.top, 14)
            }

            if let error = camera.errorMessage {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.blinkRed)
                    .padding(.top, 12)
            }

            PrimaryButton(title: "Fechar", action: closeCamera)
                .padding(.top, 18)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 26)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blinkSurface)
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    private func closeCamera() {
        saveComponent()
        selectedTab = 0
    }

    private func saveComponent() {
        guard let component = camera.currentDetection?.component else {
            return
        }

        let itemName = inventoryName(component: component)

        if let index = inventory.firstIndex(where: {
            $0.name == itemName
        }) {
            inventory[index].quantity += 1
        } else {
            inventory.append(
                InventoryItem(name: itemName, quantity: 1)
            )
        }
    }

    private func inventoryName(component: ElectronicComponent) -> String {
        if component.id.lowercased() == "protoboard" {
            return "Protoboard 400"
        }
        if component.id.lowercased() == "led" {
            return "LED vermelho"
        }

        return component.name
    }
}

struct ProjectSuggestionCard: View {
    let project: ProjectSuggestion

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("\(project.title)\n\(project.description)")
                .font(.system(size: 13))
                .foregroundColor(.blinkCharcoal.opacity(0.70))
                .lineSpacing(3)

            if let value = project.url, let url = URL(string: value) {
                Link("Abrir projeto ↗", destination: url)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.blinkOrange)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.blinkSand)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blinkOrange)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
