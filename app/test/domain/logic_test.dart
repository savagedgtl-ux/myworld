import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:myworld_plus/domain/logic/costs.dart';
import 'package:myworld_plus/domain/logic/reminders.dart';
import 'package:myworld_plus/domain/logic/search.dart';
import 'package:myworld_plus/domain/logic/validation.dart';
import 'package:myworld_plus/domain/models/account.dart';
import 'package:myworld_plus/domain/models/common.dart';
import 'package:myworld_plus/domain/models/document.dart';
import 'package:myworld_plus/domain/models/entities.dart';
import 'package:myworld_plus/domain/plans.dart';

DocumentRecord doc(String id, {String title = 'Dokument', String? cat, DateTime? date, double? amount, bool fav = false, bool vault = false, DateTime? warranty, DateTime? deleted, List<String> tags = const [], String? vendor}) =>
    DocumentRecord(
      id: id, ownerUid: 'u', title: title, storagePath: 'users/u/documents/$id/document.pdf', mimeType: 'application/pdf',
      categoryId: cat, documentDate: date, amount: amount, isFavorite: fav, isVault: vault, warrantyExpiryDate: warranty,
      deletedAt: deleted, tags: tags, vendor: vendor, createdAt: date,
    );

void main() {
  group('search', () {
    final docs = [
      doc('1', title: 'Račun za veš mašinu', cat: 'receipts', date: DateTime(2025, 12, 12), amount: 549, vendor: 'Gigatron', warranty: DateTime(2027, 12, 12)),
      doc('2', title: 'Ugovor o zakupu stana', cat: 'contracts', date: DateTime(2026, 2, 1)),
      doc('3', title: 'Laptop', cat: 'receipts', date: DateTime(2025, 3, 3), amount: 1200, fav: true, tags: ['posao']),
      doc('4', title: 'Pasoš', cat: 'personal', vault: true, date: DateTime(2024, 1, 1)),
      doc('5', title: 'Stari račun', deleted: DateTime(2026, 1, 1), date: DateTime(2026, 1, 1)),
    ];

    test('diacritic-insensitive text search', () {
      expect(normalizeText('Račun ŠĐŽ ćirilica Ђорђе'), 'racun sdjz cirilica djordje');
      final r = applyDocumentFilter(docs, const DocumentFilter(query: 'ves masina'));
      expect(r.map((d) => d.id), ['1']);
    });

    test('vendor, tags and amount are searchable', () {
      expect(applyDocumentFilter(docs, const DocumentFilter(query: 'gigatron')).single.id, '1');
      expect(applyDocumentFilter(docs, const DocumentFilter(query: 'posao')).single.id, '3');
    });

    test('trash never appears, vault excluded on request', () {
      final all = applyDocumentFilter(docs, const DocumentFilter());
      expect(all.any((d) => d.id == '5'), isFalse);
      expect(applyDocumentFilter(docs, const DocumentFilter(includeVault: false)).any((d) => d.isVault), isFalse);
      expect(applyDocumentFilter(docs, const DocumentFilter(vaultOnly: true)).single.id, '4');
    });

    test('filters: category, favourites, warranty, date range', () {
      expect(applyDocumentFilter(docs, const DocumentFilter(categoryIds: {'receipts'})).length, 2);
      expect(applyDocumentFilter(docs, const DocumentFilter(favoritesOnly: true)).single.id, '3');
      expect(applyDocumentFilter(docs, const DocumentFilter(withWarrantyOnly: true)).single.id, '1');
      final r = applyDocumentFilter(docs, const DocumentFilter(range: DateRange.lastYear), now: DateTime(2026, 6, 1));
      expect(r.map((d) => d.id).toSet(), {'1', '3'});
    });

    test('sorting', () {
      expect(applyDocumentFilter(docs, const DocumentFilter(sort: DocSort.amountDesc)).first.id, '3');
      expect(applyDocumentFilter(docs, const DocumentFilter(sort: DocSort.nameAsc)).first.title, 'Laptop');
      expect(applyDocumentFilter(docs, const DocumentFilter(sort: DocSort.newest)).first.id, '2');
      expect(applyDocumentFilter(docs, const DocumentFilter(sort: DocSort.expiry)).first.id, '1');
    });

    test('extra text (linked person names) participates', () {
      final r = applyDocumentFilter(docs, const DocumentFilter(query: 'mila'), extraText: {'2': 'Mila'});
      expect(r.single.id, '2');
    });
  });

  group('costs', () {
    final recs = [
      VehicleRecord(id: 'a', vehicleId: 'v', ownerUid: 'u', type: VehicleRecordType.service, date: DateTime(2026, 3, 1), amount: 120, currency: 'EUR', mileage: 100000),
      VehicleRecord(id: 'b', vehicleId: 'v', ownerUid: 'u', type: VehicleRecordType.tires, date: DateTime(2026, 4, 1), amount: 300, currency: 'EUR', mileage: 101500),
      VehicleRecord(id: 'c', vehicleId: 'v', ownerUid: 'u', type: VehicleRecordType.registration, date: DateTime(2025, 5, 1), amount: 25000, currency: 'RSD', nextDueDate: DateTime(2026, 5, 1)),
    ];
    test('totals per currency, never mixed', () {
      final s = summarizeCosts(recs, now: DateTime(2026, 6, 1));
      expect(s.totalByCurrency, {'EUR': 420, 'RSD': 25000});
      expect(s.thisYearByCurrency, {'EUR': 420});
      expect(s.byType[VehicleRecordType.tires], {'EUR': 300});
      expect(s.lastMileage, 101500);
    });
    test('monthly buckets', () {
      final m = monthlyTotals(recs, 'EUR', now: DateTime(2026, 6, 15), months: 6);
      expect(m.length, 6);
      expect(m.firstWhere((e) => e.month == DateTime(2026, 4)).amount, 300);
    });
    test('upcoming deadlines only from entered dates', () {
      expect(upcomingDeadlines(recs, now: DateTime(2026, 4, 1)).single.id, 'c');
      expect(upcomingDeadlines(recs, now: DateTime(2026, 6, 1)), isEmpty);
    });
  });

  group('validation', () {
    test('magic bytes, not extensions', () {
      expect(sniffMime(Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2d, 0x31])), 'application/pdf');
      expect(sniffMime(Uint8List.fromList([0xff, 0xd8, 0xff, 0xe0])), 'image/jpeg');
      expect(sniffMime(Uint8List.fromList([0x4d, 0x5a, 0x90, 0x00])), isNull);
      expect(validateUpload(Uint8List(0)), isA<FileRejected>());
      final exe = validateUpload(Uint8List.fromList([0x4d, 0x5a, 0x90, 0x00, 1, 2, 3]));
      expect((exe as FileRejected).reason, 'unsupported_type');
      expect(validateUpload(Uint8List(UploadLimits.maxBytes + 1)..setAll(0, [0x25, 0x50, 0x44, 0x46, 0x2d])), isA<FileRejected>());
    });
    test('amount parsing for both decimal styles', () {
      expect(parseAmount('1.234,56'), 1234.56);
      expect(parseAmount('1,234.56'), 1234.56);
      expect(parseAmount('549,99 €'), 549.99);
      expect(parseAmount('abc'), isNull);
      expect(parseAmount('-5'), isNull);
    });
    test('password, email, VIN, currency', () {
      expect(validatePassword('short1'), 'too_short');
      expect(validatePassword('longpassword'), 'weak');
      expect(validatePassword('longpass123'), isNull);
      expect(isValidEmail('ana@primer.rs'), isTrue);
      expect(isValidEmail('ana@'), isFalse);
      expect(isValidVin('WVWZZZ1JZXW000001'), isTrue);
      expect(isValidVin('WVWZZZ1JZXW00000O'), isFalse);
      expect(isValidCurrency('EUR'), isTrue);
      expect(isValidCurrency('eur'), isFalse);
    });
    test('privacy validation mirrors rules', () {
      expect(Privacy.private.validate(), isNull);
      expect(const Privacy(level: PrivacyLevel.family).validate(), 'privacy_needs_family');
      expect(const Privacy(level: PrivacyLevel.shared, familyId: 'f').validate(), 'privacy_needs_people');
      expect(const Privacy(level: PrivacyLevel.shared, familyId: 'f', sharedWith: ['b']).validate(), isNull);
      expect(const Privacy(level: PrivacyLevel.private, sharedWith: ['x']).toMap()['sharedWith'], isEmpty);
    });
  });

  group('reminders', () {
    test('next local occurrence keeps wall time and clamps month ends', () {
      final due = DateTime(2026, 1, 31, 9);
      expect(nextLocalOccurrence(due, RepeatRule.monthly, DateTime(2026, 2, 1)), DateTime(2026, 2, 28, 9));
      expect(nextLocalOccurrence(due, RepeatRule.yearly, DateTime(2026, 2, 1)), DateTime(2027, 1, 31, 9));
      expect(nextLocalOccurrence(due, RepeatRule.none, DateTime(2026, 2, 1)), isNull);
      expect(nextLocalOccurrence(DateTime(2026, 3, 1, 8), RepeatRule.weekly, DateTime(2026, 3, 2)), DateTime(2026, 3, 8, 8));
    });
    test('top upcoming: overdue first, max 3', () {
      final now = DateTime(2026, 6, 10);
      Reminder r(String id, DateTime d, [ReminderStatus s = ReminderStatus.active]) => Reminder(id: id, ownerUid: 'u', title: id, dueAt: d, timezone: 'UTC', status: s);
      final list = [r('later', DateTime(2026, 9, 1)), r('soon', DateTime(2026, 6, 12)), r('over', DateTime(2026, 6, 1)), r('done', DateTime(2026, 6, 11), ReminderStatus.done), r('x', DateTime(2026, 7, 1))];
      expect(topUpcoming(list, now: now).map((e) => e.id), ['over', 'soon', 'x']);
      expect(dueState(DateTime(2026, 6, 10, 23), now: now), DueState.today);
      expect(dueState(DateTime(2026, 6, 9), now: now), DueState.overdue);
    });
    test('notification id is stable and positive', () {
      expect(localNotificationId('abc'), localNotificationId('abc'));
      expect(localNotificationId('some-long-id-123') >= 0, isTrue);
    });
    test('nextNotifyAt honours lead time; inactive has none', () {
      final r = Reminder(id: 'r', ownerUid: 'u', title: 't', dueAt: DateTime(2026, 5, 1, 9), timezone: 'Europe/Belgrade', leadTimeMinutes: 1440);
      expect(r.toMap()['nextNotifyAt'], DateTime(2026, 4, 30, 9));
      expect(r.copyWith(status: ReminderStatus.done).toMap()['nextNotifyAt'], isNull);
    });
  });

  group('models', () {
    test('document round-trip and wire status', () {
      final d = doc('1', title: 'X', amount: 10, date: DateTime(2026, 1, 1)).copyWith(processingStatus: ProcessingStatus.needsReview, tags: ['a']);
      final m = d.toMap();
      expect(m['processingStatus'], 'needs_review');
      expect(m.containsKey('createdAt'), isFalse, reason: 'createdAt is immutable and written only on create');
      final back = DocumentRecord.fromMap('1', m);
      expect(back.processingStatus, ProcessingStatus.needsReview);
      expect(back.amount, 10);
      expect(back.tags, ['a']);
    });
    test('wallet card expiry & barcode', () {
      final c = WalletCard.fromMap('c', {'ownerUid': 'u', 'kind': 'coupon', 'name': 'Maxi', 'barcodeFormat': 'ean13', 'expiryDate': DateTime(2026, 1, 1)});
      expect(c.kind, WalletCardKind.coupon);
      expect(c.barcodeFormat, BarcodeKind.ean13);
      expect(c.isExpired(DateTime(2026, 1, 2)), isTrue);
      expect(c.isExpired(DateTime(2026, 1, 1)), isFalse);
    });
    test('business card display name falls back to company', () {
      expect(BusinessCard.fromMap('b', {'ownerUid': 'u', 'company': 'ACME'}).displayName, 'ACME');
    });
    test('entitlement fallback is the most restrictive', () {
      final e = Entitlement.fallback('u');
      expect(e.aiEnabled, isFalse);
      expect(e.adsEnabled, isTrue);
      expect(e.planId, PlanId.individualBase);
    });
    test('entitlement parses server document', () {
      final e = Entitlement.fromMap('u', {'planId': 'family_pro', 'aiEnabled': true, 'adsEnabled': false, 'storageLimitBytes': 1, 'maxDocuments': 2, 'usageKey': 'fam', 'currentPeriodEnd': 1767225600000});
      expect(e.planId, PlanId.familyPro);
      expect(e.isFamilyPlan, isTrue);
      expect(e.usageKey, 'fam');
      expect(e.currentPeriodEnd, isNotNull);
    });
    test('usage ratios', () {
      final e = Entitlement.fallback('u');
      const u = Usage(activeDocumentCount: 100, storageUsedBytes: 50 * 1024 * 1024);
      expect(u.documentLimitReached(e), isTrue);
      expect(u.storageRatio(e), closeTo(0.5, 0.001));
    });
    test('plan catalog mirrors server', () {
      expect(Plans.of(PlanId.individualPro).priceEur, 4.99);
      expect(Plans.of(PlanId.familyBase).ai, isFalse);
      expect(Plans.of(PlanId.familyPro).maxMembers, 10);
      expect(Plans.all.where((p) => p.ads).map((p) => p.id), [PlanId.individualBase]);
      expect(planIdFromWire(planIdToWire(PlanId.familyBase)), PlanId.familyBase);
    });
  });
}
