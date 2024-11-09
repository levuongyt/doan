import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Models/category_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';
import 'home_controller.dart';

class TransactionController extends GetxController {
  final HomeController homeController = Get.find();
  final ReportController reportController = Get.find();
  final SettingController settingController = Get.find();
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();

  // RxString selectedCategory = ''.obs;
  RxString selectedIncomeCategory = ''.obs;
  RxString selectedExpenseCategory = ''.obs;
  RxString select = ''.obs;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> listIncomeCategory = <CategoryModel>[].obs;
  RxList<CategoryModel> listExpenseCategory = <CategoryModel>[].obs;
  RxDouble totalBalance = 0.0.obs;
  Rx<String> donViTienTe = ''.obs;

  ///So du moi
  double calculateNewBalance(double amount, String type) {
    if (type == 'Thu Nhập') {
      return totalBalance.value + amount;
    } else {
      return totalBalance.value - amount;
    }
  }

  void selectIncomeCategory(String category) {
    selectedIncomeCategory.value = category;
    print('abccc');
  }

  void selectExpenseCategory(String category) {
    selectedExpenseCategory.value = category;
    print('abccc11');
  }

  Future<void> layDanhMucThuNhap() async {
    listIncomeCategory.clear();
    listIncomeCategory.value =
        await firebaseStorageUtil.getCategories(type: 'Thu Nhập');
    // listIncomeCategory.addAll(danhMuc.dsDMThuNhapMacDinh);
    if (listIncomeCategory.isNotEmpty && selectedIncomeCategory.isEmpty) {
      selectedIncomeCategory.value = listIncomeCategory[0].id ?? "";
      print('tn ${selectedIncomeCategory.value}');
    }
  }

  Future<void> layDanhMucChiTieu() async {
    listExpenseCategory.clear();
    listExpenseCategory.value =
        await firebaseStorageUtil.getCategories(type: 'Chi Tiêu');
    // listExpenseCategory.addAll(danhMuc.dsDMChiTieuMacDinh);
    if (listExpenseCategory.isNotEmpty && selectedExpenseCategory.isEmpty) {
      selectedExpenseCategory.value = listExpenseCategory[0].id ?? "";
      print('ct ${selectedExpenseCategory.value}');
    }
    print('ds hiện đânh có: ${listExpenseCategory.length}');
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    required String categoryId,
    required String type,
    required DateTime date,
  }) async {
    if (categoryId.isEmpty) {
      if (type == 'Thu Nhập' && listIncomeCategory.isNotEmpty) {
        categoryId = listIncomeCategory[0].id ?? "";
      } else if (type == 'Chi Tiêu' && listExpenseCategory.isNotEmpty) {
        categoryId = listExpenseCategory[0].id ?? "";
      }
    }
    isLoading.value = true;
    try {
      await firebaseStorageUtil.addTransaction(
        amount: amount,
        description: description,
        categoryId: categoryId,
        type: type,
        date: date,
      );
      await homeController.getUser();
      await homeController.getUserTransactions();
      homeController.update();
      //Get.snackbar('Success', 'Thành công');
      Get.snackbar(
        'Thành công',
        'Giao dịch đã được thêm thành công',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(16),
        borderRadius: 8,
      );
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
      //  print('loi khi add transaction la: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveMonthlyReport(DateTime month) async {
    await firebaseStorageUtil.saveMonthlyReport(month);
    await homeController.getReport();
    await reportController.fetchReport();
    print('da dc');
  }

  String? ktNoiDung(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length > 100) {
      return 'Độ dài không được quá 100 ký tự';
    }
    return null;
  }

  String? ktSoTien(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số tiền';
    } else if (value.length > 11) {
      return 'Độ dài không được quá 11 ký tự';
    } else if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
      return 'Số tiền phải là số hợp lệ';
    } else if (double.tryParse(value)! <= 0) {
      return 'Số tiền phải lớn hơn 0';
    }
    return null;
  }

  String? validateMoney(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số tiền không được để trống';
    }
    try {
      final parsedValue = int.parse(value.replaceAll(',', ''));
      if (parsedValue <= 0) {
        return 'Số tiền phải lớn hơn 0';
      }
      if (value.replaceAll(',', '').length > 12) {
        return 'Số tiền phải nhỏ hơn 12 chữ số';
      }
    } catch (e) {
      return 'Số tiền không hợp lệ';
    }
    return null;
  }

//Dơn vị tiền tệ
  void getCurrency() {
    donViTienTe.value = settingController.getCurrencySymbol();
    print('donvitiente: ${donViTienTe.value}');
  }

  void updateCurrency() {
    settingController.selectedCurrency.listen((newCurrency) {
      getCurrency();
    });
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    layDanhMucThuNhap();
    layDanhMucChiTieu();
    getCurrency();
    updateCurrency();
  }
}
