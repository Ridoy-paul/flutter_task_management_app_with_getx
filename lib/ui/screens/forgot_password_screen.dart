import 'package:flutter/material.dart';
import '../../data/data_network_caller/network_caller.dart';
import '../../data/utility/helpers.dart';
import '../../data/utility/urls.dart';
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

  bool _forgotPasswordInProgressStatus = false;

  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();

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
                      style: Theme.of(context).textTheme.titleLarge,
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
                      validator: (value) => inputValidate(value, "Email is required!"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: !_forgotPasswordInProgressStatus,
                        replacement: circleProgressIndicatorShow(),
                        child: ElevatedButton(
                          onPressed: () {
                            forgotPasswordSubmit();
                          },
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),
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
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),),);
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
    if(_forgotPasswordFormKey.currentState!.validate()) {

      _forgotPasswordInProgressStatus = true;
      if (mounted) {
        setState(() {});
      }

      final response = await NetworkCaller().getRequest(Urls.recoveryVerifyEmail(_emailTEController.text.trim()));
      if(response.isSuccess) {
        if(response.jsonResponse['status'] == 'success') {
          if(mounted) {
            showSnackMessage(context, '6 digit verification code sent your email.');
            Navigator.push(context, MaterialPageRoute(builder: (context) => PinVerificationScreen(email: _emailTEController.text.trim(),),),);
          }
        }
        else {
          if(mounted) {
            showSnackMessage(context, response.jsonResponse['data'], true);
          }
        }
      }
      else {
        if(mounted) {
          showSnackMessage(context, "Something is error! Please try again.", true);
        }
      }

      _forgotPasswordInProgressStatus = false;
      if (mounted) {
        setState(() {});
      }

    }
  }



}
