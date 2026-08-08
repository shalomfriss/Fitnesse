import Foundation

struct NutritionDraft: Identifiable {
    let id = UUID()
    var name: String
    var calories: Int
    var protein: Int
    var carbs: Int
    var fat: Int
}
