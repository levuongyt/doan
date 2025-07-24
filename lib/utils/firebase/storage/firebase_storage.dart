import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../../models/category_model.dart';
import '../../../models/report_model.dart';
import '../../../models/transaction_model.dart';
import '../../../models/user_model.dart';

class FirebaseStorageUtil {
  static final FirebaseStorageUtil singleton = FirebaseStorageUtil._internal();
  factory FirebaseStorageUtil() {
    return singleton;
  }
  FirebaseStorageUtil._internal();
  final storage = FirebaseFirestore.instance;

  Future<void> addUsers(
      {required String uid,
      required String email,
      required String name,
      required DateTime ngayTao,
      required double tongSoDu}) async {
    try {
      await storage.collection('Users').doc(uid).set({
        'Email': email,
        'Name': name,
        'ngayTao': ngayTao,
        'tongSoDu': tongSoDu,
      });
    } catch (e) {
      // Error adding user to database
    }
  }

  Future<UserModel?> getUser() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final snapshot = await storage.collection('Users').doc(uid).get();
      return UserModel.fromDocument(snapshot);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateTotalBalance(double newTotalBalance) async {
    String uid=FirebaseAuth.instance.currentUser?.uid??'';
    bool result=false;
    try{
      await storage.collection('Users').doc(uid).update({'tongSoDu': newTotalBalance});
      result=true;
    }catch(e){
      result=false;
    }
    return result;
  }

