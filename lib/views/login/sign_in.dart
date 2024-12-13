import 'package:doan_ql_thu_chi/views/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../config/images/image_app.dart';
import '../../controllers/sign_in_controller.dart';
import '../forgot_password/forgot_password.dart';

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
      key: signInController.formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'ĐĂNG NHẬP'.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildWelcomeImage(doubleWidth, doubleHeight),
                  const SizedBox(height: 15),
                  buildEmailField(context),
                  const SizedBox(height: 10),
                  buildPasswordField(context),
                  buildRememberCheckbox(),
                  const SizedBox(height: 5),
                  buildSignInButton(doubleHeight, context),
                  const SizedBox(height: 10),
                  buildFGPassAndSignUp(),
                  buildRowDivider(doubleHeight, doubleWidth),
                  const SizedBox(height: 10),
                  buildGGLogin(),
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
      controller: signInController.emailController,
      keyboardType: TextInputType.emailAddress,
      validator: signInController.ktEmail,
      focusNode: signInController.emailFocusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          hintText: "Email",
          hintStyle: TextStyle(color: Theme.of(context).hintColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )),
    );
  }

  Obx buildPasswordField(BuildContext context) {
    return Obx(
          () => TextFormField(
        controller: signInController.passwordController,
        obscureText: !signInController.isVisibility.value,
        focusNode: signInController.passwordFocusNode,
        validator: signInController.ktPassWord,
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
            hintText: " Password".tr,
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }

  Obx buildRememberCheckbox() {
    return Obx(
          () => Row(
        children: [
          Checkbox(
              value: signInController.isCheckBok.value,
              onChanged: (value) {
                signInController.stateCheckBok();
              }),
          Text('Nhớ mật khẩu'.tr)
        ],
      ),
    );
  }

  SizedBox buildSignInButton(double doubleHeight, BuildContext context) {
    return SizedBox(
      height: doubleHeight * (50 / 800),
      child: ElevatedButton(
          onPressed: () async {
            if (signInController.formKey.currentState!.validate()) {
              await signInController.signIn(
                  signInController.emailController.text,
                  signInController.passwordController.text);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).indicatorColor,
          ),
          child: Center(
              child: Text(
                'LOGIN'.tr,
                style: Theme.of(context).textTheme.displayLarge,
              ))),
    );
  }

  Row buildFGPassAndSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              Get.to(const ForgotPassword());
            },
            child: Text(
              'Quên mật khẩu'.tr,
              style: const TextStyle(fontSize: 15),
            )),
        TextButton(
            onPressed: () {
              Get.off(const SignUp());
            },
            child: Text(
              'Đăng ký'.tr,
              style: const TextStyle(fontSize: 15),
            )),
      ],
    );
  }

  Row buildRowDivider(double doubleHeight, double doubleWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: doubleHeight * (2 / 800),
          width: doubleWidth * (100 / 360),
          color: Colors.black12,
        ),
        Text(
          'Hoặc đăng nhập bằng'.tr,
          style: const TextStyle(fontSize: 15),
        ),
        Container(
          height: doubleHeight * (2 / 800),
          width: doubleWidth * (100 / 360),
          color: Colors.black12,
        ),
      ],
    );
  }

  Row buildGGLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () async {
              await signInController.signInWithEmailGoogle();
            },
            child: Image.asset(
              ImageApp.imageGoogle,
              height: 79,
            ),
          ),
        ),
      ],
    );
  }
}
