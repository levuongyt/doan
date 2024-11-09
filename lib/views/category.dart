import 'package:doan_ql_thu_chi/views/add_category.dart';
import 'package:doan_ql_thu_chi/views/add_transactions.dart';
import 'package:doan_ql_thu_chi/views/home.dart';
import 'package:doan_ql_thu_chi/views/update_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/transaction_controller.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final TransactionController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
         // automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Thêm danh mục'.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
          // leading: IconButton(onPressed: (){
          //   Get.to(Home());
          // }, icon: Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(AddCategory());
                },
                icon: Icon(Icons.add))
          ],
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Adjust the height as needed
            child: Container(
              color: Theme.of(context).cardColor, // Background color for unselected tabs
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
                      color: Theme.of(context).indicatorColor, // Background color for the selected tab
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
                  SizedBox(height: 10),
                  Obx(
                    () => Container(
                      //  height: doubleHeight*(260/800),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.listIncomeCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category =
                                controller.listIncomeCategory[index];
                            return InkWell(
                                onTap: () {
                                  //controller.selectIncomeCategory(category.id ?? "");
                                  // print(
                                  //     'id la :${controller.selectedCategory.value}');
                                  // print('a');
                                  // idDanhMuc = '${category.id}';
                                  // print(idDanhMuc);
                                  Get.to(UpdateCategory(
                                      id: category.id ?? "",
                                      name: category.name,
                                      iconDM: category.iconCode,
                                      colorDM: category.colorIcon,
                                      type: category.type,
                                  ));
                                },
                                child: Column(
                                    children: [
                                      Container(
                                        //width: doubleWidth * (85 / 360),
                                        // height: doubleHeight * (62 / 800),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey,
                                                // color: controller
                                                //             .selectedIncomeCategory
                                                //             .value ==
                                                //         category.id
                                                //     ? Colors.blueAccent
                                                //     : Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                IconData(
                                                    category.iconCode ??
                                                        Icons
                                                            .category.codePoint,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Color(category
                                                        .colorIcon ??
                                                    Colors.blueAccent.value),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child:
                                                  Text('${category.name}'.tr),
                                            ),
                                            Icon(Icons.dehaze)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                            );
                          }),
                    ),
                  ),
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
                  Obx(
                    () => Container(
                      //  height: doubleHeight*(260/800),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listExpenseCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category =
                                controller.listExpenseCategory[index];
                            return InkWell(
                                onTap: () {
                                 // controller.selectExpenseCategory(category.id ?? "");
                                  // print(
                                  //     'id la :${controller.selectedCategory.value}');
                                  // print('a');
                                  // idDanhMuc = '${category.id}';
                                  // print(idDanhMuc);
                                  Get.to(UpdateCategory(
                                      id: category.id ?? '',
                                      name: category.name,
                                      iconDM: category.iconCode,
                                      colorDM: category.colorIcon,
                                      type: category.type,
                                  ));
                                },
                                child: Column(
                                    children: [
                                      Container(
                                        //width: doubleWidth * (85 / 360),
                                        // height: doubleHeight * (62 / 800),
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                // color: controller
                                                //             .selectedExpenseCategory
                                                //             .value ==
                                                //         category.id
                                                //     ? Colors.blueAccent
                                                //     : Colors.grey,
                                              color: Colors.grey,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                IconData(
                                                    category.iconCode ??
                                                        Icons
                                                            .category.codePoint,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Color(category
                                                        .colorIcon ??
                                                    Colors.blueAccent.value),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child:
                                                  Text('${category.name}'.tr),
                                            ),
                                            Icon(Icons.dehaze)
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      )
                                    ],
                                  ),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ])),
      ),
    );
  }
}
