import 'package:flutter/material.dart';
import "package:flutter_svg/svg.dart";
import '../controllers/auth_controller.dart';
import 'login_screen.dart';
import 'main_bottom_nav_screen.dart';
import '../widgets/body_background_widget.dart';
import '../../utility/utility.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToLogin();
  }

  void goToLogin() async{
    final bool isLoggedIn = await AuthController.checkAuthState();

    Future.delayed(const Duration(seconds: 2)).then((value) => {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => isLoggedIn? const MainBottomNavScreen() : const LoginScreen()),
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BodyBackgroundWidget(
          child: Center(
            child: SvgPicture.asset(logo, width: 130,),
          ),
        ),
      ),
    );
  }
}
