import 'package:flutter/material.dart';
import 'package:bjj_library/splash.dart';
import 'package:bjj_library/login.dart';
import 'package:get/get.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget{
	@override
	Widget build(BuildContext context){
    Future.delayed(const Duration(milliseconds: 3000), () {
      Get.to(LoginScreen());
    });
		return GetMaterialApp(
			theme: ThemeData(
				primarySwatch: Colors.teal,
				fontFamily: "ProductSans",
			),
			debugShowCheckedModeBanner: false,
			home: SplashScreen(),
		);
	}
}