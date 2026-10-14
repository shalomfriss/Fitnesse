import Foundation

enum TimerLibraryFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case predefined = "Predefined"
    case intervals = "Intervals"
    case favorites = "Favorites"

    var id: String { rawValue }
}
