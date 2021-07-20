import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:bjj_library/home.dart';
import 'package:get/get.dart';


class LoginScreen extends StatefulWidget{
	@override
	_LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen>{

  final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 1), () {
      controller.success();
      Get.to(HomeScreen());
    });
  }


	@override
	Widget build(BuildContext context){
		return Scaffold(
			body: Container(
				alignment: Alignment.center,
        color: Color(0xffffffff),
				child: ListView(
         	children: [
						Container(
							margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.13),
							height: MediaQuery.of(context).size.height*0.28,
							child: Image.asset('assets/images/workout.jpg'),
						),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.06),
              child: Column (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height*0.50,
                    child: Card(
                      elevation: 0.3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height*0.08,
                            margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width*0.06,
                              vertical: MediaQuery.of(context).size.height*0.0113
                            ),
                            child: TextField(
                              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blue[50],
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none
                                ),
                                hintText: "Nom d'utilisateur",
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.blue
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.06),
                            height: MediaQuery.of(context).size.height*0.08,
                            child: TextField(
                              style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blue[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                  borderSide: BorderSide.none
                                ),
                                hintText: "Mot de passe",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.blue
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.5,
                            margin: EdgeInsets.only(
                              top:MediaQuery.of(context).size.height*0.02, 
                            ),
                            child: Text(
                              "Contactez l'admin si vous avez oublié votre mot de passe.", textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[400], fontFamily: "ProductSans", fontSize: 14, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal:MediaQuery.of(context).size.width*0.06,
                              vertical:MediaQuery.of(context).size.height*0.03
                            ),
                            child: RoundedLoadingButton(
                              color: Colors.blue[400],
                              successColor: Colors.blue,
                              controller: _btnController,
                              onPressed: () => _doSomething(_btnController),
                              valueColor: Colors.white,
                              borderRadius: 90,
                              child: Text("SE CONNECTER", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                ]
              ) 
            )
					],
				),
			),
		);
	}
} 