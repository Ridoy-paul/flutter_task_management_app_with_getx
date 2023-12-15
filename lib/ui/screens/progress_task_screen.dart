import 'package:flutter/material.dart';
import '../widgets/task_screen_widget.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  Widget build(BuildContext context) {
    return const TaskScreen(taskType: "Progress");
  }
}
