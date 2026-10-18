import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/ai/ai_screens.dart';
import '../features/ai/extraction_review_screen.dart';
import '../features/assets/asset_screens.dart';
import '../features/auth/auth_screens.dart';
import '../features/business_cards/business_card_screens.dart';
import '../features/cards/card_screens.dart';
import '../features/documents/document_screens.dart';
import '../features/family/family_screens.dart';
import '../features/home/home_screen.dart';
import '../features/reminders/reminder_screens.dart';
import '../features/scanner/scan_screens.dart';
import '../features/search/search_screen.dart';
import '../features/settings/settings_screens.dart';
import '../features/subscriptions/subscription_screens.dart';
import '../features/vault/vault_screens.dart';
import '../features/vehicles/vehicle_screens.dart';
import '../features/world/world_screen.dart';
import '../domain/models/entities.dart';
import 'providers.dart';
import 'shell.dart';

/// Pending invitation captured from a deep link before sign-in.
class PendingInvite extends Notifier<Uri?> {
  @override
  Uri? build() => null;
  void set(Uri? u) => state = u;
}

final pendingInviteProvider = NotifierProvider<PendingInvite, Uri?>(PendingInvite.new);

final onboardingSeenProvider = FutureProvider<bool>((_) => onboardingSeen());

/// Re-evaluates redirects when auth/profile change.
class _RouterRefresh extends ChangeNotifier {
  void ping() => notifyListeners();
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh();
  ref.listen(authUserProvider, (_, _) => refresh.ping());
  ref.listen(userProfileProvider, (_, _) => refresh.ping());
  ref.listen(onboardingSeenProvider, (_, _) => refresh.ping());
  ref.onDispose(refresh.dispose);

  Widget page(GoRouterState s, Widget Function(Map<String, String> q) b) => b(s.uri.queryParameters);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    errorBuilder: (_, s) => GenericErrorScreen(error: s.error),
    redirect: (context, state) {
      final auth = ref.read(authUserProvider);
      final loc = state.matchedLocation;
      if (auth.isLoading) return loc == '/splash' ? null : '/splash';
      final user = auth.value;
      final public = loc.startsWith('/auth') || loc == '/onboarding' || loc == '/settings/legal';

      if (loc == '/invite') {
        if (user == null) {
          ref.read(pendingInviteProvider.notifier).set(state.uri);
          return '/auth/sign-in';
        }
        return null;
      }

      if (user == null) {
        final seen = ref.read(onboardingSeenProvider).value;
        if (seen == null) return loc == '/splash' ? null : '/splash';
        if (public) return null;
        return seen ? '/auth/sign-in' : '/onboarding';
      }

      final usesPassword = user.providerData.any((p) => p.providerId == 'password');
      if (usesPassword && !user.emailVerified) return loc == '/auth/verify' ? null : '/auth/verify';

      final profileAsync = ref.read(userProfileProvider);
      if (profileAsync.isLoading && profileAsync.value == null) return loc == '/splash' ? null : '/splash';
      final profile = profileAsync.value;
      if (profile == null || !profile.onboardingCompleted) return loc == '/profile-setup' ? null : '/profile-setup';

      final pending = ref.read(pendingInviteProvider);
      if (pending != null) {
        ref.read(pendingInviteProvider.notifier).set(null);
        return pending.toString();
      }
      if (public || loc == '/splash' || loc == '/profile-setup') return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: '/auth/sign-in', builder: (_, _) => const SignInScreen()),
      GoRoute(path: '/auth/sign-up', builder: (_, _) => const SignInScreen(signUp: true)),
      GoRoute(path: '/auth/reset', builder: (_, _) => const ResetPasswordScreen()),
      GoRoute(path: '/auth/verify', builder: (_, _) => const VerifyEmailScreen()),
      GoRoute(path: '/profile-setup', builder: (_, _) => const ProfileSetupScreen()),
      GoRoute(path: '/session-expired', builder: (_, _) => const SessionExpiredScreen()),

      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(routes: [GoRoute(path: '/home', builder: (_, _) => const HomeScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/world', builder: (_, _) => const WorldScreen())]),
          StatefulShellBranch(routes: [GoRoute(path: '/vault', builder: (_, _) => const VaultScreen())]),
        ],
      ),

      GoRoute(path: '/search', builder: (_, _) => const GlobalSearchScreen()),
      GoRoute(path: '/notifications', builder: (_, _) => const NotificationsScreen()),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsScreen()),
      GoRoute(path: '/settings/privacy', builder: (_, _) => const PrivacySettingsScreen()),
      GoRoute(path: '/settings/reminders', builder: (_, _) => const ReminderSettingsScreen()),
      GoRoute(path: '/settings/vault', builder: (_, _) => const VaultSettingsScreen()),
      GoRoute(path: '/settings/export', builder: (_, _) => const ExportDataScreen()),
      GoRoute(path: '/settings/delete-account', builder: (_, _) => const DeleteAccountScreen()),
      GoRoute(path: '/settings/legal', builder: (_, _) => const LegalScreen()),
      GoRoute(path: '/settings/help', builder: (_, _) => const HelpScreen()),

