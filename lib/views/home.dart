import 'package:doan_ql_thu_chi/views/setting.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../controllers/home_controller.dart';
import '../controllers/navigation_controller.dart';
import 'account.dart';
import 'bao_cao.dart';
import 'nhap_lieu.dart';

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
                  icon: Icon(Icons.home), label: 'Tổng quan'),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit_note),
                label: 'Nhập vào',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Báo cáo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Cài đặt',
              ),
            ],
            currentIndex: navigationController.selectedIndex.value,
            onTap: (index) => navigationController.changeIndex(index),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey[400],
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
  final HomeController controller = Get.put(HomeController());
  final TextEditingController timKiemController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double doubleHeight = MediaQuery.of(context).size.height;
    final double doubleWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Chào Vương',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
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
                Text(
                  'Số dư tài khoản',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                Obx(
                  () => Container(
                    padding: EdgeInsets.all(10),
                    width: doubleWidth * (324 / 360),
                    height: doubleHeight * (58 / 800),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        controller.isVisibility.value == false
                            ? Text(
                                '${controller.userModel.value?.tongSoDu ?? 0}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                '*******',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
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
                  ),
                ),
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
                      'Tổng quan thu chi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: doubleWidth * (324 / 360),
                height: doubleHeight * (230 / 800),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(()=>
                        TextButton(
                          onPressed: () async {
                            DateTime? chonNgay = await showDatePicker(
                                context: context,
                                initialDate: controller.selectedMonth.value,
                                firstDate: DateTime(2019),
                                lastDate: DateTime(2100),
                                initialDatePickerMode: DatePickerMode.year);
                            if (chonNgay != null) {
                              controller.updateSelectedMonth(
                                DateTime(chonNgay.year, chonNgay.month, 1),
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              DateFormat('MM/yyyy').format(controller.selectedMonth.value),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                             Obx(()=>
                                Container(
                                  height: 140,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                 child:SfCartesianChart(
                                   primaryXAxis: CategoryAxis(),
                                   primaryYAxis: NumericAxis(isVisible: false,),
                                   series:[
                                     ColumnSeries<ChartData,String>(
                                       dataSource: [
                                         ChartData('Thu', controller.report.value?.totalIncome ?? 0, Colors.green),
                                         ChartData('Chi', controller.report.value?.totalExpense ?? 0, Colors.red),
                                       ],
                                         xValueMapper: (ChartData data,_) => data.x,
                                         yValueMapper: (ChartData data,_) => data.y,
                                       pointColorMapper: (ChartData data, _)=> data.color,
                                     //  width: 1,
                                     ),

                                   ],
                                   tooltipBehavior: TooltipBehavior(enable: true),
                                 )
                                 // BarChart(BarChartData(
                                 //   maxY: 10,
                                 //   barGroups: [
                                 //     BarChartGroupData(x: 0,
                                 //     barRods:[
                                 //       BarChartRodData(toY: 3,color: Colors.red),
                                 //       BarChartRodData(toY: 6,color: Colors.green)
                                 //     ]
                                 //     )
                                 //   ]
                                 // ))

                                 // PieChart(PieChartData(
                                 //   sections: [
                                 //     PieChartSectionData(
                                 //       value: controller.report.value?.totalIncome,
                                 //       color: Colors.green
                                 //     ),
                                 //     PieChartSectionData(
                                 //         value: controller.report.value?.totalExpense,
                                 //         color: Colors.red
                                 //     )
                                 //   ]
                                 // )),
                                ),
                             ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: doubleHeight * (10 / 800),
                                    width: doubleWidth * (10 / 360),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Thu',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: doubleHeight * (10 / 800),
                                    width: doubleWidth * (10 / 360),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Chi',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Obx(()=>
                                  Text('${controller.report.value?.totalIncome ?? 0}',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Obx(()=>
                                 Text(
                                    '${controller.report.value?.totalExpense ?? 0}',
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
                                  width: doubleWidth * (90 / 360),
                                  color: Colors.black,
                                ),
                                SizedBox(height: 10),
                                 Obx(()=>
                                 Text(
                                      '${controller.report.value?.soDuThang ?? 0}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Giao dịch gần đây',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                  decoration: InputDecoration(
                      hintText: 'Nhập ngày',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: IconButton(
                          onPressed: () async {
                            DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100));
                            if (selectedDate != null) {
                              timKiemController.text =
                                  DateFormat('dd/MM/yyyy').format(selectedDate);
                              // timKiemController.text = "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                            }
                          },
                          icon: Icon(Icons.calendar_month)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            print(
                                '${Icons.local_gas_station_outlined.codePoint}');
                            print('${Colors.blue.value}');
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
                              } else {
                                Get.snackbar('Lỗi',
                                    'Vui lòng nhập đúng định dạng ngày.');
                              }
                            } else {
                              controller.searchTransaction(null);
                            }
                          },
                          icon: Icon(Icons.search)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                //width: double.maxFinite,
                height: doubleHeight * (250 / 800),
                child: Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.listResultTK.length,
                    itemBuilder: (BuildContext context, int index) {
                      final transaction = controller.listResultTK[index];
                      String soTienGD = transaction.type == 'Thu Nhập'
                          ? '+${transaction.amount} VND'
                          : '-${transaction.amount} VND';

                      String formatDate =
                          DateFormat('dd/MM/yyyy').format(transaction.date);
                      return Column(
                        children: [
                          Container(
                            width: doubleWidth * (324 / 360),
                            height: doubleHeight * (151 / 800),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${formatDate}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        IconData(
                                          controller.categoryIdToDetails[
                                                      transaction.categoryId]
                                                  ?['iconCode'] ??
                                              Icons.category.codePoint,
                                          fontFamily: 'MaterialIcons',
                                        ),
                                        color: Color(
                                            controller.categoryIdToDetails[
                                                        transaction.categoryId]
                                                    ?['colorIcon'] ??
                                                Colors.grey.value),
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          "${controller.categoryIdToDetails[transaction.categoryId]?['name'] ?? 'Không có danh mục'} ",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(width: 10),
                                      Text(soTienGD,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  transaction.type == 'Thu Nhập'
                                                      ? Colors.green
                                                      : Colors.red))
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Số dư cuối : ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text('${transaction.finalBalance}',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Nội dung : ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold)),
                                      Text(transaction.description,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ])),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
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