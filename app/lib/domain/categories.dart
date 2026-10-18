import 'package:flutter/material.dart';

/// Built-in taxonomy. Labels are localized data rather than widget strings;
/// add a locale by adding a field.
class Label {
  const Label(this.sr, this.en, {required this.de, required this.fr, required this.es, required this.ru});
  final String sr;
  final String en;
  final String de;
  final String fr;
  final String es;
  final String ru;
  String of(Locale l) => switch (l.languageCode) {
        'en' => en,
        'de' => de,
        'fr' => fr,
        'es' => es,
        'ru' => ru,
        _ => sr,
      };
}

class CategoryDef {
  const CategoryDef(this.id, this.label, this.icon);
  final String id;
  final Label label;
  final IconData icon;
}

abstract final class Categories {
  static const documents = <CategoryDef>[
    CategoryDef('personal', Label('Lična dokumenta', 'Personal documents', de: 'Persönliche Dokumente', fr: 'Documents personnels', es: 'Documentos personales', ru: 'Личные документы'), Icons.badge_outlined),
    CategoryDef('contracts', Label('Ugovori', 'Contracts', de: 'Verträge', fr: 'Contrats', es: 'Contratos', ru: 'Договоры'), Icons.handshake_outlined),
    CategoryDef('receipts', Label('Računi', 'Receipts', de: 'Belege', fr: 'Reçus', es: 'Recibos', ru: 'Чеки'), Icons.receipt_long_outlined),
    CategoryDef('warranties', Label('Garancije', 'Warranties', de: 'Garantien', fr: 'Garanties', es: 'Garantías', ru: 'Гарантии'), Icons.verified_outlined),
    CategoryDef('insurance', Label('Osiguranje', 'Insurance', de: 'Versicherung', fr: 'Assurance', es: 'Seguros', ru: 'Страхование'), Icons.shield_outlined),
    CategoryDef('finance', Label('Banka i finansije', 'Banking & finance', de: 'Bank & Finanzen', fr: 'Banque et finances', es: 'Banca y finanzas', ru: 'Банк и финансы'), Icons.account_balance_outlined),
    CategoryDef('health', Label('Zdravlje', 'Health', de: 'Gesundheit', fr: 'Santé', es: 'Salud', ru: 'Здоровье'), Icons.favorite_border),
    CategoryDef('education', Label('Obrazovanje', 'Education', de: 'Bildung', fr: 'Éducation', es: 'Educación', ru: 'Образование'), Icons.school_outlined),
    CategoryDef('work', Label('Posao', 'Work', de: 'Arbeit', fr: 'Travail', es: 'Trabajo', ru: 'Работа'), Icons.work_outline),
    CategoryDef('property', Label('Nekretnine', 'Property', de: 'Immobilien', fr: 'Immobilier', es: 'Inmuebles', ru: 'Недвижимость'), Icons.house_outlined),
    CategoryDef('family', Label('Porodična dokumenta', 'Family documents', de: 'Familiendokumente', fr: 'Documents familiaux', es: 'Documentos familiares', ru: 'Семейные документы'), Icons.family_restroom),
    CategoryDef('vehicle', Label('Vozila', 'Vehicles', de: 'Fahrzeuge', fr: 'Véhicules', es: 'Vehículos', ru: 'Автомобили'), Icons.directions_car_outlined),
    CategoryDef('other', Label('Ostalo', 'Other', de: 'Sonstiges', fr: 'Autres', es: 'Otros', ru: 'Другое'), Icons.folder_outlined),
  ];

  static const home = <CategoryDef>[
    CategoryDef('appliances', Label('Kućni aparati', 'Appliances', de: 'Haushaltsgeräte', fr: 'Électroménager', es: 'Electrodomésticos', ru: 'Бытовая техника'), Icons.local_laundry_service_outlined),
    CategoryDef('electronics', Label('Elektronika', 'Electronics', de: 'Elektronik', fr: 'Électronique', es: 'Electrónica', ru: 'Электроника'), Icons.devices_other_outlined),
    CategoryDef('furniture', Label('Nameštaj', 'Furniture', de: 'Möbel', fr: 'Mobilier', es: 'Muebles', ru: 'Мебель'), Icons.chair_outlined),
    CategoryDef('kitchen', Label('Kuhinja', 'Kitchen', de: 'Küche', fr: 'Cuisine', es: 'Cocina', ru: 'Кухня'), Icons.kitchen_outlined),
    CategoryDef('tools', Label('Alati', 'Tools', de: 'Werkzeug', fr: 'Outils', es: 'Herramientas', ru: 'Инструменты'), Icons.handyman_outlined),
    CategoryDef('equipment', Label('Kućna oprema', 'Home equipment', de: 'Haushaltsausstattung', fr: 'Équipement de la maison', es: 'Equipamiento del hogar', ru: 'Оборудование для дома'), Icons.home_repair_service_outlined),
    CategoryDef('valuables', Label('Vredni predmeti', 'Valuables', de: 'Wertgegenstände', fr: 'Objets de valeur', es: 'Objetos de valor', ru: 'Ценные вещи'), Icons.diamond_outlined),
    CategoryDef('clothing', Label('Garderoba i lične stvari', 'Clothing & personal', de: 'Kleidung & Persönliches', fr: 'Vêtements et effets personnels', es: 'Ropa y objetos personales', ru: 'Одежда и личные вещи'), Icons.checkroom_outlined),
    CategoryDef('other', Label('Drugi predmeti', 'Other items', de: 'Sonstige Gegenstände', fr: 'Autres objets', es: 'Otros objetos', ru: 'Другие вещи'), Icons.category_outlined),
  ];

