part of 'login.dart';

class LoginState {
  final bool autoLogin;
  final bool loggedIn;
  final bool loading;
  final String name;
  final String authorName;
  final String email;
  final String password;
  final int index;

  const LoginState({
    this.autoLogin = true,
    this.loggedIn = false,
    this.loading = false,
    this.name = '',
    this.authorName = '',
    this.email = '',
    this.password = '',
    this.index = 0,
  });

  LoginState copyWith({
    final bool? autoLogin,
    final bool? loggedIn,
    final bool? loading,
    final String? name,
    final String? authorName,
    final String? email,
    final String? password,
    final int? index,
  }) {
    return LoginState(
      autoLogin: autoLogin ?? this.autoLogin,
      loggedIn: loggedIn ?? this.loggedIn,
      loading: loading ?? this.loading,
      name: name ?? this.name,
      authorName: authorName ?? this.authorName,
      email: email ?? this.email,
      password: password ?? this.password,
      index: index ?? this.index,
    );
  }
}
