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
      print('loading state: ${controller.isLoading}');
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
      key: formKey,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: Container(
        //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        //   width: double.infinity,
        //   child: ElevatedButton(
        //       style:
        //           ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        //       onPressed: () async {
        //         await controller.addCategory(nameDMThuNhapController.text,
        //             controller.selectedIconCode.value, 'Thu Nhập');
        //       },
        //       child: Text(
        //         'Lưu danh mục',
        //         style: TextStyle(color: Colors.white),
        //       )),
        // ),
        appBar: AppBar(
          title: Text(
            widget.name.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
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
                              // Get.back();
                              //Get.off(Category());
                              Get.until((route) =>
                                  route.settings.name == '/Category');
                            },
                            child: Text('Xác nhận'.tr)),
                      ],
                    ),
                  ));
                },
                icon: Icon(Icons.delete))
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Tên danh mục : '.tr),
                    Expanded(
                      child: TextFormField(
                        validator: controller.checkNameDM,
                        controller: nameDMController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [Text('Biểu tượng'.tr)],
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: doubleHeight * (245 / 800),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemCount: IconColorCategory.iconCodes.length,
                    itemBuilder: (context, index) {
                      final iconCode = IconColorCategory.iconCodes[index];
                      return InkWell(
                        onTap: () {
                          controller.selectedIconTNCode.value = iconCode;
                        },
                        child: Obx(
                          () => Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: controller.selectedIconTNCode.value ==
                                          iconCode
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                  width: controller.selectedIconTNCode.value ==
                                          iconCode
                                      ? 2
                                      : 1,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Icon(IconData(iconCode,
                                fontFamily: 'MaterialIcons')),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Màu sắc'.tr),
                  ],
                ),
                SizedBox(height: 5),
                Container(
                  height: doubleHeight * (245 / 800),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          () => Container(
                           // padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: controller.selectedTNColor.value == color.value
                                    ? Colors.yellow
                                    : Colors.grey,
                                width: controller.selectedTNColor.value == color.value ? 4 : 2,
                              ),
                              color: color,
                              borderRadius: BorderRadius.circular(10),
                              // boxShadow: controller.selectedTNColor.value == color.value
                              //     ? [
                              //   BoxShadow(
                              //     color: Colors.yellow.withOpacity(0.5), // Bóng vàng mờ
                              //     spreadRadius: 2,
                              //     blurRadius: 4,
                              //   ),
                              // ]
                              //     : [],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: doubleHeight * (50 / 800),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).indicatorColor,
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await controller.updateCategory(
                            widget.id,
                            nameDMController.text,
                            controller.selectedIconTNCode.value,
                            controller.selectedTNColor.value,
                            widget.type,
                          );
                          Get.until(
                              (route) => route.settings.name == '/Category');
                        }
                      },
                      child: Text(
                        'Lưu Danh Mục'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
