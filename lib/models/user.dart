import 'package:bowa/models/book.dart';

class User {
  final String username;
  final String authorName;
  final String email;
  final String password;
  final bool autoLogin;
  final List<Book>? library;
  User({
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
}
