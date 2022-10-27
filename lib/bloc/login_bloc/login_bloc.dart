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
      User? user = await createUserObject(autoLoginInfo, state.autoLogin);
      emit(state.copyWith(
        name: autoLoginInfo[0],
        authorName: autoLoginInfo[1],
        email: autoLoginInfo[2],
        password: autoLoginInfo[3],
        loggedIn: true,
        user: user,
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
    final nav = Navigator.of(context);
    final contx = ScaffoldMessenger.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> accountInfo = [];
    if (prefs.getStringList('$username Account Info') != null) {
      accountInfo = prefs.getStringList('$username Account Info')!;
    }
    if (accountInfo.isNotEmpty) {
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
      User? user = await createUserObject(accountInfo, state.autoLogin);
      emit(state.copyWith(loggedIn: true, user: user));
      nav.pop();
    } else {
      contx.showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        // clipBehavior: Clip.antiAlias,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        duration: Duration(seconds: 1),
        margin: EdgeInsets.all(10.0),
        elevation: 3,
        content: Text('Incorrect Login'),
      ));
    }
  }

  void loading(bool loading) {
    emit(state.copyWith(loading: loading));
  }

  void switchAutoLogin(bool val) {
    emit(state.copyWith(autoLogin: val));
  }

  void accountCreated() {
    emit(state.copyWith(loggedIn: true));
  }
}
