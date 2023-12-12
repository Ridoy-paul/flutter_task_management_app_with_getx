import 'package:get/get.dart';

import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class SignUpController extends GetxController {
  bool _signUpInProgress = false;
  String _message = '';
  bool _successStatus = true;

  bool get signUpInProgress => _signUpInProgress;
  String get message => _message;
  bool get successStatus => _successStatus;

  Future<void> signUpConfirm(String email, String firstName, String lastName, String mobile, String password) async {
      _signUpInProgress = true;
      update();

      /// This is used for POST request to server
      final NetworkResponse response =
      await NetworkCaller().postRequest(Urls.registration, body: {
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "mobile": mobile,
        "password": password,
      });

      ///----End--------------->>>>>>>>>>>>>>>>>

      /// This is used for circle progress disable after submit
      _signUpInProgress = false;
      update();
      ///---End----------------------->>>>>>>>>>>>>>>>>>>>

      if (response.isSuccess) {
        _message = "Account created successfully!";
        _successStatus = true;
      } else {
        _message = "Account creation failed! Please try again.";
        _successStatus = false;
      }
  }
}