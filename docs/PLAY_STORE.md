# Google Play — objava

Sve što ide u Play Console, spremno za kopiranje. Tajne (lozinke, keystore) nisu ovde.

## 1. Potpisivanje

- Upload keystore: `myworldplus-upload.jks`, alias `upload` (čuva vlasnik, **nije u gitu**). Izgubljen ključ = zahtev Google-u za reset upload ključa.
- Lokalno: `app/android/key.properties` (primer u [CONFIGURATION.md](CONFIGURATION.md#10-android-potpisivanje)).
- Upload SHA-1: `6E:64:7B:56:FA:D2:B9:7A:61:D9:CC:B9:94:95:55:9A:82:DF:33:E7`
- Upload SHA-256: `44:50:71:19:76:46:7C:13:7C:A8:4F:FF:A1:F9:56:C8:32:C9:C3:EB:36:FE:76:B9:C4:86:AB:A8:87:53:0B:ED`
- Uključi **Play App Signing** pri prvom otpremanju. Posle toga iz *Setup → App signing* prepiši **App signing key** SHA-1 i SHA-256:
  - u Firebase (*Project settings → Android app → Add fingerprint*) — inače Google prijava iz Play verzije ne radi;
  - u `hosting/.well-known/assetlinks.json` — inače linkovi pozivnica ne otvaraju aplikaciju; zatim `firebase deploy --only hosting`.

Build za Play (App Bundle, bez test dugmeta):
```bash
cd app
flutter build appbundle --release \
  --dart-define=FLAVOR=prod \
  --dart-define=REVENUECAT_GOOGLE_KEY=goog_xxx \
  --dart-define=ADMOB_UNIT_ANDROID=ca-app-pub-xxx/yyy \
  -PADMOB_APP_ID=ca-app-pub-xxx~yyy
# → build/app/outputs/bundle/release/app-release.aab
```

## 2. Nalog i testiranje

- Lični developer nalog napravljen posle novembra 2023: pre produkcije je obavezno **zatvoreno testiranje sa najmanje 12 testera, 14 dana zaredom**.
- Organizacijski nalog (firma, D-U-N-S broj) nema taj uslov.

## 3. Store listing

**Naziv (≤ 30):** `MyWorld+: dokumenti i rokovi`
EN: `MyWorld+ Documents & Reminders`

**Kratak opis (≤ 80):**
SR: `Dokumenti, garancije, vozila i rokovi na jednom mestu — sa podsetnicima.`
EN: `Documents, warranties, vehicles and deadlines in one place — with reminders.`

**Dug opis — SR:**
```
Tvoj život. Na jednom mestu.

MyWorld+ čuva sve važne papire tvog domaćinstva i podseća te pre nego što nešto istekne.

📄 DOKUMENTI
• Skeniraj kamerom ili otpremi PDF i slike
• Lične karte, pasoši, ugovori, računi, polise, recepti
• Kategorije, omiljeni, brza pretraga, korpa sa vraćanjem 30 dana

🛡️ GARANCIJE I STVARI
• Uređaji, nameštaj, oprema za hobi — sa računom i garancijom
• Istorija servisa i održavanja

🚗 VOZILA
• Registracija, osiguranje, tehnički pregled, servisi
• Troškovi po mesecu i kategoriji, istorija kilometraže

⏰ PODSETNICI
• Rok za registraciju, istek pasoša, garancije, plaćanja
• Obaveštenje unapred, u vreme koje ti odgovara

👨‍👩‍👧 PORODICA
• Pozovi članove domaćinstva i delite samo ono što izabereš
• Profili za decu i starije bez posebnog naloga

✨ AI (Pro paketi)
• Aplikacija sama pročita dokument i predloži naslov, datume i iznose
• Postavi pitanje: „Kad mi ističe osiguranje auta?" — i dobij odgovor sa izvorom

🔒 PRIVATNOST
• Podaci se ne prodaju i ne koriste za reklame
• Izvoz svih podataka i brisanje naloga iz aplikacije

PAKETI
• Individual Base — besplatno, uz oglase
• Individual Pro — bez oglasa, AI, 10 GB
• Family Base — do 5 članova, 20 GB
• Family Pro — do 10 članova, AI, 100 GB
```

**Dug opis — EN:**
```
Your life. In one place.

MyWorld+ keeps your household's important papers together and reminds you before anything expires.

📄 DOCUMENTS
• Scan with your camera or upload PDFs and photos
• IDs, passports, contracts, receipts, policies, prescriptions
• Categories, favourites, fast search, 30-day trash

🛡️ WARRANTIES & BELONGINGS
• Appliances, furniture, hobby gear — with receipt and warranty
• Service and maintenance history

🚗 VEHICLES
• Registration, insurance, inspections, services
• Costs per month and category, mileage history

⏰ REMINDERS
• Registration due, passport expiry, warranties, payments
• Notified ahead of time, when it suits you

👨‍👩‍👧 FAMILY
• Invite household members and share only what you choose
• Profiles for kids and elderly relatives without their own account

✨ AI (Pro plans)
• Reads your document and suggests the title, dates and amounts
• Ask "When does my car insurance expire?" and get an answer with its source

🔒 PRIVACY
• Your data is never sold or used for advertising
• Export everything and delete your account from inside the app

PLANS
• Individual Base — free, with ads
• Individual Pro — no ads, AI, 10 GB
• Family Base — up to 5 members, 20 GB
• Family Pro — up to 10 members, AI, 100 GB
```

**Kategorija:** Productivity · **Oznake:** Documents, Organizer
**Grafika:** ikona 512×512 PNG, feature grafika 1024×500, 2–8 screenshotova telefona (1080×1920 ili 1080×2400).

## 4. App content

**App access** → *All or some functionality is restricted* → dodaj instrukciju:
```
Sign in with email and password on the "Welcome back" screen.
Email: tester@myworld-b0330.web.app
Password: (lozinka test naloga — čuva vlasnik)
The account has a verified email. Pro features (AI, no ads) require a subscription;
use a license tester account to test purchases.
```

**Ads:** Da, sadrži oglase (samo besplatni paket).

**Ciljna grupa:** 18+. Nije namenjena deci.

**Content rating (IARC):** uslužna aplikacija, bez nasilja, kockanja i korisničke komunikacije sa strancima → očekivano *Everyone / PEGI 3*.

**Data safety** (na osnovu [PRIVACY.md](PRIVACY.md); proveri pre slanja):

| Tip podatka | Prikuplja se | Deli se | Svrha | Obavezno |
|---|---|---|---|---|
| Email | da | ne | nalog | da |
| Ime | da | ne | nalog | da |
| Fotografije i fajlovi (dokumenti) | da | ne* | funkcionalnost | ne |
| Kupovine (status pretplate) | da | ne* | funkcionalnost | ne |
| Identifikatori uređaja (FCM token, AdMob ID) | da | da (AdMob, besplatni paket) | obaveštenja, oglasi | ne |
| Crash logovi / dijagnostika | da | ne | analitika | ne |

\* Obrađivači (Google, OpenAI, RevenueCat) rade u ime aplikacije — to se po Play pravilima ne računa kao deljenje.
Šifrovano u prenosu: **da**. Korisnik može da zatraži brisanje: **da** (u aplikaciji + URL za brisanje naloga).

> Pažnja: Storage bucket je u **US-WEST1**, a [PRIVACY.md](PRIVACY.md) i politika privatnosti navode EU region. Uskladi tekst politike ili napravi EU bucket pre lansiranja.

## 5. Pretplate (Monetize → Subscriptions)

| Product ID | Base plan | Cena |
|---|---|---|
| `mw_individual_pro_monthly` | mesečno, auto-renew | 4,99 € |
| `mw_family_base_monthly` | mesečno, auto-renew | 4,99 € |
| `mw_family_pro_monthly` | mesečno, auto-renew | 14,99 € |

Zatim RevenueCat: entitlements `individual_pro`, `family_base`, `family_pro`, offering `default` (vidi [CONFIGURATION.md](CONFIGURATION.md#5-revenuecat)).
