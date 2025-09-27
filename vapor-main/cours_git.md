# 📘 Cours Git – Les fondamentaux

## 🌱 1. C’est quoi Git ?
Git est un **logiciel de gestion de versions**.  
Il sert à **sauvegarder l’évolution de ton code** et **travailler à plusieurs sans se marcher dessus**.  

👉 Sans Git : si tu fais une erreur, tu écrases tout.  
👉 Avec Git : tu peux revenir en arrière, voir qui a changé quoi, et collaborer facilement.

---

## 📂 2. Les notions de base

### a) Le dépôt (repository / repo)
Un dossier spécial qui contient :
- Ton code
- Un dossier caché `.git` avec l’historique

### b) Les zones de Git
1. **Working Directory** → là où tu modifies tes fichiers.  
2. **Staging Area** → zone d’attente pour ce que tu veux sauvegarder.  
3. **Repository** → l’historique officiel.

👉 Métaphore :  
- Brouillon (Working Directory)  
- Pages sélectionnées (Staging)  
- Copie finale remise au prof (Repository)

---

## 📝 3. Les commandes essentielles

### Initialiser un projet
```bash
git init
```

### Ajouter un fichier
```bash
git add fichier.txt
# ou pour tout ajouter
git add .
```

### Sauvegarder
```bash
git commit -m "Ajout du fichier de base"
```

### Voir l’historique
```bash
git log --oneline
```

---

## 🌿 4. Branches
Une **branche** est une version parallèle du projet.  
Par défaut : `main`.  

Créer et aller sur une nouvelle branche :
```bash
git branch ma-branche
git checkout ma-branche
# ou plus moderne
git switch -c ma-branche
```

👉 Exemple :  
- `main` contient ton devoir terminé.  
- `ma-branche` est une copie pour tester une idée.

---

## 🔀 5. Fusionner (merge)
Ramener une branche dans `main` :
```bash
git checkout main
git merge ma-branche
```

- S’il y a un conflit → Git te demande de choisir.  
- Merge garde **tout l’historique**.

---

## ⏩ 6. Rebase
**Merge** : crée un commit spécial de fusion.  
**Rebase** : rejoue tes commits après les autres → historique linéaire.

### Exemple :

- Historique avant :
```
A---B   (main)
     \
      C---D  (feature)
```

- Après un **merge** :
```
A---B-------E   (main)
     \     /
      C---D
```

- Après un **rebase** :
```
A---B---C'---D'   (feature)
```

👉 En équipe → `merge` (honnête, garde tout).  
👉 En solo → `rebase` (plus lisible).

---

## ✅ 7. Commits conventionnels
Format :
```
<type>(scope): <message>
```

### Types fréquents :
- `feat:` → nouvelle fonctionnalité  
- `fix:` → correction de bug  
- `docs:` → documentation  
- `style:` → mise en forme  
- `refactor:` → amélioration du code interne  
- `test:` → ajout/modification de tests  
- `chore:` → tâches diverses

### Exemples :
```bash
git commit -m "feat(login): ajout du bouton de connexion"
git commit -m "fix(api): correction du bug sur GET /users"
```

👉 Avantages :
- Historique clair et professionnel  
- Génération automatique de changelogs  
- Messages homogènes dans toute l’équipe

---

## 🎯 Conclusion
Avec Git tu peux :
- **Suivre ton code** : `git init`, `git add`, `git commit`  
- **Travailler en parallèle** : `git branch`, `git switch`  
- **Fusionner / réorganiser** : `git merge`, `git rebase`  
- **Écrire proprement** : commits conventionnels
