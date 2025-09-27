import Fluent
import Vapor

/**
 * TaskController.swift - Contrôleur pour la gestion des tâches
 * 
 * Ce contrôleur implémente toutes les opérations CRUD (Create, Read, Update, Delete)
 * pour les tâches. Il fait le lien entre les routes HTTP et les opérations sur la base de données.
 * 
 * Structure REST standard :
 * - GET /tasks : Lister toutes les tâches
 * - POST /tasks : Créer une nouvelle tâche  
 * - GET /tasks/:id : Récupérer une tâche spécifique
 * - PUT /tasks/:id : Modifier une tâche
 * - DELETE /tasks/:id : Supprimer une tâche
 */

struct TaskController: RouteCollection {
    
    /**
     * Enregistrement des routes
     * 
     * Cette méthode définit toutes les routes gérées par ce contrôleur
     * et les associe aux méthodes correspondantes
     */
    func boot(routes: RoutesBuilder) throws {
        
        // Groupe de routes sous le chemin "/tasks"
        let tasks = routes.grouped("tasks")
        
        // GET /tasks - Lister toutes les tâches
        tasks.get(use: index)
        
        // POST /tasks - Créer une nouvelle tâche
        tasks.post(use: create)
        
        // GET /tasks/:id - Récupérer une tâche par ID
        tasks.get(":taskID", use: show)
        
        // PUT /tasks/:id - Modifier une tâche
        tasks.put(":taskID", use: update)
        
        // DELETE /tasks/:id - Supprimer une tâche
        tasks.delete(":taskID", use: delete)
        
        // GET /tasks/pending - Récupérer uniquement les tâches non terminées
        tasks.get("pending", use: pending)
    }
    
    // MARK: - Opérations CRUD
    
    /**
     * INDEX - Lister toutes les tâches
     * 
     * Route: GET /tasks
     * Retourne toutes les tâches de la base de données au format JSON
     */
    func index(req: Request) async throws -> [Task] {
        // Récupère toutes les tâches depuis la base de données
        // .all() retourne un tableau de tous les enregistrements
        return try await Task.query(on: req.db).all()
    }
    
    /**
     * CREATE - Créer une nouvelle tâche
     * 
     * Route: POST /tasks
     * Corps de la requête: JSON avec les données de la tâche
     * Retourne la tâche créée avec son ID généré
     */
    func create(req: Request) async throws -> Task {
        
        // Validation des données reçues
        try Task.validate(content: req)
        
        // Désérialisation du JSON reçu vers un objet Task
        let task = try req.content.decode(Task.self)
        
        // Sauvegarde en base de données
        // .save() insère la tâche et génère automatiquement l'ID
        try await task.save(on: req.db)
        
        // Retourne la tâche créée (avec l'ID généré)
        return task
    }
    
    /**
     * SHOW - Récupérer une tâche spécifique
     * 
     * Route: GET /tasks/:taskID
     * Paramètre: taskID (UUID de la tâche)
     * Retourne la tâche correspondante ou une erreur 404
     */
    func show(req: Request) async throws -> Task {
        
        // Récupération de la tâche via l'helper findTask
        // Cet helper gère automatiquement les erreurs 404
        return try await findTask(req: req)
    }
    
    /**
     * UPDATE - Modifier une tâche existante
     * 
     * Route: PUT /tasks/:taskID  
     * Paramètre: taskID (UUID de la tâche)
     * Corps: JSON avec les nouvelles données
     * Retourne la tâche modifiée
     */
    func update(req: Request) async throws -> Task {
        
        // Validation des nouvelles données
        try Task.validate(content: req)
        
        // Récupération de la tâche existante
        let task = try await findTask(req: req)
        
        // Désérialisation des nouvelles données
        let updateData = try req.content.decode(Task.self)
        
        // Mise à jour des champs (garde l'ID et les dates existantes)
        task.title = updateData.title
        task.isCompleted = updateData.isCompleted
        
        // Sauvegarde des modifications
        // .save() met à jour l'enregistrement existant et updated_at automatiquement
        try await task.save(on: req.db)
        
        // Retourne la tâche modifiée
        return task
    }
    
    /**
     * DELETE - Supprimer une tâche
     * 
     * Route: DELETE /tasks/:taskID
     * Paramètre: taskID (UUID de la tâche)
     * Retourne un statut HTTP 204 (No Content) en cas de succès
     */
    func delete(req: Request) async throws -> HTTPStatus {
        
        // Récupération de la tâche à supprimer
        let task = try await findTask(req: req)
        
        // Suppression de la base de données
        try await task.delete(on: req.db)
        
        // Retourne le statut HTTP 204 (suppression réussie)
        return .noContent
    }
    
    /**
     * PENDING - Lister les tâches non terminées
     * 
     * Route: GET /tasks/pending
     * Retourne uniquement les tâches où isCompleted = false
     */
    func pending(req: Request) async throws -> [Task] {
        
        // Requête avec filtre sur isCompleted = false
        // .filter() ajoute une clause WHERE à la requête SQL
        return try await Task.query(on: req.db)
            .filter(\.$isCompleted == false)
            .all()
    }
    
    // MARK: - Méthodes utilitaires
    
    /**
     * Helper pour récupérer une tâche par ID
     * 
     * Cette méthode centralise la logique de récupération d'une tâche
     * et gère automatiquement les erreurs 404 si la tâche n'existe pas
     */
    private func findTask(req: Request) async throws -> Task {
        
        // Récupération du paramètre taskID depuis l'URL
        guard let taskID = req.parameters.get("taskID", as: UUID.self) else {
            // Si l'ID n'est pas un UUID valide, retourne une erreur 400
            throw Abort(.badRequest, reason: "ID de tâche invalide")
        }
        
        // Recherche de la tâche par ID
        guard let task = try await Task.find(taskID, on: req.db) else {
            // Si la tâche n'existe pas, retourne une erreur 404
            throw Abort(.notFound, reason: "Tâche non trouvée")
        }
        
        return task
    }
}
