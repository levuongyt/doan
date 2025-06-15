import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

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
    
    print('🔧 Basic initialization of notification service...');
    
    // Set timezone for Vietnam
    try {
      _vietnamLocation = tz.getLocation('Asia/Ho_Chi_Minh');
      print('✅ Vietnam timezone set: ${_vietnamLocation.name}');
    } catch (e) {
      print('❌ Error setting Vietnam timezone: $e');
      _vietnamLocation = tz.local;
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestSoundPermission: false, // Không tự động xin quyền
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
      print('✅ Notifications plugin initialized (without permissions)');
    } catch (e) {
      print('❌ Notification initialization error: $e');
    }
  }

  Future<bool> requestPermissionAndInitialize() async {
    if (!_isInitialized) {
      await initializeBasic();
    }

    if (_hasPermission) {
      return true;
    }

    print('🔧 Requesting notification permissions...');
    
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _notifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      try {
        final granted = await androidImplementation.requestNotificationsPermission();
        _hasPermission = granted ?? false;
        print('✅ Notification permission: $_hasPermission');
        return _hasPermission;
      } catch (e) {
        print('❌ Permission request error: $e');
        return false;
      }
    }
    
    // For iOS, request permissions
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
        print('✅ iOS notification permission: $_hasPermission');
        return _hasPermission;
      } catch (e) {
        print('❌ iOS permission request error: $e');
        return false;
      }
    }
    
    return true; // Default for other platforms
  }

  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped: ${response.payload}');
  }

  // Test notification to check if notifications work immediately
  Future<void> showTestNotification() async {
    print('🧪 Sending test notification...');
    try {
      await _notifications.show(
        999,
        'Test Notification',
        'Thông báo test - Nếu bạn thấy thông báo này thì hệ thống hoạt động tốt!',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_channel',
            'Test Channel',
            channelDescription: 'Channel for testing notifications',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
      print('✅ Test notification sent');
    } catch (e) {
      print('❌ Test notification error: $e');
    }
  }

  Future<void> scheduleTransactionReminder({
    required String title,
    required String body,
    required TimeOfDay scheduledTime,
  }) async {
    print('📅 Scheduling notification for ${scheduledTime.format(Get.context!)}');
    
    try {
      final scheduledDate = _nextInstanceOfTime(scheduledTime);
      print('📅 Next notification time: $scheduledDate');
      
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
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: 'transaction_reminder',
      );
      print('✅ Notification scheduled successfully');
    } catch (e) {
      print('❌ Schedule notification error: $e');
    }
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    print('🗑️ All notifications cancelled');
  }

  Future<void> cancelTransactionReminder() async {
    await _notifications.cancel(0);
    print('🗑️ Transaction reminder cancelled');
  }

  tz.TZDateTime _nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(_vietnamLocation);
    print('🌍 Current Vietnam time: $now');
    print('🌍 Vietnam timezone offset: ${now.timeZoneOffset}');
    
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

    print('🕐 Current Vietnam time: $now');
    print('🕐 Scheduled time: $scheduledDate');
    print('🕐 Time difference: ${scheduledDate.difference(now)}');
    
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
      print('🔔 Notifications enabled: $enabled');
      return enabled;
    }
    return false; // Mặc định false cho an toàn
  }

  // Get pending notifications for debugging
  Future<void> debugPendingNotifications() async {
    try {
      final pendingNotifications = await _notifications.pendingNotificationRequests();
      print('📋 Pending notifications: ${pendingNotifications.length}');
      for (var notification in pendingNotifications) {
        print('  - ID: ${notification.id}, Title: ${notification.title}');
      }
    } catch (e) {
      print('❌ Error getting pending notifications: $e');
    }
  }

  // Schedule a test notification in 10 seconds
  Future<void> scheduleTestIn10Seconds() async {
    print('🧪 Scheduling test notification in 10 seconds...');
    final now = tz.TZDateTime.now(_vietnamLocation);
    final scheduledDate = now.add(const Duration(seconds: 10));
    
    try {
      await _notifications.zonedSchedule(
        998,
        'Test Scheduled',
        'Thông báo test sau 10 giây - Nếu thấy thì hệ thống hoạt động!',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'test_scheduled',
            'Test Scheduled',
            channelDescription: 'Test scheduled notifications',
            importance: Importance.high,
            priority: Priority.high,
            showWhen: true,
          ),
        ),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
      print('✅ Test notification scheduled for $scheduledDate');
    } catch (e) {
      print('❌ Error scheduling test notification: $e');
    }
  }

  // Debug timezone information
  Future<void> debugTimezone() async {
    final now = tz.TZDateTime.now(_vietnamLocation);
    final localNow = DateTime.now();
    
    print('🌍 === TIMEZONE DEBUG ===');
    print('🌍 Vietnam location: ${_vietnamLocation.name}');
    print('🌍 Vietnam time now: $now');
    print('🌍 Vietnam timezone offset: ${now.timeZoneOffset}');
    print('🌍 Local system time: $localNow');
    print('🌍 Difference: ${now.difference(localNow.toUtc().add(now.timeZoneOffset))}');
    
    // Test with a specific time
    final testTime = TimeOfDay(hour: 23, minute: 35);
    final scheduledDate = _nextInstanceOfTime(testTime);
    print('🌍 Test time 23:35 -> Scheduled: $scheduledDate');
    print('🌍 === END DEBUG ===');
  }
} 