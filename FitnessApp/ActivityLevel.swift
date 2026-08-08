enum ActivityLevel: String, CaseIterable, Identifiable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly active"
    case moderatelyActive = "Moderately active"
    case veryActive = "Very active"
    case extremelyActive = "Extremely active"

    var id: Self { self }

    var multiplier: Double {
        switch self {
        case .sedentary: 1.2
        case .lightlyActive: 1.375
        case .moderatelyActive: 1.55
        case .veryActive: 1.725
        case .extremelyActive: 1.9
        }
    }

    var detail: String {
        switch self {
        case .sedentary: "Little or no exercise"
        case .lightlyActive: "Exercise 1–3 days per week"
        case .moderatelyActive: "Exercise 3–5 days per week"
        case .veryActive: "Hard exercise 6–7 days per week"
        case .extremelyActive: "Very hard training or physical work"
        }
    }
}
