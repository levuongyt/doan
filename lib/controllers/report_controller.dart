import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/report_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';

class ReportController extends GetxController {
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final SettingController settingController=Get.find();
  Rxn<ReportModel> report = Rxn<ReportModel>();
 // var reportData={}.obs;
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  RxList<TransactionModel> categoryTransactions = <TransactionModel>[].obs;
  RxString donViTienTe=''.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool loadAll = false.obs;

  final int itemsPerPage = 6;
  int currentPage = 1;

  Future<void> loadMoreTransactions() async {
    if (!isLoadingMore.value && !loadAll.value) {
      isLoadingMore.value = true;
      print('Loading more transactions...');
      await Future.delayed(Duration(seconds: 2));
      currentPage++;
      var newTransactions = categoryTransactions
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();
      if (newTransactions.isNotEmpty) {
        categoryTransactions.addAll(newTransactions);
        print('Loaded ${newTransactions.length} more transactions.');
      } else {
        loadAll.value = true;
        print('No more transactions to load.');
      }
      isLoadingMore.value = false;
    }else { print('Currently loading, please wait...'); }
  }
  // Future<void> fetchReport() async {
  //   DocumentSnapshot? reportSnapshot = await firebaseStorageUtil.getReport(selectedMonth.value);
  //   if (reportSnapshot != null && reportSnapshot.exists) {
  //     report.value = ReportModel.fromDocument(reportSnapshot);
  //     print('success');
  //   } else {
  //     print('khong co thang.');
  //     report.value = null;
  //   }
  // }


  Future<void> fetchReport() async {
    ReportModel? reportModel = await firebaseStorageUtil.getReport(selectedMonth.value);
    if (reportModel != null) {
      report.value = reportModel;
     // reportData.value=reportModel.toMap();
      print('success');
      print('dssss: ${report.value?.categories}');
     // print('adsds: ${reportData.value}');
    } else {
      print('khong co thang.');
      report.value = null;
     // reportData.value={};
    }
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    fetchReport();
    //  fetchMonthlyReport();
  }

  ///Chi tiết baos cáo
  Future<void> fetchCategoryTransactions(String categoryId) async {
    List<TransactionModel> transactions = await firebaseStorageUtil.getCategoryTransactions(selectedMonth.value, categoryId);
    categoryTransactions.value = transactions;
  }

  List<PieChartSectionData> getSectionsThuNhap() {
    if (report.value == null || report.value?.categories == null) {
      return [];
    }
    final categories = report.value?.categories?.values.where((category)=>category.type=='Thu Nhập')??[];
    List<PieChartSectionData> sections = [];
    for(var category in categories) {
      sections.add(
        PieChartSectionData(
         // title: category.name,
          title: '${category.percentage.toStringAsFixed(1)}%',
          value: category.totalAmount,
          color: Color(category.color),
        ),
      );
    }
    return sections;
  }

  List<PieChartSectionData> getSectionsChiTieu() {
    if (report.value == null || report.value?.categories == null) {
      return [];
    }
    final categories = report.value?.categories?.values.where((category)=>category.type=='Chi Tiêu')??[];
    List<PieChartSectionData> sections = [];
    for(var category in categories) {
      sections.add(
        PieChartSectionData(
          title: '${category.percentage.toStringAsFixed(1)}%',
          value: category.totalAmount,
          color: Color(category.color),
        ),
      );
    }
    return sections;
  }

  ///Tiền tệ
  void getCurrency(){
    donViTienTe.value=settingController.getCurrencySymbol();
    print('donvitiente: ${donViTienTe.value}');
  }
  double convertAmount(double amount) {
    return settingController.convertAmount(amount);
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
    fetchReport();
    getCurrency();
    updateCurrency();
    // fetchMonthlyReport();
  }
}
