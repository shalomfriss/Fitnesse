import SwiftUI

enum AppTheme {
    static let brand = "TOTAL TRAINING TOOLS"

    static let accent = Color(red: 0.055, green: 0.32, blue: 0.25)
    static let onAccent = Color.white
    static let heroAccent = Color(red: 0.76, green: 0.89, blue: 0.79)
    static let teal = Color(red: 0.08, green: 0.38, blue: 0.31)
    static let coral = accent
    static let blue = Color(red: 0.10, green: 0.29, blue: 0.25)

    static let ink = Color(red: 0.055, green: 0.09, blue: 0.075)
    static let secondaryInk = Color(red: 0.30, green: 0.36, blue: 0.33)
    static let background = Color(red: 0.965, green: 0.96, blue: 0.925)
    static let backgroundRaised = Color(red: 0.995, green: 0.99, blue: 0.97)
    static let surface = accent.opacity(0.045)
    static let surfaceStrong = accent.opacity(0.10)
    static let stroke = ink.opacity(0.14)

    static let cardRadius = 20.0
    static let smallRadius = 12.0

    static func displayFont(size: CGFloat, relativeTo style: Font.TextStyle = .largeTitle) -> Font {
        .custom("Avenir Next", size: size, relativeTo: style).weight(.bold)
    }
}
