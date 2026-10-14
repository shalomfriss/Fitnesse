import Foundation

enum MoreDestination: String, Identifiable {
    case exercises
    case tools
    case settings

    var id: String { rawValue }
}
