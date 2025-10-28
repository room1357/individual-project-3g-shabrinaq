class User {
  final String username;
  final String password;
  final String email;
  final String fullName;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
  });

  Map<String, dynamic> toMap() => {
        'username': username,
        'password': password,
        'email': email,
        'fullName': fullName,
      };

  factory User.fromMap(Map<String, dynamic> map) => User(
        username: map['username'],
        password: map['password'],
        email: map['email'],
        fullName: map['fullName'],
      );
}