import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget{
	@override
	_HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{
	@override
	Widget build(BuildContext context){
		return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Colors.teal[400],
        title: Text(
          'BJJ-Library',
          style: TextStyle(color: Colors.white, fontFamily: "ProductSans", fontSize: 17)
        ),
        centerTitle: true, 
        actions: [
          Stack(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height*0.017,
                  right: MediaQuery.of(context).size.height*0.02
                ),
                child:Icon(Icons.notifications_sharp),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height*0.018,
                right: MediaQuery.of(context).size.height*0.02,
                child: Icon(Icons.brightness_1, size: 10, color: Colors.red),
              )
            ]
          ), 
        ] ,
        actionsIconTheme: IconThemeData(color: Colors.white, size: 21),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/cover.jpg', 
                  width: MediaQuery.of(context).size.width, 
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.048,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.1,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/avatar.jpg'),
                        )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.1,
                        ),
                        child: Text(
                          'landry.apsa@gmail.com',
                          style: TextStyle(fontSize: 20, color: Colors.white)
                        )
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.1,
                        ),
                        child: Text(
                          'Administrateur',
                          style: TextStyle(fontSize: 14, color: Colors.white54,)
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.73,
              child:Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  Column(
                    children:[
                      ListTile(
                        leading: Icon(Icons.video_collection_outlined, color: Colors.teal[400]),
                        title: Text("Vidéos"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.settings, color: Colors.teal[400]),
                        title: Text("Administrations"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout_outlined, color: Colors.teal[400]),
                        title: Text("Deconnexion"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ]
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      // top: MediaQuery.of(context).size.height*0.5,
                    ),
                    child: Text(
                      'BJJ-Library 0.0.1',
                      style: TextStyle(fontSize: 12),
                    ),
                  )
                ]
              )
            )
          ],
        ),
      ),
			body: Container(
				alignment: Alignment.center,
				color: Colors.cyan[50],
				child: Column(
					children: [
						Container(
							margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.25),
							height: MediaQuery.of(context).size.height*0.375,
							child:Image.asset('assets/images/logo.jpg')
						),
					],
				),
			),
		);
	}
} 