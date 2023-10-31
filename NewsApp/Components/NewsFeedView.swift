import SwiftUI

struct NewsFeedView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                SearchBar(text: $viewModel.searchText) { text in
                    print(text)
                }
                .padding(.horizontal)
                ScrollView {

                    switch viewModel.selectedTab {
                    case 1:
                        LazyVStack {
                            ForEach(viewModel.everythingArticles, id: \.id) { article in
                                NewsCard(article: article)
                                    .padding(.horizontal)
                                    .onAppear {
                                        if article.id == viewModel.everythingArticles.last?.id {
                                            Task {
                                                await viewModel.loadMoreArticles()
                                            }
                                        }
                                    }
                            }
                        }
                    default:
                        LazyVStack {
                            ForEach(viewModel.topHeadlinesArticles, id: \.id) { article in
                                NewsCard(article: article)
                                    .padding(.horizontal)
                                    .onAppear {
                                        if article.id == viewModel.topHeadlinesArticles.last?.id {
                                            Task {
                                                await viewModel.loadMoreArticles()
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }

                if viewModel.isLoadingMore {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.vertical)
                        .frame(minHeight: HeightsConstants.progressview.height)
                }
            }
        }
    }
}
