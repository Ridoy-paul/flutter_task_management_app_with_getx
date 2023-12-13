import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class ForgotPasswordPinVerificationController extends GetxController {
  bool _pinVerificationInProgressStatus = false;
  String _message = '';
  bool _successStatus = true;

  bool get pinVerificationInProgressStatus => _pinVerificationInProgressStatus;
  String get message => _message;
  bool get successStatus => _successStatus;

  Future<bool> pinVerificationConfirm(String email, String pinCode) async {
      _pinVerificationInProgressStatus = true;
      update();

      final response = await NetworkCaller().getRequest(Urls.recoveryVerifyOTP(email, pinCode));

      if(response.isSuccess) {
        if(response.jsonResponse['status'] == 'success') {
          _message = "Verification Success.";
          _successStatus = true;
          return true;
        }
        else {
          _message = response.jsonResponse['data'] ?? '';
          _successStatus = false;
        }
      }
      else {
        _message = "Network Error! Please try again.";
        _successStatus = false;

      }

      _pinVerificationInProgressStatus = false;
      update();

      return false;
  }
}