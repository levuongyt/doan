import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:doan_ql_thu_chi/views/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'firebase_options.dart';

// void main() {
//  // runApp(const MyApp());
//   runApp(const GetMyApp());
//
// }
Future<void> configure() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configure();
  await Firebase.initializeApp();
  runApp(const GetMyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SpalshScreen(),
    );
  }
}

class GetMyApp extends StatelessWidget {
  const GetMyApp({super.key});

  @override
  Widget build(BuildContext context) {

    // return GetMaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   home: LoaderOverlay(
    //     child: SpalshScreen(),
    //     overlayWidgetBuilder: (_) {
    //       return Center(
    //         child: SpinKitCubeGrid(
    //           color: Colors.blueAccent,
    //           size: 50,
    //         ),
    //       );
    //     },
    //   ),


    /// Bọc toàn bộ ứng dụng
    return GlobalLoaderOverlay(
      overlayWidgetBuilder: (_) {
        return Center(
            child: CircularProgressIndicator(
              // backgroundColor: Colors.blueAccent,
            )

          // SpinKitCubeGrid(
          //   color: Colors.blueAccent,
          //   size: 50,
          // ),
        );
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SpalshScreen(), // Màn hình bắt đầu là SplashScreen
      ),
    );
  }
}
