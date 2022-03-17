// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:bjj_library/controller/app.dart';
import 'package:bjj_library/controller/users.dart';
import 'package:bjj_library/model/users.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

Color primaire = Colors.lightBlue.shade800;
Color background = Colors.lightBlue.shade100;

class Sondage extends StatefulWidget {
  const Sondage({
    Key? key,
  }) : super(key: key);

  @override
  State<Sondage> createState() => _SondageState();
}

class _SondageState extends State<Sondage> {

  UserController userController = Get.put(UserController());
  AppController appController = Get.put(AppController());
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  // liste des choix de sondage à creer
  List<ListTile> sondageActu = <ListTile>[];
  

  @override
  void initState() {
    super.initState();
    appController.getPosts(userController.user);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text("Annonces"),
        backgroundColor: primaire,
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              userController.user.admin ? 
              Container(
                width: Get.width,
                height: 70,
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Ajouter une publication ?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    /*SizedBox(
                      width: 45,
                      child: MaterialButton(
                        onPressed: () {},
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        child: Icon(Icons.add),
                      ),
                    )*/
                    InkWell(
                      onTap: () {
                         showDialog(
        context: context,
        builder: (context) {
          return 
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Créer un sondage',
                    style: TextStyle(color: primaire),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      )),
                ],
              ),
              children: [
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(onPressed: (){ addContent(context); }, child: Text('Annonces', style: TextStyle(fontSize: 21),)),
                      TextButton(onPressed: (){ sondage(); }, child: Text('Sondage', style: TextStyle(fontSize: 21),)),
                    ],)
              ],
            ),
          );
        });
 
                      },
                      child: Container(
                        width: 45,
                        height: 60,
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: primaire,
                            borderRadius: BorderRadius.circular(7)),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              )
              : Divider(),

              Container(
                width: Get.width,
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              ),
              SizedBox(
                width: Get.width,
                height: Get.height * .8,
                child: GetBuilder<AppController>(
                  builder: (_) {
                    return 
                    ListView(
                        children: [ 
                            for (var actualite in appController.actualite)
                            Container(
                                  width: Get.width,
                                  margin:
                                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                            offset: Offset(2, 3))
                                      ],
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: userController.user.admin 
                                        ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: primaire,
                                          child: Text(actualite['user_mail'][0].toUpperCase()),
                                          radius: 25,
                                        ),
                                        if ( !userController.user.admin )
                                          SizedBox(
                                            width: 15,
                                          ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(actualite['user_mail'],
                                                style: TextStyle(fontSize: 25)),
                                            Text("${actualite['date_pub']}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black45)),
                                          ],
                                        ),
                                        if (userController.user.admin)
                                          IconButton(
                                            onPressed: (){
                                              for (int i=0; i<appController.actualite.length; i++)
                                                if (appController.actualite[i]['actu_id'] == actualite['actu_id']){
                                                  appController.actualite.removeAt(i);
                                                }
                                              appController.update();
                                              appController.deletePost(userController.user, actualite['actu_id']);
                                            
                                            },
                                            icon: Icon(Icons.delete_outline_outlined)
                                          )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(actualite['text'],
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.justify,
                                              maxLines: 6,
                                              style: TextStyle(fontSize: 18)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          if (actualite['data'].length != 0) 
                                            Container(
                                              height: 150,
                                              width: Get.width,
                                              child: ListView(
                                                scrollDirection: Axis.vertical,
                                                children: [
                                                  for (var sond in actualite['data'])
                                                  Container(
                                                      margin: EdgeInsets.symmetric(vertical: 1),
                                                      width: Get.width,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          RichText(
                                                            text: TextSpan(
                                                              text: sond['sondage'],
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.normal,
                                                                ),
                                                              children:[
                                                               WidgetSpan(
                                                                  child: Transform.translate(
                                                                    offset: const Offset(0.0, -8.0),
                                                                    child: Text(
                                                                      ' +${sond['users'].length}',
                                                                      style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          IconButton(
                                                          iconSize: 16,
                                                            onPressed: () {
                                                              setSondage(actualite['actu_id'], sond['sondage_id'], !verifSondage(sond, userController.user));
                                                            },
                                                            icon: Icon(
                                                              verifSondage(sond, userController.user)
                                                              ? Icons.check_box
                                                              : Icons.check_box_outline_blank
                                                            ),
                                                            color: primaire,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                          ]
                      );
                  }
                ),
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  bool verifSondage(var sondage, User user){
    bool res = false; 
    for (var usr in sondage['users'])
      if (usr['user_id'] == user.id)
        res = true;
    return res;
  }

                                                              
  void setSondage(int actu, int sondage, bool value){
    for (int i=0; i<appController.actualite.length; i++)
      if (appController.actualite[i]['actu_id'] == actu)
        for (int j=0; j<appController.actualite[i]['data'].length; j++)
          if (appController.actualite[i]['data'][j]['sondage_id'] == sondage)
            if (value){
              // suprression des autres choix
              for (int jj=0; jj<appController.actualite[i]['data'].length; jj++)
                for (int kk=0; kk<appController.actualite[i]['data'][jj]['users'].length; kk++)
                  if (appController.actualite[i]['data'][jj]['users'][kk]['user_id'] == userController.user.id)
                  appController.actualite[i]['data'][jj]['users'].removeAt(kk);
              // ajout du nouveau choix
              appController.actualite[i]['data'][j]['users'].add({'user_id': userController.user.id, 'user_mail': userController.user.email});
            }
            else
              for (int k=0; k<appController.actualite[i]['data'][j]['users'].length; k++)
                if (appController.actualite[i]['data'][j]['users'][k]['user_id'] == userController.user.id)
                  appController.actualite[i]['data'][j]['users'].removeAt(k);
    appController.update();
    if (value)
      appController.voteSondage(userController.user, sondage);
    else
      appController.unVoteSondage(userController.user, sondage);
  }

  void addContent(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            children: [
              Form(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //height: 50,
                      width: Get.width * .8,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 2,
                            color: primaire,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: appController.textActu,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: "Texte",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),

                    /**------------------------------ */
                   RoundedLoadingButton(
                      color: Colors.lightBlue[800],
                      successColor: Colors.blue,
                      controller: _btnController,
                      onPressed: () {
                        void _trt(RoundedLoadingButtonController controller) async{
                          await appController.createPost(
                            userController.user,
                            {
                              'text': appController.textActu.text,
                              'type': 'texte',
                              'data': []
                            }
                          );
                          controller.reset();
                          Get.back();
                          Get.back();
                        }
                        _trt(_btnController);
                      },
                      valueColor: Colors.white,
                      borderRadius: 90,
                      child: Text("Publier",
                          style: TextStyle(
                              color: Colors.white)),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  void sondage() {
    showDialog(
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Créer un sondage',
                    style: TextStyle(color: primaire),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.redAccent,
                      )),
                ],
              ),
              children: [
                Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      //height: 50,
                      width: Get.width * .5,
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2,
                            color: primaire,
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                hintText: " Titre",
                                hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(.5),
                                ),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                SingleChildScrollView(
                  child: Column(
                    children: sondageActu 
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFD3D3D3),
                          borderRadius: BorderRadius.circular(7)),
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      width: Get.width * .5,
                      height: 35,
                      child: TextField(
                        controller: appController.sondageChoix,
                        decoration: InputDecoration.collapsed(
                          // border: InputBorder.none,
                          hintText: 'choix ${sondageActu.length+1}',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        final int index = sondageActu.length;
                        setState(() {
                            sondageActu.add(
                              ListTile(
                                leading: Icon(
                                  Icons.add,
                                  color: Colors.orange,
                                ),
                                title: Text(
                                  appController.sondageChoix.text,
                                  style: TextStyle(color: Colors.black),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete,
                                    color: Colors.red
                                  ),
                                  onPressed: (){
                                    
                                    setState(() {
                                      sondageActu.removeAt(sondageActu.length - index);
                                      Get.back();
                                      sondage();
                                    });
                                  },
                                ),
                              )
                          );
                          Get.back();
                          sondage();
                          appController.sondageChoix.text = '';
                        });
                      },
                      icon: Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
