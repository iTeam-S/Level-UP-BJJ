import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/view/screen/gestion_video.dart';
import 'package:bjj_library/view/screen/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool status1 = false;
  bool isSwitched = false;

  // Instance ana controlleur
  UserController userController = Get.put(UserController());
  ApiController apiController = Get.put(ApiController());
  AppController appController = Get.put(AppController());

  // stockena donnee ilaina apres fermeture application
  final box = GetStorage();

  late String fileName;
  late String path;
  late Map<String, String> paths;
  late List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  late FileType fileType;

  void _openFileExplorer() async {
    setState(() => isLoadingPath = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['avi', 'mkv', 'mp4'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;

        print(file.name);
        print(file.bytes);
        print(file.size);
        print(file.extension);
        print(file.path);
      } else {
        print("Annuler");
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  FocusNode _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    // appController.trtModules(userController.user.id, userController.user.token);
    // assemblé les données dans une seule requete.
    appController.trtVideos(userController.user.id, userController.user.token);
  }

  void _onFocusChange() {
    _openFileExplorer();
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
        builder: (_) => DefaultTabController(
            length: appController.moduleInit(context),
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 45,
                backgroundColor: Colors.blue[400],
                title: Text('BJJ-Library',
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
              drawer: AppDrawer(),
              bottomNavigationBar: Container(
                color: Colors.black12,
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey[800],
                  labelColor: Colors.blue,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorPadding: EdgeInsets.all(5.0),
                  indicatorColor: Colors.blue,
                  tabs: [
                    for (Module module in appController.getmoduleList())
                      Tab(
                          text: module.nom,
                          icon: module.nom == 'Tous'
                              ? Icon(Icons.video_library_outlined, size: 20)
                              : Icon(Icons.camera, size: 20)
                      ),
                  ],
                ),
              ),
              body: TabBarView(children: [
                for (Container contentPage
                    in appController.getmodulePageList(context))
                  contentPage
              ]),
              floatingActionButton: userController.user.admin
                ? FloatingActionButton(
                    onPressed: () {
                      addVideo(context);
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.blue,
                    elevation: 10,
                  )
                : null,
            )));
  }
}
