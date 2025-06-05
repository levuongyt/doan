import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/models/report_model.dart';
import 'package:doan_ql_thu_chi/models/transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/storage/firebase_storage.dart';

class ReportController extends GetxController {
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  final SettingController settingController=Get.find();
  Rxn<ReportModel> report = Rxn<ReportModel>();
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
      await Future.delayed(const Duration(seconds: 2));
      currentPage++;
      var newTransactions = categoryTransactions
          .skip((currentPage - 1) * itemsPerPage)
          .take(itemsPerPage)
          .toList();
      if (newTransactions.isNotEmpty) {
        categoryTransactions.addAll(newTransactions);
      } else {
        loadAll.value = true;
      }
      isLoadingMore.value = false;
    }else {
    }
  }

  Future<void> fetchReport() async {
    ReportModel? reportModel = await firebaseStorageUtil.getReport(selectedMonth.value);
    if (reportModel != null) {
      report.value = reportModel;
    } else {
      report.value = null;
    }
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    fetchReport();
  }

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

  void getCurrency(){
    donViTienTe.value=settingController.getCurrencySymbol();
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
  }
}
