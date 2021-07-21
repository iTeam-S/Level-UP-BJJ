class User {
  final int id;
  final String email;
  String token;
  final bool admin;

  User({this.id: 0, required this.email, this.token: '', this.admin: false});
}
