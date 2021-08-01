import 'package:bjj_library/model/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserController extends GetxController {
  final GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();
  late TextEditingController emailController, passwordController;
  String email = '';
  String password = '';
  bool valid = false;
  late User user;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  String? checkEmail(String value) {
    if (!GetUtils.isEmail(value)) return "Email Invalide";
    return null;
  }

  String? checkPassword(String value) {
    if (value.length < 6) return "Mot de passe trop court";
    return null;
  }

  void checkLogin() {
    valid = false;
    final isValid = loginFormkey.currentState!.validate();

    if (!isValid) return;
    loginFormkey.currentState!.save();
    valid = true;
  }

  void forceUpdate() {
    update();
  }
}
