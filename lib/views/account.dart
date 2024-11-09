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
 // final AccountController accountController=Get.put(AccountController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ACCOUNT',
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        iconTheme:IconThemeData(
          color: Colors.white
        ),
      ),
      body: SafeArea(child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextButton(onPressed:  (){
              Get.delete<HomeController>();
              Get.delete<TransactionController>();
              Get.delete<ReportController>();
              Get.offAll(()=>SignIn());
            //  accountController.resetController();
             // Get.delete<HomeController>();
            }, child: const Text('Đăng xuất'))
          ],
        ),
      )),
    );
  }
}
