import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/themes/themes_app.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool useGradient;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.useGradient = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<AppGradientTheme>();
    
    return AppBar(
      title: Text(
        title.tr,
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      centerTitle: centerTitle,
      backgroundColor: useGradient ? Colors.transparent : (backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor),
      elevation: 0,
      leading: showBackButton
          ? IconButton(
              onPressed: onBackPressed ?? () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).appBarTheme.iconTheme?.color,
                size: 20,
              ),
            )
          : null,
      actions: actions,
      flexibleSpace: useGradient
          ? Container(
              decoration: BoxDecoration(
                gradient: gradientTheme?.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: gradientTheme?.shadowColor ?? Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            )
          : null,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final VoidCallback? onBackPressed;

  const SimpleAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title.tr,
        style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
          color: titleColor,
        ) ?? TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: titleColor ?? Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: 2,
      leading: showBackButton
          ? IconButton(
              onPressed: onBackPressed ?? () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios,
                color: titleColor ?? Theme.of(context).appBarTheme.iconTheme?.color,
                size: 20,
              ),
            )
          : null,
      actions: actions,
      automaticallyImplyLeading: false,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// AppBar cho màn báo cáo với TabBar
class CustomReportAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? bottom;
  final double bottomHeight;

  const CustomReportAppBar({
    super.key,
    required this.title,
    this.bottom,
    this.bottomHeight = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    final gradientTheme = Theme.of(context).extension<AppGradientTheme>();
        
    return Container(
      decoration: BoxDecoration(
        gradient: gradientTheme?.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: gradientTheme?.shadowColor ?? Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          title.tr,
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: bottom != null 
            ? PreferredSize(
                preferredSize: Size.fromHeight(bottomHeight),
                child: bottom!,
              )
            : null,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom != null ? bottomHeight : 0),
  );
} 