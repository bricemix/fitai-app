/// Locale-aware RGPD/legal text for the in-app consent screen.
/// Novalab Studios Ltd — DietVision product.
library legal_content;

class LegalSection {
  final String title;
  final String body;
  const LegalSection({required this.title, required this.body});
}

class LegalContent {
  static List<LegalSection> rgpd(String locale) {
    switch (locale) {
      case 'en':
        return _en;
      case 'de':
        return _de;
      case 'es':
        return _es;
      case 'pt':
        return _pt;
      default:
        return _fr;
    }
  }

  // ── FRANÇAIS ──────────────────────────────────────────────────────────────
  static const _fr = [
    LegalSection(
      title: 'Objet',
      body:
          'DietVision est une application de coaching nutritionnel alimentée par '
          'intelligence artificielle, développée par Novalab Studios Ltd '
          '(société enregistrée en Angleterre et au Pays de Galles, siège : '
          'Londres, Royaume-Uni). Les présentes conditions régissent votre '
          'utilisation de l\'application et définissent la manière dont vos '
          'données personnelles sont collectées, traitées et protégées, '
          'conformément au Règlement Général sur la Protection des Données '
          '(RGPD — UE 2016/679) et à la loi Informatique et Libertés.',
    ),
    LegalSection(
      title: 'Données collectées',
      body:
          '• Données d\'identité : nom, adresse e-mail, numéro de téléphone, pays.\n'
          '• Données de santé : poids, taille, âge, objectif nutritionnel, '
          'niveau d\'activité physique, restrictions alimentaires.\n'
          '• Données d\'usage : photos de repas (traitées en mémoire, non stockées '
          'sur nos serveurs), historique nutritionnel, conversations avec le coach IA.\n'
          '• Données techniques : identifiant de session, adresse IP, logs d\'accès à l\'API.',
    ),
    LegalSection(
      title: 'Base légale',
      body:
          'Le traitement de vos données repose sur :\n'
          '• Votre consentement explicite (art. 6 §1 a) RGPD) pour les données '
          'de santé et l\'analyse nutritionnelle.\n'
          '• L\'exécution du contrat (art. 6 §1 b) pour la fourniture du service.\n'
          '• L\'intérêt légitime (art. 6 §1 f) pour la sécurité et l\'amélioration du service.\n\n'
          'Les données de santé constituent des données sensibles (art. 9 RGPD) '
          'et ne sont traitées qu\'avec votre consentement explicite.',
    ),
    LegalSection(
      title: 'Finalités',
      body:
          '• Fournir les fonctionnalités d\'analyse nutritionnelle par IA.\n'
          '• Personnaliser les recommandations du coach selon votre profil.\n'
          '• Gérer votre compte et votre abonnement.\n'
          '• Améliorer la qualité du service (données agrégées et anonymisées).\n'
          '• Respecter nos obligations légales et comptables.\n\n'
          'Vos données ne sont jamais vendues à des tiers ni utilisées à des fins publicitaires.',
    ),
    LegalSection(
      title: 'Sous-traitants',
      body:
          'DietVision fait appel aux sous-traitants suivants, liés par des '
          'clauses contractuelles types conformes au RGPD :\n'
          '• Anthropic / OpenRouter (analyse IA des repas) — serveurs aux États-Unis, '
          'couvert par les Clauses Contractuelles Types CE.\n'
          '• CinetPay / Stripe (paiements) — certifiés PCI-DSS.\n'
          '• Hébergeur backend — Union Européenne.\n\n'
          'Aucun transfert de données de santé hors UE sans garanties appropriées.',
    ),
    LegalSection(
      title: 'Durée de conservation',
      body:
          '• Données de compte : durée de l\'abonnement actif + 3 ans.\n'
          '• Historique nutritionnel : 12 mois glissants, puis anonymisation.\n'
          '• Logs techniques : 90 jours.\n'
          '• Données de paiement : 10 ans (obligation comptable légale).\n\n'
          'À l\'expiration, les données sont supprimées définitivement ou anonymisées.',
    ),
    LegalSection(
      title: 'Vos droits',
      body:
          'Conformément aux articles 15 à 22 du RGPD, vous disposez des droits suivants :\n\n'
          '• Droit d\'accès — obtenir une copie de vos données.\n'
          '• Droit de rectification — corriger des données inexactes.\n'
          '• Droit à l\'effacement ("droit à l\'oubli").\n'
          '• Droit à la portabilité — recevoir vos données dans un format lisible par machine.\n'
          '• Droit d\'opposition et droit au retrait du consentement (révocable à tout moment).\n\n'
          'Pour exercer ces droits : privacy@dietvision.app\n'
          'Délai de réponse : 30 jours maximum (art. 12 RGPD).\n\n'
          'Vous avez également le droit de déposer une réclamation auprès de la CNIL '
          '(www.cnil.fr) ou de l\'autorité de contrôle de votre État membre.',
    ),
    LegalSection(
      title: 'Sécurité',
      body:
          'Novalab Studios Ltd / DietVision met en œuvre les mesures suivantes :\n'
          '• Chiffrement des données en transit (TLS 1.3) et au repos (AES-256).\n'
          '• Authentification par jeton JWT à durée limitée.\n'
          '• Accès aux données restreint au personnel autorisé.\n'
          '• Audits de sécurité réguliers.',
    ),
    LegalSection(
      title: 'Responsable du traitement',
      body:
          'Novalab Studios Ltd\n'
          'Siège social : Londres, Angleterre, Royaume-Uni\n'
          'Produit : DietVision\n'
          'Contact DPO : privacy@dietvision.app\n'
          'Version : 1.1 — Mai 2026\n\n'
          'Cette politique peut être mise à jour. En cas de modification substantielle, '
          'votre consentement sera à nouveau sollicité.',
    ),
  ];

