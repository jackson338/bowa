part of 'login.dart';

class LoginState {
  final bool autoLogin;
  final bool loggedIn;
  final String name;
  final String authorName;
  final String email;
  final String password;
  final int index;

  const LoginState({
    this.autoLogin = false,
    this.loggedIn = true,
    this.name = '',
    this.authorName = '',
    this.email = '',
    this.password = '',
    this.index = 0,
  });

  LoginState copyWith({
    final bool? autoLogin,
    final bool? loggedIn,
    final String? name,
    final String? authorName,
    final String? email,
    final String? password,
    final int? index,
  }) {
    return LoginState(
      autoLogin: autoLogin ?? this.autoLogin,
      loggedIn: loggedIn ?? this.loggedIn,
      name: name ?? this.name,
      authorName: authorName ?? this.authorName,
      email: email ?? this.email,
      password: password ?? this.password,
      index: index ?? this.index,
    );
  }
}
