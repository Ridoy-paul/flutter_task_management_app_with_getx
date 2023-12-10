import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import '../../app.dart';
import '../../ui/screens/login_screen.dart';
import '../../ui/controllers/auth_controller.dart';
import 'package:http/http.dart';
import 'network_response.dart';

class NetworkCaller {

  /// This method is used for POST Request
  Future<NetworkResponse> postRequest(String url, {Map<String, dynamic>? body, bool isLogin = false}) async {

    /// This is used for show console log
    log(url);
    log(body.toString());

    try {
      final Response response =
          await post(Uri.parse(url), body: jsonEncode(body), headers: {
        'Content-type': 'Application/json',
            'token': AuthController.token.toString(),
      });

      /// This is used for show console log
      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
          statusCode: 200,
        );
      }
      else if(response.statusCode == 401) {
        if(isLogin == false) {
          backToLogin();
        }

        return NetworkResponse(
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      }
      else {
        return NetworkResponse(
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      return NetworkResponse(isSuccess: false, errorMessage: error.toString());
    }
  }

  /// This method is used for GET Request
  Future<NetworkResponse> getRequest(String url) async {

    /// This is used for show console log
    log(url);

    try {
      final Response response =
      await get(Uri.parse(url), headers: {
        'Content-type': 'Application/json',
        'token': AuthController.token.toString(),
      });

      /// This is used for show console log
      // log(response.statusCode.toString());
      // log(response.body.toString());

      if (response.statusCode == 200) {
        return NetworkResponse(
          isSuccess: true,
          jsonResponse: jsonDecode(response.body),
          statusCode: 200,
        );
      }
      else if(response.statusCode == 401) {
        backToLogin();
        return NetworkResponse(
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      }
      else {
        return NetworkResponse(
          isSuccess: false,
          jsonResponse: jsonDecode(response.body),
          statusCode: response.statusCode,
        );
      }
    } catch (error) {
      return NetworkResponse(isSuccess: false, errorMessage: error.toString());
    }
  }



  /// This function is used for backTologin, when token is expired.
  Future<void> backToLogin() async {
    await AuthController.clearAuthData();
    Navigator.pushAndRemoveUntil(TaskManagementApp.navigationKey.currentContext!, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

}
