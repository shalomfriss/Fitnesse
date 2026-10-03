import SwiftUI

struct GlassCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: AppTheme.cardRadius)
                    .fill(AppTheme.backgroundRaised.opacity(0.82))
            }
            .clipShape(.rect(cornerRadius: AppTheme.cardRadius))
    }
}
