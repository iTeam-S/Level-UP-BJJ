import 'package:bjj_library/controller/api.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  bool status1 = false;
  bool isSwitched = false;

  // Instance ana controlleur
  UserController userController = Get.put(UserController());
  ApiController apiController = Get.put(ApiController());

  // stockena donnee ilaina apres fermeture application
  final box = GetStorage();

  void _doSomething(RoundedLoadingButtonController controller) async {
    Timer(Duration(seconds: 2), () {
      controller.success();
    });
  }

  void changePassword() {
    showDialog(
        context: context,
        builder: (BuildContext context) => SimpleDialog(
              title: Text(
                "Changement de mot de passe",
              ),
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.06,
                        vertical: MediaQuery.of(context).size.height * 0.0113),
                    child: TextField(
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
                        hintText: "Ancien mot de passe",
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    )),
                Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                    ),
                    child: TextField(
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
                        hintText: "Nouveau mot de passe",
                        prefixIcon: Icon(Icons.lock, color: Colors.blue),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.06,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  child: RoundedLoadingButton(
                    color: Colors.blue[400],
                    successColor: Colors.blue,
                    controller: _btnController,
                    onPressed: () {
                      _doSomething(_btnController);
                      Navigator.pop(context);
                      Get.snackbar(
                        "Modification",
                        "Votre mot de passe a été modifié.",
                        backgroundColor: Colors.grey,
                        snackPosition: SnackPosition.BOTTOM,
                        borderColor: Colors.grey,
                        borderRadius: 10,
                        borderWidth: 2,
                        barBlur: 0,
                        duration: Duration(seconds: 2),
                      );
                    },
                    valueColor: Colors.white,
                    borderRadius: 90,
                    child: Text("ENREGISTRER",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ));
  }

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
  }

  void _onFocusChange() {
    _openFileExplorer();
    debugPrint("Focus: " + _focus.hasFocus.toString());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
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
                  child: Icon(Icons.brightness_1, size: 10, color: Colors.red),
                )
              ]),
            ],
            actionsIconTheme: IconThemeData(color: Colors.white, size: 21),
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      'assets/images/cover.jpg',
                      width: MediaQuery.of(context).size.width,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.048,
                      ),
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1,
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                    AssetImage('assets/images/avatar.jpg'),
                              )),
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.1,
                                top: MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: Text(userController.user.email,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.1,
                            ),
                            child: Text(
                                userController.user.admin
                                    ? 'Administrateur'
                                    : 'Utilisateur',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white54,
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.73,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              children: userController.user.admin
                                  ? [
                                      ListTile(
                                        leading: Icon(
                                            Icons.video_collection_outlined,
                                            color: Colors.blue[400]),
                                        title: Text("Vidéos"),
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.add_outlined,
                                            color: Colors.blue[400]),
                                        title: Text("Ajouter un module"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  SimpleDialog(
                                                    title: Text(
                                                      "Ajouter un module",
                                                    ),
                                                    children: [
                                                      Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.08,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                          ),
                                                          child: TextField(
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .grey[800]),
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .blue[50],
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              90.0)),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none),
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              90.0)),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none),
                                                              hintText:
                                                                  "Module",
                                                              prefixIcon: Icon(
                                                                  Icons
                                                                      .edit_outlined,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          )),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01),
                                                        child:
                                                            RoundedLoadingButton(
                                                          color:
                                                              Colors.blue[400],
                                                          successColor:
                                                              Colors.blue,
                                                          controller:
                                                              _btnController,
                                                          onPressed: () {
                                                            _doSomething(
                                                                _btnController);
                                                            Navigator.pop(
                                                                context);
                                                            Get.snackbar(
                                                              "Ajout",
                                                              "Le module a été enregistré avec succès",
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              borderColor:
                                                                  Colors.grey,
                                                              borderRadius: 10,
                                                              borderWidth: 2,
                                                              barBlur: 0,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            );
                                                          },
                                                          valueColor:
                                                              Colors.white,
                                                          borderRadius: 90,
                                                          child: Text("AJOUTER",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.edit_outlined,
                                            color: Colors.blue[400]),
                                        title: Text("Modifier un module"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  SimpleDialog(
                                                    title: Text(
                                                      "Modifier un module",
                                                    ),
                                                    children: [
                                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      Row(children: [
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.06,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.09,
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.0115,
                                                          ),
                                                          child: Row(children: [
                                                            DropdownButton(
                                                                icon: Icon(Icons
                                                                    .arrow_drop_down_circle),
                                                                iconDisabledColor:
                                                                    Colors.blue[
                                                                        400],
                                                                iconEnabledColor:
                                                                    Colors.blue[
                                                                        400],
                                                                iconSize: 20,
                                                                underline:
                                                                    SizedBox(),
                                                                hint: Text(
                                                                    'Module',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14)),
                                                                items: [
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                        'Course'),
                                                                    value: 1,
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                        'Pompe'),
                                                                    value: 2,
                                                                  ),
                                                                  DropdownMenuItem(
                                                                    child: Text(
                                                                        'Traction'),
                                                                    value: 3,
                                                                  ),
                                                                ],
                                                                onChanged:
                                                                    (value) =>
                                                                        print(
                                                                            value))
                                                          ]),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets.only(
                                                              // left: MediaQuery.of(context).size.width*0.15,
                                                              ),
                                                          child: IconButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    AlertDialog(
                                                                  title: const Text(
                                                                      "Suppression d'un module"),
                                                                  content:
                                                                      const Text(
                                                                          'Voulez-vous vraiment supprimer ce module ?'),
                                                                  actions: [
                                                                    TextButton(
                                                                      onPressed: () => Navigator.pop(
                                                                          context,
                                                                          'Annuler'),
                                                                      child: const Text(
                                                                          'Annuler'),
                                                                    ),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        _doSomething(
                                                                            _btnController);
                                                                        Navigator.pop(
                                                                            context);
                                                                        Get.snackbar(
                                                                          "Suppression",
                                                                          "Le module a été supprimé.",
                                                                          backgroundColor:
                                                                              Colors.grey,
                                                                          snackPosition:
                                                                              SnackPosition.BOTTOM,
                                                                          borderColor:
                                                                              Colors.grey,
                                                                          borderRadius:
                                                                              10,
                                                                          borderWidth:
                                                                              2,
                                                                          barBlur:
                                                                              0,
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                          'OK'),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            icon: Icon(
                                                                Icons.delete,
                                                                color: Colors
                                                                    .red[400],
                                                                size: 22),
                                                          ),
                                                        ),
                                                      ]),
                                                      Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.08,
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                          ),
                                                          child: TextField(
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .grey[800]),
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor: Colors
                                                                  .blue[50],
                                                              border: OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              90.0)),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none),
                                                              focusedBorder: UnderlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              90.0)),
                                                                  borderSide:
                                                                      BorderSide
                                                                          .none),
                                                              hintText:
                                                                  "Nouveau nom de module",
                                                              prefixIcon: Icon(
                                                                  Icons
                                                                      .edit_outlined,
                                                                  color: Colors
                                                                      .blue),
                                                            ),
                                                          )),
                                                      Container(
                                                        margin: EdgeInsets.symmetric(
                                                            horizontal:
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                            vertical: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.01),
                                                        child:
                                                            RoundedLoadingButton(
                                                          color:
                                                              Colors.blue[400],
                                                          successColor:
                                                              Colors.blue,
                                                          controller:
                                                              _btnController,
                                                          onPressed: () {
                                                            _doSomething(
                                                                _btnController);
                                                            Navigator.pop(
                                                                context);
                                                            Get.snackbar(
                                                              "Modification",
                                                              "Le nom de module a été modifié",
                                                              backgroundColor:
                                                                  Colors.grey,
                                                              snackPosition:
                                                                  SnackPosition
                                                                      .BOTTOM,
                                                              borderColor:
                                                                  Colors.grey,
                                                              borderRadius: 10,
                                                              borderWidth: 2,
                                                              barBlur: 0,
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            );
                                                          },
                                                          valueColor:
                                                              Colors.white,
                                                          borderRadius: 90,
                                                          child: Text(
                                                              "ENREGISTRER",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                    ],
                                                  ));
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.lock,
                                            color: Colors.blue[400]),
                                        title: Text("Changer mot de passe"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          changePassword();
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.logout_outlined,
                                            color: Colors.blue[400]),
                                        title: Text("Deconnexion"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text("Deconnexion"),
                                              content: const Text(
                                                  'Voulez-vous vraiment vous déconnecter ?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Annuler'),
                                                  child: const Text('Annuler'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    box.remove('user');
                                                    Get.offNamed('/login');
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ]
                                  : [
                                      ListTile(
                                        leading: Icon(Icons.lock,
                                            color: Colors.blue[400]),
                                        title: Text("Changer mot de passe"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          changePassword();
                                        },
                                      ),
                                      Divider(),
                                      ListTile(
                                        leading: Icon(Icons.logout_outlined,
                                            color: Colors.blue[400]),
                                        title: Text("Deconnexion"),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                              title: const Text("Deconnexion"),
                                              content: const Text(
                                                  'Voulez-vous vraiment vous déconnecter ?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'Annuler'),
                                                  child: const Text('Annuler'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    box.remove('user');
                                                    Get.offNamed('/login');
                                                  },
                                                  child: Text('OK'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ]),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'BJJ-Library 0.0.6',
                              style: TextStyle(fontSize: 12),
                            ),
                          )
                        ]))
              ],
            ),
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(children: [
            Container(
              child: ListView(children: [
                Column(children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.02,
                        left: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Text(
                                    "Course",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.centerRight,
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Row(children: [
                                          Text("Tout voir",
                                              style: TextStyle(
                                                  color: Colors.blue[400],
                                                  fontWeight: FontWeight.bold)),
                                          Icon(Icons.chevron_right_outlined,
                                              color: Colors.blue[400]),
                                        ])))
                              ]),
                          Container(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.11,
                                                    vertical:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.07),
                                                child: Icon(
                                                  Icons.play_arrow,
                                                  color: Colors.blue[400],
                                                  size: 30,
                                                )),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    color: Colors.white,
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                              value: 1,
                                                              child: TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    showDialog(
                                                                        context:
                                                                            context,
                                                                        builder: (BuildContext
                                                                                context) =>
                                                                            SimpleDialog(
                                                                              title: Text(
                                                                                "Modification d'une vidéo",
                                                                              ),
                                                                              children: [
                                                                                Container(
                                                                                    height: MediaQuery.of(context).size.height * 0.08,
                                                                                    margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06, vertical: MediaQuery.of(context).size.height * 0.0113),
                                                                                    child: TextField(
                                                                                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.blue[50],
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(90.0)), borderSide: BorderSide.none),
                                                                                        focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(90.0)), borderSide: BorderSide.none),
                                                                                        hintText: "Titre",
                                                                                        prefixIcon: Icon(Icons.edit, color: Colors.blue),
                                                                                      ),
                                                                                    )),
                                                                                Container(
                                                                                    height: MediaQuery.of(context).size.height * 0.08,
                                                                                    margin: EdgeInsets.symmetric(
                                                                                      horizontal: MediaQuery.of(context).size.width * 0.06,
                                                                                    ),
                                                                                    child: TextField(
                                                                                      style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                                                                                      decoration: InputDecoration(
                                                                                        filled: true,
                                                                                        fillColor: Colors.blue[50],
                                                                                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(90.0)), borderSide: BorderSide.none),
                                                                                        focusedBorder: UnderlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(90.0)), borderSide: BorderSide.none),
                                                                                        hintText: "Module",
                                                                                        prefixIcon: Icon(Icons.edit, color: Colors.blue),
                                                                                      ),
                                                                                    )),
                                                                                Container(
                                                                                  margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.06, vertical: MediaQuery.of(context).size.height * 0.01),
                                                                                  child: RoundedLoadingButton(
                                                                                    color: Colors.blue[400],
                                                                                    successColor: Colors.blue,
                                                                                    controller: _btnController,
                                                                                    onPressed: () {
                                                                                      _doSomething(_btnController);
                                                                                      Navigator.pop(context);
                                                                                      Get.snackbar(
                                                                                        "Modification",
                                                                                        "La vidéo a été bien modifiée.",
                                                                                        backgroundColor: Colors.grey,
                                                                                        snackPosition: SnackPosition.BOTTOM,
                                                                                        borderColor: Colors.grey,
                                                                                        borderRadius: 10,
                                                                                        borderWidth: 2,
                                                                                        barBlur: 0,
                                                                                        duration: Duration(seconds: 2),
                                                                                      );
                                                                                    },
                                                                                    valueColor: Colors.white,
                                                                                    borderRadius: 90,
                                                                                    child: Text("ENREGISTRER", style: TextStyle(color: Colors.white)),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ));
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.black),
                                                                      Text(
                                                                          "Modifier",
                                                                          style:
                                                                              TextStyle(color: Colors.black)),
                                                                    ],
                                                                  ))),
                                                          PopupMenuItem(
                                                              value: 2,
                                                              child: TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext
                                                                            context) =>
                                                                        AlertDialog(
                                                                      title: const Text(
                                                                          "Suppression d'une vidéo"),
                                                                      content:
                                                                          const Text(
                                                                              'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed: () => Navigator.pop(
                                                                              context,
                                                                              'Annuler'),
                                                                          child:
                                                                              const Text('Annuler'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            _doSomething(_btnController);
                                                                            Navigator.pop(context);
                                                                            Get.snackbar(
                                                                              "Suppression",
                                                                              "La vidéo a été bien supprimée.",
                                                                              backgroundColor: Colors.grey,
                                                                              snackPosition: SnackPosition.BOTTOM,
                                                                              borderColor: Colors.grey,
                                                                              borderRadius: 10,
                                                                              borderWidth: 2,
                                                                              barBlur: 0,
                                                                              duration: Duration(seconds: 2),
                                                                            );
                                                                          },
                                                                          child:
                                                                              Text('OK'),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                },
                                                                child: Row(
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .delete_outline,
                                                                          color:
                                                                              Colors.red),
                                                                      Text(
                                                                          "Supprimer",
                                                                          style:
                                                                              TextStyle(color: Colors.red)),
                                                                    ]),
                                                              )),
                                                        ]))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                    ],
                                  )))
                        ],
                      )),
                  Divider(),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Text(
                                    "Pompe",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.centerRight,
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Row(children: [
                                          Text("Tout voir",
                                              style: TextStyle(
                                                  color: Colors.blue[400],
                                                  fontWeight: FontWeight.bold)),
                                          Icon(Icons.chevron_right_outlined,
                                              color: Colors.blue[400]),
                                        ])))
                              ]),
                          Container(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                    ],
                                  )))
                        ],
                      )),
                  Divider(),
                  Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.00,
                        left: MediaQuery.of(context).size.width * 0.02,
                      ),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  margin: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.04,
                                    bottom: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  child: Text(
                                    "Traction",
                                    style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[700]),
                                  ),
                                ),
                                Container(
                                    alignment: Alignment.centerRight,
                                    margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.02,
                                    ),
                                    child: TextButton(
                                        onPressed: () {},
                                        child: Row(children: [
                                          Text("Tout voir",
                                              style: TextStyle(
                                                  color: Colors.blue[400],
                                                  fontWeight: FontWeight.bold)),
                                          Icon(Icons.chevron_right_outlined,
                                              color: Colors.blue[400]),
                                        ])))
                              ]),
                          Container(
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                      Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.17,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.32,
                                              child: Card(
                                                  elevation: 1,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    child: Image.asset(
                                                        'assets/images/cover.jpg',
                                                        fit: BoxFit.cover),
                                                  )),
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.13,
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.18,
                                                ),
                                                child: PopupMenuButton(
                                                    icon: Icon(Icons.more_horiz,
                                                        color: Colors.white,
                                                        size: 18),
                                                    itemBuilder: (context) => [
                                                          PopupMenuItem(
                                                            value: 1,
                                                            child:
                                                                Row(children: [
                                                              Icon(Icons.edit),
                                                              Text("Modifier")
                                                            ]),
                                                          ),
                                                          PopupMenuItem(
                                                            value: 2,
                                                            child:
                                                                Row(children: [
                                                              Icon(
                                                                  Icons
                                                                      .delete_outline,
                                                                  color: Colors
                                                                      .red),
                                                              Text(
                                                                "Supprimer",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .red),
                                                              )
                                                            ]),
                                                          )
                                                        ])),
                                            Container(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: Colors.blue[400],
                                              size: 30,
                                            ))
                                          ]),
                                    ],
                                  )))
                        ],
                      )),
                ])
              ]),
            ),
            Container(
              child: ListView(children: [
                Column(children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.0,
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.32,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset('assets/images/cover.jpg',
                                  fit: BoxFit.cover),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.11,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.07),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.blue[400],
                            size: 40,
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.24,
                            left: MediaQuery.of(context).size.width * 0.82,
                          ),
                          child: PopupMenuButton(
                              color: Colors.white,
                              icon: Icon(Icons.more_horiz,
                                  color: Colors.white, size: 18),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          SimpleDialog(
                                                            title: Text(
                                                              "Modification d'une vidéo",
                                                            ),
                                                            children: [
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.06,
                                                                      vertical: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.0113),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Titre",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Module",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                    vertical: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.01),
                                                                child:
                                                                    RoundedLoadingButton(
                                                                  color: Colors
                                                                          .blue[
                                                                      400],
                                                                  successColor:
                                                                      Colors
                                                                          .blue,
                                                                  controller:
                                                                      _btnController,
                                                                  onPressed:
                                                                      () {
                                                                    _doSomething(
                                                                        _btnController);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Get.snackbar(
                                                                      "Modification",
                                                                      "La vidéo a été bien modifiée.",
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                      borderColor:
                                                                          Colors
                                                                              .grey,
                                                                      borderRadius:
                                                                          10,
                                                                      borderWidth:
                                                                          2,
                                                                      barBlur:
                                                                          0,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    );
                                                                  },
                                                                  valueColor:
                                                                      Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      90,
                                                                  child: Text(
                                                                      "ENREGISTRER",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          ));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.black),
                                                Text("Modifier",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ],
                                            ))),
                                    PopupMenuItem(
                                        value: 2,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    "Suppression d'une vidéo"),
                                                content: const Text(
                                                    'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Annuler'),
                                                    child:
                                                        const Text('Annuler'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Suppression",
                                                        "La vidéo a été bien supprimée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Row(children: [
                                            Icon(Icons.delete_outline,
                                                color: Colors.red),
                                            Text("Supprimer",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ]),
                                        )),
                                  ]))
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.00005,
                      left: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.002,
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/video_logo.jpg'),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                ),
                            child: Column(children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      // left: MediaQuery.of(context).size.width*0.001,
                                      // top: MediaQuery.of(context).size.height*0.01,
                                      ),
                                  child: Text('Comment avoir de la vitesse ?',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black))),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    // left: MediaQuery.of(context).size.width*0.001,
                                    ),
                                child: TextButton(
                                  onPressed: () {
                                    print("WLL");
                                  },
                                  child: Row(children: [
                                    Icon(Icons.message_outlined,
                                        color: Colors.grey),
                                    Text("10 commentaires",
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                  ]),
                                ),
                              )
                            ]),
                          ),
                        ]),
                  ),
                  Divider()
                ]),
                Column(children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.0,
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.32,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset('assets/images/cover.jpg',
                                  fit: BoxFit.cover),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.11,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.07),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.blue[400],
                            size: 40,
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.24,
                            left: MediaQuery.of(context).size.width * 0.82,
                          ),
                          child: PopupMenuButton(
                              color: Colors.white,
                              icon: Icon(Icons.more_horiz,
                                  color: Colors.white, size: 18),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          SimpleDialog(
                                                            title: Text(
                                                              "Modification d'une vidéo",
                                                            ),
                                                            children: [
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.06,
                                                                      vertical: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.0113),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Titre",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Module",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                    vertical: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.01),
                                                                child:
                                                                    RoundedLoadingButton(
                                                                  color: Colors
                                                                          .blue[
                                                                      400],
                                                                  successColor:
                                                                      Colors
                                                                          .blue,
                                                                  controller:
                                                                      _btnController,
                                                                  onPressed:
                                                                      () {
                                                                    _doSomething(
                                                                        _btnController);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Get.snackbar(
                                                                      "Modification",
                                                                      "La vidéo a été bien modifiée.",
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                      borderColor:
                                                                          Colors
                                                                              .grey,
                                                                      borderRadius:
                                                                          10,
                                                                      borderWidth:
                                                                          2,
                                                                      barBlur:
                                                                          0,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    );
                                                                  },
                                                                  valueColor:
                                                                      Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      90,
                                                                  child: Text(
                                                                      "ENREGISTRER",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          ));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.black),
                                                Text("Modifier",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ],
                                            ))),
                                    PopupMenuItem(
                                        value: 2,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    "Suppression d'une vidéo"),
                                                content: const Text(
                                                    'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Annuler'),
                                                    child:
                                                        const Text('Annuler'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Suppression",
                                                        "La vidéo a été bien supprimée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Row(children: [
                                            Icon(Icons.delete_outline,
                                                color: Colors.red),
                                            Text("Supprimer",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ]),
                                        )),
                                  ]))
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.00005,
                      left: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.002,
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/video_logo.jpg'),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                ),
                            child: Column(children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      // left: MediaQuery.of(context).size.width*0.001,
                                      // top: MediaQuery.of(context).size.height*0.01,
                                      ),
                                  child: Text('Comment avoir de la vitesse ?',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black))),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    // left: MediaQuery.of(context).size.width*0.001,
                                    ),
                                child: TextButton(
                                  onPressed: () {
                                    print("WLL");
                                  },
                                  child: Row(children: [
                                    Icon(Icons.message_outlined,
                                        color: Colors.grey),
                                    Text("10 commentaires",
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                  ]),
                                ),
                              )
                            ]),
                          ),
                        ]),
                  ),
                  Divider()
                ]),
                Column(children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.0,
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.32,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset('assets/images/cover.jpg',
                                  fit: BoxFit.cover),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.11,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.07),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.blue[400],
                            size: 40,
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.24,
                            left: MediaQuery.of(context).size.width * 0.82,
                          ),
                          child: PopupMenuButton(
                              color: Colors.white,
                              icon: Icon(Icons.more_horiz,
                                  color: Colors.white, size: 18),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          SimpleDialog(
                                                            title: Text(
                                                              "Modification d'une vidéo",
                                                            ),
                                                            children: [
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.06,
                                                                      vertical: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.0113),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Titre",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Module",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                    vertical: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.01),
                                                                child:
                                                                    RoundedLoadingButton(
                                                                  color: Colors
                                                                          .blue[
                                                                      400],
                                                                  successColor:
                                                                      Colors
                                                                          .blue,
                                                                  controller:
                                                                      _btnController,
                                                                  onPressed:
                                                                      () {
                                                                    _doSomething(
                                                                        _btnController);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Get.snackbar(
                                                                      "Modification",
                                                                      "La vidéo a été bien modifiée.",
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                      borderColor:
                                                                          Colors
                                                                              .grey,
                                                                      borderRadius:
                                                                          10,
                                                                      borderWidth:
                                                                          2,
                                                                      barBlur:
                                                                          0,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    );
                                                                  },
                                                                  valueColor:
                                                                      Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      90,
                                                                  child: Text(
                                                                      "ENREGISTRER",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          ));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.black),
                                                Text("Modifier",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ],
                                            ))),
                                    PopupMenuItem(
                                        value: 2,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    "Suppression d'une vidéo"),
                                                content: const Text(
                                                    'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Annuler'),
                                                    child:
                                                        const Text('Annuler'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Suppression",
                                                        "La vidéo a été bien supprimée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Row(children: [
                                            Icon(Icons.delete_outline,
                                                color: Colors.red),
                                            Text("Supprimer",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ]),
                                        )),
                                  ]))
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.00005,
                      left: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.002,
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/video_logo.jpg'),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                ),
                            child: Column(children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      // left: MediaQuery.of(context).size.width*0.001,
                                      // top: MediaQuery.of(context).size.height*0.01,
                                      ),
                                  child: Text('Comment avoir de la vitesse ?',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black))),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    // left: MediaQuery.of(context).size.width*0.001,
                                    ),
                                child: TextButton(
                                  onPressed: () {
                                    print("WLL");
                                  },
                                  child: Row(children: [
                                    Icon(Icons.message_outlined,
                                        color: Colors.grey),
                                    Text("10 commentaires",
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                  ]),
                                ),
                              )
                            ]),
                          ),
                        ]),
                  ),
                  Divider()
                ]),
                Column(children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.04,
                      left: MediaQuery.of(context).size.width * 0.0,
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.32,
                        width: MediaQuery.of(context).size.width * 1,
                        child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: Image.asset('assets/images/cover.jpg',
                                  fit: BoxFit.cover),
                            )),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.11,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.07),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.blue[400],
                            size: 40,
                          )),
                      Container(
                          margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.24,
                            left: MediaQuery.of(context).size.width * 0.82,
                          ),
                          child: PopupMenuButton(
                              color: Colors.white,
                              icon: Icon(Icons.more_horiz,
                                  color: Colors.white, size: 18),
                              itemBuilder: (context) => [
                                    PopupMenuItem(
                                        value: 1,
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          SimpleDialog(
                                                            title: Text(
                                                              "Modification d'une vidéo",
                                                            ),
                                                            children: [
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          MediaQuery.of(context).size.width *
                                                                              0.06,
                                                                      vertical: MediaQuery.of(context)
                                                                              .size
                                                                              .height *
                                                                          0.0113),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Titre",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                  height: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.08,
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                  ),
                                                                  child:
                                                                      TextField(
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .grey[800]),
                                                                    decoration:
                                                                        InputDecoration(
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .blue[50],
                                                                      border: OutlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      focusedBorder: UnderlineInputBorder(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              90.0)),
                                                                          borderSide:
                                                                              BorderSide.none),
                                                                      hintText:
                                                                          "Module",
                                                                      prefixIcon: Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue),
                                                                    ),
                                                                  )),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(
                                                                    horizontal: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.06,
                                                                    vertical: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.01),
                                                                child:
                                                                    RoundedLoadingButton(
                                                                  color: Colors
                                                                          .blue[
                                                                      400],
                                                                  successColor:
                                                                      Colors
                                                                          .blue,
                                                                  controller:
                                                                      _btnController,
                                                                  onPressed:
                                                                      () {
                                                                    _doSomething(
                                                                        _btnController);
                                                                    Navigator.pop(
                                                                        context);
                                                                    Get.snackbar(
                                                                      "Modification",
                                                                      "La vidéo a été bien modifiée.",
                                                                      backgroundColor:
                                                                          Colors
                                                                              .grey,
                                                                      snackPosition:
                                                                          SnackPosition
                                                                              .BOTTOM,
                                                                      borderColor:
                                                                          Colors
                                                                              .grey,
                                                                      borderRadius:
                                                                          10,
                                                                      borderWidth:
                                                                          2,
                                                                      barBlur:
                                                                          0,
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    );
                                                                  },
                                                                  valueColor:
                                                                      Colors
                                                                          .white,
                                                                  borderRadius:
                                                                      90,
                                                                  child: Text(
                                                                      "ENREGISTRER",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              ),
                                                            ],
                                                          ));
                                            },
                                            child: Row(
                                              children: [
                                                Icon(Icons.edit,
                                                    color: Colors.black),
                                                Text("Modifier",
                                                    style: TextStyle(
                                                        color: Colors.black)),
                                              ],
                                            ))),
                                    PopupMenuItem(
                                        value: 2,
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                title: const Text(
                                                    "Suppression d'une vidéo"),
                                                content: const Text(
                                                    'Voulez-vous vraiment supprimer cette vidéo ?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Annuler'),
                                                    child:
                                                        const Text('Annuler'),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      _doSomething(
                                                          _btnController);
                                                      Navigator.pop(context);
                                                      Get.snackbar(
                                                        "Suppression",
                                                        "La vidéo a été bien supprimée.",
                                                        backgroundColor:
                                                            Colors.grey,
                                                        snackPosition:
                                                            SnackPosition
                                                                .BOTTOM,
                                                        borderColor:
                                                            Colors.grey,
                                                        borderRadius: 10,
                                                        borderWidth: 2,
                                                        barBlur: 0,
                                                        duration: Duration(
                                                            seconds: 2),
                                                      );
                                                    },
                                                    child: Text('OK'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                          child: Row(children: [
                                            Icon(Icons.delete_outline,
                                                color: Colors.red),
                                            Text("Supprimer",
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ]),
                                        )),
                                  ]))
                    ]),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.00005,
                      left: MediaQuery.of(context).size.width * 0.02,
                    ),
                    child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(
                                left: MediaQuery.of(context).size.width * 0.002,
                              ),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    AssetImage('assets/images/video_logo.jpg'),
                              )),
                          Container(
                            margin: EdgeInsets.only(
                                // left: MediaQuery.of(context).size.width*0.001,
                                ),
                            child: Column(children: [
                              Container(
                                  margin: EdgeInsets.only(
                                      // left: MediaQuery.of(context).size.width*0.001,
                                      // top: MediaQuery.of(context).size.height*0.01,
                                      ),
                                  child: Text('Comment avoir de la vitesse ?',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.black))),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                    // left: MediaQuery.of(context).size.width*0.001,
                                    ),
                                child: TextButton(
                                  onPressed: () {
                                    print("WLL");
                                  },
                                  child: Row(children: [
                                    Icon(Icons.message_outlined,
                                        color: Colors.grey),
                                    Text("10 commentaires",
                                        style:
                                            TextStyle(color: Colors.grey[700])),
                                  ]),
                                ),
                              )
                            ]),
                          ),
                        ]),
                  ),
                  Divider()
                ])
              ]),
            ),
            Container(child: Icon(Icons.camera)),
            Container(child: Icon(Icons.camera)),
            Container(child: Icon(Icons.camera)),
          ]),
          floatingActionButton: userController.user.admin
              ? FloatingActionButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => SimpleDialog(
                              title: Text(
                                "Ajouter une vidéo",
                              ),
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.06,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.0113),
                                    child: TextField(
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[800]),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue[50],
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90.0)),
                                            borderSide: BorderSide.none),
                                        focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90.0)),
                                            borderSide: BorderSide.none),
                                        hintText: "Titre",
                                        prefixIcon: Icon(Icons.edit,
                                            color: Colors.blue),
                                      ),
                                    )),
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.08,
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      // vertical: MediaQuery.of(context).size.height*0.0110
                                    ),
                                    child: TextField(
                                      focusNode: _focus,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[800]),
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.blue[50],
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90.0)),
                                            borderSide: BorderSide.none),
                                        focusedBorder: UnderlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(90.0)),
                                            borderSide: BorderSide.none),
                                        hintText: "Video",
                                        prefixIcon: Icon(
                                            Icons.video_library_outlined,
                                            color: Colors.blue),
                                      ),
                                    )),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.09,
                                    // vertical: MediaQuery.of(context).size.height*0.0110,
                                  ),
                                  child: Row(children: [
                                    DropdownButton(
                                        icon:
                                            Icon(Icons.arrow_drop_down_circle),
                                        iconDisabledColor: Colors.blue[400],
                                        iconEnabledColor: Colors.blue[400],
                                        iconSize: 25,
                                        underline: SizedBox(),
                                        hint: Text('Module',
                                            style: TextStyle(fontSize: 14)),
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('Course'),
                                            value: 1,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Pompe'),
                                            value: 2,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('Traction'),
                                            value: 3,
                                          ),
                                        ],
                                        onChanged: (value) => print(value))
                                  ]),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    // vertical:MediaQuery.of(context).size.height*0.01
                                  ),
                                  child: RoundedLoadingButton(
                                    color: Colors.blue[400],
                                    successColor: Colors.blue,
                                    controller: _btnController,
                                    onPressed: () {
                                      _doSomething(_btnController);
                                      Navigator.pop(context);
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
                                    },
                                    valueColor: Colors.white,
                                    borderRadius: 90,
                                    child: Text("AJOUTER",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ));
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.blue,
                  elevation: 10,
                )
              : null,
        ));
  }

  Widget menu() {
    return Container(
      color: Colors.black12,
      child: TabBar(
        isScrollable: true,
        unselectedLabelColor: Colors.grey[800],
        labelColor: Colors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Colors.blue,
        tabs: [
          Tab(
            text: "Tous",
            icon: Icon(Icons.video_library_outlined, size: 20),
          ),
          Tab(
            text: "Course",
            icon: Icon(Icons.camera, size: 20),
          ),
          Tab(
            text: "Pompe",
            icon: Icon(Icons.camera, size: 20),
          ),
          Tab(
            text: "Traction",
            icon: Icon(Icons.camera, size: 20),
          ),
          Tab(
            text: "Musculation",
            icon: Icon(Icons.camera, size: 20),
          ),
        ],
      ),
    );
  }
}
