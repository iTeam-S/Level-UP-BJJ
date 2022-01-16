// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restart_app/restart_app.dart';



class StripeService{

  final AppController appController = Get.put(AppController());
  final UserController userController = Get.put(UserController());


  String calculAmount(int amount) {
      int price = amount*100;
      return price.toString();
  }


  Future<Map> createPayementIntent(int amount, String currency) async {
    Map<String, dynamic> body = {
      'amount': calculAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card'
    };
    var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': "Bearer ${dotenv.env['STRIPE_SECRET']!}",
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      return jsonDecode(response.body);

  }


  Future<void> makepayement() async {
    try {
       Map payementDataIntent = await createPayementIntent(19, 'EUR');
       await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: payementDataIntent['client_secret'],
              // applePay: true,
              googlePay: true,
              //testEnv: true,
              style: ThemeMode.light,
              merchantCountryCode: 'EUR',
              merchantDisplayName: 'Mojahed Naïm')).then((value){
      });
      // print(payementDataIntent['client_secret']);
      displayPaymentSheet(payementDataIntent);

    }catch (err){
      print("ERREUR: $err");
    }

    
   
  }

  displayPaymentSheet(payementDataIntent) async {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
            clientSecret: payementDataIntent['client_secret'],
            confirmPayment: true,
          )).then((newValue) async{

        appController.succesSnack("Payement avec succès");
        // lance le chargement
        appController.chargement();
        var res = await appController.createAccount(userController.emailAccountController.text, payementDataIntent['id']);
        if (res == true){
          // compte créee avec succes
          // ouverture du nouveau dialog
          Get.defaultDialog(
            title: 'Information',
            middleText: "Votre mot de passe a été envoyé via mail.",
              backgroundColor:  Colors.white,
            titleStyle: TextStyle(color: Colors.lightBlue[800]),
            middleTextStyle: TextStyle(color: Colors.black),
            confirm: TextButton(onPressed: () {  Restart.restartApp(webOrigin: '/');}, child: Text('OK')),
          );
          }
      });/*.onError((error, stackTrace){
        print('Exception/DISPLAYPAYMENTSHEET0==> $error $stackTrace');
      });


    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET1==> $e');
       Get.defaultDialog(
          title: 'Information',
          middleText: "Payement Annulé",
          backgroundColor:  Colors.white,
          titleStyle: TextStyle(color: Colors.lightBlue[800]),
          middleTextStyle: TextStyle(color: Colors.black),
        );
      /*showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Text("Cancelled "),
          )); */
    } catch (e) {
      print('$e');
    }*/
  }


}