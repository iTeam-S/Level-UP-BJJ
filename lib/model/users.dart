class User {
  final int id;
  String email;
  String token;
  final bool admin;
  Map video = {'id': 0, 'pos': Duration()};

  User(
      {required this.id,
      required this.email,
      required this.token,
      required this.admin});

  Duration getPos() {
    print("OITY ARK AI: ${video['pos']}");
    return video['pos'];
  }
}
