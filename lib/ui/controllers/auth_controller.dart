import 'dart:convert';
import 'package:get/get.dart';
import "package:shared_preferences/shared_preferences.dart";
import '../../data/models/user_model.dart';

class AuthController  extends GetxController{
  String? token;
  UserModel? user;


  Future<void> saveUserInformation(String t, UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', t);
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    token = t;
    user = model;
    update();
  }

  Future<void> updateUserInformation(UserModel model) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', jsonEncode(model.toJson()));
    user = model;
    update();
  }

  Future<void> initializeUserCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString('token');
    user = UserModel.fromJson(jsonDecode(sharedPreferences.getString('user') ?? '{}'));
    update();
  }

  Future<bool> checkAuthState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');
    if(token != null) {
      await initializeUserCache();
      return true;
    }
    return false;
  }

  Future<void> clearAuthData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
    token = null;
  }

}