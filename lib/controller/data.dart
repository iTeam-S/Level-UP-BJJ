import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';

class DataController extends GetxController {
  double uploadPourcent = 0.0;
  String moduleChoix = 'Tous';
  String videopath = '';
  TextEditingController videotitle = TextEditingController();
  TextEditingController titre = TextEditingController();
  void forceUpdate() {
    update();
  }
}
