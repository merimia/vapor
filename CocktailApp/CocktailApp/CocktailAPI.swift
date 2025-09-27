import Foundation

enum CocktailAPI {
    static let baseURL = "http://localhost:8080" // IP locale ou serveur

    // MARK: - Recherche par nom
    static func searchCocktails(name: String) async throws -> [Cocktail] {
        guard let query = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/cocktail?name=\(query)") else { return [] }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Debug JSON
        let raw = String(data: data, encoding: .utf8)
        print("Réponse brute JSON: \(raw ?? "nil")")

        let response = try JSONDecoder().decode(CocktailResponse.self, from: data)
        return response.drinks ?? []
    }

    // MARK: - Cocktail aléatoire
    static func randomCocktail() async throws -> Cocktail? {
        guard let url = URL(string: "\(baseURL)/cocktails/random") else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        let raw = String(data: data, encoding: .utf8)
        print("Réponse brute JSON (random): \(raw ?? "nil")")

        let response = try JSONDecoder().decode(CocktailResponse.self, from: data)
        return response.drinks?.first
    }
}
