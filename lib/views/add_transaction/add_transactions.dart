import 'package:doan_ql_thu_chi/config/extensions/extension_currency.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../controllers/transaction_controller.dart';
import '../category/category.dart';

class NhapLieu extends StatefulWidget {
  const NhapLieu({super.key});

  @override
  State<NhapLieu> createState() => _NhapLieuState();
}

class _NhapLieuState extends State<NhapLieu> with TickerProviderStateMixin {
  final TransactionController controller = Get.find();
  final SettingController settingController = Get.find();
  final formKey = GlobalKey<FormState>();
  late TabController tabController;
  final TextEditingController ngayController = TextEditingController();
  final TextEditingController noiDungController = TextEditingController();
  final TextEditingController tienController = TextEditingController(text: "0");
  final TextEditingController ngayChiController = TextEditingController();
  final TextEditingController noiDungChiController = TextEditingController();
  final TextEditingController tienChiController = TextEditingController(text: "0");
  DateTime? pickedDate = DateTime.now();
  String idDanhMucTN = '';
  String idDanhMucCT = '';
  final NumberFormat currencyFormatterVN = NumberFormat('#,##0');
  final NumberFormat currencyFormatter = NumberFormat('#,##0.##');

  void reset() {
    pickedDate = DateTime.now();
    noiDungController.clear();
    tienController.text = "0";
    noiDungChiController.clear();
    tienChiController.text = "0";
    ngayController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    ngayChiController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    if (controller.listIncomeCategory.isNotEmpty) {
      controller.selectedIncomeCategory.value =
          controller.listIncomeCategory[0].id ?? "";
      idDanhMucTN = '';
    }
    if (controller.listExpenseCategory.isNotEmpty) {
      controller.selectedExpenseCategory.value =
          controller.listExpenseCategory[0].id ?? "";
      idDanhMucCT = '';
    }
  }

  Future<void> _saveIncome() async {
    if (formKey.currentState!.validate()) {
      double amountTN;
      if (controller.donViTienTe.value == "đ") {
        amountTN = double.parse(tienController.text.replaceAll(',', ''));
      } else {
        amountTN = double.parse(tienController.text.replaceAll(',', '')).toVND();
      }
      await controller.addTransaction(
          amount: amountTN,
          description: noiDungController.text,
          categoryId: idDanhMucTN,
          type: 'Thu Nhập',
          date: pickedDate ?? DateTime.now());
      reset();
      await controller.saveMonthlyReport(pickedDate ?? DateTime.now());
    }
  }

