import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../domain/logic/reminders.dart';
import '../domain/models/entities.dart';

/// Push (server scheduled, reliable even when the app is closed) plus local
/// notifications as an on-device backup. Notification text never contains
/// document content; by default it is generic.
class NotificationService {
  final _local = FlutterLocalNotificationsPlugin();
  final _taps = StreamController<String>.broadcast();
  String _timezone = 'UTC';
  bool _ready = false;

  /// Emits reminder ids when the user taps a notification.
  Stream<String> get taps => _taps.stream;
  String get deviceTimezone => _timezone;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      _timezone = info.identifier;
      tz.setLocalLocation(tz.getLocation(_timezone));
    } catch (_) {
      _timezone = 'UTC';
    }
    await _local.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(requestAlertPermission: false, requestBadgePermission: false, requestSoundPermission: false),
      ),
      onDidReceiveNotificationResponse: (r) {
        if (r.payload != null) _taps.add(r.payload!);
      },
    );
    FirebaseMessaging.onMessageOpenedApp.listen((m) {
      final id = m.data['reminderId'];
      if (id is String) _taps.add(id);
    });
    final initial = await FirebaseMessaging.instance.getInitialMessage();
    final id = initial?.data['reminderId'];
    if (id is String) _taps.add(id);
    _ready = true;
  }

  /// Asks for permission (only when the user enables reminders).
  Future<bool> requestPermission() async {
    final s = await FirebaseMessaging.instance.requestPermission(alert: true, badge: true, sound: true);
    if (Platform.isAndroid) {
      await _local.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
    return s.authorizationStatus == AuthorizationStatus.authorized || s.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<bool> permissionGranted() async {
    final s = await FirebaseMessaging.instance.getNotificationSettings();
    return s.authorizationStatus == AuthorizationStatus.authorized || s.authorizationStatus == AuthorizationStatus.provisional;
  }

  StreamSubscription<String>? _registered;

  /// Registers this app instance with FCM; the Firebase Installation ID (FID)
  /// is stored under users/{uid}/devices so the server can direct-send pushes.
  Future<void> registerDevice(FirebaseFirestore db, String uid, String locale) async {
    await _registered?.cancel();
    _registered = FirebaseMessaging.instance.onRegistered.listen((fid) {
      db.collection('users').doc(uid).collection('devices').doc(fid).set({
        'fid': fid,
        'platform': Platform.isIOS ? 'ios' : 'android',
        'locale': locale,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
    await FirebaseMessaging.instance.register();
  }

  Future<void> unregisterDevice(FirebaseFirestore db, String uid) async {
    await _registered?.cancel();
    final done = FirebaseMessaging.instance.onUnregistered.first.timeout(const Duration(seconds: 10));
    await FirebaseMessaging.instance.unregister();
    try {
      final fid = await done;
      await db.collection('users').doc(uid).collection('devices').doc(fid).delete();
    } catch (_) {
      // Server also prunes dead installations when a send fails.
    }
  }

  /// Mirrors active reminders as local notifications (offline backup).
  Future<void> syncLocal(List<Reminder> reminders, {required String genericTitle, required String genericBody, required bool showDetails}) async {
    if (!_ready) return;
    await _local.cancelAll();
    final now = DateTime.now();
    var scheduled = 0;
    for (final r in reminders) {
      if (!r.isActive || !r.notificationChannels.contains('local')) continue;
      final at = nextLocalOccurrence(r.dueAt.subtract(Duration(minutes: r.leadTimeMinutes)), r.repeatRule, now);
      if (at == null) continue;
      if (++scheduled > 50) break; // iOS limit is 64 pending notifications
      await _local.zonedSchedule(
        id: localNotificationId(r.id),
        title: genericTitle,
        body: showDetails ? r.title : genericBody,
        scheduledDate: tz.TZDateTime.from(at, tz.local),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails('reminders', 'Reminders', importance: Importance.high, priority: Priority.high,
              visibility: NotificationVisibility.private),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: r.id,
      );
    }
  }

  Future<void> cancelAll() => _local.cancelAll();
}
