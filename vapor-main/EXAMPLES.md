# 🎯 API de Gestion des Tâches - Exemples d'utilisation

Ce fichier contient des exemples pratiques d'utilisation de l'API de gestion des tâches.

## 📋 Collection Postman

### Variables d'environnement

Créez ces variables dans Postman :

```json
{
  "base_url": "http://localhost:8080",
  "task_id": ""
}
```

### 1. Page d'accueil

**GET** `{{base_url}}/`

Réponse attendue :
```json
{
  "message": "🎯 Bienvenue sur l'API de gestion des tâches !",
  "version": "1.0.0",
  "endpoints": {
    "GET /": "Page d'accueil",
    "GET /hello": "Message de salutation",
    "GET /tasks": "Lister toutes les tâches",
    "POST /tasks": "Créer une nouvelle tâche",
    "GET /tasks/:id": "Récupérer une tâche",
    "PUT /tasks/:id": "Modifier une tâche",
    "DELETE /tasks/:id": "Supprimer une tâche",
    "GET /tasks/pending": "Tâches non terminées"
  }
}
```

### 2. Créer une tâche

**POST** `{{base_url}}/tasks`

Headers:
- `Content-Type: application/json`

Body (raw JSON):
```json
{
  "title": "Apprendre Swift avec Vapor",
  "isCompleted": false
}
```

Réponse :
```json
{
  "id": "12345678-1234-1234-1234-123456789abc",
  "title": "Apprendre Swift avec Vapor",
  "isCompleted": false,
  "createdAt": "2025-09-08T10:30:00Z",
  "updatedAt": "2025-09-08T10:30:00Z"
}
```

💡 **Astuce Postman :** Après la création, copiez l'ID dans la variable `task_id` pour les requêtes suivantes.

### 3. Lister toutes les tâches

**GET** `{{base_url}}/tasks`

### 4. Récupérer une tâche spécifique

**GET** `{{base_url}}/tasks/{{task_id}}`

### 5. Modifier une tâche

**PUT** `{{base_url}}/tasks/{{task_id}}`

Headers:
- `Content-Type: application/json`

Body (raw JSON):
```json
{
  "title": "Apprendre Swift avec Vapor - TERMINÉ !",
  "isCompleted": true
}
```

### 6. Supprimer une tâche

**DELETE** `{{base_url}}/tasks/{{task_id}}`

### 7. Tâches non terminées

**GET** `{{base_url}}/tasks/pending`

## 🖥️ Exemples avec curl

### Créer plusieurs tâches rapidement

```bash
# Tâche 1
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Lire la documentation Vapor", "isCompleted": false}'

# Tâche 2
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Créer mon premier modèle", "isCompleted": true}'

# Tâche 3
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Tester avec Postman", "isCompleted": false}'
```

### Script de test complet

```bash
#!/bin/bash

echo "🚀 Test de l'API de gestion des tâches"
echo "======================================"

BASE_URL="http://localhost:8080"

echo "1. Test de la page d'accueil..."
curl -s $BASE_URL/ | jq .

echo -e "\n2. Création d'une tâche..."
TASK_RESPONSE=$(curl -s -X POST $BASE_URL/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Tâche de test", "isCompleted": false}')

echo $TASK_RESPONSE | jq .

# Extraction de l'ID de la tâche créée
TASK_ID=$(echo $TASK_RESPONSE | jq -r .id)
echo "ID de la tâche créée: $TASK_ID"

echo -e "\n3. Récupération de toutes les tâches..."
curl -s $BASE_URL/tasks | jq .

echo -e "\n4. Récupération de la tâche spécifique..."
curl -s $BASE_URL/tasks/$TASK_ID | jq .

echo -e "\n5. Modification de la tâche..."
curl -s -X PUT $BASE_URL/tasks/$TASK_ID \
  -H "Content-Type: application/json" \
  -d '{"title": "Tâche de test MODIFIÉE", "isCompleted": true}' | jq .

echo -e "\n6. Tâches en attente..."
curl -s $BASE_URL/tasks/pending | jq .

echo -e "\n7. Suppression de la tâche..."
curl -s -X DELETE $BASE_URL/tasks/$TASK_ID

echo -e "\n8. Vérification de la suppression..."
curl -s $BASE_URL/tasks/$TASK_ID

echo -e "\n✅ Tests terminés !"
```

