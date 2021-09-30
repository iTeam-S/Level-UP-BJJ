//import 'dart:async';
import 'dart:async';

import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/service/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:pull_to_refresh/pull_to_refresh.dart';

final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

final UserController userController = Get.put(UserController());

final ApiController apiController = Get.put(ApiController());

final CurrentVideoController currentVideoController =
    Get.put(CurrentVideoController());

final AppController appController = Get.put(AppController());
var size = Get.size;
/*24 is for notification bar on Android*/
final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
final double itemWidth = size.width / 1.8;
var tapPosition;

RefreshController _refreshControllerTab =
    RefreshController(initialRefresh: false);

RefreshController _refreshControllerAll =
    RefreshController(initialRefresh: false);

void _onRefreshTab() async {
  // monitor network fetch
  appController.trtVideos(userController.user.id, userController.user.token);
  _refreshControllerTab.refreshCompleted();
}

void _onRefreshAll() async {
  // monitor network fetch
  appController.trtVideos(userController.user.id, userController.user.token);
  if (userController.user.admin)
    appController.trtNotifs(userController.user.id, userController.user.token);
  _refreshControllerAll.refreshCompleted();
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
                      value: appController.choixModule,
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconDisabledColor: Colors.lightBlue[800],
                      iconEnabledColor: Colors.lightBlue[800],
                      iconSize: 20,
                      underline: SizedBox(),
                      hint: Text('Module', style: TextStyle(fontSize: 14)),
                      items: [
                        for (Module mod in appController.getmoduleList())
                          DropdownMenuItem(
                            child: Text(mod.nom),
                            value: mod.nom,
                          ),
                      ],
                      onChanged: (value) {
                        appController.choixModule = value.toString();
                        //dataController.forceUpdate();
                        Navigator.pop(context);
                        modifModule(context);
                        //addVideo(context, moduleList);
                      },
                    )
                  ]),
                ),
                Container(
                  margin: EdgeInsets.only(
                      // left: MediaQuery.of(context).size.width*0.15,
                      ),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (appController.choixModule == 'Tous')
                        return Get.snackbar(
                          "Erreur",
                          "Choisir un module",
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          borderColor: Colors.red,
                          borderRadius: 10,
                          borderWidth: 2,
                          barBlur: 0,
                          duration: Duration(seconds: 2),
                        );

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
                                void supprModule() async {
                                  bool res = await appController.delModule(
                                      userController.user.id,
                                      userController.user.token,
                                      appController.getModuleId(
                                          appController.choixModule));

                                  if (res) {
                                    appController.trtVideos(
                                        userController.user.id,
                                        userController.user.token);
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
                                    appController.choixModule = 'Tous';
                                  }
                                }

                                supprModule();
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.red[400], size: 22),
                  ),
                ),
              ]),
              Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                  ),
                  child: TextField(
                    controller: appController.newNomModule,
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
                      hintText: "Nouveau nom de module",
                      prefixIcon: Icon(Icons.edit_outlined, color: Colors.blue),
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
                    if (appController.newNomModule.text.trim() == '')
                      return Get.snackbar(
                        "Erreur",
                        "Entrer un nom valide.",
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                        snackPosition: SnackPosition.BOTTOM,
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderWidth: 2,
                        barBlur: 0,
                        duration: Duration(seconds: 2),
                      );
                    //_doSomething(_btnController);
                    void modifModule() async {
                      bool res = await appController.modifModule(
                          userController.user.id,
                          userController.user.token,
                          appController.getModuleId(appController.choixModule),
                          appController.newNomModule.text);

                      if (res) {
                        appController.choixModule = 'Tous';
                        appController.trtVideos(
                            userController.user.id, userController.user.token);
                        _btnController.success();
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
                        Timer(Duration(seconds: 2), () {
                          _btnController.reset();
                          Get.back();
                        });
                      } else {
                        _btnController.error();

                        Timer(Duration(seconds: 2), () {
                          _btnController.reset();
                        });
                      }
                    }

                    modifModule();
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

Container videoTabModule(context) {
  Module module = appController.currModule;
  return Container(
    child: module.videos.length != 0
        ? SmartRefresher(
            controller: _refreshControllerTab,
            onRefresh: _onRefreshTab,
            enablePullDown: true,
            child: ListView(children: [
              Divider(),
              for (var video in module.videos)
                Column(children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.11,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.001),
                      child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                // top: MediaQuery.of(context).size.height * 0.00,
                                left: MediaQuery.of(context).size.width * 0.0,
                              ),
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  width:
                                      MediaQuery.of(context).size.width * 0.23,
                                  child: Card(
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(2)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(2),
                                        child: Image.network(
                                            "$BaseUrlProtocol/api/v1/get_image/${video.image}?token=${userController.user.token}",
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
                                                0.02),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.play_arrow,
                                        color: Colors.lightBlue[800],
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        currentVideoController.video = video;
                                        Get.toNamed('/video');
                                      },
                                    )),
                              ]),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.02,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.23,
                                        child: Text(video.titre,
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black))),
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.23,
                                      child: TextButton(
                                        onPressed: () {
                                          currentVideoController.video = video;
                                          Get.toNamed('/video');
                                        },
                                        child: Row(
                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Icon(Icons.message_outlined,
                                                  size: 16, color: Colors.grey),
                                              Text(
                                                  "${video.commentaire.length} commentaires",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                      color: Colors.grey[700])),
                                            ]),
                                      ),
                                    )
                                  ]),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    // top: MediaQuery.of(context).size.height * 0.08,
                                    // left: MediaQuery.of(context).size.width * 0.0,
                                    ),
                                child: PopupMenuButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.more_vert,
                                        color: Colors.grey, size: 20),
                                    itemBuilder: (context) => userController
                                            .user.admin
                                        ? [
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
                                                              supprimerVideo(
                                                                  video.id,
                                                                  _btnController);
                                                              Navigator.pop(
                                                                  context);
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
                                          ]
                                        : []))
                          ])),
                  Divider()
                ])
            ]))
        : Center(
            child: Icon(Icons.motion_photos_off_outlined,
                size: 120, color: Colors.grey),
          ),
  );
}

