import 'package:flutter/material.dart';
import 'package:bjj_library/splash.dart';


void main() {
    runApp(MyApp());
}


class MyApp extends StatelessWidget{
	@override
	Widget build(BuildContext context){
		return MaterialApp(
			theme: ThemeData(
				primarySwatch: Colors.blue,
				fontFamily: "ProductSans",
			),
			debugShowCheckedModeBanner: false,
			home: SplashScreen(),
		);
	}
}