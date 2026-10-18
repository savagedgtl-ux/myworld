import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/tokens.dart';
import '../core/utils/formatters.dart';
import '../features/add/add_sheet.dart';
import 'connectivity.dart';

/// Bottom navigation: Home · My World · Add · Vault.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.shell});
  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    return Scaffold(
      body: Column(children: [
        const OfflineBanner(),
        Expanded(child: shell),
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex >= 2 ? shell.currentIndex + 1 : shell.currentIndex,
        onDestinationSelected: (i) {
          if (i == 2) {
            showAddSheet(context, ref);
            return;
          }
          final branch = i > 2 ? i - 1 : i;
          if (branch != 2) ref.read(addContextProvider.notifier).clear();
          shell.goBranch(branch, initialLocation: branch == shell.currentIndex);
        },
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home_rounded), label: l.navHome),
          NavigationDestination(icon: const Icon(Icons.public_outlined), selectedIcon: const Icon(Icons.public), label: l.navWorld),
          NavigationDestination(
            icon: Container(
              width: 52,
              height: 40,
              decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(Radii.md)),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            ),
            label: l.navAdd,
            tooltip: l.addTitle,
          ),
          NavigationDestination(icon: const Icon(Icons.lock_outline), selectedIcon: const Icon(Icons.lock), label: l.navVault),
        ],
      ),
    );
  }
}
