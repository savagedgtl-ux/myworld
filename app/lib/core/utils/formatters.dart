import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../l10n/app_localizations.dart';

extension L10nX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  /// intl locale tag. Serbian defaults to Latin script ("sr_Latn"); intl's
  /// plain "sr" would be Cyrillic.
  String get intlLocale {
    final l = Localizations.localeOf(this);
    if (l.languageCode == 'sr') return l.scriptCode == 'Cyrl' ? 'sr' : 'sr_Latn';
    return l.toLanguageTag().replaceAll('-', '_');
  }
}

abstract final class Fmt {
  static String date(BuildContext c, DateTime? d) => d == null ? '—' : DateFormat.yMMMd(c.intlLocale).format(d);
  static String dateShort(BuildContext c, DateTime? d) => d == null ? '—' : DateFormat('dd.MM.yyyy').format(d);
  static String dateTime(BuildContext c, DateTime? d) => d == null ? '—' : DateFormat.yMMMd(c.intlLocale).add_Hm().format(d);
  static String monthYear(BuildContext c, DateTime d) => DateFormat.yMMM(c.intlLocale).format(d);

  /// Currency is always explicit; we never infer it from the app language.
  static String money(BuildContext c, double? amount, String? currency) {
    if (amount == null) return '—';
    final f = NumberFormat.currency(locale: c.intlLocale, name: currency ?? '', symbol: currency == null ? '' : null, decimalDigits: 2);
    try {
      return f.format(amount).trim();
    } catch (_) {
      return '${NumberFormat.decimalPattern(c.intlLocale).format(amount)} ${currency ?? ''}'.trim();
    }
  }

  static String number(BuildContext c, num? v) => v == null ? '—' : NumberFormat.decimalPattern(c.intlLocale).format(v);

  static String bytes(BuildContext c, int b) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var v = b.toDouble();
    var i = 0;
    while (v >= 1024 && i < units.length - 1) {
      v /= 1024;
      i++;
    }
    return '${NumberFormat.decimalPattern(c.intlLocale).format(double.parse(v.toStringAsFixed(v >= 10 || i == 0 ? 0 : 1)))} ${units[i]}';
  }

  /// Relative due text: "danas", "za 3 dana", "pre 2 dana".
  static String relativeDays(BuildContext c, DateTime d, {DateTime? now}) {
    final n = now ?? DateTime.now();
    final days = DateTime(d.year, d.month, d.day).difference(DateTime(n.year, n.month, n.day)).inDays;
    final l = c.l10n;
    if (days == 0) return l.today;
    if (days == 1) return l.tomorrow;
    if (days > 0) return l.inDays(days);
    return l.daysAgo(-days);
  }
}
