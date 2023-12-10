
import 'package:flutter/material.dart';

String? inputValidate(dynamic value, String errorMessage) {
  if(value?.trim().isEmpty ?? true) {
    return errorMessage;
  }
  return null;
}

Center circleProgressIndicatorShow() {
  return const Center( /// Replacement Widget show
    child: CircularProgressIndicator(),
  );
}


