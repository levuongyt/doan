import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabbarCtContent extends StatelessWidget {
  const TabbarCtContent({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBar(
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
        borderRadius: BorderRadius.circular(5),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
    );
  }
}
