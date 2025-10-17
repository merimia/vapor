import Fluent
import Vapor

/**
 * Task.swift - Modèle de données pour les tâches
 * 
 * Ce fichier définit le modèle Task qui représente une tâche dans notre application.
 * Il utilise Fluent (l'ORM de Vapor) pour interagir avec la base de données.
 */

/**
 * Modèle Task
 * 
 * La classe Task hérite de Model, ce qui lui donne toutes les fonctionnalités
 * nécessaires pour interagir avec la base de données via Fluent.
 * 
 * Content permet de sérialiser/désérialiser automatiquement vers/depuis JSON
 */
final class Task: Model, Content, @unchecked Sendable {
    static let schema = "tasks"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "is_completed")
    var isCompleted: Bool

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    @Timestamp(key: "updated_at", on: .update)
    var updatedAt: Date?

    init() { }

    init(id: UUID? = nil, title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}


// MARK: - Extensions pour la validation

/**
 * Extension pour ajouter des validations aux données
 * Cela assure que les données reçues par l'API sont valides
 */
// MARK: - Extensions pour la validation
extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        // Le titre doit avoir entre 1 et 100 caractères
        validations.add("title", as: String.self, is: .count(1...100))
    }
}

