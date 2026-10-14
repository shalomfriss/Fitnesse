import SwiftUI

struct TimerLibraryFilterBar: View {
    @Binding var selection: TimerLibraryFilter

    var body: some View {
        HStack(spacing: 3) {
            ForEach(TimerLibraryFilter.allCases) { filter in
                Button {
                    selection = filter
                } label: {
                    Text(filter.rawValue)
                        .font(.subheadline.weight(selection == filter ? .semibold : .medium))
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity, minHeight: 42)
                        .foregroundStyle(selection == filter ? AppTheme.onAccent : AppTheme.ink)
                        .background {
                            if selection == filter {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(AppTheme.accent)
                            }
                        }
                        .contentShape(.rect(cornerRadius: 9))
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(selection == filter ? .isSelected : [])
            }
        }
        .padding(3)
        .background(AppTheme.backgroundRaised)
        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
        .overlay {
            RoundedRectangle(cornerRadius: AppTheme.smallRadius)
                .stroke(AppTheme.stroke, lineWidth: 1)
        }
    }
}
