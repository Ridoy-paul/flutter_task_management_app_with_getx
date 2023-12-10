import 'package:flutter/material.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import '../../data/models/task.dart';
import '../style.dart';

enum TaskStatus {
  New,
  Progress,
  Completed,
  Cancelled,
}

class TaskItemCard extends StatefulWidget {
  const TaskItemCard({
    super.key,
    required this.task,
    required this.onStatusChange,
    required this.showProgress,
  });

  final Task task;
  final VoidCallback onStatusChange;
  final Function(bool) showProgress;

  @override
  State<TaskItemCard> createState() => _TaskItemCardState();
}

class _TaskItemCardState extends State<TaskItemCard> {

  /// Function for Update Task Status
  Future<void> updateTaskStatus(String status) async {
    widget.showProgress(true);

    final response = await NetworkCaller().getRequest(Urls.updateTaskStatus(widget.task.sId ?? '', status));
    if(response.isSuccess) {
      widget.onStatusChange();
    }

    //widget.showProgress(false);
  }

  /// Function for delete Task Item
  Future<void> deleteTaskItem(String taskId) async {
    widget.showProgress(true);

    final response = await NetworkCaller().getRequest(Urls.deleteTaskItem(widget.task.sId ?? ''));
    if(response.isSuccess) {
      widget.onStatusChange();
    }

    //widget.showProgress(false);
  }

  @override
  Widget build(BuildContext context) {

    Color statusBgColor = colorBlue;
    if(widget.task.status == 'Progress') {
      statusBgColor = colorInfo;
    }
    else if(widget.task.status == 'Completed') {
      statusBgColor = colorGreen;
    }
    else if(widget.task.status == 'Cancelled') {
      statusBgColor = colorRed;
    }

    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
        side: BorderSide(
          color: colorAss,
        )
      ),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.task.title ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
            const SizedBox(height: 4,),
            Text(widget.task.description ?? ''),
            const SizedBox(height: 4,),
            Text("Date: ${widget.task.createdDate}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    widget.task.status ?? '',
                    style: const TextStyle(color: colorWhite),
                  ),
                  backgroundColor: statusBgColor,
                ),
                Wrap(
                  children: [
                    IconButton(
                      onPressed: () {
                        showUpdateStatusModal(widget.task.status ?? '');
                      },
                      icon: const Icon(Icons.edit_calendar_rounded, color: colorGreen,),
                    ),
                    IconButton(
                      onPressed: () {
                        deleteTaskItem(widget.task.sId ?? '');
                      },
                      icon: const Icon(
                        Icons.delete_forever_outlined,
                        color: colorRed,
                      ),
                    ),

                  ],
                )
              ],
            )
          ],
        ),
      ),
    );

  }

  void showUpdateStatusModal(String status) {

    List<Container> items = TaskStatus.values.map((e) => Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      child: ListTile(
        onTap: () {
          updateTaskStatus(e.name);
          Navigator.pop(context);
        },
        tileColor: status == e.name ? colorGreen : colorWhite,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: status != e.name ? colorGray : colorGreen),
        ),
        trailing:  status == e.name ? Icon(Icons.check, size: 30, color: status == e.name ? colorWhite : colorBlack,) : null,
        title: Text(e.name, style:  TextStyle(fontSize: 20, color: status == e.name ? colorWhite : colorBlack)),
      ),
    )).toList();


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Update Status",
            style: TextStyle(fontSize: 20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: items,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            )
          ],
        );
      },
    );
  }

}