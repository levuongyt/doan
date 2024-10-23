import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String? id;
  String? userId;
  DateTime? month;
  double? totalIncome;
  double? totalExpense;
  double? totalIncomeDay;
  double? totalExpenseDay;
  double? soDuThang;

  ReportModel({
    this.id,
    this.userId,
    this.month,
    this.totalIncome,
    this.totalExpense,
    this.totalIncomeDay,
    this.totalExpenseDay,
    this.soDuThang,
  });

  factory ReportModel.fromDocument(DocumentSnapshot doc) {
    return ReportModel(
      id: doc.id,
      userId: doc.get('userId'),
      month: (doc.get('month') as Timestamp).toDate(),
      totalIncome: doc.get('thuNhapThang'),
      totalExpense: doc.get('chiTieuThang'),
      totalIncomeDay: doc.get('thuNhapNgay'),
      totalExpenseDay: doc.get('chiTieuNgay'),
      soDuThang: doc.get('soDuThang'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'month': month,
      'thuNhapThang': totalIncome,
      'chiTieuThang': totalExpense,
      'thuNhapNgay': totalIncomeDay,
      'chiTieuNgay': totalExpenseDay,
      'soDuThang': soDuThang,
    };
  }
}
