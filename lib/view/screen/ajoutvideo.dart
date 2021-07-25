import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

FocusNode _focus = FocusNode();

void _doSomething(RoundedLoadingButtonController controller) async {
  Timer(Duration(seconds: 2), () {
    controller.success();
  });
}

void addVideo(context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
            title: Text(
              "Ajouter une vidéo",
            ),
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.0113),
                  child: TextField(
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide.none),
                      hintText: "Titre",
                      prefixIcon: Icon(Icons.edit, color: Colors.blue),
                    ),
                  )),
              Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                    // vertical: MediaQuery.of(context).size.height*0.0110
                  ),
                  child: TextField(
                    focusNode: _focus,
                    style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide.none),
                      focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(90.0)),
                          borderSide: BorderSide.none),
                      hintText: "Video",
                      prefixIcon: Icon(Icons.video_library_outlined,
                          color: Colors.blue),
                    ),
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.06,
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.09,
                  // vertical: MediaQuery.of(context).size.height*0.0110,
                ),
                child: Row(children: [
                  DropdownButton(
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconDisabledColor: Colors.blue[400],
                      iconEnabledColor: Colors.blue[400],
                      iconSize: 25,
                      underline: SizedBox(),
                      hint: Text('Module', style: TextStyle(fontSize: 14)),
                      items: [
                        DropdownMenuItem(
                          child: Text('Course'),
                          value: 1,
                        ),
                        DropdownMenuItem(
                          child: Text('Pompe'),
                          value: 2,
                        ),
                        DropdownMenuItem(
                          child: Text('Traction'),
                          value: 3,
                        ),
                      ],
                      onChanged: (value) => print(value))
                ]),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.06,
                  // vertical:MediaQuery.of(context).size.height*0.01
                ),
                child: RoundedLoadingButton(
                  color: Colors.blue[400],
                  successColor: Colors.blue,
                  controller: _btnController,
                  onPressed: () {
                    _doSomething(_btnController);
                    Navigator.pop(context);
                    Get.snackbar(
                      "Ajout",
                      "La vidéo a été bien ajoutée.",
                      backgroundColor: Colors.grey,
                      snackPosition: SnackPosition.BOTTOM,
                      borderColor: Colors.grey,
                      borderRadius: 10,
                      borderWidth: 2,
                      barBlur: 0,
                      duration: Duration(seconds: 2),
                    );
                  },
                  valueColor: Colors.white,
                  borderRadius: 90,
                  child: Text("AJOUTER", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ));
}
