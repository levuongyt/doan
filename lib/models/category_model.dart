import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String? id;
  String name;
  int iconCode;
  int colorIcon;
  String type;
  //String? userId;
  CategoryModel({
    this.id,
    required this.name,
    required this.iconCode,
    required this.colorIcon,
    required this.type,
   // this.userId,
  });

  factory CategoryModel.fromDocument(DocumentSnapshot doc) {

    return CategoryModel(
      id: doc.id,
      name: doc.get('name'),
      iconCode: doc.get('iconCode'),
      colorIcon: doc.get('colorIcon'),
      type: doc.get('type'),
     // userId: doc.get('userId'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'iconCode': iconCode,
      'colorIcon': colorIcon,
      'type': type,
     // 'userId': userId,
    };
  }
}
