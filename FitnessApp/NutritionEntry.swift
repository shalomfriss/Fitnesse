import Foundation

struct NutritionEntry: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let date: Date
    let calories: Int
    let protein: Int
    let carbs: Int
    let fat: Int

    init(id: UUID = UUID(), name: String, date: Date = .now, calories: Int, protein: Int, carbs: Int, fat: Int) {
        self.id = id
        self.name = name
        self.date = date
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
    }
}
