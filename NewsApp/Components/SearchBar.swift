import SwiftUI

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.lighterGray())
            TextField("Search", text: $text)
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .squareFrame(.search)
                        .foregroundColor(.lighterGray())
                }
            }
        }
        .padding(.horizontal)
        .frame(height: 40)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(.cell)
        .overlay(
            RoundedRectangle(cornerRadius: .cell)
                .stroke(Color.lighterGray())
        )
    }

}
