import 'package:get/get.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/task_summery_count_summery_model.dart';
import '../../data/utility/urls.dart';

class TaskCountSummeryController extends GetxController {
  bool _getTaskCountSummeryInProgress = false;
  TaskCountSummeryListModel _taskCountSummeryListModel = TaskCountSummeryListModel();

  bool get getTaskCountSummeryInProgress => _getTaskCountSummeryInProgress;
  TaskCountSummeryListModel get taskCountSummeryListModel => _taskCountSummeryListModel;

  Future<bool> getTaskCountSummeryList() async {
    _getTaskCountSummeryInProgress = true;
    update();

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    _getTaskCountSummeryInProgress = false;
    update();
    if (response.isSuccess) {
      _taskCountSummeryListModel = TaskCountSummeryListModel.fromJson(response.jsonResponse);
      return true;
    }

    return false;

  }
}