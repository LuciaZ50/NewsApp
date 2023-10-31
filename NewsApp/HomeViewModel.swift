import Dependencies
import Foundation

class HomeViewModel: ObservableObject {

    @Dependency(\.newsService) private var newService: NewsServiceProtocol

    @Published var topHeadlinesArticles: [Article] = []
    @Published var everythingArticles: [Article] = []
    @Published var searchText = ""

    @Published var selectedTab = 0 {
        didSet {
            currentpage = 1
        }
    }
    @Published var state: State = .loading

    @Published var currentpage = 1
    @Published var isLoadingMore = false

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
            let topHeadlinesData = try await newService.fetchTopHeadlines(at: currentpage)
            await MainActor.run {
                self.topHeadlinesArticles = topHeadlinesData?.compactMap { Article(from: $0) } ?? []
                self.state = .finished
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
            let everythingData = try await newService.fetchEverything(at: currentpage)
            await MainActor.run {
                self.everythingArticles = everythingData?.compactMap { Article(from: $0) } ?? []
            }
        } catch {
            print("Error fetching everything: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadMoreArticles() async {
        guard !isLoadingMore else { return }

        await MainActor.run {
            isLoadingMore = true
            currentpage += 1
        }

        do {
            var topHeadlinesFetchedArticles: [Article]?
            var everythingFetchedArticles: [Article]?
            switch selectedTab {
            case 0:
                if let articlesData = try await newService.fetchTopHeadlines(at: currentpage) {
                    topHeadlinesFetchedArticles = articlesData.compactMap { Article(from: $0) }
                }
            case 1:
                if let articlesData = try await newService.fetchEverything(at: currentpage) {
                    everythingFetchedArticles = articlesData.compactMap { Article(from: $0) }
                }
            default:
                break
            }

            if let articles = topHeadlinesFetchedArticles {
                self.topHeadlinesArticles.append(contentsOf: articles)
            }

            if let articles = everythingFetchedArticles {
                self.everythingArticles.append(contentsOf: articles)
            }

            isLoadingMore = false
        } catch {
            print("Error loading more articles: \(error.localizedDescription)")
            await MainActor.run {
                isLoadingMore = false
            }
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
