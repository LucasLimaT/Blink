import SwiftUI

struct CategoryTag: View {
    let category: PostCategory

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: category.symbol)
                .font(.system(size: 11, weight: .semibold))
            Text(category.label.uppercased())
                .font(.system(size: 10, weight: .bold))
        }
        .foregroundColor(category.color)
    }
}