Container videoAllModule(context, data) {
  return Container(
      child: Stack(children: [
    SmartRefresher(
        controller: _refreshControllerAll,
        onRefresh: _onRefreshAll,
        enablePullDown: true,
        child: ListView(children: [
          Column(children: [
            // for (int c=0; c<data.length; c++)
            Container(
              height: Get.height * 0.85,
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.06,
                // left: MediaQuery.of(context).size.width * 0.02,
              ),
              child: OrientationBuilder(builder: (context, orientation) {
                return GridView.count(
                  crossAxisCount: Get.width < 500 ? 2 : 4,
                  childAspectRatio: (itemWidth / itemHeight),
                  controller: new ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  children: [
                    for (Module module in data)
                      if (module.nom != 'Tous')
                        Stack(alignment: Alignment.topCenter, children: [
                          GestureDetector(
                            onTap: () {
                              appController.currModule = module;
                              appController.update();
                              Get.toNamed('/videolist');
                            },
                            onTapDown: _storePosition,
                            onLongPress: () {
                              Get.bottomSheet(
                                  Container(
                                    height: Get.height * .20,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Container(
                                            margin:
                                                EdgeInsets.only(bottom: 8.0),
                                            child: Text(
                                              "${module.nom}",
                                              style: TextStyle(fontSize: 18),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          ListTile(
                                            title: Text("Modifier"),
                                            trailing: Icon(Icons.edit),
                                            onTap: () {
                                              appController.choixModule =
                                                  module.nom;
                                              modifModule(context);
                                            },
                                          ),
                                          ListTile(
                                            title: Text(
                                              "Supprimer",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            trailing: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                            onTap: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      "Suppression d'un module"),
                                                  content: Text(
                                                      'Voulez-vous vraiment supprimer ${module.nom}'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Annuler'),
                                                      child:
                                                          const Text('Annuler'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        appController.delModule(
                                                            userController
                                                                .user.id,
                                                            userController
                                                                .user.token,
                                                            module.id);
                                                        Get.back();
                                                      },
                                                      child: Text('OK'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  elevation: 20.0,
                                  enableDrag: false,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    topRight: Radius.circular(30.0),
                                  )));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Card(
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: module.cover == ''
                                        ? Image.asset(
                                            'assets/images/cover.jpg',
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            "$BaseUrlProtocol/api/v2/get_cover/${module.cover}?token=${userController.user.token}",
                                            fit: BoxFit.cover),
                                  )),
                            ),
                          ),
                        ]),
                  ],
                );
              }),
            )
          ]),
        ])),
    Container(
      width: MediaQuery.of(context).size.width * 1,
      color: Colors.white,
      // alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.03,
        top: MediaQuery.of(context).size.height * 0.02,
        bottom: MediaQuery.of(context).size.height * 0.01,
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.00,
        top: MediaQuery.of(context).size.height * 0.0,
      ),
      child: Text(
        "TOUS LES MODULES DISPONIBLES",
        softWrap: false,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
      ),
    ),
  ]));
}

void supprimerVideo(
    int id, RoundedLoadingButtonController btnController) async {
  bool res = await appController.delVideo(
      userController.user.id, userController.user.token, id);

  if (res) {
    appController.trtVideos(userController.user.id, userController.user.token);
    Get.snackbar(
      "Suppression",
      "La vidéo a été bien supprimée.",
      backgroundColor: Colors.grey,
      snackPosition: SnackPosition.BOTTOM,
      borderColor: Colors.grey,
      borderRadius: 10,
      borderWidth: 2,
      barBlur: 0,
      duration: Duration(seconds: 2),
    );
  }
}

void _storePosition(TapDownDetails details) {
  tapPosition = details.globalPosition;
}
