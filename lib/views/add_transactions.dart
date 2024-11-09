import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/views/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../controllers/transaction_controller.dart';
import 'add_category.dart';

class NhapLieu extends StatefulWidget {
  const NhapLieu({super.key});

  @override
  State<NhapLieu> createState() => _NhapLieuState();
}

class _NhapLieuState extends State<NhapLieu> {
  final TransactionController controller = Get.find();
  final SettingController settingController = Get.find();
  final formKey = GlobalKey<FormState>();

  final TextEditingController ngayController = TextEditingController();
  final TextEditingController noiDungController = TextEditingController();
  final TextEditingController tienController = TextEditingController();

  final TextEditingController ngayChiController = TextEditingController();
  final TextEditingController noiDungChiController = TextEditingController();
  final TextEditingController tienChiController = TextEditingController();

  DateTime? pickedDate = DateTime.now();
  String idDanhMucTN = '';
  String idDanhMucCT = '';
  final currencyFormatter = NumberFormat('#,##0');
  void reset() {
    noiDungController.clear();
    tienController.clear();
    noiDungChiController.clear();
    tienChiController.clear();
    if (controller.listIncomeCategory.isNotEmpty) {
      controller.selectedIncomeCategory.value =
          controller.listIncomeCategory[0].id ?? "";
    }
    if (controller.listExpenseCategory.isNotEmpty) {
      controller.selectedExpenseCategory.value =
          controller.listExpenseCategory[0].id ?? "";
    }
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
    ngayController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    ngayChiController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              'NHẬP LIỆU'.tr,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            centerTitle: true,
            iconTheme: IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50.0),
              child: Container(
                // color: Colors.grey[300],
                color: Theme.of(context).cardColor,
                child: Column(
                  children: [
                    Container(
                      height: 10,
                      color: Theme.of(context).dividerColor,
                    ),
                    TabBar(
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
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
              child: TabBarView(children: [
            ///TAB 1
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Ngày'.tr,
                            )),
                        IconButton(
                            onPressed: () {
                              DateTime currentDate = DateFormat('dd/MM/yyyy')
                                  .parse(ngayController.text);
                              DateTime newDate =
                                  currentDate.subtract(Duration(days: 1));
                              ngayController.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: ngayController,
                            readOnly: true,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                                locale:
                                    settingController.selectedLanguage.value,
                              );

                              if (newDate != null) {
                                pickedDate = newDate;
                                ngayController.text = DateFormat('dd/MM/yyyy')
                                    .format(pickedDate ?? DateTime.now());
                              }
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              DateTime currentDate = DateFormat('dd/MM/yyyy')
                                  .parse(ngayController.text);
                              DateTime newDate =
                                  currentDate.add(Duration(days: 1));
                              ngayController.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                            },
                            icon: Icon(
                              Icons.navigate_next,
                              size: 40,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              'Nội dung '.tr,
                            )),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: noiDungController,
                            validator: controller.ktNoiDung,
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
                      children: [
                        Expanded(flex: 1, child: Text('Số tiền'.tr)),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            width: doubleWidth * (177 / 360),
                            child: TextFormField(
                              controller: tienController,
                              // validator: controller.ktSoTien,
                              validator: controller.validateMoney,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                value = value.replaceAll(',', '');
                                tienController.value = TextEditingValue(
                                    text: currencyFormatter
                                        .format(int.tryParse(value) ?? 0),
                                    selection: TextSelection.collapsed(
                                        offset: currencyFormatter
                                            .format(int.tryParse(value) ?? 0)
                                            .length));
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Obx(() => Text(controller.donViTienTe.value)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Danh mục'.tr),
                          TextButton(
                              onPressed: () {
                                //  Get.to(Category());
                                // Get.to(Category());
                                Get.to(() => Category(),
                                    routeName: '/Category');
                              },
                              child: Text('Tùy chỉnh danh mục'.tr))
                        ]),
                    SizedBox(height: 10),
                    Obx(
                      () => Container(
                        height: doubleHeight * (260 / 800),
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listIncomeCategory.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 4),
                            itemBuilder: (BuildContext context, int index) {
                              final category =
                                  controller.listIncomeCategory[index];
                              // idDanhMucTN=controller.selectedIncomeCategory.value;
                              return InkWell(
                                  onTap: () {
                                    controller.selectIncomeCategory(
                                        category.id ?? "");
                                    // print(
                                    //     'id la :${controller.selectedCategory.value}');
                                    // print('a');
                                    idDanhMucTN = '${category.id}';
                                    // print(idDanhMuc);
                                  },
                                  child: Obx(
                                    () => Container(
                                      width: doubleWidth * (85 / 360),
                                      height: doubleHeight * (62 / 800),
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller
                                                        .selectedIncomeCategory
                                                        .value ==
                                                    category.id
                                                ? Colors.blueAccent
                                                : Colors.grey,
                                            width: controller
                                                        .selectedIncomeCategory
                                                        .value ==
                                                    category.id
                                                ? 1.5
                                                : 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            IconData(
                                                category.iconCode ??
                                                    Icons.category.codePoint,
                                                fontFamily: 'MaterialIcons'),
                                            color: Color(category.colorIcon ??
                                                Colors.blueAccent.value),
                                          ),
                                          Text('${category.name}'.tr)
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
                              await controller.addTransaction(
                                  // amount: double.parse(tienController.text),
                                  amount: double.parse(
                                      tienController.text.replaceAll(',', '')),
                                  description: noiDungController.text,
                                  categoryId: idDanhMucTN,
                                  type: 'Thu Nhập',
                                  date: pickedDate ?? DateTime.now());
                              await controller.saveMonthlyReport(
                                  pickedDate ?? DateTime.now());
                              reset();
                            }
                          },
                          child: Text(
                            'Lưu thu nhập'.tr,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                    )
                  ],
                ),
              ),
            ),

            ///TAB 2 CHI TIÊU
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 1, child: Text('Ngày'.tr)),
                        IconButton(
                            onPressed: () {
                              DateTime currentDate = DateFormat('dd/MM/yyyy')
                                  .parse(ngayChiController.text);
                              DateTime newDate =
                                  currentDate.subtract(Duration(days: 1));
                              ngayChiController.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                            },
                            icon: Icon(Icons.arrow_back_ios)),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: ngayChiController,
                            readOnly: true, // Ngăn người dùng tự nhập
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.calendar_month),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );

                              if (pickedDate != null) {
                                pickedDate = newDate;
                                ngayChiController.text =
                                    DateFormat('dd/MM/yyyy')
                                        .format(pickedDate ?? DateTime.now());
                              }
                            },
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              DateTime currentDate = DateFormat('dd/MM/yyyy')
                                  .parse(ngayChiController.text);
                              DateTime newDate =
                                  currentDate.add(Duration(days: 1));
                              ngayChiController.text =
                                  DateFormat('dd/MM/yyyy').format(newDate);
                            },
                            icon: Icon(
                              Icons.navigate_next,
                              size: 40,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(flex: 1, child: Text('Nội dung : '.tr)),
                        Expanded(
                          flex: 4,
                          child: TextFormField(
                            controller: noiDungChiController,
                            validator: controller.ktNoiDung,
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
                      children: [
                        Expanded(flex: 1, child: Text('Số tiền'.tr)),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            width: doubleWidth * (177 / 360),
                            child: TextFormField(
                              controller: tienChiController,
                            //  validator: controller.ktSoTien,
                              validator: controller.validateMoney,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (value) {
                                value = value.replaceAll(',', '');
                                tienChiController.value = TextEditingValue(
                                  text: currencyFormatter
                                      .format(int.tryParse(value) ?? 0),
                                  selection: TextSelection.collapsed(
                                      offset: currencyFormatter
                                          .format(int.tryParse(value) ?? 0)
                                          .length),
                                );
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Obx(() => Text(controller.donViTienTe.value)),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Danh mục'.tr),
                          TextButton(
                              onPressed: () {
                                //  Get.to(Category());
                                Get.to(() => Category(),
                                    routeName: '/Category');
                              },
                              child: Text('Tùy chỉnh danh mục'.tr))
                        ]),
                    SizedBox(height: 10),
                    Obx(
                      () => Container(
                        height: doubleHeight * (260 / 800),
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: controller.listExpenseCategory.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 15,
                                    crossAxisCount: 4),
                            itemBuilder: (BuildContext context, int index) {
                              final category =
                                  controller.listExpenseCategory[index];
                              //idDanhMucCT =
                              //   controller.selectedExpenseCategory.value;
                              // print(
                              //    'ccv ${controller.selectedExpenseCategory.value}');
                              return InkWell(
                                  onTap: () {
                                    controller.selectExpenseCategory(
                                        category.id ?? "");
                                    // print(
                                    //     'id la :${controller.selectedCategory.value}');
                                    // print('a');
                                    idDanhMucCT = '${category.id}';
                                    // print(idDanhMuc);
                                  },
                                  child: Obx(
                                    () => Container(
                                      width: doubleWidth * (85 / 360),
                                      height: doubleHeight * (62 / 800),
                                      padding: EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: controller
                                                        .selectedExpenseCategory
                                                        .value ==
                                                    category.id
                                                ? Colors.blueAccent
                                                : Colors.grey,
                                            width: controller
                                                        .selectedExpenseCategory
                                                        .value ==
                                                    category.id
                                                ? 1.5
                                                : 1.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            IconData(
                                                category.iconCode ??
                                                    Icons.category.codePoint,
                                                fontFamily: 'MaterialIcons'),
                                            color: Color(category.colorIcon ??
                                                Colors.blueAccent.value),
                                          ),
                                          Text('${category.name}'.tr)
                                        ],
                                      ),
                                    ),
                                  ));
                            }),
                      ),
                    ),
                    SizedBox(
                      height: 5,
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
                              await controller.addTransaction(
                                  amount: double.parse(tienChiController.text
                                      .replaceAll(',', '')),
                                  description: noiDungChiController.text,
                                  categoryId: idDanhMucCT,
                                  type: 'Chi Tiêu',
                                  date: pickedDate ?? DateTime.now());
                              await controller.saveMonthlyReport(
                                  pickedDate ?? DateTime.now());
                              reset();
                            }
                          },
                          child: Text(
                            'Lưu chi tiêu'.tr,
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          )),
                    )
                  ],
                ),
              ),
            ),
          ])),
        ),
      ),
    );
  }
}
