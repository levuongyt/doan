import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:get/get.dart';

class AccountController extends GetxController{

  void resetController(){
    Get.delete<HomeController>();
  }
}