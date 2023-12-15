import 'package:flutter/material.dart';
import '../controllers/task_screen_controller.dart';
import 'package:flutter_task_management_app/ui/style.dart';
import 'package:get/get.dart';
import 'profile_summery_card_widget.dart';
import '../../data/models/task_count.dart';
import '../../data/models/task_summery_count_summery_model.dart';
import '../screens/add_new_task_screen.dart';
import 'new_task_summery_widget.dart';
import 'task_item_card_widget.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/helpers.dart';
import '../../data/utility/urls.dart';

class TaskScreen extends StatefulWidget {
  final String taskType;

  const TaskScreen({Key? key, required this.taskType}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _getTaskCountSummeryInProgress = false;

  //TaskListModel taskListModel = TaskListModel();
  // TaskCountSummeryListModel taskCountSummeryListModel = TaskCountSummeryListModel();
  final TaskScreenController _taskScreenController = Get.find<TaskScreenController>();

  // Future<void> getTaskList() async {
  //   final response = _taskScreenController.getTaskList(widget.taskType);
  //
  //   print(response);
  //   //taskListModel = TaskListModel.fromJson(response);
  //
  //   /*
  //   setState(() {
  //     _getTaskInProgress = true;
  //   });
  //
  //   final NetworkResponse response = await NetworkCaller().getRequest(Urls.getTask(widget.taskType));
  //
  //   if (response.isSuccess) {
  //     taskListModel = TaskListModel.fromJson(response.jsonResponse);
  //   }
  //
  //   setState(() {
  //     _getTaskInProgress = false;
  //   });
  //    */
  // }

  // Future<void> getTaskCountSummeryList() async {
  //   _getTaskCountSummeryInProgress = true;
  //
  //   if (mounted) {
  //     setState(() {});
  //   }
  //
  //   final NetworkResponse response =
  //   await NetworkCaller().getRequest(Urls.getTaskStatusCount);
  //   if (response.isSuccess) {
  //     taskCountSummeryListModel =
  //         TaskCountSummeryListModel.fromJson(response.jsonResponse);
  //   }
  //
  //   _getTaskCountSummeryInProgress = false;
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }


  @override
  void initState() {
    super.initState();
    _taskScreenController.getTaskList(widget.taskType);

    if (widget.taskType == "New") {
      getTaskCountSummeryList();
    }
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print("hello paul");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummery(),
            widget.taskType == 'New' ?
            Visibility(
              visible: _getTaskCountSummeryInProgress == false,
              replacement: const LinearProgressIndicator(),
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskCountSummeryListModel.taskCountList
                        ?.length ?? 0,
                    itemBuilder: (context, index) {
                      TaskCount taskCount = taskCountSummeryListModel
                          .taskCountList![index];
                      return FittedBox(
                        child: SummeryCard(
                          title: taskCount.sId ?? '',
                          value: taskCount.sum.toString(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ) : Container(),
            Expanded(
              child: GetBuilder<TaskScreenController>(builder: (taskScreenController) {
                return RefreshIndicator(
                  onRefresh: ()=> taskScreenController.getTaskList(widget.taskType),
                  child: Visibility(
                    visible: !taskScreenController.getTaskScreenInProgress,
                    replacement: circleProgressIndicatorShow(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: taskScreenController.taskListModel.taskList?.length ?? 0,
                        itemBuilder: (context, index) {
                          return TaskItemCard(
                            task: taskScreenController.taskListModel.taskList![index],
                            onStatusChange: () {
                              taskScreenController.getTaskList(widget.taskType);
                              if (widget.taskType == "New") {
                                getTaskCountSummeryList();
                              }
                            },
                            showProgress: (inProgress) {
                              // setState(() {
                              //   _getTaskInProgress = inProgress;
                              // });
                              // if (!inProgress) {
                              //   showSnackMessage(context, "Task Status Updated.");
                              // }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.taskType == "New" ? FloatingActionButton(
        onPressed: () async {
          await Get.to(const AddNewTaskScreen());
          //await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewTaskScreen(),),);

          /// This code will run when coming back from add task screen.
          if (widget.taskType == "New") {
            getTaskCountSummeryList();
          }

          _taskScreenController.getTaskList(widget.taskType);
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
