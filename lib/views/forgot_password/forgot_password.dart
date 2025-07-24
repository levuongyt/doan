import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../controllers/forgot_pass_controller.dart';
import '../../widget_common/custom_app_bar.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ForgotPassController controller = Get.put(ForgotPassController());
  final TextEditingController emailController = TextEditingController();
  final formKey=GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ever(controller.isLoading, (callback) {
      if (callback) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Scaffold(
                  appBar: CustomAppBar(
            title: 'QUÊN MẬT KHẨU'.tr,
          ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
              Text(
                'Bạn quên mật khẩu?'.tr,
                // 'Forgot Your Password?',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Vui lòng nhập email được liên kết với tài khoản của bạn và chúng tôi sẽ gửi liên kết để đặt lại mật khẩu của bạn.'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color:Theme.of(context).hintColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: controller.ktEmail,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Theme.of(context).hintColor),
                                      hintText: 'Email'.tr,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 18,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).indicatorColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () async {
                    if(formKey.currentState!.validate()){
                      await controller.sendEmaiAndResetPass(emailController.text);
                    }
                  },
                  child: Text(
                    'GỬI LIÊN KẾT ĐẶT LẠI'.tr,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
