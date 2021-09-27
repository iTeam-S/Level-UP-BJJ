//import 'dart:async';
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
  _refreshControllerAll.refreshCompleted();
}

Container videoTabModule(context, module) {
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
                                                fontSize: 18,
                                                color: Colors.black))),
                                    Container(
                                      child: TextButton(
                                        onPressed: () {
                                          print("WLL");
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
              alignment: Alignment.centerLeft,
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
                    for (int i = 0; i < 10; i++)
                      Stack(alignment: Alignment.topCenter, children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 1,
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset('assets/images/cover.jpg',
                                    fit: BoxFit.cover),
                              )),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                              top: Get.width < 500
                                  ? Get.height * 0.12
                                  : Get.height * 0.0,
                              left: MediaQuery.of(context).size.width * 0.36,
                            ),
                            child: PopupMenuButton(
                                color: Colors.white,
                                icon: Icon(Icons.more_horiz,
                                    color: Colors.white, size: 18),
                                itemBuilder: (context) => [
                                      /*PopupMenuItem(
                                                                      value:
                                                                          1,
                                                                      child: TextButton(
                                                                          onPressed: () {},
                                                                          child: Row(
                                                                            children: [
                                                                              Icon(Icons.edit, color: Colors.black),
                                                                              TextButton(
                                                                                onPressed: () {
                                                                                  //sModifierVideo();
                                                                                },
                                                                                child: Text(
                                                                                  "Modifier",
                                                                                  style: TextStyle(color: Colors.black),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ))),*/
                                      PopupMenuItem(
                                          value: 2,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        AlertDialog(
                                                  title: const Text(
                                                      "Suppression d'une vidéo"),
                                                  content: const Text(
                                                      'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Annuler'),
                                                      child:
                                                          const Text('Annuler'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {},
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
