import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';

class ResultListScreen extends StatefulWidget {
  @override
  _ResultListScreen createState() => _ResultListScreen();
}

class _ResultListScreen extends State<ResultListScreen> {
  // Instance ana controlleur
  AppController appController = Get.put(AppController());

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (_) => Scaffold(
          appBar: AppBar(
            toolbarHeight: 45,
            backgroundColor: Colors.lightBlue[800],
            title: Text("Resultat de recherche",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "ProductSans",
                    fontSize: 17)),
            centerTitle: true,
          ),
          body: ListView(children: [
              Divider(),
              for (var video in appController.getVideosByQuery(userController.searchController.text))
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
                                            "$baseUrlProtocol/api/v1/get_image/${video.image}?token=${userController.user.token}",
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
                                                              // supprimerVideo(
                                                              //     video.id,
                                                              //     _btnController);
                                                              // Navigator.pop(
                                                              //     context);
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
            ])      )
    );
  }
}
