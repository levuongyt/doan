import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/notifications/notifications.dart';
import '../utils/firebase/login/authentication.dart';

class ForgotPassController extends GetxController{
  final FireBaseUtil fireBaseUtil=FireBaseUtil();
  RxBool isLoading=false.obs;

  Future<void> sendEmaiAndResetPass(String emailSendReset)async{
    isLoading.value=true;
    bool resultSend=await fireBaseUtil.sendPasswordResetEmail(emailSendReset);
    if(resultSend==true){
      showSnackbar('Thành công'.tr, 'Đã gửi thông báo đến email của bạn'.tr, true);
    }else{
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value=false;
  }

  String? ktEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được bỏ trống'.tr;
    }else if (!RegExp(
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
}