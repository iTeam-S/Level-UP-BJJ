import 'package:flutter/material.dart';
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:get/get.dart';
import 'dart:async';


class ModuleScreen extends StatefulWidget{
	@override
	_ModuleScreenState createState() => _ModuleScreenState();
}


class _ModuleScreenState extends State<ModuleScreen>{

    final RoundedLoadingButtonController _btnController = RoundedLoadingButtonController();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 2), () {
      controller.success();
    });
  }

	@override
	Widget build(BuildContext context){
		return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Colors.teal[400],
        title: Text(
          'Course',
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
                          top: MediaQuery.of(context).size.height*0.01,
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
                        title: Text("Gestion des modules"),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.lock, color: Colors.teal[400]),
                        title: Text("Changer mot de passe"),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                              title : Text(
                                "Changement de mot de passe", 
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
                                      hintText: "Ancien mot de passe",
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.teal
                                      ),
                                    ),
                                  )
                                ),
                                Container(
                                  height: MediaQuery.of(context).size.height*0.08,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: MediaQuery.of(context).size.width*0.06,
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
                                      hintText: "Nouveau mot de passe",
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.teal
                                      ),
                                    ),
                                  )
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:MediaQuery.of(context).size.width*0.06,
                                    vertical:MediaQuery.of(context).size.height*0.01
                                  ),
                                  child: RoundedLoadingButton(
                                    color: Colors.teal[400],
                                    successColor: Colors.teal,
                                    controller: _btnController,
                                    onPressed: () {
                                      _doSomething(_btnController);
                                      Navigator.pop(context);
                                      Get.snackbar(
                                        "Modification",
                                        "Votre mot de passe a été modifié.",
                                        backgroundColor: Colors.grey,
                                        snackPosition: SnackPosition.BOTTOM,
                                        borderColor: Colors.grey,
                                        borderRadius: 10,
                                        borderWidth: 2,
                                        barBlur: 0,
                                        duration: Duration(seconds:2),
                                      );
                                    },
                                    valueColor: Colors.white,
                                    borderRadius: 90,
                                    child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            )
                          );
                        },
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.logout_outlined, color: Colors.teal[400]),
                        title: Text("Deconnexion"),
                        onTap: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: const Text("Deconnexion"),
                              content: const Text('Voulez-vous vraiment vous déconnecter ?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, 'Annuler'),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _doSomething(_btnController);
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ]
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'BJJ-Library 0.0.4',
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
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.04,
                    left: MediaQuery.of(context).size.width*0.0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children:[
                      Container(
                        height:MediaQuery.of(context).size.height*0.32,
                        width: MediaQuery.of(context).size.width*1,
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:MediaQuery.of(context).size.width*0.11,
                          vertical:MediaQuery.of(context).size.height*0.07
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.teal[400],
                          size: 40,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top:MediaQuery.of(context).size.height*0.24,
                          left:MediaQuery.of(context).size.width*0.82,
                        ),
                        child: PopupMenuButton(
                          color: Colors.white,
                          icon: Icon(Icons.more_horiz, color: Colors.white, size: 18),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: TextButton(
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
                                            vertical:MediaQuery.of(context).size.height*0.01
                                          ),
                                          child: RoundedLoadingButton(
                                            color: Colors.teal[400],
                                            successColor: Colors.teal,
                                            controller: _btnController,
                                            onPressed: () {
                                              _doSomething(_btnController);
                                              Navigator.pop(context);
                                              Get.snackbar(
                                                "Modification",
                                                "La vidéo a été bien modifiée.",
                                                backgroundColor: Colors.grey,
                                                snackPosition: SnackPosition.BOTTOM,
                                                borderColor: Colors.grey,
                                                borderRadius: 10,
                                                borderWidth: 2,
                                                barBlur: 0,
                                                duration: Duration(seconds:2),
                                              );
                                            } ,
                                            valueColor: Colors.white,
                                            borderRadius: 90,
                                            child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.black),
                                    Text(
                                      "Modifier",
                                      style: TextStyle(color: Colors.black)
                                    ),
                                  ],
                                )
                              )
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: TextButton(
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
                                          onPressed: () {
                                            _doSomething(_btnController);
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              "Suppression",
                                              "La vidéo a été bien supprimée.",
                                              backgroundColor: Colors.grey,
                                              snackPosition: SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds:2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children : [
                                    Icon(Icons.delete_outline, color: Colors.red),
                                    Text(
                                      "Supprimer",
                                      style: TextStyle(color: Colors.red)
                                    ),
                                  ]
                                ),
                              )
                            ),
                          ]
                        )
                      )
                    ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.002,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/video_logo.jpg'),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                        ),
                        child: Column(
                          children :[
                            Container(
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                // top: MediaQuery.of(context).size.height*0.01,
                              ),
                              child: Text(
                                'Comment avoir de la vitesse ?',
                                style: TextStyle(fontSize: 18, color: Colors.black)
                              )
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                              ),
                              child: TextButton(
                                onPressed: () { print("WLL") ;},
                                child:Row(
                                  children : [
                                    Icon(Icons.message_outlined, color: Colors.grey),
                                    Text(
                                      "10 commentaires",
                                      style: TextStyle(color: Colors.grey[700])
                                    ),
                                  ]
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Divider()
              ]
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.04,
                    left: MediaQuery.of(context).size.width*0.0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children:[
                      Container(
                        height:MediaQuery.of(context).size.height*0.32,
                        width: MediaQuery.of(context).size.width*1,
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:MediaQuery.of(context).size.width*0.11,
                          vertical:MediaQuery.of(context).size.height*0.07
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.teal[400],
                          size: 40,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top:MediaQuery.of(context).size.height*0.24,
                          left:MediaQuery.of(context).size.width*0.82,
                        ),
                        child: PopupMenuButton(
                          color: Colors.white,
                          icon: Icon(Icons.more_horiz, color: Colors.white, size: 18),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: TextButton(
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
                                            vertical:MediaQuery.of(context).size.height*0.01
                                          ),
                                          child: RoundedLoadingButton(
                                            color: Colors.teal[400],
                                            successColor: Colors.teal,
                                            controller: _btnController,
                                            onPressed: () {
                                              _doSomething(_btnController);
                                              Navigator.pop(context);
                                              Get.snackbar(
                                                "Modification",
                                                "La vidéo a été bien modifiée.",
                                                backgroundColor: Colors.grey,
                                                snackPosition: SnackPosition.BOTTOM,
                                                borderColor: Colors.grey,
                                                borderRadius: 10,
                                                borderWidth: 2,
                                                barBlur: 0,
                                                duration: Duration(seconds:2),
                                              );
                                            } ,
                                            valueColor: Colors.white,
                                            borderRadius: 90,
                                            child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.black),
                                    Text(
                                      "Modifier",
                                      style: TextStyle(color: Colors.black)
                                    ),
                                  ],
                                )
                              )
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: TextButton(
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
                                          onPressed: () {
                                            _doSomething(_btnController);
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              "Suppression",
                                              "La vidéo a été bien supprimée.",
                                              backgroundColor: Colors.grey,
                                              snackPosition: SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds:2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children : [
                                    Icon(Icons.delete_outline, color: Colors.red),
                                    Text(
                                      "Supprimer",
                                      style: TextStyle(color: Colors.red)
                                    ),
                                  ]
                                ),
                              )
                            ),
                          ]
                        )
                      )
                    ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.002,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/video_logo.jpg'),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                        ),
                        child: Column(
                          children :[
                            Container(
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                // top: MediaQuery.of(context).size.height*0.01,
                              ),
                              child: Text(
                                'Comment avoir de la vitesse ?',
                                style: TextStyle(fontSize: 18, color: Colors.black)
                              )
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                              ),
                              child: TextButton(
                                onPressed: () { print("WLL") ;},
                                child:Row(
                                  children : [
                                    Icon(Icons.message_outlined, color: Colors.grey),
                                    Text(
                                      "10 commentaires",
                                      style: TextStyle(color: Colors.grey[700])
                                    ),
                                  ]
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Divider()
              ]
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.04,
                    left: MediaQuery.of(context).size.width*0.0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children:[
                      Container(
                        height:MediaQuery.of(context).size.height*0.32,
                        width: MediaQuery.of(context).size.width*1,
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:MediaQuery.of(context).size.width*0.11,
                          vertical:MediaQuery.of(context).size.height*0.07
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.teal[400],
                          size: 40,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top:MediaQuery.of(context).size.height*0.24,
                          left:MediaQuery.of(context).size.width*0.82,
                        ),
                        child: PopupMenuButton(
                          color: Colors.white,
                          icon: Icon(Icons.more_horiz, color: Colors.white, size: 18),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: TextButton(
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
                                            vertical:MediaQuery.of(context).size.height*0.01
                                          ),
                                          child: RoundedLoadingButton(
                                            color: Colors.teal[400],
                                            successColor: Colors.teal,
                                            controller: _btnController,
                                            onPressed: () {
                                              _doSomething(_btnController);
                                              Navigator.pop(context);
                                              Get.snackbar(
                                                "Modification",
                                                "La vidéo a été bien modifiée.",
                                                backgroundColor: Colors.grey,
                                                snackPosition: SnackPosition.BOTTOM,
                                                borderColor: Colors.grey,
                                                borderRadius: 10,
                                                borderWidth: 2,
                                                barBlur: 0,
                                                duration: Duration(seconds:2),
                                              );
                                            } ,
                                            valueColor: Colors.white,
                                            borderRadius: 90,
                                            child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.black),
                                    Text(
                                      "Modifier",
                                      style: TextStyle(color: Colors.black)
                                    ),
                                  ],
                                )
                              )
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: TextButton(
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
                                          onPressed: () {
                                            _doSomething(_btnController);
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              "Suppression",
                                              "La vidéo a été bien supprimée.",
                                              backgroundColor: Colors.grey,
                                              snackPosition: SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds:2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children : [
                                    Icon(Icons.delete_outline, color: Colors.red),
                                    Text(
                                      "Supprimer",
                                      style: TextStyle(color: Colors.red)
                                    ),
                                  ]
                                ),
                              )
                            ),
                          ]
                        )
                      )
                    ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.002,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/video_logo.jpg'),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                        ),
                        child: Column(
                          children :[
                            Container(
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                // top: MediaQuery.of(context).size.height*0.01,
                              ),
                              child: Text(
                                'Comment avoir de la vitesse ?',
                                style: TextStyle(fontSize: 18, color: Colors.black)
                              )
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                              ),
                              child: TextButton(
                                onPressed: () { print("WLL") ;},
                                child:Row(
                                  children : [
                                    Icon(Icons.message_outlined, color: Colors.grey),
                                    Text(
                                      "10 commentaires",
                                      style: TextStyle(color: Colors.grey[700])
                                    ),
                                  ]
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Divider()
              ]
            ),
            Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.04,
                    left: MediaQuery.of(context).size.width*0.0,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children:[
                      Container(
                        height:MediaQuery.of(context).size.height*0.32,
                        width: MediaQuery.of(context).size.width*1,
                        child: Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child:Image.asset('assets/images/cover.jpg', fit: BoxFit.cover),
                          )
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal:MediaQuery.of(context).size.width*0.11,
                          vertical:MediaQuery.of(context).size.height*0.07
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.teal[400],
                          size: 40,
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top:MediaQuery.of(context).size.height*0.24,
                          left:MediaQuery.of(context).size.width*0.82,
                        ),
                        child: PopupMenuButton(
                          color: Colors.white,
                          icon: Icon(Icons.more_horiz, color: Colors.white, size: 18),
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 1,
                              child: TextButton(
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
                                            vertical:MediaQuery.of(context).size.height*0.01
                                          ),
                                          child: RoundedLoadingButton(
                                            color: Colors.teal[400],
                                            successColor: Colors.teal,
                                            controller: _btnController,
                                            onPressed: () {
                                              _doSomething(_btnController);
                                              Navigator.pop(context);
                                              Get.snackbar(
                                                "Modification",
                                                "La vidéo a été bien modifiée.",
                                                backgroundColor: Colors.grey,
                                                snackPosition: SnackPosition.BOTTOM,
                                                borderColor: Colors.grey,
                                                borderRadius: 10,
                                                borderWidth: 2,
                                                barBlur: 0,
                                                duration: Duration(seconds:2),
                                              );
                                            } ,
                                            valueColor: Colors.white,
                                            borderRadius: 90,
                                            child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    )
                                  );
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.black),
                                    Text(
                                      "Modifier",
                                      style: TextStyle(color: Colors.black)
                                    ),
                                  ],
                                )
                              )
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: TextButton(
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
                                          onPressed: () {
                                            _doSomething(_btnController);
                                            Navigator.pop(context);
                                            Get.snackbar(
                                              "Suppression",
                                              "La vidéo a été bien supprimée.",
                                              backgroundColor: Colors.grey,
                                              snackPosition: SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds:2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(
                                  children : [
                                    Icon(Icons.delete_outline, color: Colors.red),
                                    Text(
                                      "Supprimer",
                                      style: TextStyle(color: Colors.red)
                                    ),
                                  ]
                                ),
                              )
                            ),
                          ]
                        )
                      )
                    ]
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height*0.01,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width*0.002,
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/images/video_logo.jpg'),
                        )
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                        ),
                        child: Column(
                          children :[
                            Container(
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                // top: MediaQuery.of(context).size.height*0.01,
                              ),
                              child: Text(
                                'Comment avoir de la vitesse ?',
                                style: TextStyle(fontSize: 18, color: Colors.black)
                              )
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                              ),
                              child: TextButton(
                                onPressed: () { print("WLL") ;},
                                child:Row(
                                  children : [
                                    Icon(Icons.message_outlined, color: Colors.grey),
                                    Text(
                                      "10 commentaires",
                                      style: TextStyle(color: Colors.grey[700])
                                    ),
                                  ]
                                ),
                              ),
                            )
                          ]
                        ),
                      ),
                    ]
                  ),
                ),
                Divider()
              ]
            )
          ]
        ),
			),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
        backgroundColor: Colors.teal,
        elevation: 10,
      ),
      bottomNavigationBar: BottomBarWithSheet(
        disableMainActionButton : true,
        selectedIndex: 1,
        sheetChild: Center(child: Text("Place for your another content")),
        bottomBarTheme: BottomBarTheme(
          backgroundColor: Colors.black12,
          mainButtonPosition: MainButtonPosition.left,
          selectedItemBackgroundColor: Colors.teal[400],
          itemIconColor: Colors.grey[600],
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.teal[400]
        ),
        onSelectItem: (index) => print('item $index was pressed'),
        items: [
          BottomBarWithSheetItem(icon: Icons.video_library_outlined, label: "Tous"),
          BottomBarWithSheetItem(icon: Icons.sports_outlined, label: "Course"),
          BottomBarWithSheetItem(icon: Icons.settings, label: "Pompe"),
          BottomBarWithSheetItem(icon: Icons.favorite_outlined, label: "Traction"),
        ],
      ),
		);
	}
} 