import 'package:doan_ql_thu_chi/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../config/images/image_app.dart';
import '../controllers/sign_in_controller.dart';
import 'forgot_password.dart';
class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final SignInController signInController = Get.put(SignInController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ever(signInController.isLoading, (callback) {
     // print('loading state: ${signInController.isLoading}');
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

    // ever(signInController.isLoading, (callback) {
    //   print('loading state: ${signInController.isLoading}');
    //   if (callback) {
    //     context.loaderOverlay.show();
    //   } else {
    //     context.loaderOverlay.hide();
    //   }
    // });
    return Form(
      key: signInController.formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            'LOGIN',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    ImageApp.imageWelcome,
                    width: doubleWidth * (316 / 360),
                    height: doubleHeight * (215 / 800),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: signInController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: signInController.ktEmail,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Email",
                        hintStyle: const TextStyle(color: Colors.grey),
                        // focusedBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(20)),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(20),
                        // )
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(
                        () => TextFormField(
                      controller: signInController.passwordController,
                      obscureText: !signInController.isVisibility.value,
                      validator: signInController.ktPassWord,
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                              onPressed: () {
                                signInController.xuLiVisibility();

                                ///c2
                                //  signInController.isVisibility.toggle();
                              },
                              icon: signInController.isVisibility.value
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off)),
                          hintText: " Password",
                          hintStyle: const TextStyle(color: Colors.grey),
                          // focusedBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(20)),
                          // enabledBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(20))
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                    ),
                  ),

                  Obx(
                        () => Row(
                      children: [
                        Checkbox(
                            value: signInController.isCheckBok.value,
                            onChanged: (value) {
                              signInController.stateCheckBok();
                            }),
                        const Text('Nhớ mật khẩu')
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: doubleHeight * (50 / 800),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (signInController.formKey.currentState!
                              .validate()) {
                            await signInController.signIn(
                                signInController.emailController.text,
                                signInController.passwordController.text);
                           // await signInController.saveLoginData();
                            // Get.to(const Home());
                            //  } else {
                            //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            //         backgroundColor: Colors.red,
                            //         content: Container(
                            //           child: const Row(
                            //             children: [
                            //               Icon(
                            //                 Icons.clear,
                            //                 color: Colors.white,
                            //               ),
                            //               SizedBox(
                            //                 width: 10,
                            //               ),
                            //               Text('Login failed')
                            //             ],
                            //           ),
                            //         )));
                            //   }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Center(
                            child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.to(const ForgotPassword());
                          },
                          child: const Text(
                            'Quên mật khẩu',
                            style: TextStyle(fontSize: 15),
                          )),
                      TextButton(
                          onPressed: () {
                            Get.to(const SignUp());
                          },
                          child: const Text(
                            'Đăng ký',
                            style: TextStyle(fontSize: 15),
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: doubleHeight * (2 / 800),
                        width: doubleWidth * (100 / 360),
                        color: Colors.black12,
                      ),
                      const Text(
                        'Hoặc đăng nhập bằng',
                        style: TextStyle(fontSize: 15),
                      ),
                      Container(
                        height: doubleHeight * (2 / 800),
                        width: doubleWidth * (100 / 360),
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12)),
                          child: IconButton(
                              onPressed: () async{
                                await signInController.signInWithAccountFacebook();
                              },
                              icon: const Icon(
                                Icons.facebook,
                                size: 79,
                                color: Colors.blueAccent,
                              ))),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          onTap: () async{
                            // final FireBaseUtil qlFireBase = FireBaseUtil();
                            // qlFireBase.signInWithGoogle();
                            await signInController.signInWithEmailGoogle();
                          },
                          child: Image.asset(
                            ImageApp.imageGoogle,
                            height: 79,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
