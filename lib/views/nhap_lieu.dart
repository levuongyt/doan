import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../controllers/transaction_controller.dart';
import 'category.dart';


class NhapLieu extends StatefulWidget {
  const NhapLieu({super.key});

  @override
  State<NhapLieu> createState() => _NhapLieuState();
}

class _NhapLieuState extends State<NhapLieu> {
  final TransactionController controller = Get.put(TransactionController());

  final TextEditingController ngayController = TextEditingController();
  final TextEditingController noiDungController = TextEditingController();
  final TextEditingController tienController = TextEditingController();

  final TextEditingController ngayChiController = TextEditingController();
  final TextEditingController noiDungChiController = TextEditingController();
  final TextEditingController tienChiController = TextEditingController();

  DateTime? pickedDate = DateTime.now();
  String idDanhMuc = '';
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text(
            'Nhập Liệu',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Adjust the height as needed
            child: Container(
              color: Colors.grey[300], // Background color for unselected tabs
              child: Column(
                children: [
                  Container(height: 10,color: Colors.white,),
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        text: 'Thu nhập',
                      ),
                      Tab(
                        text: 'Chi tiêu',
                      ),
                    ],
                    labelColor: Colors.white,
                    unselectedLabelColor:
                    Colors.blue,
                    indicator: BoxDecoration(
                      color: Colors.blue, // Background color for the selected tab
                      borderRadius: BorderRadius.circular(
                          5), // Rounded corners for the selected tab
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
                          Expanded(flex: 1, child: Text('Ngày')),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: ngayController,
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

                                if (newDate != null) {
                                  pickedDate = newDate;
                                  ngayController.text = DateFormat('dd/MM/yyyy')
                                      .format(pickedDate ?? DateTime.now());
                                }
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
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
                          Expanded(flex: 1, child: Text('Nội dung')),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: noiDungController,
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
                          Expanded(flex: 1, child: Text('Số tiền')),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              width: doubleWidth * (177 / 360),
                              child: TextFormField(
                                controller: tienController,
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
                          Text('VND'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Danh mục'),
                            TextButton(
                                onPressed: () {
                                  Get.to(Category());
                                },
                                child: Text('Thêm danh mục'))
                          ]),
                      SizedBox(height: 10),
                      Obx(
                            () => Container(
                          height: doubleHeight*(260/800),
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: controller.listIncomeCategory.length,
                              gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 15,
                                  crossAxisCount: 4),
                              itemBuilder: (BuildContext context, int index) {
                                final category =
                                controller.listIncomeCategory[index];
                                return InkWell(
                                    onTap: () {
                                      controller.selectCategory(category.id ?? "");
                                      print(
                                          'id la :${controller.selectedCategory.value}');
                                      print('a');
                                      idDanhMuc = '${category.id}';
                                      // print(idDanhMuc);
                                    },
                                    child: Obx(
                                          () => Container(
                                        width: doubleWidth * (85 / 360),
                                        height: doubleHeight * (62 / 800),
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: controller.selectedCategory
                                                    .value ==
                                                    category.id
                                                    ? Colors.blueAccent
                                                    : Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              IconData(
                                                  category.iconCode ??
                                                      Icons.category.codePoint,
                                                  fontFamily: 'MaterialIcons'),
                                              color: Color(category.colorIcon ??
                                                  Colors.blueAccent.value),
                                            ),
                                            Text('${category.name}')
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: doubleHeight * (50 / 800),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                            onPressed: () async {
                              await controller.addTransaction(
                                  amount: double.parse(tienController.text),
                                  description: noiDungController.text,
                                  categoryId: idDanhMuc,
                                  type: 'Thu Nhập',
                                  date: pickedDate ?? DateTime.now());
                              await controller.saveMonthlyReport(pickedDate ??DateTime.now());
                            },
                            child: Text(
                              'Lưu thu nhập',
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
                          Expanded(flex: 1, child: Text('Ngày')),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
                          Expanded(
                            flex: 4,
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
                                  ngayChiController.text = DateFormat('dd/MM/yyyy')
                                      .format(pickedDate ?? DateTime.now());
                                }
                              },
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
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
                          Expanded(flex: 1, child: Text('Nội dung')),
                          Expanded(
                            flex: 4,
                            child: TextFormField(
                              controller: noiDungChiController,
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
                          Expanded(flex: 1, child: Text('Số tiền')),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              width: doubleWidth * (177 / 360),
                              child: TextFormField(
                                controller: tienChiController,
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
                          Text('VND'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Danh mục'),
                            TextButton(
                                onPressed: () {
                                  Get.to(Category());
                                },
                                child: Text('Thêm danh mục'))
                          ]),
                      SizedBox(height: 10),
                      Obx(
                            () => Container(
                          height: doubleHeight*(260/800),
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
                                return InkWell(
                                    onTap: () {
                                      controller.selectCategory(category.id ?? "");
                                      print(
                                          'id la :${controller.selectedCategory.value}');
                                      print('a');
                                      idDanhMuc = '${category.id}';
                                      // print(idDanhMuc);
                                    },
                                    child: Obx(
                                          () => Container(
                                        width: doubleWidth * (85 / 360),
                                        height: doubleHeight * (62 / 800),
                                        padding: EdgeInsets.all(7),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: controller.selectedCategory
                                                    .value ==
                                                    category.id
                                                    ? Colors.blueAccent
                                                    : Colors.grey),
                                            borderRadius:
                                            BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              IconData(
                                                  category.iconCode ??
                                                      Icons.category.codePoint,
                                                  fontFamily: 'MaterialIcons'),
                                              color: Color(category.colorIcon ??
                                                  Colors.blueAccent.value),
                                            ),
                                            Text('${category.name}')
                                          ],
                                        ),
                                      ),
                                    ));
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: doubleHeight * (50 / 800),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent),
                            onPressed: () async {
                              await controller.addTransaction(
                                  amount: double.parse(tienChiController.text),
                                  description: noiDungChiController.text,
                                  categoryId: idDanhMuc,
                                  type: 'Chi Tiêu',
                                  date: pickedDate ?? DateTime.now());
                              await controller.saveMonthlyReport(pickedDate ??DateTime.now());
                            },
                            child: Text(
                              'Lưu Chi Tiêu',
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ])),
      ),
    );
  }
}
