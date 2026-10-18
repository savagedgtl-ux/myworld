# Arhitektura

## Pregled

```
Flutter app (Riverpod)                      Firebase
┌───────────────────────────┐   rules    ┌──────────────────────────────┐
│ features/  (ekrani)       │──────────▶ │ Firestore  (metapodaci)      │
│ core/      (tema, widgeti)│            │ Storage    (privatni fajlovi)│
│ data/      (repozitorijumi)│ callable  │ Cloud Functions              │
│ domain/    (modeli, logika)│─────────▶ │  · entitlements / naplata    │
│ services/  (Firebase, OCR,│            │  · porodica / pozivnice      │
│            billing, ads…) │            │  · AI (OpenAI, server-side)  │
└───────────────────────────┘            │  · podsetnici (scheduler)    │
        ▲   RevenueCat SDK               │  · izvoz / brisanje naloga   │
        └──── App Store / Google Play ──▶│  · RevenueCat webhook        │
                                         └──────────────────────────────┘
```

## Slojevi u aplikaciji (`app/lib`)

| Folder | Odgovornost |
|---|---|
| `core/theme` | Design tokens (boje iz specifikacije, razmaci, radijusi, animacije) i `ThemeData` (svetla + tamna). |
| `core/widgets` | Komponente: `PrimaryButton`, `SecondaryButton`, `AppSearchBar`, `SectionHeader`, `WorldCategoryCard`, `FamilyMemberCard`, `DocumentListItem`, `DocumentGridCard`, `AssetCard`, `ReminderCard`, `StorageUsageCard`, `PlanBadge`, `EmptyState`, `LoadingState`, `ErrorState`, `confirmDialog`, `FilterChips`, `UpgradePrompt`, `AdSlot`, form polja (`PrivacySelector`, `MoneyField`, `DateField`, `TagsField`). |
| `core/errors` | `AppError` — sve Firebase/Functions greške se mapiraju na kodove koje UI prevodi. Sirove poruke se ne prikazuju. |
| `domain` | Čist Dart: modeli (`DocumentRecord`, `Asset`, `Vehicle`, `VehicleRecord`, `Reminder`, `WalletCard`, `BusinessCard`, `Entitlement`, …), katalog paketa (prikaz), kategorije, logika pretrage/filtera/sortiranja, troškova, validacije fajlova (magic bytes), ponavljanja podsetnika. Potpuno testirano bez Firebase-a. |
| `data` | Repository pattern. `RecordRepository<T>` čita tačno tri oblika upita koje pravila dozvoljavaju (moje / porodično / podeljeno sa mnom) i spaja ih. `DocumentRepository` vodi tok otpremanja. |
| `services` | Firebase bootstrap (App Check, Crashlytics, emulatori), auth (e-mail, Google, Apple), Storage, skener (VisionKit / ML Kit), naplata (RevenueCat), oglasi (AdMob + UMP), notifikacije (FCM FID + lokalne), Vault zaključavanje. |
| `features` | Ekrani po oblastima: auth, home, world, add, scanner, documents, vault, assets (My Home / My Hobby), vehicles (My Car), family, reminders (My Life), cards (My Cards), business_cards, search, ai, subscriptions, settings. |
| `app` | Provajderi, ruter (zaštita ruta), shell sa donjom navigacijom, `MaterialApp`. |

**State management:** samo Riverpod 3 (`Provider`, `StreamProvider`, `Notifier`). Bez mešanja rešenja.

## Ključni tokovi

### Otpremanje dokumenta
1. Klijent proveri tip fajla po **magic bytes** i veličinu.
2. Kreira se Firestore zapis `documents/{id}` sa statusom `uploading` → pravila proveravaju vlasništvo, putanju, privatnost i **kvotu broja dokumenata** iz serverskog `usage` dokumenta.
3. Fajl ide na tačnu putanju `users/{uid}/documents/{id}/document.{ext}` → Storage pravila proveravaju vlasnika, tip, veličinu i **kvotu prostora**.
4. Status → `ready` (ili `uploaded` ako je korisnik tražio AI).
5. `onFileUploaded` (server) ponovo proverava sadržaj (magic bytes); nevalidan fajl briše i označava `failed`. Ažurira `usage.storageUsedBytes`.
6. `autoExtractOnUpload` (samo AI paketi) → `documentExtractions/{id}` + status `needs_review`. Neuspeh AI-ja vraća status `ready`; dokument se nikad ne gubi.
7. Korisnik na ekranu „Proveri AI predloge” potvrđuje polja; garancija se postavlja samo uz izričitu potvrdu.

### Naplata
RevenueCat SDK obavlja kupovinu u App Store / Google Play. Posle kupovine/restore-a aplikacija zove `syncSubscription`; server **sam** preuzima stanje sa RevenueCat REST API-ja (tajni ključ) i računa entitlement. Webhook samo okida isti re-sync, pa lažno telo zahteva ne može da dodeli pristup.

### AI
Svi pozivi idu kroz Cloud Functions: provera identiteta → **ponovni obračun entitlementa** → rezervacija budžeta (po minutu, mesečno po korisniku, po porodici, globalno) → filtriranje po dozvolama **pre** slanja modelu → strukturirani JSON izlaz (zod šema, strict) → serverska validacija → beleženje potrošnje. Model nema alate i ne može da izvrši radnju.

### Podsetnici
`dispatchReminders` svakih 5 minuta. Svaka pojava ima ključ `reminderId:nextNotifyAt` koji se u transakciji „zauzima” pre slanja → bez duplikata pri ponovnom izvršavanju. Ponavljanja čuvaju lokalno vreme u IANA zoni podsetnika (DST bezbedno). Lokalne notifikacije na uređaju su rezervni kanal.

### Porodica
Pozivnica = nasumičan 256-bitni token, u bazi samo SHA-256 heš, rok 7 dana, jednokratna, opciono vezana za potvrđen e-mail, 5 pogrešnih pokušaja → opoziv. Uklanjanje/napuštanje: članstvo `removed/left`, zapisi člana postaju privatni, član se uklanja iz `sharedWith` tuđih zapisa, entitlement se ponovo računa.
