import 'dart:async';
import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restart_app/restart_app.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';


class AppDrawer extends StatelessWidget {
  final UserController userController = Get.put(UserController());
  final AppController appController = Get.put(AppController());
  final UploadVideoDataController dataController =
      Get.put(UploadVideoDataController());
  final bool isLoadingPath = false;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  final TextEditingController moduleAddController = TextEditingController();

  final FocusNode focus = FocusNode();

  // stockena donnee ilaina apres fermeture application
  final box = GetStorage();

  void _changepasswd(RoundedLoadingButtonController controller) async {
    if (userController.oldPassController.text.trim() == '' || userController.newPassController.text.trim() == ''){
      appController.errorSnack('Les champs doivent être remplis.');
      controller.reset();
    }
    else if(userController.oldPassController.text == userController.newPassController.text){
      appController.errorSnack('Les champs doivent être différents.');
      controller.reset();
    }
    else {
      var res = await appController.changepassword(userController.user, userController.oldPassController.text, userController.newPassController.text);
      if (res == true){
        controller.success();
        Timer(Duration(seconds: 2), () {
          controller.reset();
          Get.back();
          appController.succesSnack('Mot de passe mise à jour');
        });
      }
      else{
        appController.errorSnack("Ancien mot de passe incorrecte");
        controller.error();
        Timer(Duration(seconds: 2), () {
          controller.reset();
        });
      }
    }

  }

  dynamic _openFileExplorer() async {
    dataController.isLoadingPath = true;
    dataController.update();
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['png', 'svg', 'jpg', 'jpeg'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        dataController.moduleCoverpath = file.path.toString();
        dataController.moduleCovertitre.text = file.name;
        dataController.forceUpdate();
      } else {
        print("Annuler");
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
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
      bool res = await appController.addModule(userController.user.id,
          userController.user.token, module, dataController.moduleCoverpath);
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
                        prefixIcon: Icon(Icons.edit_outlined,
                            color: Colors.lightBlue[800]),
                      ),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      // vertical: MediaQuery.of(context).size.height*0.0110
                    ),
                    child: TextField(
                      controller: dataController.moduleCovertitre,
                      keyboardType: TextInputType.none,
                      focusNode: focus,
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
                        hintText: "Image de couverture",
                        prefixIcon:
                            Icon(Icons.image_search, color: Colors.blue),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: RoundedLoadingButton(
                    color: Colors.lightBlue[800],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      if (moduleAddController.text.trim() == ""){
                        _btnController.reset();
                        return appController.errorSnack("Le Nom ne doit pas être vide.");
                      }
                     
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
                      controller: userController.oldPassController,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      obscureText: true,
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
                      controller: userController.newPassController,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      obscureText: true,
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
                    color: Colors.lightBlue[800],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      _changepasswd(_btnController);
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
              Restart.restartApp(webOrigin: '/');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onFocusChange() {
    debugPrint("Focus: " + focus.hasFocus.toString());
    if (focus.hasFocus) _openFileExplorer();
  }

  @override
  Widget build(BuildContext context) {
    focus.addListener(_onFocusChange);
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
                          backgroundColor: Colors.blueAccent[500],
                          child:
                              Text(userController.user.email[0].toUpperCase()),
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
                                  leading: Icon(Icons.home,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Annonces"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.toNamed('/new');
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.video_collection_outlined,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Vidéos"),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.add_outlined,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Ajouter un module"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    ajoutModule(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.lock,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Changer mot de passe"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    changePassword(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.logout_outlined,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Deconnexion"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    deconnexion(context);
                                  },
                                ),
                              ]
                            : [
                                ListTile(
                                  leading: Icon(Icons.home,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Annonces"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    Get.toNamed('/new');
                                  },
                                ),
                                ListTile(
                                  leading: Icon(Icons.lock,
                                      color: Colors.lightBlue[800]),
                                  title: Text("Changer mot de passe"),
                                  onTap: () {
                                    Navigator.pop(context);
                                    changePassword(context);
                                  },
                                ),
                                Divider(),
                                ListTile(
                                  leading: Icon(Icons.logout_outlined,
                                      color: Colors.lightBlue[800]),
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
                        'BJJ-Library 0.4.1',
                        style: TextStyle(fontSize: 12),
                      ),
                    )
                  ]))
        ],
      ),
    );
  }

}