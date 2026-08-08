import Foundation

struct Exercise: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let muscleGroup: String
    let equipment: String
    let instructions: String

    init(id: UUID = UUID(), name: String, muscleGroup: String, equipment: String, instructions: String) {
        self.id = id
        self.name = name
        self.muscleGroup = muscleGroup
        self.equipment = equipment
        self.instructions = instructions
    }

    var illustrationSymbol: String {
        switch name {
        case "Walking Lunge": "figure.walk.motion"
        case "Pull-Up", "Hanging Knee Raise", "Dips": "figure.climbing"
        case "Push-Up", "Plank", "Dead Bug", "Russian Twist", "Mountain Climber": "figure.core.training"
        case "Burpee", "Kettlebell Swing", "Box Jump": "figure.highintensity.intervaltraining"
        case "Running": "figure.run"
        case "Cycling": "figure.outdoor.cycle"
        case "Rowing": "figure.rower"
        case "Jump Rope": "figure.jumprope"
        case "Child's Pose": "figure.mind.and.body"
        case "World's Greatest Stretch": "figure.flexibility"
        case "Band Pull-Apart": "figure.cooldown"
        case "Hip Thrust", "Glute Bridge": "figure.strengthtraining.functional"
        default: "figure.strengthtraining.traditional"
        }
    }

    var equipmentSymbol: String {
        switch equipment {
        case "Barbell": "dumbbell.fill"
        case "Dumbbell", "Dumbbells": "dumbbell.fill"
        case "Bodyweight", "None": "figure.stand"
        case "Bike": "bicycle"
        case "Cable": "cable.connector"
        case "Machine", "Rower": "gearshape.2.fill"
        case "Kettlebell", "Medicine Ball": "circle.fill"
        case "Pull-up Bar": "minus"
        case "Jump Rope", "Resistance Band": "point.topleft.down.to.point.bottomright.curvepath"
        case "Box": "shippingbox.fill"
        case "Mat": "rectangle.fill"
        default: "wrench.and.screwdriver.fill"
        }
    }

    var youtubeShortsURL: URL? {
        var components = URLComponents(string: "https://www.youtube.com/results")
        components?.queryItems = [
            URLQueryItem(name: "search_query", value: "\(name) exercise proper form shorts")
        ]
        return components?.url
    }
}
