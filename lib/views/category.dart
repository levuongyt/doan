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
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Thêm danh mục'.tr,
            style: Theme.of(context).textTheme.displayLarge,
          ),
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
            preferredSize: Size.fromHeight(50.0),
            child: Container(
              color: Theme.of(context).cardColor,
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
                      color: Theme.of(context).indicatorColor,
                      borderRadius: BorderRadius.circular(
                          5),
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
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: controller.listIncomeCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category =
                                controller.listIncomeCategory[index];
                            return InkWell(
                                onTap: () {
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
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
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
                                                    category.iconCode,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Color(category
                                                        .colorIcon),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child:
                                                  Text(category.name.tr),
                                            ),
                                            const Icon(Icons.dehaze)
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
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.listExpenseCategory.length,
                          itemBuilder: (BuildContext context, int index) {
                            final category =
                                controller.listExpenseCategory[index];
                            return InkWell(
                                onTap: () {
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
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            border: Border.all(
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
                                                    category.iconCode,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                color: Color(category
                                                        .colorIcon),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child:
                                                  Text(category.name.tr),
                                            ),
                                            const Icon(Icons.dehaze)
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
