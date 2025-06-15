import 'package:doan_ql_thu_chi/controllers/account_controller.dart';
import 'package:doan_ql_thu_chi/controllers/home_controller.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../controllers/transaction_controller.dart';
import '../login/sign_in.dart';

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
  void initState() {
    super.initState();
    ever(accountController.isLoading, (callback) {
      if (callback) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }
  
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
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar Section
                  Stack(
                    children: [
                      Obx(() => Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).indicatorColor.withOpacity(0.3),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            accountController.selectedAvatar.value,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: Icon(
                                  Icons.person,
                                  size: 50,
                                  color: Colors.grey[600],
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => _showAvatarPicker(context),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                    color: Theme.of(context).indicatorColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Name Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Obx(() => Text(
                        accountController.userModel.value?.name ?? '',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      )),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showEditNameDialog(),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Obx(() => Text(
                      accountController.userModel.value?.email ?? '',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildEmail(),
            const SizedBox(height: 8),
            buildResetPass(context),
            const SizedBox(height: 8),
            buildLogout(),
          ],
        ),
      )),
    );
  }

  void _showAvatarPicker(BuildContext context) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chọn ảnh đại diện'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAvatarOption(
                    'assets/images/avatarboy.png',
                    'Nam'.tr,
                    Icons.face,
                  ),
                  _buildAvatarOption(
                    'assets/images/avatargirl.png',
                    'Nữ'.tr,
                    Icons.face_3,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Hủy'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarOption(String avatarPath, String label, IconData icon) {
    return Obx(() => GestureDetector(
      onTap: () {
        accountController.changeAvatar(avatarPath);
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: accountController.selectedAvatar.value == avatarPath
                ? Colors.blueAccent
                : Colors.grey.withOpacity(0.3),
            width: accountController.selectedAvatar.value == avatarPath ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: accountController.selectedAvatar.value == avatarPath
              ? Colors.blue.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  avatarPath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(
                        icon,
                        size: 40,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: accountController.selectedAvatar.value == avatarPath
                    ? Colors.blueAccent
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    ));
  }

  void _showEditNameDialog() {
    usernameController.text = accountController.userModel.value?.name ?? '';
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Chỉnh sửa tên'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                            key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: TextFormField(
                              controller: usernameController,
                              keyboardType: TextInputType.name,
                              validator: accountController.checkUserName,
                              decoration: InputDecoration(
                    labelText: 'Tên tài khoản'.tr,
                    hintText: 'Nhập tên mới...'.tr,
                    prefixIcon: const Icon(Icons.person),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
                    ),
                              ),
                              onChanged: (value) {
                                formKey.currentState!.validate();
                              },
                            ),
                          ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Hủy'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                                ),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    Get.back();
                        await accountController.updateNameUser(usernameController.text);
                      }
                    },
                    child: Text(
                      'Lưu'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.logout,
            color: Colors.red,
            size: 24,
          ),
        ),
        title: Text(
          'Đăng xuất'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.red,
          ),
        ),
        subtitle: Text(
          'Thoát khỏi tài khoản hiện tại'.tr,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.red,
          ),
        ),
      onTap: () {
          Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đăng xuất'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Bạn có chắc chắn muốn đăng xuất không?'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Hủy'.tr,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                ),
                onPressed: () {
                  Get.delete<HomeController>();
                  Get.delete<TransactionController>();
                  Get.delete<ReportController>();
                  Get.offAll(() => const SignIn());
                },
                          child: Text(
                            'Đăng xuất'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildResetPass(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.lock_reset,
            color: Colors.orange,
            size: 24,
          ),
        ),
        title: Text(
          'Đặt lại mật khẩu'.tr,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Gửi email đặt lại mật khẩu'.tr,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
        ),
      onTap: () {
        emailResetController.text =
            accountController.userModel.value?.email ?? "";
        Get.dialog(
            Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 48,
                      color: Colors.orange,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đặt lại mật khẩu'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Nhập email để nhận liên kết đặt lại mật khẩu'.tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
              controller: emailResetController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                        labelText: 'Email'.tr,
                        hintText: 'Nhập email của bạn...'.tr,
                        prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.orange, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Hủy'.tr,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                  ),
                  onPressed: () async {
                    Get.back();
                            await accountController.resetPass(emailResetController.text);
                          },
                          child: Text(
                            'Gửi'.tr,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ),
        );
      },
      ),
    );
  }

  Widget buildEmail() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.email_outlined,
              color: Colors.blueAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  accountController.userModel.value?.email ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
