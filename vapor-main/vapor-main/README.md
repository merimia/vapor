# 📘 Développement d'une API REST avec Swift & Vapor

Bienvenue dans ce cours pratique sur le développement d'une API REST avec Swift et Vapor ! Ce projet vous guide pas à pas dans la création d'une API de gestion de tâches complète.

## 🎯 Objectifs pédagogiques

À la fin de ce cours, vous saurez :

- ✅ Comprendre les bases de Swift côté serveur
- ✅ Découvrir le framework Vapor et son écosystème
- ✅ Développer une API REST complète avec opérations CRUD
- ✅ Structurer correctement un projet Vapor (routes, contrôleurs, modèles, migrations)
- ✅ Manipuler une base de données SQLite avec Fluent ORM
- ✅ Tester une API avec des outils comme curl ou Postman
- ✅ Comprendre les concepts de validation de données et gestion d'erreurs

---

## 🛠️ Partie 1 : Installation et configuration

### Prérequis

Avant de commencer, assurez-vous d'avoir :

- **Swift 5.9+** installé sur votre système
- **Xcode** (sur macOS) ou **Swift for Windows/Linux**
- Un éditeur de code (VS Code, Xcode, etc.)
- **Git** pour la gestion de version

### Installation de Swift

#### Sur macOS :
```bash
# Swift est inclus avec Xcode
xcode-select --install

# Vérifiez l'installation
swift --version
```

