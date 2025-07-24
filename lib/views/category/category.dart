import 'package:doan_ql_thu_chi/models/category_model.dart';
import 'package:doan_ql_thu_chi/views/category/update_category.dart';
import 'package:doan_ql_thu_chi/widget_common/tabbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/transaction_controller.dart';
import '../../config/themes/themes_app.dart';
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
    final gradientTheme = Theme.of(context).extension<AppGradientTheme>();
    
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: gradientTheme?.primaryGradient ?? LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              ),
          ),
          title: Text(
            'DANH MỤC'.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const AddCategory());
                },
                icon: const Icon(Icons.add, color: Colors.white))
          ],
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
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
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color(category.colorIcon).withValues(alpha: 0.1),
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
                              child:                               Text(
                                category.name.tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).textTheme.titleMedium?.color,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColor,
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
