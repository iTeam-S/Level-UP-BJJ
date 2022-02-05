import 'dart:async';

import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/controller/app.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';

class ConfirmScreen extends StatefulWidget {
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

  int bruteForce = 0;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  // Instance ana controlleur
  UserController userController = Get.put(UserController());
  AppController appController = Get.put(AppController());
  final box = GetStorage();

  void _changepasswd(RoundedLoadingButtonController controller) async {
    if (userController.oldPassController.text.trim() == '' || userController.newPassController.text.trim() == ''){
      appController.errorSnack('Les champs doivent être remplis.');
      controller.reset();
    }
    else if(userController.oldPassController.text != userController.newPassController.text){
      appController.errorSnack('Le mot de passe ne correspond pas.');
      controller.reset();
    }
    else {
      var res = await appController.changepassword(userController.user, '', userController.newPassController.text);
      if (res == true){
        controller.success();
        Timer(Duration(seconds: 2), () {
          controller.reset();
          Get.back();
          appController.succesSnack('Mot de passe mise à jour');
          box.write('user', userController.user.toJson());
          box.save();
          Restart.restartApp(webOrigin: '/');
        });
      }
      else{
        appController.errorSnack("Ancien mot de passe incorrecte");
        controller.error();
        Timer(Duration(seconds: 2), () {
          controller.reset();
        });
      }
    }

  }

  void changePassword(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                "Changement de mot de passe",
              ),
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                        vertical: MediaQuery.of(context).size.height * 0.0113),
                    child: TextField(
                      controller: userController.oldPassController,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Nouveau mot de passe",
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: TextField(
                      controller: userController.newPassController,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Retaper le mot de passe",
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: RoundedLoadingButton(
                    color: Colors.lightBlue[800],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      _changepasswd(_btnController);
                    },
                    valueColor: Colors.white,
                    borderRadius: 90,
                    child: Text("ENREGISTRER",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Container(
            alignment: Alignment.center,
            color: Color(0xffffffff),
            child: ListView(
              children: [
                Container(
                  // color: Color(0xffd52d),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.14,
                      right: MediaQuery.of(context).size.width * 0.14,
                      top: MediaQuery.of(context).size.height * 0.24,
                  ),
                  width: MediaQuery.of(context).size.width *0.1,
                  child: Text(
                    "Code de confirmation",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: "ProductSans",
                        fontSize: 30,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
                Container(
                  // color: Color(0xffd52d),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.14,
                      right: MediaQuery.of(context).size.width * 0.14,
                      top: MediaQuery.of(context).size.height * 0.03,
                      bottom: MediaQuery.of(context).size.height * 0.03,
                  ),
                  width: MediaQuery.of(context).size.width *0.1,
                  child: Text(
                    "Veuillez entrer le code de confirmation que nous vous avons envoyé via votre adresse email.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: "ProductSans",
                        fontSize: 15,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              height: MediaQuery.of(context).size.height * 0.50,
                              child: Card(
                                  elevation: 0.0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13)),
                                  child: Form(
                                      // key: userController.loginFormkey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: Column(
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.08,
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.0113),
                                            child: TextFormField(
                                              controller: userController.codeController,
                                              onSaved: (value) {
                                                userController.email = value!;
                                              },
                                              //validator: (value) {
                                              //return userController
                                              //  .checkEmail(value!);
                                              // },
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[800]),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Colors.blue[50],
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.auto,
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                90.0)),
                                                    borderSide:
                                                        BorderSide.none),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    90.0)),
                                                        borderSide:
                                                            BorderSide.none),
                                                hintText: "Code de confirmation",
                                                prefixIcon: Icon(Icons.person,
                                                    color:
                                                        Colors.lightBlue[800]),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.06,
                                                vertical: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.03),
                                            child: RoundedLoadingButton(
                                              color: Colors.lightBlue[800],
                                              successColor: Colors.blue,
                                              controller: _btnController,
                                              onPressed: () async {
                                                if (bruteForce>=3){
                                                  Restart.restartApp(webOrigin: '/');
                                                }
                                                var res = await appController.verifCodeConfirmation(
                                                  userController.emailAccountController.text,
                                                  userController.codeController.text
                                                );
                                                if (res == true) changePassword(context);
                                                else {
                                                  appController.errorSnack("Code de confirmation incorrecte");
                                                  bruteForce++;
                                                }
                                                _btnController.reset();
                                              },
                                              valueColor: Colors.white,
                                              borderRadius: 90,
                                              child: Text("CONFIRMER",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            child: TextButton(
                                              onPressed : () async{
                                                var res = await appController.sendCodeConfirmation(userController.emailAccountController.text);
                                                if (res == true){
                                                  Get.toNamed('/confirm_pass');
                                                }else {
                                                  _btnController.error();
                                                }
                                              },
                                              child : Text("Réenvoyer le code",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: "ProductSans",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal
                                              ),
                                            )),
                                          ),
                                        ],
                                      )))),
                        ]))
              ],
            ),
          ),
        );
  }
}
