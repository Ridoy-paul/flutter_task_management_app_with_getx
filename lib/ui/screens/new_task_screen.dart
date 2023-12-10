import 'package:flutter/material.dart';
import '../widgets/task_screen_widget.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {

  @override
  Widget build(BuildContext context) {
    return const TaskScreen(taskType: "New");
  }
  

  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummery(),
            Visibility(
              visible: _getTaskCountSummeryInProgress == false,
              replacement: const LinearProgressIndicator(),
              child: SizedBox(
                height: 100,
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
            Expanded(
              child: Visibility(
                visible: _getNewTaskInProgress == false,
                replacement: circleProgressIndicatorShow(),
                child: ListView.builder(
                    itemCount: taskListModel.taskList?.length ?? 0,
                    itemBuilder: (count, index) {
                      return TaskItemCard(
                        task: taskListModel.taskList![index],
                        onStatusChange: () {
                          getNewTaskList();
                        },
                        showProgress: (inProgress) {
                          _getNewTaskInProgress = inProgress;
                          if(mounted) {
                            setState(() {});
                            if(inProgress == false) {
                              showSnackMessage(context, "Task Status Updated.");
                            }
                          }
                        },
                      );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddNewTaskScreen(),),);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
   */




}