      // Documents & scanner
      GoRoute(
        path: '/scan',
        builder: (_, s) => page(s, (q) => ScanFlowScreen(mode: q['mode'] ?? 'scan', area: q['area'], link: q['link'], profile: q['profile'], vault: q['vault'] == '1')),
      ),
      GoRoute(path: '/documents', builder: (_, _) => const MyDocumentsScreen()),
      GoRoute(
        path: '/documents/list',
        builder: (_, s) => page(s, (q) => DocumentListScreen(categoryId: q['category'], favorites: q['favorites'] == '1', trash: q['trash'] == '1', linkedEntityId: q['link'])),
      ),
      GoRoute(path: '/documents/recent', builder: (_, _) => const DocumentListScreen(recent: true)),
      GoRoute(path: '/documents/:id', builder: (_, s) => DocumentDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/documents/:id/preview', builder: (_, s) => DocumentPreviewScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/documents/:id/edit', builder: (_, s) => EditDocumentScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/documents/:id/sharing', builder: (_, s) => DocumentSharingScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/documents/:id/links', builder: (_, s) => DocumentLinksScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/documents/:id/review', builder: (_, s) => ExtractionReviewScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/storage', builder: (_, _) => const StorageUsageScreen()),

      // My Home / My Hobby
      GoRoute(path: '/home-area', builder: (_, _) => const AssetAreaDashboard(area: ItemArea.home)),
      GoRoute(path: '/hobby', builder: (_, _) => const AssetAreaDashboard(area: ItemArea.hobby)),
      GoRoute(path: '/assets/list', builder: (_, s) => page(s, (q) => AssetListScreen(area: areaFrom(q['area']), category: q['category']))),
      GoRoute(path: '/assets/new', builder: (_, s) => page(s, (q) => EditAssetScreen(area: areaFrom(q['area']), category: q['category']))),
      GoRoute(path: '/assets/:id', builder: (_, s) => AssetDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/assets/:id/edit', builder: (_, s) => EditAssetScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/assets/:id/warranty', builder: (_, s) => WarrantyDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/assets/:id/maintenance', builder: (_, s) => MaintenanceHistoryScreen(id: s.pathParameters['id']!)),

      // My Family
      GoRoute(path: '/family', builder: (_, _) => const FamilyDashboard()),
      GoRoute(path: '/family/members', builder: (_, _) => const FamilyMembersScreen()),
      GoRoute(path: '/family/member/:uid', builder: (_, s) => MemberProfileScreen(uid: s.pathParameters['uid']!)),
      GoRoute(path: '/family/profile/new', builder: (_, _) => const EditFamilyProfileScreen()),
      GoRoute(path: '/family/profile/:id', builder: (_, s) => FamilyProfileScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/family/profile/:id/edit', builder: (_, s) => EditFamilyProfileScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/family/invite', builder: (_, _) => const InviteMemberScreen()),
      GoRoute(path: '/family/permissions', builder: (_, _) => const FamilyPermissionsScreen()),
      GoRoute(path: '/family/shared', builder: (_, _) => const SharedDocumentsScreen()),
      GoRoute(path: '/family/settings', builder: (_, _) => const FamilySettingsScreen()),
      GoRoute(path: '/family/leave', builder: (_, _) => const LeaveFamilyScreen()),
      GoRoute(path: '/family/remove/:uid', builder: (_, s) => RemoveMemberScreen(uid: s.pathParameters['uid']!)),
      GoRoute(path: '/invite', builder: (_, s) => page(s, (q) => InvitationAcceptanceScreen(invitationId: q['i'] ?? '', token: q['t'] ?? ''))),

      // My Car
      GoRoute(path: '/car', builder: (_, s) => VehiclesDashboard(pickForRecord: s.uri.queryParameters['pick'] == 'record')),
      GoRoute(path: '/vehicles/new', builder: (_, _) => const EditVehicleScreen()),
      GoRoute(path: '/vehicles/:id', builder: (_, s) => VehicleDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/vehicles/:id/edit', builder: (_, s) => EditVehicleScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/vehicles/:id/records', builder: (_, s) => VehicleRecordsScreen(id: s.pathParameters['id']!)),
      GoRoute(
        path: '/vehicles/:id/records/new',
        builder: (_, s) => EditVehicleRecordScreen(vehicleId: s.pathParameters['id']!, initialType: s.uri.queryParameters['type'] == null ? null : recordTypeFrom(s.uri.queryParameters['type'])),
      ),
      GoRoute(path: '/vehicle-records/:rid/edit', builder: (_, s) => EditVehicleRecordScreen(recordId: s.pathParameters['rid']!)),
      GoRoute(path: '/vehicles/:id/expenses', builder: (_, s) => ExpenseOverviewScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/vehicles/:id/registration', builder: (_, s) => RegistrationInsuranceScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/vehicles/:id/mileage', builder: (_, s) => MileageHistoryScreen(id: s.pathParameters['id']!)),

      // My Life & reminders
      GoRoute(path: '/life', builder: (_, _) => const RemindersDashboard(lifeMode: true)),
      GoRoute(path: '/reminders', builder: (_, _) => const RemindersDashboard()),
      GoRoute(path: '/reminders/upcoming', builder: (_, _) => const UpcomingDeadlinesScreen()),
      GoRoute(path: '/reminders/new', builder: (_, s) => EditReminderScreen(prefill: s.uri.queryParameters)),
      GoRoute(path: '/reminders/:id', builder: (_, s) => ReminderDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/reminders/:id/edit', builder: (_, s) => EditReminderScreen(id: s.pathParameters['id']!)),

      // My Cards & Business Cards
      GoRoute(path: '/cards', builder: (_, _) => const CardsScreen()),
      GoRoute(path: '/cards/new', builder: (_, _) => const EditCardScreen()),
      GoRoute(path: '/cards/:id', builder: (_, s) => CardDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/cards/:id/edit', builder: (_, s) => EditCardScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/business-cards', builder: (_, _) => const BusinessCardsScreen()),
      GoRoute(path: '/business-cards/new', builder: (_, _) => const EditBusinessCardScreen()),
      GoRoute(path: '/business-cards/:id', builder: (_, s) => BusinessCardDetailScreen(id: s.pathParameters['id']!)),
      GoRoute(path: '/business-cards/:id/edit', builder: (_, s) => EditBusinessCardScreen(id: s.pathParameters['id']!)),

      // AI
      GoRoute(path: '/ai', builder: (_, s) => AiAskScreen(initialQuestion: s.uri.queryParameters['q'])),
      GoRoute(path: '/ai/usage', builder: (_, _) => const AiUsageScreen()),
      GoRoute(path: '/ai/upgrade', builder: (_, _) => const AiUpgradeScreen()),

      // Plans
      GoRoute(path: '/plans', builder: (_, _) => const PlansScreen()),
      GoRoute(path: '/subscription', builder: (_, _) => const ManageSubscriptionScreen()),
    ],
  );
});
