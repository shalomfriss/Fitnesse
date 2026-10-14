import SwiftUI

enum AppTheme {
    static let brand = "TOTAL TRAINING TOOLS"

    static let accent = Color(red: 1.0, green: 0.83, blue: 0.08)
    static let onAccent = Color(red: 0.055, green: 0.06, blue: 0.065)
    static let heroAccent = accent
    static let teal = accent
    static let coral = accent
    static let blue = accent

    static let ink = Color(red: 0.96, green: 0.97, blue: 0.98)
    static let secondaryInk = Color(red: 0.62, green: 0.65, blue: 0.69)
    static let background = Color(red: 0.035, green: 0.04, blue: 0.045)
    static let backgroundRaised = Color(red: 0.075, green: 0.08, blue: 0.09)
    static let surface = Color(red: 0.10, green: 0.11, blue: 0.12)
    static let surfaceStrong = Color(red: 0.14, green: 0.15, blue: 0.16)
    static let stroke = Color.white.opacity(0.13)

    static let cardRadius = 20.0
    static let smallRadius = 12.0

    static func displayFont(size: CGFloat, relativeTo style: Font.TextStyle = .largeTitle) -> Font {
        .custom("Avenir Next", size: size, relativeTo: style).weight(.bold)
    }
}
