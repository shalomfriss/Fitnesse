import SwiftUI

struct CustomExerciseEntryView: View {
    @Binding var name: String
    let canAdd: Bool
    let add: () -> Void

    var body: some View {
        HStack {
            TextField("Custom exercise name", text: $name)
                .textInputAutocapitalization(.words)
                .submitLabel(.done)
                .onSubmit(add)

            Button("Add custom exercise", systemImage: "plus", action: add)
                .labelStyle(.iconOnly)
                .buttonStyle(.borderedProminent)
                .disabled(!canAdd)
        }
    }
}
