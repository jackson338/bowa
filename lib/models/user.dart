import 'package:bowa/models/book.dart';

class User {
 final String username;
 final String authorName;
 final String email;
 final String password;
 final bool autoLogin;
 final List<Book>? library;
 const User({
    required this.username,
    required this.authorName,
    required this.email,
    required this.password,
    required this.autoLogin,
    this.library,
  });

 const User.empty({
    this.username = '',
    this.authorName = '',
    this.email = '',
    this.password = '',
    this.autoLogin = false,
    this.library = const [],
  });

  User copyWith({
    String? username,
    String? authorName,
    String? email,
    String? password,
    bool? autoLogin,
    List<Book>? library,
  }) {
    return User(
        username: username ?? this.username,
        authorName: authorName ?? this.authorName,
        email: email ?? this.email,
        password: password ?? this.password,
        autoLogin: autoLogin ?? this.autoLogin);
  }
}
