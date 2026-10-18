# MyWorld+

**Tvoj život. Na jednom mestu.** — personalni i porodični digitalni sistem za dokumente, račune, garancije, stvari, vozila, kartice, vizit karte, podsetnike i AI pretragu.

| Deo | Tehnologija | Folder |
|---|---|---|
| Mobilna aplikacija (Android + iOS) | Flutter 3.47 / Dart 3.13, Riverpod 3, go_router | [`app/`](app/) |
| Backend logika | Cloud Functions for Firebase (Node 22, TypeScript) | [`functions/`](functions/) |
| Baza i fajlovi | Cloud Firestore + Cloud Storage | [`firestore.rules`](firestore.rules), [`storage.rules`](storage.rules) |
| Bezbednosni i integracioni testovi | Firebase Emulator Suite + Vitest | [`rules-tests/`](rules-tests/) |
| Linkovi pozivnica | Firebase Hosting (`/.well-known`, `/invite`) | [`hosting/`](hosting/) |
| Dokumentacija | | [`docs/`](docs/) |

## Brzi start (lokalno, bez ikakvih naloga)

Sve osim prave naplate i pravih AI poziva radi na Firebase emulatoru.

```bash
# 1. Alati
#    Flutter 3.47+, Node 22, Java 21, Firebase CLI 14+ (npm i -g firebase-tools)

# 2. Zavisnosti
cd functions && npm ci && cd ..
cd rules-tests && npm ci && cd ..
cd app && flutter pub get && flutter gen-l10n && cd ..

# 3. Lažne tajne za emulator (fajl je u .gitignore)
printf 'OPENAI_API_KEY=test\nREVENUECAT_SECRET_API_KEY=\nREVENUECAT_WEBHOOK_AUTH=test\n' > functions/.secret.local

# 4. Emulatori
npm --prefix functions run build
firebase emulators:start --project demo-myworld

# 5. Aplikacija na emulatoru (Android emulator vidi host kao 10.0.2.2)
cd app
flutter run --dart-define=USE_EMULATORS=true --dart-define=EMULATOR_HOST=10.0.2.2
```

> Za `flutter run` i dalje su potrebni nativni Firebase fajlovi (`google-services.json`, `GoogleService-Info.plist`) bilo kog Firebase projekta — vidi [docs/CONFIGURATION.md](docs/CONFIGURATION.md).

## Testovi

```bash
cd app && flutter analyze && flutter test                    # 32 Dart testa (logika, modeli, UI, pristupačnost)
cd functions && npm run lint && npm test                      # 36 unit testova (planovi, naplata, AI validacija, vremenske zone)
firebase emulators:exec --only firestore,storage --project demo-myworld \
  "cd rules-tests && npx vitest run firestore.test.js storage.test.js"   # 37 bezbednosnih testova pravila
firebase emulators:exec --only auth,firestore,storage,functions --project demo-myworld \
  "cd rules-tests && npx vitest run functions.int.test.js"              # 10 integracionih testova funkcija
```

CI: [`.github/workflows/ci.yml`](.github/workflows/ci.yml) pokreće sve četiri grupe.

## Paketi

| Paket | Cena | AI | Oglasi | Prostor | Dokumenti | Članovi |
|---|---|---|---|---|---|---|
| Individual Base | 0 € | — | da | 100 MB | 100 | 1 |
| Individual Pro | 4,99 €/mes | da | — | 10 GB | 10 000 | 1 |
| Family Base | 4,99 €/mes | — | — | 20 GB | 20 000 | 5 |
| Family Pro | 14,99 €/mes | da | — | 100 GB | 100 000 | 10 |

Jedini izvor istine: [`functions/src/plans.ts`](functions/src/plans.ts). Entitlement računa isključivo server i upisuje u `entitlements/{uid}` (klijent ne može da piše).

## Dokumentacija

- [Arhitektura](docs/ARCHITECTURE.md)
- [Data model (Firestore + Storage)](docs/DATA_MODEL.md)
- [Bezbednost i pravila pristupa](docs/SECURITY.md)
- [Konfiguracija, environment promenljive i tajne](docs/CONFIGURATION.md)
- [Deployment, backup i release checklist](docs/DEPLOYMENT.md)
- [Privatnost, GDPR i incident procedura](docs/PRIVACY.md)
- [Mapa ekrana i rute](docs/SCREENS.md)
- [Status implementacije, testovi i poznata ograničenja](docs/STATUS.md)
