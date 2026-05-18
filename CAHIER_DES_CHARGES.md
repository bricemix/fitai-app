# Cahier des Charges — DietVision
### Application mobile de nutrition & coaching alimentaire par IA

**Version** : 1.0  
**Date** : Avril 2026  
**Plateforme** : Android (iOS prévu)  
**Stack** : Flutter / Dart  

---

## Table des matières

1. [Présentation du projet](#1-présentation-du-projet)
2. [Objectifs](#2-objectifs)
3. [Utilisateurs cibles](#3-utilisateurs-cibles)
4. [Fonctionnalités générales](#4-fonctionnalités-générales)
5. [Architecture technique](#5-architecture-technique)
6. [Modules fonctionnels détaillés](#6-modules-fonctionnels-détaillés)
7. [Modèles de données](#7-modèles-de-données)
8. [Services & intégrations](#8-services--intégrations)
9. [Interface utilisateur](#9-interface-utilisateur)
10. [Performances & contraintes](#10-performances--contraintes)
11. [Sécurité & confidentialité](#11-sécurité--confidentialité)
12. [Évolutions prévues](#12-évolutions-prévues)

---

## 1. Présentation du projet

**DietVision** est une application mobile de suivi nutritionnel intelligente qui combine la vision artificielle, le coaching IA et le tracking corporel pour aider les utilisateurs à atteindre leurs objectifs de santé et de remise en forme.

L'application repose sur deux piliers technologiques :
- **Analyse alimentaire par photo** : reconnaissance automatique des aliments via IA (en ligne ou hors ligne)
- **Coaching personnalisé** : conseils nutritionnels et fitness adaptés au profil de l'utilisateur

### Nom & identité visuelle
- **Nom** : DietVision
- **Logo** : identité visuelle propre (icon, horizontal, light)
- **Thème** : dark mode, couleur d'accent verte `#7fff6e`, typographie Syne

---

## 2. Objectifs

| Objectif | Description |
|----------|-------------|
| **Simplicité** | Identifier un aliment en une photo, sans saisie manuelle fastidieuse |
| **Précision** | Fournir des valeurs nutritionnelles fiables (calories, macros, micronutriments) |
| **Personnalisation** | Adapter les recommandations au profil, objectif et restrictions alimentaires de l'utilisateur |
| **Accessibilité offline** | Fonctionner sans connexion internet grâce à un modèle TFLite embarqué |
| **Suivi global** | Combiner suivi alimentaire et suivi corporel (poids, mensurations) en un seul outil |

---

## 3. Utilisateurs cibles

- Personnes souhaitant **perdre du poids** ou **prendre de la masse musculaire**
- Sportifs suivant leurs **apports en macronutriments**
- Personnes avec des **restrictions alimentaires** (végétarien, vegan, sans gluten, halal, keto…)
- Utilisateurs souhaitant **manger plus sainement** sans peser chaque aliment

**Niveau technique attendu** : grand public, aucune connaissance nutritionnelle préalable requise.

---

## 4. Fonctionnalités générales

### 4.1 Onboarding
- Création de profil guidée en 4 étapes
- Saisie : prénom, âge, sexe, poids, taille, objectif, niveau d'activité, restrictions alimentaires
- Calcul automatique du **TDEE** (Total Daily Energy Expenditure) via formule Mifflin-St Jeor
- Calcul de l'**IMC** (Indice de Masse Corporelle)

### 4.2 Scan & analyse alimentaire
- Prise de photo (caméra) ou import depuis la galerie
- **Mode En ligne** : analyse par modèle de vision IA via OpenRouter (GPT-4o, Gemini, etc.)
  - Identification du plat
  - **Estimation automatique du poids/portion** visible dans la photo
  - Valeurs nutritionnelles calculées pour la portion estimée
- **Mode Hors ligne** : classification TFLite locale (Food-101 ou Google AIY Food V1)
  - 101 à 2024 catégories d'aliments
  - Base nutritionnelle SQLite embarquée (~150 aliments)
  - Portions typiques par aliment
- **Recherche manuelle** : saisie du nom de l'aliment avec autocomplétion (fallback fiable)
- Top-5 alternatives proposées (mode offline)
- Sélecteur de portion : 50g — 400g (ajustable)
- **Dialogue de confirmation** avant enregistrement ("Je vais manger ça")

### 4.3 Tableau de bord
- Résumé des apports du jour : calories, protéines, glucides, lipides
- Barre de progression vers l'objectif calorique journalier
- Anneau de macros (répartition visuelle)
- Carte de rappel mesures corporelles si non saisies aujourd'hui
- Rappel derniers repas de la journée

### 4.4 Coach IA
- Interface de messagerie avec un coach virtuel
- Contexte utilisateur transmis à l'IA (profil, objectifs, historique alimentaire)
- Réponses en français, concises et pratiques
- Mode en ligne uniquement (nécessite clé API OpenRouter)

### 4.5 Statistiques & progression

**Onglet Repas (historique)**
- Regroupement par date (Aujourd'hui, Hier, dates antérieures)
- Total calorique par jour
- Vignette photo + heure + macros + score santé par repas

**Onglet Corps (mensurations)**
- Saisie quotidienne : poids, tour de taille, poitrine, hanches, biceps, cuisse
- Graphiques de tendance par mesure (30 derniers jours)
- Carte "dernières mesures" avec delta vs entrée précédente
- Code couleur : vert = bonne direction, rouge = mauvaise direction

### 4.6 Profil utilisateur
- Modification de toutes les données de profil
- Affichage IMC et objectif
- Accès aux paramètres (mode analyse, clé API, modèle IA)

### 4.7 Paramètres
- Sélection du **mode d'analyse** : En ligne (OpenRouter) / Hors ligne (TFLite)
- **Clé API OpenRouter** : saisie sécurisée avec masquage
- **Modèle OpenRouter** : configurable (défaut : `google/gemini-2.0-flash-001`)
- Statut du modèle TFLite (installé / manquant)

---

## 5. Architecture technique

### 5.1 Stack technologique

| Composant | Technologie | Version |
|-----------|------------|---------|
| Framework | Flutter | SDK ^3.11.5 |
| Langage | Dart | ^3.11.5 |
| État applicatif | setState (stateful widgets) | — |
| Persistance locale | SharedPreferences | ^2.3.2 |
| Base de données | SQLite (sqflite) | ^2.3.3 |
| IA en ligne | OpenRouter API | REST/HTTP |
| IA hors ligne | TFLite Flutter | >=0.10.4 <3.0.0 |
| Traitement image | image package | ^4.2.0 |
| Capture photo | image_picker | ^1.1.2 |
| SVG | flutter_svg | ^2.0.10+1 |
| Icône launcher | flutter_launcher_icons | ^0.14.3 |
| HTTP | http | ^1.2.2 |

### 5.2 Structure du projet

```
lib/
├── main.dart                    # Point d'entrée, navigation principale (5 onglets)
├── theme.dart                   # Thème dark, couleurs, typographies
├── models/
│   ├── profile.dart             # UserProfile (TDEE, IMC, JSON)
│   ├── meal.dart                # FoodResult, Meal
│   └── body_entry.dart          # BodyEntry (mensurations)
├── services/
│   ├── storage_service.dart     # SharedPreferences (profil, repas, mesures)
│   ├── settings_service.dart    # Mode analyse, clé API, modèle IA
│   ├── ai_service.dart          # OpenRouter API (vision + coach)
│   ├── offline_ai_service.dart  # TFLite inference
│   ├── nutrition_db_service.dart# SQLite base nutritionnelle
│   └── food_labels_data.dart    # Labels Food-101 embarqués (101 classes)
└── screens/
    ├── onboarding_screen.dart   # Création de profil (4 étapes)
    ├── dashboard_screen.dart    # Tableau de bord journalier
    ├── scan_screen.dart         # Analyse photo + résultats
    ├── coach_screen.dart        # Chat coach IA
    ├── progress_screen.dart     # Historique repas + graphiques corps
    ├── profile_screen.dart      # Profil utilisateur
    └── settings_screen.dart     # Paramètres

assets/
├── models/
│   ├── food_classifier.tflite  # Modèle TFLite (à placer manuellement)
│   └── food_labels.txt         # Labels officiels (optionnel)
└── logo/
    ├── dietvision-icon.svg
    ├── dietvision-logo-horizontal.svg
    └── dietvision-logo-light.svg
```

### 5.3 Navigation

Navigation par `BottomNavigationBar` à 5 onglets gérée dans `HomeShell` (main.dart) :

```
[Accueil]  [Scanner]  [Coach]  [Stats]  [Profil]
```

État partagé via passage de callbacks et props (architecture sans provider/bloc).

---

## 6. Modules fonctionnels détaillés

### 6.1 Analyse alimentaire en ligne (OpenRouter)

**Endpoint** : `POST https://openrouter.ai/api/v1/chat/completions`

**Headers** :
```
Authorization: Bearer {apiKey}
Content-Type: application/json
HTTP-Referer: https://dietvision.app
X-Title: DietVision
```

**Prompt vision** : L'image est encodée en base64 JPEG (max 1024px) et envoyée avec un prompt demandant un JSON structuré contenant :
- Nom du plat (français)
- `estimatedGrams` : poids estimé de la portion visible
- Calories, protéines, glucides, lipides, fibres **pour la portion estimée**
- Vitamines et minéraux clés
- Score santé (1–10)
- Conseil nutritionnel (1 phrase, français)

**Modèle par défaut** : `google/gemini-2.0-flash-001`  
**Modèles alternatifs compatibles** : `openai/gpt-4o`, `openai/gpt-4o-mini`, `anthropic/claude-3.5-sonnet`

**Preprocessing image** :
- Décodage universel (HEIC, PNG, WebP, JPEG)
- Redimensionnement si > 1024px
- Encodage JPEG qualité 85
- Base64 encode

### 6.2 Analyse alimentaire hors ligne (TFLite)

**Modèle supporté** :
- Food-101 TFLite (101 classes, recommandé)
- Google AIY Vision Classifier Food V1 (2024 classes)

**Pipeline d'inférence** :
1. Décodage et redimensionnement à 224×224px
2. Détection automatique du type de tenseur (uint8 / float32)
3. Création du buffer d'entrée :
   - `uint8` : valeurs brutes 0–255, buffer `List<List<List<List<int>>>>`
   - `float32` : normalisé [−1, 1]
4. `interpreter.allocateTensors()` avant inférence
5. `interpreter.run(input, output)`
6. Extraction du top-1 et top-5 prédictions
7. Résolution du label → `NutritionDbService.lookup()`

**Labels embarqués** : `food_labels_data.dart` contient les 101 classes Food-101 exactes comme fallback si `food_labels.txt` absent.

### 6.3 Base nutritionnelle SQLite

**Table `foods`** :

| Colonne | Type | Description |
|---------|------|-------------|
| `label` | TEXT PK | Identifiant anglais snake_case |
| `name_fr` | TEXT | Nom français |
| `calories` | INTEGER | kcal pour 100g |
| `protein` | REAL | g pour 100g |
| `carbs` | REAL | g pour 100g |
| `fat` | REAL | g pour 100g |
| `fiber` | REAL | g pour 100g |
| `health_score` | INTEGER | Score 1–10 |

**Contenu** : ~115 aliments couvrant fruits, légumes, protéines, laitages, céréales, fast-food, snacks, sucreries, boissons, noix, légumineuses.

**Recherche** :
- Lookup exact par label
- Fallback fuzzy (contains) sur label
- Recherche full-text sur `name_fr` et `label` (méthode `search()`)
- Portions typiques par aliment (`_typicalGrams` map)
- Calcul proportionnel selon `portionGrams`

### 6.4 Calcul nutritionnel (UserProfile)

**TDEE** (formule Mifflin-St Jeor) :
```
BMR homme = 10×poids + 6.25×taille − 5×âge + 5
BMR femme = 10×poids + 6.25×taille − 5×âge − 161
TDEE = BMR × multiplicateur_activité
```

Ajustements objectif :
- Perdre du poids : TDEE − 400 kcal
- Prendre de la masse : TDEE + 300 kcal

**Multiplicateurs activité** :

| Niveau | Multiplicateur |
|--------|---------------|
| Sédentaire | 1.2 |
| Léger (1-2j/sem) | 1.375 |
| Modéré (3-4j/sem) | 1.55 |
| Actif (5-6j/sem) | 1.725 |
| Très actif | 1.9 |

---

## 7. Modèles de données

### 7.1 UserProfile
```dart
{
  name: String,
  age: String,
  gender: String,          // "homme" | "femme"
  weight: String,          // kg
  height: String,          // cm
  goal: String,            // "Perdre du poids" | "Prendre de la masse" | ...
  activity: String,        // niveau d'activité
  restrictions: List<String>  // "Végétarien" | "Vegan" | "Sans gluten" | ...
}
```
**Stockage** : JSON dans SharedPreferences (`fitai_profile`)

### 7.2 FoodResult
```dart
{
  name: String,            // Nom en français
  calories: int,           // kcal (pour la portion)
  protein: double,         // g
  carbs: double,           // g
  fat: double,             // g
  fiber: double,           // g
  vitamins: String,        // description courte
  minerals: String,        // description courte
  healthScore: int,        // 1–10
  tip: String,             // conseil nutritionnel
  estimatedGrams: int?     // portion estimée par l'IA (mode online)
}
```

### 7.3 Meal
```dart
{
  date: String,            // ISO 8601
  imagePath: String?,      // chemin local vers la photo
  result: FoodResult
}
```
**Stockage** : JSON array dans SharedPreferences (`fitai_meals`)

### 7.4 BodyEntry
```dart
{
  date: String,            // YYYY-MM-DD
  weight: double?,         // kg
  waist: double?,          // cm — tour de taille
  chest: double?,          // cm — poitrine
  hips: double?,           // cm — hanches
  biceps: double?,         // cm — biceps
  thigh: double?           // cm — cuisse
}
```
**Stockage** : JSON array dans SharedPreferences (`fitai_body_entries`)

---

## 8. Services & intégrations

### 8.1 StorageService
Couche d'abstraction sur SharedPreferences.

| Méthode | Description |
|---------|-------------|
| `loadProfile()` | Charge le profil utilisateur |
| `saveProfile(p)` | Sauvegarde le profil |
| `loadMeals()` | Charge tous les repas |
| `saveMeals(list)` | Sauvegarde la liste des repas |
| `loadBodyEntries()` | Charge les mesures corporelles |
| `saveBodyEntries(list)` | Sauvegarde les mesures |
| `todayBodyEntry()` | Retourne la mesure du jour si existante |

### 8.2 SettingsService
| Clé | Valeur | Défaut |
|-----|--------|--------|
| `fitai_api_key` | Clé API OpenRouter | `""` |
| `fitai_mode` | `"online"` / `"offline"` | `"online"` |
| `fitai_model` | Identifiant modèle OpenRouter | `"google/gemini-2.0-flash-001"` |

### 8.3 AiService (OpenRouter)
| Méthode | Description |
|---------|-------------|
| `hasApiKey()` | Vérifie si une clé est configurée |
| `analyzeFood(base64)` | Analyse une image, retourne `FoodResult?` |
| `askCoach(messages, profile)` | Envoie un message au coach, retourne la réponse |

### 8.4 OfflineAiService (TFLite)
| Méthode | Description |
|---------|-------------|
| `isModelAvailable()` | Vérifie si le fichier .tflite est présent |
| `analyze(file, portionGrams)` | Analyse une image, retourne `OfflineResult` |
| `topPredictions(file, topK)` | Retourne les K meilleures prédictions |
| `dispose()` | Libère l'interpréteur TFLite |

### 8.5 NutritionDbService (SQLite)
| Méthode | Description |
|---------|-------------|
| `lookup(label, portionGrams)` | Recherche un aliment par label, calcule la portion |
| `allLabels()` | Retourne tous les labels triés alphabétiquement |
| `search(query)` | Recherche full-text par nom FR ou label EN |

---

## 9. Interface utilisateur

### 9.1 Thème
- **Mode** : Dark uniquement
- **Fond** : `#0d0d1a`
- **Surface** : `#13132a`
- **Surface 2** : `#1a1a30`
- **Accent principal** : `#7fff6e` (vert)
- **Accent 2** : `#6eaaff` (bleu)
- **Accent 3** : `#ff6e6e` (rouge/orange)
- **Texte** : `#f0f0ff`
- **Texte secondaire** : `#8888aa`
- **Bordure** : `#2a2a40`
- **Typographie titres** : Syne (bold, extrabold)
- **Typographie corps** : Inter

### 9.2 Navigation
`BottomNavigationBar` personnalisée avec 5 onglets animés :

| Onglet | Icône | Écran |
|--------|-------|-------|
| Accueil | `home_rounded` | DashboardScreen |
| Scanner | `camera_alt_rounded` | ScanScreen |
| Coach | `chat_bubble_rounded` | CoachScreen |
| Stats | `show_chart_rounded` | ProgressScreen |
| Profil | `person_rounded` | ProfileScreen |

### 9.3 Composants réutilisables clés
- `_ResultCard` : affichage des résultats nutritionnels (nom, calories, macros, micronutriments, conseil)
- `_PortionPicker` : sélecteur de portion en chips
- `_DetectionHeader` : badge de confiance et label détecté
- `_AlternativesList` : top-5 alternatives en mode offline
- `_ManualSearchSheet` : bottom sheet de recherche manuelle avec autocomplétion
- `_BodyEntrySheet` : formulaire de saisie des mensurations
- `_TrendChart` : graphique de tendance (canvas Flutter)
- `_ConfirmMealSheet` : dialogue de confirmation avant enregistrement

---

## 10. Performances & contraintes

### 10.1 Taille & mémoire
| Composant | Taille estimée |
|-----------|---------------|
| APK release | ~90 MB |
| Modèle TFLite Food-101 | ~25 MB |
| Modèle TFLite AIY Food V1 | ~5 MB |
| Base SQLite (nutrition) | < 1 MB |
| Photos stockées (locale) | Variable |

### 10.2 Temps de réponse cibles
| Action | Cible |
|--------|-------|
| Analyse online (OpenRouter) | < 4 secondes |
| Analyse offline (TFLite) | < 2 secondes |
| Recherche manuelle | < 200 ms |
| Chargement dashboard | < 300 ms |
| Init TFLite (première fois) | < 1 seconde |

### 10.3 Compatibilité
- **Android** : minSdk 21 (Android 5.0 Lollipop), targetSdk 34
- **iOS** : non déployé en v1.0 (Flutter multiplateforme prêt)
- **RAM minimum** : 2 GB recommandé pour l'inférence TFLite

---

## 11. Sécurité & confidentialité

### 11.1 Données utilisateur
- **Toutes les données sont stockées localement** sur l'appareil (SharedPreferences + SQLite)
- **Aucun serveur backend** propriétaire — aucune donnée envoyée sans action explicite
- Les photos sont conservées sur le stockage local de l'appareil

### 11.2 Clé API
- Stockée en clair dans SharedPreferences (chiffrée par le système Android)
- Masquée dans l'interface (obscureText)
- Jamais incluse dans les logs

### 11.3 Communications réseau (mode online uniquement)
- L'image (en base64) est envoyée à OpenRouter pour analyse
- Le profil utilisateur est inclus dans le contexte du coach IA
- Toutes les communications se font via HTTPS

### 11.4 Permissions Android requises
```xml
INTERNET               <!-- Mode online -->
CAMERA                 <!-- Prise de photo -->
READ_EXTERNAL_STORAGE  <!-- Import galerie (API < 33) -->
READ_MEDIA_IMAGES      <!-- Import galerie (API >= 33) -->
```

---

## 12. Évolutions prévues

### v1.1 — Court terme
- [ ] Déploiement iOS (App Store)
- [ ] Agrandissement de la base nutritionnelle (500+ aliments)
- [ ] Export des données (CSV / PDF)
- [ ] Notifications de rappel journalier

### v1.2 — Moyen terme
- [ ] Scanner de codes-barres (lecture de produits emballés via Open Food Facts API)
- [ ] Recettes personnalisées avec calcul nutritionnel automatique
- [ ] Synchronisation cloud (optionnelle, chiffrée)
- [ ] Mode multi-profils (famille)

### v2.0 — Long terme
- [ ] Modèle TFLite custom entraîné sur dataset propriétaire (> 500 classes)
- [ ] Estimation de portion par réalité augmentée (profondeur)
- [ ] Intégration wearables (pèse-personne connectée, montre)
- [ ] Plan alimentaire hebdomadaire généré par IA
- [ ] Communauté & partage de repas

---

*Document généré le 25 avril 2026 — DietVision v1.0*
