import 'package:doan_ql_thu_chi/controllers/account_controller.dart';
import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transaction_controller.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final AccountController accountController = Get.put(AccountController());
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailResetController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ACCOUNT'.tr,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 80,
                    color: Theme.of(context).indicatorColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() =>
                      Text(accountController.userModel.value?.name ?? '',
                      style: Theme.of(context).textTheme.titleLarge,)),
                  IconButton(
                      onPressed: () async {
                        usernameController.text =
                            accountController.userModel.value?.name ?? '';
                        Get.dialog(AlertDialog(
                          title:  Text('Mời nhập tên tài khoản mới'.tr),
                          content: Form(
                            key: formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.name,
                              validator: accountController.checkUserName,
                              decoration: const InputDecoration(),
                              onChanged: (value) {
                                formKey.currentState!.validate();
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child:  Text('Hủy'.tr)),
                            TextButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    Get.back();
                                    await accountController.updateNameUser(
                                        usernameController.text);
                                  }
                                },
                                child:  Text('Lưu'.tr))
                          ],
                        ));
                      },
                      icon: const Icon(Icons.edit)),
                ],
              ),
            ),
            buildEmail(),
            buildResetPass(context),
            buildLogout(),
          ],
        ),
      )),
    );
  }

  ListTile buildLogout() {
    return ListTile(
            leading: const Icon(Icons.logout,
            color: Colors.blueAccent,),
            title: Text('Đăng xuất'.tr),
            onTap: (){
              Get.dialog(AlertDialog(
                title:  Text('Bạn có chắc chắn muốn đăng xuất không?'.tr),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child:  Text('Hủy'.tr)),
                  TextButton(
                      onPressed: () {
                        Get.delete<HomeController>();
                        Get.delete<TransactionController>();
                        Get.delete<ReportController>();
                        Get.offAll(() => const SignIn());
                      },
                      child:  Text('Xác nhận'.tr)),
                ],
              ));
            },
          );
  }

  ListTile buildResetPass(BuildContext context) {
    return ListTile(
            leading: const Icon(
              Icons.lock_reset,
              color: Colors.blueAccent,
            ),
            trailing: const Icon(Icons.navigate_next),
            title:  Text('Đặt lại mật khẩu'.tr),
            onTap: () {
              emailResetController.text= accountController.userModel.value?.email ?? "";
              Get.dialog(
                AlertDialog(
                  title: Text('Vui lòng nhập email để đặt lại mật khẩu'.tr),
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
                          await accountController
                              .resetPass(emailResetController.text);
                        },
                        child: Text('Gửi'.tr)),
                  ],
                ),
              );
            },
          );
  }

  ListTile buildEmail() {
    return ListTile(
            leading: const Icon(Icons.email_outlined,
            color: Colors.blueAccent,),
            title: Row(
              children: [
                const Text('Email : '),
                Obx(() => Text(accountController.userModel.value?.email ?? ""))
              ],),
          );
  }
}
