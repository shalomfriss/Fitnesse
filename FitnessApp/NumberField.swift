import SwiftUI

struct NumberField: View {
    let label: String
    @Binding var value: Int

    var body: some View {
        TextField(label, value: $value, format: .number)
            .keyboardType(.numberPad)
            .multilineTextAlignment(.trailing)
    }
}
