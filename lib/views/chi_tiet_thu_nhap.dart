import 'package:flutter/material.dart';

class ChiTietThuNhap extends StatefulWidget {
  const ChiTietThuNhap({super.key});

  @override
  State<ChiTietThuNhap> createState() => _ChiTietThuNhapState();
}

class _ChiTietThuNhapState extends State<ChiTietThuNhap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi Tiết'),
        centerTitle: true,
      ),
      body: SafeArea(child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Báo cáo chi tiết '),
            Text('ĐIỆN THOẠI'),
            SizedBox(height: 10,),
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: Colors.grey,
                  child: Column(
                    children: [
                      Text('27/08/2024',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          Text('Điện thoại',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Số dư cuối',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                        ],
                      ),
                      Row(children: [
                        Text('Nội dung:',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                      ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
