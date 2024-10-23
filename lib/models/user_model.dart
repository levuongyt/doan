
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String email;
  String? name;
  Timestamp ngayTao;
  double tongSoDu;

  UserModel({
    this.id,
    required this.email,
    this.name,
    required this.ngayTao,
    required this.tongSoDu,
  });

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    return UserModel(
      id: doc.id,
      email: doc['Email'],
      name: doc['Name'],
      ngayTao: doc['ngayTao'],
      tongSoDu: doc['tongSoDu'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Email': email,
      'Name': name,
      'ngayTao': ngayTao,
      'tongSoDu': tongSoDu,
    };
  }
}
