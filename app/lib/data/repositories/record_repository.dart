import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/models/common.dart';
import '../firestore_codec.dart';

/// Generic repository for privacy-aware collections (documents, assets,
/// vehicles, records, reminders, wallet cards, business cards).
///
/// Reading uses exactly the three query shapes allowed by firestore.rules:
///   1. my own records,
///   2. family-level records of my active family,
///   3. records explicitly shared with me in my active family.
class RecordRepository<T extends OwnedRecord> {
  RecordRepository(this._db, this.collection, this._fromMap);

  final FirebaseFirestore _db;
  final String collection;
  final T Function(String id, Map<String, dynamic> data) _fromMap;

  CollectionReference<Map<String, dynamic>> get _col => _db.collection(collection);

  String newId() => _col.doc().id;

  Stream<List<T>> _query(Query<Map<String, dynamic>> q, {bool tolerant = false}) {
    final s = q.snapshots().map((s) => s.docs.map((d) => _fromMap(d.id, decode(d.data()))).toList());
    if (!tolerant) return s;
    // Family queries are denied right after leaving/removal; treat as "nothing shared".
    return s.transform(StreamTransformer.fromHandlers(handleError: (_, _, sink) => sink.add(<T>[])));
  }

  Stream<List<T>> watchAccessible(String uid, String? familyId) {
    final sources = <Stream<List<T>>>[_query(_col.where('ownerUid', isEqualTo: uid))];
    if (familyId != null) {
      sources.add(_query(_col.where('familyId', isEqualTo: familyId).where('privacyLevel', isEqualTo: 'family'),
          tolerant: true));
      sources.add(_query(
          _col
              .where('familyId', isEqualTo: familyId)
              .where('privacyLevel', isEqualTo: 'shared')
              .where('sharedWith', arrayContains: uid),
          tolerant: true));
    }
    return combineQueries(sources, (r) => r.id);
  }

  Stream<T?> watch(String id) =>
      _col.doc(id).snapshots().map((s) => s.exists ? _fromMap(s.id, decode(s.data()!)) : null);

  Future<T?> get(String id) async {
    final s = await _col.doc(id).get();
    return s.exists ? _fromMap(s.id, decode(s.data()!)) : null;
  }

  /// Create or update. createdAt is only written on create (rules keep it immutable).
  Future<void> save(T record, {bool isNew = false}) async {
    final data = encode(record.toMap())..['updatedAt'] = FieldValue.serverTimestamp();
    if (isNew) {
      data['createdAt'] = FieldValue.serverTimestamp();
      await _col.doc(record.id).set(data);
    } else {
      await _col.doc(record.id).set(data, SetOptions(merge: true));
    }
  }

  Future<void> patch(String id, Map<String, dynamic> fields) =>
      _col.doc(id).update(encode(fields)..['updatedAt'] = FieldValue.serverTimestamp());

  Future<void> delete(String id) => _col.doc(id).delete();
}