Rendez le script exécutable :
```bash
chmod +x test_api.sh
./test_api.sh
```

## 🧪 Scénarios de test

### Scénario 1 : Gestion d'un projet

```bash
# 1. Créer les tâches d'un projet
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Analyser les besoins", "isCompleted": true}'

curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Concevoir l'architecture", "isCompleted": true}'

curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Développer les fonctionnalités", "isCompleted": false}'

curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Tester l'application", "isCompleted": false}'

curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Déployer en production", "isCompleted": false}'

# 2. Voir l'état du projet
echo "État actuel du projet :"
curl -s http://localhost:8080/tasks | jq '.[] | {title: .title, completed: .isCompleted}'

# 3. Voir ce qui reste à faire
echo "Tâches restantes :"
curl -s http://localhost:8080/tasks/pending | jq '.[] | .title'
```

### Scénario 2 : Test des erreurs

```bash
# 1. Tenter de créer une tâche sans titre
echo "Test : tâche sans titre"
curl -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "", "isCompleted": false}'

# 2. Tenter de récupérer une tâche inexistante
echo "Test : tâche inexistante"
curl http://localhost:8080/tasks/00000000-0000-0000-0000-000000000000

# 3. Tenter de modifier une tâche inexistante
echo "Test : modification tâche inexistante"
curl -X PUT http://localhost:8080/tasks/00000000-0000-0000-0000-000000000000 \
  -H "Content-Type: application/json" \
  -d '{"title": "Test", "isCompleted": false}'
```

## 📊 Tests de performance

### Test de charge basique

```bash
#!/bin/bash

echo "🏃‍♂️ Test de charge - Création de 100 tâches"

for i in {1..100}
do
  curl -s -X POST http://localhost:8080/tasks \
    -H "Content-Type: application/json" \
    -d "{\"title\": \"Tâche automatique $i\", \"isCompleted\": false}" > /dev/null
  
  if [ $((i % 10)) -eq 0 ]; then
    echo "Créé $i tâches..."
  fi
done

echo "✅ 100 tâches créées !"

# Vérification
TASK_COUNT=$(curl -s http://localhost:8080/tasks | jq length)
echo "Nombre total de tâches : $TASK_COUNT"
```

### Mesure du temps de réponse

```bash
#!/bin/bash

echo "⏱️ Mesure des temps de réponse"

echo "GET / :"
time curl -s http://localhost:8080/ > /dev/null

echo "GET /tasks :"
time curl -s http://localhost:8080/tasks > /dev/null

echo "POST /tasks :"
time curl -s -X POST http://localhost:8080/tasks \
  -H "Content-Type: application/json" \
  -d '{"title": "Test performance", "isCompleted": false}' > /dev/null
```

## 🔍 Débogage

### Vérifier la connectivité

```bash
# Test de base
curl -v http://localhost:8080/hello

# Test avec timeout
curl --max-time 5 http://localhost:8080/

# Test de santé
curl http://localhost:8080/health
```

### Analyser les réponses

```bash
# Voir les headers HTTP
curl -I http://localhost:8080/

# Voir la réponse complète
curl -v http://localhost:8080/tasks

# Formater le JSON
curl -s http://localhost:8080/tasks | jq .
```

## 🎯 Exercices pratiques

### Exercice 1 : Workflow complet
1. Créez 5 tâches pour un projet personnel
2. Marquez 2 tâches comme terminées
3. Listez les tâches restantes
4. Supprimez une tâche inutile
5. Vérifiez l'état final

### Exercice 2 : Gestion d'erreurs
1. Testez tous les cas d'erreur possibles
2. Notez les codes de statut retournés
3. Vérifiez que les messages d'erreur sont clairs

### Exercice 3 : Performance
1. Créez 50 tâches rapidement
2. Mesurez le temps de réponse pour récupérer toutes les tâches
3. Testez la récupération d'une tâche spécifique

Ces exemples vous donneront une bonne base pour explorer et tester votre API ! 🚀
