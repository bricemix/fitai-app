# Google Play Console — Data Safety / Confidentialité des données
## DietVision (com.novalabstudios.dietvision)

> Réponses complètes à copier-coller dans le formulaire Play Console.
> URL : https://play.google.com/console → App content → Data privacy & security

---

## 1. Collecte et partage de données

**"Does your app collect or share any of the required user data types?"**
→ **Yes**

---

## 2. Données collectées

### Personal info

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| Name | ✅ Yes | ❌ No | Optional | Account personalization |
| Email address | ✅ Yes | ❌ No | Required | Authentication, account recovery |
| User IDs | ✅ Yes | ❌ No | Required | Account management |
| Address | ❌ No | — | — | — |
| Phone number | ❌ No | — | — | — |

**Processing for "Name":**
- [x] Account management

**Processing for "Email address":**
- [x] Account management
- [x] App functionality

**Processing for "User IDs":**
- [x] Account management
- [x] App functionality

---

### Health and fitness

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| Health info | ✅ Yes | ❌ No | Optional | Nutrition tracking, AI analysis |
| Fitness info | ✅ Yes | ❌ No | Optional | Goal tracking |

**Health info inclut :**
- Calories consumed per meal
- Macronutrients (protein, carbs, fat, fiber)
- Dietary restrictions (vegetarian, gluten-free, etc.)
- Daily calorie goals
- Weight goals

**Processing for "Health info":**
- [x] App functionality
- [x] Analytics
- [x] Personalization

**Processing for "Fitness info":**
- [x] App functionality
- [x] Personalization

---

### Photos and videos

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| Photos | ✅ Yes | ✅ Yes (AI service) | Required for scan | Nutritional analysis by AI |
| Videos | ❌ No | — | — | — |

**Sharing "Photos" with:**
- AI analysis service (Anthropic Claude API) — photos are sent for nutritional content identification. Photos are NOT stored permanently on servers; they are processed in real-time and discarded.

**Processing for "Photos":**
- [x] App functionality

---

### Financial info

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| Purchase history | ✅ Yes | ❌ No | Required | Subscription management |
| Payment info | ❌ No (handled by Stripe) | — | — | — |

**Note:** Payment card data is never processed by the app. It is handled entirely by Stripe's secure payment UI.

**Processing for "Purchase history":**
- [x] Account management
- [x] App functionality

---

### App activity

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| App interactions | ✅ Yes | ❌ No | Required | App functionality |
| In-app search history | ❌ No | — | — | — |
| Installed apps | ❌ No | — | — | — |
| Other user-generated content | ✅ Yes | ❌ No | Optional | AI coach conversation history |

**Processing for "App interactions":**
- [x] App functionality
- [x] Analytics

**Processing for "Other user-generated content" (coach messages):**
- [x] App functionality

---

### App info and performance

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| Crash logs | ✅ Yes | ❌ No | Required | Bug fixing |
| Diagnostics | ✅ Yes | ❌ No | Required | Performance monitoring |
| Other app performance data | ❌ No | — | — | — |

**Processing for "Crash logs" & "Diagnostics":**
- [x] App functionality
- [x] Analytics

---

### Device or other IDs

| Champ | Collecté ? | Partagé ? | Obligatoire ? | Finalité |
|-------|-----------|-----------|---------------|----------|
| Device or other IDs | ✅ Yes | ❌ No | Required | Session management, authentication token |

**Processing for "Device or other IDs":**
- [x] Account management
- [x] App functionality

---

## 3. Pratiques de sécurité

**"Is all of the user data collected by your app encrypted in transit?"**
→ **Yes**
> All data is transmitted over HTTPS/TLS 1.2+. No unencrypted connections are used.

**"Do you follow the Families Policy?"**
→ **No** (app is not directed at children)

**"Does your app include ads?"**
→ **No**

**"Does your app collect or use this data for tracking purposes defined under the App Tracking Transparency requirements?"**
→ **No**

**"Do you provide a way for users to request that their data is deleted?"**
→ **Yes**
> Users can delete their account and all associated data via: Profile → Settings → Delete Account. Data is permanently deleted within 30 days of the request.

---

## 4. Privacy Policy

**URL à renseigner :**
```
https://diet-vision.com/privacy
```
*(ou l'URL de ta politique de confidentialité)*

---

## 5. Résumé visuel pour la fiche Play Store

```
Ce que l'app collecte :
✅ Adresse e-mail
✅ Données de santé (calories, macros, objectifs)
✅ Photos de repas (analyse IA, non stockées)
✅ Historique d'abonnement
✅ Identifiant de session

Ce que l'app NE collecte PAS :
❌ Numéro de téléphone
❌ Adresse postale
❌ Données bancaires (gérées par Stripe)
❌ Localisation
❌ Contacts

Sécurité :
🔒 Toutes les données chiffrées en transit (HTTPS)
🗑️ Suppression de compte et données sur demande
🚫 Aucune publicité
🚫 Pas de partage avec des tiers pour la publicité
```

---

## 6. Description de l'app (Play Store listing)

### Court (80 caractères max)
```
Coach nutrition IA — Analysez vos repas en photo
```

### Long (4000 caractères max)
```
DietVision est votre coach nutrition personnel propulsé par l'intelligence artificielle.

📸 ANALYSEZ VOS REPAS EN PHOTO
Prenez simplement une photo de votre assiette. Notre IA identifie les aliments et calcule instantanément les calories, protéines, glucides, lipides et fibres.

🤖 COACH IA ILLIMITÉ
Posez vos questions nutrition à votre coach IA disponible 24h/24. Recevez des conseils personnalisés basés sur vos objectifs et votre historique.

📊 SUIVI COMPLET
Suivez vos macronutriments jour après jour. Visualisez vos progrès semaine par semaine et ajustez vos habitudes en conséquence.

🎯 OBJECTIFS PERSONNALISÉS
Définissez vos objectifs (perte de poids, prise de masse, maintien) et laissez DietVision vous guider avec des recommandations adaptées.

📄 EXPORT PDF
Exportez votre rapport nutritionnel mensuel en PDF pour le partager avec votre médecin ou nutritionniste.

🌍 DISPONIBLE EN 5 LANGUES
Français, Anglais, Allemand, Espagnol, Portugais.

---

PLANS DISPONIBLES :

⭐ Starter — Parfait pour commencer
• 20 analyses photo par jour
• Coach IA illimité
• Suivi calories & macros
• Historique 30 jours

🔥 Pro — Le plus populaire
• 100 analyses photo par jour
• Coach IA illimité
• Historique complet
• Export PDF mensuel
• Objectifs personnalisés

👑 Premium — L'expérience complète
• Tout le plan Pro
• 2 mois offerts
• Support prioritaire
• Accès aux nouvelles fonctionnalités en avant-première

Essai gratuit 7 jours — Sans engagement — Annulez à tout moment.
```

---

## 7. Catégorie & Tags

- **Catégorie :** Health & Fitness
- **Tags suggérés :** nutrition, calories, régime, IA, coach, macros, alimentation, santé
- **Note de contenu :** PEGI 3 / Everyone
- **Application cible :** 18+ (pas de contenu enfant)
```
