import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Converts Firestore values into plain Dart (Timestamp -> DateTime) so the
/// domain layer never depends on Firebase types.
Map<String, dynamic> decode(Map<String, dynamic> m) => m.map((k, v) => MapEntry(k, _decode(v)));

Object? _decode(Object? v) {
  if (v is Timestamp) return v.toDate();
  if (v is Map) return v.map((k, x) => MapEntry('$k', _decode(x)));
  if (v is List) return v.map(_decode).toList();
  return v;
}

/// Converts plain Dart values for writing (DateTime -> Timestamp).
Map<String, dynamic> encode(Map<String, dynamic> m) => m.map((k, v) => MapEntry(k, _encode(v)));

Object? _encode(Object? v) {
  if (v is DateTime) return Timestamp.fromDate(v);
  if (v is Map) return v.map((k, x) => MapEntry('$k', _encode(x)));
  if (v is List) return v.map(_encode).toList();
  return v;
}

/// Combines several query streams into one de-duplicated list stream.
/// Emits once every source has emitted at least once.
Stream<List<T>> combineQueries<T>(List<Stream<List<T>>> sources, String Function(T) idOf) {
  if (sources.length == 1) return sources.first;
  late StreamController<List<T>> controller;
  final latest = List<List<T>?>.filled(sources.length, null);
  final subs = <StreamSubscription<List<T>>>[];

  void emit() {
    if (latest.any((l) => l == null)) return;
    final seen = <String>{};
    final out = <T>[];
    for (final list in latest) {
      for (final item in list!) {
        if (seen.add(idOf(item))) out.add(item);
      }
    }
    controller.add(out);
  }

  controller = StreamController<List<T>>(
    onListen: () {
      for (var i = 0; i < sources.length; i++) {
        subs.add(sources[i].listen((v) {
          latest[i] = v;
          emit();
        }, onError: controller.addError));
      }
    },
    onCancel: () async {
      for (final s in subs) {
        await s.cancel();
      }
    },
  );
  return controller.stream;
}
