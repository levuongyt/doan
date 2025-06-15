import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/utils/firebase/login/authentication.dart';
import 'package:doan_ql_thu_chi/utils/firebase/storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../config/notifications/notifications.dart';
import '../models/user_model.dart';

class AccountController extends GetxController{
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final HomeController homeController=Get.find();
  RxBool isLoading=false.obs;
  final FireBaseUtil fireBaseUtil=FireBaseUtil();
  final FirebaseStorageUtil firebaseStorageUtil=FirebaseStorageUtil();
  
  // Avatar management
  RxString selectedAvatar = 'assets/images/avatarboy.png'.obs;

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
      showSnackbar('Thành công'.tr,'Tên tài khoản đã được cập nhật thành công'.tr, true);
      await getUser();
      await homeController.getUser();
    }else{
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value=false;
  }


  String? checkUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tên tài khoản không được bỏ trống'.tr;
    } else if (value.length < 6) {
      return 'Tên tài khoản phải lớn hơn 6 ký tự'.tr;
    }
    return null;
  }


  Future<void> resetPass(String emailReset) async {
    isLoading.value = true;
    bool resultSend = await fireBaseUtil.sendPasswordResetEmail(emailReset);
    if (resultSend == true) {
      showSnackbar('Thành công'.tr, 'Thông báo đã được gửi tới email của bạn'.tr, true);
    } else {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value = false;
  }

  void changeAvatar(String avatarPath) {
    selectedAvatar.value = avatarPath;
    // TODO: Save to preferences or server if needed
  }

 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUser();
  }
}