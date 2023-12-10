import 'package:flutter/material.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/utility/helpers.dart';
import '../../data/utility/urls.dart';
import '../widgets/snack_message.dart';
import 'login_screen.dart';
import '../style.dart';
import '../widgets/body_background_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key, required this.email, required this.code});
  final String email;
  final String code;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  bool _resetPasswordInProgressStatus = false;
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _resetPasswordGlobalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyBackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _resetPasswordGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Set Password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      "Minimum length password 8 character with Latter and number combination",
                      style: TextStyle(
                        color: colorGray,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: inputStyle("Password"),
                      validator: (value) => inputValidate(value, "Enter your password!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: inputStyle("Confirm Password"),
                      validator: (value) => inputValidate(value, "Confirm Your Password!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !_resetPasswordInProgressStatus,
                        replacement: circleProgressIndicatorShow(),
                        child: ElevatedButton(
                          onPressed: _resetPasswordConfirm,
                          child: const Text("Confirm", style: TextStyle(fontSize: 16),),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: colorGray,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                            },
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.green.shade300, fontSize: 16,
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

  Future<void> _resetPasswordConfirm() async {
    if(_resetPasswordGlobalKey.currentState!.validate()) {
      if(mounted) {
        setState(() {
          _resetPasswordInProgressStatus = true;
        });
      }

      if (_passwordTEController.text != _confirmPasswordTEController.text) {
        showSnackMessage(context, "Password doesn't match!", true);
        _resetPasswordInProgressStatus = false;
        if (mounted) {
          setState(() {});
        }
      }

      final NetworkResponse response = await NetworkCaller().postRequest(Urls.recoveryPassword, body: {
          "email": widget.email,
          "OTP": widget.code,
          "password": _passwordTEController.text,
      });

      if(response.isSuccess) {
        if(response.jsonResponse['status'] == 'success') {
          if(mounted) {
            showSnackMessage(context, "New Password Set.");
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
          }
        }
        else {
          if(mounted) {
            showSnackMessage(context, "Something is error! Please try again.", true);
          }
        }
      }
      else {
        if(mounted) {
          showSnackMessage(context, "Something is error! Please try again.", true);
        }
      }

      if(mounted) {
        setState(() {
          _resetPasswordInProgressStatus = false;
        });
      }
    }
  }

}
