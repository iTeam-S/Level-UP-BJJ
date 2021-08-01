import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/service/api.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
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
      looping: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 45,
        backgroundColor: Colors.blue[400],
        title: Text('Lecture de vidéo',
            style: TextStyle(
                color: Colors.white, fontFamily: "ProductSans", fontSize: 17)),
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
    );
  }
}
