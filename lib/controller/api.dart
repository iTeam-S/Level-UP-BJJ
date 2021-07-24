import 'package:dio/dio.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ApiController extends GetxController {
  var client = Dio(BaseOptions(baseUrl: "http://192.168.137.71:4444"));

  Future<List> login(usr, passwd) async {
    try {
      var response = await client.post(
        "/api/v1/login/",
        data: {"mail": usr, "password": passwd},
      );
      return [true, response.data];
    } on DioError catch (err) {
      if (err.response!.statusCode == 403) {
        return [false, err.response!.data['status']];
      } else {
        return [false, err.message];
      }
    } catch (e) {
      return [false, "Verifier Votre Réseau"];
    }
  }
}
