import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';
import 'dart:async';


class HomeScreen extends StatefulWidget{
	@override
	_HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{

    final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 2), () {
      controller.success();
      Navigator.pop(context);
    });
  }

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
        child: ListView(
          children: [
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.03,
                    left: MediaQuery.of(context).size.width*0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.04,
                          bottom: MediaQuery.of(context).size.height*0.005,
                        ),
                        child: Text(
                          "Musculation",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                        ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Stack(
                                children:[
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.23,
                                    width: MediaQuery.of(context).size.width*0.33,
                                    child: Card(
                                      elevation: 1.5,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child:Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:MediaQuery.of(context).size.width*0.09,
                                      vertical:MediaQuery.of(context).size.height*0.07
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_sharp,
                                      color: Colors.teal[400],
                                      size: 40,
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width*0.20
                                    ),
                                    child: PopupMenuButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.more_vert, color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) => SimpleDialog(
                                                      title : Text(
                                                        "Modification d'une vidéo", 
                                                      ),
                                                      children:[
                                                        Container(
                                                          height: MediaQuery.of(context).size.height*0.08,
                                                          margin: EdgeInsets.symmetric(
                                                            horizontal: MediaQuery.of(context).size.width*0.06,
                                                            vertical: MediaQuery.of(context).size.height*0.0113
                                                          ),
                                                          child:TextField(
                                                            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.teal[50],
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                borderSide: BorderSide.none
                                                              ),
                                                              focusedBorder: UnderlineInputBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                borderSide: BorderSide.none
                                                              ),
                                                              hintText: "Titre",
                                                              prefixIcon: Icon(
                                                                Icons.edit,
                                                                color: Colors.teal
                                                              ),
                                                            ),
                                                          )
                                                        ),
                                                        Container(
                                                          height: MediaQuery.of(context).size.height*0.08,
                                                          margin: EdgeInsets.symmetric(
                                                            horizontal: MediaQuery.of(context).size.width*0.06,
                                                            vertical: MediaQuery.of(context).size.height*0.0113
                                                          ),
                                                          child:TextField(
                                                            style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                                            decoration: InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors.teal[50],
                                                              border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                borderSide: BorderSide.none
                                                              ),
                                                              focusedBorder: UnderlineInputBorder(
                                                                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                borderSide: BorderSide.none
                                                              ),
                                                              hintText: "Module",
                                                              prefixIcon: Icon(
                                                                Icons.edit,
                                                                color: Colors.teal
                                                              ),
                                                            ),
                                                          )
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.symmetric(
                                                            horizontal:MediaQuery.of(context).size.width*0.06,
                                                            vertical:MediaQuery.of(context).size.height*0.03
                                                          ),
                                                          child: RoundedLoadingButton(
                                                            color: Colors.teal[400],
                                                            successColor: Colors.teal,
                                                            controller: _btnController,
                                                            onPressed: () {_doSomething(_btnController);} ,
                                                            valueColor: Colors.white,
                                                            borderRadius: 90,
                                                            child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  );
                                                },
                                                child: Text(
                                                  "Modifier",
                                                  style: TextStyle(color: Colors.black),
                                                )
                                              )
                                            ]
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline, color: Colors.red),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) => AlertDialog(
                                                      title: const Text("Suppression d'une vidéo"),
                                                      content: const Text('Voulez-vous vraiment supprimer cette vidéo ?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, 'Annuler'),
                                                          child: const Text('Annuler'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () => Navigator.pop(context, 'OK'),
                                                          child: const Text('OK'),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Supprimer",
                                                  style: TextStyle(color: Colors.red),
                                                )
                                              )
                                            ]
                                          ),
                                        )
                                      ]
                                    )
                                  )
                                ]
                              ),
                              Stack(
                                children:[
                                  Container(
                                    height: MediaQuery.of(context).size.height*0.23,
                                    width: MediaQuery.of(context).size.width*0.33,
                                    child: Card(
                                      elevation: 1.5,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child:Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                                      )
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal:MediaQuery.of(context).size.width*0.09,
                                      vertical:MediaQuery.of(context).size.height*0.07
                                    ),
                                    child: Icon(
                                      Icons.play_arrow_sharp,
                                      color: Colors.teal[400],
                                      size: 40,
                                    )
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width*0.20
                                    ),
                                    child: PopupMenuButton(
                                      icon: Icon(Icons.more_vert, color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 1,
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit),
                                              Text("Modifier")
                                            ]
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 2,
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete_outline, color: Colors.red),
                                              Text(
                                                "Supprimer",
                                                style: TextStyle(color: Colors.red),
                                              )
                                            ]
                                          ),
                                        )
                                      ]
                                    )
                                  )
                                ]
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ],
                          )
                        )
                      )
                    ],
                  )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.03,
                    left: MediaQuery.of(context).size.width*0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.04,
                          bottom: MediaQuery.of(context).size.height*0.005,
                        ),
                        child: Text(
                          "Abdomino",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                        ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ],
                          )
                        )
                      )
                    ],
                  )
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.03,
                    left: MediaQuery.of(context).size.width*0.02,
                  ),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.04,
                          bottom: MediaQuery.of(context).size.height*0.005,
                        ),
                        child: Text(
                          "Traction",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                        ),
                      ),
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                              Container(
                                height: MediaQuery.of(context).size.height*0.23,
                                width: MediaQuery.of(context).size.width*0.35,
                                child: Card(
                                  elevation: 1.5,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                ),
                              ),
                            ],
                          )
                        )
                      )
                    ],
                  )
                ),
              ]
            )
          ]
        ),
			),
      bottomNavigationBar: BottomBarWithSheet(
        disableMainActionButton : true,
        selectedIndex: 0,
        sheetChild: Center(child: Text("Place for your another content")),
        bottomBarTheme: BottomBarTheme(
          mainButtonPosition: MainButtonPosition.left,
          selectedItemBackgroundColor: Colors.teal[400],
          itemIconColor: Colors.grey[600],
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.teal[400]
        ),
        onSelectItem: (index) => print('item $index was pressed'),
        items: [
          BottomBarWithSheetItem(icon: Icons.people, label: "Tous"),
          BottomBarWithSheetItem(icon: Icons.shopping_cart, label: "Muscu"),
          BottomBarWithSheetItem(icon: Icons.settings, label: "Abdomino"),
          BottomBarWithSheetItem(icon: Icons.favorite, label: "Traction"),
        ],
      ),
		);
	}
} 