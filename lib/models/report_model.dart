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
  Map<String, CategoryReportModel>? categories;
  ReportModel({
    this.id,
    this.userId,
    this.month,
    this.totalIncome,
    this.totalExpense,
    this.totalIncomeDay,
    this.totalExpenseDay,
    this.soDuThang,
    this.categories
  });

  factory ReportModel.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> categoriesMap = doc['categories'];
    Map<String, CategoryReportModel> categories = {};
    categoriesMap.forEach((key, value) {
      categories[key] = CategoryReportModel.fromMap(value);
    });
    return ReportModel(
      id: doc.id,
      userId: doc.get('userId'),
      month: (doc.get('month') as Timestamp).toDate(),
      totalIncome: doc.get('thuNhapThang'),
      totalExpense: doc.get('chiTieuThang'),
      totalIncomeDay: doc.get('thuNhapNgay'),
      totalExpenseDay: doc.get('chiTieuNgay'),
      soDuThang: doc.get('soDuThang'),
      categories: categories,
    );
  }

  Map<String, dynamic> toMap() {
      Map<String, dynamic> categoriesMap = {};
      categories?.forEach((key, value) {
        categoriesMap[key] = value.toMap();
      });
    return {
      'userId': userId,
      'month': month,
      'thuNhapThang': totalIncome,
      'chiTieuThang': totalExpense,
      'thuNhapNgay': totalIncomeDay,
      'chiTieuNgay': totalExpenseDay,
      'soDuThang': soDuThang,
      'categories': categoriesMap
    };
  }
}

class CategoryReportModel {
  String id;
  String name;
  int iconCode;
  int color;
  double totalAmount;
  String type;
  double percentage;

  CategoryReportModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.color,
    required this.totalAmount,
    required this.type,
    required this.percentage,
  });

  factory CategoryReportModel.fromMap(Map<String, dynamic> map) {
    return CategoryReportModel(
      id: map['id'],
      name: map['name'],
      iconCode: map['iconCode'],
      color: map['color'],
      totalAmount: map['totalAmount'],
      type: map['type'],
      percentage: map['percentage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
     'id': id,
      'name': name,
      'iconCode': iconCode,
      'color': color,
      'totalAmount': totalAmount,
      'type': type,
      'percentage': percentage,
    };
  }
}
