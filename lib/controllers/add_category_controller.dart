import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/storage/firebase_storage.dart';
class AddCetegoryController extends GetxController {
  final TransactionController transactionController = Get.find();
  FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  RxBool isLoading = false.obs;
  RxInt selectedIconTNCode = Icons.home.codePoint.obs;
  RxInt selectedIconCTCode = Icons.home.codePoint.obs;
  RxInt selectedTNColor = Colors.red.value.obs;
  RxInt selectedCTColor = Colors.red.value.obs;

  Future<void> addCategory(
      String nameDM, int iconCode, int colorIcon, String type) async {
    isLoading.value = true;
    try {
      await firebaseStorageUtil.addCategory(
          name: nameDM, iconCode: iconCode, colorIcon: colorIcon, type: type);
     // Get.snackbar('Success', 'Thêm thành công');
      Get.snackbar(
        'Thành công',
        'Danh mục đã được thêm thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
    } catch (e) {
      Get.snackbar(
        'Thất bại',
        'Bạn vui lòng kiểm tra lại thông tin!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.error, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
     // Get.snackbar('Error', 'Lỗi');
    }
    isLoading.value = false;
  }

  String? checkNameCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên danh mục';
    } else if (value.length > 200) {
      return 'Độ dài Nội dung không được quá 200 ký tự';
    }
    return null;
  }
}
