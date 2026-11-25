import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'maintenance_service.dart';
import 'session_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const int timerNotifId = 888;
  static const String _kTimerChannelId = 'dev_timer_high_v1';
  static const String _kTimerChannelName = 'Timer Notifikasi (High Priority)';
  static const String _kTimerChannelDesc = 'Notifikasi hitung mundur timer dengan prioritas tinggi';
  static const String _kTimerTargetMsKey = 'ps_dev_timer_target_ms';
  static const String _kTimerDurationTextKey = 'ps_dev_timer_duration_text';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      tz.initializeTimeZones();
    } catch (_) {}
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      const timerChannel = AndroidNotificationChannel(
        _kTimerChannelId,
        _kTimerChannelName,
        description: _kTimerChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      await androidPlugin.createNotificationChannel(timerChannel);
    }
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImplementation?.requestNotificationsPermission();
  }

  /// Meminta izin notifikasi dan Exact Alarm (diperlukan pada Android 13/14+ agar timer berjalan saat aplikasi ditutup)
  Future<void> requestTimerPermissions() async {
    await init();
    final androidPlugin = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      final canExact = await androidPlugin.canScheduleExactNotifications() ?? true;
      if (!canExact) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  static String formatHms(Duration d) {
    final totalSec = d.inSeconds < 0 ? 0 : d.inSeconds;
    final hours = totalSec ~/ 3600;
    final minutes = (totalSec % 3600) ~/ 60;
    final seconds = totalSec % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  NotificationDetails _buildHighPriorityTimerDetails() {
    const androidDetails = AndroidNotificationDetails(
      _kTimerChannelId,
      _kTimerChannelName,
      channelDescription: _kTimerChannelDesc,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
      ticker: 'Timer Selesai',
      autoCancel: true,
    );
    return const NotificationDetails(android: androidDetails);
  }

  /// Memulai timer notifikasi terjadwal di level OS (AlarmManager) sehingga tetap berjalan
  /// walau aplikasi ditutup maupun latar belakang dibersihkan. Mengembalikan epoch ms target.
  Future<int> startTimerNotification({required Duration duration}) async {
    await requestTimerPermissions();
    await cancelTimerNotification();

    final int nowMs = DateTime.now().millisecondsSinceEpoch;
    final int uiTargetMs = nowMs + duration.inMilliseconds;
    // Bulatkan ke detik penuh berikutnya karena AlarmManager plugin memotong milidetik
    final int alarmEpochMs = ((uiTargetMs + 999) ~/ 1000) * 1000;
    final String formattedDuration = formatHms(duration);

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_kTimerTargetMsKey, uiTargetMs);
      await prefs.setString(_kTimerDurationTextKey, formattedDuration);
    } catch (_) {}

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      final tz.TZDateTime scheduledUtc = tz.TZDateTime.fromMillisecondsSinceEpoch(tz.UTC, alarmEpochMs);
      final details = _buildHighPriorityTimerDetails();
      const String title = '⏰ Timer Notifikasi Selesai!';
      final String body = 'Hitung mundur timer ($formattedDuration) telah mencapai 00:00:00.';

      try {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id: timerNotifId,
          title: title,
          body: body,
          scheduledDate: scheduledUtc,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
          payload: 'dev_timer_finished',
        );
      } catch (e) {
        debugPrint('[NotificationService] alarmClock fallback ke exactAllowWhileIdle: $e');
        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            id: timerNotifId,
            title: title,
            body: body,
            scheduledDate: scheduledUtc,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            payload: 'dev_timer_finished',
          );
        } catch (e2) {
          debugPrint('[NotificationService] exactAllowWhileIdle fallback ke inexactAllowWhileIdle: $e2');
          try {
            await _flutterLocalNotificationsPlugin.zonedSchedule(
              id: timerNotifId,
              title: title,
              body: body,
              scheduledDate: scheduledUtc,
              notificationDetails: details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              payload: 'dev_timer_finished',
            );
          } catch (_) {}
        }
      }
    }

    return uiTargetMs;
  }

  /// Membatalkan alarm timer terjadwal dan menghapus state di SharedPreferences
  Future<void> cancelTimerNotification() async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id: timerNotifId);
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kTimerTargetMsKey);
      await prefs.remove(_kTimerDurationTextKey);
    } catch (_) {}
  }

  /// Mengambil target epoch ms jika timer masih aktif (walau app sempat ditutup dan dibuka lagi)
  Future<int?> getActiveTimerTargetMs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final targetMs = prefs.getInt(_kTimerTargetMsKey);
      if (targetMs == null) return null;
      if (targetMs <= DateTime.now().millisecondsSinceEpoch) {
        await prefs.remove(_kTimerTargetMsKey);
        await prefs.remove(_kTimerDurationTextKey);
        return null;
      }
      return targetMs;
    } catch (_) {
      return null;
    }
  }

  /// Dipanggil saat UI foreground mendeteksi timer tepat mencapai 00:00:00
  Future<void> handleForegroundTimerZero({String? fallbackDurationText}) async {
    String durationText = fallbackDurationText ?? '00:00:00';
    try {
      final prefs = await SharedPreferences.getInstance();
      durationText = prefs.getString(_kTimerDurationTextKey) ?? durationText;
      await prefs.remove(_kTimerTargetMsKey);
      await prefs.remove(_kTimerDurationTextKey);
    } catch (_) {}

    try {
      await init();
      bool alreadyDisplayed = false;
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final active = await _flutterLocalNotificationsPlugin.getActiveNotifications();
        alreadyDisplayed = active.any((n) => n.id == timerNotifId);
      }
      if (!alreadyDisplayed) {
        await _flutterLocalNotificationsPlugin.cancel(id: timerNotifId);
        await _flutterLocalNotificationsPlugin.show(
          id: timerNotifId,
          title: '⏰ Timer Notifikasi Selesai!',
          body: 'Hitung mundur timer ($durationText) telah mencapai 00:00:00.',
          notificationDetails: _buildHighPriorityTimerDetails(),
          payload: 'dev_timer_finished',
        );
      }
    } catch (e) {
      debugPrint('[NotificationService] handleForegroundTimerZero error: $e');
    }
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    try {
      if (MaintenanceService.instance.isPushMaintenance) {
        // Gateway Push Notification dinonaktifkan oleh Superadmin
        return;
      }
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'payment_channel', 'Payment Notifications',
        channelDescription: 'Notifications for successful payments',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );
      await _flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: platformChannelSpecifics,
      );
    } catch (e) {
      // Prevent push notification failure from breaking transaction/navigation flow
    }
  }

  /// Menampilkan notifikasi instan (Modul 7 - Immediate Notification)
  Future<void> showInstantNotification({required int id, required String title, required String body}) async {
    await showNotification(id: id, title: title, body: body);
  }

  /// Menjadwalkan notifikasi di masa depan (Modul 7 - Scheduled Notification)
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      await requestPermissions();
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'scheduled_reminder_channel',
        'Pengingat Parkir Terjadwal',
        channelDescription: 'Notifikasi jadwal cek atau waktu parkir',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails details = NotificationDetails(android: androidDetails);
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } catch (_) {}
  }

  /// Membatalkan notifikasi berdasarkan ID
  Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id: id);
    } catch (_) {}
  }

  Future<void> showMaintenanceNotification({required String title, required String body}) async {
    try {
      await requestPermissions();
      const AndroidNotificationDetails maintenanceDetails = AndroidNotificationDetails(
        'maintenance_alerts_channel',
        'Pemberitahuan Maintenance Sistem',
        channelDescription: 'Pemberitahuan darurat pemeliharaan sistem ParkSmart',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        styleInformation: BigTextStyleInformation(''),
      );
      const NotificationDetails platformDetails = NotificationDetails(
        android: maintenanceDetails,
      );
      await _flutterLocalNotificationsPlugin.show(
        id: 991,
        title: title,
        body: body,
        notificationDetails: platformDetails,
      );
    } catch (e) {
      // Ignore if on desktop/web or headless
    }
  }

  /// Menampilkan notifikasi darurat parkir (suara darurat)
  Future<void> showUrgentParkingNotification({int minsLeft = 10}) async {
    if (SessionService.instance.isAdmin || SessionService.instance.userType == 'admin') return;
    try {
      await requestPermissions();
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'urgent_channel_v4',
        'Urgent Parking Notifications',
        channelDescription: 'Peringatan waktu parkir dengan suara darurat',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('sound_darurat'),
        audioAttributesUsage: AudioAttributesUsage.alarm,
        enableVibration: true,
        fullScreenIntent: true,
        autoCancel: true,
      );
      const NotificationDetails details = NotificationDetails(android: androidDetails);
      await _flutterLocalNotificationsPlugin.show(
        id: 777,
        title: '⚠️ Sisa Waktu Parkir $minsLeft Menit!',
        body: 'Waktu parkir Anda hampir habis. Segera perpanjang atau checkout untuk menghindari denda.',
        notificationDetails: details,
        payload: 'expiring_session',
      );
    } catch (_) {}
  }

  /// Membatalkan notifikasi darurat parkir
  Future<void> cancelUrgentParkingNotification() async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id: 777);
    } catch (_) {}
  }
}

