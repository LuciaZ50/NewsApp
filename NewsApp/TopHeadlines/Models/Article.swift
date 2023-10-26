import Foundation

struct Article {

    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?

    init(from model: ArticleDataModel) {
        self.source = model.source
        self.author = model.author
        self.title = model.title
        self.description = model.description
        self.url = model.url
        self.urlToImage = model.urlToImage
        self.publishedAt = model.publishedAt
        self.content = model.content
    }
}

struct Source: Codable {
    let id: String?
    let name: String?

    init(from model: SourceDataModel) {
        self.id = model.id
        self.name = model.name
    }
}
