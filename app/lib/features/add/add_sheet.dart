import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../core/theme/tokens.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/monetization.dart';

/// Where the user pressed Add — options and defaults adapt to it.
class AddContext {
  const AddContext({this.area, this.entityId, this.profileId, this.vault = false});
  final String? area; // home | hobby | car | family | life | cards | business | documents
  final String? entityId; // e.g. a vehicle or asset id
  final String? profileId; // family profile
  final bool vault;

  Map<String, String> get query => {
        'area': ?area,
        'link': ?entityId,
        'profile': ?profileId,
        if (vault) 'vault': '1',
      };
}

/// Current Add context, set by screens (My Car, a member profile, Vault…).
class AddContextNotifier extends Notifier<AddContext> {
  @override
  AddContext build() => const AddContext();
  void set(AddContext c) => state = c;
  void clear() => state = const AddContext();
}

final addContextProvider = NotifierProvider<AddContextNotifier, AddContext>(AddContextNotifier.new);

Future<void> showAddSheet(BuildContext context, WidgetRef ref) {
  final ctx = ref.read(addContextProvider);
  final ent = ref.read(entitlementValueProvider);
  final l = context.l10n;
  String q(String base, [Map<String, String> extra = const {}]) => Uri(path: base, queryParameters: {...ctx.query, ...extra}).toString();

  final items = <_AddItem>[
    if (ctx.area == 'car' && ctx.entityId != null)
      _AddItem(Icons.build_circle_outlined, l.addServiceRecord, l.addServiceRecordHint, () => context.push('/vehicles/${ctx.entityId}/records/new')),
    _AddItem(Icons.document_scanner_outlined, l.addScan, l.addScanHint, () => context.push(q('/scan', {'mode': 'scan'}))),
    _AddItem(Icons.photo_camera_outlined, l.addPhoto, l.addPhotoHint, () => context.push(q('/scan', {'mode': 'photo'}))),
    _AddItem(Icons.picture_as_pdf_outlined, l.addPdf, l.addPdfHint, () => context.push(q('/scan', {'mode': 'pdf'}))),
    _AddItem(Icons.image_outlined, l.addImage, l.addImageHint, () => context.push(q('/scan', {'mode': 'image'}))),
    _AddItem(Icons.chair_outlined, l.addItem, l.addItemHint,
        () => context.push('/assets/new?area=${ctx.area == 'hobby' ? 'hobby' : ctx.area == 'life' ? 'life' : 'home'}')),
    _AddItem(Icons.notifications_active_outlined, l.addReminder, l.addReminderHint,
        () => context.push(Uri(path: '/reminders/new', queryParameters: {'link': ?ctx.entityId}).toString())),
    _AddItem(Icons.directions_car_outlined, l.addVehicleRecord, l.addVehicleRecordHint,
        () => context.push(ctx.area == 'car' && ctx.entityId != null ? '/vehicles/${ctx.entityId}/records/new' : '/car?pick=record')),
    _AddItem(Icons.loyalty_outlined, l.addWalletCard, l.addWalletCardHint, () => context.push('/cards/new')),
    _AddItem(Icons.contact_mail_outlined, l.addBusinessCard, l.addBusinessCardHint, () => context.push('/business-cards/new')),
    if (ent.isFamilyPlan)
      _AddItem(Icons.person_add_alt_1_outlined, l.addFamilyMember, l.addFamilyMemberHint, () => context.push('/family/profile/new'))
    else
      _AddItem(Icons.person_add_alt_1_outlined, l.addFamilyMember, l.familyPlanOnly, () => showUpgradeSheet(context, UpgradeReason.family), locked: true),
  ];

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (sheet) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.lg),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Space.sm, bottom: Space.sm),
              child: Text(l.addTitle, style: Theme.of(context).textTheme.titleLarge),
            ),
            for (final i in items)
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(Radii.sm)),
                  child: Icon(i.icon, color: AppColors.secondary),
                ),
                title: Text(i.title),
                subtitle: Text(i.subtitle),
                trailing: i.locked ? const Icon(Icons.lock_outline, size: 18) : null,
                onTap: () {
                  Navigator.pop(sheet);
                  i.onTap();
                },
              ),
          ],
        ),
      ),
    ),
  );
}

class _AddItem {
  _AddItem(this.icon, this.title, this.subtitle, this.onTap, {this.locked = false});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool locked;
}
