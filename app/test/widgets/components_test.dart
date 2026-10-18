import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myworld_plus/core/theme/app_theme.dart';
import 'package:myworld_plus/core/theme/tokens.dart';
import 'package:myworld_plus/core/widgets/buttons.dart';
import 'package:myworld_plus/core/widgets/components.dart';
import 'package:myworld_plus/core/widgets/states.dart';
import 'package:myworld_plus/core/errors/app_error.dart';
import 'package:myworld_plus/domain/models/account.dart';
import 'package:myworld_plus/domain/models/entities.dart';
import 'package:myworld_plus/domain/plans.dart';
import 'package:myworld_plus/l10n/app_localizations.dart';

Widget wrap(Widget child, {Locale locale = const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'), double textScale = 1}) => MaterialApp(
      theme: AppTheme.light(),
      locale: locale,
      supportedLocales: const [Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'), Locale('sr'), Locale('en')],
      localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      home: MediaQuery(
        data: MediaQueryData(textScaler: TextScaler.linear(textScale), size: const Size(360, 780)),
        child: Scaffold(body: SingleChildScrollView(padding: const EdgeInsets.all(16), child: child)),
      ),
    );

double _luminance(Color c) => c.computeLuminance();
double contrast(Color a, Color b) {
  final l1 = _luminance(a), l2 = _luminance(b);
  return (l1 > l2 ? l1 + 0.05 : l2 + 0.05) / (l1 > l2 ? l2 + 0.05 : l1 + 0.05);
}

void main() {
  test('text colours meet WCAG AA contrast on their surfaces', () {
    expect(contrast(AppColors.textPrimary, AppColors.background), greaterThan(4.5));
    expect(contrast(AppColors.textSecondary, AppColors.card), greaterThan(4.5));
    expect(contrast(Colors.white, AppColors.primary), greaterThan(4.5));
    expect(contrast(AppColors.darkTextPrimary, AppColors.darkBackground), greaterThan(4.5));
    expect(contrast(AppColors.darkTextSecondary, AppColors.darkCard), greaterThan(4.5));
  });

  testWidgets('Serbian Latin strings render', (t) async {
    await t.pumpWidget(wrap(const EmptyState(icon: Icons.folder, title: 'x')));
    final l = AppLocalizations.of(t.element(find.byType(EmptyState)));
    expect(l.searchHint, 'Šta tražiš danas?');
    expect(l.documentsCount(3), '3 dokumenta');
    expect(l.documentsCount(5), '5 dokumenata');
    expect(l.documentsCount(21), '21 dokument');
  });

  testWidgets('English strings render', (t) async {
    await t.pumpWidget(wrap(const SizedBox(), locale: const Locale('en')));
    final l = AppLocalizations.of(t.element(find.byType(SizedBox).first));
    expect(l.searchHint, 'What are you looking for today?');
    expect(l.documentsCount(1), '1 document');
  });

  testWidgets('storage card shows usage and stays legible at 2x text', (t) async {
    final ent = Entitlement.fallback('u');
    await t.pumpWidget(wrap(StorageUsageCard(usage: const Usage(activeDocumentCount: 10, storageUsedBytes: 50 * 1024 * 1024), entitlement: ent, compact: false), textScale: 2));
    expect(find.textContaining('100 MB'), findsOneWidget);
    expect(find.text('Dokumenata: 10 od 100'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('error state maps codes to friendly messages, never raw errors', (t) async {
    await t.pumpWidget(wrap(const ErrorState(error: AppError(AppErrorCode.network))));
    expect(find.textContaining('Nema internet veze'), findsOneWidget);
    await t.pumpWidget(wrap(const ErrorState(error: AppError(AppErrorCode.aiNotInPlan))));
    expect(find.textContaining('Individual Pro'), findsOneWidget);
  });

  testWidgets('plan badge and buttons expose semantics', (t) async {
    final handle = t.ensureSemantics();
    var tapped = false;
    await t.pumpWidget(wrap(Column(children: [const PlanBadge(plan: PlanId.familyPro), PrimaryButton(label: 'Sačuvaj', onPressed: () => tapped = true)])));
    expect(find.text('Family Pro'), findsOneWidget);
    expect(find.bySemanticsLabel('Sačuvaj'), findsOneWidget);
    await t.tap(find.byType(PrimaryButton));
    expect(tapped, isTrue);
    final size = t.getSize(find.byType(FilledButton));
    expect(size.height, greaterThanOrEqualTo(48), reason: 'minimum touch target');
    handle.dispose();
  });

  testWidgets('reminder card shows overdue state', (t) async {
    final r = Reminder(id: 'r', ownerUid: 'u', title: 'Registracija', dueAt: DateTime.now().subtract(const Duration(days: 3)), timezone: 'UTC');
    await t.pumpWidget(wrap(ReminderCard(reminder: r, onTap: () {})));
    expect(find.text('Registracija'), findsOneWidget);
    expect(find.text('Isteklo'), findsOneWidget);
  });

  testWidgets('locked world card announces lock', (t) async {
    final handle = t.ensureSemantics();
    await t.pumpWidget(wrap(SizedBox(width: 160, height: 180, child: WorldCategoryCard(title: 'My Family', subtitle: 'x', icon: Icons.family_restroom, locked: true, onTap: () {}))));
    expect(find.bySemanticsLabel(RegExp('Zaključano')), findsOneWidget);
    expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    handle.dispose();
  });
}
