# Privatnost i regulativa

> Ovo nije pravni savet. Korišćenje Firebase-a ne znači automatsku usklađenost sa GDPR-om. Pre lansiranja u EU proveri sa pravnikom i popuni DPIA.

## Šta je tehnički urađeno
| Zahtev | Implementacija |
|---|---|
| Minimalno prikupljanje | Profil traži samo ime i jezik. Nema datuma rođenja, adrese, telefona. |
| Saglasnosti | Analitika isključena dok korisnik ne uključi; oglasi samo uz Google UMP saglasnost i samo u besplatnom paketu. |
| Pravo na pristup / prenosivost | „Izvezi podatke” → ZIP (JSON + originalni fajlovi; CSV u Pro paketima). |
| Pravo na brisanje | „Obriši nalog” — serverska funkcija briše zapise, fajlove, uređaje, budžete, pozivnice; AI usage i audit log se anonimizuju; Auth nalog se briše. |
| Kontrola pristupa | Pravila baze i Storage-a, App Check, ponovna prijava za brisanje. |
| Logovi | Bez sadržaja dokumenata, naslova, tekstova; samo ID-jevi i kodovi grešaka. |
| AI | Šalje se samo neophodno; `store: false` u OpenAI zahtevima; bez treniranja na korisničkim podacima. Proveri OpenAI DPA i zero-data-retention opcije za tvoj nalog. |
| Oglasi | Nikakvi podaci iz dokumenata ne idu u ad request (prazan `AdRequest`). Nema oglasa u Vault-u, skeneru, otpremanju, detaljima dokumenta, upozorenjima. Oglas preko celog ekrana samo posle čuvanja nečeg novog (nikad za Vault), ne u prvih 24 h, najviše 1 na 5 min i 3 dnevno. |
| Deca | Profili dece nisu nalozi; aplikacija nije namenjena deci kao korisnicima. |

## Zadržavanje podataka
| Podatak | Rok |
|---|---|
| Dokumenti u korpi | 30 dana, zatim trajno brisanje (`dailyHousekeeping`) |
| Izvozi (ZIP) | 7 dana |
| Neiskorišćene pozivnice | 7 dana, zatim `expired` |
| AI usage (anonimizovan posle brisanja naloga) | za obračun troškova; predlog: 13 meseci |
| Audit log | predlog: 24 meseca, anonimizovan posle brisanja naloga |
| Arhiva pretplata (anonimizovana) | koliko zahtevaju računovodstveni propisi |

## Podobrađivači (dopuni u politici privatnosti)
Google Cloud / Firebase (EU region), OpenAI (samo Pro paketi, samo na zahtev), RevenueCat (status pretplate), Google AdMob (samo Individual Base), Apple/Google (naplata, push).

## Procedura za incident
1. **Otkrivanje** — Cloud Logging alarm, prijava korisnika, Crashlytics anomalija.
2. **Zadržavanje (≤ 1 h)** — opozovi kompromitovane tajne (`functions:secrets:set` nova verzija), po potrebi privremeno postavi restriktivna pravila (`allow read, write: if false` za pogođene kolekcije), isključi pogođene funkcije.
3. **Procena (≤ 24 h)** — obim, kategorije podataka, broj korisnika; sačuvaj logove.
4. **Obaveštavanje** — nadzorni organ u roku od **72 h** (GDPR čl. 33), korisnici bez odlaganja ako je visok rizik (čl. 34). Za Srbiju: Poverenik za informacije od javnog značaja i zaštitu podataka o ličnosti (ZZPL).
5. **Oporavak** — ispravka, rotacija ključeva, restore iz backup-a ako treba.
6. **Post-mortem** — uzrok, mere, ažuriranje testova pravila.
