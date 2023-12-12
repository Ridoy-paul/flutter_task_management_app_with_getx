import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {

  bool _loginInProgress = false;
  String _message = '';
  bool _errorStatus = true;

  bool get loginInProgress => _loginInProgress;
  String get message => _message;
  bool get errorStatus => _errorStatus;

  Future<bool> loginUserConfirm(String email, String password) async {
     _loginInProgress = true;
     update();

      NetworkResponse response = await NetworkCaller().postRequest(Urls.login, body: {
        "email": email,
        "password": password,
      }, isLogin: true);

      _loginInProgress = false;
      update();

      if(response.isSuccess) {
        await AuthController.saveUserInformation(response.jsonResponse['token'], UserModel.fromJson(response.jsonResponse['data']),);
        return true;
      }
      else {
        if(response.statusCode == 401) {
          _message = "Please check email or password!";
          _errorStatus = false;
        }
        else {
          _message = "Login Failed! Please try again.";
          _errorStatus = false;
        }
      }
      return false;
  }

}