import 'package:doan_ql_thu_chi/config/notifications/notifications.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/login/authentication.dart';
import '../views/home/home.dart';
import '../views/login/login_loading_screen.dart';
import 'home_controller.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isVisibility = false.obs;
  RxBool isLoading = false.obs;
  final FireBaseUtil fireBaseUtil = FireBaseUtil();

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
      isLoading.value = false;
      
      if (result) {
        // Show loading animation first
        Get.off(
          () => LoginLoadingScreen(
            title: 'Chào mừng trở lại!'.tr,
            subtitle: 'Đang thiết lập tài khoản của bạn...'.tr,
            onAnimationComplete: () {
              // After animation completes, go to Home
              Get.lazyPut(() => HomeController());
              Get.lazyPut(() => TransactionController());
              Get.lazyPut(() => ReportController());
              Get.off(() => const Home());
            },
          ),
          transition: Transition.fadeIn,
        );
      } else {
        showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
      }
    } catch (e) {
      isLoading.value = false;
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
  }

  Future<void> signInWithEmailGoogle() async {
    try {
      isLoading.value = true;
      bool result = await fireBaseUtil.signInWithGoogle();
      isLoading.value = false;
      
      if (result) {
        // Show loading animation with Google-specific text
        Get.off(
          () => LoginLoadingScreen(
            title: 'Đăng nhập Google thành công!'.tr,
            subtitle: 'Đang đồng bộ tài khoản Google...'.tr,
            onAnimationComplete: () {
              // After animation completes, go to Home
              Get.lazyPut(() => HomeController());
              Get.lazyPut(() => TransactionController());
              Get.lazyPut(() => ReportController());
              Get.off(() => const Home());
            },
          ),
          transition: Transition.fadeIn,
        );
      } else {
        showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
      }
    } catch (e) {
      isLoading.value = false;
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
