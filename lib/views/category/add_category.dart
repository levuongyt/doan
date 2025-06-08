import 'package:doan_ql_thu_chi/config/category/icon_color_category.dart';
import 'package:doan_ql_thu_chi/widget_common/tabbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../controllers/add_category_controller.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> with TickerProviderStateMixin {
  final AddCetegoryController controller = Get.put(AddCetegoryController());
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameDMThuNhapController = TextEditingController();
  final TextEditingController nameDMChiTieuController = TextEditingController();
  late TabController tabController;

  void reset() {
    nameDMChiTieuController.clear();
    nameDMThuNhapController.clear();
    controller.selectedIconTNCode.value = Icons.home.codePoint;
    controller.selectedIconCTCode.value = Icons.home.codePoint;
    controller.selectedTNColor.value = Colors.red.value;
    controller.selectedCTColor.value = Colors.red.value;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    ever(controller.isLoading, (callback) {
      if (callback) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    return Form(
        key: formKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              'Tạo mới danh mục'.tr,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      height: 8,
                      color: Theme.of(context).dividerColor,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.blue],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey[600],
                        labelStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        tabs: [
                          Container(
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('Thu nhập'.tr),
                          ),
                          Container(
                            height: 45,
                            alignment: Alignment.center,
                            child: Text('Chi tiêu'.tr),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
              child: TabBarView(
            controller: tabController,
            children: [
              buildTabIncome(doubleHeight, context),
              buildTabExpense(doubleHeight, context),
            ],
          )),
          floatingActionButton: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: AnimatedBuilder(
              animation: tabController,
              builder: (context, child) {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (tabController.index == 0) {
                          // Tab Thu nhập
                          await controller.addCategory(
                            nameDMThuNhapController.text,
                            controller.selectedIconTNCode.value,
                            controller.selectedTNColor.value,
                            'Thu Nhập');
                        } else {
                          // Tab Chi tiêu
                          await controller.addCategory(
                            nameDMChiTieuController.text,
                            controller.selectedIconCTCode.value,
                            controller.selectedCTColor.value,
                            'Chi Tiêu');
                        }
                        reset();
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
                );
              },
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
    }

  SingleChildScrollView buildTabIncome(
      double doubleHeight, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
                    children: [
            const SizedBox(height: 5),
            buildRowNameCategoryIncome(),
            const SizedBox(height: 5),
            buildRowTitle('Biểu tượng'),
            buildListIconIncome(doubleHeight),
            const SizedBox(height: 5),
            buildRowTitle('Màu sắc'),
            buildListColorIncome(doubleHeight),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildTabExpense(
      double doubleHeight, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
                    children: [
            const SizedBox(height: 5),
            buildRowNameDM(),
            const SizedBox(height: 5),
            buildRowTitle('Biểu tượng'),
            buildListIconExpense(doubleHeight),
            const SizedBox(height: 5),
            buildRowTitle('Màu sắc'),
            buildListColorExpense(doubleHeight),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }



  SizedBox buildListColorExpense(double doubleHeight) {
    return SizedBox(
      height: doubleHeight * (220 / 800),
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
              controller.selectedCTColor.value = color.value;
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedCTColor.value == color.value
                        ? Colors.white
                        : Colors.grey.withOpacity(0.3),
                    width: controller.selectedCTColor.value == color.value ? 3 : 1,
                  ),
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: controller.selectedCTColor.value == color.value
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
                child: controller.selectedCTColor.value == color.value
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

  SizedBox buildListIconExpense(double doubleHeight) {
    return SizedBox(
      height: doubleHeight * (220 / 800),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: IconColorCategory.iconCodes.length,
        itemBuilder: (context, index) {
          final iconCode = IconColorCategory.iconCodes[index];
          return InkWell(
            onTap: () {
              controller.selectedIconCTCode.value = iconCode;
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: controller.selectedIconCTCode.value == iconCode
                      ? Colors.blueAccent.withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: controller.selectedIconCTCode.value == iconCode
                        ? Colors.blueAccent
                        : Colors.grey.withOpacity(0.3),
                    width: controller.selectedIconCTCode.value == iconCode
                        ? 2
                        : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: controller.selectedIconCTCode.value == iconCode
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
                  color: controller.selectedIconCTCode.value == iconCode
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

  Widget buildRowTitle(String title) {
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

  Widget buildRowNameDM() {
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
              controller: nameDMChiTieuController,
              validator: controller.checkNameCategory,
              onChanged: (value) {
                if (formKey.currentState != null) {
                  formKey.currentState!.validate();
                }
              },
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
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget buildRowNameCategoryIncome() {
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
              controller: nameDMThuNhapController,
              validator: controller.checkNameCategory,
              onChanged: (value) {
                if (formKey.currentState != null) {
                  formKey.currentState!.validate();
                }
              },
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
                  borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }



  SizedBox buildListColorIncome(double doubleHeight) {
    return SizedBox(
      height: doubleHeight * (220 / 800),
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

  SizedBox buildListIconIncome(double doubleHeight) {
    return SizedBox(
      height: doubleHeight * (220 / 800),
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
}
