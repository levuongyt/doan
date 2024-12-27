import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/notifications/notifications.dart';
import '../utils/firebase/login/authentication.dart';
import '../utils/firebase/storage/firebase_storage.dart';
import '../views/home/home.dart';
import 'home_controller.dart';
import 'transaction_controller.dart';

class SignUpController extends GetxController {

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode usernameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  RxBool isVisibility = false.obs;
  RxBool isLoading = false.obs;

  final FireBaseUtil fireBaseUtil = FireBaseUtil();
  final FirebaseStorageUtil storageUtil = FirebaseStorageUtil();



  String? ktEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được bỏ trống'.tr;
    } else if (!RegExp(
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

  String? ktUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên tài khoản không được bỏ trống'.tr;
    } else if (value.length < 7) {
      return 'Tên tài khoản phải lớn hơn 6 ký tự'.tr;
    }
    return null;
  }

  void xuLiVisibility() {
    isVisibility.value = !isVisibility.value;
  }

  Future<void> signUp(String email, String name, String pass, double soDu) async {
    isLoading.value = true;
    bool result = await fireBaseUtil.register(email, name, pass, soDu);
    if (result == true) {
      Get.lazyPut(() => HomeController());
      Get.lazyPut(() => TransactionController());
      Get.lazyPut(() => ReportController());
      Get.off(const Home());
    } else {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value = false;
  }


}
