import 'package:flutter/material.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/urls.dart';
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
  bool _createInProgressStatus = false;

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
                              style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            controller: _subjectTEController,
                            keyboardType: TextInputType.text,
                            decoration: inputStyle("Subject"),
                            validator: (value) => inputValidate(value, "Please Enter The Subject!"),
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
                            validator: (value) => inputValidate(value, "Description is required!"),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Visibility(
                              visible: _createInProgressStatus == false,
                              replacement: circleProgressIndicatorShow(),
                              child: ElevatedButton(
                                onPressed: createTask,
                                child: const Icon(Icons.arrow_circle_right_outlined),
                              ),
                            ),
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
    if(_addNewTaskFormKey.currentState!.validate()) {
      _createInProgressStatus = true;
      if(mounted) {
        setState(() {});
      }
      final NetworkResponse  response = await NetworkCaller().postRequest(Urls.createTask, body: {
        "title": _subjectTEController.text.trim(),
        "description": _descriptionTEController.text.trim(),
        "status": "New",
      });

      _createInProgressStatus = false;

       if(mounted) {
         setState(() {});
       }

       if(response.isSuccess) {
         _subjectTEController.clear();
         _descriptionTEController.clear();
         if(mounted) {
           showSnackMessage(context, "New Task Created.");
         }
       }
       else {
         if(mounted) {
           showSnackMessage(context, "Something is wrong, Please try again!", true);
         }
       }
      
    }
  }

  @override
  void dispose() {
    _subjectTEController.dispose();
    _descriptionTEController.dispose();
    super.dispose();
  }

}
