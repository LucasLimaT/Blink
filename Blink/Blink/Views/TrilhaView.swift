import SwiftUI

struct TrilhaView: View {
    @Binding var modules: [Module]
    @Binding var xp: Int

    @State private var selectedModuleID: String?

    var progress: Int {
        let started = modules.filter {
            $0.state == .done || $0.state == .current
        }.count
        let total = modules.filter {
            $0.state != .chest
        }.count

        if total == 0 {
            return 0
        }

        return started * 100 / total
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                StatusStrip(xp: xp)
                unitHeader

                ScrollView(showsIndicators: false) {
                    ZStack {
                        DotGrid()

                        VStack(spacing: 0) {
                            ForEach(modules.indices, id: \.self) { index in
                                trailRow(module: modules[index], index: index)

                                if index < modules.count - 1 {
                                    trailConnector(after: index)
                                }
                            }

                            unitDivider
                                .padding(.top, 22)
                        }
                        .padding(.top, 24)
                    }
                    .padding(.bottom, 30)
                }
            }
            .navigationDestination(item: $selectedModuleID) { moduleID in
                if let index = modules.firstIndex(where: {
                    $0.id == moduleID
                }) {
                    ModuleDetailView(module: $modules[index]) {
                        completeModule(module: modules[index])
                    }
                }
            }
        }
    }

    private var unitHeader: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 2) {
                Text("UNIDADE 1 · FUNDAMENTOS")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white.opacity(0.72))
                Text("Corrente e resistência")
                    .font(.system(size: 17, weight: .heavy))
                    .foregroundColor(.white)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 5) {
                Text("\(progress)%")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                ThinProgressBar(value: progress, tint: .white)
                    .frame(width: 96)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.blinkOrange)
    }

    private func trailRow(module: Module, index: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<17, id: \.self) { column in
                Group {
                    if column == position(index: index) {
                        TrailNode(module: module) {
                            selectedModuleID = module.id
                        }
                    } else if module.state == .current
                                && column == position(index: index) + 4 {
                        MascotView(pose: .walk)
                            .frame(width: 64, height: 64)
                    } else {
                        Color.clear
                            .frame(height: 64)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func trailConnector(after index: Int) -> some View {
        let positions = connectorPositions(after: index)

        return VStack(spacing: 3) {
            ForEach(positions.indices, id: \.self) { dotIndex in
                connectorDot(position: positions[dotIndex])
            }
        }
        .padding(.vertical, 2)
    }

    private func connectorDot(position: Int) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<17, id: \.self) { column in
                Group {
                    if column == position {
                        Circle()
                            .fill(Color.blinkCharcoal.opacity(0.20))
                            .frame(width: 5, height: 5)
                    } else {
                        Color.clear
                            .frame(width: 5, height: 5)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private func position(index: Int) -> Int {
        switch index % 8 {
        case 0:
            return 8
        case 1:
            return 5
        case 2:
            return 4
        case 3:
            return 7
        case 4:
            return 11
        case 5:
            return 12
        case 6:
            return 9
        default:
            return 5
        }
    }

    private func connectorPositions(after index: Int) -> [Int] {
        let start = position(index: index)
        let end = position(index: index + 1)
        var positions: [Int] = []
        var current = start

        while current != end {
            positions.append(current)
            positions.append(current)
            current += current < end ? 1 : -1
        }

        positions.append(end)
        positions.append(end)
        return positions
    }

    private func completeModule(module: Module) {
        guard let currentIndex = modules.firstIndex(where: {
            $0.id == module.id
        }) else {
            return
        }

        modules[currentIndex].state = .done
        xp += 100

        if let nextIndex = modules.indices.first(where: {
            $0 > currentIndex && modules[$0].state == .locked
        }) {
            modules[nextIndex].state = .current
        }
    }

    private var unitDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.blinkCharcoal.opacity(0.10))
                .frame(height: 1)
            Text("UNIDADE 2 · EM BREVE")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.blinkCharcoal.opacity(0.35))
            Rectangle()
                .fill(Color.blinkCharcoal.opacity(0.10))
                .frame(height: 1)
        }
        .padding(.horizontal, 20)
    }
}

private struct DotGrid: View {
    var body: some View {
        VStack(spacing: 18) {
            ForEach(0..<48, id: \.self) { _ in
                HStack(spacing: 18) {
                    ForEach(0..<16, id: \.self) { _ in
                        Circle()
                            .fill(Color.blinkCharcoal.opacity(0.15))
                            .frame(width: 2, height: 2)
                    }
                }
            }
        }
    }
}
