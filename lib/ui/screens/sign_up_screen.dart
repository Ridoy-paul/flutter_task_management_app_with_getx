import 'package:flutter/material.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/utility/urls.dart';
import 'login_screen.dart';
import '../style.dart';
import '../widgets/snack_message.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/helpers.dart';
import '../widgets/body_background_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  bool _signUpInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyBackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _signUpFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                        "Join With Us",
                        style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputStyle("Email"),
                      validator: (value) => inputValidate(value, "Please Enter Your Email!"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _firstNameTEController,
                      keyboardType: TextInputType.text,
                      decoration: inputStyle("First Name"),
                      validator: (value) => inputValidate(value, "Please Enter Your First Name!"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _lastNameTEController,
                      keyboardType: TextInputType.text,
                      decoration: inputStyle("Last Name"),
                      validator: (value) => inputValidate(value, "Please Enter Your Last Name"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _mobileTEController,
                      keyboardType: TextInputType.phone,
                      decoration: inputStyle("Mobile"),
                      validator: (value) => inputValidate(value, "Please Enter Your Mobile Number"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: inputStyle("Password"),
                      validator: (value) {
                        if(value?.isEmpty ?? true) {
                          return "Please Enter Your Password";
                        }
                        if(value!.length < 6) {
                          return "Enter Password more than 6 letter";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility( /// This widget used for Visibility replacement..
                        visible: _signUpInProgress == false,
                        replacement: circleProgressIndicatorShow(),
                        child: ElevatedButton(
                          onPressed: _signUp ,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         const Text("Already have an account?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colorGray),),
                          TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.green.shade300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_signUpFormKey.currentState!.validate()) {
      /// This is used for circle progress enable after submit
      _signUpInProgress = true;
      if (mounted) {
        setState(() {});
      }
      ///--End---------->>>>>>>>>>>>>>>>>>>>

      /// This is used for POST request to server
      final NetworkResponse response =
          await NetworkCaller().postRequest(Urls.registration, body: {
        "email": _emailTEController.text.trim(),
        "firstName": _firstNameTEController.text.trim(),
        "lastName": _lastNameTEController.text.trim(),
        "mobile": _mobileTEController.text.trim(),
        "password": _passwordTEController.text,
      });

      ///----End--------------->>>>>>>>>>>>>>>>>

      /// This is used for circle progress disable after submit
      _signUpInProgress = false;
      if (mounted) {
        setState(() {});
      }
      ///---End----------------------->>>>>>>>>>>>>>>>>>>>

      if (response.isSuccess) {
        _clearTextFields();
        if (mounted) {
          showSnackMessage(context, 'Account created successfully!');
        }
      } else {
        if (mounted) {
          showSnackMessage(
              context, 'Account creation failed! Please try again.', true,
          );
        }
      }
    }
  }

  void _clearTextFields() {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

}
