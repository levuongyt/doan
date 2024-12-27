import 'package:doan_ql_thu_chi/views/category/update_category.dart';
import 'package:doan_ql_thu_chi/widget_common/tabbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Models/category_model.dart';
import '../../controllers/transaction_controller.dart';
import 'add_category.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final TransactionController controller = Get.find();
  @override
  Widget build(BuildContext context) {
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
                  Get.to(const AddCategory());
                },
                icon: const Icon(Icons.add))
          ],
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Theme.of(context).cardColor,
              child: Column(
                children: [
                  Container(
                    height: 10,
                    color: Theme.of(context).dividerColor,
                  ),
                  const TabBarContent()
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: TabBarView(children: [
              buildTabContent(controller.listIncomeCategory),
              buildTabContent(controller.listExpenseCategory),
            ])),
      ),
    );
  }

  Padding buildTabContent(List<CategoryModel> categories) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Obx(
                  () => ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    final category = categories[index];
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
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    IconData(category.iconCode,
                                        fontFamily: 'MaterialIcons'),
                                    color: Color(category.colorIcon),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(category.name.tr),
                                ),
                                const Icon(Icons.dehaze)
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
