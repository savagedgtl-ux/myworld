// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get accept => 'Accepter';

  @override
  String get acceptTerms =>
      'J’accepte les conditions d’utilisation et la politique de confidentialité';

  @override
  String get accessUntil => 'Accès jusqu’au';

  @override
  String get adConsent => 'Consentement publicitaire';

  @override
  String get adConsentHelp =>
      'Gérez vos choix de publicité personnalisée. Le contenu de vos documents n’est jamais utilisé pour la publicité.';

  @override
  String get adLabel => 'Annonce';

  @override
  String get add => 'Ajouter';

  @override
  String get addBusinessCard => 'Ajouter une carte de visite';

  @override
  String get addBusinessCardHint =>
      'Photographiez la carte de visite d’une personne';

  @override
  String get addCategory => 'Nouvelle catégorie';

  @override
  String get addDocument => 'Ajouter un document';

  @override
  String get addFamilyMember => 'Ajouter un membre de la famille';

  @override
  String get addFamilyMemberHint =>
      'Profil d’un membre du foyer, par ex. un enfant';

  @override
  String get addFavorite => 'Ajouter aux favoris';

  @override
  String get addImage => 'Importer une image';

  @override
  String get addImageHint => 'Choisissez des photos dans votre galerie';

  @override
  String get addItem => 'Ajouter un objet';

  @override
  String get addItemHint => 'Appareil, meuble, équipement, collection…';

  @override
  String get addMemberHelp =>
      'Un profil ne nécessite ni compte ni données sensibles. Les documents sont liés au profil ; chaque document gère sa propre visibilité.';

  @override
  String get addPage => 'Ajouter une page';

  @override
  String get addPdf => 'Importer un PDF';

  @override
  String get addPdfHint => 'Un PDF déjà présent sur votre téléphone';

  @override
  String get addPhoto => 'Prendre une photo';

  @override
  String get addPhotoHint => 'Une seule photo avec l’appareil';

  @override
  String get addRecord => 'Ajouter une entrée';

  @override
  String get addReminder => 'Ajouter un rappel';

  @override
  String get addReminderHint => 'Échéance, renouvellement, anniversaire…';

  @override
  String get addRepairReceipt => 'Ajouter un reçu de réparation';

  @override
  String get addScan => 'Scanner un document';

  @override
  String get addScanHint =>
      'Détection des bords, plusieurs pages dans un seul PDF';

  @override
  String get addServiceRecord => 'Reçu d’entretien ou dépense';

  @override
  String get addServiceRecordHint => 'Pour ce véhicule';

  @override
  String get addTitle => 'Que voulez-vous ajouter ?';

  @override
  String get addVehicle => 'Ajouter un véhicule';

  @override
  String get addVehicleRecord => 'Entrée du véhicule';

  @override
  String get addVehicleRecordHint =>
      'Entretien, immatriculation, carburant, pneus…';

  @override
  String get addWalletCard => 'Ajouter une carte';

  @override
  String get addWalletCardHint => 'Carte de fidélité, réduction ou bon';

  @override
  String get address => 'Adresse';

  @override
  String get adsOffForPlan => 'Votre formule est sans publicité.';

  @override
  String get aiAnalyze => 'Analyse du document par l’IA';

  @override
  String get aiAnalyzeAgain => 'Analyser avec l’IA';

  @override
  String get aiAnalyzeHelp =>
      'L’IA propose le titre, la date, le montant et la catégorie. Vous confirmez avant tout enregistrement.';

  @override
  String get aiAndYourData => 'L’IA et vos données';

  @override
  String get aiAnswer => 'Réponse';

  @override
  String get aiDataNote =>
      'Quand vous utilisez l’IA, seul le nécessaire pour la demande est envoyé : le texte ou l’image d’un document pour l’analyse, ou de courtes métadonnées des éléments autorisés pour une question. Les documents du coffre ne sont jamais utilisés pour les questions. Les données ne servent pas à entraîner les modèles et ne sont pas conservées par le service d’IA.';

  @override
  String get aiExample1 => 'Quand expire la garantie de mon lave-linge ?';

  @override
  String get aiExample2 =>
      'Combien ai-je dépensé pour la voiture cette année ?';

  @override
  String get aiExample3 =>
      'Trouve les contrats qui expirent dans les trois prochains mois.';

  @override
  String get aiExample4 =>
      'Quels reçus ai-je pour des achats de plus de 200 euros ?';

  @override
  String get aiFilledCheck =>
      'Champs remplis. Vérifiez-les avant d’enregistrer.';

  @override
  String get aiHint => 'Posez une question sur vos données…';

  @override
  String get aiInsufficientNote =>
      'Je réponds uniquement à partir de vos données enregistrées. S’il manque quelque chose, ajoutez un document ou complétez les informations.';

  @override
  String get aiIntro =>
      'Posez des questions sur vos documents, objets, véhicules et échéances. Les réponses citent toujours leurs sources.';

  @override
  String aiIndexing(int ready, int total) {
    return 'L\'IA lit tes documents : $ready sur $total. Les réponses deviennent plus complètes au fur et à mesure.';
  }

  @override
  String get aiIndexingDeferred =>
      'La limite mensuelle de lecture des documents est atteinte. L\'IA lira le reste au début du mois prochain.';

  @override
  String get aiLimitsNote =>
      'La limite mensuelle évite les coûts imprévus. Elle est réinitialisée au début de chaque mois.';

  @override
  String get aiNoData =>
      'Je n’ai pas assez de données pour répondre à cette question.';

  @override
  String get aiNotInPlanHint =>
      'L’analyse par l’IA est disponible dans Individual Pro et Family Pro. Vous pouvez enregistrer et modifier le document manuellement.';

  @override
  String get aiPrivacyNote =>
      'L’IA ne voit que les éléments auxquels vous avez accès.';

  @override
  String get aiProcessing => 'L’IA traite le document…';

  @override
  String get aiRequestsThisMonth => 'Requêtes IA ce mois-ci';

  @override
  String get aiSearchLocked =>
      'La recherche IA en langage naturel est disponible dans les formules Pro';

  @override
  String get aiThinking => 'Recherche dans vos données…';

  @override
  String get aiUsage => 'Utilisation de l’IA et limites';

  @override
  String get aiVerifyNote =>
      'L’IA peut se tromper. Vérifiez les informations importantes dans la source.';

  @override
  String get all => 'Tout';

  @override
  String get allDocuments => 'Tous les documents';

  @override
  String get allItems => 'Tous les objets';

  @override
  String get allow => 'Autoriser';

  @override
  String get amount => 'Montant';

  @override
  String get analyticsConsent => 'Statistiques d’utilisation anonymes';

  @override
  String get analyticsConsentHelp =>
      'Nous aide à améliorer l’application. N’envoie jamais de contenu, de titres ni de données de documents.';

  @override
  String get anyTime => 'N’importe quand';

  @override
  String get appTitle => 'MyWorld+';

  @override
  String get appWorksWithoutAi =>
      'L’application fonctionne sans IA : enregistrement, consultation, recherche et rappels sont disponibles dans toutes les formules.';

  @override
  String get apply => 'Appliquer';

  @override
  String get areaBusinessCards => 'Mes cartes de visite';

  @override
  String get areaBusinessCardsSub => 'Cartes d’autres personnes';

  @override
  String get areaCar => 'Ma voiture';

  @override
  String get areaCarSub => 'Véhicules et frais';

  @override
  String get areaCards => 'Mes cartes';

  @override
  String get areaCardsSub => 'Réductions et bons';

  @override
  String get areaDocuments => 'Mes documents';

  @override
  String get areaDocumentsSub => 'Archive centrale';

  @override
  String get areaFamily => 'Ma famille';

  @override
  String get areaFamilySub => 'Espace familial';

  @override
  String get areaHobby => 'Mon hobby';

  @override
  String get areaHobbySub => 'Équipement et collections';

  @override
  String get areaHome => 'Ma maison';

  @override
  String get areaHomeSub => 'Les objets de la maison';

  @override
  String get areaLife => 'Ma vie';

  @override
  String get areaLifeSub => 'Échéances et obligations';

  @override
  String get askAi => 'Demander à l’IA';

  @override
  String get askAiInstead => 'Demander à l’assistant IA';

  @override
  String get assignedItems => 'Objets attribués';

  @override
  String get atTime => 'À l’échéance';

  @override
  String get attachReceipt => 'Scanner le reçu';

  @override
  String get back => 'Retour';

  @override
  String get backToSignIn => 'Retour à la connexion';

  @override
  String get balance => 'Solde';

  @override
  String get barcodeFormat => 'Format du code';

  @override
  String get barcodeInvalid => 'Le code n’est pas valide pour le format choisi';

  @override
  String get barcodeValue => 'Valeur du code';

  @override
  String get billingIssueBody =>
      'Le paiement a échoué. Vérifiez votre moyen de paiement dans le store pour conserver vos fonctionnalités.';

  @override
  String get billingNotConfigured =>
      'Les achats sont actuellement indisponibles sur cet appareil.';

  @override
  String get brand => 'Marque';

  @override
  String get brandModel => 'Marque et modèle';

  @override
  String get byCategory => 'Par catégorie';

  @override
  String get cancel => 'Annuler';

  @override
  String get cardCoupon => 'Bon';

  @override
  String get cardDiscount => 'Réduction';

  @override
  String get cardGift => 'Carte cadeau';

  @override
  String get cardLoyalty => 'Fidélité';

  @override
  String get cardMembership => 'Adhésion';

  @override
  String get cardName => 'Nom';

  @override
  String get cardNameHelp => 'Par ex. le nom d’un magasin ou d’une pharmacie';

  @override
  String get cardNumber => 'Numéro de carte';

  @override
  String get cardOther => 'Autre';

  @override
  String get categories => 'Catégories';

  @override
  String get category => 'Catégorie';

  @override
  String get changePhoto => 'Changer la photo';

  @override
  String get changePlan => 'Changer de formule';

  @override
  String get channelLocal => 'Notification sur l’appareil';

  @override
  String get channelLocalHelp => 'Fonctionne hors ligne';

  @override
  String get channelPush => 'Notification push';

  @override
  String get channelPushHelp => 'Arrive même si l’application est fermée';

  @override
  String get checkThisField => 'Vérifiez ce champ';

  @override
  String get chooseCurrency => 'Choisir une devise';

  @override
  String get chooseFromGallery => 'Choisir dans la galerie';

  @override
  String get choosePlan => 'Choisir une formule';

  @override
  String get chooseVehicle => 'Choisir un véhicule';

  @override
  String get clear => 'Effacer';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get close => 'Fermer';

  @override
  String get code => 'Code';

  @override
  String get color => 'Couleur';

  @override
  String get company => 'Entreprise';

  @override
  String get confirmAndSave => 'Confirmer et enregistrer';

  @override
  String get confirmDateHint => 'Vérifiez la date avant d’enregistrer.';

  @override
  String get contactSupport => 'Contacter le support';

  @override
  String get contextSection => 'Contexte';

  @override
  String get continueApple => 'Continuer avec Apple';

  @override
  String get continueGoogle => 'Continuer avec Google';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get copied => 'Copié';

  @override
  String get copy => 'Copier';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get createFamily => 'Créer une famille';

  @override
  String get createInviteLink => 'Créer un lien d’invitation';

  @override
  String get createReminder => 'Créer un rappel';

  @override
  String get currency => 'Devise';

  @override
  String get currentMileage => 'Kilométrage actuel';

  @override
  String get currentMileageKm => 'Kilométrage actuel (km)';

  @override
  String get currentPlan => 'Actuelle';

  @override
  String get date => 'Date';

  @override
  String get dateOptions =>
      'Le document contient plusieurs dates — choisissez la bonne :';

  @override
  String get decline => 'Refuser';

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get deleteAccountForever => 'Supprimer définitivement le compte';

  @override
  String get deleteCancelStoreFirst =>
      'Votre abonnement est géré par l’App Store / Google Play. Résiliez-le là-bas pour ne plus être facturé après la suppression du compte.';

  @override
  String get deleteCard => 'Supprimer la carte';

  @override
  String get deleteCardBody => 'La carte et ses photos seront supprimées.';

  @override
  String get deleteCategory => 'Supprimer la catégorie';

  @override
  String get deleteCategoryBody =>
      'Les documents restent enregistrés ; ils perdent seulement cette catégorie.';

  @override
  String get deleteConsequences =>
      'Tous vos documents, fichiers, objets, véhicules, cartes, contacts et rappels sont supprimés. Vous perdez l’accès à l’espace familial. Cette action est irréversible.';

  @override
  String get deleteConsequencesTitle => 'Ce qui va se passer';

  @override
  String get deleteContact => 'Supprimer le contact';

  @override
  String get deleteContactBody =>
      'La carte de visite et les photos seront supprimées.';

  @override
  String get deleteForever => 'Supprimer définitivement';

  @override
  String get deleteForeverBody =>
      'Le fichier sera définitivement supprimé et ne pourra pas être restauré.';

  @override
  String get deleteItem => 'Supprimer l’objet';

  @override
  String get deleteItemBody =>
      'L’objet est supprimé. Les documents liés restent dans votre archive.';

  @override
  String get deleteProfile => 'Supprimer le profil';

  @override
  String get deleteProfileBody =>
      'Le profil est supprimé. Les documents restent, ils perdent seulement le lien.';

  @override
  String get deleteRecord => 'Supprimer l’entrée';

  @override
  String get deleteRecordBody =>
      'L’entrée sera supprimée. Les reçus joints restent dans votre archive.';

  @override
  String get deleteReminder => 'Supprimer le rappel';

  @override
  String get deleteReminderBody => 'Le rappel n’enverra plus de notifications.';

  @override
  String get deleteVehicle => 'Supprimer le véhicule';

  @override
  String get deleteVehicleBody =>
      'Le véhicule et ses entrées sont supprimés. Les reçus restent dans votre archive.';

  @override
  String get deleteWord => 'SUPPRIMER';

  @override
  String get description => 'Description';

  @override
  String get details => 'Détails';

  @override
  String get disableLock => 'Désactiver le verrouillage';

  @override
  String get discount => 'Réduction';

  @override
  String get discountHelp => 'Par ex. 10 % sur les cosmétiques';

  @override
  String get discountText => 'Description de la réduction';

  @override
  String get displayName => 'Nom ou surnom';

  @override
  String get dissolveBody =>
      'L’espace familial est fermé. Vos documents restent mais deviennent privés.';

  @override
  String get dissolveFamily => 'Fermer la famille';

  @override
  String get dissolveHelp =>
      'En tant que propriétaire, vous pouvez fermer la famille lorsqu’il n’y a plus d’autres membres.';

  @override
  String get docNotAvailable =>
      'Le document n’existe pas ou vous n’y avez pas accès.';

  @override
  String get documentDate => 'Date du document';

  @override
  String get documentSaved => 'Document enregistré';

  @override
  String get documentSavedAi =>
      'L’IA traite le document. Les suggestions apparaîtront pour vérification.';

  @override
  String get documents => 'Documents';

  @override
  String get done => 'Terminé';

  @override
  String get downgradePolicy =>
      'Si vous passez à une formule inférieure, aucun fichier n’est supprimé automatiquement. Si vous dépassez la limite, les documents restent consultables et exportables, mais vous ne pouvez pas en ajouter tant que vous n’avez pas libéré de l’espace ou choisi une formule supérieure.';

  @override
  String get dueDate => 'Date d’échéance';

  @override
  String get duplicateTitle => 'Doublon possible';

  @override
  String get edit => 'Modifier';

  @override
  String get editCard => 'Modifier la carte';

  @override
  String get editContact => 'Modifier le contact';

  @override
  String get editDetails => 'Modifier les détails';

  @override
  String get editDocument => 'Modifier le document';

  @override
  String get editItem => 'Modifier l’objet';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get editRecord => 'Modifier l’entrée';

  @override
  String get editReminder => 'Modifier le rappel';

  @override
  String get editVehicle => 'Modifier le véhicule';

  @override
  String get email => 'E-mail';

  @override
  String get emailChannelNote =>
      'Les notifications par e-mail ne sont pas encore activées.';

  @override
  String get emailOptional => 'E-mail (facultatif)';

  @override
  String get emailSent => 'E-mail envoyé';

  @override
  String get emailsOnePerLine => 'E-mails (un par ligne)';

  @override
  String get enableLock => 'Activer le verrouillage';

  @override
  String get errAiFailed =>
      'L’IA ne peut pas traiter la demande pour le moment. Vos données sont en sécurité — réessayez plus tard.';

  @override
  String get errAiLimit =>
      'Limite de requêtes IA atteinte. Réessayez plus tard ou consultez votre utilisation.';

  @override
  String get errAiNotInPlan =>
      'L’IA est disponible dans Individual Pro et Family Pro.';

  @override
  String get errAlreadyInFamily => 'Vous faites déjà partie d’une famille.';

  @override
  String get errCancelled => 'Action annulée.';

  @override
  String get errDocumentLimit =>
      'Vous avez atteint la limite de documents de votre formule.';

  @override
  String get errEmailInUse => 'Un compte existe déjà avec cet e-mail.';

  @override
  String get errEmailNotVerified =>
      'E-mail pas encore vérifié. Consultez votre boîte de réception.';

  @override
  String get errFamilyFull => 'La famille est complète pour votre formule.';

  @override
  String get errFamilyHasMembers =>
      'Retirez d’abord les autres membres de la famille.';

  @override
  String get errFamilyPlan => 'Cela nécessite une formule Family.';

  @override
  String get errFileTooLarge => 'Le fichier est trop volumineux (25 Mo max.).';

  @override
  String get errGeneric => 'Une erreur s’est produite. Veuillez réessayer.';

  @override
  String get errInvalidEmail => 'Saisissez une adresse e-mail valide.';

  @override
  String get errInvitationEmail =>
      'Cette invitation a été envoyée à une autre adresse e-mail.';

  @override
  String get errInvitationExpired =>
      'L’invitation a expiré. Demandez-en une nouvelle.';

  @override
  String get errInvitationInvalid =>
      'L’invitation n’est pas valide ou a déjà été utilisée.';

  @override
  String get errNetwork =>
      'Pas de connexion Internet. Les modifications seront synchronisées dès votre retour en ligne.';

  @override
  String get errNotFound => 'Le contenu demandé est introuvable.';

  @override
  String get errPermission => 'Vous n’avez pas l’autorisation pour cela.';

  @override
  String get errRecentLogin => 'Par sécurité, veuillez vous reconnecter.';

  @override
  String get errSession => 'Votre session a expiré. Veuillez vous reconnecter.';

  @override
  String get errStorageLimit =>
      'Espace de stockage insuffisant dans votre formule.';

  @override
  String get errTitle => 'Oups';

  @override
  String get errTooMany =>
      'Trop de tentatives. Patientez un instant et réessayez.';

  @override
  String get errUnavailable =>
      'Le service est temporairement indisponible. Réessayez dans une minute.';

  @override
  String get errUnsupportedFile =>
      'Ce type de fichier n’est pas pris en charge. Utilisez PDF, JPG, PNG ou HEIC.';

  @override
  String get errUserNotFound => 'Aucun compte avec cet e-mail.';

  @override
  String get errWeakPassword => 'Le mot de passe est trop faible.';

  @override
  String get errWrongPassword => 'E-mail ou mot de passe incorrect.';

  @override
  String get expenses => 'Dépenses';

  @override
  String get expired => 'Expiré';

  @override
  String get expiryDate => 'Valable jusqu’au';

  @override
  String get exportAdvancedIncluded =>
      'Votre formule inclut aussi des tableaux CSV (documents, objets, frais de véhicule).';

  @override
  String get exportBasicOnly =>
      'L’export contient un fichier JSON avec toutes les données et les fichiers originaux. Les tableaux CSV font partie des formules Pro.';

  @override
  String get exportBody =>
      'Nous créons une archive ZIP avec tous vos documents, photos, métadonnées, objets, véhicules, rappels et les liens entre eux.';

  @override
  String get exportData => 'Exporter les données';

  @override
  String get exportFamilyNote =>
      'L’export ne contient que les éléments dont vous êtes propriétaire. Chaque membre de la famille exporte ses propres données.';

  @override
  String get exportFirst => 'Exporter d’abord les données';

  @override
  String get exportWait =>
      'Cela peut prendre quelques minutes si vous avez beaucoup de fichiers.';

  @override
  String get familyDeadlines => 'Échéances familiales';

  @override
  String get familyIntro =>
      'Un espace familial offre des documents partagés, des profils de membres et des échéances communes. Chaque document garde sa propre confidentialité.';

  @override
  String get familyInvitation => 'Invitation familiale';

  @override
  String get familyName => 'Nom de la famille';

  @override
  String get familyPermissions => 'Rôles et autorisations';

  @override
  String get familyPlanLapsed =>
      'La formule Family n’est pas active. Les données existantes restent disponibles, mais aucune nouvelle invitation n’est possible.';

  @override
  String get familyPlanOnly => 'Disponible dans les formules Family';

  @override
  String get familyProfiles => 'Profils du foyer';

  @override
  String get familyProfilesHelp =>
      'Pour les membres sans compte, par ex. les enfants.';

  @override
  String get familySettings => 'Paramètres de la famille';

  @override
  String get faq1a =>
      'Par défaut, vous seul. Un document devient visible pour les membres de la famille seulement si vous changez sa confidentialité en « Sélection » ou « Famille ».';

  @override
  String get faq1q => 'Qui peut voir mes documents ?';

  @override
  String get faq2a =>
      'Rien n’est supprimé. Tout reste consultable et exportable ; vous pourrez ajouter de nouveaux fichiers après avoir libéré de l’espace ou changé de formule.';

  @override
  String get faq2q => 'Que se passe-t-il si je dépasse mon stockage ?';

  @override
  String get faq3a =>
      'Oui. C’est pourquoi les données de l’IA sont des suggestions que vous confirmez, et les réponses citent toujours leurs sources.';

  @override
  String get faq3q => 'L’IA peut-elle se tromper ?';

  @override
  String get faq4a =>
      'Vous gérez votre abonnement dans les réglages de l’App Store ou de Google Play. L’accès reste actif jusqu’à la fin de la période payée.';

  @override
  String get faq4q => 'Comment résilier mon abonnement ?';

  @override
  String get faq5a =>
      'Non. Le PIN et la biométrie ajoutent une protection à l’écran. Les fichiers sont protégés par des règles d’accès côté serveur et chiffrés en transit et au repos par Google Cloud.';

  @override
  String get faq5q => 'Le PIN du coffre est-il un chiffrement ?';

  @override
  String get favorites => 'Favoris';

  @override
  String get favoritesOnly => 'Favoris uniquement';

  @override
  String get featureAds => 'Avec publicités';

  @override
  String get featureAi => 'Extraction, catégorisation et questions par l’IA';

  @override
  String get featureNoAds => 'Sans publicité';

  @override
  String get featureNoAi => 'Pas de fonctions IA';

  @override
  String get featureReminders => 'Rappels et notifications';

  @override
  String get featureScan => 'Numérisation et import';

  @override
  String get fileInfo => 'Fichier';

  @override
  String get fileType => 'Type de fichier';

  @override
  String get filters => 'Filtres';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get free => 'Gratuit';

  @override
  String get front => 'Recto';

  @override
  String get fuelType => 'Carburant / motorisation';

  @override
  String get fullName => 'Nom complet';

  @override
  String get getStarted => 'Commencer';

  @override
  String get goHome => 'Aller à l’accueil';

  @override
  String get gridView => 'Vue grille';

  @override
  String get haveAccount => 'J’ai déjà un compte';

  @override
  String get haveInvitationHint =>
      'Vous avez une invitation ? Ouvrez le lien du message et acceptez-la.';

  @override
  String get help => 'Aide et support';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get howWeProtect => 'Comment nous protégeons vos données';

  @override
  String get iVerified => 'J’ai vérifié mon e-mail';

  @override
  String get ignoreSuggestions => 'Ignorer les suggestions';

  @override
  String get image => 'Image';

  @override
  String get importantReminders => 'Rappels importants';

  @override
  String get injectionWarning =>
      'Le document contient un texte qui ressemble à des instructions pour l’IA. Il a été ignoré, mais vérifiez attentivement les suggestions.';

  @override
  String get invalidAmount => 'Montant non valide';

  @override
  String get invalidValue => 'Valeur non valide';

  @override
  String get invalidVin => 'Un VIN comporte 17 caractères (sans I, O, Q)';

  @override
  String get invitationDeclined => 'Invitation refusée';

  @override
  String get invite => 'Inviter';

  @override
  String get inviteEmailHelp =>
      'Si vous saisissez un e-mail, seule une personne avec cette adresse vérifiée pourra accepter.';

  @override
  String get inviteExpiresNote =>
      'Le lien est valable 7 jours et ne peut être utilisé qu’une seule fois.';

  @override
  String get inviteHelp =>
      'Créez un lien d’invitation sécurisé et envoyez-le à un membre de la famille. Les membres n’ont pas automatiquement accès à vos documents.';

  @override
  String get inviteLink => 'Lien d’invitation';

  @override
  String get inviteMember => 'Inviter un membre';

  @override
  String get inviteReady => 'Invitation prête';

  @override
  String get issuer => 'Émetteur / magasin';

  @override
  String get items => 'Objets';

  @override
  String get jobTitle => 'Poste';

  @override
  String get joinedFamily => 'Vous avez rejoint la famille';

  @override
  String get kindAnniversary => 'Anniversaire';

  @override
  String get kindContract => 'Contrat';

  @override
  String get kindCustom => 'Autre';

  @override
  String get kindDocument => 'Document';

  @override
  String get kindInsurance => 'Assurance';

  @override
  String get kindRegistration => 'Immatriculation';

  @override
  String get kindService => 'Entretien';

  @override
  String get kindSubscription => 'Abonnement / adhésion';

  @override
  String get kindWarranty => 'Garantie';

  @override
  String get langEnglish => 'Anglais';

  @override
  String get langFrench => 'Français';

  @override
  String get langGerman => 'Allemand';

  @override
  String get langSpanish => 'Espagnol';

  @override
  String get langRussian => 'Russe';

  @override
  String get langSerbian => 'Serbe';

  @override
  String get language => 'Langue';

  @override
  String get largestFiles => 'Fichiers les plus volumineux';

  @override
  String get last30Days => '30 derniers jours';

  @override
  String get lastMileage => 'Dernier kilométrage';

  @override
  String get lastYear => 'L’an dernier';

  @override
  String get later => 'Plus tard';

  @override
  String get leaveFamily => 'Quitter la famille';

  @override
  String get leaveFamilyBody =>
      'Vous perdez l’accès aux documents de la famille. Vos documents restent les vôtres et deviennent privés.';

  @override
  String get leaveFamilyTitle => 'Quitter la famille ?';

  @override
  String get legal => 'Mentions légales';

  @override
  String get legalSummary =>
      'MyWorld+ conserve vos données uniquement pour fournir le service. Nous ne vendons pas de données, n’utilisons pas le contenu des documents pour la publicité et n’entraînons pas de modèles sur vos documents. Vous pouvez exporter ou supprimer vos données à tout moment.';

  @override
  String get lifeIntro =>
      'Abonnements, polices, échéances de contrats, adhésions, anniversaires et autres dates importantes.';

  @override
  String get limitReachedBody =>
      'Rien n’a été supprimé. Tous vos éléments restent consultables et exportables. Pour en ajouter, libérez de l’espace (videz la corbeille, supprimez ce qui est inutile) ou choisissez une formule supérieure.';

  @override
  String get limitReachedTitle => 'Limite de la formule atteinte';

  @override
  String get linkedDocument => 'Document lié';

  @override
  String get linkedDocumentOptional => 'Document lié (facultatif)';

  @override
  String get linkedItem => 'Objet lié';

  @override
  String get links => 'Liens';

  @override
  String get linksHelp =>
      'Liez le document à des objets, véhicules ou membres. Le fichier n’est pas copié.';

  @override
  String get listView => 'Vue liste';

  @override
  String get loading => 'Chargement…';

  @override
  String get location => 'Emplacement à la maison';

  @override
  String get locationHelp => 'Par ex. cuisine, cave';

  @override
  String get lockEnabled => 'Le verrouillage est activé';

  @override
  String get lockNow => 'Verrouiller maintenant';

  @override
  String get lockedFeature => 'Verrouillé';

  @override
  String get maintenanceHistory => 'Réparations et entretien';

  @override
  String get make => 'Constructeur';

  @override
  String get manage => 'Gérer';

  @override
  String get manageInStore => 'Gérer dans le store';

  @override
  String get manageSubscription => 'Abonnement';

  @override
  String get markDone => 'Marquer comme fait';

  @override
  String get markDoneNext => 'Fait — passer à la date suivante';

  @override
  String get markUsed => 'Marquer comme utilisé';

  @override
  String get member => 'Membre';

  @override
  String get memberVisibleNote =>
      'Vous ne voyez que ce que ce membre a partagé avec vous ou la famille.';

  @override
  String get members => 'Membres';

  @override
  String get metAt => 'Date de rencontre';

  @override
  String get metWhere => 'Lieu de rencontre';

  @override
  String get mileage => 'Kilométrage';

  @override
  String get mileageHistory => 'Historique du kilométrage';

  @override
  String get mileageKm => 'Kilométrage (km)';

  @override
  String get minor => 'Mineur';

  @override
  String get minorHelp =>
      'Le profil d’un enfant n’est pas un compte et ne peut pas se connecter.';

  @override
  String get model => 'Modèle';

  @override
  String get more => 'Plus';

  @override
  String get moveToTrash => 'Mettre à la corbeille';

  @override
  String get moveToTrashBody =>
      'Vous pouvez restaurer le document depuis la corbeille pendant 30 jours.';

  @override
  String get movedToTrash => 'Mis à la corbeille';

  @override
  String get multiCurrencyNote =>
      'Les montants en devises différentes ne sont pas additionnés.';

  @override
  String get myAreas => 'Mes espaces';

  @override
  String get name => 'Nom';

  @override
  String get nameOrCompanyRequired => 'Saisissez un nom ou une entreprise';

  @override
  String get navAdd => 'Ajouter';

  @override
  String get navHome => 'Accueil';

  @override
  String get navVault => 'Coffre';

  @override
  String get navWorld => 'Mon monde';

  @override
  String get next => 'Suivant';

  @override
  String get next6Months => '6 prochains mois';

  @override
  String get nextDueDate => 'Prochaine échéance';

  @override
  String get nextDueHelp =>
      'À remplir seulement si vous la connaissez (par ex. sur le reçu ou selon la recommandation du garage).';

  @override
  String get nextDueMileage => 'Prochain entretien à km';

  @override
  String get nextDueSection => 'Prochaine échéance';

  @override
  String get noAccount => 'Pas de compte ? Inscrivez-vous';

  @override
  String get noAssignedItems => 'Aucun objet attribué.';

  @override
  String get noCards => 'Aucune carte pour l’instant';

  @override
  String get noCardsHint =>
      'Enregistrez cartes de fidélité, réductions et bons pour toujours les avoir sur vous.';

  @override
  String get noContacts => 'Aucune carte de visite pour l’instant';

  @override
  String get noContactsHint =>
      'Photographiez une carte de visite et enregistrez le contact en quelques secondes.';

  @override
  String get noDeadlines => 'Aucune échéance dans les 6 prochains mois';

  @override
  String get noDocuments => 'Aucun document pour l’instant';

  @override
  String get noDocumentsCta =>
      'Ajoutez votre premier document — scannez un reçu ou une garantie.';

  @override
  String get noDocumentsHint =>
      'Scannez ou importez un document pour le conserver ici.';

  @override
  String get noExpenses => 'Aucune dépense pour l’instant';

  @override
  String get noFamilyDeadlines => 'Aucune échéance partagée.';

  @override
  String get noInventedIntervals =>
      'MyWorld+ ne suppose aucun intervalle d’entretien — il affiche uniquement les dates que vous avez saisies.';

  @override
  String get noItems => 'Aucun objet pour l’instant';

  @override
  String get noItemsHint =>
      'Ajoutez un appareil ou un objet et liez son reçu et sa garantie.';

  @override
  String get noLinkTargets => 'Aucun objet, véhicule ou profil à lier.';

  @override
  String get noLinkedDocs => 'Aucun document lié.';

  @override
  String get noLinks => 'Ce document n’est lié à rien.';

  @override
  String get noMaintenance => 'Aucune entrée d’entretien';

  @override
  String get noMaintenanceHint =>
      'Ajoutez un reçu de réparation ou d’entretien lié à l’objet.';

  @override
  String get noMileage => 'Aucun kilométrage enregistré';

  @override
  String get noNotifications => 'Aucune nouvelle notification';

  @override
  String get noRecordYet => 'Aucune entrée pour l’instant.';

  @override
  String get noRecords => 'Aucune entrée pour l’instant';

  @override
  String get noReminders => 'Aucun rappel';

  @override
  String get noRemindersCta =>
      'Ajoutez votre premier rappel — immatriculation, garantie, contrat…';

  @override
  String get noRemindersHint =>
      'Les rappels vous préviennent à temps des échéances importantes.';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noResultsFiltered => 'Aucun document ne correspond aux filtres.';

  @override
  String get noResultsHint =>
      'Essayez un autre terme, effacez les filtres ou ajoutez un document.';

  @override
  String get noSharedDocs => 'Aucun document partagé.';

  @override
  String get noSharedDocsHint =>
      'Changez la confidentialité d’un document en « Famille » ou « Sélection » pour que d’autres le voient.';

  @override
  String get noSuggestions => 'Aucune suggestion de l’IA';

  @override
  String get noSuggestionsBody =>
      'Il n’y a pas encore de suggestion pour ce document.';

  @override
  String get noVehicles => 'Aucun véhicule pour l’instant';

  @override
  String get noVehiclesHint =>
      'Ajoutez un véhicule pour suivre l’historique d’entretien, les frais et les échéances.';

  @override
  String get noWarrantyDate => 'Aucune date de fin de garantie saisie';

  @override
  String get noWarrantyFound =>
      'Aucune information de garantie n’a été trouvée sur le document. Nous ne supposons aucune durée de garantie.';

  @override
  String get none => 'Aucun';

  @override
  String get notAvailable => 'Non disponible ou pas d’accès.';

  @override
  String get notSet => 'non défini';

  @override
  String get notes => 'Notes';

  @override
  String get notificationChannels => 'Canaux de notification';

  @override
  String get notificationGenericBody =>
      'Vous avez un rappel qui demande votre attention.';

  @override
  String get notificationTitle => 'Rappel MyWorld+';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsAllowed => 'Les notifications sont autorisées';

  @override
  String get notificationsBlocked => 'Les notifications ne sont pas autorisées';

  @override
  String get notifyBefore => 'Me prévenir';

  @override
  String get offlineBanner =>
      'Hors ligne — les modifications seront synchronisées plus tard';

  @override
  String get onboarding1Body =>
      'Documents, reçus, garanties, objets, véhicules et famille — bien organisés.';

  @override
  String get onboarding1Title => 'Tout ce qui compte, au même endroit.';

  @override
  String get onboarding2Body =>
      'Prenez une photo et nous créons un PDF propre.';

  @override
  String get onboarding2Title =>
      'Enregistrez documents, reçus et garanties en quelques secondes.';

  @override
  String get onboarding3Body =>
      'Recherche rapide et rappels pour les échéances importantes.';

  @override
  String get onboarding3Title => 'Trouvez ce qu’il vous faut, au bon moment.';

  @override
  String get open => 'Ouvrir';

  @override
  String get openDocument => 'Ouvrir le document';

  @override
  String get openPreview => 'Ouvrir l’aperçu';

  @override
  String get openSourceLicenses => 'Licences open source';

  @override
  String get openingCamera => 'Ouverture de l’appareil photo…';

  @override
  String get optionalDetails => 'Informations supplémentaires (facultatif)';

  @override
  String get orContinueWith => 'ou';

  @override
  String get overdue => 'En retard';

  @override
  String get ownerCannotLeave =>
      'Le propriétaire ne peut pas partir tant qu’il reste d’autres membres. Retirez-les d’abord.';

  @override
  String get pageNotFound => 'Cette page n’existe pas.';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHelp => 'Au moins 8 caractères, lettres et chiffres';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get passwordWeak =>
      'Le mot de passe doit contenir des lettres et des chiffres';

  @override
  String get pendingInvites => 'Invitations en attente';

  @override
  String get period => 'Période';

  @override
  String get permissionDeniedTitle => 'Pas d’accès';

  @override
  String get permissionsExplainer =>
      'Les rôles déterminent qui gère la famille (invitations, profils). Un rôle ne donne jamais accès aux documents d’autrui — c’est la confidentialité de chaque document qui en décide.';

  @override
  String get phonesOnePerLine => 'Téléphones (un par ligne)';

  @override
  String get photos => 'Photos';

  @override
  String get pin => 'PIN';

  @override
  String get pinHelp => '4 à 8 chiffres';

  @override
  String get pinMismatch => 'Les PIN ne correspondent pas';

  @override
  String get pinNew => 'Nouveau PIN';

  @override
  String get pinRepeat => 'Répéter le PIN';

  @override
  String get planFamilyBase => 'Family Base';

  @override
  String get planFamilyPro => 'Family Pro';

  @override
  String get planFromFamily => 'Formule fournie par votre famille';

  @override
  String get planIndividualBase => 'Individual Base';

  @override
  String get planIndividualPro => 'Individual Pro';

  @override
  String get plansSubtitle =>
      'Choisissez la formule qui vous convient. Modifiable ou résiliable à tout moment.';

  @override
  String get plansTitle => 'Formules';

  @override
  String get price => 'Prix';

  @override
  String get privacy => 'Qui peut voir';

  @override
  String get privacyBullets =>
      '• Tous les fichiers sont privés et accessibles uniquement après vérification d’accès côté serveur.\n• Les membres de la famille ne voient que ce que vous partagez explicitement.\n• Le contenu des documents n’est jamais envoyé aux statistiques, aux journaux ni aux régies publicitaires.\n• La suppression de votre compte supprime réellement les données sur le serveur.';

  @override
  String get privacyFamily => 'Famille';

  @override
  String get privacyFamilyHelp =>
      'Tous les membres actifs de votre famille peuvent le voir.';

  @override
  String get privacyNoFamilyHelp =>
      'Le partage est disponible quand vous faites partie d’une famille.';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPrivate => 'Privé';

  @override
  String get privacyPrivateHelp => 'Vous seul pouvez le voir.';

  @override
  String get privacySettings => 'Confidentialité';

  @override
  String get privacyShared => 'Sélection';

  @override
  String get privacySharedHelp =>
      'Seuls les membres que vous sélectionnez peuvent le voir.';

  @override
  String get processingStatus => 'Statut du traitement';

  @override
  String get profile => 'Profil';

  @override
  String get profileSetupBody =>
      'Juste quelques informations. Nous ne demandons rien de sensible.';

  @override
  String get profileSetupTitle => 'Votre profil';

  @override
  String get purchaseDate => 'Date d’achat';

  @override
  String get purchaseDetails => 'Achat';

  @override
  String get purchaseProcessed => 'Achat traité. Mise à jour de votre formule…';

  @override
  String get reactivate => 'Réactiver';

  @override
  String get readCardWithAi => 'Lire la carte avec l’IA';

  @override
  String get recFuel => 'Carburant';

  @override
  String get recInspection => 'Contrôle technique';

  @override
  String get recInsurance => 'Assurance';

  @override
  String get recOil => 'Vidange';

  @override
  String get recOther => 'Autre';

  @override
  String get recParking => 'Stationnement';

  @override
  String get recParts => 'Pièces';

  @override
  String get recRegistration => 'Immatriculation';

  @override
  String get recRepair => 'Réparation';

  @override
  String get recService => 'Entretien courant';

  @override
  String get recTires => 'Pneus';

  @override
  String get recTolls => 'Péages';

  @override
  String get receipts => 'Reçus';

  @override
  String get receiptsAndWarranties => 'Reçus et garanties';

  @override
  String get recentRecords => 'Entrées récentes';

  @override
  String get recentlyAdded => 'Ajoutés récemment';

  @override
  String get recordType => 'Type d’entrée';

  @override
  String get refreshStatus => 'Actualiser le statut de l’abonnement';

  @override
  String get registrationInsurance => 'Immatriculation et assurance';

  @override
  String get registrationNumber => 'Plaque d’immatriculation';

  @override
  String get relationshipOptional => 'Lien de parenté (facultatif)';

  @override
  String get remindBeforeExpiry => 'Me rappeler avant l’expiration';

  @override
  String get reminder => 'Rappel';

  @override
  String get reminderSaved => 'Rappel enregistré';

  @override
  String get reminderSettings => 'Paramètres des rappels';

  @override
  String get reminderType => 'Type';

  @override
  String get reminders => 'Rappels';

  @override
  String get removeAds => 'Supprimer les publicités';

  @override
  String get removeFavorite => 'Retirer des favoris';

  @override
  String get removeMember => 'Retirer le membre';

  @override
  String get removeMemberBody =>
      'Le membre perd immédiatement l’accès aux documents familiaux et partagés. Ses propres documents restent les siens.';

  @override
  String get renewsOn => 'Renouvellement le';

  @override
  String get repeat => 'Répéter';

  @override
  String get repeatDaily => 'Tous les jours';

  @override
  String get repeatMonthly => 'Tous les mois';

  @override
  String get repeatNone => 'Ne se répète pas';

  @override
  String get repeatWeekly => 'Toutes les semaines';

  @override
  String get repeatYearly => 'Tous les ans';

  @override
  String get required => 'Obligatoire';

  @override
  String get resendEmail => 'Renvoyer l’e-mail';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordBody =>
      'Saisissez votre e-mail et nous vous enverrons un lien pour définir un nouveau mot de passe.';

  @override
  String get resetSentBody =>
      'Si le compte existe, un lien a été envoyé. Vérifiez aussi vos spams.';

  @override
  String get resetSentTitle => 'Consultez vos e-mails';

  @override
  String get restore => 'Restaurer';

  @override
  String get restoreDone => 'Achats vérifiés';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get restored => 'Restauré';

  @override
  String get retake => 'Reprendre';

  @override
  String get retry => 'Réessayer';

  @override
  String get reviewSuggestions => 'Vérifier les suggestions de l’IA';

  @override
  String get revoke => 'Révoquer';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Membre';

  @override
  String get roleOwner => 'Propriétaire';

  @override
  String get rotate => 'Pivoter';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveAnyway => 'Enregistrer quand même';

  @override
  String get saveDocumentTitle => 'Enregistrer le document';

  @override
  String get saveToVault => 'Enregistrer dans le coffre';

  @override
  String get saveToVaultHelp =>
      'Pour les documents personnels particulièrement importants. Jamais utilisés dans les questions à l’IA.';

  @override
  String get saved => 'Enregistré';

  @override
  String get scanBarcode => 'Scanner un code-barres / QR';

  @override
  String get scanBarcodeHelp =>
      'Pointez l’appareil photo vers le code-barres ou le QR code';

  @override
  String get scanReviewHelp =>
      'Vérifiez les pages. Vous pouvez les faire pivoter, les reprendre, les supprimer ou les faire glisser pour les réordonner.';

  @override
  String get search => 'Recherche';

  @override
  String get searchCards => 'Rechercher des cartes';

  @override
  String get searchContacts => 'Rechercher des contacts';

  @override
  String get searchHint => 'Que cherchez-vous aujourd’hui ?';

  @override
  String get searchItems => 'Rechercher des objets';

  @override
  String get searchStartBody =>
      'Recherchez par nom, catégorie, vendeur, personne, appareil, montant ou étiquette.';

  @override
  String get searchStartTitle => 'Commencez à taper';

  @override
  String get searchVault => 'Rechercher dans le coffre';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get seePlans => 'Voir les formules';

  @override
  String get send => 'Envoyer';

  @override
  String get sendLink => 'Envoyer le lien';

  @override
  String get serialNumber => 'Numéro de série';

  @override
  String get serviceHistory => 'Historique d’entretien';

  @override
  String get serviceOrVendor => 'Garage ou vendeur';

  @override
  String get sessionExpiredBody =>
      'Pour votre sécurité, veuillez vous reconnecter.';

  @override
  String get sessionExpiredTitle => 'Session expirée';

  @override
  String get setPin => 'Définir un PIN pour le coffre';

  @override
  String get settings => 'Paramètres';

  @override
  String get share => 'Partager';

  @override
  String get shareFile => 'Exporter le fichier';

  @override
  String get sharedByMe => 'Partagés par moi';

  @override
  String get sharedDocuments => 'Documents partagés';

  @override
  String get sharedWithMe => 'Partagés avec moi';

  @override
  String get sharing => 'Partage et confidentialité';

  @override
  String get sharingNeedsFamily =>
      'Avec les formules Family, vous pouvez partager des documents avec les membres de la famille.';

  @override
  String get sharingServerNote =>
      'L’accès est vérifié sur le serveur pour chaque document et fichier. Lorsque vous retirez l’accès à quelqu’un, il le perd immédiatement.';

  @override
  String get sharingUpdated => 'Partage mis à jour';

  @override
  String get showCompleted => 'Afficher les terminés';

  @override
  String get showDetailsHelp =>
      'Désactivé : l’écran de verrouillage indique seulement que vous avez un rappel. Activé : le titre du rappel s’affiche.';

  @override
  String get showDetailsInNotifications =>
      'Afficher le titre dans la notification';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get showUsedExpired => 'Afficher les utilisés et expirés';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signInTitle => 'Bon retour';

  @override
  String get signInAsTester => 'Se connecter en tant que testeur';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signUpTitle => 'Créez votre MyWorld+';

  @override
  String get skip => 'Passer';

  @override
  String get snoozeWeek => 'Reporter d’une semaine';

  @override
  String get soon => 'Bientôt';

  @override
  String get sortAmountAsc => 'Montant le plus bas';

  @override
  String get sortAmountDesc => 'Montant le plus élevé';

  @override
  String get sortBy => 'Trier par';

  @override
  String get sortExpiry => 'Date d’expiration';

  @override
  String get sortNameAsc => 'Nom A–Z';

  @override
  String get sortNameDesc => 'Nom Z–A';

  @override
  String get sortNewest => 'Plus récents';

  @override
  String get sortOldest => 'Plus anciens';

  @override
  String get source => 'Source';

  @override
  String get sources => 'Sources';

  @override
  String get startExport => 'Créer l’export';

  @override
  String get status => 'Statut';

  @override
  String get statusActive => 'Actif';

  @override
  String get statusCancelled => 'Annulé';

  @override
  String get statusDiscarded => 'Rejeté';

  @override
  String get statusDone => 'Terminé';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusFailed => 'Échec';

  @override
  String get statusInRepair => 'En réparation';

  @override
  String get statusNeedsReview => 'À vérifier';

  @override
  String get statusProcessing => 'En traitement';

  @override
  String get statusReady => 'Prêt';

  @override
  String get statusRefreshed => 'Statut actualisé';

  @override
  String get statusSnoozed => 'Reporté';

  @override
  String get statusSold => 'Vendu';

  @override
  String get statusUploaded => 'Importé';

  @override
  String get statusUploading => 'Import en cours';

  @override
  String get storage => 'Stockage';

  @override
  String get storageAlmostFull => 'Le stockage est presque plein';

  @override
  String get subActive => 'Actif';

  @override
  String get subBillingIssue => 'Problème de paiement';

  @override
  String get subCancelled => 'Résilié — valable jusqu’à la fin de la période';

  @override
  String get subExpired => 'Expiré';

  @override
  String get subNone => 'Formule gratuite';

  @override
  String get subRefunded => 'Remboursé';

  @override
  String get subscriptionTerms =>
      'L’abonnement est renouvelé chaque mois jusqu’à sa résiliation dans les réglages de l’App Store ou de Google Play. Le paiement est débité sur votre compte du store.';

  @override
  String get summary => 'Résumé';

  @override
  String get supportPrivacyNote =>
      'N’envoyez jamais de mots de passe ni le contenu de documents au support.';

  @override
  String get tagline => 'Votre vie. Au même endroit.';

  @override
  String get tags => 'Étiquettes';

  @override
  String get takePhoto => 'Prendre une photo';

  @override
  String get termsOfUse => 'Conditions d’utilisation';

  @override
  String get thisYear => 'Cette année';

  @override
  String get timezone => 'Fuseau horaire';

  @override
  String get title => 'Titre';

  @override
  String get today => 'Aujourd’hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get totalInvested => 'Total investi';

  @override
  String get totalValue => 'Valeur totale';

  @override
  String get trash => 'Corbeille';

  @override
  String get trashEmpty => 'La corbeille est vide';

  @override
  String get trashRetention =>
      'Les documents de la corbeille sont définitivement supprimés après 30 jours.';

  @override
  String get tryAi => 'Demander à l’IA';

  @override
  String get typeDeleteToConfirm => 'Tapez SUPPRIMER pour confirmer';

  @override
  String get unlock => 'Déverrouiller';

  @override
  String get unlockVaultReason => 'Déverrouiller le coffre';

  @override
  String get upcomingDeadlines => 'Échéances à venir';

  @override
  String get upgradeAiBody =>
      'L’IA lit les reçus, propose des catégories et des rappels, et répond aux questions sur vos données — avec les sources.';

  @override
  String get upgradeAiTitle => 'L’aide de l’IA est dans les formules Pro';

  @override
  String get upgradeDocumentsBody =>
      'Vous avez atteint le nombre de documents de la formule gratuite. Rien n’est supprimé — choisissez une formule supérieure pour plus d’espace.';

  @override
  String get upgradeDocumentsTitle => 'Limite de documents';

  @override
  String get upgradeExportBody => 'L’export CSV fait partie des formules Pro.';

  @override
  String get upgradeExportTitle => 'Export avancé';

  @override
  String get upgradeFamilyBody =>
      'Un espace familial, les invitations et le partage de documents sont disponibles dans Family Base et Family Pro.';

  @override
  String get upgradeFamilyTitle => 'Formule Family';

  @override
  String get upgradeFiltersBody =>
      'Les filtres par statut de traitement et la recherche avancée sont dans les formules payantes.';

  @override
  String get upgradeFiltersTitle => 'Filtres avancés';

  @override
  String get upgradeStorageBody =>
      'Rien n’a été supprimé. Choisissez une formule supérieure ou libérez de l’espace.';

  @override
  String get upgradeStorageTitle => 'Le stockage est plein';

  @override
  String get upgradeVehiclesBody =>
      'Votre formule autorise un nombre limité de véhicules. Une formule supérieure en autorise davantage.';

  @override
  String get upgradeVehiclesTitle => 'Limite de véhicules';

  @override
  String get uploadErrorTitle => 'Échec de l’import';

  @override
  String get uploadFailedHint =>
      'Le fichier n’a pas été importé ou n’a pas passé la validation. Importez-le à nouveau.';

  @override
  String get uploadKeepOpen =>
      'Gardez l’application ouverte jusqu’à la fin de l’import.';

  @override
  String get useBiometrics => 'Utiliser la biométrie';

  @override
  String get useRegularSearch => 'Utiliser la recherche classique';

  @override
  String get validFrom => 'Valable à partir du';

  @override
  String get vaultEmpty => 'Le coffre est vide';

  @override
  String get vaultEmptyBody =>
      'Conservez ici vos documents personnels, contrats, polices et certificats.';

  @override
  String get vaultLockDisclaimer =>
      'Le PIN et la biométrie ajoutent une protection à l’ouverture du coffre sur cet appareil. Ce n’est pas un chiffrement : vos fichiers sont protégés par des vérifications d’accès côté serveur, quel que soit le PIN.';

  @override
  String get vaultLocked => 'Le coffre est verrouillé';

  @override
  String get vaultLockedBody => 'Saisissez votre PIN ou utilisez la biométrie.';

  @override
  String get vaultSettings => 'Paramètres du coffre';

  @override
  String get vaultSubtitle =>
      'Documents privés et particulièrement importants. Pas de publicité ici.';

  @override
  String get vendor => 'Vendeur';

  @override
  String get verifyEmailTitle => 'Vérifiez votre e-mail';

  @override
  String get warrantiesExpiring => 'Garanties qui expirent';

  @override
  String get warranty => 'Garantie';

  @override
  String get warrantyConfirm => 'Je confirme la date de garantie';

  @override
  String get warrantyConfirmHelp =>
      'Vérifiez le bon de garantie. La garantie n’est jamais définie sans votre confirmation.';

  @override
  String get warrantyFieldHelp =>
      'À remplir uniquement si c’est indiqué sur le bon de garantie';

  @override
  String get warrantySuggestion => 'Suggestion tirée du document';

  @override
  String get warrantyUntil => 'Garantie jusqu’au';

  @override
  String get warrantyUserEnteredNote =>
      'La date de garantie est celle que vous avez saisie ou confirmée.';

  @override
  String get website => 'Site web';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get withReminder => 'Avec rappel';

  @override
  String get withWarranty => 'Avec garantie';

  @override
  String get worldSubtitle => 'Chaque domaine de votre vie';

  @override
  String get year => 'Année';

  @override
  String get you => 'vous';

  @override
  String addDocumentFor(String name) {
    return 'Document pour $name';
  }

  @override
  String cardExpiresTitle(String name) {
    return 'La carte expire : $name';
  }

  @override
  String cardsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes',
      one: '$count carte',
      zero: 'Aucune carte',
    );
    return '$_temp0';
  }

  @override
  String cardsExpiringSoon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes expirent dans les 2 semaines',
      one: '$count carte expire dans les 2 semaines',
    );
    return '$_temp0';
  }

  @override
  String contactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count contacts',
      one: '$count contact',
      zero: 'Aucun contact',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a $count jour',
    );
    return '$_temp0';
  }

  @override
  String daysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours avant',
      one: '$count jour avant',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresTitle(String title) {
    return 'Expire : $title';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '$count document',
      zero: 'Aucun document',
    );
    return '$_temp0';
  }

  @override
  String documentsUsed(int used, int limit) {
    return 'Documents : $used sur $limit';
  }

  @override
  String duplicateBody(String title) {
    return 'Le même fichier est déjà enregistré sous « $title ». L’enregistrer à nouveau ?';
  }

  @override
  String expiresOn(String date) {
    return 'Expire le $date';
  }

  @override
  String featureDocuments(String count) {
    return 'Jusqu’à $count documents';
  }

  @override
  String featureMembers(int count) {
    return 'Jusqu’à $count membres de la famille';
  }

  @override
  String featureStorage(String size) {
    return '$size de stockage';
  }

  @override
  String helloName(String name) {
    return 'Bonjour, $name';
  }

  @override
  String hoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count heures avant',
      one: '$count heure avant',
    );
    return '$_temp0';
  }

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dans $count jours',
      one: 'dans $count jour',
    );
    return '$_temp0';
  }

  @override
  String invitationBody(String name) {
    return '$name vous invite dans son espace familial. Accepter ne vous donne pas accès à tous les documents — vous ne voyez que ce que les autres partagent avec vous.';
  }

  @override
  String inviteShareText(String link) {
    return 'Rejoins notre famille sur MyWorld+ : $link';
  }

  @override
  String invitedTo(String name) {
    return 'Invitation à « $name »';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count objets',
      one: '$count objet',
      zero: 'Aucun objet',
    );
    return '$_temp0';
  }

  @override
  String joinedOn(String date) {
    return 'Membre depuis le $date';
  }

  @override
  String last12Months(String currency) {
    return '12 derniers mois $currency';
  }

  @override
  String lastOn(String date) {
    return 'Dernier : $date';
  }

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '$count membre',
    );
    return '$_temp0';
  }

  @override
  String minutesBefore(int count) {
    return '$count min avant';
  }

  @override
  String nextDue(String date) {
    return 'Prochain : $date';
  }

  @override
  String offerReminderBody(String date) {
    return 'Voulez-vous un rappel pour le $date ?';
  }

  @override
  String pageN(int n) {
    return 'Page $n';
  }

  @override
  String pagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '$count page',
    );
    return '$_temp0';
  }

  @override
  String pricePerMonth(String price) {
    return '$price € / mois';
  }

  @override
  String purchasedOn(String date) {
    return 'Acheté le $date';
  }

  @override
  String remindersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count rappels',
      one: '$count rappel',
      zero: 'Aucun rappel',
    );
    return '$_temp0';
  }

  @override
  String removeMemberTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String reviewIntro(int percent) {
    return 'L’IA a lu le document (confiance $percent %). Vérifiez et corrigez les données avant d’enregistrer.';
  }

  @override
  String reviewNeededFor(String title) {
    return 'Vérifier les suggestions : $title';
  }

  @override
  String scanReviewTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '$count page',
    );
    return '$_temp0';
  }

  @override
  String sharedBy(String name) {
    return 'Partagé par $name';
  }

  @override
  String storageUsed(String used, String total) {
    return '$used utilisés sur $total';
  }

  @override
  String uploadProgress(int percent) {
    return 'Import en cours… $percent %';
  }

  @override
  String validUntil(String date) {
    return 'Valable jusqu’au $date';
  }

  @override
  String vehiclesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count véhicules',
      one: '$count véhicule',
      zero: 'Aucun véhicule',
    );
    return '$_temp0';
  }

  @override
  String verifyEmailBody(String email) {
    return 'Nous avons envoyé un lien à $email. Ouvrez-le pour confirmer votre compte.';
  }

  @override
  String warrantyActiveUntil(String date) {
    return 'Garantie valable jusqu’au $date';
  }

  @override
  String warrantyDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il reste $count jours de garantie',
      one: 'Il reste $count jour de garantie',
    );
    return '$_temp0';
  }

  @override
  String warrantyExpiredOn(String date) {
    return 'Garantie expirée le $date';
  }

  @override
  String warrantyExpiresTitle(String name) {
    return 'La garantie expire : $name';
  }

  @override
  String warrantyPrintedMonths(int months) {
    return 'Sur le document : $months mois de garantie';
  }

  @override
  String warrantyPrintedUntil(String date) {
    return 'Sur le document : jusqu’au $date';
  }

  @override
  String warrantyUntilShort(String date) {
    return 'Garantie jusqu’au $date';
  }

  @override
  String willBeSavedIn(String destination) {
    return 'Sera enregistré dans : $destination';
  }

  @override
  String wrongPin(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'PIN incorrect. Encore $count tentatives.',
      one: 'PIN incorrect. Encore $count tentative.',
    );
    return '$_temp0';
  }

  @override
  String get suggestedLinks => 'Liens suggérés';

  @override
  String get suggestedLinksHelp =>
      'Nous avons trouvé des éléments correspondant à ce document. Cochez ceux que vous voulez lier.';
}
