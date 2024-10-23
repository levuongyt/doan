import 'package:doan_ql_thu_chi/config/danhmuc/danh_muc_app.dart';
import 'package:get/get.dart';
import '../Models/category_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';
import 'home_controller.dart';

class TransactionController extends GetxController {
  final HomeController homeController = Get.find();
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final DanhMuc danhMuc=DanhMuc();
  RxString selectedCategory = ''.obs;
  RxString select = ''.obs;
  RxBool isLoading = false.obs;
  RxList<CategoryModel> listIncomeCategory = <CategoryModel>[].obs;
  RxList<CategoryModel> listExpenseCategory = <CategoryModel>[].obs;
  RxDouble totalBalance = 0.0.obs;


  ///So du moi
  double calculateNewBalance(double amount, String type) {
    if (type == 'Thu Nhập') {
      return totalBalance.value + amount;
    } else {
      return totalBalance.value - amount;
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    print('abccc');
  }

  Future<void> layDanhMucThuNhap() async {
    listIncomeCategory.clear();
    listIncomeCategory.value =
    await firebaseStorageUtil.getCategories(type: 'Thu Nhập');
    listIncomeCategory.addAll(danhMuc.dsDMThuNhapMacDinh);
    print('ds thu nhập hiện đânh có: ${listExpenseCategory.value.length}');
  }

  Future<void> layDanhMucChiTieu() async {
    listExpenseCategory.clear();
    listExpenseCategory.value =
    await firebaseStorageUtil.getCategories(type: 'Chi Tiêu');
    listExpenseCategory.addAll(danhMuc.dsDMChiTieuMacDinh);
    print('ds hiện đânh có: ${listExpenseCategory.length}');
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    required String categoryId,
    required String type,
    required DateTime date,
  }) async {
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
      Get.snackbar('Success', 'Thành công');
    } catch (e) {
      print('loi khi add transaction la: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveMonthlyReport(DateTime month) async {
    await firebaseStorageUtil.saveMonthlyReport(month);
    await homeController.getReport();
    print('da dc');
  }


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    layDanhMucThuNhap();
    layDanhMucChiTieu();
  }
}
