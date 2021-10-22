import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSnackbar(String message, {String? title, bool isError = false}) {
  Get.rawSnackbar(
    title: title,
    message: message,
    backgroundColor: isError ? Colors.red.shade500 : Colors.green.shade500,
    snackPosition: SnackPosition.TOP,
    margin: const EdgeInsets.all(10.0),
    borderRadius: 7.0,
  );
}
