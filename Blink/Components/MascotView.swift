import SwiftUI

enum MascotPose: String {
    case walk = "mascot-walk"
    case wave = "mascot-wave"
    case blinkOn = "mascot-blink-on"
}

struct MascotView: View {
    var pose: MascotPose = .walk

    var body: some View {
        Image(pose.rawValue)
            .resizable()
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
