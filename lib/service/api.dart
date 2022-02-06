import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bjj_library/controller/data.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';

// String baseUrl = dotenv.env['API_URL']!; 
String baseUrlProtocol =  dotenv.env['API_URL']!;

class ApiController extends GetxController {
  var client = dio.Dio(dio.BaseOptions(
      baseUrl: "$baseUrlProtocol",
      sendTimeout: 300000,
      receiveTimeout: 30000,
      connectTimeout: 30000));
  UploadVideoDataController dataController =
      Get.put(UploadVideoDataController());

  Future<List> login(usr, passwd) async {
    try {
      var response = await client.post(
        "/api/v1/login/",
        data: {"mail": usr, "password": passwd},
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.message];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> getmodules(int userid, String token) async {
    try {
      var response = await client.post(
        "/api/v1/get_all_modules/",
        data: {"user_id": userid, "token": token},
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.message];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> getvideos(int userid, String token) async {
    try {
      var response = await client.post(
        "/api/v1/get_videos/",
        data: {"user_id": userid, "token": token},
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        Timer(Duration(seconds: 2), () {
          // Session expiré ==> reconnexion
          Get.offNamed('/login');
        });
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> createmodule(
      int userid, String token, String module, String coverpath) async {
    try {
      List filetmp = coverpath.split('/');
      String filename = filetmp[filetmp.length - 1];
      var formData = dio.FormData.fromMap({
        'user_id': userid,
        'token': token,
        'nom': module,
        'file': await dio.MultipartFile.fromFile(coverpath, filename: filename),
      });
      var response = await client.post(
        '/api/v2/create_module/',
        data: formData,
        onSendProgress: (int sent, int total) {
          dataController.uploadCover = sent / total;
          dataController.update();
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> uploadVideo(int userid, String token, int moduleid, String titre,
      String videopath, String niveau) async {
    try {
      List filetmp = videopath.split('/');
      String filename = filetmp[filetmp.length - 1];
      var formData = dio.FormData.fromMap({
        'user_id': userid,
        'token': token,
        'module_id': moduleid,
        'titre_video': titre,
        'niveau': niveau,
        'file': await dio.MultipartFile.fromFile(videopath, filename: filename),
      });
      var response = await client.post(
        '/api/v1/upload_video/',
        data: formData,
        onSendProgress: (int sent, int total) {
          dataController.uploadPourcent = sent / total;
          dataController.forceUpdate();
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> deletevideo(int userid, String token, int id) async {
    try {
      var response = await client.post(
        "/api/v1/delete_video/",
        data: {"user_id": userid, "token": token, "video_id": id},
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> deletemodule(int userid, String token, int moduleId) async {
    try {
      var response = await client.delete(
        "/api/v1/delete_module/",
        data: {"user_id": userid, "token": token, "module_id": moduleId},
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> updatemodule(
      int userid, String token, int moduleId, String nom) async {
    try {
      var response = await client.post(
        "/api/v1/update_module/",
        data: {
          "user_id": userid,
          "token": token,
          "module_id": moduleId,
          "nom": nom
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print("--: $e");
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> comment(
      int userid, String token, String text, int videoid) async {
    try {
      var response = await client.post(
        "/api/v1/comment/",
        data: {
          "user_id": userid,
          "token": token,
          "video_id": videoid,
          "text": text
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print("--: $e");
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> getnotifs(int userid, String token) async {
    try {
      var response = await client.post(
        "/api/v1/get_notifications/",
        data: {"user_id": userid, "token": token},
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Impossible d'afficher les notifications"];
    }
  }

  Future<List> viewnotif(int userid, String token, int comID) async {
    try {
      var response = await client.post(
        "/api/v1/notif_view/",
        data: {
          "user_id": userid,
          "token": token,
          "com_id": comID,
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List> checkmail(String mail) async {
    try {
      var response = await client.post(
        "/api/v1/check_mail",
        data: {
          "mail": mail,
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List> createaccount(String mail, String password, String payementId) async {
    try {
      var response = await client.post(
        "/api/v1/create_account",
        data: {
          "mail": mail,
          "password": password,
          "payement_id": payementId,
          "token": dotenv.env['TOKEN_PAYEMENT']!
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      return [false, err.response!.data['status']];
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List> upgradeAccount(int userid, String token, String payemntID) async {
    try {
      var response = await client.post(
        "/api/v1/upgrade",
        data: {
          "user_id": userid,
          "payement_id": payemntID,
          "token": token
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      return [false, err.response!.data['status']];
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List> verifexp(int userid, String token) async{
     try {
      var response = await client.post(
        "/api/v1/verif_expiration",
        data: {
          "user_id": userid,
          "token": token
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      return [false, err.response!.data['status']];
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List> changePassword(String oldPass, String newPass, int userid, String token) async{
     try {
      var response = await client.post(
        "/api/v1/change_password",
        data: {
          "old_password": oldPass,
          "new_password": newPass,
          "user_id": userid,
          "token": token
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      return [false, err.response!.data['status']];
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List> sendCode(String mail) async {
    try {
      var response = await client.post(
        "/api/v1/forgot_password/",
        data: {
          "mail": mail
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      return [false, err.response!.data['status']];
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }

  Future<List>verifCode(String mail, String code) async {
    try {
      var response = await client.post(
        "/api/v1/verif_code/",
        data: {
          "code": code,
          "mail": mail
        },
      );
      return [true, response.data];
    } on dio.DioError catch (err) {
      return [false, err.response!.data['status']];
    } catch (e) {
      print("--: $e");
      return [false, "..."];
    }
  }


}
