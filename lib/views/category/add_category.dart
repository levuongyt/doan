import 'package:doan_ql_thu_chi/config/category/icon_color_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../config/themes/themes_app.dart';
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
    controller.selectedTNColor.value = Colors.red.toARGB32();
    controller.selectedCTColor.value = Colors.red.toARGB32();
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
            backgroundColor: Colors.transparent,
            elevation: 0,
                                  flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: Theme.of(context).extension<AppGradientTheme>()?.primaryGradient ?? LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                ),
            ),
            title: Text(
              'TẠO DANH MỤC'.tr,
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
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).cardColor 
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                        border: Theme.of(context).brightness == Brightness.dark 
                            ? Border.all(color: Theme.of(context).dividerColor) 
                            : null,
                      ),
                      child: TabBar(
                        controller: tabController,
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: Theme.of(context).extension<AppGradientTheme>()?.buttonGradient ?? const LinearGradient(
                            colors: [Colors.blueAccent, Colors.blue],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
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
                        overlayColor: WidgetStateProperty.all(Colors.transparent),
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
              controller.selectedCTColor.value = color.toARGB32();
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedCTColor.value == color.toARGB32()
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor.withValues(alpha: 0.4),
                    width: controller.selectedCTColor.value == color.toARGB32() ? 3 : 1,
                  ),
                  color: color,
                  borderRadius: BorderRadius.circular(12),

                ),
                child: controller.selectedCTColor.value == color.toARGB32()
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
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Theme.of(context).cardColor,
                  border: Border.all(
                    color: controller.selectedIconCTCode.value == iconCode
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor.withValues(alpha: 0.4),
                    width: controller.selectedIconCTCode.value == iconCode
                        ? 2
                        : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),

                ),
                child: Icon(
                  IconData(iconCode, fontFamily: 'MaterialIcons'),
                  color: controller.selectedIconCTCode.value == iconCode
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

  Widget buildRowTitle(String title) {
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

  Widget buildRowNameDM() {
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
              controller: nameDMChiTieuController,
              validator: controller.checkNameCategory,
              onChanged: (value) {
                if (formKey.currentState != null) {
                  formKey.currentState!.validate();
                }
              },
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
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
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
              controller: nameDMThuNhapController,
              validator: controller.checkNameCategory,
              onChanged: (value) {
                if (formKey.currentState != null) {
                  formKey.currentState!.validate();
                }
              },
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
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
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
              controller.selectedTNColor.value = color.toARGB32();
            },
            child: Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: controller.selectedTNColor.value == color.toARGB32()
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor.withValues(alpha: 0.4),
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

  Color _getContrastColor(Color color) {
    double luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }
}
