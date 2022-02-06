import 'dart:async';

import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/model/commentaire.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/model/video.dart';
import 'package:bjj_library/model/users.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  final UserController userController = Get.put(UserController());
  List<Module> _moduleList = <Module>[];
  List<Container> _modulePageList = <Container>[];
  List _videoList = [];
  UploadVideoDataController dataController =
      Get.put(UploadVideoDataController());
  //final TickerProviderStateMixin vsync  = TickerProviderStateMixin();
  late TabController tabController;
  String choixModule = 'Tous';
  TextEditingController newNomModule = TextEditingController();
  TextEditingController newComment = TextEditingController();

  late Module currModule;
  final box = GetStorage();
  var notifs = [];

  void finish() {
    _videoList.clear();
    _moduleList.clear();
    _modulePageList.clear();
  }

  List<Module> getmoduleList() {
    return _moduleList;
  }

  bool verifModule(String module) {
    // Permetant de verifier l'existance du module.
    for (Module mod in _moduleList) if (module == mod.nom) return true;
    return false;
  }

  List<Container> getmodulePageList(BuildContext context) {
    return _modulePageList;
  }

  void errorSnack(String text){
    Get.snackbar(
      "Erreur",
      "$text",
      colorText: Colors.white,
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.BOTTOM,
      borderColor: Colors.red,
      borderRadius: 10,
      borderWidth: 2,
      barBlur: 0,
      duration: Duration(seconds: 2),
    );
  }

  void succesSnack(String text){
    Get.snackbar(
      "Succes",
      "$text",
      colorText: Colors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      borderColor: Colors.green,
      borderRadius: 10,
      borderWidth: 2,
      barBlur: 0,
      duration: Duration(seconds: 2),
    );
  }

  void chargement(){
    Get.bottomSheet(
      Container(
        margin: EdgeInsets.symmetric(
          vertical: Get.height * 0.025,
          horizontal: Get.width * 0.06,
        ),
        child: LinearProgressIndicator(
          backgroundColor: Colors.grey,
        )
      )
    );
  }

  // int moduleInit(BuildContext context) {
  //   if (_moduleList.length == 0) _moduleList.add(Module(id: 0, nom: 'Tous'));
  //   _modulePageList.clear();
  //   for (int i = 0; i < _moduleList.length; i++) {
  //     _modulePageList.add(i == 0
  //         ? videoAllModule(context, _moduleList)
  //         : videoTabModule(context, _moduleList[i]));
  //   }

  //   return _moduleList.length;
  // }
