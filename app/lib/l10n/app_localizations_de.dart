// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get accept => 'Annehmen';

  @override
  String get acceptTerms =>
      'Ich akzeptiere die Nutzungsbedingungen und die Datenschutzerklärung';

  @override
  String get accessUntil => 'Zugriff bis';

  @override
  String get adConsent => 'Werbe-Einwilligung';

  @override
  String get adConsentHelp =>
      'Verwalte deine Einstellungen für personalisierte Werbung. Der Inhalt deiner Dokumente wird nie für Werbung verwendet.';

  @override
  String get adLabel => 'Anzeige';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addBusinessCard => 'Visitenkarte hinzufügen';

  @override
  String get addBusinessCardHint =>
      'Fotografiere die Visitenkarte einer Person';

  @override
  String get addCategory => 'Neue Kategorie';

  @override
  String get addDocument => 'Dokument hinzufügen';

  @override
  String get addFamilyMember => 'Familienmitglied hinzufügen';

  @override
  String get addFamilyMemberHint =>
      'Profil für ein Haushaltsmitglied, z. B. ein Kind';

  @override
  String get addFavorite => 'Zu Favoriten hinzufügen';

  @override
  String get addImage => 'Bild hochladen';

  @override
  String get addImageHint => 'Fotos aus der Galerie auswählen';

  @override
  String get addItem => 'Gegenstand hinzufügen';

  @override
  String get addItemHint => 'Gerät, Möbel, Ausrüstung, Sammlung…';

  @override
  String get addMemberHelp =>
      'Ein Profil braucht weder Konto noch sensible Daten. Dokumente werden mit dem Profil verknüpft; jedes Dokument legt seine Sichtbarkeit selbst fest.';

  @override
  String get addPage => 'Seite hinzufügen';

  @override
  String get addPdf => 'PDF hochladen';

  @override
  String get addPdfHint => 'Ein vorhandenes PDF von deinem Handy';

  @override
  String get addPhoto => 'Foto aufnehmen';

  @override
  String get addPhotoHint => 'Ein einzelnes Kamerafoto';

  @override
  String get addRecord => 'Eintrag hinzufügen';

  @override
  String get addReminder => 'Erinnerung hinzufügen';

  @override
  String get addReminderHint => 'Frist, Verlängerung, Jahrestag…';

  @override
  String get addRepairReceipt => 'Reparaturbeleg hinzufügen';

  @override
  String get addScan => 'Dokument scannen';

  @override
  String get addScanHint => 'Kantenerkennung, mehrere Seiten in einem PDF';

  @override
  String get addServiceRecord => 'Servicebeleg oder Ausgabe';

  @override
  String get addServiceRecordHint => 'Für dieses Fahrzeug';

  @override
  String get addTitle => 'Was möchtest du hinzufügen?';

  @override
  String get addVehicle => 'Fahrzeug hinzufügen';

  @override
  String get addVehicleRecord => 'Fahrzeugeintrag';

  @override
  String get addVehicleRecordHint => 'Service, Zulassung, Kraftstoff, Reifen…';

  @override
  String get addWalletCard => 'Karte hinzufügen';

  @override
  String get addWalletCardHint => 'Kundenkarte, Rabatt oder Gutschein';

  @override
  String get address => 'Adresse';

  @override
  String get adsOffForPlan => 'Dein Tarif ist werbefrei.';

  @override
  String get aiAnalyze => 'KI-Dokumentanalyse';

  @override
  String get aiAnalyzeAgain => 'Mit KI analysieren';

  @override
  String get aiAnalyzeHelp =>
      'Die KI schlägt Titel, Datum, Betrag und Kategorie vor. Du bestätigst, bevor etwas gespeichert wird.';

  @override
  String get aiAndYourData => 'KI und deine Daten';

  @override
  String get aiAnswer => 'Antwort';

  @override
  String get aiDataNote =>
      'Wenn du die KI nutzt, wird nur das gesendet, was für die jeweilige Anfrage nötig ist: Text oder Bild eines Dokuments für die Analyse oder kurze Metadaten freigegebener Einträge für eine Frage. Tresor-Dokumente werden nie für Fragen verwendet. Die Daten werden nicht zum Training von Modellen genutzt und vom KI-Dienst nicht gespeichert.';

  @override
  String get aiExample1 => 'Wann läuft die Garantie meiner Waschmaschine ab?';

  @override
  String get aiExample2 =>
      'Wie viel habe ich dieses Jahr für das Auto ausgegeben?';

  @override
  String get aiExample3 =>
      'Finde Verträge, die in den nächsten drei Monaten auslaufen.';

  @override
  String get aiExample4 => 'Welche Belege habe ich für Käufe über 200 Euro?';

  @override
  String get aiFilledCheck =>
      'Felder ausgefüllt. Bitte prüfe sie vor dem Speichern.';

  @override
  String get aiHint => 'Stelle eine Frage zu deinen Daten…';

  @override
  String get aiInsufficientNote =>
      'Ich antworte nur auf Basis deiner gespeicherten Daten. Fehlt etwas, füge ein Dokument hinzu oder ergänze die Angaben.';

  @override
  String get aiIntro =>
      'Frag nach deinen Dokumenten, Gegenständen, Fahrzeugen und Fristen. Antworten enthalten immer Quellen.';

  @override
  String aiIndexing(int ready, int total) {
    return 'KI liest deine Dokumente: $ready von $total. Die Antworten werden mit der Zeit vollständiger.';
  }

  @override
  String get aiIndexingDeferred =>
      'Das monatliche Leselimit für Dokumente ist erreicht. Den Rest liest die KI ab Anfang nächsten Monats.';

  @override
  String get aiLimitsNote =>
      'Das monatliche Limit verhindert unerwartete Kosten. Es wird zu Beginn jedes Monats zurückgesetzt.';

  @override
  String get aiNoData =>
      'Ich habe nicht genug Daten, um diese Frage zu beantworten.';

  @override
  String get aiNotInPlanHint =>
      'Die KI-Analyse ist in Individual Pro und Family Pro verfügbar. Du kannst das Dokument manuell speichern und bearbeiten.';

  @override
  String get aiPrivacyNote =>
      'Die KI sieht nur Einträge, auf die du Zugriff hast.';

  @override
  String get aiProcessing => 'Die KI verarbeitet das Dokument…';

  @override
  String get aiRequestsThisMonth => 'KI-Anfragen diesen Monat';

  @override
  String get aiSearchLocked =>
      'KI-Suche in natürlicher Sprache ist in den Pro-Tarifen verfügbar';

  @override
  String get aiThinking => 'Deine Daten werden durchsucht…';

  @override
  String get aiUsage => 'KI-Nutzung und Limits';

  @override
  String get aiVerifyNote =>
      'Die KI kann Fehler machen. Prüfe wichtige Informationen in der Quelle.';

  @override
  String get all => 'Alle';

  @override
  String get allDocuments => 'Alle Dokumente';

  @override
  String get allItems => 'Alle Gegenstände';

  @override
  String get allow => 'Erlauben';

  @override
  String get amount => 'Betrag';

  @override
  String get analyticsConsent => 'Anonyme Nutzungsstatistik';

  @override
  String get analyticsConsentHelp =>
      'Hilft uns, die App zu verbessern. Sendet nie Inhalte, Titel oder Dokumentdaten.';

  @override
  String get anyTime => 'Jederzeit';

  @override
  String get appTitle => 'MyWorld+';

  @override
  String get appWorksWithoutAi =>
      'Die App funktioniert auch ohne KI: Speichern, Anzeigen, Suche und Erinnerungen sind in jedem Tarif verfügbar.';

  @override
  String get apply => 'Anwenden';

  @override
  String get areaBusinessCards => 'Meine Visitenkarten';

  @override
  String get areaBusinessCardsSub => 'Karten anderer Personen';

  @override
  String get areaCar => 'Mein Auto';

  @override
  String get areaCarSub => 'Fahrzeuge und Kosten';

  @override
  String get areaCards => 'Meine Karten';

  @override
  String get areaCardsSub => 'Rabatte und Gutscheine';

  @override
  String get areaDocuments => 'Meine Dokumente';

  @override
  String get areaDocumentsSub => 'Zentrales Archiv';

  @override
  String get areaFamily => 'Meine Familie';

  @override
  String get areaFamilySub => 'Familienbereich';

  @override
  String get areaHobby => 'Mein Hobby';

  @override
  String get areaHobbySub => 'Ausrüstung und Sammlungen';

  @override
  String get areaHome => 'Mein Zuhause';

  @override
  String get areaHomeSub => 'Dinge im Haushalt';

  @override
  String get areaLife => 'Mein Leben';

  @override
  String get areaLifeSub => 'Fristen und Verpflichtungen';

  @override
  String get askAi => 'KI fragen';

  @override
  String get askAiInstead => 'Den KI-Assistenten fragen';

  @override
  String get assignedItems => 'Zugeordnete Gegenstände';

  @override
  String get atTime => 'Zum Fälligkeitszeitpunkt';

  @override
  String get attachReceipt => 'Beleg scannen';

  @override
  String get back => 'Zurück';

  @override
  String get backToSignIn => 'Zurück zur Anmeldung';

  @override
  String get balance => 'Guthaben';

  @override
  String get barcodeFormat => 'Code-Format';

  @override
  String get barcodeInvalid => 'Der Code ist für das gewählte Format ungültig';

  @override
  String get barcodeValue => 'Code-Wert';

  @override
  String get billingIssueBody =>
      'Die Zahlung ist fehlgeschlagen. Prüfe deine Zahlungsmethode im Store, um deine Funktionen zu behalten.';

  @override
  String get billingNotConfigured =>
      'Käufe sind auf diesem Gerät derzeit nicht verfügbar.';

  @override
  String get brand => 'Marke';

  @override
  String get brandModel => 'Marke und Modell';

  @override
  String get byCategory => 'Nach Kategorie';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cardCoupon => 'Gutschein';

  @override
  String get cardDiscount => 'Rabatt';

  @override
  String get cardGift => 'Geschenkkarte';

  @override
  String get cardLoyalty => 'Treuekarte';

  @override
  String get cardMembership => 'Mitgliedschaft';

  @override
  String get cardName => 'Name';

  @override
  String get cardNameHelp => 'Z. B. Name eines Geschäfts oder einer Apotheke';

  @override
  String get cardNumber => 'Kartennummer';

  @override
  String get cardOther => 'Sonstiges';

  @override
  String get categories => 'Kategorien';

  @override
  String get category => 'Kategorie';

  @override
  String get changePhoto => 'Foto ändern';

  @override
  String get changePlan => 'Tarif ändern';

  @override
  String get channelLocal => 'Benachrichtigung auf dem Gerät';

  @override
  String get channelLocalHelp => 'Funktioniert offline';

  @override
  String get channelPush => 'Push-Benachrichtigung';

  @override
  String get channelPushHelp => 'Kommt auch an, wenn die App geschlossen ist';

  @override
  String get checkThisField => 'Prüfe dieses Feld';

  @override
  String get chooseCurrency => 'Währung wählen';

  @override
  String get chooseFromGallery => 'Aus Galerie wählen';

  @override
  String get choosePlan => 'Tarif wählen';

  @override
  String get chooseVehicle => 'Fahrzeug wählen';

  @override
  String get clear => 'Leeren';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get close => 'Schließen';

  @override
  String get code => 'Code';

  @override
  String get color => 'Farbe';

  @override
  String get company => 'Firma';

  @override
  String get confirmAndSave => 'Bestätigen und speichern';

  @override
  String get confirmDateHint => 'Prüfe das Datum vor dem Speichern.';

  @override
  String get contactSupport => 'Support kontaktieren';

  @override
  String get contextSection => 'Kontext';

  @override
  String get continueApple => 'Weiter mit Apple';

  @override
  String get continueGoogle => 'Weiter mit Google';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get copied => 'Kopiert';

  @override
  String get copy => 'Kopieren';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get createFamily => 'Familie erstellen';

  @override
  String get createInviteLink => 'Einladungslink erstellen';

  @override
  String get createReminder => 'Erinnerung erstellen';

  @override
  String get currency => 'Währung';

  @override
  String get currentMileage => 'Aktueller Kilometerstand';

  @override
  String get currentMileageKm => 'Aktueller Kilometerstand (km)';

  @override
  String get currentPlan => 'Aktuell';

  @override
  String get date => 'Datum';

  @override
  String get dateOptions =>
      'Das Dokument enthält mehrere Daten – wähle das richtige:';

  @override
  String get decline => 'Ablehnen';

  @override
  String get delete => 'Löschen';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get deleteAccountForever => 'Konto endgültig löschen';

  @override
  String get deleteCancelStoreFirst =>
      'Dein Abo wird über den App Store / Google Play verwaltet. Kündige es dort, damit dir nach dem Löschen des Kontos nichts mehr berechnet wird.';

  @override
  String get deleteCard => 'Karte löschen';

  @override
  String get deleteCardBody => 'Die Karte und ihre Fotos werden gelöscht.';

  @override
  String get deleteCategory => 'Kategorie löschen';

  @override
  String get deleteCategoryBody =>
      'Die Dokumente bleiben gespeichert; sie verlieren nur diese Kategorie.';

  @override
  String get deleteConsequences =>
      'Alle deine Dokumente, Dateien, Gegenstände, Fahrzeuge, Karten, Kontakte und Erinnerungen werden gelöscht. Du verlierst den Zugang zum Familienbereich. Das kann nicht rückgängig gemacht werden.';

  @override
  String get deleteConsequencesTitle => 'Was passiert';

  @override
  String get deleteContact => 'Kontakt löschen';

  @override
  String get deleteContactBody =>
      'Die Visitenkarte und die Fotos werden gelöscht.';

  @override
  String get deleteForever => 'Endgültig löschen';

  @override
  String get deleteForeverBody =>
      'Die Datei wird endgültig gelöscht und kann nicht wiederhergestellt werden.';

  @override
  String get deleteItem => 'Gegenstand löschen';

  @override
  String get deleteItemBody =>
      'Der Gegenstand wird gelöscht. Verknüpfte Dokumente bleiben in deinem Archiv.';

  @override
  String get deleteProfile => 'Profil löschen';

  @override
  String get deleteProfileBody =>
      'Das Profil wird gelöscht. Die Dokumente bleiben, verlieren nur die Verknüpfung.';

  @override
  String get deleteRecord => 'Eintrag löschen';

  @override
  String get deleteRecordBody =>
      'Der Eintrag wird gelöscht. Angehängte Belege bleiben in deinem Archiv.';

  @override
  String get deleteReminder => 'Erinnerung löschen';

  @override
  String get deleteReminderBody =>
      'Die Erinnerung sendet keine Benachrichtigungen mehr.';

  @override
  String get deleteVehicle => 'Fahrzeug löschen';

  @override
  String get deleteVehicleBody =>
      'Das Fahrzeug und seine Einträge werden gelöscht. Belege bleiben in deinem Archiv.';

  @override
  String get deleteWord => 'LÖSCHEN';

  @override
  String get description => 'Beschreibung';

  @override
  String get details => 'Details';

  @override
  String get disableLock => 'Sperre ausschalten';

  @override
  String get discount => 'Rabatt';

  @override
  String get discountHelp => 'Z. B. 10 % auf Kosmetik';

  @override
  String get discountText => 'Rabattbeschreibung';

  @override
  String get displayName => 'Name oder Spitzname';

  @override
  String get dissolveBody =>
      'Der Familienbereich wird geschlossen. Deine Dokumente bleiben, werden aber privat.';

  @override
  String get dissolveFamily => 'Familie auflösen';

  @override
  String get dissolveHelp =>
      'Als Inhaber kannst du die Familie auflösen, sobald keine anderen Mitglieder mehr da sind.';

  @override
  String get docNotAvailable =>
      'Das Dokument existiert nicht oder du hast keinen Zugriff.';

  @override
  String get documentDate => 'Dokumentdatum';

  @override
  String get documentSaved => 'Dokument gespeichert';

  @override
  String get documentSavedAi =>
      'Die KI verarbeitet das Dokument. Vorschläge erscheinen zur Prüfung.';

  @override
  String get documents => 'Dokumente';

  @override
  String get done => 'Fertig';

  @override
  String get downgradePolicy =>
      'Wechselst du zu einem kleineren Tarif, wird keine Datei automatisch gelöscht. Liegst du über dem Limit, kannst du Dokumente weiter ansehen und exportieren, aber keine neuen hinzufügen, bis du Platz schaffst oder einen größeren Tarif wählst.';

  @override
  String get dueDate => 'Fälligkeitsdatum';

  @override
  String get duplicateTitle => 'Mögliches Duplikat';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get editCard => 'Karte bearbeiten';

  @override
  String get editContact => 'Kontakt bearbeiten';

  @override
  String get editDetails => 'Details bearbeiten';

  @override
  String get editDocument => 'Dokument bearbeiten';

  @override
  String get editItem => 'Gegenstand bearbeiten';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get editRecord => 'Eintrag bearbeiten';

  @override
  String get editReminder => 'Erinnerung bearbeiten';

  @override
  String get editVehicle => 'Fahrzeug bearbeiten';

  @override
  String get email => 'E-Mail';

  @override
  String get emailChannelNote =>
      'E-Mail-Benachrichtigungen sind noch nicht aktiviert.';

  @override
  String get emailOptional => 'E-Mail (optional)';

  @override
  String get emailSent => 'E-Mail gesendet';

  @override
  String get emailsOnePerLine => 'E-Mails (eine pro Zeile)';

  @override
  String get enableLock => 'Sperre einschalten';

  @override
  String get errAiFailed =>
      'Die KI kann die Anfrage gerade nicht bearbeiten. Deine Daten sind sicher – versuche es später erneut.';

  @override
  String get errAiLimit =>
      'Limit für KI-Anfragen erreicht. Versuche es später oder prüfe deine Nutzung.';

  @override
  String get errAiNotInPlan =>
      'KI ist in Individual Pro und Family Pro verfügbar.';

  @override
  String get errAlreadyInFamily => 'Du bist bereits in einer Familie.';

  @override
  String get errCancelled => 'Aktion abgebrochen.';

  @override
  String get errDocumentLimit =>
      'Du hast das Dokumentlimit deines Tarifs erreicht.';

  @override
  String get errEmailInUse => 'Ein Konto mit dieser E-Mail existiert bereits.';

  @override
  String get errEmailNotVerified =>
      'E-Mail noch nicht bestätigt. Sieh in deinem Posteingang nach.';

  @override
  String get errFamilyFull => 'Die Familie ist für deinen Tarif voll.';

  @override
  String get errFamilyHasMembers =>
      'Entferne zuerst die anderen Familienmitglieder.';

  @override
  String get errFamilyPlan => 'Dafür ist ein Family-Tarif nötig.';

  @override
  String get errFileTooLarge => 'Die Datei ist zu groß (max. 25 MB).';

  @override
  String get errGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';

  @override
  String get errInvalidEmail => 'Gib eine gültige E-Mail-Adresse ein.';

  @override
  String get errInvitationEmail =>
      'Diese Einladung wurde an eine andere E-Mail-Adresse gesendet.';

  @override
  String get errInvitationExpired =>
      'Die Einladung ist abgelaufen. Bitte um eine neue.';

  @override
  String get errInvitationInvalid =>
      'Die Einladung ist ungültig oder wurde bereits verwendet.';

  @override
  String get errNetwork =>
      'Keine Internetverbindung. Änderungen werden synchronisiert, sobald du wieder online bist.';

  @override
  String get errNotFound => 'Der angeforderte Inhalt wurde nicht gefunden.';

  @override
  String get errPermission => 'Dafür hast du keine Berechtigung.';

  @override
  String get errRecentLogin =>
      'Bitte melde dich aus Sicherheitsgründen erneut an.';

  @override
  String get errSession =>
      'Deine Sitzung ist abgelaufen. Bitte melde dich erneut an.';

  @override
  String get errStorageLimit => 'Nicht genug Speicherplatz in deinem Tarif.';

  @override
  String get errTitle => 'Hoppla';

  @override
  String get errTooMany =>
      'Zu viele Versuche. Warte kurz und versuche es erneut.';

  @override
  String get errUnavailable =>
      'Der Dienst ist vorübergehend nicht verfügbar. Versuche es in einer Minute erneut.';

  @override
  String get errUnsupportedFile =>
      'Dieser Dateityp wird nicht unterstützt. Verwende PDF, JPG, PNG oder HEIC.';

  @override
  String get errUserNotFound => 'Kein Konto mit dieser E-Mail.';

  @override
  String get errWeakPassword => 'Das Passwort ist zu schwach.';

  @override
  String get errWrongPassword => 'Falsche E-Mail oder falsches Passwort.';

  @override
  String get expenses => 'Ausgaben';

  @override
  String get expired => 'Abgelaufen';

  @override
  String get expiryDate => 'Gültig bis';

  @override
  String get exportAdvancedIncluded =>
      'Dein Tarif enthält auch CSV-Tabellen (Dokumente, Gegenstände, Fahrzeugkosten).';

  @override
  String get exportBasicOnly =>
      'Der Export enthält JSON mit allen Daten und die Originaldateien. CSV-Tabellen sind Teil der Pro-Tarife.';

  @override
  String get exportBody =>
      'Wir erstellen ein ZIP-Archiv mit all deinen Dokumenten, Fotos, Metadaten, Gegenständen, Fahrzeugen, Erinnerungen und den Verknüpfungen zwischen ihnen.';

  @override
  String get exportData => 'Daten exportieren';

  @override
  String get exportFamilyNote =>
      'Der Export enthält nur Einträge, die dir gehören. Jedes Familienmitglied exportiert seine eigenen Daten.';

  @override
  String get exportFirst => 'Zuerst Daten exportieren';

  @override
  String get exportWait =>
      'Das kann einige Minuten dauern, wenn du viele Dateien hast.';

  @override
  String get familyDeadlines => 'Familienfristen';

  @override
  String get familyIntro =>
      'Ein Familienbereich bietet gemeinsame Dokumente, Mitgliederprofile und gemeinsame Fristen. Jedes Dokument behält trotzdem seine eigene Privatsphäre.';

  @override
  String get familyInvitation => 'Familieneinladung';

  @override
  String get familyName => 'Familienname';

  @override
  String get familyPermissions => 'Rollen und Berechtigungen';

  @override
  String get familyPlanLapsed =>
      'Der Family-Tarif ist nicht aktiv. Vorhandene Daten bleiben verfügbar, neue Einladungen sind aber nicht möglich.';

  @override
  String get familyPlanOnly => 'In Family-Tarifen verfügbar';

  @override
  String get familyProfiles => 'Haushaltsprofile';

  @override
  String get familyProfilesHelp =>
      'Für Mitglieder ohne eigenes Konto, z. B. Kinder.';

  @override
  String get familySettings => 'Familieneinstellungen';

  @override
  String get faq1a =>
      'Standardmäßig nur du. Ein Dokument wird für Familienmitglieder erst sichtbar, wenn du seine Privatsphäre auf „Ausgewählte“ oder „Familie“ änderst.';

  @override
  String get faq1q => 'Wer kann meine Dokumente sehen?';

  @override
  String get faq2a =>
      'Es wird nichts gelöscht. Alles bleibt zum Ansehen und Exportieren verfügbar; neue Dateien kannst du hinzufügen, nachdem du Platz geschaffen oder upgegradet hast.';

  @override
  String get faq2q => 'Was passiert, wenn ich meinen Speicher überschreite?';

  @override
  String get faq3a =>
      'Ja. Deshalb sind KI-Daten Vorschläge, die du bestätigst, und Antworten nennen immer Quellen.';

  @override
  String get faq3q => 'Kann die KI Fehler machen?';

  @override
  String get faq4a =>
      'Du verwaltest dein Abo in den Einstellungen des App Store oder von Google Play. Der Zugriff bleibt bis zum Ende des bezahlten Zeitraums bestehen.';

  @override
  String get faq4q => 'Wie kündige ich mein Abo?';

  @override
  String get faq5a =>
      'Nein. PIN und Biometrie schützen zusätzlich den Bildschirm. Die Dateien sind durch serverseitige Zugriffsregeln geschützt und von Google Cloud bei der Übertragung und Speicherung verschlüsselt.';

  @override
  String get faq5q => 'Ist die Tresor-PIN eine Verschlüsselung?';

  @override
  String get favorites => 'Favoriten';

  @override
  String get favoritesOnly => 'Nur Favoriten';

  @override
  String get featureAds => 'Mit Werbung';

  @override
  String get featureAi => 'KI-Erkennung, Kategorisierung und Fragen';

  @override
  String get featureNoAds => 'Keine Werbung';

  @override
  String get featureNoAi => 'Keine KI-Funktionen';

  @override
  String get featureReminders => 'Erinnerungen und Benachrichtigungen';

  @override
  String get featureScan => 'Scannen und Hochladen';

  @override
  String get fileInfo => 'Datei';

  @override
  String get fileType => 'Dateityp';

  @override
  String get filters => 'Filter';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get free => 'Kostenlos';

  @override
  String get front => 'Vorderseite';

  @override
  String get fuelType => 'Kraftstoff / Antrieb';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get getStarted => 'Los geht’s';

  @override
  String get goHome => 'Zur Startseite';

  @override
  String get gridView => 'Rasteransicht';

  @override
  String get haveAccount => 'Ich habe bereits ein Konto';

  @override
  String get haveInvitationHint =>
      'Hast du eine Einladung? Öffne den Link aus der Nachricht und nimm sie an.';

  @override
  String get help => 'Hilfe und Support';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get howWeProtect => 'So schützen wir deine Daten';

  @override
  String get iVerified => 'Ich habe meine E-Mail bestätigt';

  @override
  String get ignoreSuggestions => 'Vorschläge ignorieren';

  @override
  String get image => 'Bild';

  @override
  String get importantReminders => 'Wichtige Erinnerungen';

  @override
  String get injectionWarning =>
      'Das Dokument enthält Text, der wie Anweisungen an die KI aussieht. Er wurde ignoriert, prüfe die Vorschläge aber sorgfältig.';

  @override
  String get invalidAmount => 'Ungültiger Betrag';

  @override
  String get invalidValue => 'Ungültiger Wert';

  @override
  String get invalidVin => 'Eine FIN hat 17 Zeichen (ohne I, O, Q)';

  @override
  String get invitationDeclined => 'Einladung abgelehnt';

  @override
  String get invite => 'Einladen';

  @override
  String get inviteEmailHelp =>
      'Wenn du eine E-Mail angibst, kann nur eine Person mit dieser bestätigten Adresse annehmen.';

  @override
  String get inviteExpiresNote =>
      'Der Link ist 7 Tage gültig und kann nur einmal verwendet werden.';

  @override
  String get inviteHelp =>
      'Erstelle einen sicheren Einladungslink und sende ihn an ein Familienmitglied. Mitglieder erhalten nicht automatisch Zugriff auf deine Dokumente.';

  @override
  String get inviteLink => 'Einladungslink';

  @override
  String get inviteMember => 'Mitglied einladen';

  @override
  String get inviteReady => 'Einladung bereit';

  @override
  String get issuer => 'Aussteller / Geschäft';

  @override
  String get items => 'Gegenstände';

  @override
  String get jobTitle => 'Position';

  @override
  String get joinedFamily => 'Du bist der Familie beigetreten';

  @override
  String get kindAnniversary => 'Jahrestag';

  @override
  String get kindContract => 'Vertrag';

  @override
  String get kindCustom => 'Sonstiges';

  @override
  String get kindDocument => 'Dokument';

  @override
  String get kindInsurance => 'Versicherung';

  @override
  String get kindRegistration => 'Zulassung';

  @override
  String get kindService => 'Service';

  @override
  String get kindSubscription => 'Abo / Mitgliedschaft';

  @override
  String get kindWarranty => 'Garantie';

  @override
  String get langEnglish => 'Englisch';

  @override
  String get langFrench => 'Französisch';

  @override
  String get langGerman => 'Deutsch';

  @override
  String get langSpanish => 'Spanisch';

  @override
  String get langRussian => 'Russisch';

  @override
  String get langSerbian => 'Serbisch';

  @override
  String get language => 'Sprache';

  @override
  String get largestFiles => 'Größte Dateien';

  @override
  String get last30Days => 'Letzte 30 Tage';

  @override
  String get lastMileage => 'Letzter Kilometerstand';

  @override
  String get lastYear => 'Letztes Jahr';

  @override
  String get later => 'Später';

  @override
  String get leaveFamily => 'Familie verlassen';

  @override
  String get leaveFamilyBody =>
      'Du verlierst den Zugriff auf Familiendokumente. Deine Dokumente bleiben deine und werden privat.';

  @override
  String get leaveFamilyTitle => 'Familie verlassen?';

  @override
  String get legal => 'Rechtliches';

  @override
  String get legalSummary =>
      'MyWorld+ speichert deine Daten nur, um den Dienst bereitzustellen. Wir verkaufen keine Daten, nutzen Dokumentinhalte nicht für Werbung und trainieren keine Modelle mit deinen Dokumenten. Du kannst deine Daten jederzeit exportieren oder löschen.';

  @override
  String get lifeIntro =>
      'Abos, Policen, Vertragsfristen, Mitgliedschaften, Jahrestage und andere wichtige Termine.';

  @override
  String get limitReachedBody =>
      'Es wurde nichts gelöscht. Alle deine Einträge bleiben zum Ansehen und Exportieren verfügbar. Um neue hinzuzufügen, schaffe Platz (Papierkorb leeren, Unnötiges löschen) oder wähle einen größeren Tarif.';

  @override
  String get limitReachedTitle => 'Tariflimit erreicht';

  @override
  String get linkedDocument => 'Verknüpftes Dokument';

  @override
  String get linkedDocumentOptional => 'Verknüpftes Dokument (optional)';

  @override
  String get linkedItem => 'Verknüpfter Gegenstand';

  @override
  String get links => 'Verknüpfungen';

  @override
  String get linksHelp =>
      'Verknüpfe das Dokument mit Gegenständen, Fahrzeugen oder Mitgliedern. Die Datei wird nicht kopiert.';

  @override
  String get listView => 'Listenansicht';

  @override
  String get loading => 'Wird geladen…';

  @override
  String get location => 'Ort im Haushalt';

  @override
  String get locationHelp => 'Z. B. Küche, Keller';

  @override
  String get lockEnabled => 'Sperre ist aktiv';

  @override
  String get lockNow => 'Jetzt sperren';

  @override
  String get lockedFeature => 'Gesperrt';

  @override
  String get maintenanceHistory => 'Reparaturen und Wartung';

  @override
  String get make => 'Hersteller';

  @override
  String get manage => 'Verwalten';

  @override
  String get manageInStore => 'Im Store verwalten';

  @override
  String get manageSubscription => 'Abo';

  @override
  String get markDone => 'Als erledigt markieren';

  @override
  String get markDoneNext => 'Erledigt – zum nächsten Termin';

  @override
  String get markUsed => 'Als verwendet markieren';

  @override
  String get member => 'Mitglied';

  @override
  String get memberVisibleNote =>
      'Du siehst nur, was dieses Mitglied mit dir oder der Familie geteilt hat.';

  @override
  String get members => 'Mitglieder';

  @override
  String get metAt => 'Kennengelernt am';

  @override
  String get metWhere => 'Wo ihr euch kennengelernt habt';

  @override
  String get mileage => 'Kilometerstand';

  @override
  String get mileageHistory => 'Kilometerverlauf';

  @override
  String get mileageKm => 'Kilometerstand (km)';

  @override
  String get minor => 'Minderjährig';

  @override
  String get minorHelp =>
      'Ein Kinderprofil ist kein Konto und kann sich nicht anmelden.';

  @override
  String get model => 'Modell';

  @override
  String get more => 'Mehr';

  @override
  String get moveToTrash => 'In den Papierkorb';

  @override
  String get moveToTrashBody =>
      'Du kannst das Dokument innerhalb von 30 Tagen aus dem Papierkorb wiederherstellen.';

  @override
  String get movedToTrash => 'In den Papierkorb verschoben';

  @override
  String get multiCurrencyNote =>
      'Beträge in verschiedenen Währungen werden nicht addiert.';

  @override
  String get myAreas => 'Meine Bereiche';

  @override
  String get name => 'Name';

  @override
  String get nameOrCompanyRequired => 'Gib einen Namen oder eine Firma ein';

  @override
  String get navAdd => 'Hinzufügen';

  @override
  String get navHome => 'Start';

  @override
  String get navVault => 'Tresor';

  @override
  String get navWorld => 'Meine Welt';

  @override
  String get next => 'Weiter';

  @override
  String get next6Months => 'Nächste 6 Monate';

  @override
  String get nextDueDate => 'Nächster Termin';

  @override
  String get nextDueHelp =>
      'Nur ausfüllen, wenn du es weißt (z. B. vom Beleg oder der Empfehlung der Werkstatt).';

  @override
  String get nextDueMileage => 'Nächster Service bei km';

  @override
  String get nextDueSection => 'Nächste Fälligkeit';

  @override
  String get noAccount => 'Kein Konto? Registrieren';

  @override
  String get noAssignedItems => 'Keine zugeordneten Gegenstände.';

  @override
  String get noCards => 'Noch keine Karten';

  @override
  String get noCardsHint =>
      'Speichere Kundenkarten, Rabatte und Gutscheine, damit du sie immer dabei hast.';

  @override
  String get noContacts => 'Noch keine Visitenkarten';

  @override
  String get noContactsHint =>
      'Fotografiere eine Visitenkarte und speichere den Kontakt in Sekunden.';

  @override
  String get noDeadlines => 'Keine Fristen in den nächsten 6 Monaten';

  @override
  String get noDocuments => 'Noch keine Dokumente';

  @override
  String get noDocumentsCta =>
      'Füge dein erstes Dokument hinzu – scanne einen Beleg oder eine Garantie.';

  @override
  String get noDocumentsHint =>
      'Scanne oder lade ein Dokument hoch, um es hier aufzubewahren.';

  @override
  String get noExpenses => 'Noch keine Ausgaben';

  @override
  String get noFamilyDeadlines => 'Keine gemeinsamen Fristen.';

  @override
  String get noInventedIntervals =>
      'MyWorld+ nimmt keine Serviceintervalle an – es zeigt nur Termine, die du eingegeben hast.';

  @override
  String get noItems => 'Noch keine Gegenstände';

  @override
  String get noItemsHint =>
      'Füge ein Gerät oder einen Gegenstand hinzu und verknüpfe Beleg und Garantie.';

  @override
  String get noLinkTargets =>
      'Keine Gegenstände, Fahrzeuge oder Profile zum Verknüpfen.';

  @override
  String get noLinkedDocs => 'Keine verknüpften Dokumente.';

  @override
  String get noLinks => 'Dieses Dokument ist mit nichts verknüpft.';

  @override
  String get noMaintenance => 'Keine Wartungseinträge';

  @override
  String get noMaintenanceHint =>
      'Füge einen Reparatur- oder Servicebeleg hinzu, der mit dem Gegenstand verknüpft ist.';

  @override
  String get noMileage => 'Kein Kilometerstand erfasst';

  @override
  String get noNotifications => 'Keine neuen Benachrichtigungen';

  @override
  String get noRecordYet => 'Noch kein Eintrag.';

  @override
  String get noRecords => 'Noch keine Einträge';

  @override
  String get noReminders => 'Keine Erinnerungen';

  @override
  String get noRemindersCta =>
      'Füge deine erste Erinnerung hinzu – Zulassung, Garantie, Vertrag…';

  @override
  String get noRemindersHint =>
      'Erinnerungen informieren dich rechtzeitig über wichtige Fristen.';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get noResultsFiltered => 'Keine Dokumente entsprechen den Filtern.';

  @override
  String get noResultsHint =>
      'Versuche einen anderen Begriff, setze Filter zurück oder füge ein Dokument hinzu.';

  @override
  String get noSharedDocs => 'Keine geteilten Dokumente.';

  @override
  String get noSharedDocsHint =>
      'Ändere die Privatsphäre eines Dokuments auf „Familie“ oder „Ausgewählte“, damit andere es sehen.';

  @override
  String get noSuggestions => 'Keine KI-Vorschläge';

  @override
  String get noSuggestionsBody =>
      'Für dieses Dokument gibt es noch keine Vorschläge.';

  @override
  String get noVehicles => 'Noch keine Fahrzeuge';

  @override
  String get noVehiclesHint =>
      'Füge ein Fahrzeug hinzu, um Servicehistorie, Kosten und Fristen zu verfolgen.';

  @override
  String get noWarrantyDate => 'Kein Garantieende eingetragen';

  @override
  String get noWarrantyFound =>
      'Auf dem Dokument wurden keine Garantieangaben gefunden. Wir nehmen keine Garantiezeit an.';

  @override
  String get none => 'Keine';

  @override
  String get notAvailable => 'Nicht verfügbar oder kein Zugriff.';

  @override
  String get notSet => 'nicht festgelegt';

  @override
  String get notes => 'Notizen';

  @override
  String get notificationChannels => 'Benachrichtigungskanäle';

  @override
  String get notificationGenericBody =>
      'Du hast eine Erinnerung, die Aufmerksamkeit braucht.';

  @override
  String get notificationTitle => 'MyWorld+ Erinnerung';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notificationsAllowed => 'Benachrichtigungen sind erlaubt';

  @override
  String get notificationsBlocked => 'Benachrichtigungen sind nicht erlaubt';

  @override
  String get notifyBefore => 'Benachrichtigen';

  @override
  String get offlineBanner =>
      'Offline – Änderungen werden später synchronisiert';

  @override
  String get onboarding1Body =>
      'Dokumente, Belege, Garantien, Gegenstände, Fahrzeuge und Familie – geordnet.';

  @override
  String get onboarding1Title => 'Alles Wichtige an einem Ort.';

  @override
  String get onboarding2Body =>
      'Mit der Kamera aufnehmen – wir erstellen ein sauberes PDF.';

  @override
  String get onboarding2Title =>
      'Dokumente, Belege und Garantien in Sekunden speichern.';

  @override
  String get onboarding3Body =>
      'Schnelle Suche und Erinnerungen an wichtige Fristen.';

  @override
  String get onboarding3Title =>
      'Finde, was du brauchst, genau dann, wenn du es brauchst.';

  @override
  String get open => 'Öffnen';

  @override
  String get openDocument => 'Dokument öffnen';

  @override
  String get openPreview => 'Vorschau öffnen';

  @override
  String get openSourceLicenses => 'Open-Source-Lizenzen';

  @override
  String get openingCamera => 'Kamera wird geöffnet…';

  @override
  String get optionalDetails => 'Weitere Angaben (optional)';

  @override
  String get orContinueWith => 'oder';

  @override
  String get overdue => 'Überfällig';

  @override
  String get ownerCannotLeave =>
      'Der Inhaber kann nicht austreten, solange andere Mitglieder da sind. Entferne sie zuerst.';

  @override
  String get pageNotFound => 'Diese Seite existiert nicht.';

  @override
  String get password => 'Passwort';

  @override
  String get passwordHelp => 'Mindestens 8 Zeichen, Buchstaben und Zahlen';

  @override
  String get passwordTooShort => 'Das Passwort muss mindestens 8 Zeichen haben';

  @override
  String get passwordWeak =>
      'Das Passwort muss Buchstaben und Zahlen enthalten';

  @override
  String get pendingInvites => 'Offene Einladungen';

  @override
  String get period => 'Zeitraum';

  @override
  String get permissionDeniedTitle => 'Kein Zugriff';

  @override
  String get permissionsExplainer =>
      'Rollen legen fest, wer die Familie verwaltet (Einladungen, Profile). Eine Rolle gewährt nie Zugriff auf die Dokumente anderer – das entscheidet die Privatsphäre jedes Dokuments.';

  @override
  String get phonesOnePerLine => 'Telefonnummern (eine pro Zeile)';

  @override
  String get photos => 'Fotos';

  @override
  String get pin => 'PIN';

  @override
  String get pinHelp => '4 bis 8 Ziffern';

  @override
  String get pinMismatch => 'Die PINs stimmen nicht überein';

  @override
  String get pinNew => 'Neue PIN';

  @override
  String get pinRepeat => 'PIN wiederholen';

  @override
  String get planFamilyBase => 'Family Base';

  @override
  String get planFamilyPro => 'Family Pro';

  @override
  String get planFromFamily => 'Tarif über deine Familie';

  @override
  String get planIndividualBase => 'Individual Base';

  @override
  String get planIndividualPro => 'Individual Pro';

  @override
  String get plansSubtitle =>
      'Wähle den Tarif, der zu dir passt. Jederzeit änderbar oder kündbar.';

  @override
  String get plansTitle => 'Tarife';

  @override
  String get price => 'Preis';

  @override
  String get privacy => 'Wer kann es sehen';

  @override
  String get privacyBullets =>
      '• Alle Dateien sind privat und nur über serverseitige Zugriffsprüfungen erreichbar.\n• Familienmitglieder sehen nur, was du ausdrücklich teilst.\n• Dokumentinhalte werden nie an Analysen, Logs oder Werbenetzwerke gesendet.\n• Das Löschen deines Kontos löscht die Daten wirklich auf dem Server.';

  @override
  String get privacyFamily => 'Familie';

  @override
  String get privacyFamilyHelp =>
      'Alle aktiven Mitglieder deiner Familie können es sehen.';

  @override
  String get privacyNoFamilyHelp =>
      'Teilen ist möglich, wenn du in einer Familie bist.';

  @override
  String get privacyPolicy => 'Datenschutzerklärung';

  @override
  String get privacyPrivate => 'Privat';

  @override
  String get privacyPrivateHelp => 'Nur du kannst es sehen.';

  @override
  String get privacySettings => 'Datenschutz';

  @override
  String get privacyShared => 'Ausgewählte';

  @override
  String get privacySharedHelp =>
      'Nur die von dir ausgewählten Mitglieder können es sehen.';

  @override
  String get processingStatus => 'Verarbeitungsstatus';

  @override
  String get profile => 'Profil';

  @override
  String get profileSetupBody =>
      'Nur ein paar Angaben. Wir fragen nichts Sensibles ab.';

  @override
  String get profileSetupTitle => 'Dein Profil';

  @override
  String get purchaseDate => 'Kaufdatum';

  @override
  String get purchaseDetails => 'Kauf';

  @override
  String get purchaseProcessed =>
      'Kauf verarbeitet. Dein Tarif wird aktualisiert…';

  @override
  String get reactivate => 'Reaktivieren';

  @override
  String get readCardWithAi => 'Karte mit KI lesen';

  @override
  String get recFuel => 'Kraftstoff';

  @override
  String get recInspection => 'Hauptuntersuchung';

  @override
  String get recInsurance => 'Versicherung';

  @override
  String get recOil => 'Ölwechsel';

  @override
  String get recOther => 'Sonstiges';

  @override
  String get recParking => 'Parken';

  @override
  String get recParts => 'Teile';

  @override
  String get recRegistration => 'Zulassung';

  @override
  String get recRepair => 'Reparatur';

  @override
  String get recService => 'Regulärer Service';

  @override
  String get recTires => 'Reifen';

  @override
  String get recTolls => 'Maut';

  @override
  String get receipts => 'Belege';

  @override
  String get receiptsAndWarranties => 'Belege und Garantien';

  @override
  String get recentRecords => 'Letzte Einträge';

  @override
  String get recentlyAdded => 'Zuletzt hinzugefügt';

  @override
  String get recordType => 'Eintragsart';

  @override
  String get refreshStatus => 'Abo-Status aktualisieren';

  @override
  String get registrationInsurance => 'Zulassung und Versicherung';

  @override
  String get registrationNumber => 'Kennzeichen';

  @override
  String get relationshipOptional => 'Beziehung (optional)';

  @override
  String get remindBeforeExpiry => 'Vor Ablauf erinnern';

  @override
  String get reminder => 'Erinnerung';

  @override
  String get reminderSaved => 'Erinnerung gespeichert';

  @override
  String get reminderSettings => 'Erinnerungseinstellungen';

  @override
  String get reminderType => 'Art';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get removeAds => 'Werbung entfernen';

  @override
  String get removeFavorite => 'Aus Favoriten entfernen';

  @override
  String get removeMember => 'Mitglied entfernen';

  @override
  String get removeMemberBody =>
      'Das Mitglied verliert sofort den Zugriff auf Familien- und geteilte Dokumente. Seine eigenen Dokumente bleiben seine.';

  @override
  String get renewsOn => 'Verlängert sich am';

  @override
  String get repeat => 'Wiederholen';

  @override
  String get repeatDaily => 'Täglich';

  @override
  String get repeatMonthly => 'Monatlich';

  @override
  String get repeatNone => 'Keine Wiederholung';

  @override
  String get repeatWeekly => 'Wöchentlich';

  @override
  String get repeatYearly => 'Jährlich';

  @override
  String get required => 'Pflichtfeld';

  @override
  String get resendEmail => 'E-Mail erneut senden';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get resetPasswordBody =>
      'Gib deine E-Mail ein und wir senden dir einen Link zum Festlegen eines neuen Passworts.';

  @override
  String get resetSentBody =>
      'Falls das Konto existiert, wurde ein Link gesendet. Sieh auch im Spam-Ordner nach.';

  @override
  String get resetSentTitle => 'Prüfe deine E-Mails';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get restoreDone => 'Käufe geprüft';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get restored => 'Wiederhergestellt';

  @override
  String get retake => 'Neu aufnehmen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get reviewSuggestions => 'KI-Vorschläge prüfen';

  @override
  String get revoke => 'Widerrufen';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMember => 'Mitglied';

  @override
  String get roleOwner => 'Inhaber';

  @override
  String get rotate => 'Drehen';

  @override
  String get save => 'Speichern';

  @override
  String get saveAnyway => 'Trotzdem speichern';

  @override
  String get saveDocumentTitle => 'Dokument speichern';

  @override
  String get saveToVault => 'Im Tresor speichern';

  @override
  String get saveToVaultHelp =>
      'Für besonders wichtige persönliche Dokumente. Wird nie für KI-Fragen verwendet.';

  @override
  String get saved => 'Gespeichert';

  @override
  String get scanBarcode => 'Barcode / QR scannen';

  @override
  String get scanBarcodeHelp =>
      'Richte die Kamera auf den Barcode oder QR-Code';

  @override
  String get scanReviewHelp =>
      'Prüfe die Seiten. Du kannst sie drehen, neu aufnehmen, löschen oder durch Ziehen neu ordnen.';

  @override
  String get search => 'Suche';

  @override
  String get searchCards => 'Karten durchsuchen';

  @override
  String get searchContacts => 'Kontakte durchsuchen';

  @override
  String get searchHint => 'Was suchst du heute?';

  @override
  String get searchItems => 'Gegenstände durchsuchen';

  @override
  String get searchStartBody =>
      'Suche nach Name, Kategorie, Händler, Person, Gerät, Betrag oder Tag.';

  @override
  String get searchStartTitle => 'Fang an zu tippen';

  @override
  String get searchVault => 'Tresor durchsuchen';

  @override
  String get seeAll => 'Alle anzeigen';

  @override
  String get seePlans => 'Tarife ansehen';

  @override
  String get send => 'Senden';

  @override
  String get sendLink => 'Link senden';

  @override
  String get serialNumber => 'Seriennummer';

  @override
  String get serviceHistory => 'Servicehistorie';

  @override
  String get serviceOrVendor => 'Werkstatt oder Händler';

  @override
  String get sessionExpiredBody =>
      'Bitte melde dich zu deiner Sicherheit erneut an.';

  @override
  String get sessionExpiredTitle => 'Sitzung abgelaufen';

  @override
  String get setPin => 'Tresor-PIN festlegen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get share => 'Teilen';

  @override
  String get shareFile => 'Datei exportieren';

  @override
  String get sharedByMe => 'Von mir geteilt';

  @override
  String get sharedDocuments => 'Geteilte Dokumente';

  @override
  String get sharedWithMe => 'Mit mir geteilt';

  @override
  String get sharing => 'Teilen und Privatsphäre';

  @override
  String get sharingNeedsFamily =>
      'In Family-Tarifen kannst du Dokumente mit Familienmitgliedern teilen.';

  @override
  String get sharingServerNote =>
      'Der Zugriff wird für jedes Dokument und jede Datei auf dem Server geprüft. Entziehst du jemandem den Zugriff, verliert er ihn sofort.';

  @override
  String get sharingUpdated => 'Freigabe aktualisiert';

  @override
  String get showCompleted => 'Erledigte anzeigen';

  @override
  String get showDetailsHelp =>
      'Aus: Der Sperrbildschirm zeigt nur, dass du eine Erinnerung hast. An: Der Titel der Erinnerung wird angezeigt.';

  @override
  String get showDetailsInNotifications =>
      'Titel in der Benachrichtigung anzeigen';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get showUsedExpired => 'Verwendete und abgelaufene anzeigen';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signInTitle => 'Willkommen zurück';

  @override
  String get signInAsTester => 'Als Tester anmelden';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signUpTitle => 'Erstelle dein MyWorld+';

  @override
  String get skip => 'Überspringen';

  @override
  String get snoozeWeek => 'Eine Woche verschieben';

  @override
  String get soon => 'Bald';

  @override
  String get sortAmountAsc => 'Niedrigster Betrag';

  @override
  String get sortAmountDesc => 'Höchster Betrag';

  @override
  String get sortBy => 'Sortieren nach';

  @override
  String get sortExpiry => 'Ablaufdatum';

  @override
  String get sortNameAsc => 'Name A–Z';

  @override
  String get sortNameDesc => 'Name Z–A';

  @override
  String get sortNewest => 'Neueste';

  @override
  String get sortOldest => 'Älteste';

  @override
  String get source => 'Quelle';

  @override
  String get sources => 'Quellen';

  @override
  String get startExport => 'Export erstellen';

  @override
  String get status => 'Status';

  @override
  String get statusActive => 'Aktiv';

  @override
  String get statusCancelled => 'Gekündigt';

  @override
  String get statusDiscarded => 'Verworfen';

  @override
  String get statusDone => 'Erledigt';

  @override
  String get statusDraft => 'Entwurf';

  @override
  String get statusFailed => 'Fehlgeschlagen';

  @override
  String get statusInRepair => 'In Reparatur';

  @override
  String get statusNeedsReview => 'Prüfung nötig';

  @override
  String get statusProcessing => 'In Bearbeitung';

  @override
  String get statusReady => 'Bereit';

  @override
  String get statusRefreshed => 'Status aktualisiert';

  @override
  String get statusSnoozed => 'Verschoben';

  @override
  String get statusSold => 'Verkauft';

  @override
  String get statusUploaded => 'Hochgeladen';

  @override
  String get statusUploading => 'Wird hochgeladen';

  @override
  String get storage => 'Speicher';

  @override
  String get storageAlmostFull => 'Der Speicher ist fast voll';

  @override
  String get subActive => 'Aktiv';

  @override
  String get subBillingIssue => 'Zahlungsproblem';

  @override
  String get subCancelled => 'Gekündigt – gültig bis Ende des Zeitraums';

  @override
  String get subExpired => 'Abgelaufen';

  @override
  String get subNone => 'Kostenloser Tarif';

  @override
  String get subRefunded => 'Erstattet';

  @override
  String get subscriptionTerms =>
      'Das Abo verlängert sich monatlich, bis du es in den Einstellungen des App Store oder von Google Play kündigst. Die Zahlung wird über dein Store-Konto abgerechnet.';

  @override
  String get summary => 'Übersicht';

  @override
  String get supportPrivacyNote =>
      'Sende dem Support nie Passwörter oder Dokumentinhalte.';

  @override
  String get tagline => 'Dein Leben. An einem Ort.';

  @override
  String get tags => 'Tags';

  @override
  String get takePhoto => 'Foto aufnehmen';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get thisYear => 'Dieses Jahr';

  @override
  String get timezone => 'Zeitzone';

  @override
  String get title => 'Titel';

  @override
  String get today => 'Heute';

  @override
  String get tomorrow => 'Morgen';

  @override
  String get totalInvested => 'Insgesamt investiert';

  @override
  String get totalValue => 'Gesamtwert';

  @override
  String get trash => 'Papierkorb';

  @override
  String get trashEmpty => 'Der Papierkorb ist leer';

  @override
  String get trashRetention =>
      'Dokumente im Papierkorb werden nach 30 Tagen endgültig gelöscht.';

  @override
  String get tryAi => 'KI fragen';

  @override
  String get typeDeleteToConfirm => 'Gib LÖSCHEN ein, um zu bestätigen';

  @override
  String get unlock => 'Entsperren';

  @override
  String get unlockVaultReason => 'Tresor entsperren';

  @override
  String get upcomingDeadlines => 'Anstehende Fristen';

  @override
  String get upgradeAiBody =>
      'Die KI liest Belege, schlägt Kategorien und Erinnerungen vor und beantwortet Fragen zu deinen Daten – mit Quellen.';

  @override
  String get upgradeAiTitle => 'KI-Hilfe gibt es in den Pro-Tarifen';

  @override
  String get upgradeDocumentsBody =>
      'Du hast die Dokumentanzahl des kostenlosen Tarifs erreicht. Es wird nichts gelöscht – wähle einen größeren Tarif für mehr Platz.';

  @override
  String get upgradeDocumentsTitle => 'Dokumentlimit';

  @override
  String get upgradeExportBody => 'Der CSV-Export ist Teil der Pro-Tarife.';

  @override
  String get upgradeExportTitle => 'Erweiterter Export';

  @override
  String get upgradeFamilyBody =>
      'Ein Familienbereich, Einladungen und das Teilen von Dokumenten sind in Family Base und Family Pro verfügbar.';

  @override
  String get upgradeFamilyTitle => 'Family-Tarif';

  @override
  String get upgradeFiltersBody =>
      'Filter nach Verarbeitungsstatus und erweiterte Suche gibt es in kostenpflichtigen Tarifen.';

  @override
  String get upgradeFiltersTitle => 'Erweiterte Filter';

  @override
  String get upgradeStorageBody =>
      'Es wurde nichts gelöscht. Wähle einen größeren Tarif oder schaffe Platz.';

  @override
  String get upgradeStorageTitle => 'Der Speicher ist voll';

  @override
  String get upgradeVehiclesBody =>
      'Dein Tarif erlaubt eine begrenzte Anzahl an Fahrzeugen. Ein größerer Tarif erlaubt mehr.';

  @override
  String get upgradeVehiclesTitle => 'Fahrzeuglimit';

  @override
  String get uploadErrorTitle => 'Hochladen fehlgeschlagen';

  @override
  String get uploadFailedHint =>
      'Die Datei wurde nicht hochgeladen oder hat die Prüfung nicht bestanden. Lade sie erneut hoch.';

  @override
  String get uploadKeepOpen =>
      'Lass die App geöffnet, bis das Hochladen abgeschlossen ist.';

  @override
  String get useBiometrics => 'Biometrie verwenden';

  @override
  String get useRegularSearch => 'Normale Suche verwenden';

  @override
  String get validFrom => 'Gültig ab';

  @override
  String get vaultEmpty => 'Der Tresor ist leer';

  @override
  String get vaultEmptyBody =>
      'Bewahre hier persönliche Dokumente, Verträge, Policen und Urkunden auf.';

  @override
  String get vaultLockDisclaimer =>
      'PIN und Biometrie schützen zusätzlich beim Öffnen des Tresors auf diesem Gerät. Das ist keine Verschlüsselung: Deine Dateien sind unabhängig von der PIN durch serverseitige Zugriffsprüfungen geschützt.';

  @override
  String get vaultLocked => 'Der Tresor ist gesperrt';

  @override
  String get vaultLockedBody => 'Gib deine PIN ein oder verwende Biometrie.';

  @override
  String get vaultSettings => 'Tresor-Einstellungen';

  @override
  String get vaultSubtitle =>
      'Private und besonders wichtige Dokumente. Hier gibt es keine Werbung.';

  @override
  String get vendor => 'Händler';

  @override
  String get verifyEmailTitle => 'Bestätige deine E-Mail';

  @override
  String get warrantiesExpiring => 'Ablaufende Garantien';

  @override
  String get warranty => 'Garantie';

  @override
  String get warrantyConfirm => 'Ich bestätige das Garantiedatum';

  @override
  String get warrantyConfirmHelp =>
      'Prüfe den Garantieschein. Die Garantie wird nie ohne deine Bestätigung festgelegt.';

  @override
  String get warrantyFieldHelp =>
      'Nur ausfüllen, wenn es auf dem Garantieschein steht';

  @override
  String get warrantySuggestion => 'Vorschlag aus dem Dokument';

  @override
  String get warrantyUntil => 'Garantie bis';

  @override
  String get warrantyUserEnteredNote =>
      'Das Garantiedatum ist das, das du eingegeben oder bestätigt hast.';

  @override
  String get website => 'Website';

  @override
  String get welcome => 'Willkommen';

  @override
  String get withReminder => 'Mit Erinnerung';

  @override
  String get withWarranty => 'Mit Garantie';

  @override
  String get worldSubtitle => 'Alle Bereiche deines Lebens';

  @override
  String get year => 'Jahr';

  @override
  String get you => 'du';

  @override
  String addDocumentFor(String name) {
    return 'Dokument für $name';
  }

  @override
  String cardExpiresTitle(String name) {
    return 'Karte läuft ab: $name';
  }

  @override
  String cardsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Karten',
      one: '$count Karte',
      zero: 'Keine Karten',
    );
    return '$_temp0';
  }

  @override
  String cardsExpiringSoon(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Karten laufen innerhalb von 2 Wochen ab',
      one: '$count Karte läuft innerhalb von 2 Wochen ab',
    );
    return '$_temp0';
  }

  @override
  String contactsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kontakte',
      one: '$count Kontakt',
      zero: 'Keine Kontakte',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'vor $count Tagen',
      one: 'vor $count Tag',
    );
    return '$_temp0';
  }

  @override
  String daysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage vorher',
      one: '$count Tag vorher',
    );
    return '$_temp0';
  }

  @override
  String documentExpiresTitle(String title) {
    return 'Läuft ab: $title';
  }

  @override
  String documentsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dokumente',
      one: '$count Dokument',
      zero: 'Keine Dokumente',
    );
    return '$_temp0';
  }

  @override
  String documentsUsed(int used, int limit) {
    return 'Dokumente: $used von $limit';
  }

  @override
  String duplicateBody(String title) {
    return 'Dieselbe Datei ist bereits als „$title“ gespeichert. Erneut speichern?';
  }

  @override
  String expiresOn(String date) {
    return 'Läuft ab am $date';
  }

  @override
  String featureDocuments(String count) {
    return 'Bis zu $count Dokumente';
  }

  @override
  String featureMembers(int count) {
    return 'Bis zu $count Familienmitglieder';
  }

  @override
  String featureStorage(String size) {
    return '$size Speicher';
  }

  @override
  String helloName(String name) {
    return 'Hallo, $name';
  }

  @override
  String hoursBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stunden vorher',
      one: '$count Stunde vorher',
    );
    return '$_temp0';
  }

  @override
  String inDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count Tagen',
      one: 'in $count Tag',
    );
    return '$_temp0';
  }

  @override
  String invitationBody(String name) {
    return '$name lädt dich in den Familienbereich ein. Durch das Annehmen erhältst du keinen Zugriff auf alle Dokumente – du siehst nur, was andere mit dir teilen.';
  }

  @override
  String inviteShareText(String link) {
    return 'Tritt unserer Familie auf MyWorld+ bei: $link';
  }

  @override
  String invitedTo(String name) {
    return 'Einladung zu „$name“';
  }

  @override
  String itemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Gegenstände',
      one: '$count Gegenstand',
      zero: 'Keine Gegenstände',
    );
    return '$_temp0';
  }

  @override
  String joinedOn(String date) {
    return 'Mitglied seit $date';
  }

  @override
  String last12Months(String currency) {
    return 'Letzte 12 Monate $currency';
  }

  @override
  String lastOn(String date) {
    return 'Zuletzt: $date';
  }

  @override
  String membersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '$count Mitglied',
    );
    return '$_temp0';
  }

  @override
  String minutesBefore(int count) {
    return '$count Min. vorher';
  }

  @override
  String nextDue(String date) {
    return 'Nächster: $date';
  }

  @override
  String offerReminderBody(String date) {
    return 'Möchtest du eine Erinnerung für den $date?';
  }

  @override
  String pageN(int n) {
    return 'Seite $n';
  }

  @override
  String pagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '$count Seite',
    );
    return '$_temp0';
  }

  @override
  String pricePerMonth(String price) {
    return '$price € / Monat';
  }

  @override
  String purchasedOn(String date) {
    return 'Gekauft am $date';
  }

  @override
  String remindersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Erinnerungen',
      one: '$count Erinnerung',
      zero: 'Keine Erinnerungen',
    );
    return '$_temp0';
  }

  @override
  String removeMemberTitle(String name) {
    return '$name entfernen?';
  }

  @override
  String reviewIntro(int percent) {
    return 'Die KI hat das Dokument gelesen (Sicherheit $percent %). Prüfe und korrigiere die Daten vor dem Speichern.';
  }

  @override
  String reviewNeededFor(String title) {
    return 'Vorschläge prüfen: $title';
  }

  @override
  String scanReviewTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Seiten',
      one: '$count Seite',
    );
    return '$_temp0';
  }

  @override
  String sharedBy(String name) {
    return 'Geteilt von $name';
  }

  @override
  String storageUsed(String used, String total) {
    return '$used von $total belegt';
  }

  @override
  String uploadProgress(int percent) {
    return 'Wird hochgeladen… $percent %';
  }

  @override
  String validUntil(String date) {
    return 'Gültig bis $date';
  }

  @override
  String vehiclesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Fahrzeuge',
      one: '$count Fahrzeug',
      zero: 'Keine Fahrzeuge',
    );
    return '$_temp0';
  }

  @override
  String verifyEmailBody(String email) {
    return 'Wir haben einen Link an $email gesendet. Öffne ihn, um dein Konto zu bestätigen.';
  }

  @override
  String warrantyActiveUntil(String date) {
    return 'Garantie gültig bis $date';
  }

  @override
  String warrantyDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Noch $count Tage Garantie',
      one: 'Noch $count Tag Garantie',
    );
    return '$_temp0';
  }

  @override
  String warrantyExpiredOn(String date) {
    return 'Garantie abgelaufen am $date';
  }

  @override
  String warrantyExpiresTitle(String name) {
    return 'Garantie läuft ab: $name';
  }

  @override
  String warrantyPrintedMonths(int months) {
    return 'Auf dem Dokument: $months Monate Garantie';
  }

  @override
  String warrantyPrintedUntil(String date) {
    return 'Auf dem Dokument: bis $date';
  }

  @override
  String warrantyUntilShort(String date) {
    return 'Garantie bis $date';
  }

  @override
  String willBeSavedIn(String destination) {
    return 'Wird gespeichert in: $destination';
  }

  @override
  String wrongPin(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falsche PIN. Noch $count Versuche.',
      one: 'Falsche PIN. Noch $count Versuch.',
    );
    return '$_temp0';
  }

  @override
  String get suggestedLinks => 'Vorgeschlagene Verknüpfungen';

  @override
  String get suggestedLinksHelp =>
      'Wir haben Einträge gefunden, die zu diesem Dokument passen. Markiere die, die du verknüpfen möchtest.';
}
