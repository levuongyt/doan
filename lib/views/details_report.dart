import 'package:doan_ql_thu_chi/controllers/report_controller.dart';
import 'package:doan_ql_thu_chi/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChiTietThuNhap extends StatefulWidget {
  final String categoryId;
  final String categoryName;
  final int iconCode;
  final int colorIcon;
  const ChiTietThuNhap(
      {super.key,
      required this.categoryId,
      required this.categoryName,
      required this.iconCode,
      required this.colorIcon});

  @override
  State<ChiTietThuNhap> createState() => _ChiTietThuNhapState();
}

class _ChiTietThuNhapState extends State<ChiTietThuNhap> {
  final ReportController reportController = Get.find();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportController.fetchCategoryTransactions(widget.categoryId);
    print('a : ${reportController.categoryTransactions.length}');
  }
  String formatBalance(double amount ) {
    return reportController.donViTienTe.value == 'đ'
        ? '${NumberFormat('#,##0').format(reportController.convertAmount(amount))} ${reportController.donViTienTe.value}'
        : '${NumberFormat('#,##0.00').format(reportController.convertAmount(amount))} ${reportController.donViTienTe.value}';
  }
  @override
  Widget build(BuildContext context) {
    final double doubleHeight = MediaQuery.of(context).size.height;
    final double doubleWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHI TIẾT DANH MỤC'.tr,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Giao dịch trong tháng'.tr,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          //  Text(widget.categoryName),
            SizedBox(
              height: 10,
            ),
            Obx(() {
              if (reportController.categoryTransactions.isEmpty) {
                return Center(
                  child: Text('Không có giao dịch'),
                );
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: reportController.categoryTransactions.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    TransactionModel transaction =
                        reportController.categoryTransactions[index];
                    String tienGD=transaction.type=='Thu Nhập'? '+${formatBalance(transaction.amount)}' : '-${formatBalance(transaction.amount)}';
                    return Column(
                      children: [
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).focusColor,
                            borderRadius: BorderRadius.circular(15),
                            //boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.grey.withOpacity(0.5),
                            //     spreadRadius: 5,
                            //     blurRadius: 7,
                            //     offset: Offset(0, 3),
                            //   )
                            // ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                DateFormat('dd/MM/yyyy')
                                    .format(transaction.date),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    IconData(widget.iconCode,
                                        fontFamily: 'MaterialIcons'),
                                    color: Color(widget.colorIcon),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(widget.categoryName.tr,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  transaction.type == 'Thu Nhập'
                                      ? Text(tienGD,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green))
                                      : Text(tienGD,
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Số dư cuối : '.tr,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                    formatBalance(transaction.finalBalance),
                                   // '${NumberFormat('#,##0').format(transaction.finalBalance)} ${reportController.donViTienTe.value}',
                                    style: Theme.of(context).textTheme.bodySmall,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text('Nội dung : '.tr,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                  SizedBox(width: 10,),
                                  Text(transaction.description,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        )
                      ],
                    );
                  },
                ),
              );
            })
          ],
        ),
      )),
    );
  }
}