  Future<void> _saveExpense() async {
    if (formKey.currentState!.validate()) {
      double amountCT;
      if (controller.donViTienTe.value == "đ") {
        amountCT = double.parse(tienChiController.text.replaceAll(',', ''));
      } else {
        amountCT = double.parse(tienChiController.text.replaceAll(',', '')).toVND();
      }
      await controller.addTransaction(
          amount: amountCT,
          description: noiDungChiController.text,
          categoryId: idDanhMucCT,
          type: 'Chi Tiêu',
          date: pickedDate ?? DateTime.now());
      reset();
      await controller.saveMonthlyReport(pickedDate ?? DateTime.now());
    }
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
    ngayController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
    ngayChiController.text = DateFormat('dd/MM/yyyy').format(DateTime.now());
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;
    return Form(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //const Icon(Icons.trending_up, size: 20),
                              const SizedBox(width: 8),
                              Text('Thu nhập'.tr),
                            ],
                          ),
                        ),
                        Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             // const Icon(Icons.trending_down, size: 20),
                              const SizedBox(width: 8),
                              Text('Chi tiêu'.tr),
                            ],
                          ),
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
              buildTabIncome(context, doubleWidth, doubleHeight),
              buildTabExpense(context, doubleWidth, doubleHeight),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 15, // Cách navbar đủ khoảng cách
          ),
          child: AnimatedBuilder(
            animation: tabController,
            builder: (context, child) {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: () async {
                    if (tabController.index == 0) {
                      await _saveIncome();
                    } else {
                      await _saveExpense();
                    }
                  },
                  backgroundColor: Theme.of(context).indicatorColor,
                  foregroundColor: Colors.white,
                  label: Text(
                    tabController.index == 0 
                        ? 'Lưu thu nhập'.tr 
                        : 'Lưu chi tiêu'.tr,
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Padding buildTabIncome(
      BuildContext context, double doubleWidth, double doubleHeight) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildRowDay(context),
            const SizedBox(height: 6),
            buildRowContent(),
            const SizedBox(height: 6),
            buildRowAmount(doubleWidth),
            const SizedBox(height: 6),
            buildRowCategory(),
            const SizedBox(height: 6),
            buildListCategory(doubleHeight, doubleWidth),
            const SizedBox(height: 120), // Space for FloatingActionButton
          ],
        ),
      ),
    );
  }

  SingleChildScrollView buildTabExpense(
      BuildContext context, double doubleWidth, double doubleHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            buildRowDayCT(context),
            const SizedBox(height: 6),
            buildRowContentCT(),
            const SizedBox(height: 6),
            buildRowAmountCT(doubleWidth),
            const SizedBox(height: 6),
            buildRowCategory(),
            const SizedBox(height: 6),
            buildListCategoryCT(doubleHeight, doubleWidth),
            const SizedBox(height: 120), // Space for FloatingActionButton
          ],
        ),
      ),
    );
  }



  Obx buildListCategoryCT(double doubleHeight, double doubleWidth) {
    return Obx(
          () => SizedBox(
        height: doubleHeight * (200 / 800),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: controller.listExpenseCategory.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 10, mainAxisSpacing: 15, crossAxisCount: 4),
            itemBuilder: (BuildContext context, int index) {
              final category = controller.listExpenseCategory[index];
              return InkWell(
                  onTap: () {
                    controller.selectExpenseCategory(category.id ?? "");
                    idDanhMucCT = '${category.id}';
                  },
                  child: Obx(
                        () => Container(
                      width: doubleWidth * (85 / 360),
                      height: doubleHeight * (62 / 800),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.selectedExpenseCategory.value ==
                                category.id
                                ? Colors.blueAccent
                                : Colors.grey.withOpacity(0.3),
                            width: controller.selectedExpenseCategory.value ==
                                category.id
                                ? 3
                                : 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(category.iconCode,
                                fontFamily: 'MaterialIcons'),
                            color: Color(category.colorIcon),
                          ),
                          Text(category.name.tr)
                        ],
                      ),
                    ),
                  ));
            }),
      ),
    );
  }

  Widget buildRowAmountCT(double doubleWidth) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.money_off,
              color: Colors.red,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              'Số tiền'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Obx(() {
              return TextFormField(
                controller: tienChiController,
                validator: controller.validateMoney,
                inputFormatters: controller.donViTienTe.value == 'đ'
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}')),
                ],
                onChanged: (value) {
                  String valueT = value.replaceAll(',', '');
                  if (controller.donViTienTe.value == 'đ') {
                    final formattedValue =
                    currencyFormatterVN.format(int.tryParse(valueT) ?? 0);
                    tienChiController.value = TextEditingValue(
                        text: formattedValue,
                        selection: TextSelection.collapsed(
                            offset: formattedValue.length));
                  }else{
                    if (value.isEmpty || value == '0') {
                      tienChiController.value = const TextEditingValue(
                        text: '0',
                        selection: TextSelection.collapsed(offset: 1),
                      );
                    } else {
                      final newValue = value.replaceFirst(RegExp(r'^0'), '');
                      if (tienChiController.text != newValue) {
                        tienChiController.value = TextEditingValue(
                          text: newValue,
                          selection: TextSelection.collapsed(offset: newValue.length),
                        );
                      }
                    }
                  }
                  if (formKey.currentState != null) {
                    formKey.currentState!.validate();
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              );
            }),
          ),
          const SizedBox(width: 12),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              controller.donViTienTe.value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget buildRowContentCT() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              'Nội dung'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: noiDungChiController,
              validator: controller.ktNoiDung,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Nhập mô tả giao dịch...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowDayCT(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              'Ngày'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              DateTime currentDate =
              DateFormat('dd/MM/yyyy').parse(ngayChiController.text);
              DateTime newDate = currentDate.subtract(const Duration(days: 1));
              ngayChiController.text = DateFormat('dd/MM/yyyy').format(newDate);
              pickedDate = newDate;
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: ngayChiController,
              readOnly: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.blueAccent,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: const Icon(Icons.calendar_month, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              ),
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: pickedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );

                if (newDate != null) {
                  pickedDate = newDate;
                  ngayChiController.text = DateFormat('dd/MM/yyyy')
                      .format(pickedDate ?? DateTime.now());
                }
              },
            ),
          ),
          IconButton(
            onPressed: () {
              DateTime currentDate =
              DateFormat('dd/MM/yyyy').parse(ngayChiController.text);
              DateTime newDate = currentDate.add(const Duration(days: 1));
              ngayChiController.text = DateFormat('dd/MM/yyyy').format(newDate);
              pickedDate = newDate;
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ),
          ),
        ],
      ),
    );
  }





  Obx buildListCategory(double doubleHeight, double doubleWidth) {
    return Obx(
          () => SizedBox(
        height: doubleHeight * (200 / 800),
        child: GridView.builder(
            shrinkWrap: true,
            itemCount: controller.listIncomeCategory.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5, mainAxisSpacing: 10, crossAxisCount: 4),
            itemBuilder: (BuildContext context, int index) {
              final category = controller.listIncomeCategory[index];
              return InkWell(
                  onTap: () {
                    controller.selectIncomeCategory(category.id ?? "");
                    idDanhMucTN = '${category.id}';
                  },
                  child: Obx(
                        () => Container(
                      width: doubleWidth * (85 / 360),
                      height: doubleHeight * (62 / 800),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.selectedIncomeCategory.value ==
                                category.id
                                ? Colors.blueAccent
                                : Colors.grey.withOpacity(0.3),
                            width: controller.selectedIncomeCategory.value ==
                                category.id
                                ? 3
                                : 2,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            IconData(category.iconCode,
                                fontFamily: 'MaterialIcons'),
                            color: Color(category.colorIcon),
                          ),
                          Text(category.name.tr)
                        ],
                      ),
                    ),
                  ));
            }),
      ),
    );
  }

  Widget buildRowCategory() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.category,
                  color: Colors.purple,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Danh mục'.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () {
              Get.to(() => const Category(), routeName: '/Category');
            },
            icon: const Icon(Icons.settings, size: 18),
            label: Text(
              'Tùy chỉnh'.tr,
              style: const TextStyle(fontSize: 14),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowAmount(double doubleWidth) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.attach_money,
              color: Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              'Số tiền'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Obx(() {
              return TextFormField(
                controller: tienController,
                validator: controller.validateMoney,
                inputFormatters: controller.donViTienTe.value == 'đ'
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
                onChanged: (value) {
                  if (controller.donViTienTe.value == 'đ') {
                    value = value.replaceAll(',', '');
                    final formattedValue =
                    currencyFormatterVN.format(int.tryParse(value) ?? 0);
                    tienController.value = TextEditingValue(
                        text: formattedValue,
                        selection: TextSelection.collapsed(
                            offset: formattedValue.length));
                  } else {
                    if (value.isEmpty || value == '0') {
                      tienController.value = const TextEditingValue(
                        text: '0',
                        selection: TextSelection.collapsed(offset: 1),
                      );
                    } else {
                      final newValue = value.replaceFirst(RegExp(r'^0'), '');
                      if (tienController.text != newValue) {
                        tienController.value = TextEditingValue(
                          text: newValue,
                          selection: TextSelection.collapsed(offset: newValue.length),
                        );
                      }
                    }
                  }
                  if (formKey.currentState != null) {
                    formKey.currentState!.validate();
                  }
                },
                keyboardType: TextInputType.numberWithOptions(
                    decimal: controller.donViTienTe.value != 'đ'),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 18),
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                ),
              );
            }),
          ),
          const SizedBox(width: 12),
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              controller.donViTienTe.value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget buildRowContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.description,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              'Nội dung'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: noiDungController,
              validator: controller.ktNoiDung,
              inputFormatters: [LengthLimitingTextInputFormatter(100)],
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Nhập mô tả giao dịch...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRowDay(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              'Ngày'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              DateTime currentDate =
              DateFormat('dd/MM/yyyy').parse(ngayController.text);
              DateTime newDate = currentDate.subtract(const Duration(days: 1));
              ngayController.text = DateFormat('dd/MM/yyyy').format(newDate);
              pickedDate = newDate;
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.chevron_left, color: Colors.grey, size: 20),
            ),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              controller: ngayController,
              readOnly: true,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.blueAccent,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: const Icon(Icons.calendar_month, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
              ),
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: pickedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                  locale: settingController.selectedLanguage.value,
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
              DateTime currentDate =
              DateFormat('dd/MM/yyyy').parse(ngayController.text);
              DateTime newDate = currentDate.add(const Duration(days: 1));
              ngayController.text = DateFormat('dd/MM/yyyy').format(newDate);
              pickedDate = newDate;
            },
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}