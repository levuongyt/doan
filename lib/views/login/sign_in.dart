import 'package:doan_ql_thu_chi/views/login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../config/images/image_app.dart';
import '../../config/themes/themes_app.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenHeight < 600;
    
    return Form(
      key: signInController.formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(
            'ĐĂNG NHẬP'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(context).extension<AppGradientTheme>()?.primaryGradient ?? LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).extension<AppGradientTheme>()?.shadowColor ?? Colors.blue.shade300.withValues(alpha: 0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final availableHeight = constraints.maxHeight;
              
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  constraints: BoxConstraints(minHeight: availableHeight),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: isSmallScreen ? 10 : 15
                  ),
                  child: Column(
                    children: [
                      // Main content wrapper with proper spacing
                      buildMainContent(screenWidth, screenHeight, isSmallScreen, availableHeight),
                      
                      // Social login section at bottom
                      buildSocialLoginSection(context, screenWidth),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  Widget buildMainContent(double width, double height, bool isSmallScreen, double availableHeight) {
    return Container(
      constraints: BoxConstraints(
        minHeight: availableHeight * 0.8, // 80% of available height
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section - about 25% of content height
          buildWelcomeImage(width, isSmallScreen ? height * 0.15 : height * 0.2),
          
          // Form section with proper spacing
          Column(
            children: [
              buildEmailField(context),
              const SizedBox(height: 12),
              buildPasswordField(context),
              buildRememberCheckbox(),
              const SizedBox(height: 8),
              buildSignInButton(height * 0.055, context),
              buildFGPassAndSignUp(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildWelcomeImage(double width, double height) {
    return Container(
      alignment: Alignment.center,
      child: Image.asset(
        ImageApp.imageWelcome,
        width: width * 0.65,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget buildEmailField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      child: TextFormField(
        controller: signInController.emailController,
        keyboardType: TextInputType.emailAddress,
        validator: signInController.ktEmail,
        focusNode: signInController.emailFocusNode,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          prefixIcon: Icon(
            Icons.email,
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
          hintText: "Email".tr,
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
          ),
          fillColor: Theme.of(context).cardColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return Obx(
      () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: TextFormField(
          controller: signInController.passwordController,
          obscureText: !signInController.isVisibility.value,
          focusNode: signInController.passwordFocusNode,
          validator: signInController.ktPassWord,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            prefixIcon: Icon(
              Icons.lock,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                signInController.xuLiVisibility();
              },
              icon: signInController.isVisibility.value
                  ? Icon(
                      Icons.visibility,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    )
                  : Icon(
                      Icons.visibility_off,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                    ),
            ),
            hintText: " Password".tr,
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            ),
            fillColor: Theme.of(context).cardColor,
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRememberCheckbox() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 8.0, top: 4.0),
        child: Row(
          children: [
                          Transform.scale(
              scale: 0.9,
              child: Checkbox(
                  value: signInController.isCheckBok.value,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: (value) {
                    signInController.stateCheckBok();
                  }),
            ),
            Text(
              'Nhớ mật khẩu'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSignInButton(double height, BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 12),
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
            foregroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Center(
              child: Text(
                'ĐĂNG NHẬP'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ))),
    );
  }

  Widget buildFGPassAndSignUp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
            onPressed: () {
              Get.to(const ForgotPassword());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            child: Text(
              'Quên mật khẩu'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            )),
        TextButton(
            onPressed: () {
              Get.off(() => const SignUp());
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            ),
            child: Text(
              'Đăng ký'.tr,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            )),
      ],
    );
  }

  Widget buildSocialLoginSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.grey.shade400],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Hoặc đăng nhập bằng'.tr,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.grey.shade400, Colors.transparent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          buildGoogleSignInButton(),
        ],
      ),
    );
  }

  Widget buildGoogleSignInButton() {
    return InkWell(
      onTap: () async {
        await signInController.signInWithEmailGoogle();
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Image.asset(
          ImageApp.imageGoogle,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
