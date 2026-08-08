import SwiftUI

struct MaintenanceCaloriesCalculatorView: View {
    @State private var sex = MaintenanceSex.male
    @State private var age = 30
    @State private var heightFeet = 5
    @State private var heightInches = 10
    @State private var weightPounds = 170.0
    @State private var activityLevel = ActivityLevel.moderatelyActive

    private var restingCalories: Int {
        Int(basalMetabolicRate.rounded())
    }

    private var maintenanceCalories: Int {
        Int((basalMetabolicRate * activityLevel.multiplier).rounded())
    }

    private var basalMetabolicRate: Double {
        let kilograms = weightPounds * 0.453_592_37
        let centimeters = Double((heightFeet * 12) + heightInches) * 2.54
        return (10 * kilograms) + (6.25 * centimeters) - (5 * Double(age)) + sex.calorieAdjustment
    }

    var body: some View {
        Form {
            Section {
                MaintenanceCaloriesResultView(
                    maintenanceCalories: maintenanceCalories,
                    restingCalories: restingCalories
                )
            }

            Section("About you") {
                Picker("Sex", selection: $sex) {
                    ForEach(MaintenanceSex.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)

                Stepper(value: $age, in: 18...100) {
                    LabeledContent("Age", value: "\(age) years")
                }

                Stepper(value: $weightPounds, in: 75...500, step: 1) {
                    LabeledContent("Weight", value: "\(Int(weightPounds)) lb")
                }

                Stepper(value: $heightFeet, in: 3...8) {
                    LabeledContent("Height — feet", value: "\(heightFeet) ft")
                }

                Stepper(value: $heightInches, in: 0...11) {
                    LabeledContent("Height — inches", value: "\(heightInches) in")
                }
            }

            Section("Activity") {
                Picker("Activity level", selection: $activityLevel) {
                    ForEach(ActivityLevel.allCases) { level in
                        Text(level.rawValue).tag(level)
                    }
                }

                Text(activityLevel.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                Text("This estimate uses the Mifflin–St Jeor equation. It is a starting point, not medical advice; your actual needs may vary.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(ScreenBackground())
        .navigationTitle("Maintenance Calories")
        .navigationBarTitleDisplayMode(.inline)
    }
}