  // ── ENGLISH ──────────────────────────────────────────────────────────────
  static const _en = [
    LegalSection(
      title: 'Purpose',
      body:
          'DietVision is an AI-powered nutritional coaching application developed '
          'by Novalab Studios Ltd (registered in England and Wales, '
          'headquartered in London, United Kingdom). These terms govern your '
          'use of the application and describe how your personal data is '
          'collected, processed and protected in accordance with the General '
          'Data Protection Regulation (GDPR — EU 2016/679) and the UK GDPR.',
    ),
    LegalSection(
      title: 'Data collected',
      body:
          '• Identity data: name, email address, phone number, country.\n'
          '• Health data: weight, height, age, nutritional goal, physical '
          'activity level, dietary restrictions.\n'
          '• Usage data: meal photos (processed in memory, not stored on our '
          'servers), nutritional history, conversations with the AI coach.\n'
          '• Technical data: session identifier, IP address, API access logs.',
    ),
    LegalSection(
      title: 'Legal basis',
      body:
          'The processing of your data is based on:\n'
          '• Your explicit consent (Art. 6(1)(a) GDPR) for health data and nutritional analysis.\n'
          '• Performance of a contract (Art. 6(1)(b)) for the provision of the service.\n'
          '• Legitimate interest (Art. 6(1)(f)) for security and service improvement.\n\n'
          'Health data constitutes special category data (Art. 9 GDPR) and is only '
          'processed with your explicit consent.',
    ),
    LegalSection(
      title: 'Purposes',
      body:
          '• Provide AI nutritional analysis features.\n'
          '• Personalize coach recommendations based on your profile.\n'
          '• Manage your account and subscription.\n'
          '• Improve service quality (aggregated and anonymized data).\n'
          '• Comply with legal and accounting obligations.\n\n'
          'Your data is never sold to third parties or used for advertising purposes.',
    ),
    LegalSection(
      title: 'Sub-processors',
      body:
          'DietVision uses the following sub-processors, bound by GDPR-compliant '
          'standard contractual clauses:\n'
          '• Anthropic / OpenRouter (AI meal analysis) — US servers, covered by EU SCCs.\n'
          '• CinetPay / Stripe (payments) — PCI-DSS certified.\n'
          '• Backend hosting — European Union.\n\n'
          'No health data is transferred outside the EU/UK without appropriate safeguards.',
    ),
    LegalSection(
      title: 'Retention period',
      body:
          '• Account data: active subscription period + 3 years.\n'
          '• Nutritional history: rolling 12 months, then anonymized.\n'
          '• Technical logs: 90 days.\n'
          '• Payment data: 10 years (legal accounting obligation).\n\n'
          'Upon expiry, data is permanently deleted or irreversibly anonymized.',
    ),
    LegalSection(
      title: 'Your rights',
      body:
          'Under Articles 15 to 22 of the GDPR, you have the following rights:\n\n'
          '• Right of access — obtain a copy of your data.\n'
          '• Right of rectification — correct inaccurate data.\n'
          '• Right to erasure ("right to be forgotten").\n'
          '• Right to data portability — receive your data in machine-readable format.\n'
          '• Right to object and right to withdraw consent (revocable at any time).\n\n'
          'To exercise these rights: privacy@dietvision.app\n'
          'Response time: maximum 30 days (Art. 12 GDPR).\n\n'
          'You also have the right to lodge a complaint with the ICO (ico.org.uk) '
          'or your local supervisory authority.',
    ),
    LegalSection(
      title: 'Security',
      body:
          'Novalab Studios Ltd / DietVision implements the following measures:\n'
          '• Encryption of data in transit (TLS 1.3) and at rest (AES-256).\n'
          '• JWT token authentication with limited validity.\n'
          '• Data access restricted to authorized staff.\n'
          '• Regular security audits.',
    ),
    LegalSection(
      title: 'Data controller',
      body:
          'Novalab Studios Ltd\n'
          'Registered office: London, England, United Kingdom\n'
          'Product: DietVision\n'
          'DPO contact: privacy@dietvision.app\n'
          'Version: 1.1 — May 2026\n\n'
          'This policy may be updated. For material changes, your consent will be '
          'requested again.',
    ),
  ];

