import 'package:doan_ql_thu_chi/Models/category_model.dart';

class DanhMuc{

  final List<CategoryModel> dsDMThuNhapMacDinh=[
    CategoryModel(id: '1',name: 'Lương',iconCode: 984868,colorIcon: 4280391411,type: 'Thu Nhập'),
    CategoryModel(id: '2',name: 'Phụ Cấp',iconCode: 58707,colorIcon: 4294961979,type: 'Thu Nhập'),
    CategoryModel(id: '3',name: 'Thưởng',iconCode: 61229,colorIcon: 4294198070,type: 'Thu Nhập'),
    CategoryModel(id: '4',name: 'Bán hàng',iconCode: 61195,colorIcon: 4289920857,type: 'Thu Nhập'),
    CategoryModel(id: '5',name: 'Học bổng',iconCode: 58713,colorIcon: 4292886779,type: 'Thu Nhập'),
    CategoryModel(id: '6',name: 'Đầu tư',iconCode: 59007,colorIcon: 4284513675,type: 'Thu Nhập'),
  ];

  final List<CategoryModel> dsDMChiTieuMacDinh=[
    CategoryModel(id: '7',name: 'Quần áo',iconCode: 58780,colorIcon: 4293467747,type: 'Chi Tiêu'),
    CategoryModel(id: '8',name: 'Tiền nhà',iconCode: 58136,colorIcon: 4285132974,type: 'Chi Tiêu'),
    CategoryModel(id: '9',name: 'Điện nước',iconCode: 984725,colorIcon: 4280391411,type: 'Chi Tiêu'),
    CategoryModel(id: '10',name: 'Đi lại',iconCode: 61820,colorIcon: 4286141768,type: 'Chi Tiêu'),
    CategoryModel(id: '11',name: 'Y tế',iconCode: 61886,colorIcon: 4288423856,type: 'Chi Tiêu'),
    CategoryModel(id: '12',name: 'Ăn uống',iconCode: 58256,colorIcon: 4294940672,type: 'Chi Tiêu'),
  ];
}