import 'package:doan_ql_thu_chi/models/category_model.dart';
import 'package:doan_ql_thu_chi/views/category/update_category.dart';
import 'package:doan_ql_thu_chi/widget_common/tabbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            preferredSize: const Size.fromHeight(70.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 8,
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
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(category.colorIcon).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                IconData(category.iconCode,
                                    fontFamily: 'MaterialIcons'),
                                color: Color(category.colorIcon),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                category.name.tr,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
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
