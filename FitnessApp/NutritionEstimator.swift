import Foundation

enum NutritionEstimator {
    static func estimate(_ description: String) -> NutritionDraft {
        let text = description.lowercased()
        var calories = 180
        var protein = 6
        var carbs = 22
        var fat = 7

        add("chicken", text, 220, 38, 0, 6, &calories, &protein, &carbs, &fat)
        add("salmon", text, 260, 34, 0, 13, &calories, &protein, &carbs, &fat)
        add("steak", text, 320, 36, 0, 19, &calories, &protein, &carbs, &fat)
        add("egg", text, 140, 12, 1, 10, &calories, &protein, &carbs, &fat)
        add("rice", text, 205, 4, 45, 1, &calories, &protein, &carbs, &fat)
        add("pasta", text, 310, 11, 61, 4, &calories, &protein, &carbs, &fat)
        add("potato", text, 160, 4, 37, 0, &calories, &protein, &carbs, &fat)
        add("avocado", text, 160, 2, 9, 15, &calories, &protein, &carbs, &fat)
        add("yogurt", text, 130, 17, 9, 3, &calories, &protein, &carbs, &fat)
        add("protein shake", text, 180, 30, 8, 3, &calories, &protein, &carbs, &fat)
        add("salad", text, 90, 3, 12, 4, &calories, &protein, &carbs, &fat)
        add("oat", text, 190, 7, 33, 4, &calories, &protein, &carbs, &fat)

        return NutritionDraft(name: description.trimmingCharacters(in: .whitespacesAndNewlines), calories: calories, protein: protein, carbs: carbs, fat: fat)
    }

    private static func add(_ keyword: String, _ text: String, _ addedCalories: Int, _ addedProtein: Int, _ addedCarbs: Int, _ addedFat: Int, _ calories: inout Int, _ protein: inout Int, _ carbs: inout Int, _ fat: inout Int) {
        guard text.contains(keyword) else { return }
        calories += addedCalories
        protein += addedProtein
        carbs += addedCarbs
        fat += addedFat
    }
}
