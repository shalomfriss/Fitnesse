import SwiftUI

struct DashboardHeader: View {
    let name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(AppTheme.brand)
                    .font(.custom("Avenir Next Condensed", size: 15, relativeTo: .headline))
                    .bold()
                    .tracking(1.7)
                    .foregroundStyle(AppTheme.accent)

                Spacer()

                Text(Date.now, format: .dateTime.month(.abbreviated).day())
                    .font(.custom("Avenir Next", size: 14, relativeTo: .subheadline))
                    .foregroundStyle(.secondary)
            }

            Text("Ready, \(name)?")
                .font(AppTheme.displayFont(size: 40))
                .tracking(-0.8)
            Text("Your next strong day starts here.")
                .font(.custom("Avenir Next", size: 17, relativeTo: .body))
                .foregroundStyle(.secondary)
        }
        .padding(.top)
        .accessibilityElement(children: .combine)
    }
}
