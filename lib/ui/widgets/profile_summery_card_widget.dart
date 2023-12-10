import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/login_screen.dart';
import '../style.dart';

class ProfileSummery extends StatefulWidget {
  const ProfileSummery({
    super.key,
    this.enableOnTap = true,
  });

  final bool enableOnTap;

  @override
  State<ProfileSummery> createState() => _ProfileSummeryState();
}

class _ProfileSummeryState extends State<ProfileSummery> {
  @override
  Widget build(BuildContext context) {

    Uint8List imageBytes = const Base64Decoder().convert(AuthController.user?.photo ?? '');

    return ListTile(
      onTap: () {
        if(widget.enableOnTap) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen(),),);
        }
      },
      leading: CircleAvatar(
        child: AuthController.user?.photo == null
            ? const Icon(Icons.person)
            : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.memory(imageBytes, fit: BoxFit.cover,),
              ),
      ),
      title: Text(
        fullName,
        style: const TextStyle(color: colorWhite, fontWeight: FontWeight.w700),
      ),
      subtitle: Text(AuthController.user?.email ?? '', style: const TextStyle(color: colorWhite),),
      trailing: IconButton(
        onPressed: () async{
          await AuthController.clearAuthData();
          if(mounted) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
          }
        },
        color: colorWhite,
        icon: const Icon(Icons.logout),
      ),
      tileColor: colorGreen,
    );
  }

  // Get the full name from AuthController
  String get fullName {
    return '${AuthController.user?.firstName ?? ''} ${AuthController.user?.lastName ?? ''}';
  }

}
