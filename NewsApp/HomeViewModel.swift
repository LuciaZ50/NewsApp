import Dependencies
import Foundation

class HomeViewModel: ObservableObject {

    @Dependency(\.newsService) private var newService: NewsServiceProtocol

    @Published var originalTopHeadlinesArticles: [Article] = []
    @Published var originalEverythingArticles: [Article] = []
    @Published var searchText = "dog" {
        didSet {
            updateFilteredArticles()
        }
    }
    @Published var topHeadlinesArticles: [Article] = []
    @Published var everythingArticles: [Article] = []

    @Published var selectedTab = 0 {
        didSet {
            currentpage = 1
        }
    }
    @Published var state: State = .loading
    @Published var sortingBy: Sorting = .ascending

    @Published var currentpage = 1
    @Published var isLoadingMore = false
    @Published var isRefreshing = false

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

    enum Sorting {
        case ascending
        case descending
    }

    init() {
        Task {
            await fetchTopHeadlines()
            await fetchEverything()
        }
    }

    func refreshData() async {

        await fetchEverything()
        await fetchTopHeadlines()

        await MainActor.run {
            isRefreshing = false
        }

    }

    func sortArticles() async {
        do {
            let everythingData = try await newService.fetchAllEverythings()
            await MainActor.run {
                self.originalEverythingArticles = everythingData?.compactMap { Article(from: $0) } ?? []
                self.everythingArticles = originalEverythingArticles.reversed()
            }
        } catch {
            print("Error sorting articles: \(error.localizedDescription)")
        }
    }

    private func updateFilteredArticles() {
        switch selectedTab {
        case 1:
            if searchText.isEmpty {
                everythingArticles = originalEverythingArticles
            } else {
                everythingArticles = originalEverythingArticles.filter { searchArticles($0) }
            }
        default:
            if searchText.isEmpty {
                topHeadlinesArticles = originalTopHeadlinesArticles
            } else {
                topHeadlinesArticles = originalTopHeadlinesArticles.filter { searchArticles($0) }
            }
        }
    }

    private func searchArticles(_ article: Article) -> Bool {
        guard searchText.isEmpty || (article.title?.lowercased().contains(searchText.lowercased()) == true) else {

            return false
        }
        return true
    }

    private func fetchTopHeadlines() async {
        await MainActor.run {
            self.state = .loading
        }
        do {
            let topHeadlinesData = try await newService.fetchTopHeadlines(for: self.searchText, page: currentpage)
            await MainActor.run {
                self.originalTopHeadlinesArticles = topHeadlinesData?.compactMap { Article(from: $0) } ?? []
                self.topHeadlinesArticles = originalTopHeadlinesArticles
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
            let everythingData = try await newService.fetchEverything(for: self.searchText, page: currentpage)
            await MainActor.run {
                self.originalEverythingArticles = everythingData?.compactMap { Article(from: $0) } ?? []
                self.everythingArticles = originalEverythingArticles
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
                if let articlesData = try await newService.fetchTopHeadlines(for: searchText, page: currentpage) {
                    topHeadlinesFetchedArticles = articlesData.compactMap { Article(from: $0) }
                }
            case 1:
                if let articlesData = try await newService.fetchEverything(for: searchText, page: currentpage) {
                    everythingFetchedArticles = articlesData.compactMap { Article(from: $0) }
                }
            default:
                break
            }

            if let articles = topHeadlinesFetchedArticles {
                self.originalTopHeadlinesArticles.append(contentsOf: articles)
            }

            if let articles = everythingFetchedArticles {
                self.originalEverythingArticles.append(contentsOf: articles)
            }

            isLoadingMore = false
        } catch {
            print("Error loading more articles: \(error.localizedDescription)")
            await MainActor.run {
                isLoadingMore = false
            }
        }
    }

}
