import 'package:doan_ql_thu_chi/config/category/icon_color_category.dart';
import 'package:doan_ql_thu_chi/controllers/update_category_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

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
    // TODO: implement initState
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
    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
                onPressed: () {
                  Get.dialog(AlertDialog(
                    title: Text('Bạn có chắc chắn muốn xóa không ?'.tr),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: Text('Hủy'.tr)),
                        TextButton(
                            onPressed: () async {
                              await controller.deleteCategory(widget.id);
                              Get.back();
                              Get.until((route) =>
                              route.settings.name == '/Category');
                            },
                            child: Text('Xác nhận'.tr)),
                      ],
                    ),
                  ));
                },
                icon: const Icon(Icons.delete))
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
              backgroundColor: Theme.of(context).indicatorColor,
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
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
          return InkWell(
            onTap: () {
              controller.selectedTNColor.value = color.value;
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedTNColor.value == color.value
                        ? Colors.white
                        : Colors.grey.withOpacity(0.3),
                    width: controller.selectedTNColor.value == color.value ? 3 : 1,
                  ),
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: controller.selectedTNColor.value == color.value
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: controller.selectedTNColor.value == color.value
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
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
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: controller.selectedIconTNCode.value == iconCode
                        ? Colors.blueAccent
                        : Colors.grey.withOpacity(0.3),
                    width: controller.selectedIconTNCode.value == iconCode
                        ? 2
                        : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: controller.selectedIconTNCode.value == iconCode
                      ? [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 0,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Icon(
                  IconData(iconCode, fontFamily: 'MaterialIcons'),
                  color: controller.selectedIconTNCode.value == iconCode
                      ? Colors.blueAccent
                      : Colors.grey[600],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Tên danh mục'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextFormField(
              validator: controller.checkNameDM,
              controller: nameDMController,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Nhập tên...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}