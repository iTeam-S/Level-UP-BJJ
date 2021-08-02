//import 'dart:async';

import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/model/video.dart';
import 'package:bjj_library/service/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shimmer_animation/shimmer_animation.dart';

final RoundedLoadingButtonController _btnController =
    RoundedLoadingButtonController();

final UserController userController = Get.put(UserController());

final ApiController apiController = Get.put(ApiController());

final CurrentVideoController currentVideoController =
    Get.put(CurrentVideoController());

final AppController appController = Get.put(AppController());

/*void _doSomething(RoundedLoadingButtonController controller) async {
  Timer(Duration(seconds: 2), () {
    controller.success();
  });
}*/

Container videoTabModule(context, module) {
  return Container(
    child: module.videos.length != 0
        ? ListView(children: [
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
                                width: MediaQuery.of(context).size.width * 0.23,
                                child: Card(
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2),
                                      child: Image.network(
                                          "${apiController.url}/api/v1/get_image/${video.image}?token=${userController.user.token}",
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
                                      color: Colors.blue[400],
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
                                          /* PopupMenuItem(
                                              value: 1,
                                              child: TextButton(
                                                  onPressed: () {},
                                                  child: Row(
                                                    children: [
                                                      Icon(Icons.edit,
                                                          color: Colors.black),
                                                      Text("Modifier",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black)),
                                                    ],
                                                  ))),*/
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
          ])
        : Center(
            child: Icon(Icons.motion_photos_off_outlined,
                size: 120, color: Colors.grey),
          ),
  );
}

Container videoAllModule(context, data) {
  var tmpdata = data;
  Divider tmpDivider = Divider();
  List dataVideos = [];
  for (var tmp in tmpdata) {
    if (tmp.nom != 'Tous') {
      dataVideos.add(tmp);
      dataVideos.add(tmpDivider);
    }
  }
  return Container(
    child: ListView(children: [
      dataVideos.length != 0
          ? Column(children: [
              for (var dataVideo in dataVideos)
                dataVideo == tmpDivider
                    ? tmpDivider
                    : Container(
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.02,
                          left: MediaQuery.of(context).size.width * 0.02,
                        ),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.04,
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Text(
                                      "${dataVideo.nom}",
                                      style: TextStyle(
                                          fontSize: 23,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700]),
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.centerRight,
                                      margin: EdgeInsets.only(
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.02,
                                      ),
                                      child: TextButton(
                                          onPressed: () {
                                            //appController.tabIndex =
                                            //dataVideo['module_id'];
                                            //appController.update();
                                          },
                                          child: Row(children: [
                                            Text("Tout voir",
                                                style: TextStyle(
                                                    color: Colors.blue[400],
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Icon(Icons.chevron_right_outlined,
                                                color: Colors.blue[400]),
                                          ])))
                                ]),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        for (var video in dataVideo.videos)
                                          Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.17,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.32,
                                                  child: Card(
                                                      elevation: 1,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        child: Image.network(
                                                            "${apiController.url}/api/v1/get_image/${video.image}?token=${userController.user.token}",
                                                            fit: BoxFit.cover),
                                                      )),
                                                ),
                                                Container(
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.11,
                                                        vertical: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.07),
                                                    child: IconButton(
                                                      icon: Icon(
                                                          Icons.play_arrow),
                                                      color: Colors.blue[400],
                                                      iconSize: 30,
                                                      onPressed: () {
                                                        currentVideoController
                                                                .video =
                                                            Video(
                                                                id: video.id,
                                                                nom: video.nom,
                                                                titre:
                                                                    video.titre,
                                                                image:
                                                                    video.image,
                                                                commentaire: video
                                                                    .commentaire);
                                                        Get.toNamed('/video');
                                                      },
                                                    )),
                                                if (userController.user.admin)
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                        top: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.13,
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.18,
                                                      ),
                                                      child: PopupMenuButton(
                                                          color: Colors.white,
                                                          icon: Icon(
                                                              Icons.more_horiz,
                                                              color:
                                                                  Colors.white,
                                                              size: 18),
                                                          itemBuilder:
                                                              (context) => [
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
                                                                        value:
                                                                            2,
                                                                        child:
                                                                            TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                            showDialog(
                                                                              context: context,
                                                                              builder: (BuildContext context) => AlertDialog(
                                                                                title: const Text("Suppression d'une vidéo"),
                                                                                content: const Text('Voulez-vous vraiment supprimer cette vidéo ?'),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () => Navigator.pop(context, 'Annuler'),
                                                                                    child: const Text('Annuler'),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      supprimerVideo(video.id, _btnController);
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text('OK'),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Row(children: [
                                                                            Icon(Icons.delete_outline,
                                                                                color: Colors.red),
                                                                            Text("Supprimer",
                                                                                style: TextStyle(color: Colors.red)),
                                                                          ]),
                                                                        )),
                                                                  ]))
                                              ]),
                                      ],
                                    )))
                          ],
                        )),
            ])
          : Shimmer(
              color: Colors.black,
              child: Card(
                elevation: 0.0,
                color: Colors.white,
                margin: EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height * 0.9,
                      minWidth: MediaQuery.of(context).size.width * 0.9),
                ),
              ),
            ),
    ]),
  );
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
