import SwiftUI

@main
struct CocktailAppApp: App {
    @StateObject private var favs = FavoritesManager()

    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Accueil", systemImage: "house.fill")
                    }

                ContentView()
                    .tabItem {
                        Label("Recherche", systemImage: "magnifyingglass")
                    }

                FavoritesView()
                    .tabItem {
                        Label("Favoris", systemImage: "heart.fill")
                    }
            }
            .environmentObject(favs)
        }
    }
}
