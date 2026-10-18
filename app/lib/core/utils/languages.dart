import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';

/// App languages a user can pick, stored as `users/{uid}.preferredLanguage`.
const supportedLanguages = ['sr', 'en', 'de', 'fr', 'es', 'ru'];

/// Language to use before the user has picked one: the phone's language when
/// supported, Serbian for neighbouring languages, otherwise English.
String deviceLanguage() {
  final code = PlatformDispatcher.instance.locale.languageCode;
  if (supportedLanguages.contains(code)) return code;
  return const ['hr', 'bs', 'sh', 'cnr', 'mk', 'sl'].contains(code) ? 'sr' : 'en';
}

/// Serbian uses Latin script.
Locale localeForLanguage(String? code) {
  final lang = code != null && supportedLanguages.contains(code) ? code : deviceLanguage();
  return lang == 'sr' ? const Locale.fromSubtags(languageCode: 'sr', scriptCode: 'Latn') : Locale(lang);
}

String languageName(AppLocalizations l, String code) => switch (code) {
      'en' => l.langEnglish,
      'de' => l.langGerman,
      'fr' => l.langFrench,
      'es' => l.langSpanish,
      'ru' => l.langRussian,
      _ => l.langSerbian,
    };