  // ── DEUTSCH ──────────────────────────────────────────────────────────────
  static const _de = [
    LegalSection(
      title: 'Zweck',
      body:
          'DietVision ist eine KI-gestützte Ernährungscoaching-App, entwickelt von '
          'Novalab Studios Ltd (registriert in England und Wales, Sitz: London, '
          'Vereinigtes Königreich). Diese Bedingungen regeln die Nutzung der App '
          'und beschreiben, wie Ihre personenbezogenen Daten im Einklang mit der '
          'Datenschutz-Grundverordnung (DSGVO — EU 2016/679) und dem UK GDPR '
          'verarbeitet und geschützt werden.',
    ),
    LegalSection(
      title: 'Erfasste Daten',
      body:
          '• Identitätsdaten: Name, E-Mail-Adresse, Telefonnummer, Land.\n'
          '• Gesundheitsdaten: Gewicht, Größe, Alter, Ernährungsziel, '
          'körperliche Aktivität, Ernährungseinschränkungen.\n'
          '• Nutzungsdaten: Mahlzeitenfotos (im Speicher verarbeitet, nicht auf '
          'unseren Servern gespeichert), Ernährungsverlauf, Gespräche mit dem KI-Coach.\n'
          '• Technische Daten: Sitzungs-ID, IP-Adresse, API-Zugriffsprotokolle.',
    ),
    LegalSection(
      title: 'Rechtsgrundlage',
      body:
          'Die Verarbeitung Ihrer Daten basiert auf:\n'
          '• Ihrer ausdrücklichen Einwilligung (Art. 6 Abs. 1 lit. a DSGVO) für Gesundheitsdaten.\n'
          '• Vertragserfüllung (Art. 6 Abs. 1 lit. b) für die Erbringung des Dienstes.\n'
          '• Berechtigten Interessen (Art. 6 Abs. 1 lit. f) für Sicherheit und Verbesserung.\n\n'
          'Gesundheitsdaten sind besondere Kategorien (Art. 9 DSGVO) und werden nur '
          'mit Ihrer ausdrücklichen Einwilligung verarbeitet.',
    ),
    LegalSection(
      title: 'Zwecke',
      body:
          '• Bereitstellung von KI-Ernährungsanalysefunktionen.\n'
          '• Personalisierung von Coach-Empfehlungen.\n'
          '• Verwaltung Ihres Kontos und Abonnements.\n'
          '• Verbesserung der Servicequalität (aggregierte, anonymisierte Daten).\n\n'
          'Ihre Daten werden niemals an Dritte verkauft oder für Werbezwecke genutzt.',
    ),
    LegalSection(
      title: 'Auftragsverarbeiter',
      body:
          '• Anthropic / OpenRouter (KI-Mahlzeitenanalyse) — US-Server, EU-SCCs.\n'
          '• CinetPay / Stripe (Zahlungen) — PCI-DSS zertifiziert.\n'
          '• Backend-Hosting — Europäische Union.\n\n'
          'Keine Übermittlung von Gesundheitsdaten außerhalb der EU ohne geeignete Garantien.',
    ),
    LegalSection(
      title: 'Speicherdauer',
      body:
          '• Kontodaten: aktive Abonnementlaufzeit + 3 Jahre.\n'
          '• Ernährungsverlauf: 12 Monate rollierend, dann anonymisiert.\n'
          '• Technische Protokolle: 90 Tage.\n'
          '• Zahlungsdaten: 10 Jahre (gesetzliche Buchführungspflicht).',
    ),
    LegalSection(
      title: 'Ihre Rechte',
      body:
          'Gemäß Art. 15–22 DSGVO haben Sie folgende Rechte:\n\n'
          '• Auskunftsrecht, Berichtigungsrecht, Löschungsrecht.\n'
          '• Recht auf Datenübertragbarkeit.\n'
          '• Widerspruchsrecht und Widerruf der Einwilligung (jederzeit möglich).\n\n'
          'Kontakt: privacy@dietvision.app\n'
          'Antwortfrist: max. 30 Tage (Art. 12 DSGVO).\n\n'
          'Sie können auch eine Beschwerde bei der zuständigen Aufsichtsbehörde einreichen.',
    ),
    LegalSection(
      title: 'Sicherheit',
      body:
          'Novalab Studios Ltd / DietVision setzt folgende Maßnahmen um:\n'
          '• Datenverschlüsselung in transit (TLS 1.3) und at rest (AES-256).\n'
          '• JWT-Token-Authentifizierung.\n'
          '• Datenzugang nur für autorisiertes Personal.\n'
          '• Regelmäßige Sicherheitsaudits.',
    ),
    LegalSection(
      title: 'Verantwortlicher',
      body:
          'Novalab Studios Ltd\n'
          'Sitz: London, England, Vereinigtes Königreich\n'
          'Produkt: DietVision\n'
          'DSB-Kontakt: privacy@dietvision.app\n'
          'Version: 1.1 — Mai 2026',
    ),
  ];

