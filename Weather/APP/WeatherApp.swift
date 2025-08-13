import SwiftUI

@main
struct WeatherApp: App {
    @StateObject private var dep = AppDependency()
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dep)
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var dep: AppDependency
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView {
            MainView(repository: dep.repo)
                .tabItem {
                    Label("Погода", systemImage: "cloud.sun.fill")
                }
            SearchView(repository: dep.repo, appState: appState)
                .tabItem {
                    Label("Поиск", systemImage: "magnifyingglass")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppDependency())
            .environmentObject(AppState())
    }
}
