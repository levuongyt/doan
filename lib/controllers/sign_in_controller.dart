import 'package:doan_ql_thu_chi/config/SharedPreferences/prefs_service.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/login/authentication.dart';
import '../views/home.dart';
import 'home_controller.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isVisibility = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCheckBok=false.obs;
  final FireBaseUtil fireBaseUtil = FireBaseUtil();
  final PrefsService prefsService=PrefsService();

  void stateCheckBok(){
    isCheckBok.value=!isCheckBok.value;
  }
  Future<void> saveLoginData() async {
    if (isCheckBok.value == true) {
      await prefsService.saveStringData('dataEmail', emailController.text);
      await prefsService.saveStringData('dataPass', passwordController.text);
    }
    await prefsService.saveBoolCheck('checkbook',isCheckBok.value);
  }

  Future<void> loadLoginData() async {
    isCheckBok.value = await prefsService.readBoolCheck('checkbook');
    if (isCheckBok.value) {
      emailController.text = await prefsService.readStringData('dataEmail')??"";
      passwordController.text = await prefsService.readStringData('dataPass')??"";
    }
  }


  // bool isEmail(String email) {
  //   bool emailValid = RegExp(
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
  //       .hasMatch(email);
  //   return emailValid;
  // }

  String? ktEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email Không được bỏ trống';
    } else if (value.length < 6) {
      return 'Độ dài email phải từ 6 ký tự trở lên';
    } else if (!RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return 'Email không đúng định dạng';
    }
    // else if (!RegExp(
    //         r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
    //     .hasMatch(value)) {
    //   return 'Email không đúng định dạng';
    // }
    // else if(!isEmail(value)){
    //   return 'Email không đúng định dạng';
    // }
    // else if(!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)){
    //   return 'Username không được chứa ký tự đặc biệt';
    // }
    return null;
  }

  String? ktPassWord(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password Không được bỏ trống';
    } else if (value.length < 6) {
      return 'Độ dài Password phải từ 6 ký tự trở lên';
    }
    //else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$').hasMatch(value)){
    //  return 'Password chưa đúng định dạng';
    // }
    return null;
  }

  void xuLiVisibility() {
    isVisibility.value = !isVisibility.value;
  }

  Future<void> signIn(String email, String pass) async {
    try {
      isLoading.value = true;
      bool result = await fireBaseUtil.login(email, pass);
      if (result) {
        Get.snackbar('Success', 'Welcome');
        await saveLoginData();
        Get.lazyPut(()=>HomeController());
        Get.lazyPut(()=>TransactionController());
        Get.lazyPut(()=>ReportController());
        Get.off(() => const Home());
        print('Trạng thái : ${isLoading.value}');
      } else {
        Get.snackbar('Error', 'Mời thử lại');
      }
    } catch (e) {
      Get.snackbar('Error', 'Mời thử lại');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmailGoogle() async {
    try {
      isLoading.value = true;
      bool result = await fireBaseUtil.signInWithGoogle();
      if (result) {
        Get.snackbar('Success', 'Welcome');
        Get.lazyPut(()=>HomeController());
        Get.lazyPut(()=>TransactionController());
        Get.lazyPut(()=>ReportController());
        Get.off(() => const Home());
        print('Trạng thái : ${isLoading.value}');
      } else {
        Get.snackbar('Error', 'Mời thử lại');
      }
    } catch (e) {
      Get.snackbar('Error', 'Mời thử lại');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithAccountFacebook() async {
    try {
      isLoading.value = true;
      bool result = await fireBaseUtil.signInWithFacebook();
      if (result) {
        Get.snackbar('Success', 'Welcome');
        Get.off(() => const Home());
        print('Trạng thái : ${isLoading.value}');
      } else {
        Get.snackbar('Error', 'Mời thử lại');
      }
    } catch (e) {
      Get.snackbar('Error', 'Mời thử lại');
    } finally {
      isLoading.value = false;
    }
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadLoginData();
  }
}
