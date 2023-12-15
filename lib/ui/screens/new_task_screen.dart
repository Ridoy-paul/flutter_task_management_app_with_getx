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
}
