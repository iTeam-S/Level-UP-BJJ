import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/model/video.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  List<Module> _moduleList = <Module>[];
  List<Container> _modulePageList = <Container>[];
  List _videoList = [];
  UploadVideoDataController dataController =
      Get.put(UploadVideoDataController());

  // @override
  // void onInit() {
  //   super.onInit();
  // }
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

  int moduleInit(BuildContext context) {
    if (_moduleList.length == 0) _moduleList.add(Module(id: 0, nom: 'Tous'));
    _modulePageList.clear();
    for (int i = 0; i < _moduleList.length; i++) {
      _modulePageList.add(i == 0
          ? videoAllModule(context, _videoList)
          : videoTabModule(context, _moduleList[i]));
    }
    return _moduleList.length;
  }

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
  }

  void trtVideos(int userid, String token) async {
    try {
      var res = await apiController.getvideos(userid, token);
      if (res[0]) {
        finish();
        _moduleList.add(Module(id: 0, nom: 'Tous'));
        _videoList = res[1]['data'];
        // Mettre en place les modules
        late Module modTmp;
        for (var mod in _videoList) {
          modTmp = Module(id: mod['module_id'], nom: mod['nom']);
          // Mise en place des videos de modules
          for (var vid in mod['videos'])
            modTmp.videos.add(Video(
                id: vid['id'],
                nom: vid['nom'],
                titre: vid['titre'],
                image: vid['image']));
          _moduleList.add(modTmp);
        }
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
  }

  Future<bool> addModule(int userid, String token, String module) async {
    try {
      var res = await apiController.createmodule(userid, token, module);
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
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
        return false;
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
      return false;
    }
  }

  int getModuleId(modname) {
    for (Module mod in _moduleList) if (modname == mod.nom) return mod.id;
    return 0;
  }

  Future<bool> uploadVideo(int userid, String token, int moduleid, String titre,
      String videopath) async {
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
          userid, token, moduleid, titre, videopath);
      Get.back();
      if (res[0]) {
        return true;
      } else {
        print(res[1]);
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
        return false;
      }
    } catch (err) {
      print(err);
      Get.back();
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
      return false;
    }
  }
}
