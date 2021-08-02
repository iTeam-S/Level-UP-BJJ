import 'package:bjj_library/controller/data.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

const String BaseUrl = "iteam-s.mg:4444";
const String BaseUrlProtocol = 'http://' + BaseUrl;

class ApiController extends GetxController {
  var client = dio.Dio(dio.BaseOptions(baseUrl: "$BaseUrlProtocol"));
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
        return [false, err.response!.data['status']];
      } else {
        return [false, err.response!.data['status']];
      }
    } catch (e) {
      print(e);
      return [false, "Verifier Votre Réseau"];
    }
  }

  Future<List> createmodule(int userid, String token, String module) async {
    try {
      var response = await client.post(
        "/api/v1/create_module/",
        data: {"user_id": userid, "token": token, "nom": module},
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
      String videopath) async {
    try {
      List filetmp = videopath.split('/');
      String filename = filetmp[filetmp.length - 1];
      var formData = dio.FormData.fromMap({
        'user_id': userid,
        'token': token,
        'module_id': moduleid,
        'titre_video': titre,
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
}
