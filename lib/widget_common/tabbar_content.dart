import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabBarContent extends StatelessWidget {
  const TabBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        tabs: [
          Container(
            height: 45,
            alignment: Alignment.center,
            child: Text('Thu nhập'.tr),
          ),
          Container(
            height: 45,
            alignment: Alignment.center,
            child: Text('Chi tiêu'.tr),
          ),
        ],
      ),
    );
  }
}
