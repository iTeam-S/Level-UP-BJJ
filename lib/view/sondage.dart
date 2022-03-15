// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color primaire = Colors.lightBlue.shade800;
Color background = Colors.lightBlue.shade100;

class Sondage extends StatefulWidget {
  const Sondage({
    Key? key,
  }) : super(key: key);

  @override
  State<Sondage> createState() => _SondageState();
}

class _SondageState extends State<Sondage> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("Annonces"),
        backgroundColor: primaire,
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: Get.width,
                height: 70,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ajouter une publication ?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    /*SizedBox(
                      width: 45,
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        child: Icon(Icons.add),
                      ),
                    )*/
                    InkWell(
                      onTap: () {
                         showDialog(
        context: context,
        builder: (context) {
          return 
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Créer un sondage',
                    style: TextStyle(color: primaire),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      )),
                ],
              ),
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: (){ addContent(context); }, child: Text('Annonces', style: TextStyle(fontSize: 21),)),
                      TextButton(onPressed: (){ sondage(); }, child: Text('Sondage', style: TextStyle(fontSize: 21),)),
                    ],)
              ],
            ),
          );
        });
 
                      },
                      child: Container(
                        width: 45,
                        height: 60,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: primaire,
                            borderRadius: BorderRadius.circular(7)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              ),
              SizedBox(
                width: Get.width,
                height: Get.height * .8,
                child: ListView.builder(
                    itemCount: 6,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, int index) {
                      return Container(
                        width: Get.width,
                        height: 300,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(2, 3))
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: primaire,
                                  child: Text("M"),
                                  radius: 25,
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Will Smith",
                                        style: TextStyle(fontSize: 25)),
                                    Text("il y a 15 minutes",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black45)),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("La nuit s'allumera",
                                      style: TextStyle(fontSize: 20)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  index % 2 == 0 ? 
                                    Text(lorem,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(fontSize: 17),
                                      maxLines: 6,
                                    ) :
                                    Container(
                                      height: 150,
                                      width: Get.width,
                                      child: ListView(
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          for (int i=0; i<10; i++)
                                          Container(
                                              margin: EdgeInsets.symmetric(vertical: 1),
                                              width: Get.width,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text("Egalité pour tous",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.normal,
                                                      )),
                                                  IconButton(
                                                  iconSize: 16,
                                                    onPressed: () {
                                                      setState(() {
                                                        isChecked = !isChecked;
                                                      });
                                                    },
                                                    icon: Icon(
                                                      !isChecked
                                                          ? Icons
                                                              .check_box_outline_blank
                                                          : Icons.check_box,
                                                    ),
                                                    color: primaire,
                                                  )
                                                ],
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String lorem =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed non risus. Suspendisse lectus tortor, dignissim sit amet, adipiscing nec, ultricies sed, dolor. Cras elementum ultrices diam. Maecenas ligula massa, varius a, semper congue, euismod non, mi. Proin porttitor, orci nec nonummy molestie, enim est eleifend mi, non fermentum diam nisl sit amet erat. Duis semper. Duis arcu massa, scelerisque vitae, consequat in, pretium a, enim. Pellentesque congue. Ut in risus volutpat libero pharetra tempor. Cras vestibulum bibendum augue. ";

  void addContent(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            children: [
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //height: 50,
                      width: Get.width * .8,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: primaire,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: " Titre",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //height: 50,
                      width: Get.width * .8,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: primaire,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Description",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    /**------------------------------ */
                    MaterialButton(
                      height: 50,
                      minWidth: 150,
                      textColor: Colors.white,
                      child: Text(
                        "Publier",
                        style: TextStyle(fontSize: 25),
                      ),
                      splashColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed: () {},
                      color: primaire,
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  void sondage() {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Créer un sondage',
                    style: TextStyle(color: primaire),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      )),
                ],
              ),
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(
                          Icons.add,
                          color: Colors.orange,
                        ),
                        title: Text(
                          "Femme au foyer",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.add,
                          color: Colors.orange,
                        ),
                        title: Text(
                          "Femme au travail",
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFD3D3D3),
                          borderRadius: BorderRadius.circular(7)),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: Get.width * .5,
                      height: 30,
                      child: const TextField(
                        decoration: InputDecoration.collapsed(
                          border: InputBorder.none,
                          hintText: '',
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.add,
                          color: Colors.blue,
                        ))
                  ],
                ),
              ],
            ),
          );
        });
  }
}
