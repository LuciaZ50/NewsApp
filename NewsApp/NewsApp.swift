import SwiftUI

@main
struct NewsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView(viewModel: HomeViewModel())
                    .ignoresSafeArea()
            }
        }
    }
}
