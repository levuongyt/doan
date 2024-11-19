import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/views/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/notifications/notifications.dart';
import '../utils/firebase/login/authentication.dart';
import '../utils/firebase/storage/firebase_storage.dart';
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
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return 'Email không đúng định dạng'.tr;
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
      return 'Mật khẩu không được bỏ trống'.tr;
    } else if (value.length < 6) {
      return 'Độ dài mật khẩu phải lớn hơn 6 ký tự'.tr;
    }
    //else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$').hasMatch(value)){
    //  return 'Password chưa đúng định dạng';
    //}
    return null;
  }

  String? ktUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên tài khoản không được bỏ trống'.tr;
    } else if (value.length < 6) {
      return 'Tên tài khoản phải lớn hơn 6 ký tự'.tr;
    }
    return null;
  }

  // String? ktNhapLaiPass(String? value){
  //   if(value == null || value.isEmpty){
  //     return 'Password Không được bỏ trống';
  //   }else if(value != passwordController.text){
  //     return 'Password không trùng khớp';
  //   }
  //   return null;
  // }

  void xuLiVisibility() {
    isVisibility.value = !isVisibility.value;
  }

  ///Dang kY
  // Future<void> signUp(String email, String pass) async {
  //   isLoading.value = true;
  //   bool result = await fireBaseUtil.register(email, pass);
  //   if (result == true) {
  //     Get.snackbar('Success', 'Đăng ký tài khoản thành công');
  //   //  print('${isLoading.value}');
  //   } else {
  //     Get.snackbar('Error', 'Mời thử lại');
  //   }
  //   isLoading.value = false;
  // }


  Future<void> signUp(String email, String name, String pass, double soDu) async {
    isLoading.value = true;
    bool result = await fireBaseUtil.register(email, name, pass, soDu);
    if (result == true) {
      // await storageUtil.addUsers(Email: email, name: name, ngayTao: DateTime.now(), tongSoDu: soDu, uid: );
     // Get.snackbar('Success', 'Đăng ký tài khoản thành công');
      Get.lazyPut(() => HomeController());
      Get.lazyPut(() => TransactionController());
      Get.lazyPut(() => ReportController());
      //  print('${isLoading.value}');
      Get.off(const Home());
    } else {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value = false;
  }


}
