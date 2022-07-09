import 'dart:async';
import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/data.dart';
import 'package:bjj_library/model/module.dart';
import 'package:bjj_library/model/video.dart';
import 'package:bjj_library/service/api.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/view/screen/drawer.dart';
import 'package:bjj_library/view/screen/video_page.dart';
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
  String modulNiveauController = '0';

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
                      keyboardType: TextInputType.none,
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
                      alignment: Alignment.center,
                      width: 200,
                      padding: EdgeInsets.only(left: 5),
                      height: MediaQuery.of(context).size.height * 0.08,
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                        // vertical: MediaQuery.of(context).size.height*0.0110
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: modulNiveauController,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconDisabledColor: Colors.lightBlue[800],
                            iconEnabledColor: Colors.lightBlue[800],
                            iconSize: 25,
                            underline: SizedBox(),
                            hint: Text("Niveau",
                                style: TextStyle(fontSize: 14)),
                            items: [
                                DropdownMenuItem(
                                  child: Text("Niveau"),
                                  value: '0',
                                ),
                                DropdownMenuItem(
                                  child: Text("Débutant"),
                                  value: '1',
                                ),
                                DropdownMenuItem(
                                  child: Text("Avancé"),
                                  value: '2',
                                ),    
                            ],
                            onChanged: (value) {
                              modulNiveauController =
                                  value.toString();
                              //dataController.forceUpdate();
                              Navigator.pop(context);
                              addVideo(context, moduleList);
                            },
                          ),
                        ),
                      ),
                    ),
                 Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.06,
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.09,
                    vertical: MediaQuery.of(context).size.height*0.0110,
                  ),
                  child: DropdownButton(
                    value: uploadVideoDataController.moduleChoix,
                    icon: Icon(Icons.arrow_drop_down_circle),
                    iconDisabledColor: Colors.lightBlue[800],
                    iconEnabledColor: Colors.lightBlue[800],
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
                  ),
                ),
               
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.06,
                    // vertical:MediaQuery.of(context).size.height*0.01
                  ),
                  child: RoundedLoadingButton(
                    color: Colors.lightBlue[800],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      if (uploadVideoDataController.titre.text.trim() == '' ||
                          uploadVideoDataController.videopath.trim() == '' ||
                          uploadVideoDataController.moduleChoix == 'Tous' || 
                          modulNiveauController == "0") {
                        Get.snackbar(
                          "Erreur",
                          "Données manquantes",
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
                            uploadVideoDataController.videopath,
                            modulNiveauController);

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
    if (userController.user.admin)
      appController.trtNotifs(userController.user.id, userController.user.token);
    else
      appController.verifexp(userController.user);
    
    appController.trtVideos(userController.user.id, userController.user.token);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: " + focus.hasFocus.toString());
    if (focus.hasFocus) _openFileExplorer();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
        builder: (_) => Scaffold(
              appBar: AppBar(
                toolbarHeight: 45,
                backgroundColor: Colors.lightBlue[800],
                title: Text('BJJ-Library',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: "ProductSans",
                        fontSize: 17)),
                centerTitle: true,
                actions: userController.user.admin
                    ? [
                        Stack(children: [
                          Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height *
                                      0.005,
                                  right: MediaQuery.of(context).size.height *
                                      0.006),
                              child: PopupMenuButton(
                                  offset: Offset(
                                      MediaQuery.of(context).size.width * 0,
                                      MediaQuery.of(context).size.height *
                                          0.05),
                                  color: Colors.white,
                                  icon: Icon(Icons.notifications_sharp,
                                      color: Colors.white, size: 20),
                                  itemBuilder: (context) => [
                                        PopupMenuItem(
                                          child: Container(
                                            height: Get.height * .33,
                                            width: Get.width,
                                            child: ListView(
                                              children: [
                                                for (var notif
                                                    in appController.notifs)
                                                  GestureDetector(
                                                    onTap: () {
                                                      for (Module mod
                                                          in appController
                                                              .getmoduleList())
                                                        for (Video vid
                                                            in mod.videos)
                                                          if (vid.id ==
                                                              notif[
                                                                  'video_id']) {
                                                            appController.viewNotif(
                                                                userController
                                                                    .user.id,
                                                                userController
                                                                    .user.token,
                                                                notif['id']);
                                                            currentVideoController
                                                                .video = vid;
                                                            Get.toNamed(
                                                                '/video');
                                                          }
                                                    },
                                                    child: Container(
                                                      child: Column(children: [
                                                        Container(
                                                            width:
                                                                Get.width * .65,
                                                            // height: MediaQuery.of(context).size.height * 0.1,
                                                            margin:
                                                                EdgeInsets.only(
                                                              top: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.001,
                                                            ),
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    margin:
                                                                        EdgeInsets
                                                                            .only(
                                                                      // top: MediaQuery.of(context).size.height * 0.00,
                                                                      right: MediaQuery.of(context)
                                                                              .size
                                                                              .width *
                                                                          0.025,
                                                                    ),
                                                                    child: Icon(
                                                                        Icons
                                                                            .comment_sharp,
                                                                        color: Colors
                                                                            .green),
                                                                  ),
                                                                  Container(
                                                                      margin: EdgeInsets
                                                                          .only(
                                                                        top: MediaQuery.of(context).size.height *
                                                                            0.01,
                                                                      ),
                                                                      child: Card(
                                                                          elevation: 0,
                                                                          child: Container(
                                                                            child:
                                                                                Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                                                                              Container(width: MediaQuery.of(context).size.width * 0.5, child: Text("${notif['mail']}", softWrap: false, overflow: TextOverflow.clip, textAlign: TextAlign.start, style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.black))),
                                                                              Container(width: MediaQuery.of(context).size.width * 0.5, child: Text("a commenté la video ${notif['titre']}", softWrap: true, textAlign: TextAlign.start, style: TextStyle(fontSize: 13, color: Colors.black87)))
                                                                            ]),
                                                                          ))),
                                                                ])),
                                                        Divider(),
                                                      ]),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ])),
                          if (appController.notifs.length != 0)
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.018,
                              right: MediaQuery.of(context).size.height * 0.012,
                              child: CircleAvatar(
                                radius: 7.5,
                                backgroundColor: Colors.red,
                                child: Text("${appController.notifs.length}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10)),
                              ),
                            )
                        ]),

                      ]
                    : null,
                actionsIconTheme: IconThemeData(color: Colors.white, size: 21),
              ),
              drawer: AppDrawer(),
              body: Container(
                color: Colors.lightBlue[100],
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white60,
                        child:  TextField(
                          controller: userController.searchController,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[800]),
                              decoration: InputDecoration(
                                filled: false,
                                fillColor: Colors.blue[50],
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.auto,
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(
                                                90.0)),
                                    borderSide:
                                        BorderSide.none),
                                focusedBorder:
                                    OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.all(
                                                Radius.circular(
                                                    90.0)),
                                        borderSide:
                                            BorderSide.none),
                                hintText: "Champ de recherche",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    if (userController.searchController.text.length < 3 ){
                                      return appController.errorSnack("Veuillez entrer au moins 3 caractères");
                                    }
                                    Get.toNamed('/search');
                                  } ,
                                  icon: Icon(Icons.search_outlined,
                                      color: Colors.lightBlue[800]),
                                ),
                                // prefixIcon: 
                              ),
                        ),
                      ),
                      Container(
                        height: Get.height * 0.85,
                        child: videoAllModule(context, appController.getmoduleList())),
                    ],
                  ),
                ),
              ),
              floatingActionButton: userController.user.admin
                  ? FloatingActionButton(
                      onPressed: () {
                        addVideo(context, appController.getmoduleList());
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.lightBlue[800],
                      elevation: 10,
                    )
                  : null,
            ));
  }
}
