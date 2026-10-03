import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    @State private var showingVideo = false

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
                        Button("Watch form videos", systemImage: "play.rectangle.fill") {
                            showingVideo = true
                        }
                        .font(.title3)
                        .bold()
                        .foregroundStyle(AppTheme.onAccent)
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .background(AppTheme.accent)
                        .clipShape(.rect(cornerRadius: AppTheme.smallRadius))
                        .contentShape(.rect)
                        .buttonStyle(.plain)
                        .accessibilityHint("Plays YouTube demonstrations for \(exercise.name) without leaving the app")
                        .sheet(isPresented: $showingVideo) {
                            InAppVideoBrowser(url: youtubeShortsURL)
                                .ignoresSafeArea()
                        }
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
