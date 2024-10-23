import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doan_ql_thu_chi/config/danhmuc/danh_muc_app.dart';
import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../Models/category_model.dart';
import '../Models/report_model.dart';
import '../models/transaction_model.dart';
import '../models/user_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';

class HomeController extends GetxController{
  final FirebaseStorageUtil firebaseStorageUtil=FirebaseStorageUtil();
  final DanhMuc danhMuc=DanhMuc();
  List<TransactionModel> transactions = <TransactionModel>[].obs;
  List<TransactionModel> listResultTK=<TransactionModel>[].obs;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  RxMap<String, Map<String, dynamic>> categoryIdToDetails = <String, Map<String, dynamic>>{}.obs;
  Rxn<ReportModel> report = Rxn<ReportModel>();
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  RxBool isVisibility=false.obs;
  RxBool isLoading = false.obs;

  void changeIsVisibility(){
    isVisibility.value=!isVisibility.value;
  }

  Future<void> getUserTransactions() async {
    isLoading.value = true;
    List<TransactionModel> response = await firebaseStorageUtil.getUserTransactions();
    if(response.isEmpty){
      // Get.snackbar('ERROR', 'Lỗi');
    }else{
      transactions.clear();
      transactions.addAll(response);
      await getCategoriesForTransactions();
      //  await firebaseStorageUtil.getCategoriesTransaction(uid)
      listResultTK.clear();
      listResultTK.assignAll(transactions);
      //  print('ds đang hiển thị ở fech: $listResultTK');

    }

    isLoading.value = false;
  }

  Future<void> getUser() async {
    isLoading.value = true;

    userModel.value = null;
    userModel.value = await firebaseStorageUtil.getUser();
    print('DS1 là: ${userModel.value?.tongSoDu}');
    if(userModel.value==null){
      print('lỗi là ');
      Get.snackbar('ERROR1', 'Lỗi');
    }else{

    }
    isLoading.value = false;
  }

  Future<void> searchTransaction(DateTime? selectedDate) async{
    if(selectedDate == null){
      listResultTK.assignAll(transactions);
      print('ds đang hiển thị ở: $listResultTK');
    }else{
      final dateFormatter=DateFormat('dd/MM/yyyy');
      final formattedDate=dateFormatter.format(selectedDate);
      listResultTK.assignAll(transactions.where((transaction){
        return dateFormatter.format(transaction.date)==formattedDate;
      }).toList());
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
        else {
          CategoryModel? defaultCategory = danhMuc.dsDMThuNhapMacDinh.firstWhereOrNull((dm) =>
          dm.id == transaction.categoryId)
              ??
              danhMuc.dsDMChiTieuMacDinh.firstWhereOrNull((dm) => dm.id == transaction.categoryId);
          if (defaultCategory != null) {
            categoryIdToDetails[transaction.categoryId] = {
              'name': defaultCategory.name,
              'iconCode': defaultCategory.iconCode,
              'colorIcon': defaultCategory.colorIcon,
            };
          }
        }
      }
    }
  }
  Future<void> getReport() async {
    DocumentSnapshot? reportSnapshot =
    await firebaseStorageUtil.getReport(selectedMonth.value);
    if (reportSnapshot != null && reportSnapshot.exists) {
      report.value = ReportModel.fromDocument(reportSnapshot);
      print('success');
    } else {
      print('loi');
      report.value = null;
    }
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    getReport();
  }

  @override
  void onInit(){
    // TODO: implement onInit
    super.onInit();
    getUserTransactions();
    getUser();
    getCategoriesForTransactions();
    getReport();
  }

}