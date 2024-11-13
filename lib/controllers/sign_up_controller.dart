import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/login/authentication.dart';
import '../utils/firebase/storage/firebase_storage.dart';

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
      return 'Email không được bỏ trống';
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
      return 'Password không được bỏ trống';
    } else if (value.length < 6) {
      return 'Độ dài Password phải từ 6 ký tự trở lên';
    }
    //else if(!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$').hasMatch(value)){
    //  return 'Password chưa đúng định dạng';
    //}
    return null;
  }

  String? ktUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên tài khoản không được bỏ trống';
    } else if (value.length < 6) {
      return 'Tên tài khoản phải từ 6 ký tự trở lên';
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
      Get.snackbar('Success', 'Đăng ký tài khoản thành công');
      //  print('${isLoading.value}');
    } else {
      Get.snackbar('Error', 'Mời thử lại');
    }
    isLoading.value = false;
  }


}
