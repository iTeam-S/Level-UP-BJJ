import 'dart:async';

import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _ForgotScreenState createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

// Instance ana controlleur
  UserController userController = Get.put(UserController());
  ApiController apiController = Get.put(ApiController());
  final box = GetStorage();

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
              width: MediaQuery.of(context).size.width * 0.1,
              child: Text(
                "Mot de passe oublié",
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.grey[600],
                    fontFamily: "ProductSans",
                    fontSize: 30,
                    fontWeight: FontWeight.normal),
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
              width: MediaQuery.of(context).size.width * 0.1,

              child: Text(
                "Veuillez entrer votre adresse email pour recupérer votre compte.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "ProductSans",
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
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
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.08,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.06,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.0113),
                                        child: TextFormField(
                                           controller: userController
                                              .emailAccountController,
                                          onSaved: (value) {
                                            userController.email = value!;
                                          },
                                          validator: (value) {
                                          return userController
                                           .checkEmail(value!);
                                          },
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[800]),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.blue[50],
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(90.0)),
                                                borderSide: BorderSide.none),
                                            focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(90.0)),
                                                borderSide: BorderSide.none),
                                            hintText: "Votre adresse email",
                                            prefixIcon: Icon(Icons.person,
                                                color: Colors.lightBlue[800]),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
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
                                            var res = await appController.sendCodeConfirmation(userController.emailAccountController.text);
                                            if (res == true){
                                               Get.toNamed('/confirm_pass');
                                            }else {
                                              _btnController.error();
                                            }
                                            Timer(Duration(seconds: 2), () {
                                                _btnController.reset();
                                            });
                                           
                                          },
                                          valueColor: Colors.white,
                                          borderRadius: 90,
                                          child: Text("CONFIRMER",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        child: TextButton(
                                            onPressed: () {
                                               Restart.restartApp(webOrigin: '/');
                                            },
                                            child: Text(
                                              "Retourner à la page de connexion.",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: "ProductSans",
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight.normal),
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
