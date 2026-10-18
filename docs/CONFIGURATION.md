# Konfiguracija

Ništa od ovoga nije podešeno u repozitorijumu — sve zahteva tvoje naloge. Tajne nikada ne idu u git.

## 1. Firebase projekti
Tri projekta (alias-i u `.firebaserc`): `myworldplus-dev`, `myworldplus-staging`, `myworldplus-prod`. Promeni ID-jeve ako su zauzeti.

U svakom projektu:
1. **Blaze plan** (Cloud Functions, Scheduler, Secret Manager).
2. Firestore (Native mode) — region `europe-west1` ili `eur3`.
3. Storage — isti region.
4. Authentication → Sign-in method: **Email/Password** (uključi „Email enumeration protection”), **Google**, **Apple**.
5. App Check → Play Integrity (Android), App Attest + DeviceCheck (iOS). Uključi „Enforce” za Firestore, Storage i Functions kada build radi.
6. Cloud Messaging → za iOS otpremi APNs auth key.
7. Crashlytics, Analytics (kolekcija je podrazumevano isključena u aplikaciji).

## 2. Nativni Firebase fajlovi (nisu u gitu)
- `app/android/app/google-services.json`
- `app/ios/Runner/GoogleService-Info.plist`

Preuzmi iz Firebase konzole za svaki projekat (ili `flutterfire configure`). Android paket: `app.myworldplus.myworld_plus`; iOS bundle: `app.myworldplus.myworldPlus`.

## 3. Tajne za Cloud Functions (Secret Manager)
```bash
firebase use prod
firebase functions:secrets:set OPENAI_API_KEY
firebase functions:secrets:set REVENUECAT_SECRET_API_KEY     # RevenueCat → Project → API keys → Secret (v1)
firebase functions:secrets:set REVENUECAT_WEBHOOK_AUTH        # nasumičan string, isti kao u RevenueCat webhook Authorization headeru
```

## 4. Ne-tajne promenljive za Functions
`functions/.env.<projectId>` (primer: `functions/.env.example`):

| Promenljiva | Podrazumevano | Opis |
|---|---|---|
| `OPENAI_MODEL_EXTRACTION` | `gpt-5-mini` | Model za čitanje dokumenata. |
| `OPENAI_MODEL_ASK` | `gpt-5-mini` | Model za pitanja. |
| `OPENAI_MODEL_CLASSIFY` | `gpt-5-nano` | Jeftin model (vizit karte). |
| `AI_GLOBAL_MONTHLY_BUDGET_USD` | `200` | Globalni mesečni limit; upozorenje na 80 %. |
| `INVITE_LINK_BASE` | `https://myworld-b0330.web.app/invite` | Baza linka pozivnice. |
| `APP_REGION` | `europe-west1` | Region funkcija. |

Cene modela za procenu troška: `functions/src/ai/usage.ts` (`PRICES`) — ažuriraj kada se cene promene.

## 5. RevenueCat
1. Napravi projekat, poveži App Store Connect i Google Play (service account).
2. Proizvodi (mesečne pretplate) u obe prodavnice, npr. `mw_individual_pro_monthly`, `mw_family_base_monthly`, `mw_family_pro_monthly`.
3. **Entitlements** u RevenueCat-u sa tačno ovim ID-jevima: `individual_pro`, `family_base`, `family_pro`.
4. Offering „default” sa paketima čiji ID proizvoda sadrži `individual_pro` / `family_base` / `family_pro`.
5. Webhook: URL `https://europe-west1-<projekat>.cloudfunctions.net/revenueCatWebhook`, Authorization header `Bearer <REVENUECAT_WEBHOOK_AUTH>`.
6. App User ID = Firebase UID (aplikacija to postavlja sama).

## 6. Build-time parametri aplikacije (`--dart-define`)

| Ključ | Primer | Opis |
|---|---|---|
| `FLAVOR` | `prod` | `dev` / `staging` / `prod` |
| `USE_EMULATORS` | `true` | Lokalni emulator. |
| `EMULATOR_HOST` | `10.0.2.2` | Host emulatora. |
| `FUNCTIONS_REGION` | `europe-west1` | |
| `REVENUECAT_APPLE_KEY` / `REVENUECAT_GOOGLE_KEY` | `appl_…` / `goog_…` | Javni SDK ključevi (nisu tajni). |
| `ADMOB_UNIT_ANDROID` / `ADMOB_UNIT_IOS` | | Banner/medium-rectangle jedinice (podrazumevano Google test ID). |
| `GOOGLE_SERVER_CLIENT_ID` | `…apps.googleusercontent.com` | Web client ID za Google prijavu. |
| `PRIVACY_URL`, `TERMS_URL`, `SUPPORT_EMAIL`, `INVITE_HOST` | | Pravni linkovi, podrška, domen pozivnica. |

Primer:
```bash
flutter build appbundle --release \
  --dart-define=FLAVOR=prod \
  --dart-define=REVENUECAT_GOOGLE_KEY=goog_xxx \
  --dart-define=ADMOB_UNIT_ANDROID=ca-app-pub-xxx/yyy \
  --dart-define=GOOGLE_SERVER_CLIENT_ID=xxx.apps.googleusercontent.com \
  -PADMOB_APP_ID=ca-app-pub-xxx~yyy
```

## 7. AdMob
- Android App ID: Gradle property `ADMOB_APP_ID` (podrazumevano test ID).
- iOS App ID: `app/ios/Flutter/Secrets.xcconfig` (primer: `Secrets.xcconfig.example`).
- U AdMob konzoli podesi **UMP poruku** (GDPR / US state privacy). Aplikacija je prikazuje pre prvog oglasa i samo u Individual Base paketu.

## 8. Domen pozivnica
Firebase Hosting na `myworld-b0330.web.app` (ili tvoj domen) servira `hosting/.well-known/assetlinks.json` i `apple-app-site-association`. Zameni `REPLACE_…` vrednosti (SHA-256 sertifikata za Android, Team ID za iOS). Ako promeniš domen, promeni ga i u `AndroidManifest.xml`, `Runner.entitlements`, `INVITE_LINK_BASE`, `INVITE_HOST`.

## 9. iOS u Xcode-u
Signing & Capabilities: Push Notifications, Sign in with Apple, Associated Domains, App Attest (entitlements su u `Runner/Runner.entitlements`), Background Modes → Remote notifications. Minimalni iOS: 15.0.

## 10. Android potpisivanje
`app/android/key.properties` (nije u gitu):
```
storeFile=/apsolutna/putanja/upload-keystore.jks
storePassword=…
keyAlias=upload
keyPassword=…
```
