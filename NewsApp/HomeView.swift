import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            TabView {
                Text("Tab 1 Content")
                    .tabItem {
                        Image(systemName: "1.square.fill")
                        Text("Tab 1")
                    }
                    .tag(0)

                Text("Tab 2 Content")
                    .tabItem {
                        Image(systemName: "2.square.fill")
                        Text("Tab 2")
                    }
                    .tag(1)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
