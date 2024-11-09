import 'package:doan_ql_thu_chi/Models/report_model.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'details_report.dart';

class BaoCao extends StatefulWidget {
  const BaoCao({super.key});

  @override
  State<BaoCao> createState() => _BaoCaoState();
}

class _BaoCaoState extends State<BaoCao> {
  final ReportController reportController = Get.find();

  String formatBalance(double amount ) {
    return reportController.donViTienTe.value == 'đ'
        ? '${NumberFormat('#,##0').format(reportController.convertAmount(amount))} ${reportController.donViTienTe.value}'
        : '${NumberFormat('#,##0.00').format(reportController.convertAmount(amount))} ${reportController.donViTienTe.value}';
  }
  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'BÁO CÁO'.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: (){
                            DateTime backMonth = DateTime(
                              reportController.selectedMonth.value.year,
                              reportController.selectedMonth.value.month - 1,
                            );
                            reportController.updateSelectedMonth(backMonth);
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                      Obx(
                        () => TextButton(
                            onPressed: () async {
                              DateTime? chonNgay = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      reportController.selectedMonth.value,
                                  firstDate: DateTime(2019),
                                  lastDate: DateTime(2100),
                                  initialDatePickerMode: DatePickerMode.year,
                                locale: Get.locale,
                              );
                              if (chonNgay != null) {
                                reportController.updateSelectedMonth(
                                  DateTime(chonNgay.year, chonNgay.month, 1),
                                );
                              }
                            },
                            child: Text(
                              DateFormat('MM/yyyy')
                                  .format(reportController.selectedMonth.value),
                              style:
                                  Theme.of(context).textTheme.displayLarge,
                            )),
                      ),
                      IconButton(
                          onPressed: () {
                            DateTime nextMonth = DateTime(
                              reportController.selectedMonth.value.year,
                              reportController.selectedMonth.value.month + 1,
                            );
                            reportController.updateSelectedMonth(nextMonth);
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ))
                    ],
                  ),
                  Container(
                    color: Theme.of(context).dividerColor,
                    height: 10,
                  ),
                  Container(
                    color: Theme.of(context).cardColor,
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
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              ///TAB 1
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Obx(
                      () => Container(
                        height: doubleHeight * (200 / 800),
                        width: doubleWidth * (250 / 360),
                        //color: Colors.grey,
                        child: PieChart(
                            swapAnimationDuration:
                                Duration(milliseconds: 150), // Optional
                            swapAnimationCurve: Curves.linear,
                            PieChartData(
                                sections:
                                    reportController.getSectionsThuNhap())),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng thu nhập :'.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => Text(
                            formatBalance(reportController.report.value?.totalIncome ?? 0),
                             // '${NumberFormat('#,##0').format(reportController.report.value?.totalIncome ?? 0)} ${reportController.donViTienTe.value}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trung bình thu/ngày:'.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => Text(
                            formatBalance(reportController.report.value?.totalIncomeDay ?? 0),
                            //  '${NumberFormat('#,##0').format(reportController.report.value?.totalIncomeDay ?? 0)} ${reportController.donViTienTe.value}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Chi tiết'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Container(
                     
                      height: 230,
                      child: reportController.report.value?.categories?.values
                          .where((category) => category.type == 'Thu Nhập')
                          .isEmpty ??
                          true
                          ? Center(
                        child: Text(
                          'Chưa có giao dịch'.tr,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                          : ListView.builder(
                        itemCount: reportController
                            .report.value?.categories?.values
                            .where((category) => category.type == 'Thu Nhập')
                            .length ??
                            0,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          // print(
                          //     'length là : ${reportController.report.value?.categories?.values.where((category) => category.type == 'Thu Nhập').length ?? 0}');
                          CategoryReportModel? category = reportController
                              .report.value?.categories?.values
                              .where((category) => category.type == 'Thu Nhập')
                              .elementAt(index);
                          if (category == null) {
                            return Container();
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.5),
                                  //     spreadRadius: 5,
                                  //     blurRadius: 7,
                                  //     offset: Offset(0, 3),
                                  //   )
                                  // ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      IconData(category.iconCode,
                                          fontFamily: 'MaterialIcons'),
                                      color: Color(category.color),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          category.name.tr,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Obx(()=>
                                          Text(
                                            formatBalance(category.totalAmount),
                                           //'${NumberFormat('#,##0').format(category.totalAmount)} ${reportController.donViTienTe.value}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ),
                                        Text(
                                          '${category.percentage.toStringAsFixed(1)}%',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        )
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.to(ChiTietThuNhap(
                                          categoryId: category.id,
                                          categoryName: category.name,
                                          iconCode: category.iconCode,
                                          colorIcon: category.color,
                                        ));
                                      },
                                      icon: Icon(Icons.navigate_next),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        },
                      ),
                    )),

                  ]),
                ),
              ),

              ///TAB 2
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(children: [
                    Obx(
                      () => Container(
                        height: doubleHeight * (200 / 800),
                        width: doubleWidth * (250 / 360),
                        //color: Colors.grey,
                        child: PieChart(
                            swapAnimationDuration:
                                Duration(milliseconds: 150), // Optional
                            swapAnimationCurve: Curves.linear,
                            PieChartData(
                                sections:
                                    reportController.getSectionsChiTieu())),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng chi tiêu :'.tr,
                          style: Theme.of(context).textTheme.bodySmall,),
                        Obx(
                          () => Text(
                            formatBalance(reportController.report.value?.totalExpense ?? 0),
                             // '${NumberFormat('#,##0').format(reportController.report.value?.totalExpense ?? 0)} ${reportController.donViTienTe.value}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trung bình chi/ngày:'.tr,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Obx(
                          () => Text(
                            formatBalance(reportController.report.value?.totalExpenseDay ?? 0),
                            //  '${NumberFormat('#,##0').format(reportController.report.value?.totalExpenseDay ?? 0)} ${reportController.donViTienTe.value}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          'Chi tiết'.tr,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(() => Container(
                      height: 230,
                      child: reportController.report.value?.categories?.values
                          .where((category) => category.type == 'Chi Tiêu')
                          .isEmpty ??
                          true
                          ? Center(
                        child: Text(
                          'Chưa có giao dịch'.tr,
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                          : ListView.builder(
                        itemCount: reportController
                            .report.value?.categories?.values
                            .where((category) => category.type == 'Chi Tiêu')
                            .length ??
                            0,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          print(
                              'length là : ${reportController.report.value?.categories?.values.where((category) => category.type == 'Chi Tiêu').length ?? 0}');
                          CategoryReportModel? category = reportController
                              .report.value?.categories?.values
                              .where((category) => category.type == 'Chi Tiêu')
                              .elementAt(index);
                          if (category == null) {
                            return Container();
                          }
                          return Column(
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding:EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).focusColor,
                                  borderRadius: BorderRadius.circular(15),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.5),
                                  //     spreadRadius: 5,
                                  //     blurRadius: 7,
                                  //     offset: Offset(0, 3),
                                  //   )
                                  // ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      IconData(category.iconCode,
                                          fontFamily: 'MaterialIcons'),
                                      color: Color(category.color),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          category.name.tr,
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Obx(
                                          ()=> Text(
                                            formatBalance(category.totalAmount),
                                          //  '${NumberFormat('#,##0').format(category.totalAmount)} ${reportController.donViTienTe.value}',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                        ),
                                        Text(
                                          '${category.percentage.toStringAsFixed(1)}%',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        )
                                      ],
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.to(ChiTietThuNhap(
                                          categoryId: category.id,
                                          categoryName: category.name,
                                          iconCode: category.iconCode,
                                          colorIcon: category.color,
                                        ));
                                      },
                                      icon: Icon(Icons.navigate_next),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        },
                      ),
                    )),

                  ]),
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: <BottomNavigationBarItem>[
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Tổng quan',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.edit_note),
        //       label: 'Nhập vào',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.bar_chart),
        //       label: 'Báo cáo',
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.settings),
        //       label: 'Cài đặt',
        //     ),
        //   ],
        //currentIndex: _selectedIndex,
        //onTap: _onItemTapped,
        //  type: BottomNavigationBarType.fixed,
        //  backgroundColor: Colors.grey,
        // ),
      ),
    );
  }
}
