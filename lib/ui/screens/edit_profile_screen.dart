import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user_model.dart';
import '../widgets/snack_message.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/urls.dart';
import '../../data/utility/helpers.dart';
import '../controllers/auth_controller.dart';
import '../widgets/body_background_widget.dart';
import '../style.dart';
import '../widgets/profile_summery_card_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  XFile? photo;

  bool _updateProfileInProgressStatus = false;

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _updateProfileGlobalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.user?.email ?? '';
    _firstNameTEController.text = AuthController.user?.firstName ?? '';
    _lastNameTEController.text = AuthController.user?.lastName ?? '';
    _mobileTEController.text = AuthController.user?.mobile ?? '';
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ProfileSummery(
              enableOnTap: false,
            ),
            Expanded(
              child: BodyBackgroundWidget(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Form(
                    key: _updateProfileGlobalKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Text(
                          "Update Profile",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        photoPickerField(),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _emailTEController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputStyle("Email"),
                          validator: (value) => inputValidate(value, "Email is Required!"),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _firstNameTEController,
                          keyboardType: TextInputType.text,
                          decoration: inputStyle("First Name"),
                          validator: (value) => inputValidate(value, "First name is required!"),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _lastNameTEController,
                          keyboardType: TextInputType.text,
                          decoration: inputStyle("Last Name"),
                          validator: (value) => inputValidate(value, "last name is required!"),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _mobileTEController,
                          keyboardType: TextInputType.phone,
                          decoration: inputStyle("Mobile"),
                          validator: (value) => inputValidate(value, "Phone number is required!"),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: _passwordTEController,
                          obscureText: true,
                          decoration: inputStyle("Password (optional)"),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Visibility(
                            visible: !_updateProfileInProgressStatus,
                            replacement: circleProgressIndicatorShow(),
                            child: ElevatedButton(
                              onPressed: updateUserProfile,
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
          ],
        ),
      ),
    );
  }

  Future<void> updateUserProfile() async {
    if(!_updateProfileGlobalKey.currentState!.validate()) {
      return;
    }

    _updateProfileInProgressStatus = true;
    if (mounted) {
      setState(() {});
    }

    String? photoInBase64;

    Map<String, dynamic> inputData = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if(_passwordTEController.text.isNotEmpty) {
      inputData['password'] = _passwordTEController.text;
    }

    if(photo != null) {
      List<int> imageBytes = await photo!.readAsBytes();
      photoInBase64 = base64Encode(imageBytes);
      inputData['photo'] = photoInBase64;
    }

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.profileUpdate, body: inputData,);

    _updateProfileInProgressStatus = false;
    if (mounted) {
      setState(() {});
    }

    if(response.isSuccess) {
      AuthController.updateUserInformation(UserModel(
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _mobileTEController.text.trim(),
        photo: photoInBase64 ?? AuthController.user?.photo,
      ));

      if(mounted) {
        showSnackMessage(context, "Profile Updated.");
      }

    }
    else {
      if(mounted) {
        showSnackMessage(context, "Network Error! Please try again.", true);
      }
    }
  }



  Container photoPickerField() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: 50,
              decoration: const BoxDecoration(
                  color: colorGray,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              child: const Center(
                child: Text(
                  "Photos",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                      color: colorWhite),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () async {
                final XFile? image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 30);
                if(image != null) {
                  photo = image;
                  if(mounted) {
                    setState(() {});
                  }
                }
              },
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                child: Visibility(
                  visible: photo == null,
                  replacement: Text(photo?.name ?? ''),
                  child: const Text("Select a photo"),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
