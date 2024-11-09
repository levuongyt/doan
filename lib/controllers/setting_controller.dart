import 'package:doan_ql_thu_chi/config/images/image_app.dart';
import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:doan_ql_thu_chi/service/api_service.dart';
import 'package:doan_ql_thu_chi/utils/firebase/storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/SharedPreferences/prefs_service.dart';
import '../models/rates_currency_model.dart';
import '../utils/firebase/login/authentication.dart';

class SettingController extends GetxController {
  final FireBaseUtil fireBaseUtil = FireBaseUtil();
  // final HomeController homeController=Get.find();
  // final TransactionController transactionController=Get.find();
  // final ReportController reportController=Get.find();
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final PrefsService prefsService = PrefsService();
  RxBool isLoading = false.obs;
  RxBool isDarkMode = false.obs;
  Rx<Locale> selectedLanguage = Locale('vi', 'VI').obs;
  RxString selectedCurrency = 'VND'.obs;
  RxDouble exchangeRate = 1.0.obs;
  final ApiService apiService = ApiService();

  Future<void> resetPass(String emailReset) async {
    isLoading.value = true;
    bool resultSend = await fireBaseUtil.sendPasswordResetEmail(emailReset);
    if (resultSend == true) {
      Get.snackbar(
        'Thành công',
        'Đã gửi thông báo đến email của bạn',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
    } else {
      Get.snackbar(
        'Thất bại',
        'Vui lòng kiểm tra lại thông tin!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
    isLoading.value = false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
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

  ///testnn
  final List<Map<String, dynamic>> localizations = [
    {
      "name": "Tiếng anh",
      "Local": const Locale('en', 'EN'),
      "image": ImageApp.imageFlagEN,
    },
    {
      "name": "Tiếng việt",
      "Local": const Locale('vi', 'VI'),
      "image": ImageApp.imageFlagVN,
    },
  ];

  Future<void> saveLanguage(Locale locale) async {
    await prefsService.saveStringData('languageValue', locale.languageCode);
    await prefsService.saveStringData('localValue', locale.countryCode ?? 'VI');
    print('done');
  }

  Future<void> readLanguage() async {
    String? valueLanguage =
        await prefsService.readStringData('languageValue') ?? 'vi';
    String? valueLocal =
        await prefsService.readStringData('localValue') ?? 'VI';
    // valueLocale=Locale(valueLanguage,valueLocal);

    selectedLanguage.value = Locale(valueLanguage, valueLocal);
    print('gg : ${selectedLanguage.value}');
    //   Get.updateLocale(valueLocale);
    Get.updateLocale(selectedLanguage.value);
  }

  // void setSelectedLanguage(Locale locale){
  //   selectedLanguage.value=locale;
  // }
  // Future<void> confirmLanguageSelection()async{
  //   await saveLanguage(selectedLanguage.value);
  //   Get.updateLocale(selectedLanguage.value);
  // }

  ///Lưu tiền tệ
  Future<void> saveCurrency(String currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('currency', currency);
    selectedCurrency.value = currency;

    ///
     await updateExchangeRate();
  }

  Future<void> readCurrency() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCurrency.value = prefs.getString('currency') ?? 'VND';

    ///
     await updateExchangeRate();
  }

  // Future<void> updateExchangeRate(String fromCurrency, String toCurrency) async {
  //   // Lấy tỷ giá từ `ExchangeRateService`
  //   RateCurrencyModel? rateData = await exchangeRateService.getExchangeRate(fromCurrency);
  //   if (rateData != null && rateData.conversionRates?..containsKey(toCurrency)) {
  //     exchangeRate.value = rateData.conversionRates?[toCurrency] ?? 1.0;
  //   } else {
  //     print('Failed to update exchange rate for $fromCurrency to $toCurrency.');
  //     exchangeRate.value = 1.0;
  //   }
  // }

  // Future<void> ds() async {
  //   exchangeRate.value = await exchangeRateService.getExchangeRate('VND');
  // }

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
      default:
        return null;
    }
  }

  double convertAmount(double amount) {
    return amount * exchangeRate.value;
  }

  String getCurrencySymbol() {
    switch (selectedCurrency.value) {
      case 'USD':
        return '\$';
      case 'VND':
        return 'đ';
      case 'EUR':
        return '€';
      default:
        return '';
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadThemeFromPreferences();
    readLanguage();
    readCurrency();
    // updateExchangeRate();
    // ds();
  }
}
