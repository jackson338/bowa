import 'package:bowa/models/book.dart';

class User {
 final String username;
 final String authorName;
 final String email;
 final String password;
 final String id;
 final bool autoLogin;
 final List<Book>? library;
 const User({
    required this.username,
    required this.authorName,
    required this.email,
    required this.password,
    required this.id,
    required this.autoLogin,
    this.library,
  });

 const User.empty({
    this.username = '',
    this.authorName = '',
    this.email = '',
    this.password = '',
    this.autoLogin = false,
    this.id = '',
    this.library = const [],
  });

  User copyWith({
    String? username,
    String? authorName,
    String? email,
    String? password,
    String? id,
    bool? autoLogin,
    List<Book>? library,
  }) {
    return User(
        username: username ?? this.username,
        authorName: authorName ?? this.authorName,
        email: email ?? this.email,
        password: password ?? this.password,
        id: id ?? this.id,
        autoLogin: autoLogin ?? this.autoLogin);
  }
}
