# Data model

Svi datumi su Firestore `Timestamp`; u Dart domenu `DateTime`. Valuta je uvek posebno polje (ISO 4217), nikad izvedena iz jezika.

## Zajednička polja privatnosti
Kolekcije `documents`, `assets`, `vehicles`, `vehicleRecords`, `reminders`, `walletCards`, `businessCards`:

| Polje | Opis |
|---|---|
| `ownerUid` | Vlasnik. Nepromenljivo posle kreiranja. |
| `familyId` | Porodica u kojoj se deli (ili `null`). |
| `privacyLevel` | `private` (samo vlasnik) · `shared` (izabrani članovi) · `family` (svi aktivni članovi). |
| `sharedWith` | UID-ovi za `shared`. Samo po sebi **nije** dovoljno — pravila zahtevaju i aktivno članstvo. |

## Kolekcije

| Putanja | Ko piše | Sadržaj |
|---|---|---|
| `users/{uid}` | klijent (ograničena polja) + server (`activeFamilyId`, `accountStatus`) | `displayName`, `email`, `photoUrl`, `preferredLanguage`, `region`, `onboardingCompleted`, `notificationPreview` (`generic`/`detailed`). |
| `users/{uid}/devices/{fid}` | klijent | FCM Firebase Installation ID, platforma, jezik. |
| `entitlements/{uid}` | **samo server** | `planId`, `ownPlanId`, `status`, `source`, `aiEnabled`, `adsEnabled`, `storageLimitBytes`, `maxDocuments`, `maxFamilyMembers`, `maxVehicles`, `advancedExport`, `advancedFilters`, `aiMonthlyRequests`, `canCreateFamily`, `canInviteMembers`, `familyId`, `usageKey`, `currentPeriodEnd`. |
| `subscriptions/{uid}` | **samo server** | `ownerUid`, `planId`, `platform`, `provider`, `providerPurchaseId`, `status`, `currentPeriodStart/End`, `gracePeriodEnd`, `cancelAtPeriodEnd`. |
| `usage/{uid ili familyId}` | **samo server** | `activeDocumentCount`, `storageUsedBytes` (porodični paketi dele jedan pool). |
| `families/{fid}` | **samo server** | `name`, `ownerUid`, `planOwnerUid`, `memberCount`, `status`. |
| `families/{fid}/members/{uid}` | **samo server** | `role` (`owner`/`admin`/`member`), `status` (`active`/`removed`/`left`), `joinedAt`, `invitedBy`, `permissions`. |
| `families/{fid}/profiles/{pid}` | owner/admin | Profili bez naloga (npr. deca): `name`, `relationship`, `isMinor`, `photoStoragePath`. |
| `familyInvitations/{id}` | **samo server** | `familyId`, `invitedBy`, `targetEmail`, `tokenHash` (SHA-256), `status`, `failedAttempts`, `expiresAt`, `acceptedAt`. |
| `documents/{id}` | vlasnik | `title`, `description`, `categoryId`, `subCategoryId`, `tags`, `fileType`, `mimeType`, `storagePath`, `fileSizeBytes`, `pageCount`, `documentDate`, `purchaseDate`, `vendor`, `amount`, `currency`, `warrantyExpiryDate`, `expiryDate`, `linkedEntityIds`, `processingStatus` (`draft/uploading/uploaded/processing/needs_review/ready/failed`), `isFavorite`, `isVault`, `notes`, `contentHash`, `searchText`, `deletedAt` (korpa). |
| `documentExtractions/{documentId}` | **samo server** | `provider`, `model`, `schemaVersion`, `extractedFields`, `confidence`, `needsReview`, `fieldsNeedingReview`, `warnings`. |
| `assets/{id}` | vlasnik | `area` (`home`/`hobby`/`life`), `name`, `category`, `brand`, `model`, `serialNumber`, `purchaseDate`, `purchasePrice`, `currency`, `vendor`, `warrantyExpiryDate`, `location`, `status`, `assignedProfileIds`, `photoStoragePath`, `notes`. |
| `vehicles/{id}` | vlasnik | `make`, `model`, `year`, `registrationNumber`, `vin`, `purchaseDate`, `purchasePrice`, `currency`, `currentMileage`, `fuelType`, `photoStoragePath`, `notes`. |
| `vehicleRecords/{id}` | vlasnik vozila | `vehicleId`, `recordType`, `date`, `mileage`, `description`, `amount`, `currency`, `vendor`, `documentIds`, `nextDueDate`, `nextDueMileage`. |
| `reminders/{id}` | vlasnik (+ server: `lastSentKey`, `lastSentAt`, pomeranje `dueAt` za ponavljanja) | `title`, `description`, `dueAt`, `timezone` (IANA), `repeatRule`, `notificationChannels`, `linkedEntityId/Type`, `linkedDocumentId`, `status`, `kind`, `leadTimeMinutes`, `nextNotifyAt`. |
| `walletCards/{id}` | vlasnik | **My Cards**: `kind` (`loyalty/discount/coupon/gift/membership/other`), `name`, `issuer`, `cardNumber`, `barcodeValue`, `barcodeFormat`, `discountText`, `balance`, `currency`, `validFrom`, `expiryDate`, `frontPhotoPath`, `backPhotoPath`, `color`, `isFavorite`, `usedAt`. |
| `businessCards/{id}` | vlasnik | **My Business Cards**: `fullName`, `company`, `jobTitle`, `phones[]`, `emails[]`, `website`, `address`, `socialLinks[]`, `frontPhotoPath`, `backPhotoPath`, `notes`, `tags`, `metAt`, `metWhere`, `isFavorite`. |
| `categories/{id}` | vlasnik | Korisničke kategorije i podkategorije (`area`, `parentId`). |
| `aiUsage/{id}` | **samo server** | `uid`, `planId`, `task`, `model`, `inputTokens`, `outputTokens`, `estimatedCostUsd`, `status`, `errorCode` — bez sadržaja. |
| `aiBudgets/{uid_yyyymm}` / `family_{fid}_yyyymm` | **samo server** | brojači zahteva i troška. |
| `aiGlobal/{yyyymm}` | **samo server** | globalni mesečni trošak (nedostupno klijentu). |
| `auditLogs/{id}` | **samo server** | kritične radnje (deljenje, članstvo, brisanje, pretplata) — samo ID-jevi. |
| `exports/{id}` | **samo server** | status izvoza i putanja ZIP-a. |

## Storage

| Putanja | Pristup |
|---|---|
| `users/{uid}/documents/{docId}/{file}` | čitanje prema Firestore zapisu dokumenta (privatnost); upis samo vlasnik, tačna deklarisana putanja, PDF/JPEG/PNG/HEIC ≤ 25 MB, u okviru kvote; bez prepisivanja i brisanja sa klijenta. |
| `users/{uid}/photos/{entityId}/{file}` | fotografije predmeta, vozila, kartica, vizit karata — čitanje prema zapisu entiteta. |
| `families/{fid}/profiles/{pid}/{file}` | fotografije profila — aktivni članovi čitaju, owner/admin pišu. |
| `exports/{uid}/{file}` | samo vlasnik čita; piše server. |

## Pretraga
Pretraga radi lokalno nad podacima koje je korisnik već ovlašćen da vidi (Firestore keš). Ne postoji zajednički indeks koji bi mogao da otkrije tuđe naslove. Za vrlo velike arhive (desetine hiljada dokumenata) preporuka je Typesense/Algolia sa **per-user scoped** ključevima koje izdaje Cloud Function — vidi `docs/STATUS.md`.
