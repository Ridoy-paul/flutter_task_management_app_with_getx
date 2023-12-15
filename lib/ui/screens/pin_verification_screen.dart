import 'package:flutter/material.dart';
import '../controllers/forgot_password_pin_verification_controller.dart';
import 'package:get/get.dart';
import '../widgets/snack_message.dart';
import '../../data/utility/helpers.dart';
import 'login_screen.dart';
import 'reset_password.dart';
import '../style.dart';
import "package:pin_code_fields/pin_code_fields.dart";
import '../widgets/body_background_widget.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
  final GlobalKey<FormState> _pinGlobalKey = GlobalKey<FormState>();
  final ForgotPasswordPinVerificationController _forgotPasswordPinVerificationController = Get
      .find<ForgotPasswordPinVerificationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyBackgroundWidget(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: _pinGlobalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    Text(
                      "PIN Verification",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      "A 6 digit verification pin sent to your email address",
                      style: TextStyle(
                        color: colorGray,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    PinCodeTextField(
                      controller: _pinTEController,
                      validator: (value) =>
                          inputValidate(
                              value, "Enter 6 digit verification code!"),
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        selectedFillColor: colorWhite,
                        inactiveFillColor: colorWhite,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      //errorAnimationController: errorController,

                      onCompleted: (v) {
                        //print("Completed");
                      },
                      onChanged: (value) {

                      },
                      beforeTextPaste: (text) {
                        //print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                      appContext: context,
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: GetBuilder<ForgotPasswordPinVerificationController>(builder: (controller) {
                        return Visibility(
                          visible: !controller.pinVerificationInProgressStatus,
                          replacement: circleProgressIndicatorShow(),
                          child: ElevatedButton(
                            onPressed: () {
                              confirmPinVerification();
                              //Navigator.push(context, MaterialPageRoute(builder: (context) => const ResetPasswordScreen() ));
                            },
                            child: const Text(
                              "Verify", style: TextStyle(fontSize: 16),),
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
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (
                                      context) => const LoginScreen()), (
                                      route) => false);
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


  Future<void> confirmPinVerification() async {
    if (!_pinGlobalKey.currentState!.validate()) {
      return;
    }

    final response = await _forgotPasswordPinVerificationController
        .pinVerificationConfirm(widget.email, _pinTEController.text);
    showSnackMessage(_forgotPasswordPinVerificationController.message,
        _forgotPasswordPinVerificationController.successStatus);
    if (response) {
      Get.to(ResetPasswordScreen(
        email: widget.email, code: _pinTEController.text,));
    }
  }

}
