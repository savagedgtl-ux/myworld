import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../core/errors/app_error.dart';
import '../../domain/models/account.dart';
import '../../domain/models/entities.dart';
import '../../services/functions_service.dart';
import '../firestore_codec.dart';

class UserRepository {
  UserRepository(this._db);
  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _ref(String uid) => _db.collection('users').doc(uid);

  Stream<UserProfile?> watch(String uid) =>
      _ref(uid).snapshots().map((s) => s.exists ? UserProfile.fromMap(uid, decode(s.data()!)) : null);

  /// Only client-editable fields (rules reject everything else).
  Future<void> updateProfile(String uid, {String? displayName, String? photoUrl, String? language, String? region, bool? onboardingCompleted, String? notificationPreview}) async {
    final data = <String, dynamic>{
      'displayName': ?displayName,
      'photoUrl': ?photoUrl,
      'preferredLanguage': ?language,
      'region': ?region,
      'onboardingCompleted': ?onboardingCompleted,
      'notificationPreview': ?notificationPreview,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final snap = await _ref(uid).get();
    if (snap.exists) {
      await _ref(uid).update(data);
    } else {
      await _ref(uid).set({'uid': uid, 'createdAt': FieldValue.serverTimestamp(), ...data});
    }
  }
}

class EntitlementRepository {
  EntitlementRepository(this._db);
  final FirebaseFirestore _db;

  Stream<Entitlement> watch(String uid) => _db.collection('entitlements').doc(uid).snapshots().map(
        (s) => s.exists ? Entitlement.fromMap(uid, decode(s.data()!)) : Entitlement.fallback(uid),
      );

  Stream<Usage> watchUsage(String key) => _db.collection('usage').doc(key).snapshots().map(
        (s) => s.exists ? Usage.fromMap(decode(s.data()!)) : const Usage(),
      );

  Stream<Map<String, dynamic>?> watchAiBudget(String uid, DateTime now) {
    final mk = '${now.toUtc().year}${now.toUtc().month.toString().padLeft(2, '0')}';
    return _db.collection('aiBudgets').doc('${uid}_$mk').snapshots().map((s) => s.data());
  }
}

class FamilyRepository {
  FamilyRepository(this._db, this._functions, this._storage);
  final FirebaseFirestore _db;
  final FunctionsService _functions;
  final FirebaseStorage _storage;

  Stream<Family?> watchFamily(String fid) =>
      _db.collection('families').doc(fid).snapshots().map((s) => s.exists ? Family.fromMap(s.id, decode(s.data()!)) : null);

  Stream<List<FamilyMember>> watchMembers(String fid) => _db
      .collection('families')
      .doc(fid)
      .collection('members')
      .where('status', isEqualTo: 'active')
      .snapshots()
      .map((s) => s.docs.map((d) => FamilyMember.fromMap(d.id, decode(d.data()))).toList());

  Stream<List<FamilyProfile>> watchProfiles(String fid) => _db
      .collection('families')
      .doc(fid)
      .collection('profiles')
      .snapshots()
      .map((s) => s.docs.map((d) => FamilyProfile.fromMap(d.id, decode(d.data()))).toList());

  Stream<List<FamilyInvitation>> watchInvitations(String fid) => _db
      .collection('familyInvitations')
      .where('familyId', isEqualTo: fid)
      .where('status', isEqualTo: 'pending')
      .snapshots()
      .map((s) => s.docs.map((d) => FamilyInvitation.fromMap(d.id, decode(d.data()))).toList())
      .handleError((_) => <FamilyInvitation>[]);

  Future<String> createFamily(String name) async => (await _functions.call('createFamily', {'name': name}))['familyId'] as String;

  Future<({String link, String invitationId})> invite(String fid, {String? email}) async {
    final r = await _functions.call('createInvitation', {'familyId': fid, if (email != null && email.isNotEmpty) 'email': email});
    return (link: r['link'] as String, invitationId: r['invitationId'] as String);
  }

  Future<void> revokeInvitation(String id) => _functions.call('revokeInvitation', {'invitationId': id});

  Future<({String familyName, String? inviterName})> previewInvitation(String id, String token) async {
    final r = await _functions.call('previewInvitation', {'invitationId': id, 'token': token});
    return (familyName: r['familyName'] as String? ?? '', inviterName: r['inviterName'] as String?);
  }

  Future<void> respond(String id, String token, bool accept) =>
      _functions.call('respondToInvitation', {'invitationId': id, 'token': token, 'accept': accept});

