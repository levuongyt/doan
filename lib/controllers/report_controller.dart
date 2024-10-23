import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Models/report_model.dart';
import '../utils/firebase/storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportController extends GetxController {
  final FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  Rxn<ReportModel> report = Rxn<ReportModel>();
  Rx<DateTime> selectedMonth = DateTime.now().obs;

  Future<void> fetchReport() async {
    DocumentSnapshot? reportSnapshot =
        await firebaseStorageUtil.getReport(selectedMonth.value);
    if (reportSnapshot != null && reportSnapshot.exists) {
      report.value = ReportModel.fromDocument(reportSnapshot);
      print('success');
    } else {
      print('khong co thang.');
      report.value = null;
    }
  }

  void updateSelectedMonth(DateTime newMonth) {
    selectedMonth.value = newMonth;
    fetchReport();
  }
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchReport();
  }
}
