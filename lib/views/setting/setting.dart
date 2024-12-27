import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../category/add_category.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final SettingController settingController = Get.find();
  final TextEditingController emailResetController = TextEditingController();
  final TextEditingController totalBalanceController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ever(settingController.isLoading, (callback) {
      if (mounted) {
        if (callback) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'CÀI ĐẶT'.tr,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            buildAddCategory(),
            buildChangeLanguage(),
            buildLightDarkTheme(),
            buildChangeCurrency(),
          ],
        ),
      )),
    );
  }

  ListTile buildChangeCurrency() {
    return ListTile(
      leading:
          const Icon(Icons.monetization_on_outlined, color: Colors.blueAccent),
      title: Text('Thay đổi tiền tệ'.tr),
      onTap: () {
        final initialCurrency = settingController.selectedCurrency.value;
        Get.dialog(
          AlertDialog(
            title: Center(child: Text('Chọn đơn vị tiền tệ'.tr)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: settingController.listCurrency.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentNameValue =
                      settingController.listCurrency[index]['name'];
                  final currentCurrencyValue =
                      settingController.listCurrency[index]['currency'];
                  final currentSymbolValue =
                      settingController.listCurrency[index]['symbol'];
                  final flag = settingController.listCurrency[index]['image'];

                  return InkWell(
                    onTap: () {
                      settingController.selectedCurrency.value =
                          currentCurrencyValue;
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              flag,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '$currentNameValue'.tr,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Text(currentSymbolValue)),
                            SizedBox(
                              width: 20,
                              child: Obx(() {
                                return settingController
                                            .selectedCurrency.value ==
                                        currentCurrencyValue
                                    ? const Icon(Icons.check,
                                        color: Colors.blueAccent)
                                    : const SizedBox(
                                        //width: 20,
                                        );
                              }),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  onPressed: () {
                    Get.back();
                    settingController.selectedCurrency.value = initialCurrency;
                  },
                  child: Text(
                    'Hủy'.tr,
                    style: const TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  onPressed: () async {
                    Get.back();
                    await settingController
                        .saveCurrency(settingController.selectedCurrency.value);
                  },
                  child: Text(
                    'Lưu'.tr,
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
          ),
        );
      },
    );
  }

  ListTile buildLightDarkTheme() {
    return ListTile(
      leading: const Icon(Icons.brightness_6, color: Colors.blueAccent),
      title: Text('Đổi chế độ sáng/tối'.tr),
      trailing: Obx(
        () => Switch(
            value: settingController.isDarkMode.value,
            onChanged: (value) async {
              settingController.toggleTheme();
              await settingController
                  .saveThemeToPreferences(settingController.isDarkMode.value);
              Get.changeThemeMode(settingController.isDarkMode.value
                  ? ThemeMode.dark
                  : ThemeMode.light);
            }),
      ),
    );
  }

  ListTile buildChangeLanguage() {
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.blueAccent),
      title: Text('Thay đổi ngôn ngữ'.tr),
      onTap: () {
        final initialLanguage = settingController.selectedLanguage.value;
        Get.dialog(
          AlertDialog(
            title: Center(child: Text('Chọn ngôn ngữ'.tr)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: settingController.localizations.length,
                itemBuilder: (BuildContext context, int index) {
                  final currentLanguageValue =
                      settingController.localizations[index]['name'];
                  final currentLocalValue =
                      settingController.localizations[index]['Local'];
                  final flag = settingController.localizations[index]['image'];

                  return InkWell(
                    onTap: () {
                      settingController.selectedLanguage.value =
                          currentLocalValue;
                    },
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Image.asset(
                              flag,
                              height: 25,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '$currentLanguageValue'.tr,
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Obx(() {
                              return settingController.selectedLanguage.value ==
                                      currentLocalValue
                                  ? const Icon(Icons.check,
                                      color: Colors.blueAccent)
                                  : const SizedBox();
                            }),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  onPressed: () {
                    Get.back();
                    settingController.selectedLanguage.value = initialLanguage;
                  },
                  child: Text(
                    'Hủy'.tr,
                    style: const TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  onPressed: () async {
                    Get.back();
                    await settingController
                        .saveLanguage(settingController.selectedLanguage.value);
                    Get.updateLocale(settingController.selectedLanguage.value);
                  },
                  child: Text(
                    'Lưu'.tr,
                    style: const TextStyle(color: Colors.white),
                  )),
            ],
          ),
        );
      },
    );
  }

  ListTile buildAddCategory() {
    return ListTile(
      leading: const Icon(
        Icons.playlist_add,
        color: Colors.blueAccent,
      ),
      title: Text('Thêm danh mục'.tr),
      onTap: () {
        Get.to(const AddCategory());
      },
    );
  }
}