  // ── ESPAÑOL ──────────────────────────────────────────────────────────────
  static const _es = [
    LegalSection(
      title: 'Objeto',
      body:
          'DietVision es una aplicación de coaching nutricional impulsada por IA, '
          'desarrollada por Novalab Studios Ltd (registrada en Inglaterra y Gales, '
          'sede: Londres, Reino Unido). Estas condiciones rigen el uso de la '
          'aplicación y describen cómo se recopilan, procesan y protegen sus datos '
          'personales de conformidad con el Reglamento General de Protección de '
          'Datos (RGPD — UE 2016/679) y el UK GDPR.',
    ),
    LegalSection(
      title: 'Datos recopilados',
      body:
          '• Datos de identidad: nombre, correo electrónico, teléfono, país.\n'
          '• Datos de salud: peso, altura, edad, objetivo nutricional, nivel de '
          'actividad física, restricciones dietéticas.\n'
          '• Datos de uso: fotos de comidas (procesadas en memoria, no almacenadas '
          'en nuestros servidores), historial nutricional, conversaciones con el coach IA.\n'
          '• Datos técnicos: identificador de sesión, IP, registros de acceso a la API.',
    ),
    LegalSection(
      title: 'Base legal',
      body:
          '• Su consentimiento explícito (Art. 6(1)(a) RGPD) para datos de salud.\n'
          '• Ejecución del contrato (Art. 6(1)(b)) para la prestación del servicio.\n'
          '• Interés legítimo (Art. 6(1)(f)) para seguridad y mejora del servicio.\n\n'
          'Los datos de salud son datos especiales (Art. 9 RGPD) y solo se procesan '
          'con su consentimiento explícito.',
    ),
    LegalSection(
      title: 'Finalidades',
      body:
          '• Proporcionar funciones de análisis nutricional por IA.\n'
          '• Personalizar recomendaciones del coach.\n'
          '• Gestionar su cuenta y suscripción.\n'
          '• Mejorar la calidad del servicio (datos agregados y anonimizados).\n\n'
          'Sus datos nunca se venden a terceros ni se usan con fines publicitarios.',
    ),
    LegalSection(
      title: 'Subencargados',
      body:
          '• Anthropic / OpenRouter (análisis IA) — servidores en EE.UU., CCE de la UE.\n'
          '• CinetPay / Stripe (pagos) — certificados PCI-DSS.\n'
          '• Hosting backend — Unión Europea.\n\n'
          'No se transfieren datos de salud fuera de la UE sin garantías adecuadas.',
    ),
    LegalSection(
      title: 'Período de conservación',
      body:
          '• Datos de cuenta: duración de la suscripción + 3 años.\n'
          '• Historial nutricional: 12 meses, luego anonimizado.\n'
          '• Registros técnicos: 90 días.\n'
          '• Datos de pago: 10 años (obligación contable legal).',
    ),
    LegalSection(
      title: 'Sus derechos',
      body:
          'Conforme a los artículos 15 a 22 del RGPD, tiene los siguientes derechos:\n\n'
          '• Acceso, rectificación, supresión, portabilidad.\n'
          '• Oposición y retirada del consentimiento (en cualquier momento).\n\n'
          'Contacto: privacy@dietvision.app\n'
          'También puede presentar una reclamación ante la AEPD o su autoridad local.',
    ),
    LegalSection(
      title: 'Seguridad',
      body:
          'Novalab Studios Ltd / DietVision implementa:\n'
          '• Cifrado en tránsito (TLS 1.3) y en reposo (AES-256).\n'
          '• Autenticación JWT de duración limitada.\n'
          '• Acceso restringido a personal autorizado.',
    ),
    LegalSection(
      title: 'Responsable del tratamiento',
      body:
          'Novalab Studios Ltd\n'
          'Domicilio social: Londres, Inglaterra, Reino Unido\n'
          'Producto: DietVision\n'
          'Contacto DPD: privacy@dietvision.app\n'
          'Versión: 1.1 — Mayo 2026',
    ),
  ];

