import 'dart:ffi';

import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/views/add_category.dart';
import 'package:doan_ql_thu_chi/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
      // print('loading state: ${signInController.isLoading}');
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                Icons.lock_reset,
                color: Colors.blueAccent,
              ),
              title: Text('Đặt lại mật khẩu'.tr),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title:
                            Text('Vui lòng nhập email để đặt lại mật khẩu'.tr),
                        content: TextFormField(
                          controller: emailResetController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              hintText: 'Nhập email'.tr,
                              hintStyle: TextStyle(
                                color: Theme.of(context).hintColor,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('Hủy'.tr)),
                          TextButton(
                              onPressed: () async {
                                Get.back();
                                await settingController
                                    .resetPass(emailResetController.text);
                              },
                              child: Text('Gửi'.tr)),
                        ],
                      );
                    });
              },
            ),
            ListTile(
              leading: Icon(
                Icons.playlist_add,
                color: Colors.blueAccent,
              ),
              title: Text('Thêm danh mục'.tr),
              onTap: () {
                Get.to(AddCategory());
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.blueAccent),
              title: Text('Thay đổi ngôn ngữ'.tr),
              onTap: () {
                final initialLanguage =
                    settingController.selectedLanguage.value;
                Get.dialog(
                  AlertDialog(
                    title: Text('Chọn ngôn ngữ'.tr),
                    content: Container(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: settingController.localizations.length,
                        itemBuilder: (BuildContext context, int index) {
                          final currentLanguageValue =
                              settingController.localizations[index]['name'];
                          final currentLocalValue =
                              settingController.localizations[index]['Local'];
                          final flag =
                              settingController.localizations[index]['image'];

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
                                    SizedBox(width: 10,),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        '$currentLanguageValue'.tr,
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Obx(() {
                                      return settingController
                                                  .selectedLanguage.value ==
                                              currentLocalValue
                                          ? Icon(Icons.check,
                                              color: Colors.blueAccent)
                                          : SizedBox();
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
                      TextButton(
                          onPressed: () {
                            Get.back();
                            settingController.selectedLanguage.value =
                                initialLanguage;
                          },
                          child: Text('Hủy'.tr)),
                      TextButton(
                          onPressed: () async {
                            Get.back();
                            await settingController.saveLanguage(
                                settingController.selectedLanguage.value);
                            Get.updateLocale(
                                settingController.selectedLanguage.value);
                          },
                          child: Text('Lưu'.tr)),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.monetization_on_outlined,
                  color: Colors.blueAccent),
              title: Text('Thay đổi tiền tệ'.tr),
              onTap: () {
                final initialCurrency =
                    settingController.selectedCurrency.value;
                Get.dialog(
                  AlertDialog(
                    title: Text('Chọn đơn vị tiền tệ'.tr),
                    content: Container(
                      width: double.maxFinite,
                      child: Obx(() {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: Text(
                                'đ',
                                style: TextStyle(fontSize: 17),
                              ),
                              title: Text('Việt Nam Đồng'),
                              trailing:
                                  settingController.selectedCurrency.value ==
                                          'VND'
                                      ? Icon(Icons.check, color: Colors.blue)
                                      : null,
                              onTap: () {
                                settingController.selectedCurrency.value =
                                    'VND';
                              },
                            ),
                            const Divider(),
                            ListTile(
                              leading: Text(
                                '\$',
                                style: TextStyle(fontSize: 17),
                              ),
                              //Icon(Icons.attach_money),
                              title: Text('US Dollar'),
                              trailing:
                                  settingController.selectedCurrency.value ==
                                          'USD'
                                      ? Icon(Icons.check, color: Colors.blue)
                                      : null,
                              onTap: () {
                                settingController.selectedCurrency.value =
                                    'USD';
                              },
                            ),
                            Divider(),
                            ListTile(
                              leading: Text(
                                '€',
                                style: TextStyle(fontSize: 17),
                              ),
                              //Icon(Icons.attach_money),
                              title: Text('EURO'),
                              trailing:
                              settingController.selectedCurrency.value ==
                                  'EUR'
                                  ? Icon(Icons.check, color: Colors.blue)
                                  : null,
                              onTap: () {
                                settingController.selectedCurrency.value =
                                'EUR';
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(15),
                    // ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Get.back();
                          settingController.selectedCurrency.value =
                              initialCurrency;
                        },
                        child: Text('Hủy'.tr),
                      ),
                      TextButton(
                        onPressed: () async {
                          Get.back();
                          await settingController.saveCurrency(
                              settingController.selectedCurrency.value);
                        },
                        child: Text('Lưu'.tr),
                      ),
                    ],
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.brightness_6, color: Colors.blueAccent),
              title: Text('Đổi chế độ sáng/tối'.tr),
              trailing: Obx(
                () => Switch(
                    value: settingController.isDarkMode.value,
                    onChanged: (value) async {
                      settingController.toggleTheme();
                      await settingController.saveThemeToPreferences(
                          settingController.isDarkMode.value);
                      Get.changeThemeMode(settingController.isDarkMode.value
                          ? ThemeMode.dark
                          : ThemeMode.light);
                      print('stae: ${settingController.isDarkMode.value}');
                    }),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.blueAccent,
              ),
              title: Text('Đăng xuất'.tr),
              onTap: () {
                // Get.delete<HomeController>();
                // Get.delete<TransactionController>();
                // Get.delete<ReportController>();
                Get.offAll(() => SignIn());
              },
            )
          ],
        ),
      )),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Tổng quan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.edit_note),
      //       label: 'Nhập vào',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bar_chart),
      //       label: 'Báo cáo',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Cài đặt',
      //     ),
      //   ],
      //   //currentIndex: _selectedIndex,
      //   //onTap: _onItemTapped,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.grey,
      // ),
    );
  }
}
