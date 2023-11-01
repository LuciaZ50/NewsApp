import Dependencies
import Foundation

@MainActor
class HomeViewModel: ObservableObject {

    @Dependency(\.newsService) private var newService: NewsServiceProtocol

    @Published var originalTopHeadlinesArticles: [Article] = []
    @Published var originalEverythingArticles: [Article] = []
    @Published var searchTextTopHeadlines = "" {
        didSet {
            updateFilteredArticles()
        }
    }
    @Published var searchTextEverythings = "cat" {
        didSet {
            updateFilteredArticles()
        }
    }
    @Published var topHeadlinesArticles: [Article] = []
    @Published var everythingArticles: [Article] = []

    @Published var selectedTab: HomeTab = .topHeadlines {
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
        case .everything:
            return "Everything"
        case .topHeadlines:
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

    enum HomeTab {
        case topHeadlines
        case everything
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

        isRefreshing = false

    }

    func sortArticles()  {
        if sortingBy == .ascending {
            self.everythingArticles = everythingArticles.sorted { (article1, article2) -> Bool in
                if let date1 = article1.publishedAt, let date2 = article2.publishedAt {
                    return date1 > date2
                }
                return false
            }
            sortingBy = .descending
        } else {
            self.everythingArticles = everythingArticles.reversed()
            sortingBy = .ascending
        }
    }

    private func updateFilteredArticles() {
        switch selectedTab {
        case .everything:
            if searchTextEverythings.isEmpty {
                everythingArticles = originalEverythingArticles
            } else {
                everythingArticles = originalEverythingArticles.filter { searchArticles(
                    $0,
                    in: self.everythingArticles,
                    with: self.searchTextEverythings) }
            }
        case .topHeadlines:
            if searchTextTopHeadlines.isEmpty {
                topHeadlinesArticles = originalTopHeadlinesArticles
            } else {
                topHeadlinesArticles = originalTopHeadlinesArticles.filter { searchArticles(
                    $0,
                    in: self.topHeadlinesArticles,
                    with: self.searchTextTopHeadlines) }
            }
        }
    }

    private func searchArticles(_ article: Article, in articles: [Article], with queryText: String) -> Bool {
        guard queryText.isEmpty || (article.title?.lowercased().contains(queryText.lowercased()) == true) else {
            return false
        }
        return true
    }

    private func fetchTopHeadlines() async {
        self.state = .loading
        do {
            let topHeadlinesData = try await newService.fetchTopHeadlines(page: currentpage)
            self.originalTopHeadlinesArticles = topHeadlinesData?.compactMap { Article(from: $0) } ?? []
            self.topHeadlinesArticles = originalTopHeadlinesArticles
            self.state = .finished
        } catch {
            print("Error fetching top headlines: \(error.localizedDescription)")
            self.state = .finished
        }
    }

    private func fetchEverything() async {
        do {
            let everythingData = try await newService.fetchEverything(for: self.searchTextEverythings, page: currentpage)
            self.originalEverythingArticles = everythingData?.compactMap { Article(from: $0) } ?? []
            self.everythingArticles = originalEverythingArticles
            sortArticles()
        } catch {
            print("Error fetching everything: \(error.localizedDescription)")
        }
    }

    @MainActor
    func loadMoreArticles() async {
        guard !isLoadingMore else { return }

        isLoadingMore = true
        currentpage += 1

        do {
            var topHeadlinesFetchedArticles: [Article]?
            var everythingFetchedArticles: [Article]?
            switch selectedTab {
            case .topHeadlines:
                if let articlesData = try await newService.fetchTopHeadlines(page: currentpage) {
                    topHeadlinesFetchedArticles = articlesData.compactMap { Article(from: $0) }
                }
            case .everything:
                if let articlesData = try await newService.fetchEverything(for: searchTextEverythings, page: currentpage) {
                    everythingFetchedArticles = articlesData.compactMap { Article(from: $0) }
                }
            }

            if let articles = topHeadlinesFetchedArticles {
                self.originalTopHeadlinesArticles.append(contentsOf: articles)
            }

            if let articles = everythingFetchedArticles {
                self.originalEverythingArticles.append(contentsOf: articles)
            }
            updateFilteredArticles()
            isLoadingMore = false
        } catch {
            print("Error loading more articles: \(error.localizedDescription)")
            isLoadingMore = false
        }
    }

}
