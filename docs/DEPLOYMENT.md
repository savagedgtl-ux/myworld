# Deployment, backup i release

## Deploy backend-a
```bash
firebase use staging        # ili prod
npm --prefix functions ci
firebase deploy --only firestore:rules,firestore:indexes,storage,functions,hosting
```
Redosled za produkciju: **pravila i indeksi → funkcije → hosting → aplikacija**. Indeksi se grade nekoliko minuta; sačekaj da budu „Enabled”.

Posle prvog deploy-a:
- Cloud Scheduler: proveri da postoje `dispatchReminders` (svakih 5 min) i `dailyHousekeeping` (03:30 UTC).
- Proveri da je RevenueCat webhook zelen (test event iz RevenueCat konzole).

## Backup i oporavak
- **Firestore**: uključi *Point-in-time recovery* (7 dana) i zakazani dnevni export:
  ```bash
  gcloud firestore backups schedules create --database='(default)' --recurrence=daily --retention=14d
  ```
  Oporavak: `gcloud firestore databases restore --source-backup=… --destination-database=restore-YYYYMMDD`, provera, pa ciljana migracija.
- **Storage**: uključi *Object versioning* i *Soft delete* (7–30 dana) na bucket-u; opciono Storage Transfer u drugi region.
- **Tajne**: Secret Manager verzionisanje je uključeno po defaultu.
- Testiraj oporavak najmanje jednom kvartalno na staging-u.

## Release checklist
- [ ] `flutter analyze`, `flutter test`, `npm test`, testovi pravila i integracije — zeleno u CI.
- [ ] Verzija u `app/pubspec.yaml` (`version: x.y.z+build`).
- [ ] App Check „Enforce” uključen za Firestore, Storage, Functions.
- [ ] Prave vrednosti: AdMob App ID/units, RevenueCat ključevi, Google server client ID, `.well-known` fajlovi.
- [ ] Sandbox kupovine: kupovina, otkazivanje, istek, grace period, restore, promena paketa, refund (RevenueCat sandbox + App Store sandbox + Play licence testers).
- [ ] Ručno: skeniranje više strana, otpremanje PDF-a, prekid mreže tokom otpremanja, porodična pozivnica na dva uređaja, uklanjanje člana, brisanje naloga.
- [ ] Pristupačnost: TalkBack/VoiceOver na glavnim tokovima, font 200 %.
- [ ] Politika privatnosti i uslovi korišćenja objavljeni na `PRIVACY_URL` / `TERMS_URL`.
- [ ] App Store: Privacy Nutrition Labels, Sign in with Apple, upravljanje pretplatom, brisanje naloga u aplikaciji (postoji), opis kamere/fotografija/Face ID.
- [ ] Google Play: Data safety formular, Families policy (ako ciljaš decu — ne cilja), oglasi označeni, App Access instrukcije za review.
- [ ] Budžeti: Google Cloud budget alert, OpenAI usage limit, `AI_GLOBAL_MONTHLY_BUDGET_USD`.
- [ ] Monitoring: Crashlytics, Cloud Logging alarmi za `ai_global_budget_80_percent`, `revenuecat_webhook_failed`, `reminder_send_failed`.

## Okruženja
| | dev | staging | prod |
|---|---|---|---|
| Firebase projekat | myworldplus-dev | myworldplus-staging | myworldplus-prod |
| RevenueCat | sandbox | sandbox | production |
| AdMob | test ID | test ID | pravi ID |
| App Check | debug provider | debug/Play Integrity | Play Integrity / App Attest |
| Podaci | sintetički | sintetički | pravi — **nikad** u dev/staging |
