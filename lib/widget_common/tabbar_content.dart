import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/themes/themes_app.dart';

class TabBarContent extends StatelessWidget {
  const TabBarContent({super.key});

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<AppGradientTheme>();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).focusColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: gradientTheme?.buttonGradient,
          boxShadow: [
            BoxShadow(
              color: gradientTheme?.shadowColor ?? Colors.black.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Theme.of(context).textTheme.bodySmall?.color,
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
        overlayColor: WidgetStateProperty.all(Colors.transparent),
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
