import 'package:doan_ql_thu_chi/config/languages/local_language.dart';
import 'package:doan_ql_thu_chi/config/themes/themes_app.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/views/splash/splash.dart';
import 'package:doan_ql_thu_chi/utils/loading_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> configure() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
      } catch (e) {
      // Firebase already initialized
      if (e.toString().contains('duplicate-app')) {
        // Firebase already initialized
      } else {
        rethrow;
      }
    }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables from .env file
  await dotenv.load(fileName: ".env");
  
  // Initialize timezone data properly
  tz.initializeTimeZones();
  
  // Set local timezone to Vietnam
  try {
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  } catch (e) {
    // Error setting Vietnam timezone
  }
  
  await configure();
  Get.put(SettingController(), permanent: true);
  runApp(const GetMyApp());
}

class GetMyApp extends StatelessWidget {
  const GetMyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingController settingController = Get.find();
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (_) {
        return LoadingUtils.buildSaveTransactionLoader();
      },
      child: Obx(() => GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('vi', 'VI'),
          Locale('en', 'EN'),
          Locale('ja', 'JP'),
        ],
        translations: LocalStringLanguage(),
        locale: settingController.selectedLanguage.value,
        theme: ThemesApp.light,
        darkTheme: ThemesApp.dark,
        themeMode: settingController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeft,
        transitionDuration: const Duration(milliseconds: 300),
        home: const SplashScreen(),
      )),
    );
  }
}
