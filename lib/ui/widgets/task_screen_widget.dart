import 'package:flutter/material.dart';
import 'package:flutter_task_management_app/ui/style.dart';
import 'profile_summery_card_widget.dart';
import '../../data/models/task_count.dart';
import '../../data/models/task_summery_count_summery_model.dart';
import '../screens/add_new_task_screen.dart';
import 'new_task_summery_widget.dart';
import 'task_item_card_widget.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/task_list_model.dart';
import '../../data/utility/helpers.dart';
import '../../data/utility/urls.dart';

class TaskScreen extends StatefulWidget {
  final String taskType;
  const TaskScreen({Key? key, required this.taskType}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  bool _getTaskInProgress = false;
  bool _getTaskCountSummeryInProgress = false;

  TaskListModel taskListModel = TaskListModel();
  TaskCountSummeryListModel taskCountSummeryListModel = TaskCountSummeryListModel();

  Future<void> getTaskList() async {
    setState(() {
      _getTaskInProgress = true;
    });

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.getTask(widget.taskType));

    if (response.isSuccess) {
      taskListModel = TaskListModel.fromJson(response.jsonResponse);
    }

    setState(() {
      _getTaskInProgress = false;
    });
  }

  Future<void> getTaskCountSummeryList() async {
    _getTaskCountSummeryInProgress = true;

    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.getTaskStatusCount);
    if (response.isSuccess) {
      taskCountSummeryListModel = TaskCountSummeryListModel.fromJson(response.jsonResponse);
    }

    _getTaskCountSummeryInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }


  @override
  void initState() {
    super.initState();
    getTaskList();

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
                    itemCount: taskCountSummeryListModel.taskCountList?.length ?? 0,
                    itemBuilder: (context, index) {
                      TaskCount taskCount = taskCountSummeryListModel.taskCountList![index];
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
              child: RefreshIndicator(
                onRefresh: getTaskList,
                child: Visibility(
                  visible: _getTaskInProgress == false,
                  replacement: circleProgressIndicatorShow(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      itemCount: taskListModel.taskList?.length ?? 0,
                      itemBuilder: (context, index) {
                        return TaskItemCard(
                          task: taskListModel.taskList![index],
                          onStatusChange: () {
                            getTaskList();
                            if(widget.taskType == "New") {
                              getTaskCountSummeryList();
                            }
                          },
                          showProgress: (inProgress) {
                            setState(() {
                              _getTaskInProgress = inProgress;
                            });
                            // if (!inProgress) {
                            //   showSnackMessage(context, "Task Status Updated.");
                            // }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.taskType == "New" ? FloatingActionButton(
        onPressed: () async {
           await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewTaskScreen(),),);

           /// This code will run when coming back from add task screen.
           if (widget.taskType == "New") {
             getTaskCountSummeryList();
           }
           getTaskList();
        },
        child: const Icon(Icons.add),
      ) : null,
    );
  }
}