  Future<bool> updateNameUser(String newName) async {
    String uid=FirebaseAuth.instance.currentUser?.uid??'';
    bool result=false;
    try{
      await storage.collection('Users').doc(uid).update({'Name': newName});
      result=true;
    }catch(e){
      result=false;
    }
    return result;
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    required String categoryId,
    required String type,
    required DateTime date,
  }) async {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      DocumentSnapshot snapshot =
          await storage.collection('Users').doc(uid).get();
      double tongSoDu = snapshot.get('tongSoDu') ?? 0.0;
      double soDuMoi;
      type == 'Thu Nhập'
          ? soDuMoi = tongSoDu + amount
          : soDuMoi = tongSoDu - amount;

      await storage.collection('Transactions').doc(const Uuid().v1()).set({
        'userId': uid,
        'tienGD': amount,
        'noiDungGD': description,
        'categoryId': categoryId,
        'loaiGD': type,
        'ngayGD': Timestamp.fromDate(date),
        'soDuCuoi':
            soDuMoi,
      });
      await storage.collection('Users').doc(uid).update({'tongSoDu': soDuMoi});
  }

  Future<List<TransactionModel>> getUserTransactions() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      QuerySnapshot snapshot = await storage
          .collection('Transactions')
          .where('userId', isEqualTo: uid)
          .get();
      final List<TransactionModel> result =
          snapshot.docs.map((e) => TransactionModel.fromDocument(e)).toList();
      return result;
    } catch (e) {
      return [];
    }
  }

  Future<void> addCategory(
      {required name,
      required iconCode,
      required colorIcon,
      required type}) async {
    try {
      await storage.collection('Categories').doc(const Uuid().v1()).set({
        'name': name,
        'iconCode': iconCode,
        'colorIcon': colorIcon,
        'type': type,
      });
    } catch (e) {
      // Error adding category to database
    }
  }

  Future<bool> updateCategory({required String id, required String name, required int icon,required int color, required String type}) async{
    bool result=false;
    try{
      await storage.collection('Categories').doc(id).update({
        'name': name,
        'iconCode':icon,
        'colorIcon':color,
        'type':type,
      });
      result=true;
    }catch(e){
      result=false;
    }
    return result;
  }


  Future<bool> deleteCategory({required String id})async{
    bool result=false;
    try{
      await storage.collection('Categories').doc(id).delete();
      result=true;
    }catch(e){
      result=false;
    }
    return result;
  }

  Future<List<CategoryModel>> getCategories({required String type}) async {
    try {
      QuerySnapshot snapshot = await storage
          .collection('Categories')
          .where('type', isEqualTo: type)
          .get();
      List<CategoryModel> categories =
          snapshot.docs.map((doc) => CategoryModel.fromDocument(doc)).toList();
      return categories;
    } catch (e) {
      // Error getting categories from database
      return [];
    }
  }


  Future<CategoryModel?> getCategoriesTransaction(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await storage.collection('Categories').doc(uid).get();
      return CategoryModel.fromDocument(snapshot);
    } catch (e) {
      // Error getting category transaction from database
      return null;
    }
  }


  Future<List<TransactionModel>> getCategoryTransactions(DateTime month, String categoryId) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth = DateTime(month.year, month.month + 1, 1).subtract(const Duration(seconds: 1));

    QuerySnapshot querySnapshot = await storage
        .collection('Transactions')
        .where('userId', isEqualTo: uid)
        .where('categoryId', isEqualTo: categoryId)
        .where('ngayGD', isGreaterThanOrEqualTo: startOfMonth)
        .where('ngayGD', isLessThanOrEqualTo: endOfMonth)
        .get();

    List<TransactionModel> transactions = querySnapshot.docs.map((doc) => TransactionModel.fromDocument(doc)).toList();
    return transactions;
  }

  Future<ReportModel?> getReport(DateTime month) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference reportRef = FirebaseFirestore.instance
        .collection('Reports')
        .doc('$uid-${DateFormat('yyyy-MM').format(month)}');
    try {
      DocumentSnapshot reportSnapshot = await reportRef.get();
      if (!reportSnapshot.exists) {
        return null;
      }
      return ReportModel.fromDocument(reportSnapshot);
    } catch (e) {
      return null;
    }
  }

  int daysInMonth(DateTime date) {
    DateTime firstDayOfNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return firstDayOfNextMonth.subtract(const Duration(days: 1)).day;
  }

  Future<void> saveMonthlyReport(DateTime month) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth =
        DateTime(month.year, month.month + 1, 1).subtract(const Duration(seconds: 1));

    QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .where('userId', isEqualTo: userId)
        .where('loaiGD', isEqualTo: 'Thu Nhập')
        .where('ngayGD', isGreaterThanOrEqualTo: startOfMonth)
        .where('ngayGD', isLessThanOrEqualTo: endOfMonth)
        .get();

    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .where('userId', isEqualTo: userId)
        .where('loaiGD', isEqualTo: 'Chi Tiêu')
        .where('ngayGD', isGreaterThanOrEqualTo: startOfMonth)
        .where('ngayGD', isLessThanOrEqualTo: endOfMonth)
        .get();

    double totalIncome =
        incomeSnapshot.docs.fold(0.0, (double sum, doc) => sum + doc['tienGD']);
    double totalExpense =
        expenseSnapshot.docs.fold(0.0, (double sum, doc) => sum + doc['tienGD']);

    int soNgayTrongThang = daysInMonth(month);
    double totalIcomeDay = totalIncome / soNgayTrongThang;
    double totalExpenseDay = totalExpense / soNgayTrongThang;
    double soDuThang = totalIncome - totalExpense;

    Map<String, Map<String, dynamic>> categoryReport = {};
    for (var doc in incomeSnapshot.docs) {
      String categoryId = doc['categoryId'];
      double amount = doc['tienGD'];
      if (!categoryReport.containsKey(categoryId)) {
        DocumentSnapshot categorySnapshot = await storage
            .collection('Categories')
            .doc(categoryId)
            .get();
        categoryReport[categoryId] = {
          'id': categoryId,
          'name': categorySnapshot['name'],
          'iconCode': categorySnapshot['iconCode'],
          'color': categorySnapshot['colorIcon'],
          'totalAmount': 0.0,
          'type': categorySnapshot['type'],
          'percentage': 0.0,
        };
      }
      categoryReport[categoryId]?['totalAmount'] += amount;
    }

    for (var doc in expenseSnapshot.docs) {
      String categoryId = doc['categoryId'];
      double amount = doc['tienGD'];
      if (!categoryReport.containsKey(categoryId)) {
        DocumentSnapshot categorySnapshot = await storage
            .collection('Categories')
            .doc(categoryId)
            .get();
        categoryReport[categoryId] = {
          'id': categoryId,
          'name': categorySnapshot['name'],
          'iconCode': categorySnapshot['iconCode'],
          'color': categorySnapshot['colorIcon'],
          'totalAmount': 0.0,
          'type': categorySnapshot['type'],
          'percentage': 0.0,
        };
      }
      categoryReport[categoryId]?['totalAmount'] += amount;
    }
    categoryReport.forEach((id, data) {
      if (data['type'] == 'Chi Tiêu') {
        data['percentage'] = (data['totalAmount'] / totalExpense) * 100;
      } else {
        data['percentage'] = (data['totalAmount'] / totalIncome) * 100;
      }
    });

    DocumentReference reportRef = FirebaseFirestore.instance
        .collection('Reports')
        .doc('$userId-${DateFormat('yyyy-MM').format(month)}');

    await reportRef.set({
      'userId': userId,
      'month': startOfMonth,
      'thuNhapThang': totalIncome,
      'chiTieuThang': totalExpense,
      'thuNhapNgay': totalIcomeDay,
      'chiTieuNgay': totalExpenseDay,
      'soDuThang': soDuThang,
      'categories':categoryReport
    });
  }

}
