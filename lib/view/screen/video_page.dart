import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

void _doSomething(RoundedLoadingButtonController controller) async {
  Timer(Duration(seconds: 2), () {
    controller.success();
  });
}

Container videoTabModule(context) {
  return Container(
    child: ListView(children: [
      Column(children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width * 1,
              child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset('assets/images/cover.jpg',
                        fit: BoxFit.cover),
                  )),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.11,
                    vertical: MediaQuery.of(context).size.height * 0.07),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.blue[400],
                  size: 40,
                )),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.24,
                  left: MediaQuery.of(context).size.width * 0.82,
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
                                        builder: (BuildContext context) =>
                                            SimpleDialog(
                                              title: Text(
                                                "Modification d'une vidéo",
                                              ),
                                              children: [
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.0113),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Titre",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                    ),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Module",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  child: RoundedLoadingButton(
                                                    color: Colors.blue[400],
                                                    successColor: Colors.blue,
                                                    controller: _btnController,
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Modification",
                                                        "La vidéo a été bien modifiée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    valueColor: Colors.white,
                                                    borderRadius: 90,
                                                    child: Text("ENREGISTRER",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.black),
                                      Text("Modifier",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ))),
                          PopupMenuItem(
                              value: 2,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title:
                                          const Text("Suppression d'une vidéo"),
                                      content: const Text(
                                          'Voulez-vous vraiment supprimer cette vidéo ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Annuler'),
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds: 2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(children: [
                                  Icon(Icons.delete_outline, color: Colors.red),
                                  Text("Supprimer",
                                      style: TextStyle(color: Colors.red)),
                                ]),
                              )),
                        ]))
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00005,
            left: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.002,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/video_logo.jpg'),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.width*0.001,
                      ),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(
                            // left: MediaQuery.of(context).size.width*0.001,
                            // top: MediaQuery.of(context).size.height*0.01,
                            ),
                        child: Text('Comment avoir de la vitesse ?',
                            style:
                                TextStyle(fontSize: 20, color: Colors.black))),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                          ),
                      child: TextButton(
                        onPressed: () {
                          print("WLL");
                        },
                        child: Row(children: [
                          Icon(Icons.message_outlined, color: Colors.grey),
                          Text("10 commentaires",
                              style: TextStyle(color: Colors.grey[700])),
                        ]),
                      ),
                    )
                  ]),
                ),
              ]),
        ),
        Divider()
      ]),
      Column(children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width * 1,
              child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset('assets/images/cover.jpg',
                        fit: BoxFit.cover),
                  )),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.11,
                    vertical: MediaQuery.of(context).size.height * 0.07),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.blue[400],
                  size: 40,
                )),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.24,
                  left: MediaQuery.of(context).size.width * 0.82,
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
                                        builder: (BuildContext context) =>
                                            SimpleDialog(
                                              title: Text(
                                                "Modification d'une vidéo",
                                              ),
                                              children: [
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.0113),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Titre",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                    ),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Module",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  child: RoundedLoadingButton(
                                                    color: Colors.blue[400],
                                                    successColor: Colors.blue,
                                                    controller: _btnController,
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Modification",
                                                        "La vidéo a été bien modifiée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    valueColor: Colors.white,
                                                    borderRadius: 90,
                                                    child: Text("ENREGISTRER",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.black),
                                      Text("Modifier",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ))),
                          PopupMenuItem(
                              value: 2,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title:
                                          const Text("Suppression d'une vidéo"),
                                      content: const Text(
                                          'Voulez-vous vraiment supprimer cette vidéo ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Annuler'),
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds: 2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(children: [
                                  Icon(Icons.delete_outline, color: Colors.red),
                                  Text("Supprimer",
                                      style: TextStyle(color: Colors.red)),
                                ]),
                              )),
                        ]))
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00005,
            left: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.002,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/video_logo.jpg'),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.width*0.001,
                      ),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(
                            // left: MediaQuery.of(context).size.width*0.001,
                            // top: MediaQuery.of(context).size.height*0.01,
                            ),
                        child: Text('Comment avoir de la vitesse ?',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                          ),
                      child: TextButton(
                        onPressed: () {
                          print("WLL");
                        },
                        child: Row(children: [
                          Icon(Icons.message_outlined, color: Colors.grey),
                          Text("10 commentaires",
                              style: TextStyle(color: Colors.grey[700])),
                        ]),
                      ),
                    )
                  ]),
                ),
              ]),
        ),
        Divider()
      ]),
      Column(children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width * 1,
              child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset('assets/images/cover.jpg',
                        fit: BoxFit.cover),
                  )),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.11,
                    vertical: MediaQuery.of(context).size.height * 0.07),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.blue[400],
                  size: 40,
                )),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.24,
                  left: MediaQuery.of(context).size.width * 0.82,
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
                                        builder: (BuildContext context) =>
                                            SimpleDialog(
                                              title: Text(
                                                "Modification d'une vidéo",
                                              ),
                                              children: [
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.0113),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Titre",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                    ),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Module",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  child: RoundedLoadingButton(
                                                    color: Colors.blue[400],
                                                    successColor: Colors.blue,
                                                    controller: _btnController,
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Modification",
                                                        "La vidéo a été bien modifiée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    valueColor: Colors.white,
                                                    borderRadius: 90,
                                                    child: Text("ENREGISTRER",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.black),
                                      Text("Modifier",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ))),
                          PopupMenuItem(
                              value: 2,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title:
                                          const Text("Suppression d'une vidéo"),
                                      content: const Text(
                                          'Voulez-vous vraiment supprimer cette vidéo ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Annuler'),
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds: 2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(children: [
                                  Icon(Icons.delete_outline, color: Colors.red),
                                  Text("Supprimer",
                                      style: TextStyle(color: Colors.red)),
                                ]),
                              )),
                        ]))
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00005,
            left: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.002,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/video_logo.jpg'),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.width*0.001,
                      ),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(
                            // left: MediaQuery.of(context).size.width*0.001,
                            // top: MediaQuery.of(context).size.height*0.01,
                            ),
                        child: Text('Comment avoir de la vitesse ?',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                          ),
                      child: TextButton(
                        onPressed: () {
                          print("WLL");
                        },
                        child: Row(children: [
                          Icon(Icons.message_outlined, color: Colors.grey),
                          Text("10 commentaires",
                              style: TextStyle(color: Colors.grey[700])),
                        ]),
                      ),
                    )
                  ]),
                ),
              ]),
        ),
        Divider()
      ]),
      Column(children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.04,
            left: MediaQuery.of(context).size.width * 0.0,
          ),
          child: Stack(alignment: Alignment.center, children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.32,
              width: MediaQuery.of(context).size.width * 1,
              child: Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset('assets/images/cover.jpg',
                        fit: BoxFit.cover),
                  )),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.11,
                    vertical: MediaQuery.of(context).size.height * 0.07),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.blue[400],
                  size: 40,
                )),
            Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.24,
                  left: MediaQuery.of(context).size.width * 0.82,
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
                                        builder: (BuildContext context) =>
                                            SimpleDialog(
                                              title: Text(
                                                "Modification d'une vidéo",
                                              ),
                                              children: [
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.0113),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Titre",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.08,
                                                    margin:
                                                        EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                    ),
                                                    child: TextField(
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              Colors.grey[800]),
                                                      decoration:
                                                          InputDecoration(
                                                        filled: true,
                                                        fillColor:
                                                            Colors.blue[50],
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        90.0)),
                                                            borderSide:
                                                                BorderSide
                                                                    .none),
                                                        focusedBorder:
                                                            UnderlineInputBorder(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            90.0)),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        hintText: "Module",
                                                        prefixIcon: Icon(
                                                            Icons.edit,
                                                            color: Colors.blue),
                                                      ),
                                                    )),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.06,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.01),
                                                  child: RoundedLoadingButton(
                                                    color: Colors.blue[400],
                                                    successColor: Colors.blue,
                                                    controller: _btnController,
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Modification",
                                                        "La vidéo a été bien modifiée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    valueColor: Colors.white,
                                                    borderRadius: 90,
                                                    child: Text("ENREGISTRER",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.black),
                                      Text("Modifier",
                                          style:
                                              TextStyle(color: Colors.black)),
                                    ],
                                  ))),
                          PopupMenuItem(
                              value: 2,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title:
                                          const Text("Suppression d'une vidéo"),
                                      content: const Text(
                                          'Voulez-vous vraiment supprimer cette vidéo ?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Annuler'),
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
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              borderColor: Colors.grey,
                                              borderRadius: 10,
                                              borderWidth: 2,
                                              barBlur: 0,
                                              duration: Duration(seconds: 2),
                                            );
                                          },
                                          child: Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Row(children: [
                                  Icon(Icons.delete_outline, color: Colors.red),
                                  Text("Supprimer",
                                      style: TextStyle(color: Colors.red)),
                                ]),
                              )),
                        ]))
          ]),
        ),
        Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.00005,
            left: MediaQuery.of(context).size.width * 0.02,
          ),
          child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.002,
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage('assets/images/video_logo.jpg'),
                    )),
                Container(
                  margin: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.width*0.001,
                      ),
                  child: Column(children: [
                    Container(
                        margin: EdgeInsets.only(
                            // left: MediaQuery.of(context).size.width*0.001,
                            // top: MediaQuery.of(context).size.height*0.01,
                            ),
                        child: Text('Comment avoir de la vitesse ?',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black))),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                          // left: MediaQuery.of(context).size.width*0.001,
                          ),
                      child: TextButton(
                        onPressed: () {
                          print("WLL");
                        },
                        child: Row(children: [
                          Icon(Icons.message_outlined, color: Colors.grey),
                          Text("10 commentaires",
                              style: TextStyle(color: Colors.grey[700])),
                        ]),
                      ),
                    )
                  ]),
                ),
              ]),
        ),
        Divider()
      ])
    ]),
  );
}

