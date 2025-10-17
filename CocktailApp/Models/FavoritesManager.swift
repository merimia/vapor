import Foundation

class FavoritesManager: ObservableObject {
    @Published private(set) var favorites: [Cocktail] = []

    private let key = "favorite_cocktails"

    init() {
        load()
    }

    func isFavorite(_ cocktail: Cocktail) -> Bool {
        favorites.contains { $0.id == cocktail.id }
    }

    func add(_ cocktail: Cocktail) {
        guard !isFavorite(cocktail) else { return }
        favorites.append(cocktail)
        save()
    }

    func remove(_ cocktail: Cocktail) {
        favorites.removeAll { $0.id == cocktail.id }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([Cocktail].self, from: data) {
            favorites = saved
        }
    }
    func toggle(_ cocktail: Cocktail) {
        if isFavorite(cocktail) {
            remove(cocktail)
        } else {
            add(cocktail)
        }
    }

}
extension Cocktail {
    static func == (lhs: Cocktail, rhs: Cocktail) -> Bool {
        lhs.id == rhs.id
    }
}
//
//  FavoritesManager.swift
//  CocktailApp
//
//  Created by admin on 27/09/2025.
//

