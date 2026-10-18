import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/theme/app_theme.dart';
import '../domain/models/entities.dart';
import '../l10n/app_localizations.dart';
import 'providers.dart';
import 'router.dart';

/// App language follows the user's profile setting; Serbian uses Latin script.
final localeProvider = Provider<Locale>((ref) {
  final lang = ref.watch(userProfileProvider).value?.preferredLanguage ?? 'sr';
  return lang == 'en' ? const Locale('en') : const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn');
});

class MyWorldApp extends ConsumerStatefulWidget {
  const MyWorldApp({super.key});
  @override
  ConsumerState<MyWorldApp> createState() => _MyWorldAppState();
}

class _MyWorldAppState extends ConsumerState<MyWorldApp> {
  StreamSubscription<Uri>? _links;
  StreamSubscription<String>? _taps;
  String? _sessionUid;

  @override
  void initState() {
    super.initState();
    _initLinks();
    final notifications = ref.read(notificationServiceProvider);
    notifications.init().then((_) {
      _taps = notifications.taps.listen((id) => ref.read(routerProvider).push('/reminders/$id'));
    });
  }

  /// Invitation deep links: https://myworldplus.app/invite?i=…&t=…
  Future<void> _initLinks() async {
    final appLinks = AppLinks();
    void handle(Uri uri) {
      if (uri.host == AppConfig.inviteHost && uri.path.startsWith('/invite')) {
        ref.read(routerProvider).go(Uri(path: '/invite', queryParameters: uri.queryParameters).toString());
      }
    }

    final initial = await appLinks.getInitialLink();
    if (initial != null) handle(initial);
    _links = appLinks.uriLinkStream.listen(handle);
  }

  /// Per-session side effects: billing identity and push token.
  void _onSession(String? uid) {
    if (uid == _sessionUid) return;
    _sessionUid = uid;
    if (uid == null) return;
    final locale = ref.read(localeProvider).languageCode;
    ref.read(billingServiceProvider).configure(uid).catchError((_) {});
    ref.read(notificationServiceProvider).registerDevice(ref.read(firestoreProvider), uid, locale).catchError((_) {});
  }

  @override
  void dispose() {
    _links?.cancel();
    _taps?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    ref.listen(uidProvider, (_, uid) => _onSession(uid));
    // Mirror reminders as local notifications (offline backup).
    ref.listen<AsyncValue<List<Reminder>>>(remindersProvider, (_, next) {
      final list = next.value;
      if (list == null) return;
      final l = lookupAppLocalizations(locale);
      ref.read(notificationServiceProvider).syncLocal(
            list,
            genericTitle: l.notificationTitle,
            genericBody: l.notificationGenericBody,
            showDetails: ref.read(userProfileProvider).value?.notificationPreview == 'detailed',
          );
    });

    return MaterialApp.router(
      title: 'MyWorld+',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: locale,
      supportedLocales: const [Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn'), Locale('sr'), Locale('en')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: router,
    );
  }
}
