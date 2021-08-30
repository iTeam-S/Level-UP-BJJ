import 'package:bjj_library/model/video.dart';

class Module {
  final int id;
  String nom;
  List<Video> videos = <Video>[];

  Module({required this.id, required this.nom});
}
