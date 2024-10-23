import 'package:get/get.dart';

import '../utils/firebase/login/authentication.dart';

class ForgotPassController extends GetxController{
  final FireBaseUtil fireBaseUtil=FireBaseUtil();
  RxBool isLoading=false.obs;

  Future<void> sendEmaiAndResetPass(String emailSendReset)async{
    isLoading.value=true;
    bool resultSend=await fireBaseUtil.sendPasswordResetEmail(emailSendReset);
    if(resultSend==true){
      Get.snackbar('Success', 'Đã gửi thông báo đến email của bạn');
    }else{
      Get.snackbar('Erorr', 'Vui lòng thử lại!');
    }
    isLoading.value=false;
  }
}