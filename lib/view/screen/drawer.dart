import 'dart:async';

import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AppDrawer extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final AppController appController = Get.put(AppController());

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final TextEditingController moduleAddController = TextEditingController();

  // stockena donnee ilaina apres fermeture application
  final box = GetStorage();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 2), () {
      controller.success();
    });
  }

  void ajoutModule(context) {
    dynamic traitement(String module, controller) async {
      if (appController.verifModule(module)) {
        Timer(Duration(seconds: 1), () {
          controller.reset();
        });
        Get.snackbar(
          "Erreur",
          "Nom deja existant",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.red,
          borderRadius: 10,
          borderWidth: 2,
          barBlur: 0,
          duration: Duration(seconds: 2),
        );
        return controller.error();
      }
      bool res = await appController.addModule(
          userController.user.id, userController.user.token, module);
      if (res) {
        Timer(Duration(seconds: 2), () {
          controller.reset();
        });
        Get.snackbar(
          "Ajout",
          "Le module a été enregistré avec succès",
          backgroundColor: Colors.grey,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.grey,
          borderRadius: 10,
          borderWidth: 2,
          barBlur: 0,
          duration: Duration(seconds: 2),
        );
        controller.success();

        appController.trtVideos(
            userController.user.id, userController.user.token);
        return "GG";
      }
      Timer(Duration(seconds: 1), () {
        controller.reset();
      });
      controller.error();
    }

    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                "Ajouter un module",
              ),
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: TextField(
                      controller: moduleAddController,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Module",
                        prefixIcon:
                            Icon(Icons.edit_outlined, color: Colors.blue),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: RoundedLoadingButton(
                    color: Colors.blue[400],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      // _doSomething(_btnController);
                      var res =
                          traitement(moduleAddController.text, _btnController);
                      if (res == 'GG') Navigator.of(context).pop();
                    },
                    valueColor: Colors.white,
                    borderRadius: 90,
                    child:
                        Text("AJOUTER", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ));
  }

  void modifModule(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                "Modifier un module",
              ),
              children: [
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                Row(children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.09,
                      vertical: MediaQuery.of(context).size.height * 0.0115,
                    ),
                    child: Row(children: [
                      DropdownButton(
                          icon: Icon(Icons.arrow_drop_down_circle),
                          iconDisabledColor: Colors.blue[400],
                          iconEnabledColor: Colors.blue[400],
                          iconSize: 20,
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
                    margin: EdgeInsets.only(
                        // left: MediaQuery.of(context).size.width*0.15,
                        ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text("Suppression d'un module"),
                            content: const Text(
                                'Voulez-vous vraiment supprimer ce module ?'),
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
                                    "Le module a été supprimé.",
                                    backgroundColor: Colors.grey,
                                    snackPosition: SnackPosition.BOTTOM,
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
                      icon:
                          Icon(Icons.delete, color: Colors.red[400], size: 22),
                    ),
                  ),
                ]),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Nouveau nom de module",
                        prefixIcon:
                            Icon(Icons.edit_outlined, color: Colors.blue),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: RoundedLoadingButton(
                    color: Colors.blue[400],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      _doSomething(_btnController);
                      Navigator.pop(context);
                      Get.snackbar(
                        "Modification",
                        "Le nom de module a été modifié",
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
                    child: Text("ENREGISTRER",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ));
  }

  void changePassword(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                "Changement de mot de passe",
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Ancien mot de passe",
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: TextField(
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Nouveau mot de passe",
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: RoundedLoadingButton(
                    color: Colors.blue[400],
                    successColor: Colors.blue,
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
                        duration: Duration(seconds: 2),
                      );
                    },
                    valueColor: Colors.white,
                    borderRadius: 90,
                    child: Text("ENREGISTRER",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ));
  }

  void deconnexion(context) {
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
              appController.finish();
              box.remove('user');
              Get.offNamed('/login');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  top: MediaQuery.of(context).size.height * 0.048,
                ),
                child: Column(
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.pinkAccent[400],
                          child: Text('L'),
                        )),
                    Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.1,
                          top: MediaQuery.of(context).size.height * 0.01,
                        ),
                        child: Text(userController.user.email,
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                      ),
                      child: Text(
                          userController.user.admin
                              ? 'Administrateur'
                              : 'Utilisateur',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.73,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                        children: userController.user.admin
                            ? [
                                ListTile(
                                  leading: Icon(Icons.video_collection_outlined, color: Colors.blue[400]),
                                  title: Text("Vidéos"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.add_outlined,
                                      color: Colors.blue[400]),
                                  title: Text("Ajouter un module"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ajoutModule(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.edit_outlined,
                                      color: Colors.blue[400]),
                                  title: Text("Modifier un module"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    modifModule(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading:
                                      Icon(Icons.lock, color: Colors.blue[400]),
                                  title: Text("Changer mot de passe"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    changePassword(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.logout_outlined,
                                      color: Colors.blue[400]),
                                  title: Text("Deconnexion"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    deconnexion(context);
                                  },
                                ),
                              ]
                            : [
                                ListTile(
                                  leading:
                                      Icon(Icons.lock, color: Colors.blue[400]),
                                  title: Text("Changer mot de passe"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    changePassword(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.logout_outlined,
                                      color: Colors.blue[400]),
                                  title: Text("Deconnexion"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    deconnexion(context);
                                  },
                                ),
                              ]),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        'BJJ-Library 0.3.6',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ]))
        ],
      ),
    );
  }
}
