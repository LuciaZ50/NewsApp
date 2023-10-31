import SwiftUI

struct NewsFeedView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                HStack {
                    SearchBar(text: $viewModel.searchText)
                        .padding(.horizontal)
                    if viewModel.selectedTab == 1 {
                        Button {
                            Task {
                                await viewModel.sortArticles()
                            }
                        } label: {
                            Text("Sort")
                                .foregroundColor(.black)
                                .bold()
                                .padding(.all, .standard)
                                .frame(height: 40)
                        }
                        .background(Color.lighterGray())
                        .cornerRadius(.cell)
                        .padding(.trailing, .standard)

                    }

                }

                    switch viewModel.selectedTab {
                    case 1:
                        List(viewModel.everythingArticles, id: \.id ) { article in
                            NewsCard(article: article, showDate: true)
                                .onAppear {
                                    if article.id == viewModel.everythingArticles.last?.id {
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

                    default:
                        List(viewModel.topHeadlinesArticles, id: \.id ) { article in
                            NewsCard(article: article)
                                .onAppear {
                                    if article.id == viewModel.topHeadlinesArticles.last?.id {
                                        Task {
                                            await viewModel.loadMoreArticles()
                                        }
                                    }
                                }
                        }
                        .listStyle(.plain)
                        .refreshable {
                            if !viewModel.isRefreshing {
                                viewModel.isRefreshing = true
                                await viewModel.refreshData()
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
}
