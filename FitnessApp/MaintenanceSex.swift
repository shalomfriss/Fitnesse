enum MaintenanceSex: String, CaseIterable, Identifiable {
    case female = "Female"
    case male = "Male"

    var id: Self { self }

    var calorieAdjustment: Double {
        switch self {
        case .female: -161
        case .male: 5
        }
    }
}
