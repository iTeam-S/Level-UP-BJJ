class User {
  final int id;
  String email;
  String token;
  final bool admin;

  User(
      {required this.id,
      required this.email,
      required this.token,
      required this.admin});
}
