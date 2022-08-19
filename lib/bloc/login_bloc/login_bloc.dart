part of 'login.dart';

class LoginBloc extends Cubit<LoginState> {
  LoginBloc() : super(const LoginState()) {
    init();
  }

  void init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List autoLoginInfo = [];
    if (prefs.getStringList('auto login') != null) {
      autoLoginInfo = prefs.getStringList('auto login')!;
    }
    if (autoLoginInfo.isNotEmpty) {
      autoLoginInfo.forEach(
        (element) => print(element),
      );
      emit(state.copyWith(
        name: autoLoginInfo[0],
        authorName: autoLoginInfo[1],
        email: autoLoginInfo[2],
        password: autoLoginInfo[3],
        loggedIn: true,
      ));
    }
  }

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
      print('made it');
      accountInfo = prefs.getStringList('$username Account Info')!;
    }
    if (accountInfo.isNotEmpty) {
      accountInfo.forEach(
        (element) => print(element),
      );
      emit(state.copyWith(
        name: accountInfo[0],
        authorName: accountInfo[1],
        email: accountInfo[2],
        password: accountInfo[3],
      ));
    }
    if (username == state.authorName && password == state.password) {
      if (state.autoLogin == true) {
        prefs.setStringList('auto login', accountInfo);
      } else {
        prefs.setStringList('auto login', []);
      }
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
