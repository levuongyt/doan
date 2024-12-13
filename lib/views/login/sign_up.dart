import 'package:doan_ql_thu_chi/views/login/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../config/images/image_app.dart';
import '../../controllers/sign_up_controller.dart';

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
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  buildWelcomeImage(doubleWidth, doubleHeight),
                  const SizedBox(height: 15),
                  buildEmailField(context),
                  const SizedBox(height: 10),
                  buildUsernameField(context),
                  const SizedBox(height: 10),
                  buildPasswordField(context),
                  const SizedBox(height: 10),
                  buildSignUpButton(doubleHeight, context),
                  const SizedBox(height: 15),
                  buildRowToSignIn()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Image buildWelcomeImage(double doubleWidth, double doubleHeight) {
    return Image.asset(
      ImageApp.imageWelcome,
      width: doubleWidth * (316 / 360),
      height: doubleHeight * (215 / 800),
    );
  }

  TextFormField buildEmailField(BuildContext context) {
    return TextFormField(
      controller: signUpController.emailController,
      keyboardType: TextInputType.emailAddress,
      focusNode: signUpController.emailFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: signUpController.ktEmail,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          hintText: "Email",
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }

  TextFormField buildUsernameField(BuildContext context) {
    return TextFormField(
      controller: signUpController.usernameController,
      validator: signUpController.ktUserName,
      focusNode: signUpController.usernameFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.person),
          hintText: "Tên tài khoản".tr,
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }

  Obx buildPasswordField(BuildContext context) {
    return Obx(
          () => TextFormField(
        controller: signUpController.passwordController,
        obscureText: !signUpController.isVisibility.value,
        validator: signUpController.ktPassWord,
        focusNode: signUpController.passwordFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
    );
  }

  SizedBox buildSignUpButton(double doubleHeight, BuildContext context) {
    return SizedBox(
      height: doubleHeight * (50 / 800),
      child: ElevatedButton(
          onPressed: () async {
            if (formKeySignUp.currentState!.validate()) {
              await signUpController.signUp(
                  signUpController.emailController.text,
                  signUpController.usernameController.text,
                  signUpController.passwordController.text,
                  0.0);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).indicatorColor,
          ),
          child: Center(
              child: Text(
                'ĐĂNG KÝ'.tr,
                style: Theme.of(context).textTheme.displayLarge,
              ))),
    );
  }

  Row buildRowToSignIn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Bạn đã có tài khoản?'.tr,
          style: const TextStyle(fontSize: 15),
        ),
        TextButton(
            onPressed: () {
              Get.off(const SignIn());
            },
            child: Text(
              'Đăng nhập ngay'.tr,
              style: const TextStyle(fontSize: 15),
            )),
      ],
    );
  }
}
