import 'package:flutter/material.dart';
import '../widgets/task_screen_widget.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  @override
  Widget build(BuildContext context) {
    return const TaskScreen(taskType: "Completed");
  }
}
