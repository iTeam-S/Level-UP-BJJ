import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/view/payement.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class SignScreen extends StatefulWidget {
  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {


  // Instance ana controlleur
  UserController userController = Get.put(UserController());
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          body: Container(
            alignment: Alignment.center,
            color: Color(0xffffffff),
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.11),
                  height: MediaQuery.of(context).size.height * 0.28,
                  child: Image.asset('assets/images/workout.jpg'),
                ),
                Container(
                  // color: Color(0xffd52d),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.14,
                    right: MediaQuery.of(context).size.width * 0.14,
                    top: MediaQuery.of(context).size.height * 0.00,
                  ),
                  width: MediaQuery.of(context).size.width * 0.1,
                  child: Text(
                    "Inscription",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.lightBlue[800],
                        fontFamily: "ProductSans",
                        fontSize: 25,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  // color: Color(0xffd52d),
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.14,
                    right: MediaQuery.of(context).size.width * 0.14,
                    top: MediaQuery.of(context).size.height * 0.02,
                    bottom: MediaQuery.of(context).size.height * 0.03,
                  ),
                  width: MediaQuery.of(context).size.width * 0.1,

                  child: Text(
                    "Veuillez entrer votre adresse email et choisir votre mode de paiement pour vous inscrire.",
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
                                          controller: userController
                                              .emailAccountController,
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
                                            hintText: "Email",
                                            prefixIcon: Icon(Icons.mail,
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
                                                0.01),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                if (userController.checkEmail(userController.emailAccountController.text) != null)
                                                Get.snackbar(
                                                  "Erreur",
                                                  "L'adresse mail doit être remplis et correcte.",
                                                  colorText: Colors.white,
                                                  backgroundColor: Colors.red,
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  borderColor: Colors.red,
                                                  borderRadius: 10,
                                                  borderWidth: 2,
                                                  barBlur: 0,
                                                  duration: Duration(seconds: 2),
                                                );
                                                else
                                                Get.defaultDialog(
                                                    title: "Confirmation mail",
                                                    middleText:  "${userController.emailAccountController.text}",
                                                    backgroundColor:  Colors.white,
                                                    titleStyle: TextStyle(color: Colors.lightBlue[800]),
                                                    middleTextStyle: TextStyle(color: Colors.black),
                                                    cancel: TextButton(onPressed: (){Get.back();}, child: Text('Annuler')),
                                                    confirm: TextButton(
                                                      onPressed: (){
                                                        void  makePayement(){
                                                          Get.to( 
                                                            () => PaypalPayment(
                                                              onFinish: (number) async {
                                                                // payment done
                                                                print('PAYEMENT_SUCCESS');
                                                                print('order id: ' + number);
                                                              }
                                                            )                     
                                                          );
                                                        }
                                                        void verifMail() async {
                                                            var res = await appController.checkMail(userController.emailAccountController.text);
                                                            Get.back();
                                                            if (res == true)
                                                              makePayement();
                                                            else
                                                              Get.snackbar(
                                                                "Erreur",
                                                                "L'adresse mail est déjà utilisé.",
                                                                colorText: Colors.white,
                                                                backgroundColor: Colors.red,
                                                                snackPosition: SnackPosition.BOTTOM,
                                                                borderColor: Colors.red,
                                                                borderRadius: 10,
                                                                borderWidth: 2,
                                                                barBlur: 0,
                                                                duration: Duration(seconds: 2),
                                                              );
                                                        }
                                                        Get.bottomSheet(
                                                          Container(
                                                            margin: EdgeInsets.symmetric(
                                                              vertical: Get.height * 0.025,
                                                              horizontal: Get.width * 0.06,
                                                            ),
                                                            child: LinearProgressIndicator(
                                                              backgroundColor: Colors.grey,
                                                            )
                                                          )
                                                        );
                                                        verifMail();
                                                      },
                                                      child: Text('Valider'))
                                                  );

                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: MediaQuery.of(context).size.height * 0.00),
                                                height: MediaQuery.of(context).size.height * 0.06,
                                                child: Image.asset('assets/images/paypal.jpg'),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                  Get.defaultDialog(
                                                    title: "Bientôt",
                                                    middleText: "Pas encore disponible!",
                                                    backgroundColor: Colors.lightBlue[700],
                                                    titleStyle: TextStyle(color: Colors.white),
                                                    middleTextStyle: TextStyle(color: Colors.white)
                                                  );
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: MediaQuery.of(context).size.height * 0.00),
                                                height: MediaQuery.of(context).size.height * 0.10,
                                                child: Image.asset('assets/images/stripe.jpg'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      /*Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                            vertical: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01),
                                        child: 
                                          InkWell(
                                            onTap: () {
                                                Get.defaultDialog(
                                                  title: "Bientôt",
                                                  middleText: "Pas encore disponible!",
                                                  backgroundColor: Colors.lightBlue[700],
                                                  titleStyle: TextStyle(color: Colors.white),
                                                  middleTextStyle: TextStyle(color: Colors.white)
                                                );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height * 0.00),
                                              height: MediaQuery.of(context).size.height * 0.06,
                                              child: Image.asset('assets/images/visa.jpg'),
                                            ),
                                          ),
                                      ),*/
                                    ],
                                  ))),
                        ]))
              ],
            ),
          ),
        );
  }
}
