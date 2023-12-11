import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {

  bool _loginInProgress = false;
  String _message = '';
  bool _status = true;

  bool get loginInProgress => _loginInProgress;
  String get message => _message;
  bool get status => _status;

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
        // if(mounted) {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => const MainBottomNavScreen(),
        //     ),
        //   );
        // }
      }
      else {
        if(response.statusCode == 401) {
          _message = "Please check email or password!";
          _status = false;
        }
        else {
          _message = "Login Failed! Please try again.";
          _status = false;
        }
      }
      return false;
  }

}