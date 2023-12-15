import 'dart:convert';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/utility/urls.dart';
import 'auth_controller.dart';


class ProfileUpdateController extends GetxController {
  bool _updateProfileInProgressStatus = false;
  String _message = '';
  bool _successStatus = true;

  bool get updateProfileInProgressStatus => _updateProfileInProgressStatus;
  String get message => _message;
  bool get successStatus => _successStatus;

  Future<bool> updateUserProfileConfirm(String email, String firstName, String lastName, String mobile, XFile? photo, String? password) async {

    _updateProfileInProgressStatus = true;
    update();

    String? photoInBase64;

    Map<String, dynamic> inputData = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if(password!.isNotEmpty) {
      inputData['password'] = password;
    }

    if(photo != null) {
      List<int> imageBytes = await photo.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData['photo'] = photoInBase64;
    }

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.profileUpdate, body: inputData,);

    _updateProfileInProgressStatus = false;
    update();

    if(response.isSuccess) {
      Get.find<AuthController>().updateUserInformation(UserModel(
        email: email,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: photoInBase64 ?? AuthController.user?.photo,
      ));

      _message = "Profile Updated.";
      _successStatus = true;
      return true;
    }
    else {
      _message = "Network Error! Please try again.";
      _successStatus = true;
    }
    return false;
  }
}