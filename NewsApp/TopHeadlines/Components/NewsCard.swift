import SwiftUI

struct NewsCard: View {

    let article: Article

    var body: some View {
        VStack(alignment: .leading) {
            Text(article.title ?? "title")
//            AsyncImage(url: <#T##URL?#>) { <#Image#> in
//                <#code#>
//            } placeholder: {
//                <#code#>
//            }

        }
    }
}

struct NewsCard_Previews: PreviewProvider {
    static var previews: some View {
        let article = Article(from: ArticleDataModel(
            source: Source(from: SourceDataModel(id: "id", name: "name")),
            author: "Lucia Zuzic",
            title: "Some title",
            description: "some description",
            url: "",
            urlToImage: "",
            publishedAt: "26-10-2023",
            content: "content"))

        return NewsCard(article: article)
    }
}
