import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/service/api.dart';
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
          body: ListView(children: [
            Column(
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
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
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
                              left: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child:
                                CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.pinkAccent[400],
                          child: Text('L'),
                        ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.02,
                            ),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("Video de viteese maximale ?",
                                          softWrap: false,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                              fontSize: 19.5,
                                              color: Colors.black))),
                                  Container(
                                    child: TextButton(
                                      onPressed: () {
                                        print("WLL");
                                      },
                                      child: Row(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                        Icon(Icons.calendar_today_outlined,
                                            size: 18, color: Colors.grey),
                                        Text("Il y 6 mois | 10 Commentaires",
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
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.black),
                                                    Text("Modifier",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ))),
                                        PopupMenuItem(
                                            value: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text("Supprimer",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ]),
                                            )),
                                      ]))
                        ])),
                        Divider(),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.40,
                          child: Card(
                            color: Colors.grey[200],
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                            child: ListView(
                              children : [
                                  
                                  
                                  Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.001,
                        left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              // top: MediaQuery.of(context).size.height * 0.00,
                              left: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child:
                                CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.lightGreen[900],
                          child: Text('G'),
                        ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Card(
                              elevation: 0,
                              child :Container(
                            padding: EdgeInsets.all(14),
                                
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("gaetan.apsa@gmail.com",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("Cette vidéo est incroyable, la vitesse n'a jamais été mon truc mais là ça y est !",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black))
                                  )
                                ]),
                          ))),
                          Container(
                              margin: EdgeInsets.only(
                                  // top: MediaQuery.of(context).size.height * 0.08,
                                  // left: MediaQuery.of(context).size.width * 0.0,
                                  ),
                              child: PopupMenuButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.grey, size: 20),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.black),
                                                    Text("Modifier",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ))),
                                        PopupMenuItem(
                                            value: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text("Supprimer",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ]),
                                            )),
                                      ]))
                        ])),


                                  Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.001,
                        left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              // top: MediaQuery.of(context).size.height * 0.00,
                              left: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child:
                                CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.purple,
                          child: Text('B'),
                        ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Card(
                              elevation: 0,
                              child :Container(
                            padding: EdgeInsets.all(14),
                                
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("gaetan.apsa@gmail.com",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("Cette vidéo est incroyable, la vitesse n'a jamais été mon truc mais là ça y est !",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black))
                                  )
                                ]),
                          ))),
                          Container(
                              margin: EdgeInsets.only(
                                  // top: MediaQuery.of(context).size.height * 0.08,
                                  // left: MediaQuery.of(context).size.width * 0.0,
                                  ),
                              child: PopupMenuButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.grey, size: 20),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.black),
                                                    Text("Modifier",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ))),
                                        PopupMenuItem(
                                            value: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text("Supprimer",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ]),
                                            )),
                                      ]))
                        ])),


                                                          Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.001,
                        left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              // top: MediaQuery.of(context).size.height * 0.00,
                              left: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child:
                                CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.pink[900],
                          child: Text('M'),
                        ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Card(
                              elevation: 0,
                              child :Container(
                            padding: EdgeInsets.all(14),
                                
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("gaetan.apsa@gmail.com",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("Cette vidéo est incroyable, la vitesse n'a jamais été mon truc mais là ça y est !",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black))
                                  )
                                ]),
                          ))),
                          Container(
                              margin: EdgeInsets.only(
                                  // top: MediaQuery.of(context).size.height * 0.08,
                                  // left: MediaQuery.of(context).size.width * 0.0,
                                  ),
                              child: PopupMenuButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.grey, size: 20),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.black),
                                                    Text("Modifier",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ))),
                                        PopupMenuItem(
                                            value: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text("Supprimer",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ]),
                                            )),
                                      ]))
                        ])),



                                                          Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.001,
                        left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              // top: MediaQuery.of(context).size.height * 0.00,
                              left: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child:
                                CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.orange[900],
                          child: Text('D'),
                        ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Card(
                              elevation: 0,
                              child :Container(
                            padding: EdgeInsets.all(14),
                                
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("gaetan.apsa@gmail.com",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("Cette vidéo est incroyable, la vitesse n'a jamais été mon truc mais là ça y est !",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black))
                                  )
                                ]),
                          ))),
                          Container(
                              margin: EdgeInsets.only(
                                  // top: MediaQuery.of(context).size.height * 0.08,
                                  // left: MediaQuery.of(context).size.width * 0.0,
                                  ),
                              child: PopupMenuButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.grey, size: 20),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.black),
                                                    Text("Modifier",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ))),
                                        PopupMenuItem(
                                            value: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text("Supprimer",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ]),
                                            )),
                                      ]))
                        ])),



                                                          Container(
                    // height: MediaQuery.of(context).size.height * 0.1,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.001,
                        left: MediaQuery.of(context).size.width * 0.08,
                    ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              // top: MediaQuery.of(context).size.height * 0.00,
                              left: MediaQuery.of(context).size.width * 0.0,
                            ),
                            child:
                                CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.lightBlue[900],
                          child: Text('J'),
                        ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Card(
                              elevation: 0,
                              child :Container(
                            padding: EdgeInsets.all(14),
                                
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("gaetan.apsa@gmail.com",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.black))),
                                  Container(
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: Text("Cette vidéo est incroyable, la vitesse n'a jamais été mon truc mais là ça y est !",
                                          softWrap: true,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black))
                                  )
                                ]),
                          ))),
                          Container(
                              margin: EdgeInsets.only(
                                  // top: MediaQuery.of(context).size.height * 0.08,
                                  // left: MediaQuery.of(context).size.width * 0.0,
                                  ),
                              child: PopupMenuButton(
                                  color: Colors.white,
                                  icon: Icon(Icons.more_vert,
                                      color: Colors.grey, size: 20),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                            value: 1,
                                            child: TextButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.edit,
                                                        color: Colors.black),
                                                    Text("Modifier",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ],
                                                ))),
                                        PopupMenuItem(
                                            value: 2,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: Row(children: [
                                                Icon(Icons.delete_outline,
                                                    color: Colors.red),
                                                Text("Supprimer",
                                                    style: TextStyle(
                                                        color: Colors.red)),
                                              ]),
                                            )),
                                      ]))
                        ])),


                              ]
                            )),
                          ),
            ],
          ),])
        ));
  }
}
