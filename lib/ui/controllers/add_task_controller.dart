import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/urls.dart';

class AddTaskController extends GetxController {
  bool _createInProgressStatus = false;
  String _message = '';
  bool _successStatus = true;

  bool get createInProgressStatus => _createInProgressStatus;
  String get message => _message;
  bool get successStatus => _successStatus;

  Future<bool> createTaskConfirm(String title, String description) async {
      _createInProgressStatus = true;
      update();

      final NetworkResponse  response = await NetworkCaller().postRequest(Urls.createTask, body: {
        "title": title,
        "description": description,
        "status": "New",
      });

      _createInProgressStatus = false;
      update();

      if(response.isSuccess) {
        _message = "New Task Created.";
        _successStatus = true;
        return true;
      }
      else {
        _message = "Something is wrong, Please try again!";
        _successStatus = false;
        return false;
      }
  }
}