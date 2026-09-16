class UserModel {
  final String username;
  final String email;

  UserModel({
    required this.username,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : username = map['username'] ?? '',
        email = map['email'] ?? '';
}