# Status implementacije

Stanje na dan isporuke ove verzije. Ništa ovde nije prikazano kao urađeno ako nije stvarno urađeno i provereno.

## Provereno u ovom okruženju

| Provera | Rezultat |
|---|---|
| `flutter analyze` | 0 problema |
| `flutter test` | 32/32 (pretraga, filteri, sortiranje, troškovi, validacija fajlova, iznosi, privatnost, podsetnici, modeli, kontrast boja WCAG AA, lokalizacija sr/en sa množinom, tekst 200 %, semantika, dodirne površine) |
| `functions` — `tsc` + `vitest` | 36/36 (entitlement logika, RevenueCat parsiranje, pristup, vremenske zone/DST, magic bytes, AI validacija, AI katalog, cene) |
| Pravila Firestore/Storage (emulator) | 37/37 |
| Integracija funkcija (Auth+Firestore+Storage+Functions emulator) | 10/10 (bootstrap, AI bez prava, lažni plan, kreiranje porodice, pozivnice, pogrešan/istekao/ponovljen token, uklanjanje člana, brisanje naloga) |

## Implementirano, ali NIJE izvršeno ovde (zahteva tvoje naloge / uređaj)

| Šta | Zašto nije pokrenuto | Šta treba |
|---|---|---|
| Android/iOS nativni build | Mreža okruženja blokira `dl.google.com` (Google Maven); iOS build zahteva macOS + Xcode | `flutter build apk` / `flutter build ios` na svojoj mašini ili u CI; verzije Gradle pluginova (`google-services 4.4.4`, `crashlytics 3.0.6`) proveri pri prvom build-u |
| Pravi AI pozivi (OpenAI) | Nema API ključa | `OPENAI_API_KEY` u Secret Manager; proveri imena modela za tvoj nalog |
| Prava naplata | Nema RevenueCat/App Store/Play naloga | Vidi `CONFIGURATION.md` §5, sandbox testovi iz release checklist-a |
| Push notifikacije | Nema APNs/FCM konfiguracije | APNs key, test na uređaju |
| Skener kamere, biometrija, barkod skener, AdMob | Potreban fizički uređaj | Ručni test na Android i iOS uređaju |

## Poznata ograničenja i sledeći koraci
1. **Pretraga** radi lokalno nad ovlašćenim podacima. Za > ~20 000 dokumenata po korisniku uvesti Typesense/Algolia sa per-user scoped ključevima.
2. **Semantička pretraga** = AI pitanje sa leksičkim predfilterom (40 najrelevantnijih zapisa) + determinističke sume troškova. Vektorski embeddings nisu uvedeni.
3. **Kvota prostora** — u retkim slučajevima istovremenih otpremanja moguće je malo prekoračenje (pravila čitaju brojač pre upisa). Fotografije porodičnih profila se ne računaju u kvotu.
4. **Otpremanje** se ne nastavlja posle gašenja aplikacije; korisnik ponavlja (ekran nudi „Pokušaj ponovo”).
5. **E2EE** nije implementirana (namerno, vidi `SECURITY.md`). Vault PIN je zaštita ekrana, tako i opisano.
6. **E-mail obaveštenja** nisu implementirana; UI to jasno kaže.
7. **Ćirilica**: struktura je spremna (dodati `app_sr_Cyrl.arb`, `Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Cyrl')`); prevod nije napravljen.
8. **Izvoz** se preuzima u memoriju (do 500 MB); za veće arhive predlog je kratkotrajni signed URL ili deljenje u delovima.
9. **Lokalne notifikacije**: najviše 50 zakazanih (iOS limit 64); push sa servera nema to ograničenje.
10. **Detekcija duplikata** samo za identičan fajl (SHA-256).
11. **UI testovi na uređaju** (`integration_test`) nisu napisani — postoje widget testovi.
12. **Remote Config** nije uveden; limiti se menjaju u `functions/src/plans.ts` i deploy-uju.
13. Vlasnik porodice sa drugim članovima **ne može** da obriše nalog dok ih ne ukloni (namerno — bez tihog gubitka tuđih podataka). Prenos vlasništva nije implementiran.
14. Ikonica aplikacije i splash grafika su podrazumevane Flutter — potreban je finalni brending.
