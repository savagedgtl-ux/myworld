# Mapa ekrana

Svi ekrani su stvarni, povezani sa Firestore/Storage/Functions. Kolona „Fajl” je u `app/lib/features/`.

| # | Ekran | Ruta | Fajl |
|---|---|---|---|
| **A** | | | |
| 1 | Splash | `/splash` | `auth/auth_screens.dart` |
| 2 | Onboarding (3 ekrana, preskakanje) | `/onboarding` | `auth/auth_screens.dart` |
| 3 | Registracija | `/auth/sign-up` | `auth/auth_screens.dart` |
| 4 | Prijava (e-mail, Google, Apple) | `/auth/sign-in` | `auth/auth_screens.dart` |
| 5 | Resetovanje lozinke | `/auth/reset` | `auth/auth_screens.dart` |
| 6 | Potvrda e-maila | `/auth/verify` | `auth/auth_screens.dart` |
| — | Kreiranje profila | `/profile-setup` | `auth/auth_screens.dart` |
| 7 | Home | `/home` | `home/home_screen.dart` |
| 8 | My World | `/world` | `world/world_screen.dart` |
| 9 | Global Search | `/search` | `search/search_screen.dart` |
| 10 | Add Action Sheet (kontekstualan) | dugme „Dodaj” | `add/add_sheet.dart` |
| 11 | Notifications | `/notifications` | `settings/settings_screens.dart` |
| 12 | Profile | `/profile` | `settings/settings_screens.dart` |
| 13 | Settings | `/settings` | `settings/settings_screens.dart` |
| **B** | | | |
| 14 | My Documents | `/documents` | `documents/document_screens.dart` |
| 15 | Document Categories (+ korisničke) | `/documents` | `documents/document_screens.dart` |
| 16 | Document List (filteri, sort, grupisanje, grid/lista) | `/documents/list` | `documents/document_screens.dart` |
| 17 | Document Detail | `/documents/:id` | `documents/document_screens.dart` |
| 18 | Document Preview (PDF / zoom slike) | `/documents/:id/preview` | `documents/document_screens.dart` |
| 19 | Scan Document | `/scan?mode=scan` | `scanner/scan_screens.dart` |
| 20 | Scan Review (rotacija, ponovo, brisanje, redosled, + strana) | `/scan` (korak) | `scanner/scan_screens.dart` |
| 21 | Upload File (PDF / slike / foto) | `/scan?mode=pdf|image|photo` | `scanner/scan_screens.dart` |
| 22 | Edit Document | `/documents/:id/edit` | `documents/document_screens.dart` |
| 23 | Document Sharing | `/documents/:id/sharing` | `documents/document_screens.dart` |
| — | Veze dokumenta | `/documents/:id/links` | `documents/document_screens.dart` |
| 24 | Favorites | `/documents/list?favorites=1` | `documents/document_screens.dart` |
| 25 | Recently Added | `/documents/recent` | `documents/document_screens.dart` |
| — | Korpa | `/documents/list?trash=1` | `documents/document_screens.dart` |
| 26 | Storage Usage | `/storage` | `documents/document_screens.dart` |
| **C** | | | |
| 27–28 | My Home Dashboard + kategorije | `/home-area` | `assets/asset_screens.dart` |
| 29 | Asset List | `/assets/list?area=home` | `assets/asset_screens.dart` |
| 30 | Asset Detail | `/assets/:id` | `assets/asset_screens.dart` |
| 31–32 | Add / Edit Asset | `/assets/new`, `/assets/:id/edit` | `assets/asset_screens.dart` |
| 33 | Warranty Detail | `/assets/:id/warranty` | `assets/asset_screens.dart` |
| 34 | Maintenance History | `/assets/:id/maintenance` | `assets/asset_screens.dart` |
| **D** | | | |
| 35 | Family Dashboard (kreiranje porodice) | `/family` | `family/family_screens.dart` |
| 36 | Family Member List | `/family/members` | `family/family_screens.dart` |
| 37 | Member Profile / profil domaćinstva | `/family/member/:uid`, `/family/profile/:id` | `family/family_screens.dart` |
| 38 | Add Member (profil bez naloga) | `/family/profile/new` | `family/family_screens.dart` |
| 39 | Invite Member | `/family/invite` | `family/family_screens.dart` |
| 40 | Invitation Acceptance | `/invite?i=&t=` | `family/family_screens.dart` |
| 41 | Family Permissions | `/family/permissions` | `family/family_screens.dart` |
| 42 | Shared Documents | `/family/shared` | `family/family_screens.dart` |
| 43 | Family Settings | `/family/settings` | `family/family_screens.dart` |
| 44 | Leave Family | `/family/leave` | `family/family_screens.dart` |
| 45 | Remove Member | `/family/remove/:uid` | `family/family_screens.dart` |
| **E** | | | |
| 46–47 | Hobby Dashboard + kategorije | `/hobby` | `assets/asset_screens.dart` |
| 48 | Hobby Item Detail | `/assets/:id` | `assets/asset_screens.dart` |
| 49–50 | Add / Edit Hobby Item | `/assets/new?area=hobby` | `assets/asset_screens.dart` |
| **F** | | | |
| 51 | Vehicles Dashboard | `/car` | `vehicles/vehicle_screens.dart` |
| 52 | Vehicle Detail | `/vehicles/:id` | `vehicles/vehicle_screens.dart` |
| 53–54 | Add / Edit Vehicle | `/vehicles/new`, `/vehicles/:id/edit` | `vehicles/vehicle_screens.dart` |
| 55 | Vehicle Records | `/vehicles/:id/records` | `vehicles/vehicle_screens.dart` |
| 56 | Add Service Record (+ sken računa) | `/vehicles/:id/records/new` | `vehicles/vehicle_screens.dart` |
| 57 | Expense Overview (po valuti, mesečni graf, po kategoriji) | `/vehicles/:id/expenses` | `vehicles/vehicle_screens.dart` |
| 58 | Registration and Insurance | `/vehicles/:id/registration` | `vehicles/vehicle_screens.dart` |
| 59 | Mileage History | `/vehicles/:id/mileage` | `vehicles/vehicle_screens.dart` |
| **G** | | | |
| 60 | Reminders Dashboard / My Life | `/reminders`, `/life` | `reminders/reminder_screens.dart` |
| 61 | Reminder Detail | `/reminders/:id` | `reminders/reminder_screens.dart` |
| 62–63 | Create / Edit Reminder | `/reminders/new`, `/reminders/:id/edit` | `reminders/reminder_screens.dart` |
| 64 | Reminder Settings | `/settings/reminders` | `reminders/reminder_screens.dart` |
| 65 | Upcoming Deadlines | `/reminders/upcoming` | `reminders/reminder_screens.dart` |
| **H** | | | |
| 66–67 | AI Search / Question | `/ai` | `ai/ai_screens.dart` |
| 68 | AI Answer with Sources | `/ai` (kartica) | `ai/ai_screens.dart` |
| 69 | Extraction Review | `/documents/:id/review` | `ai/extraction_review_screen.dart` |
| 70 | AI Usage and Limits | `/ai/usage` | `ai/ai_screens.dart` |
| 71 | AI Upgrade Prompt | `/ai/upgrade` | `ai/ai_screens.dart` |
| **I** | | | |
| 72 | Plans and Pricing | `/plans` | `subscriptions/subscription_screens.dart` |
| 73 | Store Purchase Flow | `/plans` → RevenueCat | `subscriptions/subscription_screens.dart` |
| 74 | Manage Subscription | `/subscription` | `subscriptions/subscription_screens.dart` |
| 75 | Restore Purchases | `/plans` | `subscriptions/subscription_screens.dart` |
| 76 | Upgrade Prompt | sheet / kartica | `core/widgets/monetization.dart` |
| 77 | Ad Consent | `/settings/privacy` (Google UMP) | `settings/settings_screens.dart` |
| 78 | Ad Placement | `AdSlot` (samo Home) | `core/widgets/monetization.dart` |
| **J** | | | |
| 79 | Vault | `/vault` | `vault/vault_screens.dart` |
| 80 | Vault Settings | `/settings/vault` | `vault/vault_screens.dart` |
| 81 | Biometric Lock | `/vault` (zaključan) | `vault/vault_screens.dart` |
| 82 | Privacy Settings | `/settings/privacy` | `settings/settings_screens.dart` |
| 83 | Export Data | `/settings/export` | `settings/settings_screens.dart` |
| 84 | Delete Account | `/settings/delete-account` | `settings/settings_screens.dart` |
| 85 | Legal Documents | `/settings/legal` | `settings/settings_screens.dart` |
| 86 | Help and Support | `/settings/help` | `settings/settings_screens.dart` |
| **K** | | | |
| 87 | Offline State | baner u shell-u | `app/connectivity.dart` |
| 88 | Upload Error (ponovni pokušaj) | `/scan` (korak) | `scanner/scan_screens.dart` |
| 89 | AI Error | `AiErrorCard` | `ai/ai_screens.dart` |
| 90–91 | Empty / Loading States | `EmptyState`, `LoadingState`, `ListSkeleton` | `core/widgets/states.dart` |
| 92 | Permission Denied | `ErrorState` | `core/widgets/states.dart` |
| 93 | Session Expired | `/session-expired` | `settings/settings_screens.dart` |
| 94 | Subscription Expired / billing issue | `/subscription`, obaveštenja | `subscriptions/subscription_screens.dart` |
| 95 | Storage Limit Reached | `/storage`, greška otpremanja | `documents/document_screens.dart` |
| 96 | Generic Error Recovery | ruter `errorBuilder` | `settings/settings_screens.dart` |
| **Novo** | | | |
| — | My Cards (lojalnost, popusti, kuponi, poklon, članske) | `/cards`, `/cards/:id`, `/cards/new` | `cards/card_screens.dart` |
| — | Skener barkoda / QR | iz forme kartice | `cards/card_screens.dart` |
| — | My Business Cards (tuđe vizit karte, AI čitanje u Pro) | `/business-cards`, `/business-cards/:id`, `/business-cards/new` | `business_cards/business_card_screens.dart` |
