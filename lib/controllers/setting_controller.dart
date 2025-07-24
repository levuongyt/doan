import 'package:doan_ql_thu_chi/config/images/image_app.dart';
import 'package:doan_ql_thu_chi/service/api_service.dart';
import 'package:doan_ql_thu_chi/service/notification_service.dart';
import 'package:doan_ql_thu_chi/utils/firebase/storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/SharedPreferences/prefs_service.dart';
import '../models/rates_currency_model.dart';
import '../utils/firebase/login/authentication.dart';

class SettingController extends GetxController {
  final FireBaseUtil fireBaseUtil = FireBaseUtil();
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final PrefsService prefsService = PrefsService();
  final NotificationService notificationService = NotificationService();
  RxBool isLoading = false.obs;
  RxBool isDarkMode = false.obs;
  RxBool notificationEnabled = true.obs;
  RxBool reminderEnabled = false.obs;
  Rx<TimeOfDay> reminderTime = const TimeOfDay(hour: 20, minute: 0).obs;
  Rx<Locale> selectedLanguage = const Locale('vi', 'VI').obs;
  RxString selectedCurrency = 'VND'.obs;
  RxDouble exchangeRate = 1.0.obs;
  final ApiService apiService = ApiService();
  final List<Map<String, dynamic>> localizations = [
    {
      "name": "Tiếng việt",
      "Local": const Locale('vi', 'VI'),
      "image": ImageApp.imageFlagVN,
    },
    {
      "name": "Tiếng anh",
      "Local": const Locale('en', 'EN'),
      "image": ImageApp.imageFlagEN,
    },
    {
      "name": "Tiếng Nhật",
      "Local": const Locale('ja', 'JP'),
      "image": ImageApp.imageFlagJP,
    },
  ];

  final List<Map<String, dynamic>> listCurrency = [
    {
      "name": "Việt Nam Đồng",
      "currency": "VND",
      "symbol":"đ",
      "image": ImageApp.imageFlagVN,
    },
    {
      "name": "US Dollar",
      "currency": "USD",
      "symbol":"\$",
      "image": ImageApp.imageFlaUSA,
    },
    {
      "name": "EURO",
      "currency": "EUR",
      "symbol":"€",
      "image": ImageApp.imageFlagEURO,
    },
    {
      "name": "Yên Nhật",
      "currency": "JPY",
      "symbol":"¥",
      "image": ImageApp.imageFlagJP,
    },
  ];

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await saveThemeToPreferences(isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> saveThemeToPreferences(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  Future<void> loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> saveLanguage(Locale locale) async {
    await prefsService.saveStringData('languageValue', locale.languageCode);
    await prefsService.saveStringData('localValue', locale.countryCode ?? 'VI');
  }

  Future<void> readLanguage() async {
    String? valueLanguage =
        await prefsService.readStringData('languageValue') ?? 'vi';
    String? valueLocal =
        await prefsService.readStringData('localValue') ?? 'VI';

    selectedLanguage.value = Locale(valueLanguage, valueLocal);
    Get.updateLocale(selectedLanguage.value);
  }

  Future<void> saveCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    selectedCurrency.value = currency;
     await updateExchangeRate();
  }

  Future<void> readCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCurrency.value = prefs.getString('currency') ?? 'VND';
     await updateExchangeRate();
  }

  Future<void> saveNotificationSetting(bool enabled) async {
    if (enabled) {
      final hasPermission = await notificationService.requestPermissionAndInitialize();
      if (!hasPermission) {
        Get.snackbar(
          'Thông báo',
          'Cần cấp quyền thông báo để sử dụng tính năng này',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      
      if (reminderEnabled.value) {
        await scheduleTransactionReminder();
      }
    } else {
      await notificationService.cancelAllNotifications();
    }
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationEnabled', enabled);
    notificationEnabled.value = enabled;
  }

  Future<void> loadNotificationSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    notificationEnabled.value = prefs.getBool('notificationEnabled') ?? false;
  }

  void toggleNotification() async {
    final newValue = !notificationEnabled.value;
    await saveNotificationSetting(newValue);
  }

  // Reminder notification settings
  Future<void> saveReminderSetting(bool enabled) async {
    if (enabled && !notificationEnabled.value) {
      Get.snackbar(
        'Thông báo',
        'Vui lòng bật "Thông báo chung" trước khi sử dụng tính năng nhắc nhở',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    if (enabled) {
      await scheduleTransactionReminder();
    } else {
      await notificationService.cancelTransactionReminder();
    }
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('reminderEnabled', enabled);
    reminderEnabled.value = enabled;
  }

  Future<void> loadReminderSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    reminderEnabled.value = prefs.getBool('reminderEnabled') ?? false;
  }

  Future<void> saveReminderTime(TimeOfDay time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderHour', time.hour);
    await prefs.setInt('reminderMinute', time.minute);
    reminderTime.value = time;
    
    if (reminderEnabled.value) {
      await scheduleTransactionReminder();
    }
  }

  Future<void> loadReminderTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int hour = prefs.getInt('reminderHour') ?? 20;
    int minute = prefs.getInt('reminderMinute') ?? 0;
    reminderTime.value = TimeOfDay(hour: hour, minute: minute);
  }

  void toggleReminder() async {
    final newValue = !reminderEnabled.value;
    await saveReminderSetting(newValue);
  }

  Future<void> scheduleTransactionReminder() async {
    if (!notificationEnabled.value) {
      return;
    }
    
    await notificationService.scheduleTransactionReminder(
              title: 'Nhắc nhở ghi chép'.tr,
      body: 'Đừng quên ghi lại các giao dịch thu chi hôm nay!',
      scheduledTime: reminderTime.value,
    );
  }

  Future<void> initializeNotifications() async {
    await notificationService.initializeBasic();
    
    if (notificationEnabled.value && reminderEnabled.value) {
      final hasPermission = await notificationService.hasPermission();
      if (hasPermission) {
        await scheduleTransactionReminder();
      }
    }
  }

  Future<void> updateExchangeRate() async {
    RatesCurrencyModel? rateModel =
        await apiService.getExchangeRate();
    if (rateModel != null && rateModel.conversionRates != null) {
      double? rate =
          getRateByCurrency(rateModel.conversionRates, selectedCurrency.value);
      exchangeRate.value = rate ?? 1.0;
    } else {
      exchangeRate.value = 1.0;
    }
  }

  double? getRateByCurrency(ConversionRates? rates, String currency) {
    if (rates == null) {
      return null;
    }
    switch (currency) {
      case 'USD':
        return rates.uSD;
      case 'VND':
        return rates.vND?.toDouble();
      case 'EUR':
        return rates.eUR;
      case 'JPY':
        return rates.jPY;
      default:
        return null;
    }
  }

  double convertAmount(double amount) {
    return amount * exchangeRate.value;
  }

  double amountToVND(double amount){
    return amount / exchangeRate.value;
  }

  String getCurrencySymbol() {
    switch (selectedCurrency.value) {
      case 'USD':
        return '\$';
      case 'VND':
        return 'đ';
      case 'EUR':
        return '€';
      case 'JPY':
        return '¥';
      default:
        return '';
    }
  }

  // Helper method to get current theme mode
  ThemeMode get currentThemeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;
  
  // Helper method to check if current theme is dark
  bool get isCurrentThemeDark => isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPreferences();
    readLanguage();
    readCurrency();
    loadNotificationSetting();
    loadReminderSetting();
    loadReminderTime();
    initializeNotifications();
  }
}
