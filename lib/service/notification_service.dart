import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  late tz.Location _vietnamLocation;
  bool _isInitialized = false;
  bool _hasPermission = false;

  Future<void> initializeBasic() async {
    if (_isInitialized) return;
    
    try {
      _vietnamLocation = tz.getLocation('Asia/Ho_Chi_Minh');
    } catch (e) {
      _vietnamLocation = tz.local;
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    try {
      await _notifications.initialize(
        settings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );
      _isInitialized = true;
    } catch (e) {
      // Notification initialization error
    }
  }

  Future<bool> requestPermissionAndInitialize() async {
    if (!_isInitialized) {
      await initializeBasic();
    }

    if (_hasPermission) {
      return true;
    }

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        final granted = await androidImplementation.requestNotificationsPermission();
        _hasPermission = granted ?? false;
        return _hasPermission;
      } catch (e) {
        return false;
      }
    }
    
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    
    if (iosImplementation != null) {
      try {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        _hasPermission = granted ?? false;
        return _hasPermission;
      } catch (e) {
        return false;
      }
    }
    
    return true;
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Notification tapped
  }

  Future<void> scheduleTransactionReminder({
    required String title,
    required String body,
    required TimeOfDay scheduledTime,
  }) async {
    try {
      final scheduledDate = _nextInstanceOfTime(scheduledTime);
      
      await _notifications.zonedSchedule(
        0,
        title,
        body,
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'transaction_reminder',
            'Nhắc nhở giao dịch',
            channelDescription: 'Nhắc nhở nhập giao dịch hàng ngày',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            showWhen: true,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'transaction_reminder',
      );
    } catch (e) {
      // Schedule notification error
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelTransactionReminder() async {
    await _notifications.cancel(0);
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(_vietnamLocation);
    
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      _vietnamLocation,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    
    return scheduledDate;
  }

  Future<bool> hasPermission() async {
    if (_hasPermission) {
      return true;
    }
    
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final enabled = await androidImplementation.areNotificationsEnabled() ?? false;
      _hasPermission = enabled;
      return enabled;
    }
    return false;
  }
}
 