  Future<void> removeMember(String fid, String uid) => _functions.call('removeMember', {'familyId': fid, 'memberUid': uid});
  Future<void> leave(String fid) => _functions.call('leaveFamily', {'familyId': fid});
  Future<void> setRole(String fid, String uid, FamilyRole role) =>
      _functions.call('setMemberRole', {'familyId': fid, 'memberUid': uid, 'role': role.name});
  Future<void> dissolve(String fid) => _functions.call('dissolveFamily', {'familyId': fid});

  Future<void> saveProfile(String fid, String uid, FamilyProfile p, {bool isNew = false}) async {
    final ref = _db.collection('families').doc(fid).collection('profiles').doc(p.id);
    if (isNew) {
      await ref.set({...p.toMap(), 'createdBy': uid, 'createdAt': FieldValue.serverTimestamp()});
    } else {
      await ref.update({...p.toMap(), 'updatedAt': FieldValue.serverTimestamp()});
    }
  }

  String newProfileId(String fid) => _db.collection('families').doc(fid).collection('profiles').doc().id;

  Future<void> deleteProfile(String fid, String pid) => _db.collection('families').doc(fid).collection('profiles').doc(pid).delete();

  Future<String> uploadProfilePhoto(String fid, String pid, Uint8List jpg) async {
    final path = 'families/$fid/profiles/$pid/photo.jpg';
    try {
      await _storage.ref(path).putData(jpg, SettableMetadata(contentType: 'image/jpeg'));
    } catch (e) {
      throw AppError.from(e);
    }
    return path;
  }
}

class CategoryRepository {
  CategoryRepository(this._db);
  final FirebaseFirestore _db;

  Stream<List<CustomCategory>> watch(String uid) => _db
      .collection('categories')
      .where('ownerUid', isEqualTo: uid)
      .snapshots()
      .map((s) => s.docs.map((d) => CustomCategory.fromMap(d.id, d.data())).toList());

  Future<void> add(String uid, String name, String area, {String? parentId}) =>
      _db.collection('categories').add({...CustomCategory(id: '', ownerUid: uid, name: name, area: area, parentId: parentId).toMap(), 'createdAt': FieldValue.serverTimestamp()});

  Future<void> remove(String id) => _db.collection('categories').doc(id).delete();
}

class AiAnswer {
  const AiAnswer({required this.answer, required this.insufficientData, required this.sources});
  final String? answer;
  final bool insufficientData;
  final List<({String id, String collection, String title})> sources;
}

class AiRepository {
  AiRepository(this._functions);
  final FunctionsService _functions;

  Future<AiAnswer> ask(String question) async {
    final r = await _functions.call('aiAsk', {'question': question});
    final src = (r['sources'] as List? ?? const [])
        .whereType<Map>()
        .map((m) => (id: '${m['id']}', collection: '${m['collection']}', title: '${m['title']}'))
        .toList();
    return AiAnswer(answer: r['answer'] as String?, insufficientData: r['insufficientData'] == true, sources: src);
  }

  Future<Map<String, dynamic>> extractBusinessCard(List<String> photoPaths) =>
      _functions.call('extractBusinessCard', {'photoPaths': photoPaths});
}

class AccountRepository {
  AccountRepository(this._functions, this._storage);
  final FunctionsService _functions;
  final FirebaseStorage _storage;

  /// Builds a ZIP server-side and downloads it into memory for sharing/saving.
  Future<Uint8List> exportData() async {
    final r = await _functions.call('exportUserData', const {}, const Duration(minutes: 9));
    final path = r['storagePath'] as String;
    final bytes = await _storage.ref(path).getData(500 * 1024 * 1024);
    if (bytes == null) throw const AppError(AppErrorCode.notFound);
    return bytes;
  }

  Future<void> deleteAccount() => _functions.call('deleteAccount', const {}, const Duration(minutes: 9));
}

class PhotoRepository {
  PhotoRepository(this._storage);
  final FirebaseStorage _storage;

  /// Entity photos live at users/{uid}/photos/{entityId}/{name}.jpg
  Future<String> upload(String uid, String entityId, String name, Uint8List jpg) async {
    final path = 'users/$uid/photos/$entityId/$name.jpg';
    try {
      await _storage.ref(path).putData(jpg, SettableMetadata(contentType: 'image/jpeg'));
    } catch (e) {
      final err = AppError.from(e);
      throw err.code == AppErrorCode.permissionDenied ? const AppError(AppErrorCode.storageLimit) : err;
    }
    return path;
  }
}
