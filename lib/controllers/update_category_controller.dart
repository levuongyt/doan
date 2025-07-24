import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:doan_ql_thu_chi/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../config/notifications/notifications.dart';
import '../utils/firebase/storage/firebase_storage.dart';

class UpdateCategoryController extends GetxController {
  final TransactionController transactionController = Get.find();
  final HomeController homeController=Get.find();
  final ReportController reportController=Get.find();
  FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  var categories = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxInt selectedIconTNCode = Icons.home.codePoint.obs;
  RxInt selectedTNColor = Colors.red.toARGB32().obs;

  Future<void> updateCategory(
      String id, String nameDM, int iconDM, int colorDM, String typeDM) async {
    isLoading.value=true;
    bool resultUpdate = await firebaseStorageUtil.updateCategory(id: id,name: nameDM, icon: iconDM, color: colorDM, type: typeDM);
    if (resultUpdate == true) {
      showSnackbar('Thành công'.tr, 'Danh mục đã được sửa thành công'.tr, true);
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
      await transactionController.saveMonthlyReport(DateTime.now());
      await homeController.getCategoriesForTransactions();
    }else{
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value=false;
  }

  Future<void> deleteCategory(String idDM)async{
    isLoading.value=true;
    bool resultDelete=await firebaseStorageUtil.deleteCategory(id: idDM);
    if(resultDelete==true){
      showSnackbar('Thành công'.tr, 'Danh mục đã được xóa thành công'.tr, true);
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
    }else{
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isLoading.value=false;
}

  String? checkNameDM(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên danh mục'.tr;
    } else if (value.length > 200) {
      return 'Độ dài không được quá 100 ký tự'.tr;
    }
    return null;
  }
}
