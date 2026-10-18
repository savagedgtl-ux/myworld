import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/tokens.dart';
import '../core/utils/formatters.dart';

/// Lightweight reachability check (no extra plugin): periodically resolves a
/// Google host. Firestore keeps working offline from cache; this only informs
/// the user that changes will sync later.
final onlineProvider = StreamProvider<bool>((ref) async* {
  Future<bool> check() async {
    try {
      final r = await InternetAddress.lookup('firestore.googleapis.com').timeout(const Duration(seconds: 4));
      return r.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  yield await check();
  yield* Stream.periodic(const Duration(seconds: 15)).asyncMap((_) => check()).distinct();
});

class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final online = ref.watch(onlineProvider).value ?? true;
    return AnimatedSize(
      duration: Motion.of(context, Motion.normal),
      child: online
          ? const SizedBox(width: double.infinity)
          : Material(
              color: AppColors.warning,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Space.lg, vertical: Space.sm),
                  child: Row(children: [
                    const Icon(Icons.wifi_off_rounded, size: 18, color: Colors.white),
                    const SizedBox(width: Space.sm),
                    Expanded(child: Text(context.l10n.offlineBanner, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                  ]),
                ),
              ),
            ),
    );
  }
}
