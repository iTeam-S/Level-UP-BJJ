import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/service/stripe.dart';
import 'package:bjj_library/view/payement.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class Renew extends StatefulWidget {
  @override
  _Renew createState() => _Renew();
}

class _Renew extends State<Renew> {


  // Instance ana controlleur
  UserController userController = Get.put(UserController());
  final box = GetStorage();
  // instance du service stripe
  StripeService stripeService = StripeService();


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
                    "Renouvellement",
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
                    "Votre abonnement est épuisé, pour pouvoir continuer, il faut passer au rénouvellement, Choisissez ci-dessous, votre moyen de paiement.",
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
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                
                                                Get.to( 
                                                  () => PaypalPayment(
                                                    onFinish: (payemntID) async {
                                                      print('order id: ' + payemntID);
                                                      Get.back();
                                                      appController.chargement();
                                                      var res = await appController.upgradeAccount(userController.user, payemntID);
                                                      if (res == true){
                                                        // renouveller avec succes
                                                        // fermeture du popup
                                                        Get.back();
                                                        // ouverture du nouveau dialog
                                                        Get.defaultDialog(
                                                          title: 'Information',
                                                          middleText: "Votre compte a été bien renouveller",
                                                            backgroundColor:  Colors.white,
                                                          titleStyle: TextStyle(color: Colors.lightBlue[800]),
                                                          middleTextStyle: TextStyle(color: Colors.black),
                                                          confirm: TextButton(onPressed: () {  Restart.restartApp(webOrigin: '/');}, child: Text('OK')),
                                                        );
                                                        }
                                                    }
                                                  )
                                                );

                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: MediaQuery.of(context).size.height * 0.00),
                                                height: MediaQuery.of(context).size.height * 0.05,
                                                child: Image.asset('assets/images/paypal.png'),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                
                                                appController.chargement();
                                                // lancement de le procedure du verification de l existance du mail
                                                stripeService.makepayement(true);
                                                
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    top: MediaQuery.of(context).size.height * 0.00),
                                                height: MediaQuery.of(context).size.height * 0.05,
                                                child: Image.asset('assets/images/visa.png'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))),
                        ]))
              ],
            ),
          ),
        );
  }
}