  static const hobby = <CategoryDef>[
    CategoryDef('photo', Label('Foto-oprema', 'Photo gear', de: 'Fotoausrüstung', fr: 'Matériel photo', es: 'Equipo fotográfico', ru: 'Фототехника'), Icons.photo_camera_outlined),
    CategoryDef('bikes', Label('Bicikli', 'Bikes', de: 'Fahrräder', fr: 'Vélos', es: 'Bicicletas', ru: 'Велосипеды'), Icons.pedal_bike_outlined),
    CategoryDef('sport', Label('Sportska oprema', 'Sports gear', de: 'Sportausrüstung', fr: 'Équipement sportif', es: 'Material deportivo', ru: 'Спортивный инвентарь'), Icons.sports_tennis_outlined),
    CategoryDef('music', Label('Muzički instrumenti', 'Instruments', de: 'Musikinstrumente', fr: 'Instruments de musique', es: 'Instrumentos musicales', ru: 'Музыкальные инструменты'), Icons.music_note_outlined),
    CategoryDef('books', Label('Knjige', 'Books', de: 'Bücher', fr: 'Livres', es: 'Libros', ru: 'Книги'), Icons.menu_book_outlined),
    CategoryDef('collections', Label('Kolekcije', 'Collections', de: 'Sammlungen', fr: 'Collections', es: 'Colecciones', ru: 'Коллекции'), Icons.collections_bookmark_outlined),
    CategoryDef('camping', Label('Kamp oprema', 'Camping', de: 'Camping', fr: 'Camping', es: 'Camping', ru: 'Кемпинг'), Icons.forest_outlined),
    CategoryDef('gaming', Label('Gejming', 'Gaming', de: 'Gaming', fr: 'Jeux vidéo', es: 'Videojuegos', ru: 'Игры'), Icons.sports_esports_outlined),
    CategoryDef('other', Label('Drugi hobiji', 'Other hobbies', de: 'Andere Hobbys', fr: 'Autres loisirs', es: 'Otras aficiones', ru: 'Другие хобби'), Icons.interests_outlined),
  ];

  static const vault = <CategoryDef>[
    CategoryDef('personal', Label('Lična dokumenta', 'Personal documents', de: 'Persönliche Dokumente', fr: 'Documents personnels', es: 'Documentos personales', ru: 'Личные документы'), Icons.badge_outlined),
    CategoryDef('contracts', Label('Ugovori', 'Contracts', de: 'Verträge', fr: 'Contrats', es: 'Contratos', ru: 'Договоры'), Icons.handshake_outlined),
    CategoryDef('insurance', Label('Polise', 'Policies', de: 'Policen', fr: 'Polices', es: 'Pólizas', ru: 'Полисы'), Icons.shield_outlined),
    CategoryDef('education', Label('Obrazovanje', 'Education', de: 'Bildung', fr: 'Éducation', es: 'Educación', ru: 'Образование'), Icons.school_outlined),
    CategoryDef('certificates', Label('Potvrde', 'Certificates', de: 'Bescheinigungen', fr: 'Certificats', es: 'Certificados', ru: 'Справки'), Icons.workspace_premium_outlined),
    CategoryDef('family', Label('Dokumenti članova porodice', 'Family members', de: 'Familienmitglieder', fr: 'Membres de la famille', es: 'Miembros de la familia', ru: 'Члены семьи'), Icons.family_restroom),
    CategoryDef('other', Label('Drugi privatni fajlovi', 'Other private files', de: 'Sonstige private Dateien', fr: 'Autres fichiers privés', es: 'Otros archivos privados', ru: 'Другие личные файлы'), Icons.lock_outline),
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
