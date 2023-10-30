import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            switch viewModel.state {
            case .loading:
                ForEach(viewModel.redactedData, id: \.id) { article in
                    NewsCard(article: article)
                        .redacted(reason: .placeholder)
                }
            case .finished:
                VStack {
                    TabView(selection: $viewModel.selectedTab) {
                        NewsFeedView(viewModel: viewModel)
                            .padding(.top, .standard)
                            .tabItem {
                                Image(systemName: "newspaper")
                                Text("Top headlines")
                            }
                            .tag(0)

                        NewsFeedView(viewModel: viewModel)
                            .padding(.top, .standard)
                            .tabItem {
                                Image(systemName: "newspaper.circle")
                                Text("Everything")
                            }
                            .tag(1)
                    }
                }
                .padding()
            }
        }
        .navigationTitle(viewModel.tabTitle)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
