import 'package:doan_ql_thu_chi/Models/category_model.dart';
import 'package:doan_ql_thu_chi/config/extensions/extension_currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../account/account.dart';
import '../add_transaction/add_transactions.dart';
import '../report/report.dart';
import '../setting/setting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NavigationController navigationController =
      Get.put(NavigationController());

  final List<Widget> pages = [
    const HomePage(),
    const NhapLieu(),
    const BaoCao(),
    const Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navigationController.selectedIndex.value,
            children: pages,
          )),
      bottomNavigationBar: Obx(() => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: const Icon(Icons.home), label: 'Tổng quan'.tr),
              BottomNavigationBarItem(
                icon: const Icon(Icons.edit_note),
                label: 'Nhập vào'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.bar_chart),
                label: 'Báo cáo'.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: 'Cài đặt'.tr,
              ),
            ],
            currentIndex: navigationController.selectedIndex.value,
            onTap: (index) => navigationController.changeIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Theme.of(context).cardColor,
            selectedItemColor: Colors.blueAccent,
          )),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController controller = Get.find();
  final TextEditingController timKiemController = TextEditingController();
  final TextEditingController totalBalanceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final formKeyBalance = GlobalKey<FormState>();
  final FocusNode dayFocus = FocusNode();
  final NumberFormat currencyFormatter = NumberFormat('#,##0');
  @override
  void initState() {
    super.initState();
    ever(controller.isUpdateLoading, (callback) {
      if (callback) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  String formatBalance(double amount) {
    return controller.donViTienTe.value == 'đ'
        ? '${NumberFormat('#,##0').format(amount.toCurrency())} ${controller.donViTienTe.value}'
        : '${NumberFormat('#,##0.##').format(amount.toCurrency())} ${controller.donViTienTe.value}';
  }

  @override
  Widget build(BuildContext context) {
    final double doubleHeight = MediaQuery.of(context).size.height;
    final double doubleWidth = MediaQuery.of(context).size.width;
    return Form(
      key: formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text(
                'Chào mừng '.tr,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Obx(
                () => Text(
                  controller.userModel.value?.name ?? " ",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                  onPressed: () {
                    Get.to(const Account());
                  },
                  icon: const Icon(
                    Icons.account_circle,
                    color: Colors.white,
                  )),
            ),
          ],
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: doubleWidth * (324 / 360),
                      height: doubleHeight * (80 / 800),
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.dialog(
                                buildFormUpdateBalance(context),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Số dư tài khoản'.tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).hintColor,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.navigate_next,
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                controller.isVisibility.value == false
                                    ? Text(
                                        formatBalance(controller
                                                .userModel.value?.tongSoDu ??
                                            0),
                                        style: const TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : const Text(
                                        '*******',
                                        style: TextStyle(
                                            // color: Colors.blueAccent,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                controller.changeIsVisibility();
                              },
                              icon: controller.isVisibility.value
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off))
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                buildSectionTitle(context, 'Tổng quan thu chi'),
                const SizedBox(height: 10),
                buildOverview(doubleWidth, doubleHeight, context),
                const SizedBox(height: 10),
                buildSectionTitle(context, 'Giao dịch gần đây'),
                const SizedBox(height: 10),
                buildTextFieldSearch(doubleWidth, context),
                buildListTransaction(doubleHeight),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Form buildFormUpdateBalance(BuildContext context) {
    return Form(
      key: formKeyBalance,
      child: AlertDialog(
        title: Center(child: Text('Thiết lập tổng số dư'.tr)),
        content: TextFormField(
          controller: totalBalanceController,
          keyboardType: TextInputType.number,
          validator: controller.validateTotalBalance,
          inputFormatters: controller.donViTienTe.value == 'đ'
              ? [FilteringTextInputFormatter.digitsOnly]
              : [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d+\.?\d{0,2}'),
                  ),
                ],
          onChanged: (value) {
            value = value.replaceAll(',', '');
            if (controller.donViTienTe.value == 'đ') {
              totalBalanceController.value = TextEditingValue(
                text: currencyFormatter.format(int.tryParse(value) ?? 0),
                selection: TextSelection.collapsed(
                    offset: currencyFormatter
                        .format(int.tryParse(value) ?? 0)
                        .length),
              );
            } else {
              if (value.isEmpty || value == '0') {
                totalBalanceController.value = const TextEditingValue(
                  text: '0',
                  selection: TextSelection.collapsed(offset: 1),
                );
              } else {
                final newValue = value.replaceFirst(RegExp(r'^0'), '');
                if (totalBalanceController.text != newValue) {
                  totalBalanceController.value = TextEditingValue(
                    text: newValue,
                    selection: TextSelection.collapsed(offset: newValue.length),
                  );
                }
              }
            }

            if (formKeyBalance.currentState != null) {
              formKeyBalance.currentState!.validate();
            }
          },
          decoration: InputDecoration(
              hintText: 'Nhập số dư'.tr,
              hintStyle: TextStyle(
                color: Theme.of(context).hintColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              ),
              onPressed: () {
                Get.back();
              },
              child: Text(
                'Hủy'.tr,
                style: const TextStyle(color: Colors.white),
              )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              ),
              onPressed: () async {
                if (formKeyBalance.currentState!.validate()) {
                  double amountCT;
                  if (controller.donViTienTe.value == "đ") {
                    amountCT = double.parse(
                        totalBalanceController.text.replaceAll(',', ''));
                  } else {
                    amountCT = double.parse(
                            totalBalanceController.text.replaceAll(',', ''))
                        .toVND();
                  }
                  Get.back();
                  await controller.updateTotalBalance(amountCT);
                }
              },
              child: Text(
                'Lưu'.tr,
                style: const TextStyle(color: Colors.white),
              )),
        ],
      ),
    );
  }

  Obx buildOverview(
      double doubleWidth, double doubleHeight, BuildContext context) {
    return Obx(
      () => Container(
        width: doubleWidth * (324 / 360),
        height: doubleHeight * (205 / 800),
        decoration: BoxDecoration(
          color: Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        DateTime backMonth = DateTime(
                          controller.selectedMonth.value.year,
                          controller.selectedMonth.value.month - 1,
                        );
                        controller.updateSelectedMonth(backMonth);
                      },
                      icon: const Icon(
                        Icons.navigate_before,
                        color: Colors.grey,
                        size: 30,
                      )),
                  TextButton(
                    onPressed: () async {
                      DateTime? chonNgay = await showDialog<DateTime>(
                        context: context,
                        builder: (BuildContext context) {
                          return Localizations.override(
                            context: context,
                            locale: Get.locale,
                            child: Dialog(
                              child: SizedBox(
                                height: doubleHeight * 0.56,
                                child: MonthYearPickerDialog(
                                  initialDate: controller.selectedMonth.value,
                                  firstDate: DateTime(2019),
                                  lastDate: DateTime(2100),
                                  initialMonthYearPickerMode:
                                      MonthYearPickerMode.month,
                                ),
                              ),
                            ),
                          );
                        },
                      );

                      if (chonNgay != null) {
                        controller.updateSelectedMonth(
                          DateTime(chonNgay.year, chonNgay.month, 1),
                        );
                      }
                    },
                    child: Center(
                      child: Text(
                        DateFormat('MM/yyyy')
                            .format(controller.selectedMonth.value),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        DateTime nextMonth = DateTime(
                          controller.selectedMonth.value.year,
                          controller.selectedMonth.value.month + 1,
                        );
                        controller.updateSelectedMonth(nextMonth);
                      },
                      icon: const Icon(
                        Icons.navigate_next,
                        color: Colors.grey,
                        size: 30,
                      ))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(
                    () => Flexible(
                      child: Container(
                          height: doubleHeight * (130 / 800),
                          width: doubleWidth * (170 / 360),
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SfCartesianChart(
                            primaryXAxis: const CategoryAxis(
                              labelStyle: TextStyle(fontSize: 13),
                            ),
                            primaryYAxis: const NumericAxis(
                              isVisible: false,
                            ),
                            series: [
                              ColumnSeries<ChartData, String>(
                                dataSource: [
                                  ChartData(
                                      'Thu'.tr,
                                      (controller.report.value?.totalIncome ??
                                              0)
                                          .toCurrency(),
                                      Colors.green),
                                  ChartData(
                                      'Chi'.tr,
                                      (controller.report.value?.totalExpense ??
                                              0)
                                          .toCurrency(),
                                      Colors.red),
                                ],
                                xValueMapper: (ChartData data, _) => data.x,
                                yValueMapper: (ChartData data, _) => data.y,
                                pointColorMapper: (ChartData data, _) =>
                                    data.color,
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(
                                enable: true, format: 'point.y'),
                          )),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Obx(
                        () => Text(
                          formatBalance(
                              controller.report.value?.totalIncome ?? 0),
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Obx(
                        () => Text(
                          formatBalance(
                              controller.report.value?.totalExpense ?? 0),
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 2,
                        width: doubleWidth * (100 / 360),
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10),
                      Obx(
                        () => Text(
                          formatBalance(
                              controller.report.value?.soDuThang ?? 0),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Obx buildListTransaction(double doubleHeight) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return NotificationListener<ScrollNotification>(
          onNotification: (scroll) {
            if (scroll.metrics.pixels == scroll.metrics.maxScrollExtent) {
              if (scroll is ScrollEndNotification) {
                controller.loadMoreTransactions();
              }
            }
            return true;
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            height: doubleHeight * (245 / 800),
            child: Obx(
              () {
                if (controller.listResultTK.isEmpty) {
                  return Center(
                    child: Text(
                      'Chưa có giao dịch'.tr,
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.listResultTK.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == controller.listResultTK.length) {
                        return Obx(() => controller.isLoadingMore.value
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox());
                      }
                      final transaction = controller.listResultTK[index];
                      CategoryModel? category = controller
                          .categoryIdToDetails[transaction.categoryId];
                      String formatDate =
                          DateFormat('dd/MM/yyyy').format(transaction.date);
                      return Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).focusColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Text(
                                      formatDate,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      IconData(
                                        category?.iconCode ??
                                            Icons.category.codePoint,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                      color: Color(
                                        category?.colorIcon ??
                                            Colors.grey.value,
                                      ),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      (category?.name ?? 'Không có danh mục')
                                          .tr,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    const SizedBox(width: 10),
                                    Obx(
                                      () => Text(
                                        transaction.type == 'Thu Nhập'
                                            ? '+${formatBalance(transaction.amount)}'
                                            : '-${formatBalance(transaction.amount)}',
                                        // soTienGD,
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: transaction.type == 'Thu Nhập'
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Số dư cuối : '.tr,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    Obx(
                                      () => Text(
                                        formatBalance(transaction.finalBalance),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: RichText(
                                        text: TextSpan(
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                          children: [
                                            TextSpan(
                                              text: 'Nội dung : '.tr,
                                            ),
                                            TextSpan(
                                              text: transaction.description,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      );
                    });
              },
            ),
          ),
        );
      }
    });
  }

  SizedBox buildTextFieldSearch(double doubleWidth, BuildContext context) {
    return SizedBox(
      width: doubleWidth * (324 / 360),
      child: TextFormField(
        controller: timKiemController,
        validator: controller.dateValidator,
        focusNode: dayFocus,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            hintText: 'Nhập ngày'.tr,
            hintStyle: TextStyle(color: Theme.of(context).hintColor),
            prefixIcon: IconButton(
                onPressed: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    locale: Get.locale,
                  );
                  if (selectedDate != null) {
                    timKiemController.text =
                        DateFormat('dd/MM/yyyy').format(selectedDate);
                  }
                },
                icon: const Icon(Icons.calendar_month)),
            suffixIcon: IconButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    String enteredDate = timKiemController.text;
                    if (enteredDate.isNotEmpty) {
                      /// Chuyển đổi chuỗi ngày thành DateTime để tk
                      List<String> dateParts = enteredDate.split('/');
                      if (dateParts.length == 3) {
                        DateTime? selectedDate = DateTime(
                          int.parse(dateParts[2]),
                          int.parse(dateParts[1]),
                          int.parse(dateParts[0]),
                        );
                        controller.searchTransaction(selectedDate);
                      }
                    } else {
                      controller.searchTransaction(null);
                    }
                  }
                },
                icon: const Icon(Icons.search)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Padding buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title.tr,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}

class ChartData {
  final String x;
  final double y;
  final Color color;

  ChartData(this.x, this.y, this.color);
}
