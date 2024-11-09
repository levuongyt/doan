import 'package:doan_ql_thu_chi/views/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../config/images/image_app.dart';
import '../controllers/sign_up_controller.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final SignUpController signUpController = Get.put(SignUpController());
  final formKeySignUp = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ever(signUpController.isLoading, (callback) {
      print('loading state: ${signUpController.isLoading}');
      if (callback) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;

    // ever(signUpController.isLoading, (callback) {
    //   print("Loading state: ${signUpController.isLoading}");
    //
    //   if (callback) {
    //     context.loaderOverlay.show();
    //   } else {
    //     context.loaderOverlay.hide();
    //   }
    // });
    return Form(
      key: formKeySignUp,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'ĐĂNG KÝ'.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: IconThemeData(color: Colors.white),
        ),
       // backgroundColor: Colors.white,
        body: Obx(
              () => SingleChildScrollView(
            child: Container(
              // height: double.infinity,
             // color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Image.asset(
                    ImageApp.imageWelcome,
                    width: doubleWidth * (316 / 360),
                    height: doubleHeight * (215 / 800),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: signUpController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: signUpController.ktEmail,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Email",
                        hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: signUpController.usernameController,
                    validator: signUpController.ktUserName,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Tên tài khoản".tr,
                        hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: signUpController.passwordController,
                    obscureText: !signUpController.isVisibility.value,
                    validator: signUpController.ktPassWord,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                            onPressed: () {
                              signUpController.xuLiVisibility();

                              ///c2
                              // signUpController.isVisibility.toggle();
                            },
                            icon: signUpController.isVisibility.value
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        hintText: "Mật khẩu".tr,
                        hintStyle: TextStyle(color: Theme.of(context).hintColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: doubleHeight * (50 / 800),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (formKeySignUp.currentState!
                              .validate()) {
                            await signUpController.signUp(
                                signUpController.emailController.text,
                                signUpController.usernameController.text,
                                signUpController.passwordController.text,
                                0.0);
                            // Get.to(const Home());
                            //  } else {
                            //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //        backgroundColor: Colors.red,
                            //        content: Container(
                            //          child: const Row(
                            //            children: [
                            //              Icon(
                            //                Icons.clear,
                            //                color: Colors.white,
                            //              ),
                            //              SizedBox(
                            //                width: 10,
                            //              ),
                            //              Text('Login failed')
                            //            ],
                            //          ),
                            //        )));
                            //  }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child:  Center(
                            child: Text(
                              'ĐĂNG KÝ'.tr,
                              style: Theme.of(context).textTheme.displayLarge,
                            ))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Bạn đã có tài khoản?'.tr,
                        style: TextStyle(fontSize: 15),
                      ),
                      TextButton(
                          onPressed: () {
                            Get.off(const SignIn());
                          },
                          child: Text(
                            'Đăng nhập ngay'.tr,
                            style: TextStyle(fontSize: 15),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
