import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ZStack {
            ScreenBackground()
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ExerciseIllustration(exercise: exercise, compact: false)
                        .frame(maxWidth: .infinity, minHeight: 240)
                    Text(exercise.name).font(.largeTitle).bold()
                    HStack {
                        Label(exercise.muscleGroup, systemImage: "figure.arms.open")
                        Spacer()
                        Label(exercise.equipment, systemImage: "wrench.and.screwdriver")
                    }
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.accent)
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("How to perform").font(.title3).bold()
                            Text(exercise.instructions).foregroundStyle(.secondary).lineSpacing(4)
                        }
                    }
                    if let youtubeShortsURL = exercise.youtubeShortsURL {
                        Link(destination: youtubeShortsURL) {
                            Label("Watch a YouTube Short", systemImage: "play.rectangle.fill")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity, minHeight: 58)
                                .background(.red)
                                .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Opens YouTube demonstrations for \(exercise.name)")
                    }
                    GlassCard {
                        VStack(alignment: .leading, spacing: 10) {
                            Label("Form cue", systemImage: "lightbulb.fill").font(.headline).foregroundStyle(AppTheme.teal)
                            Text("Choose a load that lets you keep control through the full range of motion. Stop if you feel sharp pain.").foregroundStyle(.secondary)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
