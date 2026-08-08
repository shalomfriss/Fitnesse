import SwiftUI

struct ProgressRing: View {
    let progress: Double
    let color: Color
    let centerText: String

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.10), lineWidth: 10)
            Circle()
                .trim(from: 0, to: min(max(progress, 0), 1))
                .stroke(color, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text(centerText)
                .font(.headline)
                .bold()
                .minimumScaleFactor(0.7)
        }
        .accessibilityLabel("Progress")
        .accessibilityValue(Text(progress, format: .percent))
    }
}
