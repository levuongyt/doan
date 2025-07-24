import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget_common/custom_app_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../category/add_category.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final SettingController settingController = Get.find();

  @override
  void initState() {
    super.initState();
    ever(settingController.isLoading, (callback) {
      if (mounted) {
        if (callback) {
          context.loaderOverlay.show();
        } else {
          context.loaderOverlay.hide();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'CÀI ĐẶT'.tr,
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Tùy chỉnh'.tr),
              _buildSettingsGroup([
                buildAddCategory(),
                const SizedBox(height: 8),
                buildChangeLanguage(),
                const SizedBox(height: 8),
                buildChangeCurrency(),
                const SizedBox(height: 8),
                buildLightDarkTheme(),
              ]),
              const SizedBox(height: 24),
              _buildSectionHeader('Thông báo'.tr),
              _buildSettingsGroup([
                buildNotificationSettings(),
                const SizedBox(height: 8),
                buildReminderSettings(),
              ]),
              const SizedBox(height: 24),
             // _buildSectionHeader('Thông tin ứng dụng'.tr),
              //_buildSettingsGroup([
               // _buildAppInfoTile(),
              //]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.tr,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }


  Widget buildAddCategory() {
    return GestureDetector(
      onTap: () => Get.to(const AddCategory()),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.playlist_add,
                color: Colors.purple,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Thêm danh mục'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tạo danh mục thu chi mới'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget buildChangeLanguage() {
    return GestureDetector(
      onTap: _showLanguageDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.language,
                color: Colors.blue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngôn ngữ'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    '${settingController.localizations.firstWhere((lang) => lang['Local'] == settingController.selectedLanguage.value, orElse: () => {'name': 'Tiếng việt'})['name']}'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget buildChangeCurrency() {
    return GestureDetector(
      onTap: _showCurrencyDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.monetization_on_outlined,
                color: Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đơn vị tiền tệ'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    '${settingController.listCurrency.firstWhere((currency) => currency['currency'] == settingController.selectedCurrency.value, orElse: () => {'name': 'Việt Nam Đồng'})['name']}'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget buildLightDarkTheme() {
    return GestureDetector(
      onTap: () async {
        settingController.toggleTheme();
        await settingController.saveThemeToPreferences(settingController.isDarkMode.value);
        Get.changeThemeMode(settingController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.brightness_6,
                color: Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chế độ sáng/tối'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    settingController.isDarkMode.value ? 'Chế độ tối'.tr : 'Chế độ sáng'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  )),
                ],
              ),
            ),
            Obx(() => Switch(
              value: settingController.isDarkMode.value,
              onChanged: (value) async {
                settingController.toggleTheme();
                await settingController.saveThemeToPreferences(settingController.isDarkMode.value);
                Get.changeThemeMode(settingController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
              },
              activeColor: Colors.orange,
            )),
          ],
        ),
      ),
    );
  }

  Widget buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.notifications_outlined,
              color: Colors.blue,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông báo chung'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Nhận thông báo từ ứng dụng'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Obx(() => Switch(
            value: settingController.notificationEnabled.value,
            onChanged: (value) {
              settingController.toggleNotification();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value 
                      ? 'Đã bật thông báo'.tr 
                      : 'Đã tắt thông báo'.tr
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            activeColor: Colors.blue,
          )),
        ],
      ),
    );
  }

  Widget buildReminderSettings() {
    return GestureDetector(
      onTap: () {
        _showReminderDialog();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.alarm,
                color: Colors.green,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nhắc nhở ghi chép'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleMedium?.color ?? Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() => Text(
                    settingController.reminderEnabled.value
                        ? '${'Đã bật lúc'.tr} ${settingController.reminderTime.value.format(context)}'
                        : settingController.notificationEnabled.value 
                            ? 'Nhắc nhở ghi chép thu chi hàng ngày'.tr
                            : 'Cần bật thông báo chung trước'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      color: settingController.notificationEnabled.value 
                          ? Colors.grey[600] 
                          : Colors.red[400],
                    ),
                  )),
                ],
              ),
            ),
            Obx(() => Switch(
              value: settingController.reminderEnabled.value,
              onChanged: settingController.notificationEnabled.value 
                  ? (value) {
                      settingController.toggleReminder();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            value 
                              ? 'Đã bật nhắc nhở ghi chép'.tr 
                              : 'Đã tắt nhắc nhở ghi chép'.tr
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              activeColor: Colors.green,
            )),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    final initialLanguage = settingController.selectedLanguage.value;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.language,
                size: 48,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              Text(
                'Chọn ngôn ngữ'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...settingController.localizations.map((lang) {
                final currentLanguageValue = lang['name'];
                final currentLocalValue = lang['Local'];
                final flag = lang['image'];

                return Obx(() => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: settingController.selectedLanguage.value == currentLocalValue
                          ? Colors.blue
                          : Colors.grey.withValues(alpha: 0.3),
                      width: settingController.selectedLanguage.value == currentLocalValue ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: settingController.selectedLanguage.value == currentLocalValue
                        ? Colors.blue.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  child: ListTile(
                    onTap: () {
                      settingController.selectedLanguage.value = currentLocalValue;
                    },
                    leading: Image.asset(flag, height: 25),
                    title: Text(
                      '$currentLanguageValue'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: settingController.selectedLanguage.value == currentLocalValue
                        ? const Icon(Icons.check_circle, color: Colors.blue)
                        : null,
                  ),
                ));
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      settingController.selectedLanguage.value = initialLanguage;
                    },
                    child: Text(
                      'Hủy'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      Get.back();
                      await settingController.saveLanguage(settingController.selectedLanguage.value);
                      Get.updateLocale(settingController.selectedLanguage.value);
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

  void _showCurrencyDialog() {
    final initialCurrency = settingController.selectedCurrency.value;
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                'Chọn đơn vị tiền tệ'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ...settingController.listCurrency.map((currency) {
                final currentNameValue = currency['name'];
                final currentCurrencyValue = currency['currency'];
                final currentSymbolValue = currency['symbol'];
                final flag = currency['image'];

                return Obx(() => Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: settingController.selectedCurrency.value == currentCurrencyValue
                          ? Colors.green
                          : Colors.grey.withValues(alpha: 0.3),
                      width: settingController.selectedCurrency.value == currentCurrencyValue ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    color: settingController.selectedCurrency.value == currentCurrencyValue
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.transparent,
                  ),
                  child: ListTile(
                    onTap: () {
                      settingController.selectedCurrency.value = currentCurrencyValue;
                    },
                    leading: Image.asset(flag, height: 25),
                    title: Text(
                      '$currentNameValue'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(currentSymbolValue),
                    trailing: settingController.selectedCurrency.value == currentCurrencyValue
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                  ),
                ));
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      settingController.selectedCurrency.value = initialCurrency;
                    },
                    child: Text(
                      'Hủy'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      Get.back();
                      await settingController.saveCurrency(settingController.selectedCurrency.value);
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

  void _showReminderDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.alarm,
                size: 48,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              Text(
                'Cài đặt nhắc nhở'.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              
              // Hiển thị thông báo nếu thông báo chung chưa bật
              Obx(() => !settingController.notificationEnabled.value 
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber, color: Colors.orange[700], size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Cần bật "Thông báo chung" trước khi sử dụng tính năng này'.tr,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bật nhắc nhở:'.tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: settingController.notificationEnabled.value 
                          ? Colors.black87 
                          : Colors.grey,
                    ),
                  ),
                  Obx(() => Switch(
                    value: settingController.reminderEnabled.value,
                    onChanged: settingController.notificationEnabled.value 
                        ? (value) {
                            settingController.toggleReminder();
                          }
                        : null,
                    activeColor: Colors.green,
                  )),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thời gian:'.tr,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Obx(() => TextButton(
                    onPressed: () async {
                      final TimeOfDay? selectedTime = await showTimePicker(
                        context: context,
                        initialTime: settingController.reminderTime.value,
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: true,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (selectedTime != null) {
                        await settingController.saveReminderTime(selectedTime);
                      }
                    },
                    child: Text(
                      settingController.reminderTime.value.format(context),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      'Đóng'.tr,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      Get.back();
                      
                      // Kiểm tra thông báo chung có bật không
                      if (!settingController.notificationEnabled.value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                              content: Text(
                                'Cần bật "Thông báo chung" trước khi sử dụng tính năng này'.tr,
                              ),
                            backgroundColor: Colors.orange,
                            duration: const Duration(seconds: 3),
                            action: SnackBarAction(
                                label: 'Bật ngay'.tr,
                                textColor: Colors.white,
                              onPressed: () {
                                settingController.toggleNotification();
                              },
                            ),
                          ),
                        );
                        return;
                      }
                      
                      // Nếu thông báo chung đã bật, hiển thị thông báo bình thường
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            settingController.reminderEnabled.value
                              ? 'Nhắc nhở đã được bật lúc ${settingController.reminderTime.value.format(context)}'
                              : 'Nhắc nhở đã được tắt',
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    },
                    child: Text(
                      'Xong'.tr,
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
}
