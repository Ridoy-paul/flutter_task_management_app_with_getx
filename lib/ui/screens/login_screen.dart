import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'package:get/get.dart';
import '../../data/utility/helpers.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';
import '../style.dart';
import '../widgets/snack_message.dart';
import '../widgets/body_background_widget.dart';
import 'main_bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final LoginController _loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyBackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "Get Started With",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: inputStyle("Email"),
                      validator: (value) => inputValidate(value, "Please enter the email!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      obscureText: true,
                      decoration: inputStyle("Password"),
                      validator: (value) => inputValidate(value, "Enter the password!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<LoginController>(
                        builder: (loginController) {
                          return Visibility(
                            visible: !loginController.loginInProgress,
                            replacement: circleProgressIndicatorShow(),
                            child: ElevatedButton(
                              onPressed: _login,
                              child: const Icon(Icons.arrow_circle_right_outlined),
                            ),
                          );
                        }
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Get.to(const ForgotPasswordScreen());
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              color: Colors.green.shade300, fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account?",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: colorGray,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(const SignUpScreen());
                            },
                            child: Text(
                              "Sign up",
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


  Future<void> _login() async {
    if (!_loginFormKey.currentState!.validate()) {
      return;
    }

    final response = await _loginController.loginUserConfirm(
        _emailTEController.text.trim(), _passwordTEController.text);

    if (response) {
      Get.offAll(const MainBottomNavScreen());
    }
    else {
      showSnackMessage(_loginController.message, _loginController.errorStatus);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
