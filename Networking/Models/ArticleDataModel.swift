import Foundation

struct ArticleDataModel: Codable {

    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct SourceDataModel: Codable {
    let id: String?
    let name: String?
}
