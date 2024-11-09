import 'package:doan_ql_thu_chi/Models/category_model.dart';
import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/firebase/storage/firebase_storage.dart';

class UpdateCategoryController extends GetxController {
  final TransactionController transactionController = Get.find();
  final HomeController homeController=Get.find();
  final ReportController reportController=Get.find();
  FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  var categories = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxInt selectedIconTNCode = Icons.home.codePoint.obs;
  RxInt selectedTNColor = Colors.red.value.obs;

  Future<void> updateCategory(
      String id, String nameDM, int iconDM, int colorDM, String typeDM) async {
    isLoading.value=true;
    bool resultUpdate = await firebaseStorageUtil.updateCategory(id: id,name: nameDM, icon: iconDM, color: colorDM, type: typeDM);
    if (resultUpdate == true) {
      Get.snackbar(
        'Thành công',
        'Danh mục đã được sửa thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
    //  Get.snackbar('Success', 'Cập nhật thành công');
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
      await transactionController.saveMonthlyReport(DateTime.now());
      await homeController.getCategoriesForTransactions();
     // await reportController.fetchReport();
    }else{
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
     // Get.snackbar('Error', 'Thất bại');
    }
    isLoading.value=false;
  }

  Future<void> deleteCategory(String idDM)async{
    isLoading.value=true;
    bool resultDelete=await firebaseStorageUtil.deleteCategory(id: idDM);
    if(resultDelete==true){
      Get.snackbar(
        'Thành công',
        'Danh mục đã được xóa thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
     // Get.snackbar('Success', 'Xóa thành công');
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
    }else{
      Get.snackbar('Error', 'Lỗi');
    }
    isLoading.value=false;
}

  String? checkNameDM(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập tên danh mục';
    } else if (value.length > 200) {
      return 'Độ dài danh mục không được quá 200 ký tự';
    }
    return null;
  }
}
