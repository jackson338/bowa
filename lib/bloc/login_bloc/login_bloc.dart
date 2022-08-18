part of 'login.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(const LoginState()) {
    init();
  }

  void init() async {}

  void name(name) {
    emit(state.copyWith(name: name));
  }

  void password(password) {
    emit(state.copyWith(password: password));
  }

  void login(String username, String password, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> accountInfo = [];
    if (prefs.getStringList('$username Account Info') != null) {
      accountInfo = prefs.getStringList('$username Account Info')!;
    }
    if (accountInfo.isNotEmpty) {
      accountInfo.forEach((element) => print(element),);
      emit(state.copyWith(
        name: accountInfo[0],
        authorName: accountInfo[1],
        email: accountInfo[2],
        password: accountInfo[3],
      ));
    }
    if (username == state.authorName && password == state.password) {
      emit(state.copyWith(loggedIn: true));
      Navigator.of(context).pop();
    }
  }

  void switchAutoLogin(bool val) {
    emit(state.copyWith(autoLogin: val));
  }

  void accountCreated() {
    emit(state.copyWith(loggedIn: true));
  }
}
