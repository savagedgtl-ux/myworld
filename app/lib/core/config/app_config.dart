/// Build-time configuration via --dart-define (see README "Configuration").
/// No secrets here: only public identifiers. Secret keys live in Cloud
/// Functions Secret Manager.
abstract final class AppConfig {
  /// dev | staging | prod
  static const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
  static const useEmulators = bool.fromEnvironment('USE_EMULATORS', defaultValue: false);
  static const emulatorHost = String.fromEnvironment('EMULATOR_HOST', defaultValue: '10.0.2.2');
  static const functionsRegion = String.fromEnvironment('FUNCTIONS_REGION', defaultValue: 'europe-west1');

  /// RevenueCat public SDK keys (safe to ship in the app).
  static const revenueCatAppleKey = String.fromEnvironment('REVENUECAT_APPLE_KEY');
  static const revenueCatGoogleKey = String.fromEnvironment('REVENUECAT_GOOGLE_KEY');

  /// AdMob ad unit for the single native/banner slot (Individual Base only).
  /// Real unit only in prod builds; everything else shows Google's test ads so
  /// nobody clicks our own ads by accident.
  static const adUnitAndroid = String.fromEnvironment('ADMOB_UNIT_ANDROID',
      defaultValue: flavor == 'prod' ? 'ca-app-pub-9194255448126768/4973486383' : 'ca-app-pub-3940256099942544/6300978111');
  static const adUnitIos = String.fromEnvironment('ADMOB_UNIT_IOS', defaultValue: 'ca-app-pub-3940256099942544/2934735716');

  /// Full-screen ad shown at natural breaks (after something new is saved).
  static const interstitialUnitAndroid = String.fromEnvironment('ADMOB_INTERSTITIAL_ANDROID',
      defaultValue: flavor == 'prod' ? 'ca-app-pub-9194255448126768/9240034456' : 'ca-app-pub-3940256099942544/1033173712');
  static const interstitialUnitIos = String.fromEnvironment('ADMOB_INTERSTITIAL_IOS', defaultValue: 'ca-app-pub-3940256099942544/4411468910');

  /// Google Sign-In server client id (Web client id from Firebase console).
  static const googleServerClientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID', defaultValue: '604089389013-pl032nb48i8ci2sl0fgrfugisrkmdjav.apps.googleusercontent.com');

  static const privacyPolicyUrl = String.fromEnvironment('PRIVACY_URL', defaultValue: 'https://myworld-b0330.web.app/privacy');
  static const termsUrl = String.fromEnvironment('TERMS_URL', defaultValue: 'https://myworld-b0330.web.app/terms');
  static const supportEmail = String.fromEnvironment('SUPPORT_EMAIL', defaultValue: 'savage.dgtl@gmail.com');
  static const inviteHost = String.fromEnvironment('INVITE_HOST', defaultValue: 'myworld-b0330.web.app');

  /// Test builds only: a one-tap sign-in with a pre-made tester account
  /// (also handed to store reviewers). Never set for prod builds.
  static const testLoginEmail = String.fromEnvironment('TEST_LOGIN_EMAIL');
  static const testLoginPassword = String.fromEnvironment('TEST_LOGIN_PASSWORD');
  static bool get hasTestLogin => !isProd && testLoginEmail.isNotEmpty && testLoginPassword.isNotEmpty;

  static bool get isProd => flavor == 'prod';
}
