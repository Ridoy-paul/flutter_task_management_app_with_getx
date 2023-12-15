import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {

    return GetBuilder<AuthController>(
        builder: (authController) {
          Uint8List imageBytes = const Base64Decoder().convert( _authController.user?.photo ?? '');
          return ListTile(
            onTap: () {
              if (widget.enableOnTap) {
                Get.to(const EditProfileScreen());
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen(),),);
              }
            },
            leading: CircleAvatar(
              child: _authController.user?.photo == null
                  ? const Icon(Icons.person)
                  : ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.memory(imageBytes, fit: BoxFit.cover,),
              ),
            ),
            title: Text(
              fullName,
              style: const TextStyle(
                  color: colorWhite, fontWeight: FontWeight.w700),
            ),
            subtitle: Text(_authController.user?.email ?? '',
              style: const TextStyle(color: colorWhite),),
            trailing: IconButton(
              onPressed: () async {
                await Get.find<AuthController>().clearAuthData();
                if (mounted) {
                  Get.offAll(const LoginScreen());
                }
              },
              color: colorWhite,
              icon: const Icon(Icons.logout),
            ),
            tileColor: colorGreen,
          );
        });
  }

  // Get the full name from AuthController
  String get fullName {
    return '${_authController.user?.firstName ?? ''} ${_authController.user
        ?.lastName ?? ''}';
  }

}
