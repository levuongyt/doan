import 'package:doan_ql_thu_chi/models/report_model.dart';
import 'package:doan_ql_thu_chi/config/extensions/extension_currency.dart';
import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/widget_common/tabbar_content.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
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
        ? '${NumberFormat('#,##0').format(amount.toCurrency())} ${reportController.donViTienTe.value}'
        : '${NumberFormat('#,##0.##').format(amount.toCurrency())} ${reportController.donViTienTe.value}';
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
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0),
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
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        )),
                    Obx(
                          () => TextButton(
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
                                        initialDate: reportController.selectedMonth.value,
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
                        icon: const Icon(
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
                    child:
                    const TabBarContent(),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              buildTabInCome(doubleHeight, doubleWidth, context),
              buildTabExpense(doubleHeight, doubleWidth, context),
            ],
          ),
        ),
      ),
    );
  }

  SingleChildScrollView buildTabExpense(double doubleHeight, double doubleWidth, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Obx(
                () => SizedBox(
              height: doubleHeight * (200 / 800),
              width: doubleWidth * (250 / 360),
              child: PieChart(
                  swapAnimationDuration:
                  const Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear,
                  PieChartData(
                      sections:
                      reportController.getSectionsChiTieu())),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng chi tiêu:'.tr,
                style: Theme.of(context).textTheme.bodySmall,),
              Obx(
                    () => Text(
                  formatBalance(reportController.report.value?.totalExpense ?? 0),
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
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.grey,
          ),
          const SizedBox(
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
          const SizedBox(
            height: 10,
          ),
          Obx(() => SizedBox(
            height: 230,
            child: reportController.report.value?.categories?.values
                .where((category) => category.type == 'Chi Tiêu')
                .isEmpty ??
                true
                ? Center(
              child: Text(
                'Chưa có dữ liệu'.tr,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
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
                CategoryReportModel? category = reportController
                    .report.value?.categories?.values
                    .where((category) => category.type == 'Chi Tiêu')
                    .elementAt(index);
                if (category == null) {
                  return Container();
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding:const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Icon(
                              IconData(category.iconCode,
                                  fontFamily: 'MaterialIcons'),
                              color: Color(category.color),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Text(
                              category.name.tr,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(
                                      ()=> Text(
                                    formatBalance(category.totalAmount),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ),
                                Text(
                                  '${category.percentage.toStringAsFixed(1)}%',
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(DetailsReport(
                                categoryId: category.id,
                                categoryName: category.name,
                                iconCode: category.iconCode,
                                colorIcon: category.color,
                              ));
                            },
                            icon: const Icon(Icons.navigate_next),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                );
              },
            ),
          )),

        ]),
      ),
    );
  }

  SingleChildScrollView buildTabInCome(double doubleHeight, double doubleWidth, BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(children: [
          Obx(
                () => SizedBox(
              height: doubleHeight * (200 / 800),
              width: doubleWidth * (250 / 360),
              child: PieChart(
                  swapAnimationDuration:
                  const Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear,
                  PieChartData(
                      sections:
                      reportController.getSectionsThuNhap())),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng thu nhập:'.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Obx(
                    () => Text(
                  formatBalance(reportController.report.value?.totalIncome ?? 0),
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
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.grey,
          ),
          const SizedBox(
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
          const SizedBox(
            height: 10,
          ),
          Obx(() => SizedBox(

            height: 230,
            child: reportController.report.value?.categories?.values
                .where((category) => category.type == 'Thu Nhập')
                .isEmpty ??
                true
                ? Center(
              child: Text(
                'Chưa có dữ liệu'.tr,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
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
                CategoryReportModel? category = reportController
                    .report.value?.categories?.values
                    .where((category) => category.type == 'Thu Nhập')
                    .elementAt(index);
                if (category == null) {
                  return Container();
                }
                return Column(
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Icon(
                              IconData(category.iconCode,
                                  fontFamily: 'MaterialIcons'),
                              color: Color(category.color),
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Text(
                              category.name.tr,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          Expanded(
                            flex:2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Obx(()=>
                                    Text(
                                      formatBalance(category.totalAmount),
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                ),
                                Text(
                                  '${category.percentage.toStringAsFixed(1)}%',
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.to(DetailsReport(
                                categoryId: category.id,
                                categoryName: category.name,
                                iconCode: category.iconCode,
                                colorIcon: category.color,
                              ));
                            },
                            icon: const Icon(Icons.navigate_next),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                );
              },
            ),
          )),

        ]),
      ),
    );
  }
}
