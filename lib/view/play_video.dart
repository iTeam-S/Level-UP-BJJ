import 'dart:async';

import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/model/video.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/view/screen/video_page.dart';
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
        "${apiController.url}/api/v1/get_video/${currentVideoController.video!.nom}?token=${userController.user.token}");

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

    userController.user.video['pos'] = {
      'minutes': userController.user.video['pos'].inMinutes,
      'seconds': userController.user.video['pos'].inSeconds
    };
    Map usrTmp = {
      'email': userController.email,
      'admin': userController.user.admin,
      'id': userController.user.id,
      'token': userController.user.token,
      'video': userController.user.video
    };

    box.write('user', usrTmp);
    userController.user.video['pos'] = Duration(
        minutes: userController.user.video['pos']['minutes'],
        seconds: userController.user.video['pos']['seconds']);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 45,
            backgroundColor: Colors.blue[400],
            title: Text('Lecture de vidéo',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "ProductSans",
                    fontSize: 17)),
            centerTitle: true,
            actions: [
              Stack(children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.017,
                      right: MediaQuery.of(context).size.height * 0.02),
                  child: Icon(Icons.notifications_sharp),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.018,
                  right: MediaQuery.of(context).size.height * 0.02,
                  child: Icon(Icons.brightness_1, size: 10, color: Colors.red),
                )
              ]),
            ],
            actionsIconTheme: IconThemeData(color: Colors.white, size: 21),
          ),
          body: Column(
            children: <Widget>[
              Container(
                child: Center(
                  child: _chewieController != null &&
                          _chewieController!
                              .videoPlayerController.value.isInitialized
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.31,
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
            ],
          ),
        ));
  }
}
