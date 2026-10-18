# Bezbednost

## Principi (implementirano)
- **Podrazumevano odbij.** Svaka kolekcija je eksplicitno navedena u `firestore.rules`; sve ostalo je zabranjeno. Storage ima catch-all `deny`.
- **Server je autoritet** za plan, članstvo, uloge, pozivnice, kvote, AI rezultate i audit log — klijent te kolekcije ne može da piše.
- **Uloga ≠ pristup dokumentima.** Owner/admin upravljaju porodicom, ali ne vide tuđe privatne zapise.
- **Uklonjen član odmah gubi pristup**: svaka provera zahteva `members/{uid}.status == 'active'`.
- **Fajl se ne može preuzeti po ID-ju ili putanji**: Storage pravila čitaju Firestore zapis dokumenta i primenjuju istu privatnost.
- **Vlasnik je nepromenljiv**, `storagePath` i `createdAt` takođe.
- **Kvote se proveravaju u pravilima** (broj dokumenata, prostor) iz serverskih `usage`/`entitlements` dokumenata.
- **Admin SDK zaobilazi pravila**, zato serverske funkcije (AI, izvoz) prolaze kroz `lib/access.ts` (`canRead`) — ogledalo pravila.
- **App Check** je obavezan za callable funkcije u produkciji (`enforceAppCheck`).
- **Ponovna prijava** (≤ 10 min) je obavezna za brisanje naloga.

## Bezbednosni testovi (emulator)

`rules-tests/firestore.test.js`, `storage.test.js`, `functions.int.test.js` — scenariji iz specifikacije:

| # | Scenario | Test |
|---|---|---|
| 1 | Korisnik A otvara dokument korisnika B | ✅ odbijeno |
| 2 | Član porodice otvara privatni dokument drugog člana | ✅ odbijeno |
| 3 | Lokalna promena plana na Family Pro | ✅ odbijeno (pravila + `createFamily` vraća `permission-denied`) |
| 4 | AI endpoint bez AI prava | ✅ `aiAsk` i `extractDocument` → `permission-denied` |
| 5 | Uklonjen član pokušava ponovni pristup | ✅ odbijeno (pravila + integracioni tok) |
| 6 | Istekla / iskorišćena pozivnica | ✅ odbijeno |
| 7 | Nedozvoljen tip fajla | ✅ odbijeno (pravila) + server briše fajl sa pogrešnim magic bytes |
| 8 | Preuzimanje fajla sa tuđim ID-jem | ✅ odbijeno |
| 9 | Promena vlasnika dokumenta | ✅ odbijeno |
| 10 | AI pitanje pokušava da izvuče tuđe privatne podatke | ✅ podaci se filtriraju **pre** modela; izvori van dozvoljenog skupa se odbacuju (`validateAnswer`, unit test) |
| 11 | Otkazana pretplata, klijent i dalje prikazuje Pro | ✅ `isEntitled` po isteku perioda; `requireAi` uvek ponovo računa entitlement |
| 12 | Promena serverskih entitlement podataka | ✅ odbijeno |

Dodatno: lažna AI statusna polja, nepoznata polja, tuđa porodica, prepisivanje fajla, kvote, falsifikovanje `lastSentKey` podsetnika, audit/AI usage nedostupni klijentu.

## Prompt injection
- Sadržaj dokumenta se šalje u `<document>` bloku uz sistemsko uputstvo da je to nepouzdan podatak.
- Model **nema alate**; može samo da vrati JSON po šemi.
- Šema ima polje `containsInstructions`; ako je `true`, korisnik vidi upozorenje na ekranu za proveru.
- Sve promene podataka radi korisnik kroz UI, nikad model.

## Vault
PIN (iterirani SHA-256 sa nasumičnim salt-om, `flutter_secure_storage`) i biometrija štite **otvaranje ekrana** na uređaju. To nije end-to-end enkripcija i tako je i opisano korisniku. Posle 5 pogrešnih PIN-ova zahteva se nova prijava. Vault dokumenti se ne koriste u AI pitanjima i ne prikazuju se u globalnoj pretrazi dok je Vault zaključan.

## Privatnost na uređaju
- Skenovi i izabrane slike se drže u memoriji; privremeni fajlovi se odmah brišu, keš skenera se čisti.
- Android: `setRecentsScreenshotEnabled(false)`, isključen backup (`allowBackup=false`, `data_extraction_rules`).
- iOS i Android: `PrivacyCover` prekriva sadržaj kada aplikacija nije aktivna.
- Obaveštenja su podrazumevano generička (bez naziva).
- Crashlytics ne dobija sadržaj; analitika je isključena dok korisnik ne pristane.

## End-to-end enkripcija (namerno nije implementirana u v1)
Spec traži da se E2EE ne predstavlja lažno. Pravilna E2EE zahteva upravljanje ključevima, oporavak, deljenje u porodici, promenu uređaja i opoziv — i isključuje serversku AI obradu tih fajlova. Predlog za v2: opcioni „Zaključani dokumenti” sa ključem po dokumentu, umotanim javnim ključevima članova (X25519) i recovery ključem koji korisnik čuva; takvi dokumenti su eksplicitno isključeni iz AI.
