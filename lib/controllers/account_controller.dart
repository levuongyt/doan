import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/utils/firebase/login/authentication.dart';
import 'package:doan_ql_thu_chi/utils/firebase/storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/user_model.dart';

class AccountController extends GetxController{
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final HomeController homeController=Get.find();
  RxBool isLoading=false.obs;
  final FireBaseUtil fireBaseUtil=FireBaseUtil();
  final FirebaseStorageUtil firebaseStorageUtil=FirebaseStorageUtil();

  void resetController(){
    Get.delete<HomeController>();
  }

  Future<void> getUser() async {
    isLoading.value = true;
    userModel.value = null;
    userModel.value = await firebaseStorageUtil.getUser();
    if (userModel.value == null) {
      Get.snackbar('ERROR1', 'Lỗi');
    } else {}
    isLoading.value = false;
  }

  Future<void> updateNameUser(String newName) async{
    isLoading.value=true;
    bool resultUpdate=await firebaseStorageUtil.updateNameUser(newName);
    if(resultUpdate==true){
      Get.snackbar(
        'Thành công',
        'Tên tài khoản đã được cập nhật thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
      await getUser();
      await homeController.getUser();
    }else{
      Get.snackbar(
        'Thất bại',
        'Vui lòng kiểm tra lại thông tin!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
    isLoading.value=false;
  }


  String? checkUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên tài khoản không được bỏ trống';
    } else if (value.length < 6) {
      return 'Tên tài khoản phải từ 6 ký tự trở lên';
    }
    return null;
  }


  Future<void> resetPass(String emailReset) async {
    isLoading.value = true;
    bool resultSend = await fireBaseUtil.sendPasswordResetEmail(emailReset);
    if (resultSend == true) {
      Get.snackbar(
        'Thành công',
        'Đã gửi thông báo đến email của bạn',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } else {
      Get.snackbar(
        'Thất bại',
        'Vui lòng kiểm tra lại thông tin!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
    isLoading.value = false;
  }

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUser();
  }
}