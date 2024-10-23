import 'package:doan_ql_thu_chi/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/firebase/storage/firebase_storage.dart';


class CetegoryController extends GetxController {
  final TransactionController transactionController = Get.find();
  FirebaseStorageUtil firebaseStorageUtil = FirebaseStorageUtil();
  RxBool isLoading = false.obs;
  RxInt selectedIconTNCode = Icons.home.codePoint.obs;
  RxInt selectedIconCTCode = Icons.home.codePoint.obs;
  RxInt selectedTNColor = Colors.red.value.obs;
  RxInt selectedCTColor = Colors.red.value.obs;

  RxList<int> iconCodes = <int>[
    Icons.home.codePoint,
    Icons.work.codePoint,
    Icons.school.codePoint,
    Icons.shopping_cart.codePoint,
    Icons.wallet_outlined.codePoint,
    Icons.sports.codePoint,
    Icons.card_giftcard_outlined.codePoint,
    Icons.local_gas_station_outlined.codePoint,
    Icons.water_drop_outlined.codePoint,
    Icons.local_dining.codePoint,
    Icons.savings.codePoint,
    Icons.trending_up.codePoint,
    Icons.business_outlined.codePoint,
    Icons.restaurant.codePoint,
    Icons.movie.codePoint,
    Icons.phone.codePoint,
    Icons.medical_services_outlined.codePoint,
    Icons.flight.codePoint,
    Icons.local_hospital.codePoint,
    Icons.directions_car.codePoint,
    Icons.receipt.codePoint,
    Icons.policy.codePoint,
    Icons.checkroom.codePoint,
    Icons.account_balance.codePoint,
  ].obs;

  RxList<Color> colors = <Color>[
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.black,
    Colors.brown,
    Colors.blueGrey,
    Colors.pink,
    Colors.grey,
    Colors.greenAccent,
    Colors.deepPurple,
    Colors.tealAccent,
    Colors.lightGreenAccent,
    Colors.purpleAccent,
    Colors.cyan,
    Colors.black26,
    Colors.lime
  ].obs;

  Future<void> addCategory(
      String nameDM, int iconCode, int colorIcon, String type) async {
    isLoading.value = true;
    try {
      await firebaseStorageUtil.addCategory(
          name: nameDM, iconCode: iconCode, colorIcon: colorIcon, type: type);
      Get.snackbar('Success', 'Thêm thành công');
      await transactionController.layDanhMucThuNhap();
      await transactionController.layDanhMucChiTieu();
    } catch (e) {
      Get.snackbar('Error', 'Lỗi');
    }
    isLoading.value = false;
  }
}
