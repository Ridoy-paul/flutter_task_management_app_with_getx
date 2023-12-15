import 'package:flutter/material.dart';
import '../controllers/task_count_summery_controller.dart';
import '../controllers/task_screen_controller.dart';
import 'package:flutter_task_management_app/ui/style.dart';
import 'package:get/get.dart';
import 'profile_summery_card_widget.dart';
import '../../data/models/task_count.dart';
import '../screens/add_new_task_screen.dart';
import 'new_task_summery_widget.dart';
import 'task_item_card_widget.dart';
import '../../data/utility/helpers.dart';

class TaskScreen extends StatefulWidget {
  final String taskType;

  const TaskScreen({Key? key, required this.taskType}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {

  final TaskScreenController _taskScreenController = Get.find<TaskScreenController>();
  final TaskCountSummeryController _taskCountSummeryController = Get.find<TaskCountSummeryController>();

  @override
  void initState() {
    super.initState();
    _taskScreenController.getTaskList(widget.taskType);

    if (widget.taskType == "New") {
      _taskCountSummeryController.getTaskCountSummeryList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummery(),
            widget.taskType == 'New' ?
            GetBuilder<TaskCountSummeryController>(builder: (taskCountSummeryController) {
              return Visibility(
                visible: !taskCountSummeryController.getTaskCountSummeryInProgress,
                replacement: const LinearProgressIndicator(),
                child: SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: taskCountSummeryController.taskCountSummeryListModel.taskCountList?.length ?? 0,
                      itemBuilder: (context, index) {
                        TaskCount taskCount = taskCountSummeryController.taskCountSummeryListModel.taskCountList![index];
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
              );
            }) : Container(),
            Expanded(
              child: GetBuilder<TaskScreenController>(
                  builder: (taskScreenController) {
                    return RefreshIndicator(
                      onRefresh: () =>
                          taskScreenController.getTaskList(widget.taskType),
                      child: Visibility(
                        visible: !taskScreenController.getTaskScreenInProgress,
                        replacement: circleProgressIndicatorShow(),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: taskScreenController.taskListModel
                                .taskList?.length ?? 0,
                            itemBuilder: (context, index) {
                              return TaskItemCard(
                                task: taskScreenController.taskListModel
                                    .taskList![index],
                                onStatusChange: () {
                                  taskScreenController.getTaskList(
                                      widget.taskType);
                                  if (widget.taskType == "New") {
                                    _taskCountSummeryController.getTaskCountSummeryList();
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
          /// This code will run when coming back from add task screen.
          if (widget.taskType == "New") {
            _taskCountSummeryController.getTaskCountSummeryList();
          }

          _taskScreenController.getTaskList(widget.taskType);
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
