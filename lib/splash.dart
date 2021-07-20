import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shimmer/shimmer.dart';


class SplashScreen extends StatefulWidget{
	@override
	_SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen>{
	@override
	Widget build(BuildContext context){
		return Scaffold(
			body: Container(
				alignment: Alignment.center,
				color: Colors.white,
				child: Column(
					children: [
						Container(
							margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.26),
							height: MediaQuery.of(context).size.height*0.375,
							child: CircleAvatar(
                radius : 85,
                backgroundImage : AssetImage('assets/images/logo.jpg')
              )
						),
						Container(
							margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.275),
							child:Shimmer.fromColors(
								baseColor: Color(0x99999999),
								highlightColor: Colors.blue[600],
								period: Duration(seconds: 2),
								child: Container(
									child: Text(
										"BJJ-Library",
										style: TextStyle(
											fontSize: 16,
											fontFamily: "ProductSans",
										),
									),
								)
							)
						)
					],
				),
			),
		);
	}
} 