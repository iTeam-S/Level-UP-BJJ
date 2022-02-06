import 'package:bjj_library/model/commentaire.dart';

class Video {
  final int id;
  final String titre;
  final String nom;
  final String image;
  List<Commentaire> commentaire = <Commentaire>[];
  final int niveau;

  Video(
      {required this.id,
      required this.nom,
      required this.titre,
      required this.image,
      this.commentaire: const <Commentaire>[],
      this.niveau: 1 });

}
