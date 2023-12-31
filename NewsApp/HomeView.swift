import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            switch viewModel.state {
            case .loading:
                ProgressView()
            case .finished:
                VStack {
                    TabView(selection: $viewModel.selectedTab) {
                        NewsFeedView(viewModel: viewModel)
                            .padding(.top, .standard)
                            .tabItem {
                                Image(systemName: "newspaper")
                                Text("Top headlines")
                            }
                            .tag(HomeViewModel.HomeTab.topHeadlines)

                        NewsFeedView(viewModel: viewModel)
                            .padding(.top, .standard)
                            .tabItem {
                                Image(systemName: "newspaper.circle")
                                Text("Everything")
                            }
                            .tag(HomeViewModel.HomeTab.everything)
                    }
                }
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
