import 'package:bjj_library/model/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  GlobalKey<FormState> loginFormkey = GlobalKey<FormState>();
  late TextEditingController emailController, passwordController, emailAccountController;
  late TextEditingController newPassController, oldPassController, codeController;
  String email = '';
  String password = '';
  bool valid = false;
  late User user;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailAccountController = TextEditingController();
    oldPassController = TextEditingController();
    newPassController = TextEditingController();
    codeController = TextEditingController();
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
}
