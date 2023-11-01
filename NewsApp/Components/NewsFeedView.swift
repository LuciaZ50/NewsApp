import SwiftUI

struct NewsFeedView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                    switch viewModel.selectedTab {
                    case 1:
                        HStack {
                            SearchBar(text: $viewModel.searchTextEverythings)
                                .padding(.horizontal)
                            Button {
                                Task {
                                    await viewModel.sortArticles()
                                }
                            } label: {
                                Text("Sort \(viewModel.sortingBy == .ascending ? "Ascending" : "Descending")")
                                    .foregroundColor(.black)
                                    .bold()
                                    .padding(.all, .standard)
                                    .frame(height: 40)
                            }
                            .background(Color.lighterGray())
                            .cornerRadius(.cell)
                            .padding(.trailing, .standard)
                        }

                        articlesListView(articles: viewModel.everythingArticles, showDate: true)
                    case 0:
                        SearchBar(text: $viewModel.searchTextTopHeadlines)
                            .padding(.horizontal)
                        articlesListView(articles: viewModel.topHeadlinesArticles)

                    default:
                        EmptyView()
                    }
            }

            if viewModel.isLoadingMore {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.vertical)
                    .frame(minHeight: HeightsConstants.progressview.height)
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Text("")
                    Spacer()
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Text("Done")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }
            }
        }
        .navigationBarTitle("News Feed")
    }

    @ViewBuilder
    func articlesListView(articles: [Article], showDate: Bool = false) -> some View {
        List(articles, id: \.id) { article in
            NewsCard(article: article, showDate: showDate)
                .onAppear {
                    if article.id == articles.last?.id {
                        Task {
                            await viewModel.loadMoreArticles()
                        }
                    }
                }
        }
        .listStyle(.plain)
        .refreshable {
            Task {
                if !viewModel.isRefreshing {
                    viewModel.isRefreshing = true
                    await viewModel.refreshData()
                }
            }
        }
    }

}
