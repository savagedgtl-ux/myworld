import 'package:flutter/material.dart';

/// Built-in taxonomy. Labels are localized data (sr/en) rather than widget
/// strings; add a locale by adding a field.
class Label {
  const Label(this.sr, this.en);
  final String sr;
  final String en;
  String of(Locale l) => l.languageCode == 'en' ? en : sr;
}

class CategoryDef {
  const CategoryDef(this.id, this.label, this.icon);
  final String id;
  final Label label;
  final IconData icon;
}

abstract final class Categories {
  static const documents = <CategoryDef>[
    CategoryDef('personal', Label('Lična dokumenta', 'Personal documents'), Icons.badge_outlined),
    CategoryDef('contracts', Label('Ugovori', 'Contracts'), Icons.handshake_outlined),
    CategoryDef('receipts', Label('Računi', 'Receipts'), Icons.receipt_long_outlined),
    CategoryDef('warranties', Label('Garancije', 'Warranties'), Icons.verified_outlined),
    CategoryDef('insurance', Label('Osiguranje', 'Insurance'), Icons.shield_outlined),
    CategoryDef('finance', Label('Banka i finansije', 'Banking & finance'), Icons.account_balance_outlined),
    CategoryDef('health', Label('Zdravlje', 'Health'), Icons.favorite_border),
    CategoryDef('education', Label('Obrazovanje', 'Education'), Icons.school_outlined),
    CategoryDef('work', Label('Posao', 'Work'), Icons.work_outline),
    CategoryDef('property', Label('Nekretnine', 'Property'), Icons.house_outlined),
    CategoryDef('family', Label('Porodična dokumenta', 'Family documents'), Icons.family_restroom),
    CategoryDef('vehicle', Label('Vozila', 'Vehicles'), Icons.directions_car_outlined),
    CategoryDef('other', Label('Ostalo', 'Other'), Icons.folder_outlined),
  ];

  static const home = <CategoryDef>[
    CategoryDef('appliances', Label('Kućni aparati', 'Appliances'), Icons.local_laundry_service_outlined),
    CategoryDef('electronics', Label('Elektronika', 'Electronics'), Icons.devices_other_outlined),
    CategoryDef('furniture', Label('Nameštaj', 'Furniture'), Icons.chair_outlined),
    CategoryDef('kitchen', Label('Kuhinja', 'Kitchen'), Icons.kitchen_outlined),
    CategoryDef('tools', Label('Alati', 'Tools'), Icons.handyman_outlined),
    CategoryDef('equipment', Label('Kućna oprema', 'Home equipment'), Icons.home_repair_service_outlined),
    CategoryDef('valuables', Label('Vredni predmeti', 'Valuables'), Icons.diamond_outlined),
    CategoryDef('clothing', Label('Garderoba i lične stvari', 'Clothing & personal'), Icons.checkroom_outlined),
    CategoryDef('other', Label('Drugi predmeti', 'Other items'), Icons.category_outlined),
  ];

  static const hobby = <CategoryDef>[
    CategoryDef('photo', Label('Foto-oprema', 'Photo gear'), Icons.photo_camera_outlined),
    CategoryDef('bikes', Label('Bicikli', 'Bikes'), Icons.pedal_bike_outlined),
    CategoryDef('sport', Label('Sportska oprema', 'Sports gear'), Icons.sports_tennis_outlined),
    CategoryDef('music', Label('Muzički instrumenti', 'Instruments'), Icons.music_note_outlined),
    CategoryDef('books', Label('Knjige', 'Books'), Icons.menu_book_outlined),
    CategoryDef('collections', Label('Kolekcije', 'Collections'), Icons.collections_bookmark_outlined),
    CategoryDef('camping', Label('Kamp oprema', 'Camping'), Icons.forest_outlined),
    CategoryDef('gaming', Label('Gejming', 'Gaming'), Icons.sports_esports_outlined),
    CategoryDef('other', Label('Drugi hobiji', 'Other hobbies'), Icons.interests_outlined),
  ];

  static const vault = <CategoryDef>[
    CategoryDef('personal', Label('Lična dokumenta', 'Personal documents'), Icons.badge_outlined),
    CategoryDef('contracts', Label('Ugovori', 'Contracts'), Icons.handshake_outlined),
    CategoryDef('insurance', Label('Polise', 'Policies'), Icons.shield_outlined),
    CategoryDef('education', Label('Obrazovanje', 'Education'), Icons.school_outlined),
    CategoryDef('certificates', Label('Potvrde', 'Certificates'), Icons.workspace_premium_outlined),
    CategoryDef('family', Label('Dokumenti članova porodice', 'Family members'), Icons.family_restroom),
    CategoryDef('other', Label('Drugi privatni fajlovi', 'Other private files'), Icons.lock_outline),
  ];

  static CategoryDef? find(List<CategoryDef> list, String? id) {
    for (final c in list) {
      if (c.id == id) return c;
    }
    return null;
  }

  static String labelFor(BuildContext context, String? id, {List<CategoryDef> list = documents}) {
    final l = Localizations.localeOf(context);
    return find(list, id)?.label.of(l) ?? id ?? '';
  }
}
