import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String id;
  String userId;
  double amount;
  String description;
  String categoryId;
  String type;
  DateTime date;
  double finalBalance;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.type,
    required this.date,
    required this.finalBalance,
  });

  factory TransactionModel.fromDocument(DocumentSnapshot doc) {
    return TransactionModel(
        id: doc.id,
        userId: doc.get('userId'),
        amount: doc.get('tienGD'),
        description: doc.get('noiDungGD'),
        categoryId: doc.get('categoryId'),
        type: doc.get('loaiGD'),
        date: (doc.get('ngayGD') as Timestamp).toDate(),
        finalBalance: doc.get('soDuCuoi')
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'tienGD': amount,
      'noiDungGD': description,
      'categoryId': categoryId,
      'loaiGD': type,
      'ngayGD': Timestamp.fromDate(date),
      'soDuCuoi': finalBalance,
    };
  }
}
