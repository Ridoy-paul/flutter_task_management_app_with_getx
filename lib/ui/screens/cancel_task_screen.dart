import 'package:flutter/material.dart';
import '../widgets/task_screen_widget.dart';

class CancelTaskScreen extends StatefulWidget {
  const CancelTaskScreen({super.key});

  @override
  State<CancelTaskScreen> createState() => _CancelTaskScreenState();
}

class _CancelTaskScreenState extends State<CancelTaskScreen> {

  @override
  Widget build(BuildContext context) {
    return const TaskScreen(taskType: "Cancelled");
  }
}
