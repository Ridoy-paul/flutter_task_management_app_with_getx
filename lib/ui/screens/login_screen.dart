import 'package:flutter/material.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/data_network_caller/network_response.dart';
import '../../data/models/user_model.dart';
import '../../data/utility/helpers.dart';
import '../../data/utility/urls.dart';
import '../controllers/auth_controller.dart';
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
  bool _loginInProgress = false;

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
                      child: Visibility(
                        visible: _loginInProgress == false,
                        replacement: circleProgressIndicatorShow(),
                        child: ElevatedButton(
                          onPressed: _loginUserConfirm,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40,),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen(),),);
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

  Future<void> _loginUserConfirm() async {
    if(_loginFormKey.currentState!.validate()) {
      _loginInProgress = true;
      if(mounted) {
        setState(() {});
      }

      NetworkResponse response = await NetworkCaller().postRequest(Urls.login, body: {
        "email": _emailTEController.text.trim(),
        "password": _passwordTEController.text,
      }, isLogin: true);

      _loginInProgress = false;
      if(mounted) {
        setState(() {});
      }

      if(response.isSuccess) {
        await AuthController.saveUserInformation(response.jsonResponse['token'], UserModel.fromJson(response.jsonResponse['data']),);
        if(mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainBottomNavScreen(),
            ),
          );
        }
      }
      else {
        if(response.statusCode == 401) {
          if(mounted) {
            showSnackMessage(context, "Please check email or password!", true);
          }
        }
        else {
          if(mounted) {
            showSnackMessage(context, "Login Failed! Please try again.", true);
          }
        }
      }

    }
  }


  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }


}
