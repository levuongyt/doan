import 'package:doan_ql_thu_chi/config/images/image_app.dart';
import 'package:doan_ql_thu_chi/config/themes/themes_app.dart';
import 'package:doan_ql_thu_chi/controllers/setting_controller.dart';
import 'package:doan_ql_thu_chi/views/setting.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/home_controller.dart';
import '../controllers/navigation_controller.dart';
import 'account.dart';
import 'report.dart';
import 'add_transactions.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NavigationController navigationController =
      Get.put(NavigationController());

  final List<Widget> pages = [
    HomePage(),
    NhapLieu(),
    BaoCao(),
    Setting(),
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
                  icon: Icon(Icons.home), label: 'Tổng quan'.tr),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit_note),
                label: 'Nhập vào'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Báo cáo'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Cài đặt'.tr,
              ),
            ],
            currentIndex: navigationController.selectedIndex.value,
            onTap: (index) => navigationController.changeIndex(index),
            type: BottomNavigationBarType.fixed,
            //  backgroundColor: Colors.grey[300],
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ever(controller.isLoading, (callback) {
      if (callback) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  String formatBalance(double amount) {
    return controller.donViTienTe.value == 'đ'
        ? '${NumberFormat('#,##0').format(controller.convertAmount(amount))} ${controller.donViTienTe.value}'
        : '${NumberFormat('#,##0.00').format(controller.convertAmount(amount))} ${controller.donViTienTe.value}';
  }

  @override
  Widget build(BuildContext context) {
    final double doubleHeight = MediaQuery.of(context).size.height;
    final double doubleWidth = MediaQuery.of(context).size.width;

    return Form(
      key: formKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text(
                'Chào mừng '.tr,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                controller.userModel.value?.name ?? " ",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(Account());
                },
                icon: Icon(Icons.account_circle))
          ],
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    // String formatBalance = controller.donViTienTe.value == 'đ'
                    //     ? '${NumberFormat('#,##0').format(controller.convertAmount(controller.userModel.value?.tongSoDu ?? 0))} ${controller.donViTienTe.value}'
                    //     : '${NumberFormat('#,##0.00').format(controller.convertAmount(controller.userModel.value?.tongSoDu ?? 0))} ${controller.donViTienTe.value}';

                    return Container(
                      padding: EdgeInsets.all(10),
                      width: doubleWidth * (324 / 360),
                      height: doubleHeight * (82 / 800),
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text('Thiết lập tổng số dư'.tr),
                                  content: TextFormField(
                                    controller: totalBalanceController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        hintText: 'Nhập số dư'.tr,
                                        hintStyle: TextStyle(
                                          color: Theme.of(context).hintColor,
                                        )),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text('Hủy'.tr)),
                                    TextButton(
                                        onPressed: () async {
                                          Get.back();
                                          await controller.updateTotalBalance(
                                              double.parse(
                                                  totalBalanceController.text));
                                        },
                                        child: Text('Lưu'.tr)),
                                  ],
                                ),
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
                                    Icon(
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
                                        //'${NumberFormat('#,##0').format(controller.userModel.value?.tongSoDu ?? 0)} ${controller.donViTienTe.value}',
                                        // controller.donViTienTe.value == 'VND'
                                        //     ? '${NumberFormat('#,##0').format(controller.convertAmount(controller.userModel.value?.tongSoDu ?? 0))} ${controller.donViTienTe.value}'
                                        //     : '${NumberFormat('#,##0.00').format(controller.convertAmount(controller.userModel.value?.tongSoDu ?? 0))} ${controller.donViTienTe.value}',

                                        // style: Theme.of(context).textTheme.titleLarge,
                                        style: TextStyle(
                                          //color: Colors.blueAccent,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
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
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng quan thu chi'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Container(
                    width: doubleWidth * (324 / 360),
                    height: doubleHeight * (230 / 800),
                    decoration: BoxDecoration(
                      color: Theme.of(context).focusColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
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
                                  icon: Icon(
                                    Icons.navigate_before,
                                    color: Colors.grey,
                                    size: 30,
                                  )),
                              TextButton(
                                onPressed: () async {
                                  DateTime? chonNgay =
                                      await showMonthYearPicker(
                                    context: context,
                                    initialDate: controller.selectedMonth.value,
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2100),
                                    locale: Get.locale,
                                  );
                                  // DateTime? chonNgay = await showDatePicker(
                                  //     context: context,
                                  //     initialDate: controller.selectedMonth.value,
                                  //     firstDate: DateTime(2019),
                                  //     lastDate: DateTime(2100),
                                  //     initialDatePickerMode: DatePickerMode.year,
                                  //);
                                  if (chonNgay != null) {
                                    controller.updateSelectedMonth(
                                      DateTime(
                                          chonNgay.year, chonNgay.month, 1),
                                    );
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    DateFormat('MM/yyyy')
                                        .format(controller.selectedMonth.value),
                                    style: TextStyle(
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
                                  icon: Icon(
                                    Icons.navigate_next,
                                    color: Colors.grey,
                                    size: 30,
                                  ))
                            ],
                          ),
                          // SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(
                                () => Container(
                                    height: 150,
                                    width: 190,
                                    decoration: BoxDecoration(
                                      color: Colors.blueAccent.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SfCartesianChart(
                                      primaryXAxis: CategoryAxis(
                                        labelStyle: TextStyle(fontSize: 13),
                                      ),
                                      primaryYAxis: NumericAxis(
                                        isVisible: false,
                                      ),
                                      series: [
                                        ColumnSeries<ChartData, String>(
                                          dataSource: [
                                            ChartData(
                                                'Thu'.tr,
                                                controller.convertAmount(
                                                    controller.report.value
                                                            ?.totalIncome ??
                                                        0),
                                                Colors.green),
                                            ChartData(
                                                'Chi'.tr,
                                                controller.convertAmount(
                                                    controller.report.value
                                                            ?.totalExpense ??
                                                        0),
                                                Colors.red),
                                          ],
                                          xValueMapper: (ChartData data, _) =>
                                              data.x,
                                          yValueMapper: (ChartData data, _) =>
                                              data.y,
                                          pointColorMapper:
                                              (ChartData data, _) => data.color,
                                          //  width: 1,
                                        ),
                                      ],
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                    )),
                              ),
                              // Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Row(
                              //       children: [
                              //         Container(
                              //           height: doubleHeight * (10 / 800),
                              //           width: doubleWidth * (10 / 360),
                              //           decoration: BoxDecoration(
                              //             color: Colors.green,
                              //             shape: BoxShape.circle,
                              //           ),
                              //         ),
                              //         SizedBox(width: 5),
                              //         Text(
                              //           'Thu'.tr,
                              //           style:
                              //               Theme.of(context).textTheme.bodySmall,
                              //         ),
                              //       ],
                              //     ),
                              //     // SizedBox(height: 10),
                              //     Row(
                              //       children: [
                              //         Container(
                              //           height: doubleHeight * (10 / 800),
                              //           width: doubleWidth * (10 / 360),
                              //           decoration: BoxDecoration(
                              //             color: Colors.red,
                              //             shape: BoxShape.circle,
                              //           ),
                              //         ),
                              //         SizedBox(width: 5),
                              //         Text(
                              //           'Chi'.tr,
                              //           style:
                              //               Theme.of(context).textTheme.bodySmall,
                              //         ),
                              //       ],
                              //     ),
                              //     SizedBox(
                              //       height: 45,
                              //     )
                              //   ],
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Obx(
                                    () => Text(
                                      formatBalance(controller
                                              .report.value?.totalIncome ??
                                          0),
                                      //'${NumberFormat('#,##0').format(controller.report.value?.totalIncome ?? 0)} ${controller.donViTienTe.value}',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      formatBalance(controller
                                              .report.value?.totalExpense ??
                                          0),
                                      // '${NumberFormat('#,##0').format(controller.report.value?.totalExpense ?? 0)} ${controller.donViTienTe.value}',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 2,
                                    width: doubleWidth * (100 / 360),
                                    color: Colors.black,
                                  ),
                                  SizedBox(height: 10),
                                  Obx(
                                    () => Text(
                                      formatBalance(
                                          controller.report.value?.soDuThang ??
                                              0),
                                      // '${NumberFormat('#,##0').format(controller.report.value?.soDuThang ?? 0)} ${controller.donViTienTe.value}',
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
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
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Giao dịch gần đây'.tr,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),

                      ///  Icon(Icons.local_gas_station_outlined,color: Color(4282682111),),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: doubleWidth * (324 / 360),
                  child: TextFormField(
                    controller: timKiemController,
                    validator: controller.dateValidator,
                    decoration: InputDecoration(
                        hintText: 'Nhập ngày'.tr,
                        hintStyle:
                            TextStyle(color: Theme.of(context).hintColor),
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
                                    DateFormat('dd/MM/yyyy')
                                        .format(selectedDate);
                                // timKiemController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                              }
                            },
                            icon: Icon(Icons.calendar_month)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                String enteredDate = timKiemController.text;
                                if (enteredDate.isNotEmpty) {
                                  /// Chuyển đổi chuỗi ngày thành DateTime để tk
                                  List<String> dateParts =
                                      enteredDate.split('/');
                                  if (dateParts.length == 3) {
                                    DateTime? selectedDate = DateTime(
                                      int.parse(dateParts[2]),
                                      int.parse(dateParts[1]),
                                      int.parse(dateParts[0]),
                                    );
                                    controller.searchTransaction(selectedDate);
                                  }
                                  // else {
                                  //   Get.snackbar('Lỗi',
                                  //       'Vui lòng nhập đúng định dạng ngày.');
                                  // }
                                } else {
                                  controller.searchTransaction(null);
                                }
                              }
                            },
                            icon: Icon(Icons.search)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll.metrics.pixels ==
                            scroll.metrics.maxScrollExtent) {
                          if (scroll is ScrollEndNotification) {
                            print(
                                'Reached end of list. Attempting to load more...');
                            controller.loadMoreTransactions();
                          }
                        }
                        return true;
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        height: doubleHeight * (215 / 800),
                        child: Obx(
                          () {
                            if (controller.listResultTK.isEmpty) {
                              return Center(
                                child: Text(
                                  'Chưa có giao dịch'.tr,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.listResultTK.length+1,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == controller.listResultTK.length) {
                                  // Hiển thị loading ở cuối danh sách khi đang tải thêm dữ liệu
                                  return Obx(() => controller.isLoadingMore.value
                                      ? const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                                      : const SizedBox());
                                }
                                  final transaction =
                                  controller.listResultTK[index];
                                  // String soTienGD = transaction.type == 'Thu Nhập'
                                  //     ? '+${formatBalance(transaction.amount)}'
                                  //     : '-${formatBalance(transaction.amount)}';
                                  String formatDate = DateFormat('dd/MM/yyyy')
                                      .format(transaction.date);
                                  return Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Theme
                                              .of(context)
                                              .focusColor,
                                          borderRadius: BorderRadius.circular(
                                              15),
                                        ),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Text(
                                                  '${formatDate}',
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  IconData(
                                                    controller
                                                        .categoryIdToDetails[
                                                    transaction
                                                        .categoryId]
                                                    ?['iconCode'] ??
                                                        Icons.category
                                                            .codePoint,
                                                    fontFamily: 'MaterialIcons',
                                                  ),
                                                  color: Color(
                                                    controller
                                                        .categoryIdToDetails[
                                                    transaction
                                                        .categoryId]
                                                    ?['colorIcon'] ??
                                                        Colors.grey.value,
                                                  ),
                                                  size: 24,
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  "${controller
                                                      .categoryIdToDetails[transaction
                                                      .categoryId]?['name'] ??
                                                      'Không có danh mục'}"
                                                      .tr,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                SizedBox(width: 10),
                                                Obx(
                                                      () =>
                                                      Text(
                                                        transaction.type ==
                                                            'Thu Nhập'
                                                            ? '+${formatBalance(
                                                            transaction
                                                                .amount)}'
                                                            : '-${formatBalance(
                                                            transaction
                                                                .amount)}',
                                                        // soTienGD,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          fontWeight: FontWeight
                                                              .bold,
                                                          color: transaction
                                                              .type ==
                                                              'Thu Nhập'
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
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Obx(
                                                      () =>
                                                      Text(
                                                        formatBalance(
                                                            transaction
                                                                .finalBalance),
                                                        // '${NumberFormat('#,##0').format(transaction.finalBalance)} ${controller.donViTienTe.value}',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodySmall,
                                                      ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Nội dung : '.tr,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    transaction.description,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      // Obx(() => controller.isLoadingMore.value == true
                                      //     ? const CircularProgressIndicator()
                                      //     : const SizedBox()
                                      // )
                                    ],
                                  );
                                }
                            );

                          },
                        ),
                      ),
                    );
                  }
                }),
              ],
            ),
          ),
        ),
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
