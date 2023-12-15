import 'package:flutter/material.dart';
import 'package:flutter_task_management_app/ui/controllers/auth_controller.dart';
import 'package:flutter_task_management_app/ui/controllers/profile_update_controller.dart';
import 'package:flutter_task_management_app/ui/controllers/reset_password_controller.dart';
import 'package:flutter_task_management_app/ui/controllers/task_count_summery_controller.dart';
import 'package:flutter_task_management_app/ui/controllers/task_screen_controller.dart';
import 'ui/controllers/forgot_password_pin_verification_controller.dart';
import 'ui/controllers/add_task_controller.dart';
import 'ui/controllers/forgot_password_email_verify_controller.dart';
import 'ui/controllers/sign_up_controller.dart';
import 'ui/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/style.dart';

class TaskManagementApp extends StatelessWidget {
  const TaskManagementApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigationKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      theme: ThemeData(

        ///this is used for input type style ---------------->>>>>>>>>>>
        inputDecorationTheme: InputDecorationTheme(
            fillColor: colorWhite,
            filled: true,
            labelStyle: const TextStyle(
              color: colorGray,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10),
            )
        ),
        ///--------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w600,
          )
        ),

        primaryColor: colorGreen,
        primarySwatch: Colors.green,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )
          ),
        ),
      ),
      initialBinding: ControllerBinder(),
    );
  }
}

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(LoginController());
    Get.put(AddTaskController());
    Get.put(SignUpController());
    Get.put(ForgotPasswordEmailVerifyController());
    Get.put(ForgotPasswordPinVerificationController());
    Get.put(ReSetPasswordController());
    Get.put(ProfileUpdateController());
    Get.put(TaskScreenController());
    Get.put(TaskCountSummeryController());


  }
}
