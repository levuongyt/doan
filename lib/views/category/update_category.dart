import 'package:doan_ql_thu_chi/config/category/icon_color_category.dart';
import 'package:doan_ql_thu_chi/controllers/update_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../config/themes/themes_app.dart';

class UpdateCategory extends StatefulWidget {
  final String id;
  final String name;
  final int iconDM;
  final int colorDM;
  final String type;
  const UpdateCategory(
      {super.key,
        required this.id,
        required this.name,
        required this.iconDM,
        required this.colorDM,
        required this.type});

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  final UpdateCategoryController controller =
  Get.put(UpdateCategoryController());
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameDMController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameDMController.text = widget.name.tr;
      controller.selectedIconTNCode.value = widget.iconDM;
      controller.selectedTNColor.value = widget.colorDM;
    });
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
    final doubleHeight = MediaQuery.of(context).size.height;
    final gradientTheme = Theme.of(context).extension<AppGradientTheme>();
    
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: gradientTheme?.primaryGradient ?? LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              ),
          ),
          title: Text(
            widget.name.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.dialog(AlertDialog(
                    backgroundColor: Theme.of(context).cardColor,
                    title: Text(
                      'Bạn có chắc chắn muốn xóa không ?'.tr,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text(
                              'Hủy'.tr,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            )),
                        TextButton(
                            onPressed: () async {
                              await controller.deleteCategory(widget.id);
                              Get.back();
                              Get.until((route) =>
                              route.settings.name == '/Category');
                            },
                            child: Text(
                              'Xác nhận'.tr,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            )),
                      ],
                    ),
                  ));
                },
                icon: const Icon(Icons.delete, color: Colors.white))
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    buildRowNameCategory(),
                    const SizedBox(height: 5),
                    buildTitleSection('Biểu tượng'),
                    buildListIcon(doubleHeight),
                    const SizedBox(height: 5),
                    buildTitleSection('Màu sắc'),
                    buildListColor(doubleHeight),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            )),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: FloatingActionButton.extended(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await controller.updateCategory(
                    widget.id,
                    nameDMController.text,
                    controller.selectedIconTNCode.value,
                    controller.selectedTNColor.value,
                    widget.type,
                  );
                  Get.until((route) => route.settings.name == '/Category');
                }
              },
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              label: Text(
                'Lưu danh mục'.tr,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  Widget buildTitleSection(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
      child: Row(
        children: [
          Text(
            title.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildListColor(double doubleHeight) {
    return SizedBox(
      height: doubleHeight * (250 / 800),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: IconColorCategory.colors.length,
        itemBuilder: (context, index) {
          final color = IconColorCategory.colors[index];
          final isDarkMode = Theme.of(context).brightness == Brightness.dark;
          
          return InkWell(
            onTap: () {
              controller.selectedTNColor.value = color.toARGB32();
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedTNColor.value == color.toARGB32()
                        ? Theme.of(context).primaryColor
                        : (isDarkMode 
                            ? Theme.of(context).dividerColor.withValues(alpha: 0.3)
                            : Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                    width: controller.selectedTNColor.value == color.toARGB32() ? 3 : 1,
                  ),
                  color: color,
                  borderRadius: BorderRadius.circular(12),

                ),
                child: controller.selectedTNColor.value == color.toARGB32()
                    ? Icon(
                        Icons.check,
                        color: _getContrastColor(color),
                        size: 20,
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox buildListIcon(double doubleHeight) {
    return SizedBox(
      height: doubleHeight * (250 / 800),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: IconColorCategory.iconCodes.length,
        itemBuilder: (context, index) {
          final iconCode = IconColorCategory.iconCodes[index];
          
          return InkWell(
            onTap: () {
              controller.selectedIconTNCode.value = iconCode;
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: controller.selectedIconTNCode.value == iconCode
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Theme.of(context).cardColor,
                  border: Border.all(
                    color: controller.selectedIconTNCode.value == iconCode
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor.withValues(alpha: 0.4),
                    width: controller.selectedIconTNCode.value == iconCode
                        ? 2
                        : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),

                ),
                child: Icon(
                  IconData(iconCode, fontFamily: 'MaterialIcons'),
                  color: controller.selectedIconTNCode.value == iconCode
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                  size: 24,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildRowNameCategory() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        ),
      child: Row(
        children: [
          Text(
            'Tên danh mục'.tr,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              validator: controller.checkNameDM,
              controller: nameDMController,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập tên...'.tr,
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surface
                    : Theme.of(context).colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getContrastColor(Color color) {
    double luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}