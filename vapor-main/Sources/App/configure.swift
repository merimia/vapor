import Vapor
import Fluent
import FluentSQLiteDriver
import Leaf


/**
 * configure.swift - Configuration principale de l'application Vapor
 * 
 * Ce fichier contient toute la configuration de l'application :
 * - Configuration de la base de données
 * - Ajout des migrations
 * - Configuration des middlewares
 * - Enregistrement des routes
 */

// Configure votre application
public func configure(_ app: Application) async throws {
    
    // MARK: - Configuration de la base de données SQLite
    
    /**
     * Configuration de SQLite comme base de données
     * SQLite est idéal pour les projets d'apprentissage car :
     * - Pas besoin d'installation séparée
     * - Base de données stockée dans un fichier local
     * - Parfait pour le développement et les tests
     */
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

    // MARK: - Ajout des migrations
    
    /**
     * Les migrations permettent de créer et modifier la structure de la base de données
     * Elles sont exécutées automatiquement au démarrage de l'application
     */
    app.migrations.add(CreateTask())
    
    // MARK: - Configuration des middlewares
    
    /**
     * Les middlewares sont des composants qui traitent les requêtes HTTP
     * avant qu'elles n'atteignent vos routes
     */
    
    // Middleware pour servir les fichiers statiques depuis le dossier Public/
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // MARK: - Enregistrement des routes
    
    /**
     * Les routes définissent les endpoints de votre API
     * Elles sont organisées dans le fichier routes.swift
     */
    app.views.use(.leaf)

    try routes(app)
}