#### Sur Windows :
1. Téléchargez Swift depuis [swift.org](https://swift.org/download/)
2. Suivez les instructions d'installation
3. Vérifiez avec `swift --version`

#### Sur Linux (Ubuntu) :
```bash
# Installation des dépendances
sudo apt-get update
sudo apt-get install clang libicu-dev

# Téléchargement et installation de Swift
wget https://swift.org/builds/swift-5.9-release/ubuntu2004/swift-5.9-RELEASE/swift-5.9-RELEASE-ubuntu20.04.tar.gz
tar xzf swift-5.9-RELEASE-ubuntu20.04.tar.gz
sudo mv swift-5.9-RELEASE-ubuntu20.04 /opt/swift
echo 'export PATH=/opt/swift/usr/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Installation de Vapor Toolbox (Optionnel)

Vapor Toolbox facilite la création de nouveaux projets :

```bash
# Installation via Homebrew (macOS)
brew install vapor

# Ou installation manuelle
git clone https://github.com/vapor/toolbox.git
cd toolbox
swift build -c release
sudo mv .build/release/vapor /usr/local/bin
```

### Création du projet
 
Notre projet est déjà configuré ! Voici comment il a été structuré :

1. **Package.swift** : Configuration des dépendances
2. **Sources/App/** : Code source principal
3. **Base de données** : SQLite configurée automatiquement

### Premier lancement

Dans le terminal, naviguez vers le dossier du projet et lancez :

```bash
# Compilation du projet
swift build

# Lancement du serveur
swift run

# Alternative avec Vapor Toolbox
vapor run
```

Le serveur démarre sur `http://localhost:8080`

### 💡 Exercice 1 : Vérification de l'installation

1. Lancez le serveur avec `swift run`
2. Ouvrez votre navigateur et allez sur `http://localhost:8080`
3. Vous devriez voir un message de bienvenue JSON
4. Testez aussi `http://localhost:8080/hello`
5. Arrêtez le serveur avec `Ctrl+C`

**Résultat attendu :**
```json
{
  "message": "🎯 Bienvenue sur l'API de gestion des tâches !",
  "version": "1.0.0",
  "endpoints": {
    // ... liste des endpoints disponibles
  }
}
```

---

## 📂 Partie 2 : Structure d'un projet Vapor

### Architecture générale

```
TaskAPI/
├── Package.swift                 # Configuration des dépendances
├── Sources/
│   └── App/
│       ├── main.swift           # Point d'entrée de l'application
│       ├── configure.swift      # Configuration (DB, middlewares, routes)
│       ├── routes.swift         # Définition des routes principales
│       ├── Controllers/         # Logique métier
│       │   └── TaskController.swift
│       ├── Models/              # Modèles de données
│       │   └── Task.swift
│       └── Migrations/          # Scripts de création/modification de la DB
│           └── CreateTask.swift
├── Tests/                       # Tests unitaires et d'intégration
├── Public/                      # Fichiers statiques (CSS, JS, images)
└── db.sqlite                   # Base de données SQLite (créée automatiquement)
```

### Détail des composants

#### 📄 **Package.swift**
- Définit les dépendances du projet (Vapor, Fluent, etc.)
- Configure les targets de compilation
- Spécifie les versions minimales requises

#### 🚀 **main.swift**
- Point d'entrée de l'application
- Initialise l'environnement Vapor
- Démarre le serveur HTTP

#### ⚙️ **configure.swift**
- Configuration centrale de l'application
- Configuration de la base de données
- Enregistrement des migrations
- Configuration des middlewares

#### 🛣️ **routes.swift**
- Définition des routes HTTP
- Enregistrement des contrôleurs
- Routes de démonstration et de santé

#### 🎮 **Controllers/**
- Contient la logique métier
- Traite les requêtes HTTP
- Interagit avec les modèles

#### 🗃️ **Models/**
- Définit la structure des données
- Gère l'interaction avec la base de données
- Contient les règles de validation

#### 📊 **Migrations/**
- Scripts de création/modification des tables
- Versioning de la structure de données
- Permet la synchronisation entre environnements

### 💡 Exercice 2 : Exploration de la structure

1. Ouvrez le fichier `Sources/App/routes.swift`
2. Identifiez où sont définies les routes par défaut
3. Trouvez la route qui gère `GET /hello`
4. Regardez comment la route d'accueil retourne du JSON
5. Explorez le fichier `configure.swift` pour comprendre la configuration

**Questions à vous poser :**
- Comment Vapor sait-il quelle fonction appeler pour chaque route ?
- Où est configurée la base de données SQLite ?
- Comment les migrations sont-elles enregistrées ?

---

## 🔗 Partie 3 : Création du modèle Task

### Comprendre Fluent ORM

**Fluent** est l'ORM (Object-Relational Mapping) de Vapor qui permet de :
- Définir des modèles de données en Swift
- Générer automatiquement les requêtes SQL
- Gérer les relations entre tables
- Valider les données

### Anatomie du modèle Task

Notre modèle `Task` se trouve dans `Sources/App/Models/Task.swift` :

```swift
final class Task: Model, Content {
    static let schema = "tasks"  // Nom de la table
    
    @ID(key: .id)               // Clé primaire UUID
    var id: UUID?
    
    @Field(key: "title")        // Champ titre
    var title: String
    
    @Field(key: "is_completed") // Statut de completion
    var isCompleted: Bool
    
    @Timestamp(key: "created_at", on: .create)  // Date de création
    var createdAt: Date?
    
    @Timestamp(key: "updated_at", on: .update)  // Date de modification
    var updatedAt: Date?
}
```

### Les annotations Fluent

#### `@ID`
- Définit la clé primaire de la table
- Génère automatiquement un UUID unique
- Peut être personnalisée avec d'autres types

#### `@Field`
- Représente une colonne normale de la table
- Le paramètre `key` définit le nom de la colonne
- Type automatiquement inféré depuis la propriété Swift

#### `@Timestamp`
- Gère automatiquement les dates de création/modification
- `.create` : mis à jour seulement lors de la création
- `.update` : mis à jour à chaque modification

### Migration associée

La migration `CreateTask` dans `Sources/App/Migrations/CreateTask.swift` crée la table :

```swift
func prepare(on database: Database) async throws {
    try await database.schema("tasks")
        .id()                                           // UUID primary key
        .field("title", .string, .required)            // VARCHAR NOT NULL
        .field("is_completed", .bool, .required,        // BOOLEAN NOT NULL DEFAULT false
               .sql(.default(false)))
        .field("created_at", .datetime, .required)      // DATETIME NOT NULL
        .field("updated_at", .datetime, .required)      // DATETIME NOT NULL
        .create()
}
```

### Validation des données

Le modèle inclut des règles de validation :

```swift
extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("title", as: String.self, is: !.empty)      // Titre requis
        validations.add("title", as: String.self, is: .count(1...100))  // 1-100 caractères
    }
}
```

### 💡 Exercice 3 : Extension du modèle

Ajoutez un champ `priority` à votre modèle Task :

1. **Créez un enum pour les priorités :**
   ```swift
   enum TaskPriority: String, Codable, CaseIterable {
       case low = "low"
       case medium = "medium"  
       case high = "high"
   }
   ```

2. **Ajoutez le champ dans Task.swift :**
   ```swift
   @Field(key: "priority")
   var priority: TaskPriority
   ```

3. **Modifiez le constructeur :**
   ```swift
   init(id: UUID? = nil, title: String, isCompleted: Bool = false, priority: TaskPriority = .medium) {
       self.id = id
       self.title = title
       self.isCompleted = isCompleted
       self.priority = priority
   }
   ```

4. **Créez une nouvelle migration :**
   ```swift
   struct AddPriorityToTask: AsyncMigration {
       func prepare(on database: Database) async throws {
           try await database.schema("tasks")
               .field("priority", .string, .required, .sql(.default("medium")))
               .update()
       }
       
       func revert(on database: Database) async throws {
           try await database.schema("tasks")
               .deleteField("priority")
               .update()
       }
   }
   ```

5. **Enregistrez la migration dans configure.swift**

**Défi supplémentaire :** Ajoutez une route `GET /tasks/priority/:level` qui filtre par priorité.

---

## 🧑‍💻 Partie 4 : Création du contrôleur TaskController

### Architecture MVC avec Vapor

Vapor suit le pattern **MVC** (Model-View-Controller) :

- **Model** : `Task.swift` - Structure des données
- **View** : Réponses JSON (pas de templates HTML ici)
- **Controller** : `TaskController.swift` - Logique métier

### Rôle du contrôleur

Le `TaskController` :
- Reçoit les requêtes HTTP depuis les routes
- Valide les données d'entrée
- Effectue les opérations sur la base de données
- Retourne les réponses au format JSON
- Gère les erreurs

### Les opérations CRUD

#### **CREATE - Créer une tâche**

```swift
func create(req: Request) async throws -> Task {
    // 1. Validation des données
    try Task.validate(content: req)
    
    // 2. Désérialisation JSON -> Objet Task
    let task = try req.content.decode(Task.self)
    
    // 3. Sauvegarde en base
    try await task.save(on: req.db)
    
    // 4. Retour de la tâche avec ID généré
    return task
}
```

**Exemple d'utilisation :**
```bash
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Apprendre Vapor", "isCompleted": false}'
```

#### **READ - Lire les tâches**

```swift
// Toutes les tâches
func index(req: Request) async throws -> [Task] {
    return try await Task.query(on: req.db).all()
}

// Une tâche spécifique
func show(req: Request) async throws -> Task {
    return try await findTask(req: req)
}

// Tâches non terminées seulement
func pending(req: Request) async throws -> [Task] {
    return try await Task.query(on: req.db)
        .filter(\.$isCompleted == false)
        .all()
}
```

#### **UPDATE - Modifier une tâche**

```swift
func update(req: Request) async throws -> Task {
    // 1. Validation
    try Task.validate(content: req)
    
    // 2. Récupération de la tâche existante
    let task = try await findTask(req: req)
    
    // 3. Mise à jour des champs
    let updateData = try req.content.decode(Task.self)
    task.title = updateData.title
    task.isCompleted = updateData.isCompleted
    
    // 4. Sauvegarde
    try await task.save(on: req.db)
    
    return task
}
```

#### **DELETE - Supprimer une tâche**

```swift
func delete(req: Request) async throws -> HTTPStatus {
    let task = try await findTask(req: req)
    try await task.delete(on: req.db)
    return .noContent  // HTTP 204
}
```

### Gestion des erreurs

```swift
private func findTask(req: Request) async throws -> Task {
    guard let taskID = req.parameters.get("taskID", as: UUID.self) else {
        throw Abort(.badRequest, reason: "ID de tâche invalide")
    }
    
    guard let task = try await Task.find(taskID, on: req.db) else {
        throw Abort(.notFound, reason: "Tâche non trouvée")
    }
    
    return task
}
```

### Enregistrement des routes

```swift
func boot(routes: RoutesBuilder) throws {
    let tasks = routes.grouped("tasks")
    
    tasks.get(use: index)              // GET /tasks
    tasks.post(use: create)            // POST /tasks
    tasks.get(":taskID", use: show)    // GET /tasks/:id
    tasks.put(":taskID", use: update)  // PUT /tasks/:id
    tasks.delete(":taskID", use: delete) // DELETE /tasks/:id
    tasks.get("pending", use: pending)   // GET /tasks/pending
}
```

### 💡 Exercice 4 : Fonctionnalités avancées

Implémentez ces nouvelles fonctionnalités dans le contrôleur :

1. **Route pour les tâches terminées :**
   ```swift
   // GET /tasks/completed
   func completed(req: Request) async throws -> [Task] {
       return try await Task.query(on: req.db)
           .filter(\.$isCompleted == true)
           .all()
   }
   ```

2. **Route de recherche par titre :**
   ```swift
   // GET /tasks/search?q=terme
   func search(req: Request) async throws -> [Task] {
       guard let searchTerm = req.query[String.self, at: "q"] else {
           throw Abort(.badRequest, reason: "Paramètre 'q' manquant")
       }
       
       return try await Task.query(on: req.db)
           .filter(\.$title ~~ searchTerm)  // LIKE en SQL
           .all()
   }
   ```

3. **Route de statistiques :**
   ```swift
   // GET /tasks/stats
   func stats(req: Request) async throws -> [String: Any] {
       let total = try await Task.query(on: req.db).count()
       let completed = try await Task.query(on: req.db)
           .filter(\.$isCompleted == true)
           .count()
       
       return [
           "total": total,
           "completed": completed,
           "pending": total - completed,
           "completion_rate": total > 0 ? Double(completed) / Double(total) * 100 : 0
       ]
   }
   ```

4. **N'oubliez pas d'enregistrer ces nouvelles routes !**

---

## 🌐 Partie 5 : Test de l'API

### Démarrage du serveur

```bash
# Dans le dossier du projet
swift run

# Le serveur démarre sur http://localhost:8080
```

### Test avec curl

#### 1. Vérifier que l'API fonctionne
```bash
curl http://localhost:8080/
curl http://localhost:8080/hello
curl http://localhost:8080/health
```

#### 2. Créer des tâches
```bash
# Créer une première tâche
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Apprendre Vapor", "isCompleted": false}'

# Créer une deuxième tâche
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Créer une API REST", "isCompleted": true}'

# Créer une tâche avec des données invalides (pour tester la validation)
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "", "isCompleted": false}'
```

#### 3. Lire les tâches
```bash
# Toutes les tâches
curl http://localhost:8080/tasks

# Tâches non terminées
curl http://localhost:8080/tasks/pending

# Une tâche spécifique (remplacez UUID par un vrai ID)
curl http://localhost:8080/tasks/UUID-DE-LA-TACHE
```

#### 4. Modifier une tâche
```bash
# Marquer une tâche comme terminée
curl -X PUT http://localhost:8080/tasks/UUID-DE-LA-TACHE \
  -H "Content-Type: application/json" \
  -d '{"title": "Apprendre Vapor - FAIT !", "isCompleted": true}'
```

#### 5. Supprimer une tâche
```bash
curl -X DELETE http://localhost:8080/tasks/UUID-DE-LA-TACHE
```

### Test avec Postman

#### Configuration de base
1. **Téléchargez et installez Postman**
2. **Créez une nouvelle collection** "Task API"
3. **URL de base :** `http://localhost:8080`

#### Requêtes à créer

1. **GET /** - Page d'accueil
   - Méthode: GET
   - URL: `{{base_url}}/`

2. **POST /tasks** - Créer une tâche
   - Méthode: POST
   - URL: `{{base_url}}/tasks`
   - Headers: `Content-Type: application/json`
   - Body (raw JSON):
     ```json
     {
       "title": "Ma nouvelle tâche",
       "isCompleted": false
     }
     ```

3. **GET /tasks** - Lister les tâches
   - Méthode: GET
   - URL: `{{base_url}}/tasks`

4. **GET /tasks/:id** - Récupérer une tâche
   - Méthode: GET
   - URL: `{{base_url}}/tasks/{{task_id}}`

5. **PUT /tasks/:id** - Modifier une tâche
   - Méthode: PUT
   - URL: `{{base_url}}/tasks/{{task_id}}`
   - Headers: `Content-Type: application/json`
   - Body (raw JSON):
     ```json
     {
       "title": "Tâche modifiée",
       "isCompleted": true
     }
     ```

6. **DELETE /tasks/:id** - Supprimer une tâche
   - Méthode: DELETE
   - URL: `{{base_url}}/tasks/{{task_id}}`

#### Variables d'environnement Postman
```json
{
  "base_url": "http://localhost:8080",
  "task_id": "récupéré-depuis-une-réponse-précédente"
}
```

### Réponses attendues

#### Succès - Création d'une tâche
```json
{
  "id": "12345678-1234-1234-1234-123456789abc",
  "title": "Ma nouvelle tâche",
  "isCompleted": false,
  "createdAt": "2025-09-08T10:30:00Z",
  "updatedAt": "2025-09-08T10:30:00Z"
}
```

#### Succès - Liste des tâches
```json
[
  {
    "id": "12345678-1234-1234-1234-123456789abc",
    "title": "Première tâche",
    "isCompleted": false,
    "createdAt": "2025-09-08T10:30:00Z",
    "updatedAt": "2025-09-08T10:30:00Z"
  },
  {
    "id": "87654321-4321-4321-4321-cba987654321",
    "title": "Deuxième tâche",
    "isCompleted": true,
    "createdAt": "2025-09-08T10:35:00Z",
    "updatedAt": "2025-09-08T10:40:00Z"
  }
]
```

#### Erreur - Tâche non trouvée
```json
{
  "error": true,
  "reason": "Tâche non trouvée"
}
```

#### Erreur - Données invalides
```json
{
  "error": true,
  "reason": "title is required"
}
```

### 💡 Exercice 5 : Tests complets

Réalisez ces tests et documentez les résultats :

1. **Test du cycle CRUD complet :**
   - Créez 3 tâches différentes
   - Listez toutes les tâches
   - Modifiez une tâche pour la marquer comme terminée
   - Supprimez une tâche
   - Vérifiez que les changements sont persistés

2. **Test des cas d'erreur :**
   - Tentez de créer une tâche sans titre
   - Tentez de récupérer une tâche avec un ID invalide
   - Tentez de modifier une tâche inexistante

3. **Test des fonctionnalités avancées :**
   - Testez la route `/tasks/pending`
   - Si vous avez implémenté les exercices précédents, testez-les

4. **Test de charge basique :**
   - Créez 10 tâches rapidement
   - Vérifiez que l'API reste responsive

**Capturez vos résultats dans un document avec :**
- Screenshots des requêtes Postman
- Réponses JSON reçues
- Codes de statut HTTP observés
- Temps de réponse

---

## 🚀 Partie 6 : Aller plus loin

### Validation avancée des données

#### Validation personnalisée
```swift
extension Task: Validatable {
    static func validations(_ validations: inout Validations) {
        // Titre requis, 1-100 caractères
        validations.add("title", as: String.self, is: !.empty && .count(1...100))
        
        // Validation personnalisée pour les mots interdits
        validations.add("title", as: String.self) { title in
            let forbiddenWords = ["spam", "test123"]
            return ValidatorResults.Lazy {
                forbiddenWords.allSatisfy { !title.lowercased().contains($0) }
            }
        }
    }
}
```

#### Middleware de validation
```swift
struct TaskValidationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Validation personnalisée avant traitement
        if request.method == .POST && request.url.path.contains("/tasks") {
            let task = try request.content.decode(Task.self)
            
            // Règles métier personnalisées
            if task.title.count > 100 {
                throw Abort(.badRequest, reason: "Le titre ne peut pas dépasser 100 caractères")
            }
        }
        
        return try await next.respond(to: request)
    }
}
```

### Gestion avancée des erreurs

#### Middleware d'erreur personnalisé
```swift
struct ErrorMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch {
            return try await handleError(error, for: request)
        }
    }
    
    private func handleError(_ error: Error, for request: Request) async throws -> Response {
        let status: HTTPResponseStatus
        let message: String
        
        switch error {
        case let abort as AbortError:
            status = abort.status
            message = abort.reason
        case let validation as ValidationsError:
            status = .badRequest
            message = "Erreurs de validation: \(validation.description)"
        default:
            status = .internalServerError
            message = "Erreur interne du serveur"
        }
        
        let errorResponse = ErrorResponse(
            error: true,
            message: message,
            timestamp: Date()
        )
        
        return try await errorResponse.encodeResponse(status: status, for: request)
    }
}

struct ErrorResponse: Content {
    let error: Bool
    let message: String
    let timestamp: Date
}
```

### Pagination

```swift
extension TaskController {
    func indexPaginated(req: Request) async throws -> Page<Task> {
        return try await Task.query(on: req.db)
            .paginate(for: req)
    }
}

// Dans routes.swift
tasks.get("paginated", use: taskController.indexPaginated)
```

### Filtrage et tri

```swift
func indexFiltered(req: Request) async throws -> [Task] {
    var query = Task.query(on: req.db)
    
    // Filtrage par statut
    if let completed = req.query[Bool.self, at: "completed"] {
        query = query.filter(\.$isCompleted == completed)
    }
    
    // Recherche dans le titre
    if let search = req.query[String.self, at: "search"] {
        query = query.filter(\.$title ~~ search)
    }
    
    // Tri
    let sortBy = req.query[String.self, at: "sortBy"] ?? "createdAt"
    let sortDirection = req.query[String.self, at: "sortDirection"] ?? "desc"
    
    switch sortBy {
    case "title":
        query = sortDirection == "asc" ? 
            query.sort(\.$title, .ascending) : 
            query.sort(\.$title, .descending)
    case "createdAt":
        query = sortDirection == "asc" ? 
            query.sort(\.$createdAt, .ascending) : 
            query.sort(\.$createdAt, .descending)
    default:
        query = query.sort(\.$createdAt, .descending)
    }
    
    return try await query.all()
}
```

### Authentification basique

#### Modèle User
```swift
final class User: Model, Content {
    static let schema = "users"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "username")
    var username: String
    
    @Field(key: "password_hash")
    var passwordHash: String
    
    init() { }
    
    init(id: UUID? = nil, username: String, passwordHash: String) {
        self.id = id
        self.username = username
        self.passwordHash = passwordHash
    }
}
```

#### Middleware d'authentification
```swift
struct AuthenticationMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: AsyncResponder) async throws -> Response {
        // Vérification du token Bearer
        guard let token = request.headers.bearerAuthorization?.token else {
            throw Abort(.unauthorized, reason: "Token manquant")
        }
        
        // Validation du token (simplifié)
        guard token == "secret-token" else {
            throw Abort(.unauthorized, reason: "Token invalide")
        }
        
        return try await next.respond(to: request)
    }
}
```

### Migration vers PostgreSQL

#### 1. Modifier Package.swift
```swift
.package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0")
```

#### 2. Modifier configure.swift
```swift
import FluentPostgresDriver

// Configuration PostgreSQL
app.databases.use(.postgres(
    hostname: Environment.get("DATABASE_HOST") ?? "localhost",
    port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
    username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
    password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
    database: Environment.get("DATABASE_NAME") ?? "vapor_database"
), as: .psql)
```

#### 3. Variables d'environnement
```bash
# .env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=password
DATABASE_NAME=tasks_db
```

### Tests unitaires

```swift
// Tests/AppTests/TaskTests.swift
@testable import App
import XCTVapor

final class TaskTests: XCTestCase {
    var app: Application!
    
    override func setUp() async throws {
        app = Application(.testing)
        try await configure(app)
        try await app.autoMigrate()
    }
    
    override func tearDown() async throws {
        try await app.autoRevert()
        app.shutdown()
    }
    
    func testCreateTask() async throws {
        try await app.test(.POST, "/tasks") { req in
            req.headers.contentType = .json
            try req.content.encode(["title": "Test Task", "isCompleted": false])
        } afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let task = try res.content.decode(Task.self)
            XCTAssertEqual(task.title, "Test Task")
            XCTAssertFalse(task.isCompleted)
        }
    }
    
    func testGetTasks() async throws {
        // Créer une tâche de test
        let task = Task(title: "Test Task")
        try await task.save(on: app.db)
        
        try await app.test(.GET, "/tasks") { req in
        } afterResponse: { res in
            XCTAssertEqual(res.status, .ok)
            let tasks = try res.content.decode([Task].self)
            XCTAssertEqual(tasks.count, 1)
            XCTAssertEqual(tasks[0].title, "Test Task")
        }
    }
}
```

### Logging et monitoring

```swift
// Configuration des logs
app.logger.logLevel = .debug

// Log personnalisé dans le contrôleur
func create(req: Request) async throws -> Task {
    req.logger.info("Création d'une nouvelle tâche")
    
    let task = try req.content.decode(Task.self)
    try await task.save(on: req.db)
    
    req.logger.info("Tâche créée avec ID: \(task.id?.uuidString ?? "unknown")")
    
    return task
}
```

### 💡 Exercices avancés

1. **Système de priorités complet :**
   - Ajoutez un enum `TaskPriority` avec les valeurs low, medium, high
   - Créez une route de filtrage par priorité
   - Implémentez un tri par priorité

2. **API de statistiques :**
   - Route pour les statistiques globales
   - Route pour les statistiques par période (jour, semaine, mois)
   - Graphique de productivité

3. **Gestion des catégories :**
   - Créez un modèle `Category`
   - Ajoutez une relation entre Task et Category
   - Implémentez les opérations CRUD pour les catégories

4. **API de recherche avancée :**
   - Recherche full-text dans les titres
   - Filtres combinés (statut + priorité + catégorie)
   - Tri multi-critères

5. **Authentification JWT :**
   - Implémentez un système d'inscription/connexion
   - Générez des tokens JWT
   - Protégez les routes avec des middlewares

---

## 📚 Conclusion

### Ce que vous avez appris

🎯 **Swift côté serveur**
- Syntaxe Swift appliquée au développement backend
- Gestion asynchrone avec async/await
- Programmation orientée objet et protocoles

🏗️ **Architecture d'un projet Vapor**
- Structure MVC (Model-View-Controller)
- Séparation des responsabilités
- Organisation du code en modules

🌐 **API REST avec Vapor**
- Création de routes HTTP (GET, POST, PUT, DELETE)
- Sérialisation/désérialisation JSON automatique
- Gestion des paramètres et du corps des requêtes
- Codes de statut HTTP appropriés

🗄️ **Gestion de données avec Fluent & SQLite**
- Modélisation de données avec les annotations Fluent
- Migrations pour la gestion de schémas
- Opérations CRUD asynchrones
- Requêtes avancées avec filtres et tri

✅ **Validation et gestion d'erreurs**
- Validation automatique des données d'entrée
- Gestion centralisée des erreurs
- Messages d'erreur informatifs

🔧 **Outils de développement**
- Tests avec curl et Postman
- Debugging et logging
- Structure de projet professionnelle

### Compétences acquises

Après ce cours, vous êtes capables de :

- ✅ Créer une API REST complète en Swift avec Vapor
- ✅ Structurer un projet backend de manière professionnelle
- ✅ Gérer une base de données avec un ORM moderne
- ✅ Valider et sécuriser les données d'entrée
- ✅ Tester une API avec des outils appropriés
- ✅ Déboguer et maintenir une application Vapor

### Prochaines étapes

Pour continuer votre apprentissage :

1. **Approfondissement Vapor :**
   - Templates avec Leaf
   - WebSockets temps réel
   - Déploiement en production

2. **Sécurité :**
   - Authentification JWT
   - Chiffrement des mots de passe
   - Protection CSRF et CORS

3. **Performance :**
   - Cache avec Redis
   - Optimisation des requêtes
   - Load balancing

4. **DevOps :**
   - Containerisation avec Docker
   - CI/CD avec GitHub Actions
   - Déploiement cloud (AWS, Google Cloud, etc.)

### Ressources supplémentaires

📖 **Documentation officielle :**
- [Vapor Documentation](https://docs.vapor.codes/)
- [Swift.org](https://swift.org/documentation/)
- [Fluent Documentation](https://docs.vapor.codes/fluent/overview/)

🎓 **Communauté :**
- [Discord Vapor](https://discord.gg/vapor)
- [Stack Overflow - vapor](https://stackoverflow.com/questions/tagged/vapor)
- [GitHub Vapor](https://github.com/vapor/vapor)

📺 **Tutoriels vidéo :**
- [Vapor University](https://vapor.university/)
- [iOS Dev Weekly](https://iosdevweekly.com/)

### Félicitations ! 🎉

Vous avez maintenant les bases solides pour développer des APIs modernes avec Swift et Vapor. Ce projet peut servir de fondation pour des applications plus complexes.

N'hésitez pas à expérimenter, modifier le code, et créer vos propres fonctionnalités. La programmation s'apprend par la pratique !

**Bonne continuation dans votre parcours de développement Swift côté serveur !** 🚀
