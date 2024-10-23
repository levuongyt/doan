import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../Models/category_model.dart';
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
      required String Email,
      required String name,
      required DateTime ngayTao,
      required double tongSoDu}) async {
    try {
      await storage.collection('Users').doc(uid).set({
        'Email': Email,
        'Name': name,
        'ngayTao': ngayTao,
        'tongSoDu': tongSoDu,
      });
      print('Thành công');
    } catch (e) {
      print('Lỗi là: $e');
    }
  }

  ///Lấy user
  Future<UserModel?> getUser() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    try {
      final snapshot = await storage.collection('Users').doc(uid).get();
      return UserModel.fromDocument(snapshot);
    } catch (e) {
      print('aaa');
      print('Lỗi lấy User là : $e');
      return null;
    }
  }

  Future<void> addTransaction({
    required double amount,
    required String description,
    required String categoryId,
    required String type,
    required DateTime date,
  }) async {
    try {
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
            soDuMoi, // Chuyển đổi DateTime thành Timestamp cho Firestore
      });

      await storage.collection('Users').doc(uid).update({'tongSoDu': soDuMoi});

      print('Thành công');
    } catch (e) {
      print('Lỗi: $e');
    }
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
      print('Lỗi là: $e');
      return [];
    }
  }

  ///them danh muc
  Future<void> addCategory(
      {required name,
      required iconCode,
      required colorIcon,
      required type}) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      await storage.collection('Categories').doc(const Uuid().v1()).set({
        'name': name,
        'iconCode': iconCode,
        'colorIcon': colorIcon,
        'type': type,
        'userId': uid,
      });
      print('Danh mục đã được thêm thành công');
    } catch (e) {
      print('Lỗi khi thêm danh mục: $e');
    }
  }

  Future<List<CategoryModel>> getCategories({required String type}) async {
    try {
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      QuerySnapshot snapshot = await storage
          .collection('Categories')
          .where('type', isEqualTo: type)
          .where('userId', isEqualTo: uid)
          .get();
      List<CategoryModel> categories =
          snapshot.docs.map((doc) => CategoryModel.fromDocument(doc)).toList();
      return categories;
    } catch (e) {
    //  print('Lỗi khi lấy danh mục: $e');
      return [];
    }
  }

  ///Lấy danh mục theo giao dịch
  Future<CategoryModel?> getCategoriesTransaction(String uid) async {
    try {
      DocumentSnapshot snapshot =
          await storage.collection('Categories').doc(uid).get();
      return CategoryModel.fromDocument(snapshot);
    } catch (e) {
      // print('Lỗi khi lấy danh mục: $e');
      return null;
    }
  }

  ///Báo cáo

  Future<DocumentSnapshot?> getReport(DateTime month) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    DocumentReference reportRef = FirebaseFirestore.instance
        .collection('Reports')
        .doc(
            '${uid}-${DateFormat('yyyy-MM').format(month)}');

    DocumentSnapshot reportSnapshot = await reportRef.get();
    print(' ID la : ${reportRef.id}');
    if (!reportSnapshot.exists) {
      print('khong co du lieu');
      return null;
    }

    return reportSnapshot;
  }

  int daysInMonth(DateTime date) {
    DateTime firstDayOfNextMonth = (date.month < 12)
        ? DateTime(date.year, date.month + 1, 1)
        : DateTime(date.year + 1, 1, 1);
    return firstDayOfNextMonth.subtract(Duration(days: 1)).day;
  }

  Future<void> saveMonthlyReport(DateTime month) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('Lỗi: Người dùng chưa đăng nhập');
      return;
    }
    DateTime startOfMonth = DateTime(month.year, month.month, 1);
    DateTime endOfMonth =
        DateTime(month.year, month.month + 1, 1).subtract(Duration(seconds: 1));

    /// Lấy giao dịch thu nhập
    QuerySnapshot incomeSnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .where('userId', isEqualTo: userId)
        .where('loaiGD', isEqualTo: 'Thu Nhập')
        .where('ngayGD', isGreaterThanOrEqualTo: startOfMonth)
        .where('ngayGD', isLessThanOrEqualTo: endOfMonth)
        .get();

    /// Lấy giao dịch chi tiêu
    QuerySnapshot expenseSnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .where('userId', isEqualTo: userId)
        .where('loaiGD', isEqualTo: 'Chi Tiêu')
        .where('ngayGD', isGreaterThanOrEqualTo: startOfMonth)
        .where('ngayGD', isLessThanOrEqualTo: endOfMonth)
        .get();

    // double totalIncome = 0.0;
    // for (var doc in incomeSnapshot.docs) {
    //   double tienGD = doc['tienGD'];
    //   totalIncome += tienGD;
    // }

    double totalIncome =
        incomeSnapshot.docs.fold(0.0, (sum, doc) => sum + doc['tienGD']);
    double totalExpense =
        expenseSnapshot.docs.fold(0.0, (sum, doc) => sum + doc['tienGD']);

    int soNgayTrongThang = daysInMonth(month);
    double totalIcomeDay = totalIncome / soNgayTrongThang;
    double totalExpenseDay = totalExpense / soNgayTrongThang;
    double soDuThang = totalIncome - totalExpense;

    DocumentReference reportRef = FirebaseFirestore.instance
        .collection('Reports')
        .doc(userId + '-' + DateFormat('yyyy-MM').format(month));

    await reportRef.set({
      'userId': userId,
      'month': startOfMonth,
      'thuNhapThang': totalIncome,
      'chiTieuThang': totalExpense,
      'thuNhapNgay': totalIcomeDay,
      'chiTieuNgay': totalExpenseDay,
      'soDuThang': soDuThang,
    });
    print('Báo cáo tháng lưu thành công');
  }
}
