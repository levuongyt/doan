import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Models/category_model.dart';
import '../Models/report_model.dart';
import '../config/notifications/notifications.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';

class HomeController extends GetxController {
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final SettingController settingController = Get.find();
  List<TransactionModel> transactions = <TransactionModel>[].obs;
  List<TransactionModel> listResultTK = <TransactionModel>[].obs;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxMap<String, CategoryModel> categoryIdToDetails =
      <String, CategoryModel>{}.obs;
  Rxn<ReportModel> report = Rxn<ReportModel>();
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  RxBool isVisibility = false.obs;
  RxBool isLoading = false.obs;
  RxBool isUpdateLoading=false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool loadAll = false.obs;
  RxBool isSearching = false.obs;

  Rx<String> donViTienTe = ''.obs;
  final int itemsPerPage = 6;
  int currentPage = 1;

  void changeIsVisibility() {
    isVisibility.value = !isVisibility.value;
  }

  void getCurrency() {
    donViTienTe.value = settingController.getCurrencySymbol();
  }

  Future<void> getUserTransactions() async {
   // isLoading.value = true;
    List<TransactionModel> response =
        await firebaseStorageUtil.getUserTransactions();
    if (response.isEmpty) {
    } else {
      transactions.clear();
      transactions.addAll(response);
      await getCategoriesForTransactions();
      listResultTK.clear();
      listResultTK
          .addAll(transactions.take(itemsPerPage * currentPage).toList());
    }

  //  isLoading.value = false;
  }

  Future<void> loadMoreTransactions() async {
    if (!isSearching.value && !isLoadingMore.value && !loadAll.value) {
      isLoadingMore.value = true;
      await Future.delayed(const Duration(seconds: 2));
      currentPage++;
      var newTransactions = transactions
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();
      if (newTransactions.isNotEmpty) {
        listResultTK.addAll(newTransactions);
      } else {
        loadAll.value = true;
      }
      isLoadingMore.value = false;
    } else {}
  }

  Future<void> updateTotalBalance(double newTotalBalance) async {
   isUpdateLoading.value=true;
    bool resultUpdate =
        await firebaseStorageUtil.updateTotalBalance(newTotalBalance);
    if (resultUpdate == true) {
      await getUser();
      showSnackbar('Thành công'.tr, 'Thiết lập số dư ban đầu thành công'.tr, true);
    } else {
      showSnackbar('Thất bại'.tr, 'Vui lòng kiểm tra lại thông tin!'.tr, false);
    }
    isUpdateLoading.value=false;
  }

  Future<void> getUser() async {
    userModel.value = null;
    userModel.value = await firebaseStorageUtil.getUser();
    if (userModel.value == null) {
      Get.snackbar('ERROR1', 'Lỗi');
    } else {

    }
  }

  String? validateTotalBalance(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số tiền không được để trống'.tr;
    }
    try {
      if (value.replaceAll(',', '').length > 13) {
        return 'Số tiền phải nhỏ hơn 14 chữ số'.tr;
      }
    } catch (e) {
      return 'Số tiền không hợp lệ'.tr;
    }
    return null;
  }

  String? dateValidator(String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }
    final datePattern = RegExp(r"^\d{2}/\d{2}/\d{4}$");

    if (!datePattern.hasMatch(date)) {
      return 'Mời nhập định dạng ngày (dd/MM/yyyy)'.tr;
    }
    return null;
  }

  Future<void> searchTransaction(DateTime? selectedDate) async {
    if (selectedDate == null) {
      isSearching.value = false;
      listResultTK
          .assignAll(transactions.take(itemsPerPage * currentPage).toList());
    } else {
      isSearching.value = true;
      final dateFormatter = DateFormat('dd/MM/yyyy');
      final formattedDate = dateFormatter.format(selectedDate);
      listResultTK.assignAll(transactions.where((transaction) {
        return dateFormatter.format(transaction.date) == formattedDate;
      }).toList());
    }
  }

  Future<void> getCategoriesForTransactions() async {
    categoryIdToDetails.clear();
    for (var transaction in transactions) {
      if (!categoryIdToDetails.containsKey(transaction.categoryId)) {
        CategoryModel? category = await firebaseStorageUtil
            .getCategoriesTransaction(transaction.categoryId);
        if (category != null) {
          categoryIdToDetails[transaction.categoryId] = category;
        }
      }
    }
  }

  Future<void> getReport() async {
    ReportModel? reportModel =
        await firebaseStorageUtil.getReport(selectedMonth.value);
    if (reportModel != null) {
      report.value = reportModel;
    } else {
      report.value = null;
    }
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    getReport();
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
    getUserTransactions();
    getUser();
    getCategoriesForTransactions();
    getReport();
    getCurrency();
    updateCurrency();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
