import 'package:flutter/material.dart';
import '../controllers/reset_password_controller.dart';
import 'package:get/get.dart';
import '../../data/utility/helpers.dart';
import '../widgets/snack_message.dart';
import 'login_screen.dart';
import '../style.dart';
import '../widgets/body_background_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen(
      {super.key, required this.email, required this.code});

  final String email;
  final String code;

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  final GlobalKey<FormState> _resetPasswordGlobalKey = GlobalKey<FormState>();
  final ReSetPasswordController _reSetPasswordController = Get.find<ReSetPasswordController>();

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
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
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
                      validator: (value) =>
                          inputValidate(value, "Enter your password!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: inputStyle("Confirm Password"),
                      validator: (value) =>
                          inputValidate(value, "Confirm Your Password!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<ReSetPasswordController>(builder: (controller) {
                        return Visibility(
                          visible: !controller.resetPasswordInProgressStatus,
                          replacement: circleProgressIndicatorShow(),
                          child: ElevatedButton(
                            onPressed: _resetPassword,
                            child: const Text(
                              "Confirm", style: TextStyle(fontSize: 16),),
                          ),
                        );
                      }),
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
                              Get.to(const LoginScreen());
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

  Future<void> _resetPassword() async {
    if (!_resetPasswordGlobalKey.currentState!.validate()) {
      return;
    }

    final response = await _reSetPasswordController.resetPasswordConfirm(
        widget.email,
        widget.code,
        _passwordTEController.text,
        _confirmPasswordTEController.text
    );

    showSnackMessage(_reSetPasswordController.message, _reSetPasswordController.successStatus);

    if (response) {
      Get.to(const LoginScreen());
    }
  }
}
