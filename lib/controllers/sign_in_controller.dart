import 'package:doan_ql_thu_chi/config/SharedPreferences/prefs_service.dart';
import 'package:doan_ql_thu_chi/config/notifications/notifications.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/login/authentication.dart';
import '../views/home/home.dart';
import 'home_controller.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isVisibility = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCheckBok = false.obs;
  final FireBaseUtil fireBaseUtil = FireBaseUtil();
  final PrefsService prefsService = PrefsService();

  void stateCheckBok() {
    isCheckBok.value = !isCheckBok.value;
  }

  Future<void> saveLoginData() async {
    if (isCheckBok.value == true) {
      await prefsService.saveStringData('dataEmail', emailController.text);
      await prefsService.saveStringData('dataPass', passwordController.text);
    }
    await prefsService.saveBoolCheck('checkbook', isCheckBok.value);
  }

  Future<void> loadLoginData() async {
    isCheckBok.value = await prefsService.readBoolCheck('checkbook');
    if (isCheckBok.value) {
      emailController.text =
          await prefsService.readStringData('dataEmail') ?? "";
      passwordController.text =
          await prefsService.readStringData('dataPass') ?? "";
    }
  }

  String? ktEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được bỏ trống'.tr;
    }else if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return 'Email không đúng định dạng'.tr;
    }
    return null;
  }

  String? ktPassWord(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được bỏ trống'.tr;
    } else if (value.length < 7) {
      return 'Độ dài mật khẩu phải lớn hơn 6 ký tự'.tr;
    }
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
        await saveLoginData();
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => TransactionController());
        Get.lazyPut(() => ReportController());
        Get.off(() => const Home());
      } else {
        showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
      }
    } catch (e) {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithEmailGoogle() async {
    try {
      isLoading.value = true;
      bool result = await fireBaseUtil.signInWithGoogle();
      if (result) {
        Get.lazyPut(() => HomeController());
        Get.lazyPut(() => TransactionController());
        Get.lazyPut(() => ReportController());
        Get.off(() => const Home());
      } else {
        showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
      }
    } catch (e) {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadLoginData();
  }
}