/*
  void trtModules(int userid, String token) async {
    try {
      var res = await apiController.getmodules(userid, token);
      if (res[0]) {
        for (var mod in res[1]['data'])
          _moduleList.add(Module(id: mod[0], nom: mod[1]));
        update();
      } else {
        Get.snackbar(
          "Erreur",
          "${res[1]}",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
          borderColor: Colors.red,
          borderRadius: 10,
          borderWidth: 2,
          barBlur: 0,
          duration: Duration(seconds: 2),
        );
      }
    } catch (err) {
      print(err);
      Get.snackbar(
        "Erreur",
        "Vérfier votre connexion Internet.",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
        borderColor: Colors.red,
        borderRadius: 10,
        borderWidth: 2,
        barBlur: 0,
        duration: Duration(seconds: 2),
      );
    }
  }*/

  void trtVideos(int userid, String token) async {
    try {
      var res = await apiController.getvideos(userid, token);
      if (res[0]) {
        finish();
        _moduleList.add(Module(id: 0, nom: 'Tous', cover: ''));
        _videoList = res[1]['data'];
        // Mettre en place les modules
        late Module modTmp;
        for (var mod in _videoList) {
          modTmp = Module(
              id: mod['module_id'], nom: mod['nom'], cover: mod['cover']);
          // Mise en place des videos de modules
          List<Commentaire> coms;
          for (var vid in mod['videos']) {
            coms = <Commentaire>[];
            for (var com in vid['commentaire'])
              coms.add(Commentaire(
                  id: com['id'],
                  text: com['text'],
                  userid: com['user_id'],
                  email: com['user_email']));
            modTmp.videos.add(Video(
                id: vid['id'],
                nom: vid['nom'],
                titre: vid['titre'],
                image: vid['image'],
                commentaire: coms));
          }
          _moduleList.add(modTmp);
        }
        update();
      } else {
        // errorSnack("${res[1]}");
        errorSnack('Session Expiré');
        box.remove('user');
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
    }
  }

  Future<bool> addModule(
      int userid, String token, String module, String coverpath) async {
    try {
      dataController.uploadCover = 0;
      Get.bottomSheet(GetBuilder<UploadVideoDataController>(
          builder: (_) => Container(
              margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.025,
                horizontal: Get.width * 0.06,
              ),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                value: dataController.uploadCover,
              ))));
      var res =
          await apiController.createmodule(userid, token, module, coverpath);
      Get.back();
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      Get.back();
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

  int getModuleId(modname) {
    for (Module mod in _moduleList) if (modname == mod.nom) return mod.id;
    return 0;
  }

  Future<bool> uploadVideo(int userid, String token, int moduleid, String titre,
      String videopath, String niveau) async {
    try {
      Get.bottomSheet(GetBuilder<UploadVideoDataController>(
          builder: (_) => Container(
              margin: EdgeInsets.symmetric(
                vertical: Get.height * 0.025,
                horizontal: Get.width * 0.06,
              ),
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                value: dataController.uploadPourcent,
              ))));
      var res = await apiController.uploadVideo(
          userid, token, moduleid, titre, videopath, niveau);
      Get.back();
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      Get.back();
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

  Future<bool> delVideo(int userid, String token, int id) async {
    try {
      var res = await apiController.deletevideo(userid, token, id);
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

  Future<bool> delModule(int userid, String token, int moduleId) async {
    try {
      var res = await apiController.deletemodule(userid, token, moduleId);
      if (res[0]) {
        trtVideos(userid, token);
        succesSnack("Module supprimé");
        return true;
      } else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

  Future<bool> modifModule(
      int userid, String token, int moduleId, String nom) async {
    try {
      var res = await apiController.updatemodule(userid, token, moduleId, nom);
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

  Future<bool> sendComment(
      int userid, String token, String text, int videoid) async {
    try {
      var res = await apiController.comment(userid, token, text, videoid);
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

  void trtNotifs(int id, String token) async {
    try {
      var res = await apiController.getnotifs(id, token);
      if (res[0]) {
        notifs = res[1]['data'];
        update();
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
    }
  }

  Future<bool> viewNotif(int userid, String token, int id) async {
    try {
      var res = await apiController.viewnotif(userid, token, id);
      if (res[0]) {
        trtNotifs(userid, token);
        return true;
      } else {
        print(res[1]);
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
      return false;
    }
  }

   Future<bool> checkMail(String mail) async {
    try {
      var res = await apiController.checkmail(mail);
      if (res[0]) {
        return res[1]['data'] == 0;
      } else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Une erreur s'est produite");
      return false;
    }
  }

   Future<bool> createAccount(String mail, String payemntID) async {
    try {
      // Get a random secure password 
      String password = Utils.passwdGen(6);
      var res = await apiController.createaccount(mail, password, payemntID);
      if (res[0]) {
        res[1]['admin'] = res[1]['admin'] == 1 ? true : false;
        userController.user = User.fromJson(res[1]);
        // sauvegarde de l'user dans le storage
        box.write('user', userController.user.toJson());
        box.save(); 
        return true;
      } else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Une erreur s'est produite");
      return false;
    }
  }

  Future<bool> upgradeAccount(User user, String payemntID) async{
    try {
      var res = await apiController.upgradeAccount(user.id, user.token, payemntID);
      if (res[0]) {
        return true;
      } else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Une erreur s'est produite");
      return false;
    }

  }

  void verifexp(User user) async {
     try {
      var res = await apiController.verifexp(user.id, user.token);
      if (res[0]) {
        if  (res[1]['data'] != 1)
          Timer(Duration(seconds: 2), () {
            Get.offNamed('/renew');
          });
      } else {
        errorSnack("${res[1]}");
      }
    } catch (err) {
      print(err);
      errorSnack("Vérfier votre connexion Internet.");
    }
  }

  Future<bool> changepassword(User user, String oldPass, String newPass) async {
     try {
      var res = await apiController.changePassword(oldPass, newPass, user.id, user.token);
      if (res[0]) {
        return res[1]['data'];
      } else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Une erreur s'est produite.");
      return false; 
    }
  }

  Future<bool> sendCodeConfirmation(String mail) async{
     try {
      var res = await apiController.sendCode(mail);
      if (res[0]) {
        return true;
      } else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Une erreur s'est produite.");
      return false; 
    }
  }

  Future<bool> verifCodeConfirmation(String mail, String code) async {
    try {
      var res = await apiController.verifCode(mail, code);
      if (res[0]) {
        userController.user = User.fromJson(res[1]);
        return true;
      } 
      else {
        errorSnack("${res[1]}");
        return false;
      }
    } catch (err) {
      print(err);
      errorSnack("Une erreur s'est produite.");
      return false; 
    }
  }

}