Container videoAllModule(context) {
  return Container(
    child: ListView(children: [
      Column(children: [
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: Text(
                          "Course",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: TextButton(
                              onPressed: () {},
                              child: Row(children: [
                                Text("Tout voir",
                                    style: TextStyle(
                                        color: Colors.blue[400],
                                        fontWeight: FontWeight.bold)),
                                Icon(Icons.chevron_right_outlined,
                                    color: Colors.blue[400]),
                              ])))
                    ]),
                Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.11,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.07),
                                  child: Icon(
                                    Icons.play_arrow,
                                    color: Colors.blue[400],
                                    size: 30,
                                  )),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      color: Colors.white,
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                                value: 1,
                                                child: TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              SimpleDialog(
                                                                title: Text(
                                                                  "Modification d'une vidéo",
                                                                ),
                                                                children: [
                                                                  Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.08,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal: MediaQuery.of(context).size.width *
                                                                              0.06,
                                                                          vertical: MediaQuery.of(context).size.height *
                                                                              0.0113),
                                                                      child:
                                                                          TextField(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey[800]),
                                                                        decoration:
                                                                            InputDecoration(
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              Colors.blue[50],
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                              borderSide: BorderSide.none),
                                                                          focusedBorder: UnderlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                              borderSide: BorderSide.none),
                                                                          hintText:
                                                                              "Titre",
                                                                          prefixIcon: Icon(
                                                                              Icons.edit,
                                                                              color: Colors.blue),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                      height: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.08,
                                                                      margin: EdgeInsets
                                                                          .symmetric(
                                                                        horizontal:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.06,
                                                                      ),
                                                                      child:
                                                                          TextField(
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                            color:
                                                                                Colors.grey[800]),
                                                                        decoration:
                                                                            InputDecoration(
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              Colors.blue[50],
                                                                          border: OutlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                              borderSide: BorderSide.none),
                                                                          focusedBorder: UnderlineInputBorder(
                                                                              borderRadius: BorderRadius.all(Radius.circular(90.0)),
                                                                              borderSide: BorderSide.none),
                                                                          hintText:
                                                                              "Module",
                                                                          prefixIcon: Icon(
                                                                              Icons.edit,
                                                                              color: Colors.blue),
                                                                        ),
                                                                      )),
                                                                  Container(
                                                                    margin: EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            MediaQuery.of(context).size.width *
                                                                                0.06,
                                                                        vertical:
                                                                            MediaQuery.of(context).size.height *
                                                                                0.01),
                                                                    child:
                                                                        RoundedLoadingButton(
                                                                      color: Colors
                                                                              .blue[
                                                                          400],
                                                                      successColor:
                                                                          Colors
                                                                              .blue,
                                                                      controller:
                                                                          _btnController,
                                                                      onPressed:
                                                                          () {
                                                                        _doSomething(
                                                                            _btnController);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Get.snackbar(
                                                                          "Modification",
                                                                          "La vidéo a été bien modifiée.",
                                                                          backgroundColor:
                                                                              Colors.grey,
                                                                          snackPosition:
                                                                              SnackPosition.BOTTOM,
                                                                          borderColor:
                                                                              Colors.grey,
                                                                          borderRadius:
                                                                              10,
                                                                          borderWidth:
                                                                              2,
                                                                          barBlur:
                                                                              0,
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        );
                                                                      },
                                                                      valueColor:
                                                                          Colors
                                                                              .white,
                                                                      borderRadius:
                                                                          90,
                                                                      child: Text(
                                                                          "ENREGISTRER",
                                                                          style:
                                                                              TextStyle(color: Colors.white)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.edit,
                                                            color:
                                                                Colors.black),
                                                        Text("Modifier",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                      ],
                                                    ))),
                                            PopupMenuItem(
                                                value: 2,
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          AlertDialog(
                                                        title: const Text(
                                                            "Suppression d'une vidéo"),
                                                        content: const Text(
                                                            'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    'Annuler'),
                                                            child: const Text(
                                                                'Annuler'),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              _doSomething(
                                                                  _btnController);
                                                              Navigator.pop(
                                                                  context);
                                                              Get.snackbar(
                                                                "Suppression",
                                                                "La vidéo a été bien supprimée.",
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                snackPosition:
                                                                    SnackPosition
                                                                        .BOTTOM,
                                                                borderColor:
                                                                    Colors.grey,
                                                                borderRadius:
                                                                    10,
                                                                borderWidth: 2,
                                                                barBlur: 0,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              );
                                                            },
                                                            child: Text('OK'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Row(children: [
                                                    Icon(Icons.delete_outline,
                                                        color: Colors.red),
                                                    Text("Supprimer",
                                                        style: TextStyle(
                                                            color: Colors.red)),
                                                  ]),
                                                )),
                                          ]))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                          ],
                        )))
              ],
            )),
        Divider(),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: Text(
                          "Pompe",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: TextButton(
                              onPressed: () {},
                              child: Row(children: [
                                Text("Tout voir",
                                    style: TextStyle(
                                        color: Colors.blue[400],
                                        fontWeight: FontWeight.bold)),
                                Icon(Icons.chevron_right_outlined,
                                    color: Colors.blue[400]),
                              ])))
                    ]),
                Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                          ],
                        )))
              ],
            )),
        Divider(),
        Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.00,
              left: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.04,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                        ),
                        child: Text(
                          "Traction",
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ),
                      Container(
                          alignment: Alignment.centerRight,
                          margin: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.02,
                          ),
                          child: TextButton(
                              onPressed: () {},
                              child: Row(children: [
                                Text("Tout voir",
                                    style: TextStyle(
                                        color: Colors.blue[400],
                                        fontWeight: FontWeight.bold)),
                                Icon(Icons.chevron_right_outlined,
                                    color: Colors.blue[400]),
                              ])))
                    ]),
                Container(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                            Stack(alignment: Alignment.center, children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.17,
                                width: MediaQuery.of(context).size.width * 0.32,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Image.asset(
                                          'assets/images/cover.jpg',
                                          fit: BoxFit.cover),
                                    )),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.13,
                                    left: MediaQuery.of(context).size.width *
                                        0.18,
                                  ),
                                  child: PopupMenuButton(
                                      icon: Icon(Icons.more_horiz,
                                          color: Colors.white, size: 18),
                                      itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 1,
                                              child: Row(children: [
                                                Icon(Icons.edit),
                                                Text("Modifier")
                                              ]),
                                            ),
                                            PopupMenuItem(
                                              value: 2,
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text(
                                                  "Supprimer",
                                                  style: TextStyle(
                                                      color: Colors.red),
                                                )
                                              ]),
                                            )
                                          ])),
                              Container(
                                  child: Icon(
                                Icons.play_arrow,
                                color: Colors.blue[400],
                                size: 30,
                              ))
                            ]),
                          ],
                        )))
              ],
            )),
      ])
    ]),
  );
}
