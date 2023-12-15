import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/utility/urls.dart';

class TaskScreenController extends GetxController {
  TaskListModel _taskListModel = TaskListModel();
  bool _getTaskScreenInProgress = false;

  bool get getTaskScreenInProgress => _getTaskScreenInProgress;
  TaskListModel get taskListModel => _taskListModel;

  Future<bool> getTaskList(String taskType) async {
    _getTaskScreenInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getTask(taskType));

    _getTaskScreenInProgress = false;
    update();

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.jsonResponse);
      return true;
    }
    return false;
  }

}