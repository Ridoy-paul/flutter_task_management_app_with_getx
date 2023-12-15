import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/utility/urls.dart';

class UpdateTaskController extends GetxController {
  bool _updateTaskInProgress = false;

  bool get updateTaskInProgress => _updateTaskInProgress;

  Future<bool> updateTaskStatus(String taskID, String status) async {
    //widget.showProgress(true);
    _updateTaskInProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.updateTaskStatus(taskID, status));

    _updateTaskInProgress = false;
    update();
    if(response.isSuccess) {
      return true;
    }

    return false;

    //widget.showProgress(false);
  }
}