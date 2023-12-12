import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../style.dart';

void showSnackMessage(String message, [bool isErrorStatus = true]) {
  Get.snackbar(
    isErrorStatus ? "Success" : "Error!",
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isErrorStatus ? colorGreen : colorRed,
    colorText: Colors.white,
    borderRadius: 10.0,
    isDismissible: true,
    dismissDirection: DismissDirection.horizontal,
    forwardAnimationCurve: Curves.easeOutBack,
    duration: const Duration(seconds: 2),
    barBlur: 20.0,
    margin: const EdgeInsets.all(10.0),
    padding: const EdgeInsets.all(16.0),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: const Offset(0, 3),
      ),
    ],
  );
}
