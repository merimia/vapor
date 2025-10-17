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
struct SignupRequest: Content {
    let username: String
    let password: String
}
struct SignupResponse: Content {
    let id: UUID
    let username: String
}

struct LoginRequest: Content {
    let username: String
    let password: String
}

struct LoginResponse: Content {
    let id: UUID
    let username: String
}


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

    // Page d’accueil
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


    app.get("health") { req async -> HealthResponse in
        HealthResponse(
            status: "healthy",
            timestamp: Date().timeIntervalSince1970,
            version: "1.0.0",
            database: "sqlite"
        )
    }
    app.post("users", "signup") { req async throws -> SignupResponse in
        let signup = try req.content.decode(SignupRequest.self)

        let passwordHash = try Bcrypt.hash(signup.password)
        let user = User(username: signup.username, passwordHash: passwordHash)

        try await user.save(on: req.db)

        guard let id = user.id else {
            throw Abort(.internalServerError, reason: "User ID missing")
        }
        return SignupResponse(id: id, username: user.username)
    }


    app.post("users", "login") { req async throws -> LoginResponse in
        let login = try req.content.decode(LoginRequest.self)

        // Cherche l'utilisateur par username
        guard let user = try await User.query(on: req.db)
            .filter(\User.$username == login.username)
            .first() else {
            throw Abort(.unauthorized, reason: "Nom d'utilisateur ou mot de passe incorrect")
        }

        // Vérifie le mot de passe hashé avec Bcrypt
        let verified = try Bcrypt.verify(login.password, created: user.passwordHash)
        guard verified else {
            throw Abort(.unauthorized, reason: "Nom d'utilisateur ou mot de passe incorrect")
        }

        // Retourne un LoginResponse (tu peux ajouter un token JWT ici si tu veux)
        return LoginResponse(id: try user.requireID(), username: user.username)
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
