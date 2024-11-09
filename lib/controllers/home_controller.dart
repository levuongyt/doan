import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Models/category_model.dart';
import '../Models/report_model.dart';
import '../config/category/category_app.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';

class HomeController extends GetxController {
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final SettingController settingController = Get.find();
  final DanhMuc danhMuc = DanhMuc();
  List<TransactionModel> transactions = <TransactionModel>[].obs;
  List<TransactionModel> listResultTK = <TransactionModel>[].obs;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxMap<String, Map<String, dynamic>> categoryIdToDetails =
      <String, Map<String, dynamic>>{}.obs;
  Rxn<ReportModel> report = Rxn<ReportModel>();
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  RxBool isVisibility = false.obs;
  RxBool isLoading = false.obs;
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
    print('donvitiente: ${donViTienTe.value}');
  }

  double convertAmount(double amount) {
    return settingController.convertAmount(amount);
  }

  Future<void> getUserTransactions() async {
    isLoading.value = true;
    List<TransactionModel> response =
        await firebaseStorageUtil.getUserTransactions();
    if (response.isEmpty) {
      // Get.snackbar('ERROR', 'Lỗi');
    } else {
      transactions.clear();
      transactions.addAll(response);
      await getCategoriesForTransactions();
      //  await firebaseStorageUtil.getCategoriesTransaction(uid)
      listResultTK.clear();
      // listResultTK.assignAll(transactions);
      listResultTK
          .addAll(transactions.take(itemsPerPage * currentPage).toList());
      //  print('ds đang hiển thị ở fech: $listResultTK');
    }

    isLoading.value = false;
  }

  Future<void> loadMoreTransactions() async {
    if (!isSearching.value && !isLoadingMore.value && !loadAll.value) {
      isLoadingMore.value = true;
      print('Loading more transactions...');
      await Future.delayed(Duration(seconds: 2));
      currentPage++;
      var newTransactions = transactions
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();
      if (newTransactions.isNotEmpty) {
        listResultTK.addAll(newTransactions);
        print('Loaded ${newTransactions.length} more transactions.');
      } else {
        loadAll.value = true;
        print('No more transactions to load.');
      }
      isLoadingMore.value = false;
    }else { print('Currently loading, please wait...'); }
  }

  Future<void> updateTotalBalance(double newTotalBalance) async {
    isLoading.value = true;
    // bool resultUpdate=await FirebaseStorageUtil.singleton.updateTotalBalance(newTotalBalance);
    bool resultUpdate =
        await firebaseStorageUtil.updateTotalBalance(newTotalBalance);
    if (resultUpdate == true) {
      await getUser();
      Get.snackbar('Thành công', 'Thiết lập số dư ban đầu thành công');
    } else {
      Get.snackbar('Lỗi', 'Thất bại');
    }
    isLoading.value = false;
  }

  Future<void> getUser() async {
    isLoading.value = true;
    userModel.value = null;
    userModel.value = await firebaseStorageUtil.getUser();
    print('DS1 là: ${userModel.value?.tongSoDu}');
    if (userModel.value == null) {
      print('lỗi là ');
      Get.snackbar('ERROR1', 'Lỗi');
    } else {}
    isLoading.value = false;
  }

  String? dateValidator(String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }
    final datePattern = RegExp(r"^\d{2}/\d{2}/\d{4}$");

    if (!datePattern.hasMatch(date)) {
      return 'Mời nhập định dạng ngày (dd/MM/yyyy)';
    }
    // final dateParts = date.split('/');
    // if (dateParts.length != 3) {
    //   return 'Mời nhập định dạng ngày dd/MM/yyyy';
    // }
    return null;
  }

  Future<void> searchTransaction(DateTime? selectedDate) async {
    if (selectedDate == null) {
      isSearching.value=false;
      listResultTK.assignAll(transactions.take(itemsPerPage * currentPage).toList());
     // listResultTK.assignAll(transactions);
      print('ds đang hiển thị ở: $listResultTK');
    } else {
      isSearching.value=true;
      final dateFormatter = DateFormat('dd/MM/yyyy');
      final formattedDate = dateFormatter.format(selectedDate);
      listResultTK.assignAll(transactions
          .where((transaction) {
             return dateFormatter.format(transaction.date) == formattedDate;
             }).toList());
          //   return dateFormatter.format(transaction.date) == formattedDate;
          // })
          // .toList()
          // .take(itemsPerPage * currentPage)
          // .toList());
      print('ds đang hiển thị ở 1: ${listResultTK.length}');
    }
  }

  Future<void> getCategoriesForTransactions() async {
    categoryIdToDetails.clear();
    for (var transaction in transactions) {
      if (!categoryIdToDetails.containsKey(transaction.categoryId)) {
        CategoryModel? category = await firebaseStorageUtil
            .getCategoriesTransaction(transaction.categoryId);
        if (category != null) {
          categoryIdToDetails[transaction.categoryId] = {
            'name': category.name,
            'iconCode': category.iconCode,
            'colorIcon': category.colorIcon,
          };
        }
        // else {
        //   CategoryModel? defaultCategory = danhMuc.dsDMThuNhapMacDinh.firstWhereOrNull((dm) =>
        //   dm.id == transaction.categoryId)
        //       ??
        //       danhMuc.dsDMChiTieuMacDinh.firstWhereOrNull((dm) => dm.id == transaction.categoryId);
        //   if (defaultCategory != null) {
        //     categoryIdToDetails[transaction.categoryId] = {
        //       'name': defaultCategory.name,
        //       'iconCode': defaultCategory.iconCode,
        //       'colorIcon': defaultCategory.colorIcon,
        //     };
        //   }
        // }
      }
    }
  }

  // Future<void> getReport() async {
  //   DocumentSnapshot? reportSnapshot =
  //   await firebaseStorageUtil.getReport(selectedMonth.value);
  //   if (reportSnapshot != null && reportSnapshot.exists) {
  //     report.value = ReportModel.fromDocument(reportSnapshot);
  //     print('success');
  //   } else {
  //     print('loi');
  //     report.value = null;
  //   }
  // }
  Future<void> getReport() async {
    ReportModel? reportModel =
        await firebaseStorageUtil.getReport(selectedMonth.value);
    if (reportModel != null) {
      report.value = reportModel;
      // reportData.value=reportModel.toMap();
      print('success');
    } else {
      print('khong co thang.');
      report.value = null;
      //  reportData.value={};
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
