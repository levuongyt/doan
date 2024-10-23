import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'chi_tiet_chi_tieu.dart';
import 'chi_tiet_thu_nhap.dart';

class BaoCao extends StatefulWidget {
  const BaoCao({super.key});

  @override
  State<BaoCao> createState() => _BaoCaoState();
}

class _BaoCaoState extends State<BaoCao> {
  final ReportController reportController = Get.put(ReportController());
  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'BÁO CÁO',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(150.0),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          onPressed: () async {
                            // await reportController.fetchReport();
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
                                  initialDatePickerMode: DatePickerMode.year);
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
                                  TextStyle(color: Colors.white, fontSize: 17),
                            )),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 40,
                          ))
                    ],
                  ),
                  Container(
                    color: Colors.white,
                    height: 50,
                  ),
                  Container(
                    color: Colors.grey,
                    child: TabBar(
                      tabs: <Widget>[
                        Tab(
                          text: 'Thu nhập',
                        ),
                        Tab(
                          text: 'Chi tiêu',
                        ),
                      ],
                      labelColor:
                          Colors.white,
                      unselectedLabelColor:
                          Colors.black,
                      indicator: BoxDecoration(
                        color: Colors
                            .blue,
                        borderRadius: BorderRadius.circular(
                            5),
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
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: doubleHeight * (250 / 800),
                      width: doubleWidth * (250 / 360),
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng thu nhập: '),
                        Obx(
                          () => Text(
                              '${reportController.report.value?.totalIncome ?? 0}'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trung bình thu/ngày'),
                        Obx(
                          () => Text(
                              '${reportController.report.value?.totalIncomeDay ?? 0}'),
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
                      children: [Text('Chi tiết')],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: 70,
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.phone),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Điện thoại'),
                                  Text('27/8/2024')
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('900000'), Text('100%')],
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(ChiTietThuNhap());
                                  },
                                  icon: Icon(Icons.navigate_next))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),

              ///TAB 2
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      height: doubleHeight * (250 / 800),
                      width: doubleWidth * (250 / 360),
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tổng chi tiêu: '),
                        Obx(
                          () => Text(
                              '${reportController.report.value?.totalExpense ?? 0}'),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Trung bình chi/ngày'),
                        Obx(
                          () => Text(
                              '${reportController.report.value?.totalExpenseDay ?? 0}'),
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
                      children: [Text('Chi tiết')],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: 70,
                          color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.phone),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Điện thoại'),
                                  Text('27/8/2024')
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('900000'), Text('100%')],
                              ),
                              IconButton(
                                  onPressed: () {
                                    Get.to(ChiTietChiTieu());
                                  },
                                  icon: Icon(Icons.navigate_next))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
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
