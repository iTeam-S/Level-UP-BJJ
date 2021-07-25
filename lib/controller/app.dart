import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final ApiController apiController = Get.put(ApiController());
  List<Module> _moduleList = <Module>[];
  List<Container> _modulePageList = <Container>[];

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  List<Module> getmoduleList() {
    return _moduleList;
  }

  List<Container> getmodulePageList(BuildContext context) {
    return _modulePageList;
  }

  int moduleInit(BuildContext context) {
    if (_moduleList.length == 0) _moduleList.add(Module(id: 0, nom: 'Tous'));
    _modulePageList.clear();
    for (int i = 0; i < _moduleList.length; i++) {
      _modulePageList
          .add(i == 0 ? videoAllModule(context) : videoTabModule(context));
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
}
