import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/errors/app_error.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/buttons.dart';
import '../../core/widgets/components.dart';
import '../../core/widgets/monetization.dart';
import '../../core/widgets/states.dart';
import '../../data/repositories/account_repositories.dart';

class _Turn {
  _Turn(this.question);
  final String question;
  AiAnswer? answer;
  Object? error;
}

/// AI questions over the user's own (and permitted family) data, with sources.
/// History lives only in memory for this session.
class AiAskScreen extends ConsumerStatefulWidget {
  const AiAskScreen({super.key, this.initialQuestion});
  final String? initialQuestion;
  @override
  ConsumerState<AiAskScreen> createState() => _AiAskScreenState();
}

class _AiAskScreenState extends ConsumerState<AiAskScreen> {
  final _c = TextEditingController();
  final _turns = <_Turn>[];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null && widget.initialQuestion!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ask(widget.initialQuestion!));
    }
  }

  Future<void> _ask(String q) async {
    q = q.trim();
    if (q.isEmpty || _busy) return;
    final t = _Turn(q.length > 500 ? q.substring(0, 500) : q);
    setState(() {
      _turns.add(t);
      _busy = true;
      _c.clear();
    });
    try {
      t.answer = await ref.read(aiRepoProvider).ask(t.question);
    } catch (e) {
      t.error = e;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    if (!ent.aiEnabled) return const AiUpgradeScreen();
    final examples = [l.aiExample1, l.aiExample2, l.aiExample3, l.aiExample4];
    return Scaffold(
      appBar: AppBar(title: Text(l.askAi), actions: [
        IconButton(tooltip: l.aiUsage, onPressed: () => context.push('/ai/usage'), icon: const Icon(Icons.data_usage)),
      ]),
      body: Column(children: [
        Expanded(
          child: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
            if (_turns.isEmpty) ...[
              Text(l.aiIntro, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: Space.sm),
              Text(l.aiPrivacyNote, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: Space.lg),
              for (final e in examples) Padding(padding: const EdgeInsets.only(bottom: Space.sm), child: ActionChip(label: Text(e), onPressed: () => _ask(e))),
            ],
            for (final t in _turns) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.only(left: 48, bottom: Space.sm),
                  padding: const EdgeInsets.all(Space.md),
                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(Radii.md)),
                  child: Text(t.question, style: const TextStyle(color: Colors.white)),
                ),
              ),
              AiAnswerCard(turnAnswer: t.answer, error: t.error, loading: t.answer == null && t.error == null),
              const SizedBox(height: Space.lg),
            ],
          ]),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Space.gutter, Space.sm, Space.gutter, Space.md),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: _c,
                  maxLength: 500,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _ask,
                  decoration: InputDecoration(hintText: l.aiHint, counterText: ''),
                ),
              ),
              const SizedBox(width: Space.sm),
              IconButton.filled(tooltip: l.send, onPressed: _busy ? null : () => _ask(_c.text), icon: const Icon(Icons.arrow_upward)),
            ]),
          ),
        ),
      ]),
    );
  }
}

