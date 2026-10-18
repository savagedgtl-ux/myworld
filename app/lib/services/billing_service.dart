import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../core/config/app_config.dart';
import '../core/errors/app_error.dart';
import '../domain/plans.dart';
import 'functions_service.dart';

/// A purchasable plan as offered by the store (localized price from the store).
class StoreOffer {
  const StoreOffer({required this.plan, required this.priceString, required this.package});
  final PlanId plan;
  final String priceString;
  final Package package;
}

/// App Store / Google Play subscriptions through RevenueCat.
///
/// The client result of a purchase is NEVER trusted: after every purchase or
/// restore we call `syncSubscription`, which fetches the verified state
/// server-side and recomputes the entitlement. The UI then follows
/// entitlements/{uid}, which only the server can write.
class BillingService {
  BillingService(this._functions);
  final FunctionsService _functions;
  bool _configured = false;

  bool get isAvailable =>
      (Platform.isIOS && AppConfig.revenueCatAppleKey.isNotEmpty) ||
      (Platform.isAndroid && AppConfig.revenueCatGoogleKey.isNotEmpty);

  Future<void> configure(String uid) async {
    if (!isAvailable) return;
    if (!_configured) {
      final key = Platform.isIOS ? AppConfig.revenueCatAppleKey : AppConfig.revenueCatGoogleKey;
      await Purchases.configure(PurchasesConfiguration(key)..appUserID = uid);
      _configured = true;
    } else {
      await Purchases.logIn(uid);
    }
  }

  Future<void> logOut() async {
    if (!_configured) return;
    try {
      await Purchases.logOut();
    } catch (_) {}
  }

  /// Offerings configured in RevenueCat; package identifiers must map to
  /// entitlement ids individual_pro / family_base / family_pro.
  Future<List<StoreOffer>> offers() async {
    if (!isAvailable || !_configured) return const [];
    try {
      final offerings = await Purchases.getOfferings();
      final current = offerings.current;
      if (current == null) return const [];
      final out = <StoreOffer>[];
      for (final pkg in current.availablePackages) {
        final plan = _planForProduct(pkg.storeProduct.identifier, pkg.identifier);
        if (plan != null) out.add(StoreOffer(plan: plan, priceString: pkg.storeProduct.priceString, package: pkg));
      }
      return out;
    } on PlatformException catch (e) {
      throw _map(e);
    }
  }

  PlanId? _planForProduct(String productId, String packageId) {
    final id = '$productId $packageId'.toLowerCase();
    if (id.contains('family_pro') || id.contains('fam_pro')) return PlanId.familyPro;
    if (id.contains('family_base') || id.contains('fam_base')) return PlanId.familyBase;
    if (id.contains('individual_pro') || id.contains('ind_pro')) return PlanId.individualPro;
    return null;
  }

  Future<void> purchase(StoreOffer offer) async {
    try {
      await Purchases.purchase(PurchaseParams.package(offer.package));
    } on PlatformException catch (e) {
      throw _map(e);
    } finally {
      // Even after a cancel we resync: it is cheap and keeps state honest.
      await sync();
    }
  }

  Future<void> restore() async {
    if (isAvailable && _configured) {
      try {
        await Purchases.restorePurchases();
      } on PlatformException catch (e) {
        throw _map(e);
      }
    }
    await sync();
  }

  /// Server-side verification and entitlement recompute.
  Future<void> sync() => _functions.call('syncSubscription');

  Future<String?> managementUrl() async {
    if (!_configured) return null;
    final info = await Purchases.getCustomerInfo();
    return info.managementURL;
  }

  AppError _map(PlatformException e) {
    final code = PurchasesErrorHelper.getErrorCode(e);
    return switch (code) {
      PurchasesErrorCode.purchaseCancelledError => const AppError(AppErrorCode.cancelled),
      PurchasesErrorCode.networkError => const AppError(AppErrorCode.network),
      _ => const AppError(AppErrorCode.unavailable),
    };
  }
}
