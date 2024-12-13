import 'package:doan_ql_thu_chi/config/extensions/extension_currency.dart';
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
  }

  String formatBalance(double amount) {
    return reportController.donViTienTe.value == 'đ'
        ? '${NumberFormat('#,##0').format(amount.toCurrency())} ${reportController.donViTienTe.value}'
        : '${NumberFormat('#,##0.##').format(amount.toCurrency())} ${reportController.donViTienTe.value}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHI TIẾT DANH MỤC'.tr,
          style: Theme.of(context).textTheme.displayLarge,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Giao dịch trong tháng'.tr,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                Obx(() {
                  if (reportController.categoryTransactions.isEmpty) {
                    return Center(
                      child: Text('Không có giao dịch'.tr),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: reportController.categoryTransactions.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        TransactionModel transaction =
                        reportController.categoryTransactions[index];
                        String tienGD = transaction.type == 'Thu Nhập'
                            ? '+${formatBalance(transaction.amount)}'
                            : '-${formatBalance(transaction.amount)}';
                        return Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).focusColor,
                                borderRadius: BorderRadius.circular(15),
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
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.categoryName.tr,
                                        style:
                                        Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      transaction.type == 'Thu Nhập'
                                          ? Text(tienGD,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green))
                                          : Text(tienGD,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Số dư cuối : '.tr,
                                        style:
                                        Theme.of(context).textTheme.bodySmall,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        formatBalance(transaction.finalBalance),
                                        style:
                                        Theme.of(context).textTheme.bodySmall,
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            children: [
                                              TextSpan(
                                                text: 'Nội dung : '.tr,
                                              ),
                                              TextSpan(
                                                text: transaction.description,
                                              ),
                                            ],
                                          ),
                                          softWrap: true,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
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
