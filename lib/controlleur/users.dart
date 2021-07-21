import 'package:bjj_library/model/users.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class UserController extends GetxController {
  var user = User(email: '').obs;
}
