import 'package:bjj_library/controller/app.dart';
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
          body: videoListQuery(context, userController.searchController.text)     
        )
    );
  }
}
