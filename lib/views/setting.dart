import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CÀI ĐẶT CHUNG',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle:true,
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(
            color: Colors.white
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Tổng quan',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.edit_note),
      //       label: 'Nhập vào',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bar_chart),
      //       label: 'Báo cáo',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.settings),
      //       label: 'Cài đặt',
      //     ),
      //   ],
      //   //currentIndex: _selectedIndex,
      //   //onTap: _onItemTapped,
      //   type: BottomNavigationBarType.fixed,
      //   backgroundColor: Colors.grey,
      // ),
    );
  }
}
