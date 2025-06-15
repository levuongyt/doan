import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

class LoadingUtils {
  // Loading cho việc lưu giao dịch
  static Widget buildSaveTransactionLoader() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SpinKitFoldingCube(
            color: const Color(0xFF4CAF50),
            size: 40.0,
          ),
        ),
      ),
    );
  }

  // Loading cho tải dữ liệu
  static Widget buildDataLoader() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitFadingCircle(
                color: const Color(0xFF6366F1),
                size: 60.0,
              ),
              const SizedBox(height: 20),
              Text(
                'Đang tải dữ liệu...'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Loading cho đồng bộ
  static Widget buildSyncLoader() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitSpinningCircle(
                color: Colors.orange,
                size: 60.0,
              ),
              const SizedBox(height: 20),
              Text(
                'Đang đồng bộ...'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Loading chung (mặc định)
  static Widget buildDefaultLoader() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitFadingCircle(
                color: const Color(0xFF6366F1),
                size: 60.0,
              ),
              const SizedBox(height: 20),
              Text(
                'Đang xử lý...'.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 