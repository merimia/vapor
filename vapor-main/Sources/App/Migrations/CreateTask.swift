import Fluent

/**
 * CreateTask.swift - Migration pour créer la table des tâches
 * 
 * Les migrations permettent de créer, modifier ou supprimer des tables dans la base de données.
 * Cette migration crée la table "tasks" avec tous les champs nécessaires.
 * 
 * Avantages des migrations :
 * - Versioning de la base de données
 * - Synchronisation entre différents environnements
 * - Historique des changements de structure
 */

struct CreateTask: AsyncMigration {
    
    /**
     * Méthode prepare - Exécutée lors de l'application de la migration
     * 
     * Cette méthode crée la table "tasks" avec tous ses champs et contraintes
     * 
     * @param database: Instance de la base de données
     */
    func prepare(on database: Database) async throws {
        try await database.schema("tasks")
            
            // MARK: - Définition des colonnes
            
            /**
             * Colonne ID - Clé primaire
             * .id() crée automatiquement une colonne UUID avec auto-génération
             */
            .id()
            
            /**
             * Colonne title - Titre de la tâche
             * - Type: String (VARCHAR en SQL)
             * - Contrainte: NOT NULL (requis)
             */
            .field("title", .string, .required)
            
            /**
             * Colonne is_completed - Statut de completion
             * - Type: Bool (BOOLEAN en SQL)
             * - Contrainte: NOT NULL avec valeur par défaut false
             */
            .field("is_completed", .bool, .required, .sql(.default(false)))
            
            /**
             * Colonne created_at - Date de création
             * - Type: Date (DATETIME en SQL)
             * - Contrainte: NOT NULL (Fluent la remplit automatiquement)
             */
            .field("created_at", .datetime, .required)
            
            /**
             * Colonne updated_at - Date de dernière modification  
             * - Type: Date (DATETIME en SQL)
             * - Contrainte: NOT NULL (Fluent la met à jour automatiquement)
             */
            .field("updated_at", .datetime, .required)
            
            // MARK: - Création de la table
            
            /**
             * .create() exécute la création de la table avec tous les champs définis
             * Cette opération est idempotente (peut être exécutée plusieurs fois sans erreur)
             */
            .create()
    }
    
    /**
     * Méthode revert - Exécutée lors de l'annulation de la migration
     * 
     * Cette méthode supprime la table "tasks" pour revenir à l'état précédent
     * Utile pour les tests ou pour annuler des changements de structure
     * 
     * @param database: Instance de la base de données
     */
    func revert(on database: Database) async throws {
        // Supprime complètement la table "tasks"
        try await database.schema("tasks").delete()
    }
}
