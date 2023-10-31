import SwiftUI

struct NewsCard: View {
    let article: Article
    @State var showDate: Bool = false

    var body: some View {
        HStack {
            if let url = article.urlToImage {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .squareFrame(.cell)
                } placeholder: {
                    Image("image.placeholder")
                        .resizable()
                        .scaledToFill()
                        .squareFrame(.cell)
                }
            }
            VStack(alignment: .leading) {
                Text(article.title ?? "title")
                    .bold()
                    .lineLimit(nil)
                Spacer()
                HStack {
                    Text("Author:")
                    Spacer()
                    Text(article.author ?? "Author Unknown")
                        .font(.italic(.caption)())
                        .lineLimit(1)
                }
                if showDate {
                    Text(article.publishedAt?.formatDateAsDDMMYYYY() ?? "")
                        .font(.caption)
                }
            }
            .foregroundColor(.black)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: HeightsConstants.cell.height)
        .padding()
        .background(Color.lighterGray())
        .cornerRadius(.cell)
    }
}
