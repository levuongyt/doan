import 'package:doan_ql_thu_chi/config/languages/local_language.dart';
import 'package:doan_ql_thu_chi/config/themes/themes_app.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/views/splash/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

Future<void> configure() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configure();
  await Firebase.initializeApp();
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
        return const Center(
            child: CircularProgressIndicator()
            );
      },
      child: GetMaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        translations: LocalStringLanguage(),
        locale: settingController.selectedLanguage.value,
        theme: ThemesApp.light,
        darkTheme: ThemesApp.dark,
        debugShowCheckedModeBanner: false,
        home: const SpalshScreen(),
      ),
    );
  }
}
