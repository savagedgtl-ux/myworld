import 'dart:async';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/config/app_config.dart';

/// Ads for Individual Base only. The SDK is not even initialized unless the
/// server-side entitlement says ads are allowed AND consent allows requests.
/// No document data, titles or search terms are ever passed to ad requests.
class AdsService {
  AdsService({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  bool _initialized = false;
  bool _canRequest = false;
  InterstitialAd? _interstitial;
  bool _interstitialLoading = false;

  /// Interstitial limits: no full-screen ads in the first day of use, at most
  /// one every few minutes and a few per day.
  static const interstitialGrace = Duration(hours: 24);
  static const interstitialGap = Duration(minutes: 5);
  static const interstitialDailyCap = 3;
  static const _kFirstSeen = 'ads.firstSeen';
  static const _kLastShown = 'ads.lastShown';
  static const _kDay = 'ads.day';
  static const _kDayCount = 'ads.dayCount';

  bool get canRequestAds => _initialized && _canRequest;
  String get bannerUnitId => Platform.isIOS ? AppConfig.adUnitIos : AppConfig.adUnitAndroid;
  String get interstitialUnitId => Platform.isIOS ? AppConfig.interstitialUnitIos : AppConfig.interstitialUnitAndroid;

  /// Runs the Google UMP consent flow (GDPR/regional) and initializes the SDK.
  Future<void> ensureReady() async {
    if (_initialized) return;
    final done = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () async {
        await ConsentForm.loadAndShowConsentFormIfRequired((_) {});
        _canRequest = await ConsentInformation.instance.canRequestAds();
        if (!done.isCompleted) done.complete();
      },
      (_) async {
        _canRequest = await ConsentInformation.instance.canRequestAds();
        if (!done.isCompleted) done.complete();
      },
    );
    await done.future;
    if (_canRequest) {
      await MobileAds.instance.initialize();
      // Non-personalized by default unless the user consented otherwise in UMP.
      await MobileAds.instance.updateRequestConfiguration(RequestConfiguration(
        maxAdContentRating: MaxAdContentRating.pg,
      ));
    }
    _initialized = true;
  }

  /// Loads the next interstitial in the background so it can show instantly.
  Future<void> preloadInterstitial() async {
    if (_interstitial != null || _interstitialLoading) return;
    await ensureReady();
    if (!canRequestAds) return;
    _interstitialLoading = true;
    await InterstitialAd.load(
      adUnitId: interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial = ad;
          _interstitialLoading = false;
        },
        onAdFailedToLoad: (_) => _interstitialLoading = false,
      ),
    );
  }

  /// Shows the preloaded interstitial if the frequency limits allow it. The
  /// caller has already checked the server entitlement (free plan only).
  Future<void> maybeShowInterstitial() async {
    if (!await _interstitialAllowed()) {
      unawaited(preloadInterstitial());
      return;
    }
    final ad = _interstitial;
    if (ad == null) {
      unawaited(preloadInterstitial());
      return;
    }
    _interstitial = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        preloadInterstitial();
      },
    );
    await _recordInterstitial();
    await ad.show();
  }

  Future<bool> _interstitialAllowed() async {
    final now = DateTime.now();
    final firstSeen = int.tryParse(await _storage.read(key: _kFirstSeen) ?? '');
    if (firstSeen == null) {
      await _storage.write(key: _kFirstSeen, value: '${now.millisecondsSinceEpoch}');
      return false;
    }
    if (now.difference(DateTime.fromMillisecondsSinceEpoch(firstSeen)) < interstitialGrace) return false;
    final last = int.tryParse(await _storage.read(key: _kLastShown) ?? '');
    if (last != null && now.difference(DateTime.fromMillisecondsSinceEpoch(last)) < interstitialGap) return false;
    final sameDay = await _storage.read(key: _kDay) == _dayKey(now);
    final count = sameDay ? int.tryParse(await _storage.read(key: _kDayCount) ?? '') ?? 0 : 0;
    return count < interstitialDailyCap;
  }

  Future<void> _recordInterstitial() async {
    final now = DateTime.now();
    final day = _dayKey(now);
    final sameDay = await _storage.read(key: _kDay) == day;
    final count = sameDay ? int.tryParse(await _storage.read(key: _kDayCount) ?? '') ?? 0 : 0;
    await _storage.write(key: _kLastShown, value: '${now.millisecondsSinceEpoch}');
    await _storage.write(key: _kDay, value: day);
    await _storage.write(key: _kDayCount, value: '${count + 1}');
  }

  static String _dayKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() == PrivacyOptionsRequirementStatus.required;

  Future<void> showPrivacyOptions() => ConsentForm.showPrivacyOptionsForm((_) {});
}
