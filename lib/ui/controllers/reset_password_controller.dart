import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class ReSetPasswordController extends GetxController {
  bool _resetPasswordInProgressStatus = false;
  String _message = '';
  bool _successStatus = true;

  bool get loginInProgress => _resetPasswordInProgressStatus;
  String get message => _message;
  bool get successStatus => _successStatus;

  Future<bool> _resetPasswordConfirm(String email, String otp, String password, String confirmPassword) async {
      _resetPasswordInProgressStatus = true;
      update();

      if (password != confirmPassword) {
        _message = "Password doesn't match!";
        _successStatus = false;
        _resetPasswordInProgressStatus = true;
        update();
        return false;
      }

      final NetworkResponse response = await NetworkCaller().postRequest(Urls.recoveryPassword, body: {
        "email": email,
        "OTP": otp,
        "password": password,
      });

      if(response.isSuccess) {
        if(response.jsonResponse['status'] == 'success') {
          _message = "New Password Set.";
          _successStatus = true;
          return true;
        }
        else {
          _message = "Something is error! Please try again.";
          _successStatus = false;
        }
      }
      else {
        _message = "Something is error! Please try again.";
        _successStatus = false;
      }

      _resetPasswordInProgressStatus = false;
      update();
      return false;
  }
}