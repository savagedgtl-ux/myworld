import '../models/entities.dart';

/// Picks the most important upcoming reminders for Home (max [limit]).
List<Reminder> topUpcoming(Iterable<Reminder> reminders, {int limit = 3, DateTime? now}) {
  final n = now ?? DateTime.now();
  final active = reminders.where((r) => r.isActive).toList()
    ..sort((a, b) {
      // Overdue first, then nearest due date.
      final ao = a.dueAt.isBefore(n), bo = b.dueAt.isBefore(n);
      if (ao != bo) return ao ? -1 : 1;
      return a.dueAt.compareTo(b.dueAt);
    });
  return active.take(limit).toList();
}

enum DueState { overdue, today, soon, later }

DueState dueState(DateTime due, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  final d = DateTime(due.year, due.month, due.day);
  if (d.isBefore(today)) return DueState.overdue;
  if (d == today) return DueState.today;
  if (d.difference(today).inDays <= 14) return DueState.soon;
  return DueState.later;
}

/// Local, device-side next occurrence (wall-clock) used for local notifications.
DateTime? nextLocalOccurrence(DateTime due, RepeatRule rule, DateTime after) {
  if (rule == RepeatRule.none) return due.isAfter(after) ? due : null;
  var d = due;
  var i = 0;
  while (!d.isAfter(after) && i < 100000) {
    i++;
    d = switch (rule) {
      RepeatRule.daily => DateTime(due.year, due.month, due.day + i, due.hour, due.minute),
      RepeatRule.weekly => DateTime(due.year, due.month, due.day + 7 * i, due.hour, due.minute),
      RepeatRule.monthly => _addMonthsClamped(due, i),
      RepeatRule.yearly => _addMonthsClamped(due, 12 * i),
      RepeatRule.none => d,
    };
  }
  return d;
}

DateTime _addMonthsClamped(DateTime d, int months) {
  final total = d.year * 12 + (d.month - 1) + months;
  final y = total ~/ 12, m = total % 12 + 1;
  final last = DateTime(y, m + 1, 0).day;
  return DateTime(y, m, d.day > last ? last : d.day, d.hour, d.minute);
}

/// Stable 31-bit id for local notifications derived from a reminder id.
int localNotificationId(String reminderId) {
  var h = 0;
  for (final c in reminderId.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return h;
}
