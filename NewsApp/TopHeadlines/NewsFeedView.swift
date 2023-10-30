import SwiftUI

struct NewsFeedView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack {
                ScrollView {

                    switch viewModel.selectedTab {
                    case 1:
                        ForEach(viewModel.everythingArticles, id: \.id) { article in
                            NewsCard(article: article)
                                .padding(.horizontal, .standard)
                        }
                    default:
                        ForEach(viewModel.topHeadlinesArticles, id: \.id) { article in
                            NewsCard(article: article)
                                .padding(.horizontal, .standard)
                        }
                    }
                }
            }
        }
    }
}
