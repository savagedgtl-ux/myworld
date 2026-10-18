import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('sr'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
  ];

  /// No description provided for @accept.
  ///
  /// In sr, this message translates to:
  /// **'Prihvati'**
  String get accept;

  /// No description provided for @acceptTerms.
  ///
  /// In sr, this message translates to:
  /// **'Prihvatam uslove korišćenja i politiku privatnosti'**
  String get acceptTerms;

  /// No description provided for @accessUntil.
  ///
  /// In sr, this message translates to:
  /// **'Pristup do'**
  String get accessUntil;

  /// No description provided for @adConsent.
  ///
  /// In sr, this message translates to:
  /// **'Saglasnost za oglase'**
  String get adConsent;

  /// No description provided for @adConsentHelp.
  ///
  /// In sr, this message translates to:
  /// **'Upravljaj izborom personalizovanih oglasa. Sadržaj tvojih dokumenata se nikada ne koristi za oglase.'**
  String get adConsentHelp;

  /// No description provided for @adLabel.
  ///
  /// In sr, this message translates to:
  /// **'Oglas'**
  String get adLabel;

  /// No description provided for @add.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj'**
  String get add;

  /// No description provided for @addBusinessCard.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj vizit kartu'**
  String get addBusinessCard;

  /// No description provided for @addBusinessCardHint.
  ///
  /// In sr, this message translates to:
  /// **'Fotografiši tuđu vizit kartu'**
  String get addBusinessCardHint;

  /// No description provided for @addCategory.
  ///
  /// In sr, this message translates to:
  /// **'Nova kategorija'**
  String get addCategory;

  /// No description provided for @addDocument.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj dokument'**
  String get addDocument;

  /// No description provided for @addFamilyMember.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj člana porodice'**
  String get addFamilyMember;

  /// No description provided for @addFamilyMemberHint.
  ///
  /// In sr, this message translates to:
  /// **'Profil za člana domaćinstva, npr. dete'**
  String get addFamilyMemberHint;

  /// No description provided for @addFavorite.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj u omiljene'**
  String get addFavorite;

  /// No description provided for @addImage.
  ///
  /// In sr, this message translates to:
  /// **'Otpremi sliku'**
  String get addImage;

  /// No description provided for @addImageHint.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi fotografije iz galerije'**
  String get addImageHint;

  /// No description provided for @addItem.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj predmet'**
  String get addItem;

  /// No description provided for @addItemHint.
  ///
  /// In sr, this message translates to:
  /// **'Uređaj, nameštaj, oprema, kolekcija…'**
  String get addItemHint;

  /// No description provided for @addMemberHelp.
  ///
  /// In sr, this message translates to:
  /// **'Profil ne zahteva nalog niti osetljive podatke. Dokumenti se povezuju sa profilom, a vidljivost određuje svaki dokument posebno.'**
  String get addMemberHelp;

  /// No description provided for @addPage.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj stranu'**
  String get addPage;

  /// No description provided for @addPdf.
  ///
  /// In sr, this message translates to:
  /// **'Otpremi PDF'**
  String get addPdf;

  /// No description provided for @addPdfHint.
  ///
  /// In sr, this message translates to:
  /// **'Postojeći PDF sa telefona'**
  String get addPdfHint;

  /// No description provided for @addPhoto.
  ///
  /// In sr, this message translates to:
  /// **'Fotografiši'**
  String get addPhoto;

  /// No description provided for @addPhotoHint.
  ///
  /// In sr, this message translates to:
  /// **'Jedna fotografija kamerom'**
  String get addPhotoHint;

  /// No description provided for @addRecord.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj evidenciju'**
  String get addRecord;

  /// No description provided for @addReminder.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj podsetnik'**
  String get addReminder;

  /// No description provided for @addReminderHint.
  ///
  /// In sr, this message translates to:
  /// **'Rok, obnova, godišnjica…'**
  String get addReminderHint;

  /// No description provided for @addRepairReceipt.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj račun za popravku'**
  String get addRepairReceipt;

  /// No description provided for @addScan.
  ///
  /// In sr, this message translates to:
  /// **'Skeniraj dokument'**
  String get addScan;

  /// No description provided for @addScanHint.
  ///
  /// In sr, this message translates to:
  /// **'Kamera prepoznaje ivice, više strana u jedan PDF'**
  String get addScanHint;

  /// No description provided for @addServiceRecord.
  ///
  /// In sr, this message translates to:
  /// **'Račun za servis ili trošak'**
  String get addServiceRecord;

  /// No description provided for @addServiceRecordHint.
  ///
  /// In sr, this message translates to:
  /// **'Za ovo vozilo'**
  String get addServiceRecordHint;

  /// No description provided for @addTitle.
  ///
  /// In sr, this message translates to:
  /// **'Šta dodaješ?'**
  String get addTitle;

  /// No description provided for @addVehicle.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj vozilo'**
  String get addVehicle;

  /// No description provided for @addVehicleRecord.
  ///
  /// In sr, this message translates to:
  /// **'Evidencija vozila'**
  String get addVehicleRecord;

  /// No description provided for @addVehicleRecordHint.
  ///
  /// In sr, this message translates to:
  /// **'Servis, registracija, gorivo, gume…'**
  String get addVehicleRecordHint;

  /// No description provided for @addWalletCard.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj karticu'**
  String get addWalletCard;

  /// No description provided for @addWalletCardHint.
  ///
  /// In sr, this message translates to:
  /// **'Kartica lojalnosti, popust ili kupon'**
  String get addWalletCardHint;

  /// No description provided for @address.
  ///
  /// In sr, this message translates to:
  /// **'Adresa'**
  String get address;

  /// No description provided for @adsOffForPlan.
  ///
  /// In sr, this message translates to:
  /// **'Tvoj paket je bez oglasa.'**
  String get adsOffForPlan;

  /// No description provided for @aiAnalyze.
  ///
  /// In sr, this message translates to:
  /// **'AI analiza dokumenta'**
  String get aiAnalyze;

  /// No description provided for @aiAnalyzeAgain.
  ///
  /// In sr, this message translates to:
  /// **'Analiziraj pomoću AI'**
  String get aiAnalyzeAgain;

  /// No description provided for @aiAnalyzeHelp.
  ///
  /// In sr, this message translates to:
  /// **'AI predlaže naziv, datum, iznos i kategoriju. Ti potvrđuješ pre čuvanja.'**
  String get aiAnalyzeHelp;

  /// No description provided for @aiAndYourData.
  ///
  /// In sr, this message translates to:
  /// **'AI i tvoji podaci'**
  String get aiAndYourData;

  /// No description provided for @aiAnswer.
  ///
  /// In sr, this message translates to:
  /// **'Odgovor'**
  String get aiAnswer;

  /// No description provided for @aiDataNote.
  ///
  /// In sr, this message translates to:
  /// **'Kada koristiš AI, šalje se samo ono što je potrebno za taj zahtev: tekst ili slika jednog dokumenta za analizu, odnosno kratki metapodaci dozvoljenih zapisa za pitanje. Vault dokumenti se ne koriste u pitanjima. Podaci se ne koriste za treniranje modela i ne čuvaju se kod AI servisa.'**
  String get aiDataNote;

  /// No description provided for @aiExample1.
  ///
  /// In sr, this message translates to:
  /// **'Kada mi ističe garancija za mašinu za veš?'**
  String get aiExample1;

  /// No description provided for @aiExample2.
  ///
  /// In sr, this message translates to:
  /// **'Koliko sam potrošio na automobil ove godine?'**
  String get aiExample2;

  /// No description provided for @aiExample3.
  ///
  /// In sr, this message translates to:
  /// **'Pronađi ugovore koji ističu u naredna tri meseca.'**
  String get aiExample3;

  /// No description provided for @aiExample4.
  ///
  /// In sr, this message translates to:
  /// **'Koje račune imam za kupovine preko 200 evra?'**
  String get aiExample4;

  /// No description provided for @aiFilledCheck.
  ///
  /// In sr, this message translates to:
  /// **'Polja su popunjena. Proveri ih pre čuvanja.'**
  String get aiFilledCheck;

  /// No description provided for @aiHint.
  ///
  /// In sr, this message translates to:
  /// **'Postavi pitanje o svojim podacima…'**
  String get aiHint;

  /// No description provided for @aiInsufficientNote.
  ///
  /// In sr, this message translates to:
  /// **'Odgovaram samo na osnovu sačuvanih podataka. Ako nešto nedostaje, dodaj dokument ili dopuni podatke.'**
  String get aiInsufficientNote;

  /// No description provided for @aiIntro.
  ///
  /// In sr, this message translates to:
  /// **'Pitaj o svojim dokumentima, stvarima, vozilima i rokovima. Odgovor uvek sadrži izvore.'**
  String get aiIntro;

  /// No description provided for @aiLimitsNote.
  ///
  /// In sr, this message translates to:
  /// **'Mesečni limit štiti od neočekivanih troškova. Resetuje se početkom meseca.'**
  String get aiLimitsNote;

  /// No description provided for @aiNoData.
  ///
  /// In sr, this message translates to:
  /// **'Nemam dovoljno podataka da odgovorim na ovo pitanje.'**
  String get aiNoData;

  /// No description provided for @aiNotInPlanHint.
  ///
  /// In sr, this message translates to:
  /// **'AI analiza je dostupna u Individual Pro i Family Pro paketima. Dokument možeš da sačuvaš i uređuješ ručno.'**
  String get aiNotInPlanHint;

  /// No description provided for @aiPrivacyNote.
  ///
  /// In sr, this message translates to:
  /// **'AI vidi samo zapise kojima ti imaš pristup.'**
  String get aiPrivacyNote;

  /// No description provided for @aiProcessing.
  ///
  /// In sr, this message translates to:
  /// **'AI obrađuje dokument…'**
  String get aiProcessing;

  /// No description provided for @aiRequestsThisMonth.
  ///
  /// In sr, this message translates to:
  /// **'AI zahtevi ovog meseca'**
  String get aiRequestsThisMonth;

  /// No description provided for @aiSearchLocked.
  ///
  /// In sr, this message translates to:
  /// **'AI pretraga prirodnim jezikom je dostupna u Pro paketima'**
  String get aiSearchLocked;

  /// No description provided for @aiThinking.
  ///
  /// In sr, this message translates to:
  /// **'Tražim u tvojim podacima…'**
  String get aiThinking;

  /// No description provided for @aiUsage.
  ///
  /// In sr, this message translates to:
  /// **'AI potrošnja i limiti'**
  String get aiUsage;

  /// No description provided for @aiVerifyNote.
  ///
  /// In sr, this message translates to:
  /// **'AI može da pogreši. Važne informacije proveri u izvoru.'**
  String get aiVerifyNote;

  /// No description provided for @all.
  ///
  /// In sr, this message translates to:
  /// **'Sve'**
  String get all;

  /// No description provided for @allDocuments.
  ///
  /// In sr, this message translates to:
  /// **'Svi dokumenti'**
  String get allDocuments;

  /// No description provided for @allItems.
  ///
  /// In sr, this message translates to:
  /// **'Svi predmeti'**
  String get allItems;

  /// No description provided for @allow.
  ///
  /// In sr, this message translates to:
  /// **'Dozvoli'**
  String get allow;

  /// No description provided for @amount.
  ///
  /// In sr, this message translates to:
  /// **'Iznos'**
  String get amount;

  /// No description provided for @analyticsConsent.
  ///
  /// In sr, this message translates to:
  /// **'Anonimna analitika korišćenja'**
  String get analyticsConsent;

  /// No description provided for @analyticsConsentHelp.
  ///
  /// In sr, this message translates to:
  /// **'Pomaže nam da poboljšamo aplikaciju. Nikada ne šalje sadržaj, nazive ni podatke iz dokumenata.'**
  String get analyticsConsentHelp;

  /// No description provided for @anyTime.
  ///
  /// In sr, this message translates to:
  /// **'Bilo kada'**
  String get anyTime;

  /// No description provided for @appTitle.
  ///
  /// In sr, this message translates to:
  /// **'MyWorld+'**
  String get appTitle;

  /// No description provided for @appWorksWithoutAi.
  ///
  /// In sr, this message translates to:
  /// **'Aplikacija radi i bez AI: čuvanje, pregled, pretraga i podsetnici su dostupni u svim paketima.'**
  String get appWorksWithoutAi;

  /// No description provided for @apply.
  ///
  /// In sr, this message translates to:
  /// **'Primeni'**
  String get apply;

  /// No description provided for @areaBusinessCards.
  ///
  /// In sr, this message translates to:
  /// **'My Business Cards'**
  String get areaBusinessCards;

  /// No description provided for @areaBusinessCardsSub.
  ///
  /// In sr, this message translates to:
  /// **'Tuđe vizit karte'**
  String get areaBusinessCardsSub;

  /// No description provided for @areaCar.
  ///
  /// In sr, this message translates to:
  /// **'My Car'**
  String get areaCar;

  /// No description provided for @areaCarSub.
  ///
  /// In sr, this message translates to:
  /// **'Vozila i troškovi'**
  String get areaCarSub;

  /// No description provided for @areaCards.
  ///
  /// In sr, this message translates to:
  /// **'My Cards'**
  String get areaCards;

  /// No description provided for @areaCardsSub.
  ///
  /// In sr, this message translates to:
  /// **'Popusti i kuponi'**
  String get areaCardsSub;

  /// No description provided for @areaDocuments.
  ///
  /// In sr, this message translates to:
  /// **'My Documents'**
  String get areaDocuments;

  /// No description provided for @areaDocumentsSub.
  ///
  /// In sr, this message translates to:
  /// **'Centralni arhiv'**
  String get areaDocumentsSub;

  /// No description provided for @areaFamily.
  ///
  /// In sr, this message translates to:
  /// **'My Family'**
  String get areaFamily;

  /// No description provided for @areaFamilySub.
  ///
  /// In sr, this message translates to:
  /// **'Porodični prostor'**
  String get areaFamilySub;

  /// No description provided for @areaHobby.
  ///
  /// In sr, this message translates to:
  /// **'My Hobby'**
  String get areaHobby;

  /// No description provided for @areaHobbySub.
  ///
  /// In sr, this message translates to:
  /// **'Oprema i kolekcije'**
  String get areaHobbySub;

  /// No description provided for @areaHome.
  ///
  /// In sr, this message translates to:
  /// **'My Home'**
  String get areaHome;

  /// No description provided for @areaHomeSub.
  ///
  /// In sr, this message translates to:
  /// **'Stvari u domu'**
  String get areaHomeSub;

  /// No description provided for @areaLife.
  ///
  /// In sr, this message translates to:
  /// **'My Life'**
  String get areaLife;

  /// No description provided for @areaLifeSub.
  ///
  /// In sr, this message translates to:
  /// **'Rokovi i obaveze'**
  String get areaLifeSub;

  /// No description provided for @askAi.
  ///
  /// In sr, this message translates to:
  /// **'Pitaj AI'**
  String get askAi;

  /// No description provided for @askAiInstead.
  ///
  /// In sr, this message translates to:
  /// **'Postavi pitanje AI asistentu'**
  String get askAiInstead;

  /// No description provided for @assignedItems.
  ///
  /// In sr, this message translates to:
  /// **'Dodeljene stvari'**
  String get assignedItems;

  /// No description provided for @atTime.
  ///
  /// In sr, this message translates to:
  /// **'U vreme roka'**
  String get atTime;

  /// No description provided for @attachReceipt.
  ///
  /// In sr, this message translates to:
  /// **'Skeniraj račun'**
  String get attachReceipt;

  /// No description provided for @back.
  ///
  /// In sr, this message translates to:
  /// **'Poleđina'**
  String get back;

  /// No description provided for @backToSignIn.
  ///
  /// In sr, this message translates to:
  /// **'Nazad na prijavu'**
  String get backToSignIn;

  /// No description provided for @balance.
  ///
  /// In sr, this message translates to:
  /// **'Stanje'**
  String get balance;

  /// No description provided for @barcodeFormat.
  ///
  /// In sr, this message translates to:
  /// **'Format koda'**
  String get barcodeFormat;

  /// No description provided for @barcodeInvalid.
  ///
  /// In sr, this message translates to:
  /// **'Kod nije ispravan za izabrani format'**
  String get barcodeInvalid;

  /// No description provided for @barcodeValue.
  ///
  /// In sr, this message translates to:
  /// **'Vrednost koda'**
  String get barcodeValue;

  /// No description provided for @billingIssueBody.
  ///
  /// In sr, this message translates to:
  /// **'Naplata nije uspela. Proveri način plaćanja u prodavnici kako ne bi izgubio pristup funkcijama.'**
  String get billingIssueBody;

  /// No description provided for @billingNotConfigured.
  ///
  /// In sr, this message translates to:
  /// **'Kupovina trenutno nije dostupna na ovom uređaju.'**
  String get billingNotConfigured;

  /// No description provided for @brand.
  ///
  /// In sr, this message translates to:
  /// **'Proizvođač'**
  String get brand;

  /// No description provided for @brandModel.
  ///
  /// In sr, this message translates to:
  /// **'Proizvođač i model'**
  String get brandModel;

  /// No description provided for @byCategory.
  ///
  /// In sr, this message translates to:
  /// **'Po kategoriji'**
  String get byCategory;

  /// No description provided for @cancel.
  ///
  /// In sr, this message translates to:
  /// **'Otkaži'**
  String get cancel;

  /// No description provided for @cardCoupon.
  ///
  /// In sr, this message translates to:
  /// **'Kupon'**
  String get cardCoupon;

  /// No description provided for @cardDiscount.
  ///
  /// In sr, this message translates to:
  /// **'Popust'**
  String get cardDiscount;

  /// No description provided for @cardGift.
  ///
  /// In sr, this message translates to:
  /// **'Poklon kartica'**
  String get cardGift;

  /// No description provided for @cardLoyalty.
  ///
  /// In sr, this message translates to:
  /// **'Lojalnost'**
  String get cardLoyalty;

  /// No description provided for @cardMembership.
  ///
  /// In sr, this message translates to:
  /// **'Članska'**
  String get cardMembership;

  /// No description provided for @cardName.
  ///
  /// In sr, this message translates to:
  /// **'Naziv'**
  String get cardName;

  /// No description provided for @cardNameHelp.
  ///
  /// In sr, this message translates to:
  /// **'Npr. Maxi, DM, apoteka…'**
  String get cardNameHelp;

  /// No description provided for @cardNumber.
  ///
  /// In sr, this message translates to:
  /// **'Broj kartice'**
  String get cardNumber;

  /// No description provided for @cardOther.
  ///
  /// In sr, this message translates to:
  /// **'Ostalo'**
  String get cardOther;

  /// No description provided for @categories.
  ///
  /// In sr, this message translates to:
  /// **'Kategorije'**
  String get categories;

  /// No description provided for @category.
  ///
  /// In sr, this message translates to:
  /// **'Kategorija'**
  String get category;

  /// No description provided for @changePhoto.
  ///
  /// In sr, this message translates to:
  /// **'Promeni fotografiju'**
  String get changePhoto;

  /// No description provided for @changePlan.
  ///
  /// In sr, this message translates to:
  /// **'Promeni paket'**
  String get changePlan;

  /// No description provided for @channelLocal.
  ///
  /// In sr, this message translates to:
  /// **'Obaveštenje na uređaju'**
  String get channelLocal;

  /// No description provided for @channelLocalHelp.
  ///
  /// In sr, this message translates to:
  /// **'Radi i bez interneta'**
  String get channelLocalHelp;

  /// No description provided for @channelPush.
  ///
  /// In sr, this message translates to:
  /// **'Push obaveštenje'**
  String get channelPush;

  /// No description provided for @channelPushHelp.
  ///
  /// In sr, this message translates to:
  /// **'Stiže i kada je aplikacija zatvorena'**
  String get channelPushHelp;

  /// No description provided for @checkThisField.
  ///
  /// In sr, this message translates to:
  /// **'Proveri ovo polje'**
  String get checkThisField;

  /// No description provided for @chooseCurrency.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi valutu'**
  String get chooseCurrency;

  /// No description provided for @chooseFromGallery.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi iz galerije'**
  String get chooseFromGallery;

  /// No description provided for @choosePlan.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi paket'**
  String get choosePlan;

  /// No description provided for @chooseVehicle.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi vozilo'**
  String get chooseVehicle;

  /// No description provided for @clear.
  ///
  /// In sr, this message translates to:
  /// **'Obriši'**
  String get clear;

  /// No description provided for @clearFilters.
  ///
  /// In sr, this message translates to:
  /// **'Ukloni filtere'**
  String get clearFilters;

  /// No description provided for @close.
  ///
  /// In sr, this message translates to:
  /// **'Zatvori'**
  String get close;

  /// No description provided for @code.
  ///
  /// In sr, this message translates to:
  /// **'Kod'**
  String get code;

  /// No description provided for @color.
  ///
  /// In sr, this message translates to:
  /// **'Boja'**
  String get color;

  /// No description provided for @company.
  ///
  /// In sr, this message translates to:
  /// **'Firma'**
  String get company;

  /// No description provided for @confirmAndSave.
  ///
  /// In sr, this message translates to:
  /// **'Potvrdi i sačuvaj'**
  String get confirmAndSave;

  /// No description provided for @confirmDateHint.
  ///
  /// In sr, this message translates to:
  /// **'Proveri datum pre čuvanja.'**
  String get confirmDateHint;

  /// No description provided for @contactSupport.
  ///
  /// In sr, this message translates to:
  /// **'Kontaktiraj podršku'**
  String get contactSupport;

  /// No description provided for @contextSection.
  ///
  /// In sr, this message translates to:
  /// **'Kontekst'**
  String get contextSection;

  /// No description provided for @continueApple.
  ///
  /// In sr, this message translates to:
  /// **'Nastavi uz Apple'**
  String get continueApple;

  /// No description provided for @continueGoogle.
  ///
  /// In sr, this message translates to:
  /// **'Nastavi uz Google'**
  String get continueGoogle;

  /// No description provided for @continueLabel.
  ///
  /// In sr, this message translates to:
  /// **'Nastavi'**
  String get continueLabel;

  /// No description provided for @copied.
  ///
  /// In sr, this message translates to:
  /// **'Kopirano'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In sr, this message translates to:
  /// **'Kopiraj'**
  String get copy;

  /// No description provided for @createAccount.
  ///
  /// In sr, this message translates to:
  /// **'Napravi nalog'**
  String get createAccount;

  /// No description provided for @createFamily.
  ///
  /// In sr, this message translates to:
  /// **'Napravi porodicu'**
  String get createFamily;

  /// No description provided for @createInviteLink.
  ///
  /// In sr, this message translates to:
  /// **'Napravi pozivni link'**
  String get createInviteLink;

  /// No description provided for @createReminder.
  ///
  /// In sr, this message translates to:
  /// **'Napravi podsetnik'**
  String get createReminder;

  /// No description provided for @currency.
  ///
  /// In sr, this message translates to:
  /// **'Valuta'**
  String get currency;

  /// No description provided for @currentMileage.
  ///
  /// In sr, this message translates to:
  /// **'Trenutna kilometraža'**
  String get currentMileage;

  /// No description provided for @currentMileageKm.
  ///
  /// In sr, this message translates to:
  /// **'Trenutna kilometraža (km)'**
  String get currentMileageKm;

  /// No description provided for @currentPlan.
  ///
  /// In sr, this message translates to:
  /// **'Trenutni'**
  String get currentPlan;

  /// No description provided for @date.
  ///
  /// In sr, this message translates to:
  /// **'Datum'**
  String get date;

  /// No description provided for @dateOptions.
  ///
  /// In sr, this message translates to:
  /// **'Na dokumentu postoji više datuma — izaberi pravi:'**
  String get dateOptions;

  /// No description provided for @decline.
  ///
  /// In sr, this message translates to:
  /// **'Odbij'**
  String get decline;

  /// No description provided for @delete.
  ///
  /// In sr, this message translates to:
  /// **'Obriši'**
  String get delete;

  /// No description provided for @deleteAccount.
  ///
  /// In sr, this message translates to:
  /// **'Obriši nalog'**
  String get deleteAccount;

  /// No description provided for @deleteAccountForever.
  ///
  /// In sr, this message translates to:
  /// **'Trajno obriši nalog'**
  String get deleteAccountForever;

  /// No description provided for @deleteCancelStoreFirst.
  ///
  /// In sr, this message translates to:
  /// **'Pretplata se vodi u App Store / Google Play. Otkaži je tamo kako ti ne bi bila naplaćena posle brisanja naloga.'**
  String get deleteCancelStoreFirst;

  /// No description provided for @deleteCard.
  ///
  /// In sr, this message translates to:
  /// **'Obriši karticu'**
  String get deleteCard;

  /// No description provided for @deleteCardBody.
  ///
  /// In sr, this message translates to:
  /// **'Kartica i njene fotografije biće obrisane.'**
  String get deleteCardBody;

  /// No description provided for @deleteCategory.
  ///
  /// In sr, this message translates to:
  /// **'Obriši kategoriju'**
  String get deleteCategory;

  /// No description provided for @deleteCategoryBody.
  ///
  /// In sr, this message translates to:
  /// **'Dokumenti ostaju sačuvani, samo gube ovu kategoriju.'**
  String get deleteCategoryBody;

  /// No description provided for @deleteConsequences.
  ///
  /// In sr, this message translates to:
  /// **'Brišu se svi tvoji dokumenti, fajlovi, predmeti, vozila, kartice, kontakti i podsetnici. Gubiš pristup porodičnom prostoru. Ova radnja se ne može poništiti.'**
  String get deleteConsequences;

  /// No description provided for @deleteConsequencesTitle.
  ///
  /// In sr, this message translates to:
  /// **'Šta se dešava'**
  String get deleteConsequencesTitle;

  /// No description provided for @deleteContact.
  ///
  /// In sr, this message translates to:
  /// **'Obriši kontakt'**
  String get deleteContact;

  /// No description provided for @deleteContactBody.
  ///
  /// In sr, this message translates to:
  /// **'Vizit karta i fotografije biće obrisane.'**
  String get deleteContactBody;

  /// No description provided for @deleteForever.
  ///
  /// In sr, this message translates to:
  /// **'Obriši trajno'**
  String get deleteForever;

  /// No description provided for @deleteForeverBody.
  ///
  /// In sr, this message translates to:
  /// **'Fajl će biti trajno obrisan i ne može se vratiti.'**
  String get deleteForeverBody;

  /// No description provided for @deleteItem.
  ///
  /// In sr, this message translates to:
  /// **'Obriši predmet'**
  String get deleteItem;

  /// No description provided for @deleteItemBody.
  ///
  /// In sr, this message translates to:
  /// **'Predmet se briše. Povezani dokumenti ostaju u arhivi.'**
  String get deleteItemBody;

  /// No description provided for @deleteProfile.
  ///
  /// In sr, this message translates to:
  /// **'Obriši profil'**
  String get deleteProfile;

  /// No description provided for @deleteProfileBody.
  ///
  /// In sr, this message translates to:
  /// **'Profil se briše. Dokumenti ostaju, samo gube vezu sa profilom.'**
  String get deleteProfileBody;

  /// No description provided for @deleteRecord.
  ///
  /// In sr, this message translates to:
  /// **'Obriši evidenciju'**
  String get deleteRecord;

  /// No description provided for @deleteRecordBody.
  ///
  /// In sr, this message translates to:
  /// **'Evidencija će biti obrisana. Priloženi računi ostaju u arhivi.'**
  String get deleteRecordBody;

  /// No description provided for @deleteReminder.
  ///
  /// In sr, this message translates to:
  /// **'Obriši podsetnik'**
  String get deleteReminder;

  /// No description provided for @deleteReminderBody.
  ///
  /// In sr, this message translates to:
  /// **'Podsetnik više neće slati obaveštenja.'**
  String get deleteReminderBody;

  /// No description provided for @deleteVehicle.
  ///
  /// In sr, this message translates to:
  /// **'Obriši vozilo'**
  String get deleteVehicle;

  /// No description provided for @deleteVehicleBody.
  ///
  /// In sr, this message translates to:
  /// **'Brišu se vozilo i njegove evidencije. Računi ostaju u arhivi.'**
  String get deleteVehicleBody;

  /// No description provided for @deleteWord.
  ///
  /// In sr, this message translates to:
  /// **'OBRIŠI'**
  String get deleteWord;

  /// No description provided for @description.
  ///
  /// In sr, this message translates to:
  /// **'Opis'**
  String get description;

  /// No description provided for @details.
  ///
  /// In sr, this message translates to:
  /// **'Detalji'**
  String get details;

  /// No description provided for @disableLock.
  ///
  /// In sr, this message translates to:
  /// **'Isključi zaključavanje'**
  String get disableLock;

  /// No description provided for @discount.
  ///
  /// In sr, this message translates to:
  /// **'Popust'**
  String get discount;

  /// No description provided for @discountHelp.
  ///
  /// In sr, this message translates to:
  /// **'Npr. 10% na kozmetiku, 500 RSD na kupovinu'**
  String get discountHelp;

  /// No description provided for @discountText.
  ///
  /// In sr, this message translates to:
  /// **'Opis popusta'**
  String get discountText;

  /// No description provided for @displayName.
  ///
  /// In sr, this message translates to:
  /// **'Ime ili nadimak'**
  String get displayName;

  /// No description provided for @dissolveBody.
  ///
  /// In sr, this message translates to:
  /// **'Porodični prostor se zatvara. Tvoji dokumenti ostaju, ali postaju privatni.'**
  String get dissolveBody;

  /// No description provided for @dissolveFamily.
  ///
  /// In sr, this message translates to:
  /// **'Zatvori porodicu'**
  String get dissolveFamily;

  /// No description provided for @dissolveHelp.
  ///
  /// In sr, this message translates to:
  /// **'Kao vlasnik, porodicu možeš da zatvoriš kada u njoj nema drugih članova.'**
  String get dissolveHelp;

  /// No description provided for @docNotAvailable.
  ///
  /// In sr, this message translates to:
  /// **'Dokument ne postoji ili nemaš pristup.'**
  String get docNotAvailable;

  /// No description provided for @documentDate.
  ///
  /// In sr, this message translates to:
  /// **'Datum dokumenta'**
  String get documentDate;

  /// No description provided for @documentSaved.
  ///
  /// In sr, this message translates to:
  /// **'Dokument je sačuvan'**
  String get documentSaved;

  /// No description provided for @documentSavedAi.
  ///
  /// In sr, this message translates to:
  /// **'AI obrađuje dokument. Predlozi će se pojaviti za proveru.'**
  String get documentSavedAi;

  /// No description provided for @documents.
  ///
  /// In sr, this message translates to:
  /// **'Dokumenti'**
  String get documents;

  /// No description provided for @done.
  ///
  /// In sr, this message translates to:
  /// **'Gotovo'**
  String get done;

  /// No description provided for @downgradePolicy.
  ///
  /// In sr, this message translates to:
  /// **'Ako pređeš na manji paket, nijedan fajl se ne briše automatski. Ako pređeš limit, dokumenti ostaju dostupni za pregled i izvoz, ali novi ne mogu da se dodaju dok ne oslobodiš prostor ili ne izabereš veći paket.'**
  String get downgradePolicy;

  /// No description provided for @dueDate.
  ///
  /// In sr, this message translates to:
  /// **'Rok'**
  String get dueDate;

  /// No description provided for @duplicateTitle.
  ///
  /// In sr, this message translates to:
  /// **'Moguć duplikat'**
  String get duplicateTitle;

  /// No description provided for @edit.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni'**
  String get edit;

  /// No description provided for @editCard.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni karticu'**
  String get editCard;

  /// No description provided for @editContact.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni kontakt'**
  String get editContact;

  /// No description provided for @editDetails.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni podatke'**
  String get editDetails;

  /// No description provided for @editDocument.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni dokument'**
  String get editDocument;

  /// No description provided for @editItem.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni predmet'**
  String get editItem;

  /// No description provided for @editProfile.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni profil'**
  String get editProfile;

  /// No description provided for @editRecord.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni evidenciju'**
  String get editRecord;

  /// No description provided for @editReminder.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni podsetnik'**
  String get editReminder;

  /// No description provided for @editVehicle.
  ///
  /// In sr, this message translates to:
  /// **'Izmeni vozilo'**
  String get editVehicle;

  /// No description provided for @email.
  ///
  /// In sr, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @emailChannelNote.
  ///
  /// In sr, this message translates to:
  /// **'Obaveštenja e-mailom trenutno nisu uključena.'**
  String get emailChannelNote;

  /// No description provided for @emailOptional.
  ///
  /// In sr, this message translates to:
  /// **'E-mail (opciono)'**
  String get emailOptional;

  /// No description provided for @emailSent.
  ///
  /// In sr, this message translates to:
  /// **'E-mail je poslat'**
  String get emailSent;

  /// No description provided for @emailsOnePerLine.
  ///
  /// In sr, this message translates to:
  /// **'E-mail adrese (jedna po redu)'**
  String get emailsOnePerLine;

  /// No description provided for @enableLock.
  ///
  /// In sr, this message translates to:
  /// **'Uključi zaključavanje'**
  String get enableLock;

  /// No description provided for @errAiFailed.
  ///
  /// In sr, this message translates to:
  /// **'AI trenutno ne može da obradi zahtev. Tvoji podaci su sačuvani — pokušaj ponovo kasnije.'**
  String get errAiFailed;

  /// No description provided for @errAiLimit.
  ///
  /// In sr, this message translates to:
  /// **'Dostignut je limit AI zahteva. Pokušaj kasnije ili proveri potrošnju.'**
  String get errAiLimit;

  /// No description provided for @errAiNotInPlan.
  ///
  /// In sr, this message translates to:
  /// **'AI je dostupan u Individual Pro i Family Pro paketima.'**
  String get errAiNotInPlan;

  /// No description provided for @errAlreadyInFamily.
  ///
  /// In sr, this message translates to:
  /// **'Već si član porodice.'**
  String get errAlreadyInFamily;

  /// No description provided for @errCancelled.
  ///
  /// In sr, this message translates to:
  /// **'Radnja je otkazana.'**
  String get errCancelled;

  /// No description provided for @errDocumentLimit.
  ///
  /// In sr, this message translates to:
  /// **'Dostignut je limit broja dokumenata za tvoj paket.'**
  String get errDocumentLimit;

  /// No description provided for @errEmailInUse.
  ///
  /// In sr, this message translates to:
  /// **'Nalog sa ovim e-mailom već postoji.'**
  String get errEmailInUse;

  /// No description provided for @errEmailNotVerified.
  ///
  /// In sr, this message translates to:
  /// **'E-mail još nije potvrđen. Proveri poštu.'**
  String get errEmailNotVerified;

  /// No description provided for @errFamilyFull.
  ///
  /// In sr, this message translates to:
  /// **'Porodica je popunjena za tvoj paket.'**
  String get errFamilyFull;

  /// No description provided for @errFamilyHasMembers.
  ///
  /// In sr, this message translates to:
  /// **'Prvo ukloni ostale članove porodice.'**
  String get errFamilyHasMembers;

  /// No description provided for @errFamilyPlan.
  ///
  /// In sr, this message translates to:
  /// **'Za ovo je potreban Family paket.'**
  String get errFamilyPlan;

  /// No description provided for @errFileTooLarge.
  ///
  /// In sr, this message translates to:
  /// **'Fajl je prevelik (najviše 25 MB).'**
  String get errFileTooLarge;

  /// No description provided for @errGeneric.
  ///
  /// In sr, this message translates to:
  /// **'Nešto nije u redu. Pokušaj ponovo.'**
  String get errGeneric;

  /// No description provided for @errInvalidEmail.
  ///
  /// In sr, this message translates to:
  /// **'Unesi ispravnu e-mail adresu.'**
  String get errInvalidEmail;

  /// No description provided for @errInvitationEmail.
  ///
  /// In sr, this message translates to:
  /// **'Pozivnica je poslata na drugu e-mail adresu.'**
  String get errInvitationEmail;

  /// No description provided for @errInvitationExpired.
  ///
  /// In sr, this message translates to:
  /// **'Pozivnica je istekla. Zatraži novu.'**
  String get errInvitationExpired;

  /// No description provided for @errInvitationInvalid.
  ///
  /// In sr, this message translates to:
  /// **'Pozivnica nije važeća ili je već iskorišćena.'**
  String get errInvitationInvalid;

  /// No description provided for @errNetwork.
  ///
  /// In sr, this message translates to:
  /// **'Nema internet veze. Promene će se sinhronizovati kad se veza vrati.'**
  String get errNetwork;

  /// No description provided for @errNotFound.
  ///
  /// In sr, this message translates to:
  /// **'Traženi sadržaj nije pronađen.'**
  String get errNotFound;

  /// No description provided for @errPermission.
  ///
  /// In sr, this message translates to:
  /// **'Nemaš dozvolu za ovu radnju.'**
  String get errPermission;

  /// No description provided for @errRecentLogin.
  ///
  /// In sr, this message translates to:
  /// **'Iz bezbednosnih razloga ponovo se prijavi.'**
  String get errRecentLogin;

  /// No description provided for @errSession.
  ///
  /// In sr, this message translates to:
  /// **'Sesija je istekla. Prijavi se ponovo.'**
  String get errSession;

  /// No description provided for @errStorageLimit.
  ///
  /// In sr, this message translates to:
  /// **'Nema dovoljno prostora u tvom paketu.'**
  String get errStorageLimit;

  /// No description provided for @errTitle.
  ///
  /// In sr, this message translates to:
  /// **'Ups'**
  String get errTitle;

  /// No description provided for @errTooMany.
  ///
  /// In sr, this message translates to:
  /// **'Previše pokušaja. Sačekaj malo pa pokušaj ponovo.'**
  String get errTooMany;

  /// No description provided for @errUnavailable.
  ///
  /// In sr, this message translates to:
  /// **'Servis je trenutno nedostupan. Pokušaj za koji minut.'**
  String get errUnavailable;

  /// No description provided for @errUnsupportedFile.
  ///
  /// In sr, this message translates to:
  /// **'Ovaj tip fajla nije podržan. Koristi PDF, JPG, PNG ili HEIC.'**
  String get errUnsupportedFile;

  /// No description provided for @errUserNotFound.
  ///
  /// In sr, this message translates to:
  /// **'Nalog sa ovim e-mailom ne postoji.'**
  String get errUserNotFound;

  /// No description provided for @errWeakPassword.
  ///
  /// In sr, this message translates to:
  /// **'Lozinka je preslaba.'**
  String get errWeakPassword;

  /// No description provided for @errWrongPassword.
  ///
  /// In sr, this message translates to:
  /// **'Pogrešan e-mail ili lozinka.'**
  String get errWrongPassword;

  /// No description provided for @expenses.
  ///
  /// In sr, this message translates to:
  /// **'Troškovi'**
  String get expenses;

  /// No description provided for @expired.
  ///
  /// In sr, this message translates to:
  /// **'Isteklo'**
  String get expired;

  /// No description provided for @expiryDate.
  ///
  /// In sr, this message translates to:
  /// **'Važi do'**
  String get expiryDate;

  /// No description provided for @exportAdvancedIncluded.
  ///
  /// In sr, this message translates to:
  /// **'Tvoj paket uključuje i CSV tabele (dokumenti, predmeti, troškovi vozila).'**
  String get exportAdvancedIncluded;

  /// No description provided for @exportBasicOnly.
  ///
  /// In sr, this message translates to:
  /// **'Izvoz sadrži JSON sa svim podacima i originalne fajlove. CSV tabele su deo Pro paketa.'**
  String get exportBasicOnly;

  /// No description provided for @exportBody.
  ///
  /// In sr, this message translates to:
  /// **'Napravićemo ZIP arhivu sa svim tvojim dokumentima, fotografijama, metapodacima, predmetima, vozilima, podsetnicima i vezama između njih.'**
  String get exportBody;

  /// No description provided for @exportData.
  ///
  /// In sr, this message translates to:
  /// **'Izvezi podatke'**
  String get exportData;

  /// No description provided for @exportFamilyNote.
  ///
  /// In sr, this message translates to:
  /// **'Izvoz sadrži samo zapise čiji si ti vlasnik. Svaki član porodice izvozi svoje podatke.'**
  String get exportFamilyNote;

  /// No description provided for @exportFirst.
  ///
  /// In sr, this message translates to:
  /// **'Prvo izvezi podatke'**
  String get exportFirst;

  /// No description provided for @exportWait.
  ///
  /// In sr, this message translates to:
  /// **'Ovo može da potraje nekoliko minuta ako imaš mnogo fajlova.'**
  String get exportWait;

  /// No description provided for @familyDeadlines.
  ///
  /// In sr, this message translates to:
  /// **'Porodični rokovi'**
  String get familyDeadlines;

  /// No description provided for @familyIntro.
  ///
  /// In sr, this message translates to:
  /// **'Porodični prostor omogućava zajedničke dokumente, profile članova i zajedničke rokove. Svaki dokument i dalje ima svoju privatnost.'**
  String get familyIntro;

  /// No description provided for @familyInvitation.
  ///
  /// In sr, this message translates to:
  /// **'Pozivnica za porodicu'**
  String get familyInvitation;

  /// No description provided for @familyName.
  ///
  /// In sr, this message translates to:
  /// **'Naziv porodice'**
  String get familyName;

  /// No description provided for @familyPermissions.
  ///
  /// In sr, this message translates to:
  /// **'Uloge i dozvole'**
  String get familyPermissions;

  /// No description provided for @familyPlanLapsed.
  ///
  /// In sr, this message translates to:
  /// **'Porodični paket nije aktivan. Postojeći podaci ostaju dostupni, ali nove pozivnice nisu moguće.'**
  String get familyPlanLapsed;

  /// No description provided for @familyPlanOnly.
  ///
  /// In sr, this message translates to:
  /// **'Dostupno u Family paketima'**
  String get familyPlanOnly;

  /// No description provided for @familyProfiles.
  ///
  /// In sr, this message translates to:
  /// **'Profili članova domaćinstva'**
  String get familyProfiles;

  /// No description provided for @familyProfilesHelp.
  ///
  /// In sr, this message translates to:
  /// **'Za članove bez sopstvenog naloga, npr. decu.'**
  String get familyProfilesHelp;

  /// No description provided for @familySettings.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja porodice'**
  String get familySettings;

  /// No description provided for @faq1a.
  ///
  /// In sr, this message translates to:
  /// **'Podrazumevano samo ti. Dokument postaje vidljiv članovima porodice tek kada mu promeniš privatnost u \'Deljeno\' ili \'Porodično\'.'**
  String get faq1a;

  /// No description provided for @faq1q.
  ///
  /// In sr, this message translates to:
  /// **'Ko može da vidi moje dokumente?'**
  String get faq1q;

  /// No description provided for @faq2a.
  ///
  /// In sr, this message translates to:
  /// **'Ništa se ne briše. Sve ostaje dostupno za pregled i izvoz, a nove fajlove možeš da dodaš kada oslobodiš prostor ili izabereš veći paket.'**
  String get faq2a;

  /// No description provided for @faq2q.
  ///
  /// In sr, this message translates to:
  /// **'Šta se dešava ako pređem limit prostora?'**
  String get faq2q;

  /// No description provided for @faq3a.
  ///
  /// In sr, this message translates to:
  /// **'Može. Zato su AI podaci predlozi koje potvrđuješ, a odgovori uvek navode izvore.'**
  String get faq3a;

  /// No description provided for @faq3q.
  ///
  /// In sr, this message translates to:
  /// **'Da li AI može da pogreši?'**
  String get faq3q;

  /// No description provided for @faq4a.
  ///
  /// In sr, this message translates to:
  /// **'Pretplatom upravljaš u App Store ili Google Play podešavanjima. Pristup ostaje do kraja plaćenog perioda.'**
  String get faq4a;

  /// No description provided for @faq4q.
  ///
  /// In sr, this message translates to:
  /// **'Kako otkazujem pretplatu?'**
  String get faq4q;

  /// No description provided for @faq5a.
  ///
  /// In sr, this message translates to:
  /// **'Ne. PIN i biometrija dodatno štite pristup ekranu. Fajlovi su zaštićeni serverskim pravilima pristupa i šifrovani u prenosu i skladištu kod Google Cloud-a.'**
  String get faq5a;

  /// No description provided for @faq5q.
  ///
  /// In sr, this message translates to:
  /// **'Da li je PIN za Vault enkripcija?'**
  String get faq5q;

  /// No description provided for @favorites.
  ///
  /// In sr, this message translates to:
  /// **'Omiljeno'**
  String get favorites;

  /// No description provided for @favoritesOnly.
  ///
  /// In sr, this message translates to:
  /// **'Samo omiljeni'**
  String get favoritesOnly;

  /// No description provided for @featureAds.
  ///
  /// In sr, this message translates to:
  /// **'Sa oglasima'**
  String get featureAds;

  /// No description provided for @featureAi.
  ///
  /// In sr, this message translates to:
  /// **'AI ekstrakcija, kategorizacija i pitanja'**
  String get featureAi;

  /// No description provided for @featureNoAds.
  ///
  /// In sr, this message translates to:
  /// **'Bez oglasa'**
  String get featureNoAds;

  /// No description provided for @featureNoAi.
  ///
  /// In sr, this message translates to:
  /// **'Bez AI funkcija'**
  String get featureNoAi;

  /// No description provided for @featureReminders.
  ///
  /// In sr, this message translates to:
  /// **'Podsetnici i obaveštenja'**
  String get featureReminders;

  /// No description provided for @featureScan.
  ///
  /// In sr, this message translates to:
  /// **'Skeniranje i otpremanje'**
  String get featureScan;

  /// No description provided for @fileInfo.
  ///
  /// In sr, this message translates to:
  /// **'Fajl'**
  String get fileInfo;

  /// No description provided for @fileType.
  ///
  /// In sr, this message translates to:
  /// **'Tip fajla'**
  String get fileType;

  /// No description provided for @filters.
  ///
  /// In sr, this message translates to:
  /// **'Filteri'**
  String get filters;

  /// No description provided for @forgotPassword.
  ///
  /// In sr, this message translates to:
  /// **'Zaboravljena lozinka?'**
  String get forgotPassword;

  /// No description provided for @free.
  ///
  /// In sr, this message translates to:
  /// **'Besplatno'**
  String get free;

  /// No description provided for @front.
  ///
  /// In sr, this message translates to:
  /// **'Prednja strana'**
  String get front;

  /// No description provided for @fuelType.
  ///
  /// In sr, this message translates to:
  /// **'Gorivo / pogon'**
  String get fuelType;

  /// No description provided for @fullName.
  ///
  /// In sr, this message translates to:
  /// **'Ime i prezime'**
  String get fullName;

  /// No description provided for @getStarted.
  ///
  /// In sr, this message translates to:
  /// **'Počni'**
  String get getStarted;

  /// No description provided for @goHome.
  ///
  /// In sr, this message translates to:
  /// **'Na početnu'**
  String get goHome;

  /// No description provided for @gridView.
  ///
  /// In sr, this message translates to:
  /// **'Prikaz u mreži'**
  String get gridView;

  /// No description provided for @haveAccount.
  ///
  /// In sr, this message translates to:
  /// **'Već imam nalog'**
  String get haveAccount;

  /// No description provided for @haveInvitationHint.
  ///
  /// In sr, this message translates to:
  /// **'Imaš pozivnicu? Otvori link iz poruke i prihvati je.'**
  String get haveInvitationHint;

  /// No description provided for @help.
  ///
  /// In sr, this message translates to:
  /// **'Pomoć i podrška'**
  String get help;

  /// No description provided for @hidePassword.
  ///
  /// In sr, this message translates to:
  /// **'Sakrij lozinku'**
  String get hidePassword;

  /// No description provided for @howWeProtect.
  ///
  /// In sr, this message translates to:
  /// **'Kako štitimo tvoje podatke'**
  String get howWeProtect;

  /// No description provided for @iVerified.
  ///
  /// In sr, this message translates to:
  /// **'Potvrdio sam e-mail'**
  String get iVerified;

  /// No description provided for @ignoreSuggestions.
  ///
  /// In sr, this message translates to:
  /// **'Zanemari predloge'**
  String get ignoreSuggestions;

  /// No description provided for @image.
  ///
  /// In sr, this message translates to:
  /// **'Slika'**
  String get image;

  /// No description provided for @importantReminders.
  ///
  /// In sr, this message translates to:
  /// **'Važni podsetnici'**
  String get importantReminders;

  /// No description provided for @injectionWarning.
  ///
  /// In sr, this message translates to:
  /// **'Dokument sadrži tekst koji liči na uputstva za AI. Zanemaren je, ali proveri predloge pažljivo.'**
  String get injectionWarning;

  /// No description provided for @invalidAmount.
  ///
  /// In sr, this message translates to:
  /// **'Neispravan iznos'**
  String get invalidAmount;

  /// No description provided for @invalidValue.
  ///
  /// In sr, this message translates to:
  /// **'Neispravna vrednost'**
  String get invalidValue;

  /// No description provided for @invalidVin.
  ///
  /// In sr, this message translates to:
  /// **'VIN ima 17 znakova (bez I, O, Q)'**
  String get invalidVin;

  /// No description provided for @invitationDeclined.
  ///
  /// In sr, this message translates to:
  /// **'Pozivnica je odbijena'**
  String get invitationDeclined;

  /// No description provided for @invite.
  ///
  /// In sr, this message translates to:
  /// **'Pozovi'**
  String get invite;

  /// No description provided for @inviteEmailHelp.
  ///
  /// In sr, this message translates to:
  /// **'Ako uneseš e-mail, pozivnicu može da prihvati samo osoba sa tom potvrđenom adresom.'**
  String get inviteEmailHelp;

  /// No description provided for @inviteExpiresNote.
  ///
  /// In sr, this message translates to:
  /// **'Link važi 7 dana i može se iskoristiti samo jednom.'**
  String get inviteExpiresNote;

  /// No description provided for @inviteHelp.
  ///
  /// In sr, this message translates to:
  /// **'Napravi bezbedan pozivni link i pošalji ga članu porodice. Član ne dobija automatski pristup tvojim dokumentima.'**
  String get inviteHelp;

  /// No description provided for @inviteLink.
  ///
  /// In sr, this message translates to:
  /// **'Pozivni link'**
  String get inviteLink;

  /// No description provided for @inviteMember.
  ///
  /// In sr, this message translates to:
  /// **'Pozovi člana'**
  String get inviteMember;

  /// No description provided for @inviteReady.
  ///
  /// In sr, this message translates to:
  /// **'Pozivnica je spremna'**
  String get inviteReady;

  /// No description provided for @issuer.
  ///
  /// In sr, this message translates to:
  /// **'Izdavalac / prodavnica'**
  String get issuer;

  /// No description provided for @items.
  ///
  /// In sr, this message translates to:
  /// **'Predmeti'**
  String get items;

  /// No description provided for @jobTitle.
  ///
  /// In sr, this message translates to:
  /// **'Pozicija'**
  String get jobTitle;

  /// No description provided for @joinedFamily.
  ///
  /// In sr, this message translates to:
  /// **'Pridružio si se porodici'**
  String get joinedFamily;

  /// No description provided for @kindAnniversary.
  ///
  /// In sr, this message translates to:
  /// **'Godišnjica'**
  String get kindAnniversary;

  /// No description provided for @kindContract.
  ///
  /// In sr, this message translates to:
  /// **'Ugovor'**
  String get kindContract;

  /// No description provided for @kindCustom.
  ///
  /// In sr, this message translates to:
  /// **'Ostalo'**
  String get kindCustom;

  /// No description provided for @kindDocument.
  ///
  /// In sr, this message translates to:
  /// **'Dokument'**
  String get kindDocument;

  /// No description provided for @kindInsurance.
  ///
  /// In sr, this message translates to:
  /// **'Osiguranje'**
  String get kindInsurance;

  /// No description provided for @kindRegistration.
  ///
  /// In sr, this message translates to:
  /// **'Registracija'**
  String get kindRegistration;

  /// No description provided for @kindService.
  ///
  /// In sr, this message translates to:
  /// **'Servis'**
  String get kindService;

  /// No description provided for @kindSubscription.
  ///
  /// In sr, this message translates to:
  /// **'Pretplata / članarina'**
  String get kindSubscription;

  /// No description provided for @kindWarranty.
  ///
  /// In sr, this message translates to:
  /// **'Garancija'**
  String get kindWarranty;

  /// No description provided for @langEnglish.
  ///
  /// In sr, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langFrench.
  ///
  /// In sr, this message translates to:
  /// **'Francuski'**
  String get langFrench;

  /// No description provided for @langGerman.
  ///
  /// In sr, this message translates to:
  /// **'Nemački'**
  String get langGerman;

  /// No description provided for @langSpanish.
  ///
  /// In sr, this message translates to:
  /// **'Španski'**
  String get langSpanish;

  /// No description provided for @langRussian.
  ///
  /// In sr, this message translates to:
  /// **'Ruski'**
  String get langRussian;

  /// No description provided for @langSerbian.
  ///
  /// In sr, this message translates to:
  /// **'Srpski'**
  String get langSerbian;

  /// No description provided for @language.
  ///
  /// In sr, this message translates to:
  /// **'Jezik'**
  String get language;

  /// No description provided for @largestFiles.
  ///
  /// In sr, this message translates to:
  /// **'Najveći fajlovi'**
  String get largestFiles;

  /// No description provided for @last30Days.
  ///
  /// In sr, this message translates to:
  /// **'Poslednjih 30 dana'**
  String get last30Days;

  /// No description provided for @lastMileage.
  ///
  /// In sr, this message translates to:
  /// **'Poslednja kilometraža'**
  String get lastMileage;

  /// No description provided for @lastYear.
  ///
  /// In sr, this message translates to:
  /// **'Prošle godine'**
  String get lastYear;

  /// No description provided for @later.
  ///
  /// In sr, this message translates to:
  /// **'Kasnije'**
  String get later;

  /// No description provided for @leaveFamily.
  ///
  /// In sr, this message translates to:
  /// **'Napusti porodicu'**
  String get leaveFamily;

  /// No description provided for @leaveFamilyBody.
  ///
  /// In sr, this message translates to:
  /// **'Gubiš pristup porodičnim dokumentima. Tvoji dokumenti ostaju tvoji i postaju privatni.'**
  String get leaveFamilyBody;

  /// No description provided for @leaveFamilyTitle.
  ///
  /// In sr, this message translates to:
  /// **'Napuštaš porodicu?'**
  String get leaveFamilyTitle;

  /// No description provided for @legal.
  ///
  /// In sr, this message translates to:
  /// **'Pravne informacije'**
  String get legal;

  /// No description provided for @legalSummary.
  ///
  /// In sr, this message translates to:
  /// **'MyWorld+ čuva tvoje podatke samo da bi ti pružio uslugu. Ne prodajemo podatke, ne koristimo sadržaj dokumenata za oglase i ne treniramo modele na tvojim dokumentima. U svakom trenutku možeš da izvezeš ili obrišeš podatke.'**
  String get legalSummary;

  /// No description provided for @lifeIntro.
  ///
  /// In sr, this message translates to:
  /// **'Pretplate, polise, rokovi ugovora, članarine, godišnjice i ostali važni datumi.'**
  String get lifeIntro;

  /// No description provided for @limitReachedBody.
  ///
  /// In sr, this message translates to:
  /// **'Ništa nije obrisano. Sve tvoje stavke su dostupne za pregled i izvoz. Da bi dodao nove, oslobodi prostor (isprazni korpu, obriši nepotrebno) ili izaberi veći paket.'**
  String get limitReachedBody;

  /// No description provided for @limitReachedTitle.
  ///
  /// In sr, this message translates to:
  /// **'Dostignut je limit paketa'**
  String get limitReachedTitle;

  /// No description provided for @linkedDocument.
  ///
  /// In sr, this message translates to:
  /// **'Povezani dokument'**
  String get linkedDocument;

  /// No description provided for @linkedDocumentOptional.
  ///
  /// In sr, this message translates to:
  /// **'Povezani dokument (opciono)'**
  String get linkedDocumentOptional;

  /// No description provided for @linkedItem.
  ///
  /// In sr, this message translates to:
  /// **'Povezana stavka'**
  String get linkedItem;

  /// No description provided for @links.
  ///
  /// In sr, this message translates to:
  /// **'Veze'**
  String get links;

  /// No description provided for @linksHelp.
  ///
  /// In sr, this message translates to:
  /// **'Poveži dokument sa predmetima, vozilima ili članovima. Fajl se ne kopira.'**
  String get linksHelp;

  /// No description provided for @listView.
  ///
  /// In sr, this message translates to:
  /// **'Prikaz u listi'**
  String get listView;

  /// No description provided for @loading.
  ///
  /// In sr, this message translates to:
  /// **'Učitavanje…'**
  String get loading;

  /// No description provided for @location.
  ///
  /// In sr, this message translates to:
  /// **'Lokacija u domu'**
  String get location;

  /// No description provided for @locationHelp.
  ///
  /// In sr, this message translates to:
  /// **'Npr. kuhinja, podrum'**
  String get locationHelp;

  /// No description provided for @lockEnabled.
  ///
  /// In sr, this message translates to:
  /// **'Zaključavanje je uključeno'**
  String get lockEnabled;

  /// No description provided for @lockNow.
  ///
  /// In sr, this message translates to:
  /// **'Zaključaj sada'**
  String get lockNow;

  /// No description provided for @lockedFeature.
  ///
  /// In sr, this message translates to:
  /// **'Zaključano'**
  String get lockedFeature;

  /// No description provided for @maintenanceHistory.
  ///
  /// In sr, this message translates to:
  /// **'Popravke i održavanje'**
  String get maintenanceHistory;

  /// No description provided for @make.
  ///
  /// In sr, this message translates to:
  /// **'Marka'**
  String get make;

  /// No description provided for @manage.
  ///
  /// In sr, this message translates to:
  /// **'Upravljaj'**
  String get manage;

  /// No description provided for @manageInStore.
  ///
  /// In sr, this message translates to:
  /// **'Upravljaj u prodavnici'**
  String get manageInStore;

  /// No description provided for @manageSubscription.
  ///
  /// In sr, this message translates to:
  /// **'Pretplata'**
  String get manageSubscription;

  /// No description provided for @markDone.
  ///
  /// In sr, this message translates to:
  /// **'Označi kao završeno'**
  String get markDone;

  /// No description provided for @markDoneNext.
  ///
  /// In sr, this message translates to:
  /// **'Završeno — pomeri na sledeći rok'**
  String get markDoneNext;

  /// No description provided for @markUsed.
  ///
  /// In sr, this message translates to:
  /// **'Označi kao iskorišćen'**
  String get markUsed;

  /// No description provided for @member.
  ///
  /// In sr, this message translates to:
  /// **'Član'**
  String get member;

  /// No description provided for @memberVisibleNote.
  ///
  /// In sr, this message translates to:
  /// **'Vidiš samo ono što je ovaj član podelio sa tobom ili sa porodicom.'**
  String get memberVisibleNote;

  /// No description provided for @members.
  ///
  /// In sr, this message translates to:
  /// **'Članovi'**
  String get members;

  /// No description provided for @metAt.
  ///
  /// In sr, this message translates to:
  /// **'Datum upoznavanja'**
  String get metAt;

  /// No description provided for @metWhere.
  ///
  /// In sr, this message translates to:
  /// **'Gde ste se upoznali'**
  String get metWhere;

  /// No description provided for @mileage.
  ///
  /// In sr, this message translates to:
  /// **'Kilometraža'**
  String get mileage;

  /// No description provided for @mileageHistory.
  ///
  /// In sr, this message translates to:
  /// **'Istorija kilometraže'**
  String get mileageHistory;

  /// No description provided for @mileageKm.
  ///
  /// In sr, this message translates to:
  /// **'Kilometraža (km)'**
  String get mileageKm;

  /// No description provided for @minor.
  ///
  /// In sr, this message translates to:
  /// **'Maloletno'**
  String get minor;

  /// No description provided for @minorHelp.
  ///
  /// In sr, this message translates to:
  /// **'Profil deteta nije nalog i ne može da se prijavi.'**
  String get minorHelp;

  /// No description provided for @model.
  ///
  /// In sr, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @more.
  ///
  /// In sr, this message translates to:
  /// **'Još'**
  String get more;

  /// No description provided for @moveToTrash.
  ///
  /// In sr, this message translates to:
  /// **'Premesti u korpu'**
  String get moveToTrash;

  /// No description provided for @moveToTrashBody.
  ///
  /// In sr, this message translates to:
  /// **'Dokument možeš da vratiš iz korpe u narednih 30 dana.'**
  String get moveToTrashBody;

  /// No description provided for @movedToTrash.
  ///
  /// In sr, this message translates to:
  /// **'Premešteno u korpu'**
  String get movedToTrash;

  /// No description provided for @multiCurrencyNote.
  ///
  /// In sr, this message translates to:
  /// **'Iznosi u različitim valutama se ne sabiraju zajedno.'**
  String get multiCurrencyNote;

  /// No description provided for @myAreas.
  ///
  /// In sr, this message translates to:
  /// **'Moje oblasti'**
  String get myAreas;

  /// No description provided for @name.
  ///
  /// In sr, this message translates to:
  /// **'Naziv'**
  String get name;

  /// No description provided for @nameOrCompanyRequired.
  ///
  /// In sr, this message translates to:
  /// **'Unesi ime ili firmu'**
  String get nameOrCompanyRequired;

  /// No description provided for @navAdd.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj'**
  String get navAdd;

  /// No description provided for @navHome.
  ///
  /// In sr, this message translates to:
  /// **'Početna'**
  String get navHome;

  /// No description provided for @navVault.
  ///
  /// In sr, this message translates to:
  /// **'Vault'**
  String get navVault;

  /// No description provided for @navWorld.
  ///
  /// In sr, this message translates to:
  /// **'My World'**
  String get navWorld;

  /// No description provided for @next.
  ///
  /// In sr, this message translates to:
  /// **'Dalje'**
  String get next;

  /// No description provided for @next6Months.
  ///
  /// In sr, this message translates to:
  /// **'Narednih 6 meseci'**
  String get next6Months;

  /// No description provided for @nextDueDate.
  ///
  /// In sr, this message translates to:
  /// **'Sledeći rok'**
  String get nextDueDate;

  /// No description provided for @nextDueHelp.
  ///
  /// In sr, this message translates to:
  /// **'Unesi samo ako znaš rok (npr. sa računa ili po preporuci servisa).'**
  String get nextDueHelp;

  /// No description provided for @nextDueMileage.
  ///
  /// In sr, this message translates to:
  /// **'Sledeći servis na km'**
  String get nextDueMileage;

  /// No description provided for @nextDueSection.
  ///
  /// In sr, this message translates to:
  /// **'Sledeći rok'**
  String get nextDueSection;

  /// No description provided for @noAccount.
  ///
  /// In sr, this message translates to:
  /// **'Nemam nalog — registruj se'**
  String get noAccount;

  /// No description provided for @noAssignedItems.
  ///
  /// In sr, this message translates to:
  /// **'Nema dodeljenih stvari.'**
  String get noAssignedItems;

  /// No description provided for @noCards.
  ///
  /// In sr, this message translates to:
  /// **'Još nema kartica'**
  String get noCards;

  /// No description provided for @noCardsHint.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj kartice lojalnosti, popuste i kupone da ih uvek imaš uz sebe.'**
  String get noCardsHint;

  /// No description provided for @noContacts.
  ///
  /// In sr, this message translates to:
  /// **'Još nema vizit karata'**
  String get noContacts;

  /// No description provided for @noContactsHint.
  ///
  /// In sr, this message translates to:
  /// **'Fotografiši vizit kartu i sačuvaj kontakt za par sekundi.'**
  String get noContactsHint;

  /// No description provided for @noDeadlines.
  ///
  /// In sr, this message translates to:
  /// **'Nema rokova u narednih 6 meseci'**
  String get noDeadlines;

  /// No description provided for @noDocuments.
  ///
  /// In sr, this message translates to:
  /// **'Još nema dokumenata'**
  String get noDocuments;

  /// No description provided for @noDocumentsCta.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj prvi dokument — skeniraj račun ili garanciju.'**
  String get noDocumentsCta;

  /// No description provided for @noDocumentsHint.
  ///
  /// In sr, this message translates to:
  /// **'Skeniraj ili otpremi dokument da ga sačuvaš ovde.'**
  String get noDocumentsHint;

  /// No description provided for @noExpenses.
  ///
  /// In sr, this message translates to:
  /// **'Još nema troškova'**
  String get noExpenses;

  /// No description provided for @noFamilyDeadlines.
  ///
  /// In sr, this message translates to:
  /// **'Nema zajedničkih rokova.'**
  String get noFamilyDeadlines;

  /// No description provided for @noInventedIntervals.
  ///
  /// In sr, this message translates to:
  /// **'MyWorld+ ne pretpostavlja servisne intervale — prikazuje samo rokove koje si uneo.'**
  String get noInventedIntervals;

  /// No description provided for @noItems.
  ///
  /// In sr, this message translates to:
  /// **'Još nema predmeta'**
  String get noItems;

  /// No description provided for @noItemsHint.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj uređaj ili predmet i poveži ga sa računom i garancijom.'**
  String get noItemsHint;

  /// No description provided for @noLinkTargets.
  ///
  /// In sr, this message translates to:
  /// **'Nema predmeta, vozila ni profila za povezivanje.'**
  String get noLinkTargets;

  /// No description provided for @noLinkedDocs.
  ///
  /// In sr, this message translates to:
  /// **'Nema povezanih dokumenata.'**
  String get noLinkedDocs;

  /// No description provided for @noLinks.
  ///
  /// In sr, this message translates to:
  /// **'Dokument nije povezan ni sa čim.'**
  String get noLinks;

  /// No description provided for @noMaintenance.
  ///
  /// In sr, this message translates to:
  /// **'Nema zapisa o održavanju'**
  String get noMaintenance;

  /// No description provided for @noMaintenanceHint.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj račun za popravku ili servis i poveži ga sa predmetom.'**
  String get noMaintenanceHint;

  /// No description provided for @noMileage.
  ///
  /// In sr, this message translates to:
  /// **'Nema unete kilometraže'**
  String get noMileage;

  /// No description provided for @noNotifications.
  ///
  /// In sr, this message translates to:
  /// **'Nema novih obaveštenja'**
  String get noNotifications;

  /// No description provided for @noRecordYet.
  ///
  /// In sr, this message translates to:
  /// **'Još nema evidencije.'**
  String get noRecordYet;

  /// No description provided for @noRecords.
  ///
  /// In sr, this message translates to:
  /// **'Još nema evidencija'**
  String get noRecords;

  /// No description provided for @noReminders.
  ///
  /// In sr, this message translates to:
  /// **'Nema podsetnika'**
  String get noReminders;

  /// No description provided for @noRemindersCta.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj prvi podsetnik — registracija, garancija, ugovor…'**
  String get noRemindersCta;

  /// No description provided for @noRemindersHint.
  ///
  /// In sr, this message translates to:
  /// **'Podsetnici te obaveštavaju o važnim rokovima na vreme.'**
  String get noRemindersHint;

  /// No description provided for @noResults.
  ///
  /// In sr, this message translates to:
  /// **'Nema rezultata'**
  String get noResults;

  /// No description provided for @noResultsFiltered.
  ///
  /// In sr, this message translates to:
  /// **'Nijedan dokument ne odgovara filterima.'**
  String get noResultsFiltered;

  /// No description provided for @noResultsHint.
  ///
  /// In sr, this message translates to:
  /// **'Probaj drugi pojam, ukloni filtere ili dodaj dokument.'**
  String get noResultsHint;

  /// No description provided for @noSharedDocs.
  ///
  /// In sr, this message translates to:
  /// **'Nema deljenih dokumenata.'**
  String get noSharedDocs;

  /// No description provided for @noSharedDocsHint.
  ///
  /// In sr, this message translates to:
  /// **'Promeni privatnost dokumenta u \'Porodično\' ili \'Deljeno\' da bi ga drugi videli.'**
  String get noSharedDocsHint;

  /// No description provided for @noSuggestions.
  ///
  /// In sr, this message translates to:
  /// **'Nema AI predloga'**
  String get noSuggestions;

  /// No description provided for @noSuggestionsBody.
  ///
  /// In sr, this message translates to:
  /// **'Za ovaj dokument još nema predloga.'**
  String get noSuggestionsBody;

  /// No description provided for @noVehicles.
  ///
  /// In sr, this message translates to:
  /// **'Još nema vozila'**
  String get noVehicles;

  /// No description provided for @noVehiclesHint.
  ///
  /// In sr, this message translates to:
  /// **'Dodaj vozilo i vodi servisnu istoriju, troškove i rokove.'**
  String get noVehiclesHint;

  /// No description provided for @noWarrantyDate.
  ///
  /// In sr, this message translates to:
  /// **'Datum isteka garancije nije unet'**
  String get noWarrantyDate;

  /// No description provided for @noWarrantyFound.
  ///
  /// In sr, this message translates to:
  /// **'Na dokumentu nije pronađen podatak o garanciji. Ne pretpostavljamo trajanje garancije.'**
  String get noWarrantyFound;

  /// No description provided for @none.
  ///
  /// In sr, this message translates to:
  /// **'Bez'**
  String get none;

  /// No description provided for @notAvailable.
  ///
  /// In sr, this message translates to:
  /// **'Nije dostupno ili nemaš pristup.'**
  String get notAvailable;

  /// No description provided for @notSet.
  ///
  /// In sr, this message translates to:
  /// **'nije postavljeno'**
  String get notSet;

  /// No description provided for @notes.
  ///
  /// In sr, this message translates to:
  /// **'Napomene'**
  String get notes;

  /// No description provided for @notificationChannels.
  ///
  /// In sr, this message translates to:
  /// **'Kanali obaveštenja'**
  String get notificationChannels;

  /// No description provided for @notificationGenericBody.
  ///
  /// In sr, this message translates to:
  /// **'Imaš podsetnik koji zahteva pažnju.'**
  String get notificationGenericBody;

  /// No description provided for @notificationTitle.
  ///
  /// In sr, this message translates to:
  /// **'MyWorld+ podsetnik'**
  String get notificationTitle;

  /// No description provided for @notifications.
  ///
  /// In sr, this message translates to:
  /// **'Obaveštenja'**
  String get notifications;

  /// No description provided for @notificationsAllowed.
  ///
  /// In sr, this message translates to:
  /// **'Obaveštenja su dozvoljena'**
  String get notificationsAllowed;

  /// No description provided for @notificationsBlocked.
  ///
  /// In sr, this message translates to:
  /// **'Obaveštenja nisu dozvoljena'**
  String get notificationsBlocked;

  /// No description provided for @notifyBefore.
  ///
  /// In sr, this message translates to:
  /// **'Obavesti me'**
  String get notifyBefore;

  /// No description provided for @offlineBanner.
  ///
  /// In sr, this message translates to:
  /// **'Nema veze — izmene će se sinhronizovati kasnije'**
  String get offlineBanner;

  /// No description provided for @onboarding1Body.
  ///
  /// In sr, this message translates to:
  /// **'Dokumenti, računi, garancije, stvari, vozila i porodica — organizovano.'**
  String get onboarding1Body;

  /// No description provided for @onboarding1Title.
  ///
  /// In sr, this message translates to:
  /// **'Sve tvoje važne stvari, na jednom mestu.'**
  String get onboarding1Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In sr, this message translates to:
  /// **'Fotografiši kamerom, a mi pravimo uredan PDF.'**
  String get onboarding2Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj dokumente, račune i garancije za nekoliko sekundi.'**
  String get onboarding2Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In sr, this message translates to:
  /// **'Brza pretraga i podsetnici za važne rokove.'**
  String get onboarding3Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In sr, this message translates to:
  /// **'Pronađi ono što ti treba, baš kada ti zatreba.'**
  String get onboarding3Title;

  /// No description provided for @open.
  ///
  /// In sr, this message translates to:
  /// **'Otvori'**
  String get open;

  /// No description provided for @openDocument.
  ///
  /// In sr, this message translates to:
  /// **'Otvori dokument'**
  String get openDocument;

  /// No description provided for @openPreview.
  ///
  /// In sr, this message translates to:
  /// **'Otvori pregled'**
  String get openPreview;

  /// No description provided for @openSourceLicenses.
  ///
  /// In sr, this message translates to:
  /// **'Licence otvorenog koda'**
  String get openSourceLicenses;

  /// No description provided for @openingCamera.
  ///
  /// In sr, this message translates to:
  /// **'Otvaram kameru…'**
  String get openingCamera;

  /// No description provided for @optionalDetails.
  ///
  /// In sr, this message translates to:
  /// **'Dodatni podaci (opciono)'**
  String get optionalDetails;

  /// No description provided for @orContinueWith.
  ///
  /// In sr, this message translates to:
  /// **'ili'**
  String get orContinueWith;

  /// No description provided for @overdue.
  ///
  /// In sr, this message translates to:
  /// **'Isteklo'**
  String get overdue;

  /// No description provided for @ownerCannotLeave.
  ///
  /// In sr, this message translates to:
  /// **'Vlasnik ne može da napusti porodicu dok ima drugih članova. Prvo ih ukloni.'**
  String get ownerCannotLeave;

  /// No description provided for @pageNotFound.
  ///
  /// In sr, this message translates to:
  /// **'Ova stranica ne postoji.'**
  String get pageNotFound;

  /// No description provided for @password.
  ///
  /// In sr, this message translates to:
  /// **'Lozinka'**
  String get password;

  /// No description provided for @passwordHelp.
  ///
  /// In sr, this message translates to:
  /// **'Najmanje 8 znakova, slova i brojevi'**
  String get passwordHelp;

  /// No description provided for @passwordTooShort.
  ///
  /// In sr, this message translates to:
  /// **'Lozinka mora imati najmanje 8 znakova'**
  String get passwordTooShort;

  /// No description provided for @passwordWeak.
  ///
  /// In sr, this message translates to:
  /// **'Lozinka mora sadržati slova i brojeve'**
  String get passwordWeak;

  /// No description provided for @pendingInvites.
  ///
  /// In sr, this message translates to:
  /// **'Aktivne pozivnice'**
  String get pendingInvites;

  /// No description provided for @period.
  ///
  /// In sr, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In sr, this message translates to:
  /// **'Nema pristupa'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionsExplainer.
  ///
  /// In sr, this message translates to:
  /// **'Uloge određuju ko upravlja porodicom (pozivanje, profili). Uloga ne daje pristup tuđim dokumentima — to određuje privatnost svakog dokumenta.'**
  String get permissionsExplainer;

  /// No description provided for @phonesOnePerLine.
  ///
  /// In sr, this message translates to:
  /// **'Telefoni (jedan po redu)'**
  String get phonesOnePerLine;

  /// No description provided for @photos.
  ///
  /// In sr, this message translates to:
  /// **'Fotografije'**
  String get photos;

  /// No description provided for @pin.
  ///
  /// In sr, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @pinHelp.
  ///
  /// In sr, this message translates to:
  /// **'4 do 8 cifara'**
  String get pinHelp;

  /// No description provided for @pinMismatch.
  ///
  /// In sr, this message translates to:
  /// **'PIN-ovi se ne poklapaju'**
  String get pinMismatch;

  /// No description provided for @pinNew.
  ///
  /// In sr, this message translates to:
  /// **'Novi PIN'**
  String get pinNew;

  /// No description provided for @pinRepeat.
  ///
  /// In sr, this message translates to:
  /// **'Ponovi PIN'**
  String get pinRepeat;

  /// No description provided for @planFamilyBase.
  ///
  /// In sr, this message translates to:
  /// **'Family Base'**
  String get planFamilyBase;

  /// No description provided for @planFamilyPro.
  ///
  /// In sr, this message translates to:
  /// **'Family Pro'**
  String get planFamilyPro;

  /// No description provided for @planFromFamily.
  ///
  /// In sr, this message translates to:
  /// **'Paket dolazi iz porodice'**
  String get planFromFamily;

  /// No description provided for @planIndividualBase.
  ///
  /// In sr, this message translates to:
  /// **'Individual Base'**
  String get planIndividualBase;

  /// No description provided for @planIndividualPro.
  ///
  /// In sr, this message translates to:
  /// **'Individual Pro'**
  String get planIndividualPro;

  /// No description provided for @plansSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Izaberi paket koji ti odgovara. Možeš da ga promeniš ili otkažeš bilo kada.'**
  String get plansSubtitle;

  /// No description provided for @plansTitle.
  ///
  /// In sr, this message translates to:
  /// **'Paketi'**
  String get plansTitle;

  /// No description provided for @price.
  ///
  /// In sr, this message translates to:
  /// **'Cena'**
  String get price;

  /// No description provided for @privacy.
  ///
  /// In sr, this message translates to:
  /// **'Ko vidi'**
  String get privacy;

  /// No description provided for @privacyBullets.
  ///
  /// In sr, this message translates to:
  /// **'• Svi fajlovi su privatni i dostupni samo kroz proveru pristupa na serveru.\n• Porodični članovi vide samo ono što izričito podeliš.\n• Sadržaj dokumenata se ne šalje u analitiku, logove ni reklamne mreže.\n• Brisanje naloga zaista briše podatke na serveru.'**
  String get privacyBullets;

  /// No description provided for @privacyFamily.
  ///
  /// In sr, this message translates to:
  /// **'Porodično'**
  String get privacyFamily;

  /// No description provided for @privacyFamilyHelp.
  ///
  /// In sr, this message translates to:
  /// **'Vide svi aktivni članovi tvoje porodice.'**
  String get privacyFamilyHelp;

  /// No description provided for @privacyNoFamilyHelp.
  ///
  /// In sr, this message translates to:
  /// **'Deljenje je dostupno kada si član porodice.'**
  String get privacyNoFamilyHelp;

  /// No description provided for @privacyPolicy.
  ///
  /// In sr, this message translates to:
  /// **'Politika privatnosti'**
  String get privacyPolicy;

  /// No description provided for @privacyPrivate.
  ///
  /// In sr, this message translates to:
  /// **'Privatno'**
  String get privacyPrivate;

  /// No description provided for @privacyPrivateHelp.
  ///
  /// In sr, this message translates to:
  /// **'Vidiš samo ti.'**
  String get privacyPrivateHelp;

  /// No description provided for @privacySettings.
  ///
  /// In sr, this message translates to:
  /// **'Privatnost'**
  String get privacySettings;

  /// No description provided for @privacyShared.
  ///
  /// In sr, this message translates to:
  /// **'Izabrani'**
  String get privacyShared;

  /// No description provided for @privacySharedHelp.
  ///
  /// In sr, this message translates to:
  /// **'Vide samo članovi koje izabereš.'**
  String get privacySharedHelp;

  /// No description provided for @processingStatus.
  ///
  /// In sr, this message translates to:
  /// **'Status obrade'**
  String get processingStatus;

  /// No description provided for @profile.
  ///
  /// In sr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @profileSetupBody.
  ///
  /// In sr, this message translates to:
  /// **'Još samo par podataka. Ništa osetljivo ne tražimo.'**
  String get profileSetupBody;

  /// No description provided for @profileSetupTitle.
  ///
  /// In sr, this message translates to:
  /// **'Tvoj profil'**
  String get profileSetupTitle;

  /// No description provided for @purchaseDate.
  ///
  /// In sr, this message translates to:
  /// **'Datum kupovine'**
  String get purchaseDate;

  /// No description provided for @purchaseDetails.
  ///
  /// In sr, this message translates to:
  /// **'Kupovina'**
  String get purchaseDetails;

  /// No description provided for @purchaseProcessed.
  ///
  /// In sr, this message translates to:
  /// **'Kupovina je obrađena. Paket se ažurira…'**
  String get purchaseProcessed;

  /// No description provided for @reactivate.
  ///
  /// In sr, this message translates to:
  /// **'Ponovo aktiviraj'**
  String get reactivate;

  /// No description provided for @readCardWithAi.
  ///
  /// In sr, this message translates to:
  /// **'Pročitaj karticu pomoću AI'**
  String get readCardWithAi;

  /// No description provided for @recFuel.
  ///
  /// In sr, this message translates to:
  /// **'Gorivo'**
  String get recFuel;

  /// No description provided for @recInspection.
  ///
  /// In sr, this message translates to:
  /// **'Tehnički pregled'**
  String get recInspection;

  /// No description provided for @recInsurance.
  ///
  /// In sr, this message translates to:
  /// **'Osiguranje'**
  String get recInsurance;

  /// No description provided for @recOil.
  ///
  /// In sr, this message translates to:
  /// **'Zamena ulja'**
  String get recOil;

  /// No description provided for @recOther.
  ///
  /// In sr, this message translates to:
  /// **'Ostalo'**
  String get recOther;

  /// No description provided for @recParking.
  ///
  /// In sr, this message translates to:
  /// **'Parking'**
  String get recParking;

  /// No description provided for @recParts.
  ///
  /// In sr, this message translates to:
  /// **'Delovi'**
  String get recParts;

  /// No description provided for @recRegistration.
  ///
  /// In sr, this message translates to:
  /// **'Registracija'**
  String get recRegistration;

  /// No description provided for @recRepair.
  ///
  /// In sr, this message translates to:
  /// **'Popravka'**
  String get recRepair;

  /// No description provided for @recService.
  ///
  /// In sr, this message translates to:
  /// **'Redovan servis'**
  String get recService;

  /// No description provided for @recTires.
  ///
  /// In sr, this message translates to:
  /// **'Gume'**
  String get recTires;

  /// No description provided for @recTolls.
  ///
  /// In sr, this message translates to:
  /// **'Putarine'**
  String get recTolls;

  /// No description provided for @receipts.
  ///
  /// In sr, this message translates to:
  /// **'Računi'**
  String get receipts;

  /// No description provided for @receiptsAndWarranties.
  ///
  /// In sr, this message translates to:
  /// **'Računi i garancije'**
  String get receiptsAndWarranties;

  /// No description provided for @recentRecords.
  ///
  /// In sr, this message translates to:
  /// **'Poslednje evidencije'**
  String get recentRecords;

  /// No description provided for @recentlyAdded.
  ///
  /// In sr, this message translates to:
  /// **'Nedavno dodato'**
  String get recentlyAdded;

  /// No description provided for @recordType.
  ///
  /// In sr, this message translates to:
  /// **'Vrsta evidencije'**
  String get recordType;

  /// No description provided for @refreshStatus.
  ///
  /// In sr, this message translates to:
  /// **'Osveži status pretplate'**
  String get refreshStatus;

  /// No description provided for @registrationInsurance.
  ///
  /// In sr, this message translates to:
  /// **'Registracija i osiguranje'**
  String get registrationInsurance;

  /// No description provided for @registrationNumber.
  ///
  /// In sr, this message translates to:
  /// **'Registarska oznaka'**
  String get registrationNumber;

  /// No description provided for @relationshipOptional.
  ///
  /// In sr, this message translates to:
  /// **'Odnos (opciono)'**
  String get relationshipOptional;

  /// No description provided for @remindBeforeExpiry.
  ///
  /// In sr, this message translates to:
  /// **'Podseti me pre isteka'**
  String get remindBeforeExpiry;

  /// No description provided for @reminder.
  ///
  /// In sr, this message translates to:
  /// **'Podsetnik'**
  String get reminder;

  /// No description provided for @reminderSaved.
  ///
  /// In sr, this message translates to:
  /// **'Podsetnik je sačuvan'**
  String get reminderSaved;

  /// No description provided for @reminderSettings.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja podsetnika'**
  String get reminderSettings;

  /// No description provided for @reminderType.
  ///
  /// In sr, this message translates to:
  /// **'Vrsta'**
  String get reminderType;

  /// No description provided for @reminders.
  ///
  /// In sr, this message translates to:
  /// **'Podsetnici'**
  String get reminders;

  /// No description provided for @removeAds.
  ///
  /// In sr, this message translates to:
  /// **'Ukloni oglase'**
  String get removeAds;

  /// No description provided for @removeFavorite.
  ///
  /// In sr, this message translates to:
  /// **'Ukloni iz omiljenih'**
  String get removeFavorite;

  /// No description provided for @removeMember.
  ///
  /// In sr, this message translates to:
  /// **'Ukloni člana'**
  String get removeMember;

  /// No description provided for @removeMemberBody.
  ///
  /// In sr, this message translates to:
  /// **'Član odmah gubi pristup porodičnim i deljenim dokumentima. Njegovi dokumenti ostaju njegovi.'**
  String get removeMemberBody;

  /// No description provided for @renewsOn.
  ///
  /// In sr, this message translates to:
  /// **'Obnavlja se'**
  String get renewsOn;

  /// No description provided for @repeat.
  ///
  /// In sr, this message translates to:
  /// **'Ponavljanje'**
  String get repeat;

  /// No description provided for @repeatDaily.
  ///
  /// In sr, this message translates to:
  /// **'Svakog dana'**
  String get repeatDaily;

  /// No description provided for @repeatMonthly.
  ///
  /// In sr, this message translates to:
  /// **'Svakog meseca'**
  String get repeatMonthly;

  /// No description provided for @repeatNone.
  ///
  /// In sr, this message translates to:
  /// **'Ne ponavlja se'**
  String get repeatNone;

  /// No description provided for @repeatWeekly.
  ///
  /// In sr, this message translates to:
  /// **'Svake nedelje'**
  String get repeatWeekly;

  /// No description provided for @repeatYearly.
  ///
  /// In sr, this message translates to:
  /// **'Svake godine'**
  String get repeatYearly;

  /// No description provided for @required.
  ///
  /// In sr, this message translates to:
  /// **'Obavezno polje'**
  String get required;

  /// No description provided for @resendEmail.
  ///
  /// In sr, this message translates to:
  /// **'Pošalji ponovo'**
  String get resendEmail;

  /// No description provided for @resetPassword.
  ///
  /// In sr, this message translates to:
  /// **'Resetovanje lozinke'**
  String get resetPassword;

  /// No description provided for @resetPasswordBody.
  ///
  /// In sr, this message translates to:
  /// **'Unesi e-mail i poslaćemo ti link za novu lozinku.'**
  String get resetPasswordBody;

  /// No description provided for @resetSentBody.
  ///
  /// In sr, this message translates to:
  /// **'Ako nalog postoji, link je poslat. Proveri i spam folder.'**
  String get resetSentBody;

  /// No description provided for @resetSentTitle.
  ///
  /// In sr, this message translates to:
  /// **'Proveri e-mail'**
  String get resetSentTitle;

  /// No description provided for @restore.
  ///
  /// In sr, this message translates to:
  /// **'Vrati'**
  String get restore;

  /// No description provided for @restoreDone.
  ///
  /// In sr, this message translates to:
  /// **'Kupovine su proverene'**
  String get restoreDone;

  /// No description provided for @restorePurchases.
  ///
  /// In sr, this message translates to:
  /// **'Vrati kupovine'**
  String get restorePurchases;

  /// No description provided for @restored.
  ///
  /// In sr, this message translates to:
  /// **'Vraćeno'**
  String get restored;

  /// No description provided for @retake.
  ///
  /// In sr, this message translates to:
  /// **'Fotografiši ponovo'**
  String get retake;

  /// No description provided for @retry.
  ///
  /// In sr, this message translates to:
  /// **'Pokušaj ponovo'**
  String get retry;

  /// No description provided for @reviewSuggestions.
  ///
  /// In sr, this message translates to:
  /// **'Proveri AI predloge'**
  String get reviewSuggestions;

  /// No description provided for @revoke.
  ///
  /// In sr, this message translates to:
  /// **'Opozovi'**
  String get revoke;

  /// No description provided for @roleAdmin.
  ///
  /// In sr, this message translates to:
  /// **'Administrator'**
  String get roleAdmin;

  /// No description provided for @roleMember.
  ///
  /// In sr, this message translates to:
  /// **'Član'**
  String get roleMember;

  /// No description provided for @roleOwner.
  ///
  /// In sr, this message translates to:
  /// **'Vlasnik'**
  String get roleOwner;

  /// No description provided for @rotate.
  ///
  /// In sr, this message translates to:
  /// **'Rotiraj'**
  String get rotate;

  /// No description provided for @save.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj'**
  String get save;

  /// No description provided for @saveAnyway.
  ///
  /// In sr, this message translates to:
  /// **'Ipak sačuvaj'**
  String get saveAnyway;

  /// No description provided for @saveDocumentTitle.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj dokument'**
  String get saveDocumentTitle;

  /// No description provided for @saveToVault.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvaj u Vault'**
  String get saveToVault;

  /// No description provided for @saveToVaultHelp.
  ///
  /// In sr, this message translates to:
  /// **'Za posebno važne lične dokumente. Ne koristi se u AI pitanjima.'**
  String get saveToVaultHelp;

  /// No description provided for @saved.
  ///
  /// In sr, this message translates to:
  /// **'Sačuvano'**
  String get saved;

  /// No description provided for @scanBarcode.
  ///
  /// In sr, this message translates to:
  /// **'Skeniraj barkod / QR'**
  String get scanBarcode;

  /// No description provided for @scanBarcodeHelp.
  ///
  /// In sr, this message translates to:
  /// **'Usmeri kameru ka barkodu ili QR kodu'**
  String get scanBarcodeHelp;

  /// No description provided for @scanReviewHelp.
  ///
  /// In sr, this message translates to:
  /// **'Proveri strane. Možeš da ih rotiraš, ponoviš, obrišeš ili prevučeš da promeniš redosled.'**
  String get scanReviewHelp;

  /// No description provided for @search.
  ///
  /// In sr, this message translates to:
  /// **'Pretraga'**
  String get search;

  /// No description provided for @searchCards.
  ///
  /// In sr, this message translates to:
  /// **'Pretraži kartice'**
  String get searchCards;

  /// No description provided for @searchContacts.
  ///
  /// In sr, this message translates to:
  /// **'Pretraži kontakte'**
  String get searchContacts;

  /// No description provided for @searchHint.
  ///
  /// In sr, this message translates to:
  /// **'Šta tražiš danas?'**
  String get searchHint;

  /// No description provided for @searchItems.
  ///
  /// In sr, this message translates to:
  /// **'Pretraži predmete'**
  String get searchItems;

  /// No description provided for @searchStartBody.
  ///
  /// In sr, this message translates to:
  /// **'Pretraži po nazivu, kategoriji, prodavcu, osobi, uređaju, iznosu ili tagu.'**
  String get searchStartBody;

  /// No description provided for @searchStartTitle.
  ///
  /// In sr, this message translates to:
  /// **'Počni da kucaš'**
  String get searchStartTitle;

  /// No description provided for @searchVault.
  ///
  /// In sr, this message translates to:
  /// **'Pretraži Vault'**
  String get searchVault;

  /// No description provided for @seeAll.
  ///
  /// In sr, this message translates to:
  /// **'Sve'**
  String get seeAll;

  /// No description provided for @seePlans.
  ///
  /// In sr, this message translates to:
  /// **'Pogledaj pakete'**
  String get seePlans;

  /// No description provided for @send.
  ///
  /// In sr, this message translates to:
  /// **'Pošalji'**
  String get send;

  /// No description provided for @sendLink.
  ///
  /// In sr, this message translates to:
  /// **'Pošalji link'**
  String get sendLink;

  /// No description provided for @serialNumber.
  ///
  /// In sr, this message translates to:
  /// **'Serijski broj'**
  String get serialNumber;

  /// No description provided for @serviceHistory.
  ///
  /// In sr, this message translates to:
  /// **'Servisna istorija'**
  String get serviceHistory;

  /// No description provided for @serviceOrVendor.
  ///
  /// In sr, this message translates to:
  /// **'Servis ili prodavac'**
  String get serviceOrVendor;

  /// No description provided for @sessionExpiredBody.
  ///
  /// In sr, this message translates to:
  /// **'Iz bezbednosnih razloga potrebno je da se ponovo prijaviš.'**
  String get sessionExpiredBody;

  /// No description provided for @sessionExpiredTitle.
  ///
  /// In sr, this message translates to:
  /// **'Sesija je istekla'**
  String get sessionExpiredTitle;

  /// No description provided for @setPin.
  ///
  /// In sr, this message translates to:
  /// **'Postavi PIN za Vault'**
  String get setPin;

  /// No description provided for @settings.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja'**
  String get settings;

  /// No description provided for @share.
  ///
  /// In sr, this message translates to:
  /// **'Podeli'**
  String get share;

  /// No description provided for @shareFile.
  ///
  /// In sr, this message translates to:
  /// **'Izvezi fajl'**
  String get shareFile;

  /// No description provided for @sharedByMe.
  ///
  /// In sr, this message translates to:
  /// **'Ja delim'**
  String get sharedByMe;

  /// No description provided for @sharedDocuments.
  ///
  /// In sr, this message translates to:
  /// **'Deljeni dokumenti'**
  String get sharedDocuments;

  /// No description provided for @sharedWithMe.
  ///
  /// In sr, this message translates to:
  /// **'Deljeno sa mnom'**
  String get sharedWithMe;

  /// No description provided for @sharing.
  ///
  /// In sr, this message translates to:
  /// **'Deljenje i privatnost'**
  String get sharing;

  /// No description provided for @sharingNeedsFamily.
  ///
  /// In sr, this message translates to:
  /// **'Dokumente možeš da deliš sa članovima porodice u Family paketima.'**
  String get sharingNeedsFamily;

  /// No description provided for @sharingServerNote.
  ///
  /// In sr, this message translates to:
  /// **'Pristup se proverava na serveru za svaki dokument i fajl. Kada nekome ukloniš pristup, on ga odmah gubi.'**
  String get sharingServerNote;

  /// No description provided for @sharingUpdated.
  ///
  /// In sr, this message translates to:
  /// **'Deljenje je ažurirano'**
  String get sharingUpdated;

  /// No description provided for @showCompleted.
  ///
  /// In sr, this message translates to:
  /// **'Prikaži završene'**
  String get showCompleted;

  /// No description provided for @showDetailsHelp.
  ///
  /// In sr, this message translates to:
  /// **'Isključeno: na zaključanom ekranu piše samo da imaš podsetnik. Uključeno: prikazuje se naziv podsetnika.'**
  String get showDetailsHelp;

  /// No description provided for @showDetailsInNotifications.
  ///
  /// In sr, this message translates to:
  /// **'Prikaži naziv u obaveštenju'**
  String get showDetailsInNotifications;

  /// No description provided for @showPassword.
  ///
  /// In sr, this message translates to:
  /// **'Prikaži lozinku'**
  String get showPassword;

  /// No description provided for @showUsedExpired.
  ///
  /// In sr, this message translates to:
  /// **'Prikaži iskorišćene i istekle'**
  String get showUsedExpired;

  /// No description provided for @signIn.
  ///
  /// In sr, this message translates to:
  /// **'Prijavi se'**
  String get signIn;

  /// No description provided for @signInTitle.
  ///
  /// In sr, this message translates to:
  /// **'Dobro došao nazad'**
  String get signInTitle;

  /// No description provided for @signInAsTester.
  ///
  /// In sr, this message translates to:
  /// **'Uđi kao tester'**
  String get signInAsTester;

  /// No description provided for @signOut.
  ///
  /// In sr, this message translates to:
  /// **'Odjavi se'**
  String get signOut;

  /// No description provided for @signUpTitle.
  ///
  /// In sr, this message translates to:
  /// **'Napravi svoj MyWorld+'**
  String get signUpTitle;

  /// No description provided for @skip.
  ///
  /// In sr, this message translates to:
  /// **'Preskoči'**
  String get skip;

  /// No description provided for @snoozeWeek.
  ///
  /// In sr, this message translates to:
  /// **'Odloži za nedelju dana'**
  String get snoozeWeek;

  /// No description provided for @soon.
  ///
  /// In sr, this message translates to:
  /// **'Uskoro'**
  String get soon;

  /// No description provided for @sortAmountAsc.
  ///
  /// In sr, this message translates to:
  /// **'Najmanji iznos'**
  String get sortAmountAsc;

  /// No description provided for @sortAmountDesc.
  ///
  /// In sr, this message translates to:
  /// **'Najveći iznos'**
  String get sortAmountDesc;

  /// No description provided for @sortBy.
  ///
  /// In sr, this message translates to:
  /// **'Sortiranje'**
  String get sortBy;

  /// No description provided for @sortExpiry.
  ///
  /// In sr, this message translates to:
  /// **'Datum isteka'**
  String get sortExpiry;

  /// No description provided for @sortNameAsc.
  ///
  /// In sr, this message translates to:
  /// **'Naziv A–Z'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In sr, this message translates to:
  /// **'Naziv Z–A'**
  String get sortNameDesc;

  /// No description provided for @sortNewest.
  ///
  /// In sr, this message translates to:
  /// **'Najnovije'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In sr, this message translates to:
  /// **'Najstarije'**
  String get sortOldest;

  /// No description provided for @source.
  ///
  /// In sr, this message translates to:
  /// **'Izvor'**
  String get source;

  /// No description provided for @sources.
  ///
  /// In sr, this message translates to:
  /// **'Izvori'**
  String get sources;

  /// No description provided for @startExport.
  ///
  /// In sr, this message translates to:
  /// **'Napravi izvoz'**
  String get startExport;

  /// No description provided for @status.
  ///
  /// In sr, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusActive.
  ///
  /// In sr, this message translates to:
  /// **'Aktivno'**
  String get statusActive;

  /// No description provided for @statusCancelled.
  ///
  /// In sr, this message translates to:
  /// **'Otkazano'**
  String get statusCancelled;

  /// No description provided for @statusDiscarded.
  ///
  /// In sr, this message translates to:
  /// **'Odbačeno'**
  String get statusDiscarded;

  /// No description provided for @statusDone.
  ///
  /// In sr, this message translates to:
  /// **'Završeno'**
  String get statusDone;

  /// No description provided for @statusDraft.
  ///
  /// In sr, this message translates to:
  /// **'Nacrt'**
  String get statusDraft;

  /// No description provided for @statusFailed.
  ///
  /// In sr, this message translates to:
  /// **'Neuspešno'**
  String get statusFailed;

  /// No description provided for @statusInRepair.
  ///
  /// In sr, this message translates to:
  /// **'Na popravci'**
  String get statusInRepair;

  /// No description provided for @statusNeedsReview.
  ///
  /// In sr, this message translates to:
  /// **'Za proveru'**
  String get statusNeedsReview;

  /// No description provided for @statusProcessing.
  ///
  /// In sr, this message translates to:
  /// **'Obrada'**
  String get statusProcessing;

  /// No description provided for @statusReady.
  ///
  /// In sr, this message translates to:
  /// **'Spremno'**
  String get statusReady;

  /// No description provided for @statusRefreshed.
  ///
  /// In sr, this message translates to:
  /// **'Status je osvežen'**
  String get statusRefreshed;

  /// No description provided for @statusSnoozed.
  ///
  /// In sr, this message translates to:
  /// **'Odloženo'**
  String get statusSnoozed;

  /// No description provided for @statusSold.
  ///
  /// In sr, this message translates to:
  /// **'Prodato'**
  String get statusSold;

  /// No description provided for @statusUploaded.
  ///
  /// In sr, this message translates to:
  /// **'Otpremljeno'**
  String get statusUploaded;

  /// No description provided for @statusUploading.
  ///
  /// In sr, this message translates to:
  /// **'Otpremanje'**
  String get statusUploading;

  /// No description provided for @storage.
  ///
  /// In sr, this message translates to:
  /// **'Skladište'**
  String get storage;

  /// No description provided for @storageAlmostFull.
  ///
  /// In sr, this message translates to:
  /// **'Skladište je skoro puno'**
  String get storageAlmostFull;

  /// No description provided for @subActive.
  ///
  /// In sr, this message translates to:
  /// **'Aktivna'**
  String get subActive;

  /// No description provided for @subBillingIssue.
  ///
  /// In sr, this message translates to:
  /// **'Problem sa naplatom'**
  String get subBillingIssue;

  /// No description provided for @subCancelled.
  ///
  /// In sr, this message translates to:
  /// **'Otkazana — važi do kraja perioda'**
  String get subCancelled;

  /// No description provided for @subExpired.
  ///
  /// In sr, this message translates to:
  /// **'Istekla'**
  String get subExpired;

  /// No description provided for @subNone.
  ///
  /// In sr, this message translates to:
  /// **'Besplatni paket'**
  String get subNone;

  /// No description provided for @subRefunded.
  ///
  /// In sr, this message translates to:
  /// **'Refundirana'**
  String get subRefunded;

  /// No description provided for @subscriptionTerms.
  ///
  /// In sr, this message translates to:
  /// **'Pretplata se automatski obnavlja svakog meseca dok je ne otkažeš u podešavanjima App Store-a ili Google Play-a. Naplata ide preko tvog naloga u prodavnici.'**
  String get subscriptionTerms;

  /// No description provided for @summary.
  ///
  /// In sr, this message translates to:
  /// **'Sažetak'**
  String get summary;

  /// No description provided for @supportPrivacyNote.
  ///
  /// In sr, this message translates to:
  /// **'Nikada ne šalji lozinke niti sadržaj dokumenata podršci.'**
  String get supportPrivacyNote;

  /// No description provided for @tagline.
  ///
  /// In sr, this message translates to:
  /// **'Tvoj život. Na jednom mestu.'**
  String get tagline;

  /// No description provided for @tags.
  ///
  /// In sr, this message translates to:
  /// **'Tagovi'**
  String get tags;

  /// No description provided for @takePhoto.
  ///
  /// In sr, this message translates to:
  /// **'Fotografiši'**
  String get takePhoto;

  /// No description provided for @termsOfUse.
  ///
  /// In sr, this message translates to:
  /// **'Uslovi korišćenja'**
  String get termsOfUse;

  /// No description provided for @thisYear.
  ///
  /// In sr, this message translates to:
  /// **'Ove godine'**
  String get thisYear;

  /// No description provided for @timezone.
  ///
  /// In sr, this message translates to:
  /// **'Vremenska zona'**
  String get timezone;

  /// No description provided for @title.
  ///
  /// In sr, this message translates to:
  /// **'Naziv'**
  String get title;

  /// No description provided for @today.
  ///
  /// In sr, this message translates to:
  /// **'Danas'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In sr, this message translates to:
  /// **'Sutra'**
  String get tomorrow;

  /// No description provided for @totalInvested.
  ///
  /// In sr, this message translates to:
  /// **'Ukupno uloženo'**
  String get totalInvested;

  /// No description provided for @totalValue.
  ///
  /// In sr, this message translates to:
  /// **'Ukupna vrednost'**
  String get totalValue;

  /// No description provided for @trash.
  ///
  /// In sr, this message translates to:
  /// **'Korpa'**
  String get trash;

  /// No description provided for @trashEmpty.
  ///
  /// In sr, this message translates to:
  /// **'Korpa je prazna'**
  String get trashEmpty;

  /// No description provided for @trashRetention.
  ///
  /// In sr, this message translates to:
  /// **'Dokumenti iz korpe trajno se brišu posle 30 dana.'**
  String get trashRetention;

  /// No description provided for @tryAi.
  ///
  /// In sr, this message translates to:
  /// **'Pitaj AI'**
  String get tryAi;

  /// No description provided for @typeDeleteToConfirm.
  ///
  /// In sr, this message translates to:
  /// **'Upiši OBRIŠI za potvrdu'**
  String get typeDeleteToConfirm;

  /// No description provided for @unlock.
  ///
  /// In sr, this message translates to:
  /// **'Otključaj'**
  String get unlock;

  /// No description provided for @unlockVaultReason.
  ///
  /// In sr, this message translates to:
  /// **'Otključaj Vault'**
  String get unlockVaultReason;

  /// No description provided for @upcomingDeadlines.
  ///
  /// In sr, this message translates to:
  /// **'Predstojeći rokovi'**
  String get upcomingDeadlines;

  /// No description provided for @upgradeAiBody.
  ///
  /// In sr, this message translates to:
  /// **'AI čita račune, predlaže kategorije i podsetnike i odgovara na pitanja o tvojim podacima — uz izvore.'**
  String get upgradeAiBody;

  /// No description provided for @upgradeAiTitle.
  ///
  /// In sr, this message translates to:
  /// **'AI pomoć je u Pro paketima'**
  String get upgradeAiTitle;

  /// No description provided for @upgradeDocumentsBody.
  ///
  /// In sr, this message translates to:
  /// **'Dostigao si broj dokumenata za besplatni paket. Ništa se ne briše — izaberi veći paket za više prostora.'**
  String get upgradeDocumentsBody;

  /// No description provided for @upgradeDocumentsTitle.
  ///
  /// In sr, this message translates to:
  /// **'Limit dokumenata'**
  String get upgradeDocumentsTitle;

  /// No description provided for @upgradeExportBody.
  ///
  /// In sr, this message translates to:
  /// **'CSV izvoz je deo Pro paketa.'**
  String get upgradeExportBody;

  /// No description provided for @upgradeExportTitle.
  ///
  /// In sr, this message translates to:
  /// **'Napredni izvoz'**
  String get upgradeExportTitle;

  /// No description provided for @upgradeFamilyBody.
  ///
  /// In sr, this message translates to:
  /// **'Porodični prostor, pozivnice i deljenje dokumenata dostupni su u Family Base i Family Pro paketima.'**
  String get upgradeFamilyBody;

  /// No description provided for @upgradeFamilyTitle.
  ///
  /// In sr, this message translates to:
  /// **'Family paket'**
  String get upgradeFamilyTitle;

  /// No description provided for @upgradeFiltersBody.
  ///
  /// In sr, this message translates to:
  /// **'Filteri po statusu obrade i napredna pretraga dostupni su u plaćenim paketima.'**
  String get upgradeFiltersBody;

  /// No description provided for @upgradeFiltersTitle.
  ///
  /// In sr, this message translates to:
  /// **'Napredni filteri'**
  String get upgradeFiltersTitle;

  /// No description provided for @upgradeStorageBody.
  ///
  /// In sr, this message translates to:
  /// **'Ništa nije obrisano. Za više prostora izaberi veći paket ili oslobodi prostor.'**
  String get upgradeStorageBody;

  /// No description provided for @upgradeStorageTitle.
  ///
  /// In sr, this message translates to:
  /// **'Prostor je pun'**
  String get upgradeStorageTitle;

  /// No description provided for @upgradeVehiclesBody.
  ///
  /// In sr, this message translates to:
  /// **'Tvoj paket dozvoljava ograničen broj vozila. Veći paket omogućava više.'**
  String get upgradeVehiclesBody;

  /// No description provided for @upgradeVehiclesTitle.
  ///
  /// In sr, this message translates to:
  /// **'Limit vozila'**
  String get upgradeVehiclesTitle;

  /// No description provided for @uploadErrorTitle.
  ///
  /// In sr, this message translates to:
  /// **'Otpremanje nije uspelo'**
  String get uploadErrorTitle;

  /// No description provided for @uploadFailedHint.
  ///
  /// In sr, this message translates to:
  /// **'Fajl nije otpremljen ili nije prošao proveru. Otpremi ga ponovo.'**
  String get uploadFailedHint;

  /// No description provided for @uploadKeepOpen.
  ///
  /// In sr, this message translates to:
  /// **'Ne zatvaraj aplikaciju dok se otpremanje ne završi.'**
  String get uploadKeepOpen;

  /// No description provided for @useBiometrics.
  ///
  /// In sr, this message translates to:
  /// **'Koristi biometriju'**
  String get useBiometrics;

  /// No description provided for @useRegularSearch.
  ///
  /// In sr, this message translates to:
  /// **'Koristi običnu pretragu'**
  String get useRegularSearch;

  /// No description provided for @validFrom.
  ///
  /// In sr, this message translates to:
  /// **'Važi od'**
  String get validFrom;

  /// No description provided for @vaultEmpty.
  ///
  /// In sr, this message translates to:
  /// **'Vault je prazan'**
  String get vaultEmpty;

  /// No description provided for @vaultEmptyBody.
  ///
  /// In sr, this message translates to:
  /// **'Ovde čuvaj lične dokumente, ugovore, polise i potvrde.'**
  String get vaultEmptyBody;

  /// No description provided for @vaultLockDisclaimer.
  ///
  /// In sr, this message translates to:
  /// **'PIN i biometrija dodatno štite otvaranje Vault-a na ovom uređaju. To nije enkripcija: tvoji fajlovi su zaštićeni proverom pristupa na serveru, bez obzira na PIN.'**
  String get vaultLockDisclaimer;

  /// No description provided for @vaultLocked.
  ///
  /// In sr, this message translates to:
  /// **'Vault je zaključan'**
  String get vaultLocked;

  /// No description provided for @vaultLockedBody.
  ///
  /// In sr, this message translates to:
  /// **'Unesi PIN ili koristi biometriju.'**
  String get vaultLockedBody;

  /// No description provided for @vaultSettings.
  ///
  /// In sr, this message translates to:
  /// **'Podešavanja Vault-a'**
  String get vaultSettings;

  /// No description provided for @vaultSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Privatna i posebno važna dokumenta. Ovde nema oglasa.'**
  String get vaultSubtitle;

  /// No description provided for @vendor.
  ///
  /// In sr, this message translates to:
  /// **'Prodavac'**
  String get vendor;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In sr, this message translates to:
  /// **'Potvrdi e-mail'**
  String get verifyEmailTitle;

  /// No description provided for @warrantiesExpiring.
  ///
  /// In sr, this message translates to:
  /// **'Garancije ističu'**
  String get warrantiesExpiring;

  /// No description provided for @warranty.
  ///
  /// In sr, this message translates to:
  /// **'Garancija'**
  String get warranty;

  /// No description provided for @warrantyConfirm.
  ///
  /// In sr, this message translates to:
  /// **'Potvrđujem datum garancije'**
  String get warrantyConfirm;

  /// No description provided for @warrantyConfirmHelp.
  ///
  /// In sr, this message translates to:
  /// **'Proveri na garantnom listu. Garancija se nikada ne postavlja bez tvoje potvrde.'**
  String get warrantyConfirmHelp;

  /// No description provided for @warrantyFieldHelp.
  ///
  /// In sr, this message translates to:
  /// **'Unesi samo ako je navedeno na garantnom listu'**
  String get warrantyFieldHelp;

  /// No description provided for @warrantySuggestion.
  ///
  /// In sr, this message translates to:
  /// **'Predlog sa dokumenta'**
  String get warrantySuggestion;

  /// No description provided for @warrantyUntil.
  ///
  /// In sr, this message translates to:
  /// **'Garancija do'**
  String get warrantyUntil;

  /// No description provided for @warrantyUserEnteredNote.
  ///
  /// In sr, this message translates to:
  /// **'Datum garancije je onaj koji si uneo ili potvrdio.'**
  String get warrantyUserEnteredNote;

  /// No description provided for @website.
  ///
  /// In sr, this message translates to:
  /// **'Sajt'**
  String get website;

  /// No description provided for @welcome.
  ///
  /// In sr, this message translates to:
  /// **'Dobro došli'**
  String get welcome;

  /// No description provided for @withReminder.
  ///
  /// In sr, this message translates to:
  /// **'Sa podsetnikom'**
  String get withReminder;

  /// No description provided for @withWarranty.
  ///
  /// In sr, this message translates to:
  /// **'Sa garancijom'**
  String get withWarranty;

  /// No description provided for @worldSubtitle.
  ///
  /// In sr, this message translates to:
  /// **'Sve oblasti tvog života'**
  String get worldSubtitle;

  /// No description provided for @year.
  ///
  /// In sr, this message translates to:
  /// **'Godina proizvodnje'**
  String get year;

  /// No description provided for @you.
  ///
  /// In sr, this message translates to:
  /// **'ti'**
  String get you;

  /// No description provided for @addDocumentFor.
  ///
  /// In sr, this message translates to:
  /// **'Dokument za {name}'**
  String addDocumentFor(String name);

  /// No description provided for @cardExpiresTitle.
  ///
  /// In sr, this message translates to:
  /// **'Ističe kartica: {name}'**
  String cardExpiresTitle(String name);

  /// No description provided for @cardsCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, =0{Nema kartica} one{{count} kartica} few{{count} kartice} other{{count} kartica}}'**
  String cardsCount(int count);

  /// No description provided for @cardsExpiringSoon.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{{count} kartica ističe u naredne 2 nedelje} few{{count} kartice ističu u naredne 2 nedelje} other{{count} kartica ističe u naredne 2 nedelje}}'**
  String cardsExpiringSoon(int count);

  /// No description provided for @contactsCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, =0{Nema kontakata} one{{count} kontakt} few{{count} kontakta} other{{count} kontakata}}'**
  String contactsCount(int count);

  /// No description provided for @daysAgo.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{pre {count} dan} few{pre {count} dana} other{pre {count} dana}}'**
  String daysAgo(int count);

  /// No description provided for @daysBefore.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{{count} dan ranije} few{{count} dana ranije} other{{count} dana ranije}}'**
  String daysBefore(int count);

  /// No description provided for @documentExpiresTitle.
  ///
  /// In sr, this message translates to:
  /// **'Ističe: {title}'**
  String documentExpiresTitle(String title);

  /// No description provided for @documentsCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, =0{Nema dokumenata} one{{count} dokument} few{{count} dokumenta} other{{count} dokumenata}}'**
  String documentsCount(int count);

  /// No description provided for @documentsUsed.
  ///
  /// In sr, this message translates to:
  /// **'Dokumenata: {used} od {limit}'**
  String documentsUsed(int used, int limit);

  /// No description provided for @duplicateBody.
  ///
  /// In sr, this message translates to:
  /// **'Isti fajl je već sačuvan kao „{title}”. Da li želiš da ga sačuvaš ponovo?'**
  String duplicateBody(String title);

  /// No description provided for @expiresOn.
  ///
  /// In sr, this message translates to:
  /// **'Ističe {date}'**
  String expiresOn(String date);

  /// No description provided for @featureDocuments.
  ///
  /// In sr, this message translates to:
  /// **'Do {count} dokumenata'**
  String featureDocuments(String count);

  /// No description provided for @featureMembers.
  ///
  /// In sr, this message translates to:
  /// **'Do {count} članova porodice'**
  String featureMembers(int count);

  /// No description provided for @featureStorage.
  ///
  /// In sr, this message translates to:
  /// **'{size} prostora'**
  String featureStorage(String size);

  /// No description provided for @helloName.
  ///
  /// In sr, this message translates to:
  /// **'Zdravo, {name}'**
  String helloName(String name);

  /// No description provided for @hoursBefore.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{{count} sat ranije} few{{count} sata ranije} other{{count} sati ranije}}'**
  String hoursBefore(int count);

  /// No description provided for @inDays.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{za {count} dan} few{za {count} dana} other{za {count} dana}}'**
  String inDays(int count);

  /// No description provided for @invitationBody.
  ///
  /// In sr, this message translates to:
  /// **'{name} te poziva u porodični prostor. Prihvatanjem ne dobijaš automatski pristup svim dokumentima — vidiš samo ono što ti drugi podele.'**
  String invitationBody(String name);

  /// No description provided for @inviteShareText.
  ///
  /// In sr, this message translates to:
  /// **'Pozivam te u našu porodicu na MyWorld+: {link}'**
  String inviteShareText(String link);

  /// No description provided for @invitedTo.
  ///
  /// In sr, this message translates to:
  /// **'Poziv u porodicu „{name}”'**
  String invitedTo(String name);

  /// No description provided for @itemsCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, =0{Nema predmeta} one{{count} predmet} few{{count} predmeta} other{{count} predmeta}}'**
  String itemsCount(int count);

  /// No description provided for @joinedOn.
  ///
  /// In sr, this message translates to:
  /// **'Član od {date}'**
  String joinedOn(String date);

  /// No description provided for @last12Months.
  ///
  /// In sr, this message translates to:
  /// **'Poslednjih 12 meseci {currency}'**
  String last12Months(String currency);

  /// No description provided for @lastOn.
  ///
  /// In sr, this message translates to:
  /// **'Poslednje: {date}'**
  String lastOn(String date);

  /// No description provided for @membersCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{{count} član} few{{count} člana} other{{count} članova}}'**
  String membersCount(int count);

  /// No description provided for @minutesBefore.
  ///
  /// In sr, this message translates to:
  /// **'{count} min ranije'**
  String minutesBefore(int count);

  /// No description provided for @nextDue.
  ///
  /// In sr, this message translates to:
  /// **'Sledeće: {date}'**
  String nextDue(String date);

  /// No description provided for @offerReminderBody.
  ///
  /// In sr, this message translates to:
  /// **'Želiš li podsetnik za {date}?'**
  String offerReminderBody(String date);

  /// No description provided for @pageN.
  ///
  /// In sr, this message translates to:
  /// **'Strana {n}'**
  String pageN(int n);

  /// No description provided for @pagesCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{{count} strana} few{{count} strane} other{{count} strana}}'**
  String pagesCount(int count);

  /// No description provided for @pricePerMonth.
  ///
  /// In sr, this message translates to:
  /// **'{price} € / mesečno'**
  String pricePerMonth(String price);

  /// No description provided for @purchasedOn.
  ///
  /// In sr, this message translates to:
  /// **'Kupljeno {date}'**
  String purchasedOn(String date);

  /// No description provided for @remindersCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, =0{Nema podsetnika} one{{count} podsetnik} few{{count} podsetnika} other{{count} podsetnika}}'**
  String remindersCount(int count);

  /// No description provided for @removeMemberTitle.
  ///
  /// In sr, this message translates to:
  /// **'Ukloniti člana {name}?'**
  String removeMemberTitle(String name);

  /// No description provided for @reviewIntro.
  ///
  /// In sr, this message translates to:
  /// **'AI je pročitao dokument (pouzdanost {percent}%). Proveri i ispravi podatke pre čuvanja.'**
  String reviewIntro(int percent);

  /// No description provided for @reviewNeededFor.
  ///
  /// In sr, this message translates to:
  /// **'Proveri predloge: {title}'**
  String reviewNeededFor(String title);

  /// No description provided for @scanReviewTitle.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{{count} strana} few{{count} strane} other{{count} strana}}'**
  String scanReviewTitle(int count);

  /// No description provided for @sharedBy.
  ///
  /// In sr, this message translates to:
  /// **'Delio: {name}'**
  String sharedBy(String name);

  /// No description provided for @storageUsed.
  ///
  /// In sr, this message translates to:
  /// **'Iskorišćeno {used} od {total}'**
  String storageUsed(String used, String total);

  /// No description provided for @uploadProgress.
  ///
  /// In sr, this message translates to:
  /// **'Otpremanje… {percent}%'**
  String uploadProgress(int percent);

  /// No description provided for @validUntil.
  ///
  /// In sr, this message translates to:
  /// **'Važi do {date}'**
  String validUntil(String date);

  /// No description provided for @vehiclesCount.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, =0{Nema vozila} one{{count} vozilo} few{{count} vozila} other{{count} vozila}}'**
  String vehiclesCount(int count);

  /// No description provided for @verifyEmailBody.
  ///
  /// In sr, this message translates to:
  /// **'Poslali smo link na {email}. Otvori ga da potvrdiš nalog.'**
  String verifyEmailBody(String email);

  /// No description provided for @warrantyActiveUntil.
  ///
  /// In sr, this message translates to:
  /// **'Garancija važi do {date}'**
  String warrantyActiveUntil(String date);

  /// No description provided for @warrantyDaysLeft.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{Još {count} dan garancije} few{Još {count} dana garancije} other{Još {count} dana garancije}}'**
  String warrantyDaysLeft(int count);

  /// No description provided for @warrantyExpiredOn.
  ///
  /// In sr, this message translates to:
  /// **'Garancija je istekla {date}'**
  String warrantyExpiredOn(String date);

  /// No description provided for @warrantyExpiresTitle.
  ///
  /// In sr, this message translates to:
  /// **'Ističe garancija: {name}'**
  String warrantyExpiresTitle(String name);

  /// No description provided for @warrantyPrintedMonths.
  ///
  /// In sr, this message translates to:
  /// **'Na dokumentu: {months} meseci garancije'**
  String warrantyPrintedMonths(int months);

  /// No description provided for @warrantyPrintedUntil.
  ///
  /// In sr, this message translates to:
  /// **'Na dokumentu: do {date}'**
  String warrantyPrintedUntil(String date);

  /// No description provided for @warrantyUntilShort.
  ///
  /// In sr, this message translates to:
  /// **'Garancija do {date}'**
  String warrantyUntilShort(String date);

  /// No description provided for @willBeSavedIn.
  ///
  /// In sr, this message translates to:
  /// **'Biće sačuvano u: {destination}'**
  String willBeSavedIn(String destination);

  /// No description provided for @wrongPin.
  ///
  /// In sr, this message translates to:
  /// **'{count, plural, one{Pogrešan PIN. Ostao je još {count} pokušaj.} few{Pogrešan PIN. Ostala su još {count} pokušaja.} other{Pogrešan PIN. Ostalo je još {count} pokušaja.}}'**
  String wrongPin(int count);

  /// No description provided for @suggestedLinks.
  ///
  /// In sr, this message translates to:
  /// **'Predložene veze'**
  String get suggestedLinks;

  /// No description provided for @suggestedLinksHelp.
  ///
  /// In sr, this message translates to:
  /// **'Pronašli smo stvari koje odgovaraju dokumentu. Označi one sa kojima želiš da ga povežeš.'**
  String get suggestedLinksHelp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'ru',
    'sr',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'sr':
      return AppLocalizationsSr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
