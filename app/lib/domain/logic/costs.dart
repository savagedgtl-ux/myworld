import '../models/entities.dart';

/// Vehicle cost aggregation. Amounts in different currencies are never summed
/// together — each currency gets its own total.
class CostSummary {
  CostSummary({required this.totalByCurrency, required this.thisYearByCurrency, required this.byType, required this.lastMileage});

  final Map<String, double> totalByCurrency;
  final Map<String, double> thisYearByCurrency;

  /// type -> currency -> amount
  final Map<VehicleRecordType, Map<String, double>> byType;
  final double? lastMileage;

  bool get isEmpty => totalByCurrency.isEmpty;
}

CostSummary summarizeCosts(Iterable<VehicleRecord> records, {DateTime? now, double? vehicleMileage}) {
  final year = (now ?? DateTime.now()).year;
  final total = <String, double>{};
  final thisYear = <String, double>{};
  final byType = <VehicleRecordType, Map<String, double>>{};
  double? lastMileage = vehicleMileage;
  DateTime? lastMileageDate;

  for (final r in records) {
    if (r.mileage != null && (lastMileageDate == null || r.date.isAfter(lastMileageDate))) {
      lastMileageDate = r.date;
      if (lastMileage == null || r.mileage! > lastMileage) lastMileage = r.mileage;
    }
    final amount = r.amount;
    if (amount == null) continue;
    final cur = r.currency ?? '—';
    total[cur] = (total[cur] ?? 0) + amount;
    if (r.date.year == year) thisYear[cur] = (thisYear[cur] ?? 0) + amount;
    final t = byType.putIfAbsent(r.type, () => {});
    t[cur] = (t[cur] ?? 0) + amount;
  }
  return CostSummary(totalByCurrency: total, thisYearByCurrency: thisYear, byType: byType, lastMileage: lastMileage);
}

/// Monthly totals for a single currency over the last [months] months.
List<({DateTime month, double amount})> monthlyTotals(Iterable<VehicleRecord> records, String currency, {int months = 12, DateTime? now}) {
  final n = now ?? DateTime.now();
  final buckets = <DateTime, double>{};
  for (var i = months - 1; i >= 0; i--) {
    buckets[DateTime(n.year, n.month - i)] = 0;
  }
  for (final r in records) {
    if (r.amount == null || (r.currency ?? '—') != currency) continue;
    final key = DateTime(r.date.year, r.date.month);
    if (buckets.containsKey(key)) buckets[key] = buckets[key]! + r.amount!;
  }
  return [for (final e in buckets.entries) (month: e.key, amount: e.value)];
}

/// Upcoming deadlines from records the user entered (we never invent intervals).
List<VehicleRecord> upcomingDeadlines(Iterable<VehicleRecord> records, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final list = records.where((r) => r.nextDueDate != null && r.nextDueDate!.isAfter(n.subtract(const Duration(days: 1)))).toList()
    ..sort((a, b) => a.nextDueDate!.compareTo(b.nextDueDate!));
  return list;
}
