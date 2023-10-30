import Dependencies
import Foundation

class HomeViewModel: ObservableObject {

    @Dependency(\.newsService) private var newService: NewsServiceProtocol

    @Published var topHeadlinesArticles: [Article] = []
    @Published var everythingArticles: [Article] = []

    @Published var selectedTab = 0
    @Published var state: State = .loading

    var tabTitle: String {
        switch selectedTab {
        case 1:
            return "Everything"
        default:
            return "Top Headlines"
        }
    }

    enum State {
        case loading
        case finished
    }

    init() {
        Task {
            await fetchTopHeadlines()
            await fetchEverything()
        }
    }

    private func fetchTopHeadlines() async {
        self.state = .loading
        do {
            let topHeadlinesData = try await newService.fetchTopHeadlines()
            await MainActor.run {
                self.topHeadlinesArticles = topHeadlinesData?.compactMap { Article(from: $0) } ?? []
                self.state = .finished
                print("VM: \(topHeadlinesData)")
            }

        } catch {
            print("Error fetching top headlines: \(error.localizedDescription)")
            await MainActor.run {
                self.state = .finished
            }
        }
    }

    private func fetchEverything() async {
        do {
            let everythingData = try await newService.fetchEverything()
            await MainActor.run {
                self.everythingArticles = everythingData?.compactMap { Article(from: $0) } ?? []
            }
        } catch {
            print("Error fetching everything: \(error.localizedDescription)")
        }
    }

    var redactedData: [Article] {
        let redactedArticle = Article(
            author: "Author",
            title: "Title",
            urlToImage: URL(string: "https://picsum.photos/200")
        )

        return Array(repeating: redactedArticle, count: 5)
    }

}
