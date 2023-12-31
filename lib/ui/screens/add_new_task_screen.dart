import 'package:flutter/material.dart';
import '../controllers/add_task_controller.dart';
import 'package:get/get.dart';
import '../widgets/snack_message.dart';
import '../../data/utility/helpers.dart';
import '../widgets/body_background_widget.dart';
import '../style.dart';
import '../widgets/profile_summery_card_widget.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final TextEditingController _subjectTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _addNewTaskFormKey = GlobalKey<FormState>();
  final AddTaskController _addTaskController = Get.find<AddTaskController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummery(),
            Expanded(
              child: BodyBackgroundWidget(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _addNewTaskFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Text(
                              "Add New Task",
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _subjectTEController,
                            keyboardType: TextInputType.text,
                            decoration: inputStyle("Subject"),
                            validator: (value) =>
                                inputValidate(
                                    value, "Please Enter The Subject!"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _descriptionTEController,
                            keyboardType: TextInputType.text,
                            maxLines: 8,
                            decoration: const InputDecoration(
                                hintText: "Description"
                            ),
                            validator: (value) =>
                                inputValidate(
                                    value, "Description is required!"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: GetBuilder<AddTaskController>(builder: (addTaskController) {
                              return Visibility(
                                visible: !_addTaskController.createInProgressStatus,
                                replacement: circleProgressIndicatorShow(),
                                child: ElevatedButton(
                                  onPressed: createTask,
                                  child: const Icon(Icons.arrow_circle_right_outlined),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// This function used to create new task
  Future<void> createTask() async {
    if (!_addNewTaskFormKey.currentState!.validate()) {
      return;
    }

    final response = await _addTaskController.createTaskConfirm(
        _subjectTEController.text.trim(), _descriptionTEController.text.trim());

    if (response) {
      _subjectTEController.clear();
      _descriptionTEController.clear();
    }

    showSnackMessage(_addTaskController.message, _addTaskController.successStatus);

  }

  @override
  void dispose() {
    _subjectTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }

}
