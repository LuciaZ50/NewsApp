import Foundation

struct ArticleDataModel: Codable {

    let source: SourceDataModel?
    let author: String?
    let title: String?
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: String?
    let content: String?

    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
        case content
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        url = try container.decode(URL?.self, forKey: .url)
        source = try container.decode(SourceDataModel?.self, forKey: .source)
        author = try container.decode(String?.self, forKey: .author)
        title = try container.decode(String?.self, forKey: .title)
        description = try container.decode(String?.self, forKey: .description)
        publishedAt = try container.decode(String?.self, forKey: .publishedAt)
        content = try container.decode(String?.self, forKey: .content)

        if let urlString = try container.decodeIfPresent(String.self, forKey: .urlToImage) {
            urlToImage = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        } else {
            urlToImage = nil
        }
    }

}

struct SourceDataModel: Codable {
    let id: String?
    let name: String?
}
