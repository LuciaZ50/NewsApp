import Foundation

struct Article {

    let id = UUID().uuidString
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?

    init(from model: ArticleDataModel) {
        self.source = Source(from: model.source)
        self.author = model.author
        self.title = model.title
        self.description = model.description
        self.url = model.url
        self.urlToImage = model.urlToImage
        self.publishedAt = model.publishedAt
        self.content = model.content
    }

    init(source: Source? = nil,
         author: String? = nil,
         title: String? = nil,
         description: String? = nil,
         url: URL? = nil,
         urlToImage: URL? = nil,
         publishedAt: String? = nil,
         content: String? = nil) {
        self.source = source
        self.author = author
        self.title = title
        self.description = description
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
    }

}

struct Source: Codable {
    let id: String?
    let name: String?

    init(from model: SourceDataModel?) {
        self.id = model?.id
        self.name = model?.name
    }
}
