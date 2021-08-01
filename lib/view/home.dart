import 'dart:async';
import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/view/screen/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

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
  UploadVideoDataController uploadVideoDataController =
      Get.put(UploadVideoDataController());

  // stockena donnee ilaina apres fermeture application
  final box = GetStorage();

  late String fileName;
  late String path;
  late Map<String, String> paths;
  late List<String> extensions;
  bool isLoadingPath = false;
  bool isMultiPick = false;
  late FileType fileType;

  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  FocusNode focus = FocusNode();

  void addVideo(context, moduleList) {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                "Ajouter une vidéo",
              ),
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                        vertical: MediaQuery.of(context).size.height * 0.0113),
                    child: TextField(
                      controller: uploadVideoDataController.titre,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Titre",
                        prefixIcon: Icon(Icons.edit, color: Colors.blue),
                      ),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      // vertical: MediaQuery.of(context).size.height*0.0110
                    ),
                    child: TextField(
                      controller: uploadVideoDataController.videotitle,
                      focusNode: focus,
                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.blue[50],
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(90.0)),
                            borderSide: BorderSide.none),
                        hintText: "Video",
                        prefixIcon: Icon(Icons.video_library_outlined,
                            color: Colors.blue),
                      ),
                    )),
                Container(
                  height: MediaQuery.of(context).size.height * 0.06,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.09,
                    // vertical: MediaQuery.of(context).size.height*0.0110,
                  ),
                  child: Row(children: [
                    DropdownButton(
                      value: uploadVideoDataController.moduleChoix,
                      icon: Icon(Icons.arrow_drop_down_circle),
                      iconDisabledColor: Colors.blue[400],
                      iconEnabledColor: Colors.blue[400],
                      iconSize: 25,
                      underline: SizedBox(),
                      hint: Text(uploadVideoDataController.moduleChoix,
                          style: TextStyle(fontSize: 14)),
                      items: [
                        for (Module mod in moduleList)
                          DropdownMenuItem(
                            child: Text(mod.nom),
                            value: mod.nom,
                          ),
                      ],
                      onChanged: (value) {
                        uploadVideoDataController.moduleChoix =
                            value.toString();
                        //dataController.forceUpdate();
                        Navigator.pop(context);
                        addVideo(context, moduleList);
                      },
                    )
                  ]),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                    // vertical:MediaQuery.of(context).size.height*0.01
                  ),
                  child: RoundedLoadingButton(
                    color: Colors.blue[400],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      if (uploadVideoDataController.titre.text.trim() == '' ||
                          uploadVideoDataController.videopath.trim() == '' ||
                          uploadVideoDataController.moduleChoix == 'Tous') {
                        Get.snackbar(
                          "Erreur",
                          "Champ manquante",
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                          snackPosition: SnackPosition.BOTTOM,
                          borderColor: Colors.red,
                          borderRadius: 10,
                          borderWidth: 2,
                          barBlur: 0,
                          duration: Duration(seconds: 2),
                        );
                        Timer(Duration(seconds: 2), () {
                          _btnController.reset();
                        });
                        _btnController.error();
                        return;
                      }

                      Future uploadVideo() async {
                        bool res = await appController.uploadVideo(
                            userController.user.id,
                            userController.user.token,
                            appController.getModuleId(
                                uploadVideoDataController.moduleChoix),
                            uploadVideoDataController.titre.text,
                            uploadVideoDataController.videopath);

                        if (res) {
                          uploadVideoDataController.videopath = '';
                          uploadVideoDataController.videotitle.text = '';
                          _btnController.success();
                          Get.snackbar(
                            "Ajout",
                            "La vidéo a été bien ajoutée.",
                            backgroundColor: Colors.grey,
                            snackPosition: SnackPosition.BOTTOM,
                            borderColor: Colors.grey,
                            borderRadius: 10,
                            borderWidth: 2,
                            barBlur: 0,
                            duration: Duration(seconds: 2),
                          );
                          Timer(Duration(seconds: 2), () {
                            _btnController.reset();
                            Get.back();
                            appController.trtVideos(userController.user.id,
                                userController.user.token);
                          });
                        } else {
                          _btnController.error();
                          Timer(Duration(seconds: 2), () {
                            _btnController.reset();
                          });
                        }
                      }

                      uploadVideo();
                    },
                    valueColor: Colors.white,
                    borderRadius: 90,
                    child:
                        Text("AJOUTER", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ));
  }

  dynamic _openFileExplorer() async {
    setState(() => isLoadingPath = true);
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['avi', 'mkv', 'mp4'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        uploadVideoDataController.videopath = file.path.toString();
        uploadVideoDataController.videotitle.text = file.name;
        uploadVideoDataController.forceUpdate();
      } else {
        print("Annuler");
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    focus.addListener(_onFocusChange);
    // appController.trtModules(userController.user.id, userController.user.token);
    // assemblé les données dans une seule requete.
    appController.trtVideos(userController.user.id, userController.user.token);
  }

  void _onFocusChange() {
    debugPrint("Focus: " + focus.hasFocus.toString());
    if (focus.hasFocus) _openFileExplorer();
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
                              : Icon(Icons.motion_photos_on, size: 20)
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
                        addVideo(context, appController.getmoduleList());
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.blue,
                      elevation: 10,
                    )
                  : null,
            )));
  }
}
