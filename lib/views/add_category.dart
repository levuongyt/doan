import 'package:doan_ql_thu_chi/config/category/icon_color_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../controllers/add_category_controller.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final AddCetegoryController controller = Get.put(AddCetegoryController());
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameDMThuNhapController = TextEditingController();
  final TextEditingController nameDMChiTieuController = TextEditingController();

  void reset(){
    nameDMChiTieuController.clear();
    nameDMThuNhapController.clear();
    controller.selectedIconTNCode.value = Icons.home.codePoint;
    controller.selectedIconCTCode.value = Icons.home.codePoint;
    controller.selectedTNColor.value = Colors.red.value;
    controller.selectedCTColor.value = Colors.red.value;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Form(
        key: formKey,
        child: Scaffold(
           floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              'Tạo mới danh mục'.tr,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize:
                  Size.fromHeight(50.0), // Adjust the height as needed
              child: Column(
                children: [
                  Container(
                    height: 10,
                    color: Theme.of(context).dividerColor,
                  ),
                  Container(
                    color: Theme.of(context).cardColor, // Background color for unselected tabs
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(
                          text: 'Thu nhập'.tr,
                        ),
                        Tab(
                          text: 'Chi tiêu'.tr,
                        ),
                      ],
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.blue,
                      indicator: BoxDecoration(
                        color: Theme.of(context).indicatorColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SafeArea(
              child: TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Tên danh mục : '.tr),
                          Expanded(
                            child: TextFormField(
                              controller: nameDMThuNhapController,
                              validator: controller.checkNameCategory,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        children: [
                          Text('Biểu tượng'.tr),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: doubleHeight * (220 / 800),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                          color: controller.selectedIconTNCode
                                                      .value ==
                                                  iconCode
                                              ? Colors.blueAccent
                                              : Colors.grey,
                                        width: controller.selectedIconTNCode
                                            .value ==
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
                        height: doubleHeight * (220 / 800),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller.selectedTNColor.value ==
                                              color.value
                                          ? Colors.yellow
                                          : Colors.grey,
                                      width: controller.selectedTNColor.value ==
                                          color.value
                                          ? 4
                                          : 2,
                                    ),
                                    color: color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                await controller.addCategory(
                                    nameDMThuNhapController.text,
                                    controller.selectedIconTNCode.value,
                                    controller.selectedTNColor.value,
                                    'Thu Nhập');
                                reset();
                              }
                            },
                            child: Text(
                              'Lưu Danh Mục'.tr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                ),
              ),

              ///Tab2
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text('Tên danh mục : '.tr),
                          Expanded(
                            child: TextFormField(
                              controller: nameDMChiTieuController,
                              validator: controller.checkNameCategory,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [Text('Biểu tượng'.tr)],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: doubleHeight * (220 / 800),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: IconColorCategory.iconCodes.length,
                          itemBuilder: (context, index) {
                            final iconCode = IconColorCategory.iconCodes[index];
                            return InkWell(
                              onTap: () {
                                controller.selectedIconCTCode.value = iconCode;
                              },
                              child: Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: controller.selectedIconCTCode
                                                      .value ==
                                                  iconCode
                                              ? Colors.blueAccent
                                              : Colors.grey,
                                        width: controller.selectedIconCTCode
                                            .value ==
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
                        height: doubleHeight * (220 / 800),
                        child: GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: IconColorCategory.colors.length,
                          itemBuilder: (context, index) {
                            final color = IconColorCategory.colors[index];
                            return InkWell(
                              onTap: () {
                                controller.selectedCTColor.value = color.value;
                              },
                              child: Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller.selectedCTColor.value ==
                                              color.value
                                          ? Colors.yellow
                                          : Colors.grey,
                                      width: controller.selectedCTColor.value ==
                                          color.value
                                          ? 4
                                          : 2,
                                    ),
                                    color: color,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                                await controller.addCategory(
                                    nameDMChiTieuController.text,
                                    controller.selectedIconCTCode.value,
                                    controller.selectedCTColor.value,
                                    'Chi Tiêu');
                                reset();
                              }
                            },
                            child: Text(
                              'Lưu Danh Mục'.tr,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
