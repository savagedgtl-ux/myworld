import '../models/document.dart';

/// Lower-case, diacritic-insensitive normalisation (Serbian Latin + Cyrillic).
String normalizeText(String s) {
  const map = {
    'č': 'c', 'ć': 'c', 'š': 's', 'ž': 'z', 'đ': 'dj',
    'а': 'a', 'б': 'b', 'в': 'v', 'г': 'g', 'д': 'd', 'ђ': 'dj', 'е': 'e', 'ж': 'z', 'з': 'z', 'и': 'i',
    'ј': 'j', 'к': 'k', 'л': 'l', 'љ': 'lj', 'м': 'm', 'н': 'n', 'њ': 'nj', 'о': 'o', 'п': 'p', 'р': 'r',
    'с': 's', 'т': 't', 'ћ': 'c', 'у': 'u', 'ф': 'f', 'х': 'h', 'ц': 'c', 'ч': 'c', 'џ': 'dz', 'ш': 's',
    'á': 'a', 'à': 'a', 'ä': 'a', 'é': 'e', 'è': 'e', 'ë': 'e', 'í': 'i', 'ó': 'o', 'ö': 'o', 'ú': 'u', 'ü': 'u',
  };
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    b.write(map[ch] ?? ch);
  }
  return b.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
}

/// A term matches when it appears as-is, or — for longer words — when its
/// stem does (crude handling of Serbian case endings: mašina/mašinu/mašine).
bool termMatches(String haystack, String term) {
  if (haystack.contains(term)) return true;
  if (term.length >= 5) return haystack.contains(term.substring(0, term.length - 1));
  if (term.length == 4) return RegExp('\\b${RegExp.escape(term.substring(0, 3))}').hasMatch(haystack);
  return false;
}

enum DocSort { newest, oldest, nameAsc, nameDesc, amountDesc, amountAsc, expiry }

enum DateRange { any, last30, thisYear, lastYear }

class DocumentFilter {
  const DocumentFilter({
    this.query = '',
    this.categoryIds = const {},
    this.range = DateRange.any,
    this.fileType,
    this.linkedEntityId,
    this.status,
    this.favoritesOnly = false,
    this.withWarrantyOnly = false,
    this.withReminderIds,
    this.vaultOnly = false,
    this.includeVault = true,
    this.sort = DocSort.newest,
  });

  final String query;
  final Set<String> categoryIds;
  final DateRange range;
  final String? fileType; // 'pdf' | 'image'
  final String? linkedEntityId;
  final ProcessingStatus? status;
  final bool favoritesOnly;
  final bool withWarrantyOnly;

  /// Document ids that have a reminder (for the "with reminder" filter).
  final Set<String>? withReminderIds;
  final bool vaultOnly;
  final bool includeVault;
  final DocSort sort;

  bool get isEmpty =>
      query.isEmpty && categoryIds.isEmpty && range == DateRange.any && fileType == null && linkedEntityId == null &&
      status == null && !favoritesOnly && !withWarrantyOnly && withReminderIds == null;

  DocumentFilter copyWith({
    String? query,
    Set<String>? categoryIds,
    DateRange? range,
    String? fileType,
    bool clearFileType = false,
    String? linkedEntityId,
    ProcessingStatus? status,
    bool clearStatus = false,
    bool? favoritesOnly,
    bool? withWarrantyOnly,
    Set<String>? withReminderIds,
    bool clearReminder = false,
    DocSort? sort,
  }) =>
      DocumentFilter(
        query: query ?? this.query,
        categoryIds: categoryIds ?? this.categoryIds,
        range: range ?? this.range,
        fileType: clearFileType ? null : (fileType ?? this.fileType),
        linkedEntityId: linkedEntityId ?? this.linkedEntityId,
        status: clearStatus ? null : (status ?? this.status),
        favoritesOnly: favoritesOnly ?? this.favoritesOnly,
        withWarrantyOnly: withWarrantyOnly ?? this.withWarrantyOnly,
        withReminderIds: clearReminder ? null : (withReminderIds ?? this.withReminderIds),
        vaultOnly: vaultOnly,
        includeVault: includeVault,
        sort: sort ?? this.sort,
      );
}

DateTime? _relevantDate(DocumentRecord d) => d.documentDate ?? d.purchaseDate ?? d.createdAt;

/// Filters and sorts documents the user is already authorised to see.
List<DocumentRecord> applyDocumentFilter(List<DocumentRecord> docs, DocumentFilter f, {DateTime? now, Map<String, String>? extraText}) {
  final today = now ?? DateTime.now();
  final terms = normalizeText(f.query).split(' ').where((t) => t.isNotEmpty).toList();

  bool inRange(DocumentRecord d) {
    final dt = _relevantDate(d);
    if (f.range == DateRange.any) return true;
    if (dt == null) return false;
    return switch (f.range) {
      DateRange.last30 => dt.isAfter(today.subtract(const Duration(days: 30))),
      DateRange.thisYear => dt.year == today.year,
      DateRange.lastYear => dt.year == today.year - 1,
      DateRange.any => true,
    };
  }

  final out = docs.where((d) {
    if (d.inTrash) return false;
    if (f.vaultOnly && !d.isVault) return false;
    if (!f.includeVault && d.isVault) return false;
    if (f.categoryIds.isNotEmpty && !f.categoryIds.contains(d.categoryId)) return false;
    if (f.fileType != null && d.fileType != f.fileType) return false;
    if (f.linkedEntityId != null && !d.linkedEntityIds.contains(f.linkedEntityId)) return false;
    if (f.status != null && d.processingStatus != f.status) return false;
    if (f.favoritesOnly && !d.isFavorite) return false;
    if (f.withWarrantyOnly && !d.hasWarranty) return false;
    if (f.withReminderIds != null && !f.withReminderIds!.contains(d.id)) return false;
    if (!inRange(d)) return false;
    if (terms.isEmpty) return true;
    final hay = normalizeText('${d.searchText} ${d.amount ?? ''} ${extraText?[d.id] ?? ''}');
    return terms.every((t) => termMatches(hay, t));
  }).toList();

  int cmpDate(DocumentRecord a, DocumentRecord b) =>
      (_relevantDate(a) ?? DateTime(0)).compareTo(_relevantDate(b) ?? DateTime(0));
  switch (f.sort) {
    case DocSort.newest:
      out.sort((a, b) => cmpDate(b, a));
    case DocSort.oldest:
      out.sort(cmpDate);
    case DocSort.nameAsc:
      out.sort((a, b) => normalizeText(a.title).compareTo(normalizeText(b.title)));
    case DocSort.nameDesc:
      out.sort((a, b) => normalizeText(b.title).compareTo(normalizeText(a.title)));
    case DocSort.amountDesc:
      out.sort((a, b) => (b.amount ?? -1).compareTo(a.amount ?? -1));
    case DocSort.amountAsc:
      out.sort((a, b) => (a.amount ?? double.infinity).compareTo(b.amount ?? double.infinity));
    case DocSort.expiry:
      DateTime exp(DocumentRecord d) => d.warrantyExpiryDate ?? d.expiryDate ?? DateTime(9999);
      out.sort((a, b) => exp(a).compareTo(exp(b)));
  }
  return out;
}

/// Generic text match for other record types (assets, cards, contacts…).
bool matchesQuery(String query, Iterable<String?> fields) {
  final terms = normalizeText(query).split(' ').where((t) => t.isNotEmpty);
  if (terms.isEmpty) return true;
  final hay = normalizeText(fields.whereType<String>().join(' '));
  return terms.every((t) => termMatches(hay, t));
}
