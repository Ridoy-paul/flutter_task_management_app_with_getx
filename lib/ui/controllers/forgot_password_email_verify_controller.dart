import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class ForgotPasswordEmailVerifyController extends GetxController {
  bool _forgotPasswordInProgressStatus = false;
  String _message = '';
  bool _successStatus = true;

  bool get forgotPasswordInProgressStatus => _forgotPasswordInProgressStatus;
  String get message => _message;
  bool get successStatus => _successStatus;

  Future<bool> forgotPasswordConfirm(String email) async {
      _forgotPasswordInProgressStatus = true;
      update();

      final response = await NetworkCaller().getRequest(Urls.recoveryVerifyEmail(email));
      if(response.isSuccess) {
        if(response.jsonResponse['status'] == 'success') {
          _message = "6 digit verification code sent your email.";
          _successStatus = true;
          return true;
        }
        else {
          _message = response.jsonResponse['data'];
          _successStatus = false;
        }
      }
      else {
        _message = "Something is error! Please try again.";
        _successStatus = false;
      }

      _forgotPasswordInProgressStatus = false;
      update();
      return false;
  }
}