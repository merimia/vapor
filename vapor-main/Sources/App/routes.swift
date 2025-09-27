import Vapor
import Fluent

// MARK: - Modèles

struct CocktailAPIResponse: Content {
    let drinks: [CocktailItem]
}

struct CocktailItem: Content {
    let strDrink: String
    let strDrinkThumb: String?   // URL de l’image

    let strInstructions: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?

    var ingredients: [String] {
        [strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5].compactMap { $0 }
    }
}


// MARK: - Routes

import Vapor

func routes(_ app: Application) throws {
    app.get("cocktail") { req async throws -> CocktailAPIResponse in
        let name = try req.query.get(String.self, at: "name")
        let url = URI(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(name)")
        let response = try await req.client.get(url)
        
        guard response.status == .ok else {
            throw Abort(.notFound, reason: "Cocktail non trouvé.")
        }
        
        return try response.content.decode(CocktailAPIResponse.self)
    }



    // 🔧 Route JSON alternative (si tu veux garder la version API REST)
    app.get("api", "cocktail") { req async throws -> CocktailAPIResponse in
        let name = try req.query.get(String.self, at: "name")
        let url = URI(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(name)")
        let response = try await req.client.get(url)

        guard response.status == .ok else {
            throw Abort(.notFound, reason: "Cocktail non trouvé.")
        }

        let decoded = try response.content.decode(CocktailAPIResponse.self)
        return decoded
    }

    // 🌐 Page d’accueil
    app.get { req async in
        RootResponse(
            message: "🎯 Bienvenue sur l'API de gestion des cocktails !",
            version: "1.0.0",
            endpoints: [
                "GET /": "Page d'accueil",
                "GET /cocktail?name=margarita": "Affiche une page HTML avec les infos d'un cocktail",
                "GET /api/cocktail?name=margarita": "Retourne les données cocktail au format JSON (ancienne version)",
                "GET /hello": "Message de salutation"
            ]
        )
    }

    // 🧪 Hello world
    app.get("hello") { req async -> String in
        "👋 Salut depuis Vapor ! L'API fonctionne parfaitement."
    }

    // ✅ Health check
    app.get("health") { req async -> HealthResponse in
        HealthResponse(
            status: "healthy",
            timestamp: Date().timeIntervalSince1970,
            version: "1.0.0",
            database: "sqlite"
        )
    }
}

// MARK: - Modèles de réponse

struct RootResponse: Content {
    let message: String
    let version: String
    let endpoints: [String: String]
}

struct HealthResponse: Content {
    let status: String
    let timestamp: Double
    let version: String
    let database: String
}
