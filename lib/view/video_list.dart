import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/view/gradiant_icone.dart';

import 'package:bjj_library/view/screen/video_page.dart';
import 'package:flutter/material.dart';

import 'package:get_storage/get_storage.dart';

import 'package:get/get.dart';

class VideoListScreen extends StatefulWidget {
  @override
  _VideoListScreen createState() => _VideoListScreen();
}

class _VideoListScreen extends State<VideoListScreen> {
  // Instance ana controlleur
  AppController appController = Get.put(AppController());

  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      builder: (_) => DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.circle, color: Colors.white, size: 25), text: "Débutant"),
                Tab(
                  text: "Avancé",
                  icon: GradientIcon(
                    Icons.circle,
                    25.0,
                    LinearGradient(
                      colors: <Color>[
                        Colors.blue,
                        Colors.brown,
                        Colors.purple,
                        Colors.black
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ]),
              toolbarHeight: 45,
              backgroundColor: Colors.lightBlue[800],
              title: Text(appController.currModule.nom,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "ProductSans",
                      fontSize: 17)),
              centerTitle: true,
            ),
            body: TabBarView(
              children: [
                videoTabModule(context, 0),
                videoTabModule(context, 1)
              ],
            ),
        )
    
      )
    );
  }
}