/// AI answer with its sources (screen 68). Shows "not enough data" honestly.
class AiAnswerCard extends StatelessWidget {
  const AiAnswerCard({super.key, required this.turnAnswer, required this.error, required this.loading});
  final AiAnswer? turnAnswer;
  final Object? error;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (loading) {
      return AppCard(child: Row(children: [const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)), const SizedBox(width: Space.md), Text(l.aiThinking)]));
    }
    if (error != null) return AiErrorCard(error: error!);
    final a = turnAnswer!;
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.auto_awesome, size: 18, color: AppColors.secondary),
          const SizedBox(width: Space.sm),
          Text(l.aiAnswer, style: Theme.of(context).textTheme.labelMedium),
        ]),
        const SizedBox(height: Space.sm),
        if (a.insufficientData && (a.answer == null || a.answer!.isEmpty))
          Text(l.aiNoData)
        else
          SelectableText(a.answer ?? l.aiNoData, style: Theme.of(context).textTheme.bodyLarge),
        if (a.insufficientData) Padding(padding: const EdgeInsets.only(top: Space.sm), child: Text(l.aiInsufficientNote, style: Theme.of(context).textTheme.bodySmall)),
        if (a.sources.isNotEmpty) ...[
          const SizedBox(height: Space.md),
          Text(l.sources, style: Theme.of(context).textTheme.labelMedium),
          for (final s in a.sources)
            ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(_iconFor(s.collection), size: 20),
              title: Text(s.title),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(_routeFor(s.collection, s.id)),
            ),
        ],
        const SizedBox(height: Space.xs),
        Text(l.aiVerifyNote, style: Theme.of(context).textTheme.labelSmall),
      ]),
    );
  }

  static IconData _iconFor(String c) => switch (c) {
        'documents' => Icons.description_outlined,
        'assets' => Icons.chair_outlined,
        'vehicles' || 'vehicleRecords' => Icons.directions_car_outlined,
        'reminders' => Icons.alarm,
        'walletCards' => Icons.loyalty_outlined,
        'businessCards' => Icons.badge_outlined,
        _ => Icons.link,
      };

  static String _routeFor(String c, String id) => switch (c) {
        'documents' => '/documents/$id',
        'assets' => '/assets/$id',
        'vehicles' => '/vehicles/$id',
        'vehicleRecords' => '/vehicle-records/$id/edit',
        'reminders' => '/reminders/$id',
        'walletCards' => '/cards/$id',
        'businessCards' => '/business-cards/$id',
        _ => '/home',
      };
}

/// AI error state (screen 89): explains what happened, never loses data.
class AiErrorCard extends StatelessWidget {
  const AiErrorCard({super.key, required this.error});
  final Object error;
  @override
  Widget build(BuildContext context) {
    final code = AppError.from(error).code;
    return AppCard(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: Space.sm),
          Expanded(child: Text(errorMessage(context, error))),
        ]),
        if (code == AppErrorCode.aiLimit) TextButton(onPressed: () => context.push('/ai/usage'), child: Text(context.l10n.aiUsage)),
        if (code == AppErrorCode.aiNotInPlan) const UpgradePrompt(reason: UpgradeReason.ai, compact: true),
      ]),
    );
  }
}

class AiUsageScreen extends ConsumerWidget {
  const AiUsageScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final ent = ref.watch(entitlementValueProvider);
    final uid = ref.watch(uidProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.aiUsage)),
      body: uid == null
          ? const LoadingState()
          : StreamBuilder<Map<String, dynamic>?>(
              stream: ref.read(entitlementRepoProvider).watchAiBudget(uid, DateTime.now()),
              builder: (context, snap) {
                final used = (snap.data?['requests'] as num?)?.toInt() ?? 0;
                final limit = ent.aiMonthlyRequests;
                final ratio = limit == 0 ? 0.0 : (used / limit).clamp(0, 1).toDouble();
                return ListView(padding: const EdgeInsets.all(Space.gutter), children: [
                  PlanBadge(plan: ent.planId),
                  const SizedBox(height: Space.lg),
                  AppCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(l.aiRequestsThisMonth, style: Theme.of(context).textTheme.labelMedium),
                      Text('$used / $limit', style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: Space.sm),
                      LinearProgressIndicator(value: ratio, minHeight: 6, color: ratio > 0.9 ? AppColors.error : AppColors.accent),
                      const SizedBox(height: Space.sm),
                      Text(l.aiLimitsNote, style: Theme.of(context).textTheme.bodySmall),
                    ]),
                  ),
                  const SizedBox(height: Space.lg),
                  Text(l.aiDataNote, style: Theme.of(context).textTheme.bodySmall),
                ]);
              },
            ),
    );
  }
}

class AiUpgradeScreen extends StatelessWidget {
  const AiUpgradeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.askAi)),
      body: ListView(padding: const EdgeInsets.all(Space.gutter), children: [
        const UpgradePrompt(reason: UpgradeReason.ai),
        const SizedBox(height: Space.lg),
        for (final e in [l.aiExample1, l.aiExample2, l.aiExample3]) ListTile(leading: const Icon(Icons.chat_bubble_outline), title: Text(e)),
        const SizedBox(height: Space.lg),
        Text(l.appWorksWithoutAi, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: Space.md),
        SecondaryButton(label: l.useRegularSearch, onPressed: () => context.pushReplacement('/search')),
      ]),
    );
  }
}
