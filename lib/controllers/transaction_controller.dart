import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/models/category_model.dart';
import 'package:get/get.dart';
import '../config/notifications/notifications.dart';
import '../utils/firebase/storage/firebase_storage.dart';
import 'home_controller.dart';

class TransactionController extends GetxController {
  final HomeController homeController = Get.find();
  final ReportController reportController = Get.find();
  final SettingController settingController = Get.find();
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  RxString selectedIncomeCategory = ''.obs;
  RxString selectedExpenseCategory = ''.obs;
  RxString select = ''.obs;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> listIncomeCategory = <CategoryModel>[].obs;
  RxList<CategoryModel> listExpenseCategory = <CategoryModel>[].obs;
  RxDouble totalBalance = 0.0.obs;
  Rx<String> donViTienTe = ''.obs;

  double calculateNewBalance(double amount, String type) {
    if (type == 'Thu Nhập') {
      return totalBalance.value + amount;
    } else {
      return totalBalance.value - amount;
    }
  }

  void selectIncomeCategory(String category) {
    selectedIncomeCategory.value = category;
  }

  void selectExpenseCategory(String category) {
    selectedExpenseCategory.value = category;
  }

  Future<void> layDanhMucThuNhap() async {
    listIncomeCategory.clear();
    listIncomeCategory.value =
        await firebaseStorageUtil.getCategories(type: 'Thu Nhập');
    if (listIncomeCategory.isNotEmpty && selectedIncomeCategory.isEmpty) {
      selectedIncomeCategory.value = listIncomeCategory[0].id ?? "";
    }
  }

  Future<void> layDanhMucChiTieu() async {
    listExpenseCategory.clear();
    listExpenseCategory.value =
        await firebaseStorageUtil.getCategories(type: 'Chi Tiêu');
    if (listExpenseCategory.isNotEmpty && selectedExpenseCategory.isEmpty) {
      selectedExpenseCategory.value = listExpenseCategory[0].id ?? "";
    }
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
      showSnackbar('Thành công'.tr, 'Giao dịch đã được thêm thành công'.tr, true);
    } catch (e) {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveMonthlyReport(DateTime month) async {
    await firebaseStorageUtil.saveMonthlyReport(month);
    await homeController.getReport();
    await reportController.fetchReport();
  }

  String? ktNoiDung(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    } else if (value.length > 100) {
      return 'Độ dài không được quá 100 ký tự'.tr;
    }
    return null;
  }


  String? validateMoney(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số tiền không được để trống'.tr;
    }
    try {
      final parsedValue = double.parse(value.replaceAll(',', ''));
      if (parsedValue <= 0) {
        return 'Số tiền phải lớn hơn 0'.tr;
      }
      if (value.replaceAll(',', '').replaceAll('.', '').length > 12) {
        return 'Số tiền phải nhỏ hơn 12 chữ số'.tr;
      }
    } catch (e) {
      return 'Số tiền không hợp lệ'.tr;
    }
    return null;
  }

  void getCurrency() {
    donViTienTe.value = settingController.getCurrencySymbol();
  }

  void updateCurrency() {
    settingController.selectedCurrency.listen((newCurrency) {
      getCurrency();
    });
  }

  @override
  void onInit() {
    super.onInit();
    layDanhMucThuNhap();
    layDanhMucChiTieu();
    getCurrency();
    updateCurrency();
  }
}
