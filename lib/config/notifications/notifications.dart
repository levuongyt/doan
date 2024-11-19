import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String title, String message, bool isSuccess){
  Get.snackbar(
    title.tr,
    message.tr,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
    colorText: Colors.white,
    icon: Icon(isSuccess ? Icons.check_circle : Icons.error,
        color: Colors.white),
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(16),
    borderRadius: 8,
  );
}