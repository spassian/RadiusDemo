import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Task1View()
                .tabItem {
                    Label("Task 1", systemImage: "1.square.fill")
                }
            
            Task2View()
                .tabItem {
                    Label("Task 2", systemImage: "2.square.fill")
                }
            
            Task3View()
                .tabItem {
                    Label("Task 3", systemImage: "3.square.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
