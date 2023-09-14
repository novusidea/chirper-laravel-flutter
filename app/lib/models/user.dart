class User {
  String name;
  String email;

  User({
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      name: responseData['name'],
      email: responseData['email'],
    );
  }
}
