import 'package:flutter/material.dart';
import '../controllers/forgot_password_email_verify_controller.dart';
import 'package:get/get.dart';
import '../../data/utility/helpers.dart';
import '../widgets/snack_message.dart';
import 'login_screen.dart';
import 'pin_verification_screen.dart';
import '../style.dart';
import '../widgets/body_background_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();
  final ForgotPasswordEmailVerifyController _forgotPasswordEmailVerifyController = Get
      .find<ForgotPasswordEmailVerifyController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyBackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _forgotPasswordFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Your Email Address",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      "A 6 digit verification pin will send to your email address",
                      style: TextStyle(
                        color: colorGray,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputStyle("Email"),
                      validator: (value) =>
                          inputValidate(value, "Email is required!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<ForgotPasswordEmailVerifyController>(builder: (forgotPasswordEmailVerifyController) {
                        return Visibility(
                          visible: !forgotPasswordEmailVerifyController.forgotPasswordInProgressStatus,
                          replacement: circleProgressIndicatorShow(),
                          child: ElevatedButton(
                            onPressed: () {
                              forgotPasswordSubmit();
                            },
                            child: const Icon(
                                Icons.arrow_circle_right_outlined),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 48,),
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

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }

  Future<void> forgotPasswordSubmit() async {
    if (!_forgotPasswordFormKey.currentState!.validate()) {
      return;
    }

    final response = await _forgotPasswordEmailVerifyController
        .forgotPasswordConfirm(_emailTEController.text.trim());

    showSnackMessage(_forgotPasswordEmailVerifyController.message,
        _forgotPasswordEmailVerifyController.successStatus);
    if (response) {
      Get.to(PinVerificationScreen(email: _emailTEController.text.trim(),));
    }
  }
}
