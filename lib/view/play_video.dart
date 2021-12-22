import 'dart:async';

import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/model/commentaire.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/model/video.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  UserController userController = Get.put(UserController());
  ApiController apiController = Get.put(ApiController());
  CurrentVideoController currentVideoController =
      Get.put(CurrentVideoController());
  final box = GetStorage();
  List<Module> modules = appController.getmoduleList();
  bool efaVita = false;
  List colorAvatar = [
    Colors.blue[900],
    Colors.blueGrey[200],
    Colors.pinkAccent[50],
    Colors.teal,
  ];

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(
        "$baseUrlProtocol/api/v1/get_video/${currentVideoController.video!.nom}?token=${userController.user.token}");

    _videoPlayerController.addListener(() {
    if (_videoPlayerController.value.duration ==
      _videoPlayerController.value.position) {
      //Debut algorithme.
      bool efaIzy = false;

      for (Module module in modules)
        if (module.nom != 'Tous')
          for (Video vid in module.videos) {
            if (efaIzy && !efaVita) {
              Timer(Duration(seconds: 1), () {
                currentVideoController.video = vid;
                Get.offNamed('/video', preventDuplicates: false);
              });
              efaVita = true;
              return;
            }
            if (currentVideoController.video!.id == vid.id) efaIzy = true;
            }
      }
    });

    await Future.wait([
      _videoPlayerController.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      startAt:
          userController.user.video['id'] == currentVideoController.video!.id
              ? userController.user.video['pos']
              : Duration(),
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.black,
      ),
      autoInitialize: true,
    );
  }

  Future<bool> _onWillPop() async {
    if (_videoPlayerController.value.duration ==
        _videoPlayerController.value.position) {
      userController.user.video['id'] = 0;
      userController.user.video['pos'] =
          Duration(minutes: 0, seconds: 0, milliseconds: 0);
    } else {
      userController.user.video['id'] = currentVideoController.video!.id;
      userController.user.video['pos'] = _videoPlayerController.value.position;
    }

    Map usrTmp = {
      'email': userController.user.email,
      'admin': userController.user.admin,
      'id': userController.user.id,
      'token': userController.user.token,
      'video': {
        'id': userController.user.video['id'],
        'pos': userController.user.video['pos'].inSeconds
      }
    };
    box.write('user', usrTmp);
    box.save();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrentVideoController>(
        builder: (_) => WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 45,
                  backgroundColor: Colors.lightBlue[800],
                  title: Text('Lecture de vidéo',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "ProductSans",
                          fontSize: 17)),
                  centerTitle: true,
                ),
                body: ListView(children: [
                  Column(
                    children: <Widget>[
                      Container(
                        child: Center(
                          child: _chewieController != null &&
                                  _chewieController!
                                      .videoPlayerController.value.isInitialized
                              ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.31,
                                  child: Theme(
                                      data: ThemeData.light().copyWith(
                                        platform: TargetPlatform.iOS,
                                      ),
                                      child: Chewie(
                                        controller: _chewieController!,
                                      )))
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 20),
                                    Text('Loading'),
                                  ],
                                ),
                        ),
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.001,
                            left: MediaQuery.of(context).size.width * 0.05,
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                    // top: MediaQuery.of(context).size.height * 0.00,
                                    left:
                                        MediaQuery.of(context).size.width * 0.0,
                                  ),
                                  child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.blueGrey,
                                      child: Text('BJJ',
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            child: Text(
                                                currentVideoController
                                                    .video!.titre,
                                                softWrap: false,
                                                overflow: TextOverflow.fade,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
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
                                                  Icon(
                                                      Icons
                                                          .calendar_today_outlined,
                                                      size: 18,
                                                      color: Colors.grey),
                                                  Text(
                                                      "Il y 6 mois | ${currentVideoController.video!.commentaire.length} commentaires",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .grey[700])),
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
                                    child: IconButton(
                                      onPressed: null,
                                      icon: Icon(
                                        Icons.delete_sweep,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ))
                              ])),
                      Divider(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        child: Card(
                            color: Colors.grey[50],
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13)),
                            child: ListView(children: [
                              for (Commentaire commentaire
                                  in currentVideoController.video!.commentaire)
                                Container(
                                    // height: MediaQuery.of(context).size.height * 0.1,
                                    margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.001,
                                      left: MediaQuery.of(context).size.width *
                                          0.08,
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            margin: EdgeInsets.only(
                                              // top: MediaQuery.of(context).size.height * 0.00,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.0,
                                            ),
                                            child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: colorAvatar[
                                                  commentaire.userid %
                                                      colorAvatar.length],
                                              child: Text(commentaire.email[0]
                                                  .toUpperCase()),
                                            ),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.01,
                                              ),
                                              child: Card(
                                                  elevation: 0,
                                                  child: Container(
                                                    padding: EdgeInsets.all(14),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.50,
                                                              child: Text(
                                                                  commentaire
                                                                      .email,
                                                                  softWrap:
                                                                      true,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontSize:
                                                                          17,
                                                                      color: Colors
                                                                          .black))),
                                                          Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.50,
                                                              child: Text(
                                                                  commentaire
                                                                      .text,
                                                                  softWrap:
                                                                      true,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                              .grey[
                                                                          850])))
                                                        ]),
                                                  ))),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  // top: MediaQuery.of(context).size.height * 0.08,
                                                  // left: MediaQuery.of(context).size.width * 0.0,
                                                  ),
                                              child: userController.user.admin
                                                  ? IconButton(
                                                      onPressed: null,
                                                      icon: Icon(
                                                        Icons.delete_sweep,
                                                        size: 20,
                                                      ),
                                                    )
                                                  : IconButton(
                                                      onPressed: null,
                                                      icon: Icon(
                                                        Icons.delete_sweep,
                                                        size: 20,
                                                        color: Colors.grey[50],
                                                      ),
                                                    ))
                                        ])),
                            ])),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.6,
                            margin: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height *
                                    0.0113),
                            child: TextField(
                              controller: appController.newComment,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[800]),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.blue[50],
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none),
                                focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(90.0)),
                                    borderSide: BorderSide.none),
                                hintText: "Votre commentaire...",
                                prefixIcon: Icon(
                                  Icons.message_outlined,
                                  color: Colors.blue,
                                  size: 17.5,
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.lightBlue[900]),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50))),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                  vertical: MediaQuery.of(context).size.height *
                                      0.025,
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.044,
                                )),
                                elevation: MaterialStateProperty.all(0)),
                            onPressed: () {
                              if (appController.newComment.text.trim() == '')
                                return;
                              void sendComment() async {
                                //String textsave = appController.newComment.text;

                                bool res = await appController.sendComment(
                                    userController.user.id,
                                    userController.user.token,
                                    appController.newComment.text,
                                    currentVideoController.video!.id);

                                if (res) {
                                  currentVideoController.video!.commentaire.add(
                                      Commentaire(
                                          id: 0,
                                          text: appController.newComment.text,
                                          userid: userController.user.id,
                                          email: userController.user.email));
                                  appController.newComment.text = '';
                                  Get.snackbar(
                                    "Succes",
                                    "Votre Commentaire a été ajouté.",
                                    backgroundColor: Colors.grey,
                                    snackPosition: SnackPosition.BOTTOM,
                                    borderColor: Colors.grey,
                                    borderRadius: 10,
                                    borderWidth: 2,
                                    barBlur: 0,
                                    duration: Duration(seconds: 2),
                                  );
                                  currentVideoController.update();
                                }
                              }

                              sendComment();
                            },
                            icon: Icon(Icons.send),
                            label: Text("Commenter"),
                          )
                        ],
                      )
                    ],
                  ),
                ]))));
  }
}
