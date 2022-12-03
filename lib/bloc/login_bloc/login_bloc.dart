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

  void updateUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> newInfo = [
      username,
      state.user!.authorName,
      state.user!.email,
      state.user!.password,
    ];
    final User newUser = state.user!.copyWith(username: username);
    prefs.remove('${state.user!.authorName} user');
    prefs.remove('${state.user!.authorName} Account Info');
    emit(state.copyWith(user: newUser));
    prefs.setStringList('${state.user!.authorName} Account Info', newInfo);
    prefs.setStringList('auto login', newInfo);
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.authorName} user', jsonString);
  }

  void updateAuthor(String authorName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> newInfo = [
      state.user!.username,
      authorName,
      state.user!.email,
      state.user!.password,
    ];
    final newUser = state.user!.copyWith(authorName: authorName);
    prefs.remove('${state.user!.authorName} user');
    prefs.remove('${state.user!.authorName} Account Info');
    emit(state.copyWith(user: newUser));
    prefs.setStringList('${state.user!.authorName} Account Info', newInfo);
    prefs.setStringList('auto login', newInfo);
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.authorName} user', jsonString);
  }

  void updateEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> newInfo = [
      state.user!.username,
      state.user!.authorName,
      email,
      state.user!.password,
    ];
    final newUser = state.user!.copyWith(email: email);
    prefs.remove('${state.user!.authorName} user');
    prefs.remove('${state.user!.authorName} Account Info');
    emit(state.copyWith(user: newUser));
    prefs.setStringList('${state.user!.authorName} Account Info', newInfo);
    prefs.setStringList('auto login', newInfo);
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.authorName} user', jsonString);
  }

  void updatePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> newInfo = [
      state.user!.username,
      state.user!.authorName,
      state.user!.email,
      password
    ];
    final newUser = state.user!.copyWith(password: password);
    prefs.remove('${state.user!.authorName} user');
    prefs.remove('${state.user!.authorName} Account Info');
    emit(state.copyWith(user: newUser));
    prefs.setStringList('${state.user!.authorName} Account Info', newInfo);
    prefs.setStringList('auto login', newInfo);
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.authorName} user', jsonString);
  }

  void name(name) {
    emit(state.copyWith(name: name));
  }

  void password(password) async {
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

  void accountCreated(List accountInfo) async {
    User? user = await createUserObject(accountInfo, state.autoLogin);
    emit(state.copyWith(loggedIn: true, user: user));
  }

  void updateLibrary(User newUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(state.copyWith(user: newUser));
    final jsonString = jsonEncode(state.user!.toJson());
    prefs.setString('${state.user!.authorName} user', jsonString);
  }
}
