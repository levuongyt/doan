import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/notifications/notifications.dart';
import '../utils/firebase/storage/firebase_storage.dart';
class AddCetegoryController extends GetxController {
  final TransactionController transactionController = Get.find();
  FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  RxBool isLoading = false.obs;
  RxInt selectedIconTNCode = Icons.home.codePoint.obs;
  RxInt selectedIconCTCode = Icons.home.codePoint.obs;
  RxInt selectedTNColor = Colors.red.toARGB32().obs;
  RxInt selectedCTColor = Colors.red.toARGB32().obs;

  Future<void> addCategory(
      String nameDM, int iconCode, int colorIcon, String type) async {
    isLoading.value = true;
    try {
      await firebaseStorageUtil.addCategory(
          name: nameDM, iconCode: iconCode, colorIcon: colorIcon, type: type);
      showSnackbar('Thành công'.tr, 'Danh mục đã được thêm thành công'.tr, true);
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
    } catch (e) {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value = false;
  }

  String? checkNameCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên danh mục'.tr;
    } else if (value.length > 200) {
      return 'Độ dài Nội dung không được quá 200 ký tự'.tr;
    }
    return null;
  }
}
