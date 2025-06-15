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
  void initState() {
    super.initState();
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
          elevation: 2,
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
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          // Chart section with loading state
          Obx(() => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: doubleHeight * (180 / 800),
              width: doubleWidth * (250 / 360),
              child: PieChart(
                  swapAnimationDuration:
                  const Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear,
                  PieChartData(
                      sections:
                      reportController.getSectionsChiTieu())),
            ),
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng chi tiêu:'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Obx(
                      () => Text(
                        formatBalance(reportController.report.value?.totalExpense ?? 0),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[600],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trung bình chi/ngày:'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Obx(
                      () => Text(
                        formatBalance(reportController.report.value?.totalExpenseDay ?? 0),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[500],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red[100]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assessment_outlined,
                  color: Colors.red[600],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chi tiết'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Container(
            height: 280,
            padding: const EdgeInsets.only(bottom: 80), // Padding để tránh navbar che
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
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.grey[200]!, width: 1),
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
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
                    const SizedBox(height: 4),
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
        padding: const EdgeInsets.all(8),
        child: Column(children: [
          // Chart section
          Obx(() => Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              height: doubleHeight * (180 / 800),
              width: doubleWidth * (250 / 360),
              child: PieChart(
                  swapAnimationDuration:
                  const Duration(milliseconds: 150), // Optional
                  swapAnimationCurve: Curves.linear,
                  PieChartData(
                      sections:
                      reportController.getSectionsThuNhap())),
            ),
          )),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng thu nhập:'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Obx(
                      () => Text(
                        formatBalance(reportController.report.value?.totalIncome ?? 0),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Trung bình thu/ngày:'.tr,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    Obx(
                      () => Text(
                        formatBalance(reportController.report.value?.totalIncomeDay ?? 0),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[500],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[100]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.assessment_outlined,
                  color: Colors.green[600],
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chi tiết'.tr,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Container(
            height: 280,
            padding: const EdgeInsets.only(bottom: 80), // Padding để tránh navbar che
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
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                        border: Border.all(color: Colors.grey[200]!, width: 1),
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
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[600],
                                  ),
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
                    const SizedBox(height: 4),
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
