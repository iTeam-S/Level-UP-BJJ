import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';


class VideoScreen extends StatefulWidget {
  const VideoScreen({
    Key? key,
  }) : super(key: key);
  
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoPlayerController1;
  late VideoPlayerController _videoPlayerController2;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController2.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController2 = VideoPlayerController.network('http://192.168.137.1:4444/api/v1/get_video/1627756931.5752923Juliano.mp4?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgzMzI3NjAsInN1YiI6Mn0.htGeu_xrEVW822r_kQIaUYQA2HLRKc5KNHzG-6DJf6E');

    await Future.wait([
      _videoPlayerController2.initialize(),
    ]);
    _createChewieController();
    setState(() {});
  }

    void _createChewieController() {

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController2,
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
              child:
                  Icon(Icons.brightness_1, size: 10, color: Colors.red),
            )
          ]),
        ],
        actionsIconTheme: IconThemeData(color: Colors.white, size: 21),
      ),

      body: Column(
        children: <Widget>[
          Container(
            child: Center(
              child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                ? Container(
                  height: MediaQuery.of(context).size.height * 0.31,
                  child: Theme(
                      data: ThemeData.light().copyWith(
                      platform: TargetPlatform.iOS,
                    ),
                    child :Chewie(
                      controller: _chewieController!,
                    )
                  ))
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
