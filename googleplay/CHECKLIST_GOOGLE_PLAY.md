# Checklist Publication Google Play — DietVision

**App ID** : `com.novalabstudios.dietvision`
**Version** : 1.0.0 (build 17)

---

## ✅ PRÊT

- [x] **AAB signé** → `release/dietvision-v1.0.0+17.aab`
- [x] **Keystore** → `signing/dietvision-release.jks`
- [x] **Application ID** changé → `com.novalabstudios.dietvision`
- [x] **Icône 512×512** → `graphics/icon_512x512.png`
- [x] **Feature graphic 1024×500** → `graphics/feature_graphic_1024x500.png`
- [x] **Titre** (FR + EN) → `store_listing/*/title.txt`
- [x] **Description courte** (FR + EN) → `store_listing/*/short_description.txt`
- [x] **Description longue** (FR + EN) → `store_listing/*/full_description.txt`

---

## ⏳ À FAIRE AVANT PUBLICATION

### 📸 Screenshots (OBLIGATOIRES — minimum 2 par type)
- [ ] **Téléphone** (format 9:16 recommandé, min 320px, max 3840px)
  - Déposer dans : `graphics/screenshots/phone/`
  - Écrans suggérés : Dashboard, Scan IA, Coach Pro, Coach Premium, Progrès
- [ ] **Tablette 7"** (optionnel)
  - Déposer dans : `graphics/screenshots/tablet/`

### 🎨 Feature Graphic
- [ ] Remplacer `graphics/feature_graphic_1024x500.png` par une version
      graphiquement soignée (Canva, Figma, Photoshop)
      → Dimensions exactes : **1024 × 500 px**

### 📋 Console Google Play
- [ ] Créer un compte développeur Google Play (25 USD unique)
      → https://play.google.com/console
- [ ] Créer l'application avec l'ID : `com.novalabstudios.dietvision`
- [ ] Uploader l'AAB dans "Production" ou "Test interne"
- [ ] Remplir la **Politique de confidentialité** (URL requise)
      → Utiliser l'URL du serveur : https://dietvision.app/politique-confidentialite
- [ ] Remplir le **Questionnaire de notation du contenu** (IARC)
      → Catégorie : Santé & Forme physique — Pas de contenu sensible
- [ ] Compléter la section **Sécurité des données**
      → Données collectées : email, prénom, données de santé (poids, taille…)
      → Chiffrement en transit : OUI
      → Suppression possible : OUI

### 💳 Achats intégrés (si applicable)
- [ ] Configurer les abonnements Pro et Premium dans la console
      → Mensuel / Trimestriel / Semestriel / Annuel
- [ ] Lier à Stripe via l'API Play Billing (si paiement natif)

### 🌍 Distribution
- [ ] Choisir les pays de diffusion
- [ ] Catégorie : **Santé & Forme physique**
- [ ] Tags : nutrition, calories, IA, régime, fitness, santé

---

## 🔑 COMMANDES UTILES

```bash
# Rebuilder l'AAB signé
flutter build appbundle --release

# Vérifier la signature
keytool -verify -verbose -keystore googleplay/signing/dietvision-release.jks

# Incrémenter la version dans pubspec.yaml
# version: 1.0.0+17  →  1.0.0+18
```

---

## ⚠️ SAUVEGARDES CRITIQUES

| Fichier | Importance | Action |
|---------|-----------|--------|
| `signing/dietvision-release.jks` | 🔴 CRITIQUE | Sauvegarder hors du projet |
| `android/key.properties` | 🔴 CRITIQUE | NE PAS commiter dans Git |
| Mot de passe keystore | 🔴 CRITIQUE | Stocker dans gestionnaire MDP |
