import 'dart:async';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/config/app_config.dart';

/// Ads for Individual Base only. The SDK is not even initialized unless the
/// server-side entitlement says ads are allowed AND consent allows requests.
/// No document data, titles or search terms are ever passed to ad requests.
class AdsService {
  bool _initialized = false;
  bool _canRequest = false;

  bool get canRequestAds => _initialized && _canRequest;
  String get bannerUnitId => Platform.isIOS ? AppConfig.adUnitIos : AppConfig.adUnitAndroid;

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

  Future<bool> privacyOptionsRequired() async =>
      await ConsentInformation.instance.getPrivacyOptionsRequirementStatus() == PrivacyOptionsRequirementStatus.required;

  Future<void> showPrivacyOptions() => ConsentForm.showPrivacyOptionsForm((_) {});
}
