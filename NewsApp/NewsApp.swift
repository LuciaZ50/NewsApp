import SwiftUI

@main
struct NewsApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView(viewModel: HomeViewModel())
                    .ignoresSafeArea()
            }
        }
    }
}
