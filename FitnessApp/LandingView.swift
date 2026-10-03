import SwiftUI

struct LandingView: View {
    let continueAction: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false

    var body: some View {
        ZStack {
            Image("training-hero")
                .resizable()
                .scaledToFill()
                .scaleEffect(appeared && !reduceMotion ? 1.0 : 1.045)
                .animation(.smooth(duration: 1.4), value: appeared)
                .ignoresSafeArea()
                .accessibilityHidden(true)

            LinearGradient(
                stops: [
                    .init(color: AppTheme.ink.opacity(0.22), location: 0),
                    .init(color: .clear, location: 0.38),
                    .init(color: AppTheme.ink.opacity(0.18), location: 0.58),
                    .init(color: AppTheme.ink.opacity(0.94), location: 1)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top, spacing: 12) {
                    Text("TOTAL")
                        .font(AppTheme.displayFont(size: 54))
                        .tracking(-2.6)

                    Rectangle()
                        .fill(AppTheme.heroAccent)
                        .frame(width: 4, height: 50)

                    Text("TRAINING\nTOOLS")
                        .font(.custom("Avenir Next Condensed", size: 15, relativeTo: .headline))
                        .bold()
                        .tracking(1.8)
                        .lineSpacing(-2)
                        .padding(.top, 5)
                }
                .foregroundStyle(.white)
                .opacity(appeared ? 1 : 0)
                .offset(y: reduceMotion || appeared ? 0 : -18)
                .animation(.smooth(duration: 0.65), value: appeared)

                Spacer()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Built for the work.")
                        .font(AppTheme.displayFont(size: 40))
                        .tracking(-1.25)
                        .foregroundStyle(.white)

                    Text("Plan the session. Track the effort. Keep moving without giving your data away.")
                        .font(.custom("Avenir Next", size: 18, relativeTo: .body))
                        .foregroundStyle(.white.opacity(0.94))
                        .lineSpacing(3)
                        .fixedSize(horizontal: false, vertical: true)

                    Button("Start training", systemImage: "arrow.up.right", action: continueAction)
                        .font(.custom("Avenir Next", size: 17, relativeTo: .headline))
                        .bold()
                        .foregroundStyle(AppTheme.ink)
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .background(AppTheme.heroAccent)
                        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                        .buttonStyle(KineticButtonStyle())
                        .accessibilityHint("Opens your training dashboard")

                    Text("NO ACCOUNT · STORED ON DEVICE")
                        .font(.custom("Avenir Next", size: 13, relativeTo: .footnote))
                        .bold()
                        .tracking(0.8)
                        .foregroundStyle(.white.opacity(0.82))
                        .frame(maxWidth: .infinity)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: reduceMotion || appeared ? 0 : 24)
                .animation(.smooth(duration: 0.7).delay(reduceMotion ? 0 : 0.16), value: appeared)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 20)
        }
        .task {
            appeared = true
        }
    }
}

#Preview {
    LandingView(continueAction: {})
        .preferredColorScheme(.light)
}
