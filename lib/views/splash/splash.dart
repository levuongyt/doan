import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../config/SharedPreferences/prefs_service.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/report_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../home/home.dart';
import '../login/sign_in.dart';
import '../welcome/welcome.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    // Đợi một chút để animation splash chạy
    await Future.delayed(const Duration(seconds: 2));
    
    // Kiểm tra xem user đã đăng nhập chưa
    final User? user = FirebaseAuth.instance.currentUser;
    
    if (user != null) {
      // User đã đăng nhập → Vào Home
      Get.lazyPut(() => HomeController());
      Get.lazyPut(() => TransactionController());
      Get.lazyPut(() => ReportController());
      Get.off(() => const Home());
    } else {
      // User chưa đăng nhập → Kiểm tra đã xem Welcome chưa
      final PrefsService prefsService = PrefsService();
      bool hasSeenWelcome = await prefsService.readBoolCheck('hasSeenWelcome');
      
      if (hasSeenWelcome) {
        // Đã xem Welcome rồi → Vào màn Login
        Get.off(() => const SignIn());
      } else {
        // Chưa xem Welcome → Vào màn Welcome (lần đầu)
        Get.off(() => const Welcome());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: LottieBuilder.asset('assets/Lottie/Animation.json'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
