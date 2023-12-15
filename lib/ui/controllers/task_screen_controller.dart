import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/utility/urls.dart';

class TaskScreenController extends GetxController {
  TaskListModel _taskListModel = TaskListModel();
  bool _getTaskScreenInProgress = false;
  String _message = '';
  bool _successStatus = true;

  bool get getTaskScreenInProgress => _getTaskScreenInProgress;
  String get message => _message;
  bool get successStatus => _successStatus;
  TaskListModel get taskListModel => _taskListModel;

  /// Function for get task lists...
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

  /// Function for Update task status...
  Future<bool> updateTaskStatus(String taskID, String status) async {
    _getTaskScreenInProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.updateTaskStatus(taskID, status));

    _getTaskScreenInProgress = false;
    update();
    if(response.isSuccess) {
      _message = "Task Status Update.";
      _successStatus = true;
      return true;
    }

    _message = "Task Status can not Updated.";
    _successStatus = false;
    return false;
  }

  /// Function for delete task
  Future<bool> deleteTaskItem(String taskId) async {
    _getTaskScreenInProgress = true;
    update();

    final response = await NetworkCaller().getRequest(Urls.deleteTaskItem(taskId));
    _getTaskScreenInProgress = false;
    update();
    if(response.isSuccess) {
      _message = "Task Status Update.";
      _successStatus = true;
      return true;
    }

    return false;
  }




}