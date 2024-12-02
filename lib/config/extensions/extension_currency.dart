import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:get/get.dart';

extension ExtensionCurrency on double {
  double toCurrency() {
    final SettingController settingController = Get.find();
    return settingController.convertAmount(this);
  }

  double toVND() {
    final SettingController settingController = Get.find();
    return settingController.amountToVND(this);
  }

}