  // ── PORTUGUÊS ────────────────────────────────────────────────────────────
  static const _pt = [
    LegalSection(
      title: 'Objeto',
      body:
          'DietVision é um aplicativo de coaching nutricional alimentado por IA, '
          'desenvolvido pela Novalab Studios Ltd (registrada na Inglaterra e no '
          'País de Gales, sede: Londres, Reino Unido). Estes termos regem o uso '
          'do aplicativo e descrevem como seus dados pessoais são coletados, '
          'processados e protegidos em conformidade com o Regulamento Geral de '
          'Proteção de Dados (RGPD — UE 2016/679) e o UK GDPR.',
    ),
    LegalSection(
      title: 'Dados coletados',
      body:
          '• Dados de identidade: nome, e-mail, telefone, país.\n'
          '• Dados de saúde: peso, altura, idade, objetivo nutricional, nível de '
          'atividade física, restrições alimentares.\n'
          '• Dados de uso: fotos de refeições (processadas em memória, não armazenadas '
          'nos servidores), histórico nutricional, conversas com o coach IA.\n'
          '• Dados técnicos: ID de sessão, IP, logs de acesso à API.',
    ),
    LegalSection(
      title: 'Base legal',
      body:
          '• Seu consentimento explícito (Art. 6(1)(a) RGPD) para dados de saúde.\n'
          '• Execução do contrato (Art. 6(1)(b)) para prestação do serviço.\n'
          '• Interesse legítimo (Art. 6(1)(f)) para segurança e melhoria do serviço.\n\n'
          'Dados de saúde são dados especiais (Art. 9 RGPD) e só são processados '
          'com seu consentimento explícito.',
    ),
    LegalSection(
      title: 'Finalidades',
      body:
          '• Fornecer recursos de análise nutricional por IA.\n'
          '• Personalizar recomendações do coach.\n'
          '• Gerenciar sua conta e assinatura.\n'
          '• Melhorar a qualidade do serviço (dados agregados e anonimizados).\n\n'
          'Seus dados nunca são vendidos a terceiros nem usados para publicidade.',
    ),
    LegalSection(
      title: 'Suboperadores',
      body:
          '• Anthropic / OpenRouter (análise IA) — servidores nos EUA, CCE da UE.\n'
          '• CinetPay / Stripe (pagamentos) — certificados PCI-DSS.\n'
          '• Hospedagem backend — União Europeia.\n\n'
          'Nenhum dado de saúde é transferido para fora da UE sem garantias adequadas.',
    ),
    LegalSection(
      title: 'Período de retenção',
      body:
          '• Dados da conta: duração da assinatura ativa + 3 anos.\n'
          '• Histórico nutricional: 12 meses contínuos, depois anonimizado.\n'
          '• Logs técnicos: 90 dias.\n'
          '• Dados de pagamento: 10 anos (obrigação contábil legal).',
    ),
    LegalSection(
      title: 'Seus direitos',
      body:
          'De acordo com os artigos 15 a 22 do RGPD, você tem os seguintes direitos:\n\n'
          '• Acesso, retificação, apagamento, portabilidade.\n'
          '• Oposição e retirada do consentimento (a qualquer momento).\n\n'
          'Contato: privacy@dietvision.app\n'
          'Você também pode apresentar uma reclamação à ANPD ou à autoridade local.',
    ),
    LegalSection(
      title: 'Segurança',
      body:
          'Novalab Studios Ltd / DietVision implementa:\n'
          '• Criptografia em trânsito (TLS 1.3) e em repouso (AES-256).\n'
          '• Autenticação JWT com validade limitada.\n'
          '• Acesso restrito a pessoal autorizado.',
    ),
    LegalSection(
      title: 'Controlador de dados',
      body:
          'Novalab Studios Ltd\n'
          'Sede: Londres, Inglaterra, Reino Unido\n'
          'Produto: DietVision\n'
          'Contato DPO: privacy@dietvision.app\n'
          'Versão: 1.1 — Maio 2026',
    ),
  ];
}
