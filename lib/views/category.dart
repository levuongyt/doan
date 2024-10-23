import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../controllers/category_controller.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  final CetegoryController controller = Get.put(CetegoryController());
  final TextEditingController nameDMThuNhapController = TextEditingController();
  final TextEditingController nameDMChiTieuController = TextEditingController();

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
  }

  @override
  Widget build(BuildContext context) {
    final doubleHeight = MediaQuery.of(context).size.height;
    final doubleWidth = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: Container(
        //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        //   width: double.infinity,
        //   child: ElevatedButton(
        //       style:
        //           ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
        //       onPressed: () async {
        //         await controller.addCategory(nameDMThuNhapController.text,
        //             controller.selectedIconCode.value, 'Thu Nhập');
        //       },
        //       child: Text(
        //         'Lưu danh mục',
        //         style: TextStyle(color: Colors.white),
        //       )),
        // ),
        appBar: AppBar(
          title: Text('Thêm danh mục'),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0), // Adjust the height as needed
            child: Container(
              color: Colors.grey[300], // Background color for unselected tabs
              child: TabBar(
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
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(
                      5),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
              ),
            ),
          ),
        ),
        body: SafeArea(
            child: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Tên danh mục : '),
                            Expanded(
                              child: TextFormField(
                                controller: nameDMThuNhapController,
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
                          children: [Text('Biểu tượng')],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(
                              () => Container(
                            height: doubleHeight*(215/800),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                              itemCount: controller.iconCodes.length,
                              itemBuilder: (context, index) {
                                final iconCode = controller.iconCodes[index];
                                return InkWell(
                                  onTap: () {
                                    controller.selectedIconTNCode.value = iconCode;
                                  },
                                  child: Obx(
                                        () => Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              controller.selectedIconTNCode.value ==
                                                  iconCode
                                                  ? Colors.blueAccent
                                                  : Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Icon(IconData(iconCode,
                                          fontFamily: 'MaterialIcons')),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text('Màu sắc'),
                          ],
                        ),
                        SizedBox(height: 5),
                        Obx(() => Container(
                          height: doubleHeight*(215/800),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: controller.colors.length,
                            itemBuilder: (context, index) {
                              final color = controller.colors[index];
                              return InkWell(
                                onTap: () {
                                  controller.selectedTNColor.value =
                                      color.value;
                                },
                                child: Obx(
                                      () => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller.selectedTNColor.value ==
                                            color.value
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                      color: color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: double.infinity,
                          height: doubleHeight * (50 / 800),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent),
                              onPressed: () async {
                                await controller.addCategory(nameDMThuNhapController.text,
                                    controller.selectedIconTNCode.value,
                                    controller.selectedTNColor.value,
                                    'Thu Nhập');
                              },
                              child: Text(
                                'Lưu Danh Mục',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),

                ///Tab2
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Tên danh mục : '),
                            Expanded(
                              child: TextFormField(
                                controller: nameDMChiTieuController,
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
                          children: [Text('Biểu tượng')],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Obx(
                              () => Container(
                            height: doubleHeight*(215/800),
                            child: GridView.builder(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                              itemCount: controller.iconCodes.length,
                              itemBuilder: (context, index) {
                                final iconCode = controller.iconCodes[index];
                                return InkWell(
                                  onTap: () {
                                    controller.selectedIconCTCode.value = iconCode;
                                  },
                                  child: Obx(
                                        () => Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                              controller.selectedIconCTCode.value ==
                                                  iconCode
                                                  ? Colors.blueAccent
                                                  : Colors.grey),
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Icon(IconData(iconCode,
                                          fontFamily: 'MaterialIcons')),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text('Màu sắc'),
                          ],
                        ),
                        SizedBox(height: 5),
                        Obx(() => Container(
                          height: doubleHeight*(215/800),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 6,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: controller.colors.length,
                            itemBuilder: (context, index) {
                              final color = controller.colors[index];
                              return InkWell(
                                onTap: () {
                                  controller.selectedCTColor.value =
                                      color.value;
                                },
                                child: Obx(
                                      () => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller.selectedCTColor.value ==
                                            color.value
                                            ? Colors.black
                                            : Colors.grey,
                                      ),
                                      color: color,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )),
                        SizedBox(height: 20,),
                        SizedBox(
                          width: double.infinity,
                          height: doubleHeight * (50 / 800),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent),
                              onPressed: () async {
                                await controller.addCategory(nameDMChiTieuController.text,
                                    controller.selectedIconCTCode.value,
                                    controller.selectedCTColor.value,
                                    'Chi Tiêu');
                              },
                              child: Text(
                                'Lưu Danh Mục',
                                style: TextStyle(color: Colors.white, fontSize: 15),
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
