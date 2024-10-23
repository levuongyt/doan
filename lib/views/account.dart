import 'package:doan_ql_thu_chi/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ACCOUNT'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextButton(onPressed:  (){
              Get.offAll(const SignIn());
            }, child: const Text('Đăng xuất'))
          ],
        ),
      )),
    );
  }
}
